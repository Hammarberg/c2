/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#define C2_INTERFACE_TEMPLATE_VERSION 1

#include "cmdi.h"

#include <cstdint>
#include <initializer_list>
#include <new>
#include <cmath>

#define c2_verbose(...) c2_get_single()->c2_log(1,c2_eloggroup::verbose,__FILE__,__LINE__,__VA_ARGS__);
#define c2_info(...)    c2_get_single()->c2_log(0,c2_eloggroup::info,__FILE__,__LINE__,__VA_ARGS__);
#define c2_warning(...) c2_get_single()->c2_log(0,c2_eloggroup::warning,__FILE__,__LINE__,__VA_ARGS__);
#define c2_error(...)   c2_get_single()->c2_log(0,c2_eloggroup::error,__FILE__,__LINE__,__VA_ARGS__);

#define c2static static c2_static_impl

class c2i
{
public:
	typedef int64_t cint;

	template<typename T, typename ST=size_t>
	class c2_vector
	{
	public:
		c2_vector(){	}
		c2_vector(const c2_vector &o)
		{
			ensure(c2vn=o.c2vn, true);
			for(ST r=0;r<o.c2vn;r++)
				new (&c2vp[r]) T(o.c2vp[r]);
		}
		virtual ~c2_vector()
		{
			c2v_size(0);
			c2i::c2_free(c2vp);
		}
		ST c2v_size()const
		{
			return c2vn;
		}
		ST c2v_size(ST size)
		{
			if(size > c2vn)
			{
				c2v_ensure(size);
				for(ST r = c2vn; r < size; r++)
					new (&c2vp[r]) T();
			}
			else if(size < c2vn)
			{
				for(ST r = size; r < c2vn; r++)
					c2vp[r].~T();
			}
			return c2vn = size;
		}
		T &c2v_ref(ST r = 0)
		{
			if(r >= c2vn)
				c2v_size(r+1);
			return c2vp[r];
		}
		T c2v_read(ST r = 0)const
		{
			if(r < c2vn)
				return c2vp[r];
			return T(0);
		}
		void c2v_push(const T &o)
		{
			c2v_ensure(c2vn+1);
			new (&c2vp[c2vn]) T(o);
			c2vn++;
		}
		bool c2v_pop(T &o)
		{
			if(!c2vn)return false;
			o=c2vp[c2vn-1];
			size(c2vn);
			return true;
		}
		void c2v_ensure(ST size, bool trim=false)
		{
			if(size > c2va)
			{
				ST na = size == 1 ? 1 : (trim ? size : size * 2);
				c2vp = (T *)c2i::c2_realloc(c2vp, sizeof(T)*na);
				c2va = na;
			}
		}
		void c2v_copy(const c2_vector &o)
		{
			c2v_size(0);
			c2v_ensure(c2vn=o.c2vn, true);
			for(ST r=0;r<o.c2vn;r++)
				new (&c2vp[r]) T(o.c2vp[r]);
		}
	private:
		ST c2vn=0,c2va=0;
		T *c2vp=nullptr;
	};

	class c2_corg
	{
	public:
		cint operator=(c2_corg &o);
		cint operator=(cint n);
		cint operator=(std::initializer_list<cint> elements);
		operator cint()const;
		void backup(cint &a, cint &w);
		void restore(cint a, cint w);
		cint orga = 0, orgw = 0;
	}c2_org;
	
	typedef c2_vector<cint> c2_vardata;

	class c2_var : private c2_vardata
	{
	friend c2i;
	public:
		c2_var();
		c2_var(const c2_var &o);
		c2_var(cint in, uint8_t ib = 0);
		c2_var(int in);
		c2_var(const c2_corg &o);
		c2_var(std::initializer_list<c2_var> elements);
		c2_var(const char *pstr);
		virtual ~c2_var();

