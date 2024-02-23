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
		int64_t operator=(c2_corg &o);
		int64_t operator=(int64_t n);
		int64_t operator=(std::initializer_list<int64_t> elements);
		operator int64_t() const;
		//operator var() const;
		void backup(int64_t &a, int64_t &w);
		void restore(int64_t a, int64_t w);
		int64_t orga = 0, orgw = 0;
	}c2_org;
	
	struct c2_void{};

	struct c2_vardata
	{
		c2_vardata(int64_t in=0, int32_t ib=1, int32_t ia=0, int32_t ic=1)
		: c2va(ia), c2vb(ib), c2vc(ic)
		{
			c2vv.c2vn = in;
		}
		
		union
		{
			int64_t c2vn;		//Value
			int64_t *c2vp;		//Or pointer to values
		}c2vv;

		uint32_t c2va;			//Allocated elements
		int32_t c2vb;			//Highest bit count
		uint32_t c2vc;			//Number of values, 1 minimum
		char *c2vs = nullptr;	//Holds temporary string buffer
		
		int64_t get() const { if(!c2va){ return c2vv.c2vn; } return c2vv.c2vp[0]; }
		void set(int64_t n) {internal_clear(); c2va=c2vb=0; c2vv.c2vn=n; c2vc = 1;}
	protected:
		void internal_clear() { if(c2va){ c2i::c2_free(c2vv.c2vp);} }
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
		c2_basevar(int64_t n, uint32_t ib = 0) : c2_vardata(n) { c2vb = ib ? ib : calc_bits(n); }
		c2_basevar(int n) : c2_vardata(n) { c2vb = calc_bits(n); }
		c2_basevar(const c2_corg &o) : c2_vardata(o.orga) { c2vb = calc_bits(o.orga); }
		
		c2_basevar(std::initializer_list<c2_basevar> elements)
		{
			const size_t count = elements.size();
			if(count == 1)
			{
				copy(*elements.begin());
			}
			else
			{
				c2va = c2vc = count;
				c2vv.c2vp = (int64_t *) c2i::c2_malloc(sizeof(int64_t) * count);
				int32_t nb = 0;
				size_t r=0;
				for(auto i = elements.begin(); i != elements.end(); i++, r++)
				{
					int32_t cb = calc_bits(c2vv.c2vp[r] = i->get());
					if(cb > nb)
						nb = cb;
				}
				c2vb = nb;
			}
		}
		
		c2_basevar(const char *pstr)
		{
			if(pstr)
			{
				size_t count = c2i::c2_strlen(pstr);
				c2va = c2vc = count;
				c2vv.c2vp = (int64_t *) c2i::c2_malloc(sizeof(int64_t) * count);
				int32_t nb = 0;
				for(size_t r=0; r<count; r++)
				{
					int32_t cb = calc_bits(c2vv.c2vp[r] = pstr[r]);
					if(cb > nb)
						nb = cb;
				}
				c2vb = nb;
			}
			else
			{
				c2va = 0;
				c2vb = c2vc = 1;
				c2vv.c2vn = 0;
			}
		}
		
		~c2_basevar() { c2_get_single()->c2_unregister_var(this); internal_clear(); if(c2vs){ c2i::c2_free(c2vs); } }
		
		template<typename I> c2_basevar &operator=(const c2_basevar<I> &o) { internal_clear(); copy(o); return *this; }
		c2_basevar& operator=(const c2_basevar &o) { internal_clear(); copy(o); return *this; }
		c2_basevar &operator=(int64_t n) { internal_clear(); c2vv.c2vn = n; c2va = 0; c2vb = calc_bits(n); c2vc = 1; return *this; }
		c2_basevar &operator=(const c2_corg &o) { internal_clear(); c2vv.c2vn = o.orga; c2va = 0; c2vb = calc_bits(o.orga); c2vc = 1; return *this; }
		
		int64_t &operator[](int64_t n) { c2vb = 0; return getat(n); }
		operator int64_t&() { c2vb = 0; return getat(0); }
		int64_t getatlix(int64_t n) { return getat((n >= 0 && n < c2vc) ? n : 0); }
		
		size_t size() const { return c2vc; }
		
		void clear() { internal_clear(); c2va = c2vb = c2vv.c2vn = 0; c2vc = 1; }
		
		int32_t bits() { internal_bits(); return c2vb; }
		
		const char *str()
		{
			c2vs = (char *)c2i::c2_realloc(c2vs, c2vc + 1);
			char *p = c2vs;
			
			for(size_t r=0; r<c2vc; r++, p++)
			{
				*p = char(getat(r));
			}
			
			*p = 0;
			
			return c2vs;
		}
		
		int value() const { return get(); }
		
	private:
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
				c2vv.c2vp = (int64_t *)c2i::c2_malloc(sizeof(int64_t[c2vc]));
				c2i::c2_memcpy(c2vv.c2vp, o.c2vv.c2vp, sizeof(int64_t[c2vc]));
			}
		}
		
		int64_t &getat(int64_t n){ if(!n && !c2va){ return c2vv.c2vn; } ensurearray(n); return c2vv.c2vp[n]; }
		
		void ensurearray(int64_t n)
		{
			if(n < 0)
				throw "negative";
			
			if(n < c2vc)
				return;
			
			if(n < c2va)
			{
				c2vc = uint32_t(n) + 1;
				return;
			}
			
			int64_t on = c2va ? c2vv.c2vp[0] : c2vv.c2vn;
			int64_t oa = c2va;
			
			c2va = uint32_t(n) * 2;
			c2vc = uint32_t(n) + 1;
			
			c2vv.c2vp = (int64_t *)c2i::c2_realloc(oa ? c2vv.c2vp : nullptr, sizeof(int64_t) * c2va);
			c2i::c2_memset((void *)&c2vv.c2vp[oa], 0, sizeof(int64_t) * (c2va - oa));
			
			c2vv.c2vp[0] = on;
		}
		
		static int32_t calc_bits(int64_t n)
		{
			int32_t b = 1;
			if(n >= 0)
			{
				for(; b < 64; b++)
				{
					if(!(n >> b))
						break;
				}
				return b;
			}
			
			n = ~n;
			for(; b < 64; b++)
			{
				if(!(n >> b))
					break;
			}
			return b + 1;
		}
		
		void internal_bits()
		{
			if(!c2vb)
			{
				if(c2va)
				{
					for(uint32_t r=0; r<c2vc; r++)
					{
						int32_t bb = calc_bits(c2vv.c2vp[r]);
						if(bb > c2vb)
							c2vb = bb;
					}
				}
				else
				{
					c2vb = calc_bits(c2vv.c2vn);
				}
			}
		}
		
		static bool inrange(int bits, int64_t n){return n < (1LL<<bits) && n >= 0-(1LL<<(bits-1));}
	};
	
	typedef c2_basevar<c2_void> var;

	template<typename U> friend class c2_basevar;
	
	c2i(cmdi *pcmd);
	virtual ~c2i();

	virtual bool c2_assemble();
	
	virtual void c2_pre();
	virtual void c2_reset_pass();
	virtual void c2_pass() = 0;
	virtual void c2_post();

	virtual void push8(int64_t b, bool isaddr = false);
	virtual void push16le(int64_t b, bool isaddr = false);
	virtual void push16be(int64_t b, bool isaddr = false);
	virtual void push32le(int64_t b, bool isaddr = false);
	virtual void push32be(int64_t b, bool isaddr = false);
	virtual void push64le(int64_t b, bool isaddr = false);
	virtual void push64be(int64_t b, bool isaddr = false);
	
	int64_t c2_low_bound();
	int64_t c2_high_bound();
	
	template<int BITS> bool c2bt(int64_t n, int taken)
	{
		if (BITS == 8 && n == 2 * taken)
			return false;
		
		struct {uint64_t n:BITS;}s; s.n = n;
		return s.n == n;
	}
	
	template<int BITS> bool c2st(int64_t n)
	{
		struct {int64_t n:BITS;}s; s.n = n;
		return s.n == n;
	}
	
	template<int BITS> int64_t c2ur(int64_t n)
	{
		struct {uint64_t n:BITS;}s; s.n = n;
		if (s.n != n)
			c2_error("Unsigned value out of range");
			
		return n&((int64_t(1)<<BITS)-1);
	}
	
	template<int BITS> int64_t c2sr(int64_t n)
	{
		struct {int64_t n:BITS;}s; s.n = n;
		if (s.n != n)
			c2_error("Signed value out of range");
			
		return n&((1<<BITS)-1);
	}
	
	template<int LOW, int HIGH> int64_t c2lh(int64_t n)
	{
		if (n < LOW || n > HIGH)
			c2_error("Value out of range");
		
		return n;
	}

	template<int BITS> int64_t c2r(int64_t n)
	{
		if (!var::inrange(BITS, n))
			c2_error("Value out of range");
		
		return n&((1<<BITS)-1);
	}
	
	template<int BITS> int64_t c2b(int64_t n)
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
		int64_t size();
		int64_t seek(int64_t pos);
		int64_t pos();
		bool eof();
		int64_t pop8();
		int64_t pop16le();
		int64_t pop16be();
		int64_t pop32le();
		int64_t pop32be();
		int64_t pop64le();
		int64_t pop64be();
		float pop32float();
		double pop64float();
		int64_t read(void *ptr, int64_t size);
	private:
		void *pinternal;
	};
	
	void loadbin(const char *file, size_t offset = 0, size_t length = -1);
	static var loadvar(const char *file, size_t offset = 0, size_t length = -1);
	void loadstream(const char *cmd, size_t offset = 0, size_t length = -1);
	
	void c2_add_arg(const char *format, ...);

	void c2_set_ram(int64_t base, int64_t size);
	
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
	
	static c2i *c2_get_single(){ return c2i::c2_single; }
	
	void c2_poke(int64_t pos, int64_t data);
	uint8_t c2_peek(int64_t pos);

	virtual void c2_config_setup_info(const char *title, bool verbose);
	virtual void c2_config_setup_file(const char *file);
	virtual void c2_config_setup_include(const char *file);
	
	bool c2_allow_overwrite = false;
	bool c2_verbose = false;
	bool c2_assembly_step_hash = false;

	cmdi &c2_cmd;
	
	void *c2_get_internal(){return pinternal;}
	
	bool c2_resolve(const char *addr, int64_t &out, bool allow_labels = true);

	void c2_subassemble(const char *source);
	
	virtual const char *c2_get_template();

protected:
	// Hides internals to avoid includes
	void *pinternal;
	
	void push(int64_t b);
	int32_t error_count, warning_count;
	int c2_pass_count = 0;
	
	void c2_register_var(const char *name, const char *from, int mode, c2i::c2_vardata *pv);
	void c2_unregister_var(c2i::c2_vardata *pv);

	static c2i *c2_single;
	
	uint8_t *RAM = nullptr;
	uint8_t *RAM_use = nullptr;
	int64_t RAM_base = 0, RAM_size = 0;
};
