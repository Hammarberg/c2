/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "cmdi.h"

#include <cstdint>
#include <cstddef>
#include <initializer_list>
#include <functional>
#include <cmath>

#define c2_verbose(...) c2_log(c2_eloglevel::verbose, __FILE__, __LINE__, __VA_ARGS__);
#define c2_info(...) c2_log(c2_eloglevel::info, __FILE__, __LINE__, __VA_ARGS__);
#define c2_warning(...) c2_log(c2_eloglevel::warning, __FILE__, __LINE__, __VA_ARGS__);
#define c2_error(...) c2_log(c2_eloglevel::error, __FILE__, __LINE__, __VA_ARGS__);

class c2i
{
public:
	typedef int64_t cint;

	class c2_corg
	{
	public:
		cint operator=(c2_corg &o);
		cint operator=(cint n);
		cint operator=(std::initializer_list<cint> elements);
		operator cint() const;
		void backup(cint &a, cint &w);
		void restore(cint a, cint w);
		cint orga = 0, orgw = 0;
	}c2_org;
	
	class c2_vardata
	{
	public:
		c2_vardata(cint in=0, int8_t ib=0);
		virtual ~c2_vardata();
		size_t size() const { return c2vc; }
		void reset(cint in=0);
		void set(cint n) { setat(0, n); }
		cint setat(size_t index, cint n);
		cint get() const;
		cint &getat(size_t index);

		uint8_t bits() const;
		void ensure(size_t size);
		void copy(const c2_vardata &o);
		void invalidate_bits() {	c2vb = 0; }
	private:
		void internal_clear();
		cint update_bits(cint n) const;

		static uint8_t calc_bits(cint n);

		union
		{
			cint c2vn;		//Value
			cint *c2vp;		//Or pointer to values
		}c2vv;

		size_t c2va = 0;		//Allocated elements
		size_t c2vc = 1;		//Number of values, 1 minimum
		mutable uint8_t c2vb = 0;	//Highest number of bits needed by any value stored
	};

	struct c2_slabel
	{
		c2_slabel(const char *inname, int inmode)
		:name(inname),mode(inmode){}
		const char *name;
		int mode;
	};

	template<typename T>
	class c2_basevar : public T, protected c2_vardata
	{
	template<typename U> friend class c2_basevar;
	friend c2i;
	public:
		c2_basevar() {}
		c2_basevar(const c2_slabel &o) { c2_get_single()->c2_register_var(o.name, nullptr, o.mode, this); }
		template<typename I> c2_basevar(const c2_basevar<I> &o) { copy(o); }
		c2_basevar(const c2_basevar &o) { copy(o); }
		c2_basevar(cint n, uint8_t ib = 0) : c2_vardata(n, ib) {}
		c2_basevar(int n) : c2_vardata(n) {}
		c2_basevar(const c2_corg &o) : c2_vardata(o.orga) {}
		
		c2_basevar(std::initializer_list<c2_basevar> elements)
		{
			const size_t count = elements.size();
			ensure(count);
			size_t r = 0;
			for(auto i = elements.begin(); i != elements.end(); i++, r++)
				setat(r, i->get());
		}
		
		c2_basevar(const char *pstr)
		{
			if(pstr)
			{
				const size_t count = c2i::c2_strlen(pstr);
				ensure(count);
				for(size_t r=0; r<count; r++)
					setat(r, pstr[r]);
			}
		}
		
		virtual ~c2_basevar(){if(c2vs){ c2i::c2_free(c2vs);}}
		
		template<typename I> c2_basevar &operator=(const c2_basevar<I> &o) { copy(o); return *this; }

		c2_basevar& operator=(const c2_basevar &o) { copy(o); return *this; }
		c2_basevar &operator=(cint n) { set(n); return *this; }
		c2_basevar &operator=(const c2_corg &o) { set(o.orga); return *this; }
		
		cint &operator[](size_t n) { invalidate_bits(); return getat(n); }
		operator cint&() { invalidate_bits(); return getat(0); }
		cint getatlix(size_t n) { return getat((n >= 0 && n < size()) ? n : 0); }
		
		const char *str()
		{
			c2vs = (char *)c2i::c2_realloc(c2vs, size() + 1);
			char *p = c2vs;
			
			for(size_t r=0; r<size(); r++, p++)
				*p = char(getat(r));
			
			*p = 0;
			
			return c2vs;
		}
		
		int value() { return get(); }
		size_t size() const { return c2_vardata::size(); }
		uint8_t bits() const { return c2_vardata::bits(); }

	private:
		/*
		template<typename I> void copy(const c2_basevar<I> &o)
		{
			if(!o.c2va)
			{
				c2va = o.c2va;
				c2vb = o.c2vb;
				c2vc = o.c2vc;
				c2vv.c2vn = o.c2vv.c2vn;
			}
			else
			{
				c2vc = c2va = o.c2vc;
				c2vb = o.c2vb;
				c2vv.c2vp = (cint *)c2i::c2_malloc(sizeof(cint[c2vc]));
				c2i::c2_memcpy(c2vv.c2vp, o.c2vv.c2vp, sizeof(cint[c2vc]));
			}
		}
		*/
		
		static bool inrange(int bits, cint n){return n < (1LL<<bits) && n >= 0-(1LL<<(bits-1));}

		mutable char *c2vs = nullptr;	//Holds temporary string buffer
	};
	