		c2_var &operator=(const c2_var &o);
		c2_var &operator=(cint n);
		c2_var &operator=(const c2_corg &o);
		cint &operator[](size_t n);
		operator cint&();

		const char *str()const;
		int value()const;
		size_t size()const;
		uint8_t bits()const;
	private:
		void invalidate_bits();
		void copy(const c2_var &o);
		static bool inrange(int bits, cint n);
		uint8_t update_bits()const;
		static uint8_t calc_bits(cint n);

		mutable char *c2vs = nullptr;	//Holds temporary string buffer
		mutable uint8_t c2vb = 0;	//Highest number of bits needed by any value stored
	};

	typedef c2_var var;

	struct c2_slabel
	{
		c2_slabel(const char *inname, uint32_t inscid, int inmode = 0)
		:name(inname),scid(inscid),mode(inmode){}
		const char *name;
		uint32_t scid;
		int mode;
	};

	template<typename T>
	class c2_baselabel : public T, private c2_vardata
	{
	friend c2i;
	public:
		c2_baselabel(const c2_slabel &o) : c2scid(o.scid) { c2_get_single()->c2_register_var(o.name, nullptr, o.mode, this); }
		virtual ~c2_baselabel() { c2_get_single()->c2_unregister_var(this); }
		
		void operator=(const c2_corg &o) { c2v_ref(c2_get_lix())=o.orga; }
		operator cint() const { return c2v_read(c2_get_lix()); }
		operator var() const { return c2v_read(c2_get_lix()); };
		cint &operator[](size_t n) { return c2v_ref(n); }

		int c2_value() { return c2v_read(); }
		size_t c2_size() const { return c2v_size(); }
	private:
		size_t c2_get_lix() const { return c2_get_single()->c2_scope_lix(c2scid); }
		uint32_t c2scid;
	};
	
	struct c2_void{};
	typedef c2_baselabel<c2_void> c2_label;

	class c2_static_impl : private c2_vardata
	{
	public:
		c2_static_impl() {}
		virtual ~c2_static_impl() {}
		cint &operator=(cint in) { return c2v_ref(c2_get_single()->c2_scope_index)=in; }
		operator cint() { return c2v_ref(c2_get_single()->c2_scope_index); }
	};

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
	virtual void push24le(cint b, bool isaddr = false);
	virtual void push24be(cint b, bool isaddr = false);
	virtual void push32le(cint b, bool isaddr = false);
	virtual void push32be(cint b, bool isaddr = false);
	virtual void push64le(cint b, bool isaddr = false);
	virtual void push64be(cint b, bool isaddr = false);
	
	cint c2_get_low_bound();
	cint c2_get_high_bound();

	var c2_low_bound;
	var c2_high_bound;

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
	
	enum c2_eloggroup : uint8_t
	{
		verbose,
		info,
		warning,
		error
	};
	
	void c2_log(int level, c2_eloggroup group, const char *file, int line, const char *format, ...);

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
	var loadvar(const char *file, size_t offset = 0, size_t length = -1);
	void loadstream(const char *cmd, size_t offset = 0, size_t length = -1);
	
	void c2_add_arg(const char *format, ...);

	void c2_set_ram(cint base, cint size);
	
	size_t c2_scope_push(uint32_t fileindex, uint32_t line, uint32_t uid);
	size_t c2_scope_lix(uint32_t uid);
	void c2_scope_pop();
	struct c2_sscope
	{
		c2_sscope(uint32_t fileindex, uint32_t line, uint32_t uid);
		~c2_sscope();
	private:
		uint32_t c2_bak_scope_id = 0;
		size_t c2_bak_scope_index = 0;
	};
	uint32_t c2_scope_id = 0;
	size_t c2_scope_index = 0;

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

	virtual void c2_config_setup_info(const char *title, int verbose);
	virtual void c2_config_setup_file(const char *file);
	virtual void c2_config_setup_include(const char *file);
	
	bool c2_allow_overwrite = false;
	int c2_loglevel = 0;
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