	struct c2_void{};

	typedef c2_basevar<c2_void> var;

	template<typename U> friend class c2_basevar;
	
	c2i(cmdi *pcmd);
	virtual ~c2i();

	virtual bool c2_assemble();
	
	virtual void c2_pre();
	virtual void c2_reset_pass();
	virtual void c2_pass() = 0;
	virtual void c2_post();

	virtual void push8(cint b, bool isaddr = false);
	virtual void push16le(cint b, bool isaddr = false);
	virtual void push16be(cint b, bool isaddr = false);
	virtual void push32le(cint b, bool isaddr = false);
	virtual void push32be(cint b, bool isaddr = false);
	virtual void push64le(cint b, bool isaddr = false);
	virtual void push64be(cint b, bool isaddr = false);
	
	cint c2_low_bound();
	cint c2_high_bound();
	
	template<int BITS> bool c2bt(cint n, int taken)
	{
		if (BITS == 8 && n == 2 * taken)
			return false;
		
		struct {uint64_t n:BITS;}s; s.n = n;
		return s.n == n;
	}
	
	template<int BITS> bool c2st(cint n)
	{
		struct {int64_t n:BITS;}s; s.n = n;
		return s.n == n;
	}
	
	template<int BITS> cint c2ur(cint n)
	{
		struct {uint64_t n:BITS;}s; s.n = n;
		if (s.n != n)
			c2_error("Unsigned value out of range");
			
		return n&((cint(1)<<BITS)-1);
	}
	
	template<int BITS> cint c2sr(cint n)
	{
		struct {int64_t n:BITS;}s; s.n = n;
		if (s.n != n)
			c2_error("Signed value out of range");
			
		return n&((1<<BITS)-1);
	}
	
	template<int LOW, int HIGH> cint c2lh(cint n)
	{
		if (n < LOW || n > HIGH)
			c2_error("Value out of range");
		
		return n;
	}

	template<int BITS> cint c2r(cint n)
	{
		if (!var::inrange(BITS, n))
			c2_error("Value out of range");
		
		return n&((1<<BITS)-1);
	}
	
	template<int BITS> cint c2b(cint n)
	{
		if (BITS == 8 && n == 0)
			c2_error("Value out of range");
		
		return c2sr<BITS>(n);
	}
	
	enum c2_eloglevel : uint8_t
	{
		verbose,
		info,
		warning,
		error
	};
	
	void c2_log(c2_eloglevel level, const char *file, int line, const char *format, ...);
	
	class c2_file
	{
	public:
		c2_file(const char *file = nullptr);
		~c2_file();
		bool open(const char *file);
		void close();
		cint size();
		cint seek(cint pos);
		cint pos();
		bool eof();
		cint pop8();
		cint pop16le();
		cint pop16be();
		cint pop32le();
		cint pop32be();
		cint pop64le();
		cint pop64be();
		float pop32float();
		double pop64float();
		cint read(void *ptr, cint size);
	private:
		void *pinternal;
	};
	
	void loadbin(const char *file, size_t offset = 0, size_t length = -1);
	static var loadvar(const char *file, size_t offset = 0, size_t length = -1);
	void loadstream(const char *cmd, size_t offset = 0, size_t length = -1);
	
	void c2_add_arg(const char *format, ...);

	void c2_set_ram(cint base, cint size);
	
	int64_t c2_scope_push(uint32_t fileindex, uint32_t line, uint32_t uid);
	void c2_scope_pop();
	struct c2_sscope
	{
		c2_sscope(uint32_t fileindex, uint32_t line, uint32_t uid);
		~c2_sscope();
	private:
		int64_t lix_backup;
	};
	int64_t c2_lix = 0;
	
	static void *c2_malloc(size_t size);
	static void c2_free(void *ptr);
	static void *c2_realloc(void *ptr, size_t size);
	static size_t c2_strlen(const char *s);
	static void *c2_memset(void *s, int c, size_t n);
	static void *c2_memcpy(void *dest, const void *src, size_t n);
	static const char *c2_strchr(const char *s, int c);

	static c2i *c2_get_single(){ return c2i::c2_single; }
	
	void c2_poke(cint pos, cint data);
	uint8_t c2_peek(cint pos);

	virtual void c2_config_setup_info(const char *title, bool verbose);
	virtual void c2_config_setup_file(const char *file);
	virtual void c2_config_setup_include(const char *file);
	
	bool c2_allow_overwrite = false;
	bool c2_verbose = false;
	bool c2_assembly_step_hash = false;

	cmdi &c2_cmd;
	
	void *c2_get_internal(){return pinternal;}
	
	bool c2_resolve(const char *addr, cint &out, bool allow_labels = true);

	void c2_subassemble(const char *source);
	
	virtual const char *c2_get_template();

protected:
	// Hides internals to avoid includes
	void *pinternal;
	
	void push(cint b);
	int32_t error_count, warning_count;
	int c2_pass_count = 0;
	
	void c2_register_var(const char *name, const char *from, int mode, c2i::c2_vardata *pv);
	void c2_unregister_var(c2i::c2_vardata *pv);

	static c2i *c2_single;
	
	uint8_t *RAM = nullptr;
	uint8_t *RAM_last = nullptr;
	uint8_t *RAM_use = nullptr;
	cint RAM_base = 0, RAM_size = 0;
};
