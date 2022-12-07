/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "c2i.h"
#include "c2b.h"

#include <cstdio>
#include <cstdarg>
#include <cstring>
#include <map>
#include <memory>

#define ierror(...) c2_log(c2_eloglevel::error, nullptr, 0, __VA_ARGS__)
#define iwarning(...) c2_log(c2_eloglevel::warning, nullptr, 0, __VA_ARGS__)

///////////////////////////////////////////////////////////////////////////////
// Var
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
// corg
///////////////////////////////////////////////////////////////////////////////

int64_t c2i::c2_corg::operator=(c2_corg &o)
{
	// @ = @ resets orga
	return orga = o.orgw;
}

int64_t c2i::c2_corg::operator=(int64_t n)
{
	return orga = orgw = n;
}

int64_t c2i::c2_corg::operator=(std::initializer_list<int64_t> elements)
{
	auto i = elements.begin();
	if(elements.size() >= 2)
	{
		orgw = *i;
		i++;
		orga = *i;
	}
	else if(elements.size() == 1)
	{
		orga = orgw = *i;
	}
	
	return orga;
}

c2i::c2_corg::operator int64_t() const
{
	return orga;
}

/*
c2i::c2_corg::operator var() const
{
	return var(orga);
}
*/

void c2i::c2_corg::backup(int64_t &a, int64_t &w)
{
	a = orga;
	w = orgw;
}

void c2i::c2_corg::restore(int64_t a, int64_t w)
{
	orga = a;
	orgw = w;
}

///////////////////////////////////////////////////////////////////////////////
// c2i misc
///////////////////////////////////////////////////////////////////////////////


void sinternal::get_sorted_vars(std::vector<std::pair<std::string, int64_t>> &out)
{
	std::map<int64_t, std::string> sorted;
	
	for(auto i=registered_vars.begin(); i!=registered_vars.end(); i++)
	{
		if(!strstr(i->first.c_str(), "c2_auto_"))
			sorted[i->second->get()] = i->first;
	}
	
	for(auto i=sorted.begin(); i!=sorted.end(); i++)
	{
		out.push_back(std::pair<std::string, int64_t>(i->second, i->first));
	}
}

bool sinternal::lookup_var(const std::string &in, int64_t &out)
{
	auto i = registered_vars.find(in);
	if(i != registered_vars.end())
	{
		out = i->second->get();
		return true;
	}
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// c2i
///////////////////////////////////////////////////////////////////////////////


#if defined(_WIN32)
#define LIBRARY_API __declspec(dllexport)
#else
#define LIBRARY_API
#endif

c2i *c2_create_object_instance(cmdi *pcmd);

static std::unique_ptr<c2i> c2_dsingle = nullptr;

extern "C" LIBRARY_API c2i *c2_get_object_instance(cmdi *pcmd)
{
	c2i *i = c2i::c2_get_single();
	if(!i)
	{
		i = c2_create_object_instance(pcmd);
		c2_dsingle = std::unique_ptr<c2i>(i);
	}
	return i;
}	

c2i *c2i::c2_single = nullptr;

c2i::c2i(cmdi *pcmd)
: c2_cmd(*pcmd)
{
	c2i::c2_single = this;
	sinternal *p = new sinternal;
	pinternal = (void *)p;
	
	c2_cmd.add_info("--out", "-o", "<from> <to> [filename]: Outputs a binary. If no filename is given stdout will be used. To and from can be either addresses, labels or '-' or '+' as lowest/highest+1 address assembled.");
	c2_cmd.add_info("--dump-vars", "-dv", "[filename]: Output variables.");

	c2i::var a = "vice break";
	c2i::var b = a;
}

c2i::~c2i()
{
	sinternal *p = (sinternal *)pinternal;
	delete p;
	
	delete [] RAM;
	delete [] RAM_use;
}

void c2i::push8(int64_t b)
{
	if(!var::inrange(8, b))
	{
		ierror("Byte overflow storing value %lld", b);
	}
	
	push(b);
}

void c2i::push16le(int64_t b)
{
	if(!var::inrange(16, b))
	{
		ierror("Word overflow storing value %lld", b);
	}
	
	push(b&255);
	push(b>>8);
}

void c2i::push16be(int64_t b)
{
	if(!var::inrange(16, b))
	{
		ierror("Word overflow");
	}
	
	push(b>>8);
	push(b);
}

void c2i::push32le(int64_t b)
{
	if(!var::inrange(32, b))
	{
		ierror("Dword overflow");
	}
	
	push(b);
	push(b>>8);
	push(b>>16);
	push(b>>24);
}

void c2i::push32be(int64_t b)
{
	if(!var::inrange(32, b))
	{
		ierror("Dword overflow");
	}
	
	push(b>>24);
	push(b>>16);
	push(b>>8);
	push(b);
}

void c2i::push64le(int64_t b)
{
	push(b);
	push(b>>8);
	push(b>>16);
	push(b>>24);
	push(b>>32);
	push(b>>40);
	push(b>>48);
	push(b>>56);
}

void c2i::push64be(int64_t b)
{
	push(b>>56);
	push(b>>48);
	push(b>>40);
	push(b>>32);
	push(b>>24);
	push(b>>16);
	push(b>>8);
	push(b);
}

void c2i::push(int64_t b)
{
	c2_poke(c2_org.orgw, b);
	c2_org.orga++;
	c2_org.orgw++;
}

void c2i::c2_poke(int64_t pos, int64_t data)
{
	sinternal *p = (sinternal *)pinternal;
	
	int64_t d[2];
	d[0] = pos;
	d[1] = uint8_t(data);
	
	p->hash_state.push128(d);

	if(pos < RAM_base || pos >= RAM_base+RAM_size)
	{
		ierror("Out of range writing to address 0x%x", int(c2_org.orgw));
	}
	else
	{
		if(c2_allow_overwrite == false && RAM_use[pos - RAM_base])
			ierror("Overwriting already assembled data at address 0x%x", int(pos));
		
		RAM[pos - RAM_base] = uint8_t(data);
		RAM_use[pos - RAM_base] = 1;
	}
}

uint8_t c2i::c2_peek(int64_t pos)
{
	if(pos < RAM_base || pos >= RAM_base+RAM_size)
	{
		ierror("Out of range writing to address 0x%x", int(c2_org.orgw));
		return 0;
	}
	return RAM[pos - RAM_base];
}

void c2i::c2_reset_pass()
{
	error_count = 0;
	warning_count = 0;
	sinternal *p = (sinternal *)pinternal;
	p->log.clear();
	p->hash_state.seed();
	
	memset(RAM, 0, RAM_size);
	memset(RAM_use, 0, RAM_size);
	
}

bool c2i::c2_assemble()
{
	c2_pre();
	
	sinternal *p = (sinternal *)pinternal;
	bool result = true;
	
	std::vector<cmur3::shash> history;

	try
	{
		int64_t org_backup_a, org_backup_w;
		c2_org.backup(org_backup_a, org_backup_w);
			
		for(int pass=1;;pass++)
		{
			c2_pass_count = pass;
			if(pass == 50)
			{
				throw "Giving up resolving forward dependencies";
			}
			
			c2_org.restore(org_backup_a, org_backup_w);
			c2_reset_pass();
			
			fprintf(stderr, "Pass %d\t", pass);
			c2_pass();
			p->hash_state.finalize();
			cmur3::shash hash = p->hash_state.hash;
#ifndef _MSC_VER
			fprintf(stderr, "%016lx%016lx\n", hash.h1, hash.h2);
#else
			fprintf(stderr, "%016llx%016llx\n", hash.h1, hash.h2);
#endif
			if(history.size())
			{
				auto i = history.rbegin();
				if(!memcmp(&hash, &(*i), sizeof(hash)))
					break;
				
				i++;
				while(i != history.rend())
				{
					if(!memcmp(&hash, &(*i), sizeof(hash)))
					{
						throw "Cyclic pass detected, cannot resolve forward dependencies";
					}
					i++;
				}
			}
			history.push_back(hash);
		}
	}
	catch(const char *str)
	{
		result = false;
		std::string out = "error: ";
		out += str;
		p->log.push_back(std::pair<c2_eloglevel, std::string>(c2_eloglevel::error, out));
	}
	
	std::vector<std::pair<c2_eloglevel, std::string>> &log = p->log;
	
	for(size_t r=0; r<log.size();r++)
	{
		c2_eloglevel level = log[r].first;
		fprintf(stderr, log[r].second.c_str());
		fprintf(stderr, "\n");

		if(level == c2_eloglevel::error)
		{
			result = false;
			break;
		}
	}
	
	if(result)
	{
		c2_post();
	}
	
	return result;
}

int64_t c2i::c2_low_bound()
{
	int64_t low = 0;
	for(;low<RAM_size;low++)
		if(RAM_use[low])
			return low + RAM_base;

	return -1;
}

int64_t c2i::c2_high_bound()
{
	int64_t high = RAM_size - 1;
	for(;high>=0;high--)
		if(RAM_use[high])
			return high+1 + RAM_base;

	return -1;
}

bool c2i::c2_resolve(const char *addr, int64_t &out)
{
	if(!addr)
		return 0;

	enum
	{
		low,
		high,
		dec,
		oct,
		hex,
		//bin,
		label
	}t;
	
	const char *p;
	
	switch(*addr)
	{
	case '-':
		t = low;
		p = addr;
		break;
	case '+':
		t = high;
		p = addr;
		break;
	case '$':
		t = hex;
		p = addr+1;
		break;
		/*
	case '%':
		t = bin;
		p = addr+1;
		break;
		 */
	case '0':
		switch(addr[1])
		{
		case 'x':
			t = hex;
			p = addr+2;
			break;
			/*
		case 'b':
			t = bin;
			p = addr+2;
			break;*/
		case '\0':
			t = dec;
			p = addr;
			break;
		default:
			t = oct;
			p = addr;
			break;
		}
		break;
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':
		t = dec;
		p = addr;
		break;
	default:
		t = label;
		p = addr;
		break;
	};
	
	switch(t)
	{
	case low:
		out = c2_low_bound();
		break;
	case high:
		out = c2_high_bound();
		break;
	case dec:
		sscanf(p, "%ld", &out);
		break;
	case oct:
		sscanf(p, "%lo", &out);
		break;
	case hex:
		sscanf(p, "%lx", &out);
		break;
	case label:
		{
			sinternal *ptr = (sinternal *)pinternal;
			if(!ptr->lookup_var(p, out))
				return false;
		}
		break;
	};
	
	return true;
}


void c2i::c2_pre()
{
	
}

void c2i::c2_post()
{
	sinternal *p = (sinternal *)pinternal;
	
	c2_cmd.invoke("--out", 2, 3, [&](int arga, const char *argc[])
	{
		int64_t from,to;
		
		if(!c2_resolve(argc[0], from))
			throw "--out could not resolve 'from' address";
		
		if(!c2_resolve(argc[1], to))
			throw "--out could not resolve 'to' address";
			
		if(from > to || from < RAM_base || from >= RAM_base+RAM_size || to < RAM_base || to >= RAM_base+RAM_size)
			throw "--out addresses out of range";
			
		FILE *fp = stdout;
		if(arga == 3)
		{
			fp = fopen(argc[2], "wb");
			if(!fp)
				throw "--out could not open file for writing";
		}
		
		fwrite(RAM+from-RAM_base, 1, to - from, fp);
		
		if(fp != stdout)
			fclose(fp);
	});
	
	c2_cmd.invoke("--dump-vars", 0, 1, [p](int arga, const char *argc[])
	{
		FILE *fp = stdout;
		if(arga)
		{
			fp = fopen(argc[0], "w");
			if(!fp)
				throw "--dump-vars could not open file for writing";
		}

		std::vector<std::pair<std::string, int64_t>> sorted;
		p->get_sorted_vars(sorted);
		
		for(size_t r=0;r<sorted.size();r++)
		{
			fprintf(fp, "%s %lx\n", sorted[r].first.c_str(), sorted[r].second);
		}
		
		if(fp != stdout)
			fclose(fp);
	});
}

void c2i::loadbin(const char *path, size_t offset, size_t length)
{
	FILE *fp = fopen(path, "rb");
	if(!fp)
	{
		ierror("File not found: %s", path);
		return;
	}
	
	fseek(fp, 0, SEEK_END);
	size_t size = ftell(fp);
		
	if(offset > size)
	{
		fclose(fp);
		ierror("Offset %d is beyond file size for: %s", int(offset), path);
		return;
	}
	fseek(fp, long(offset), SEEK_SET);
	
	size_t toread;
	
	if(length == size_t(-1))
	{
		toread = size - offset;
	}
	else if(length > size - offset)
	{
		fclose(fp);
		ierror("Requested size (%d) to read is larger than the file size for: %s", int(length), path);
		return;
	}
	else
	{
		toread = length;
	}

	for(size_t r=0; r<toread; r++)
	{
		uint8_t b;
		fread(&b, 1, 1, fp);
		push(b);
	}
	
	fclose(fp);
}

c2i::var c2i::loadvar(const char *path, size_t offset, size_t length)
{
	var v;
	FILE *fp = fopen(path, "rb");
	if(!fp)
	{
		ierror("File not found: %s", path);
		return v;
	}
	
	fseek(fp, 0, SEEK_END);
	size_t size = ftell(fp);
		
	if(offset > size)
	{
		fclose(fp);
		ierror("Offset %d is beyond file size for: %s", int(offset), path);
		return v;
	}
	fseek(fp, long(offset), SEEK_SET);
	
	size_t toread;
	
	if(length == size_t(-1))
	{
		toread = size - offset;
	}
	else if(length > size - offset)
	{
		fclose(fp);
		ierror("Requested size (%d) to read is larger than the file size for: %s", int(length), path);
		return v;
	}
	else
	{
		toread = length;
	}
	
	if(toread)
	{
		v[toread - 1] = 0;
		
		for(size_t r=0;r<toread;r++)
		{
			uint8_t b;
			fread((char *)&b, 1, 1, fp);
			v[r] = b;
		}
	}

	fclose(fp);
	
	return v;
}

void c2i::c2_scope_push(uint32_t fileindex, uint32_t line)
{
	sinternal *p = (sinternal *)pinternal;
	p->stack_history.push_back(sdebugstack(fileindex, line));
}

void c2i::c2_scope_pop()
{
	sinternal *p = (sinternal *)pinternal;
	p->stack_history.pop_back();
}

void c2i::c2_config_setup_file(const char *file)
{
	sinternal *p = (sinternal *)pinternal;
	p->files.push_back(file);
}

void c2i::c2_log(c2_eloglevel level, const char *file, int line, const char *format, ...)
{
	// Not logging anything on first pass
	if(c2_pass_count == 1)
		return;
		
	switch(level)
	{
	case c2_eloglevel::warning:
		if(warning_count >= 10)
			return;
		break;
	case c2_eloglevel::error:
		if(error_count >= 10)
			return;
		break;
	default:
		break;
	};
		
	
	sinternal *p = (sinternal *)pinternal;
	
	std::string out;
	std::vector<sdebugstack> &stack_history = p->stack_history;
	
	size_t shs = stack_history.size();
	if(shs)
	{
		for(size_t r = 0 ; r < shs; r++)
		{
			if(file || (!file && r != shs - 1))
				out += " expanded from ";
			
			out += p->files[stack_history[r].fileindex] + ":" + std::to_string(stack_history[r].line) + ": ";
			
			if(r != shs - 1)
				out += "\n";
		}
	}

	char buffer[1024];
	char *pstr = (char *)buffer;
	bool alloc = false;
	
	va_list args;
	
	va_start (args, format);
	int n = vsnprintf (pstr, sizeof(buffer), format, args);
	va_end (args);

	// In case buffer is not large enough
	if (size_t(n) >= sizeof(buffer) - 1)
	{
		alloc = true;
		pstr = new char[n + 16];
		va_start (args, format);
		vsnprintf (pstr, n + 15, format, args);
		va_end (args);
	}
	
	if(file)
	{
		if(shs)
			out += "\n";
		out += file;
		out += ":" + std::to_string(line) + ": ";
	}
	
	switch(level)
	{
		case c2_eloglevel::debug:
			out += "debug: ";
		break;
		case c2_eloglevel::info:
			out += "info: ";
		break;
		case c2_eloglevel::warning:
			out += "warning: ";
		break;
		case c2_eloglevel::error:
			out += "error: ";
			error_count++;
		break;
		default:
		break;
	};
	out += pstr;
	
	if(alloc)
	{
		delete [] pstr;
	}
	
	p->log.push_back(std::pair<c2i::c2_eloglevel, std::string>(level, out));
	//std::cerr << out.c_str();
	
	/*
	if(error_count >= 20)
	{
		throw "error count exceeds threshold";
	}
	 */
}

void c2i::register_var(const char *name, c2i::c2_vardata *pv)
{
	sinternal *p = (sinternal *)pinternal;
	p->registered_vars[name] = pv;
}

void *c2i::c2_malloc(size_t size)
{
	return malloc(size);
}

void c2i::c2_free(void *ptr)
{
	free(ptr);
}

void *c2i::c2_realloc(void *ptr, size_t size)
{
	return realloc(ptr, size);
}

size_t c2i::c2_strlen(const char *s)
{
	return strlen(s);
}

void *c2i::c2_memset(void *s, int c, size_t n)
{
	return memset(s, c, n);
}

void *c2i::c2_memcpy(void *dest, const void *src, size_t n)
{
	return memcpy(dest, src, n);
}

void c2i::c2_set_ram(int64_t base, int64_t size)
{
	if(RAM)
	{
		delete [] RAM;
		delete [] RAM_use;
	}
		
	RAM = new uint8_t[size];
	RAM_use = new uint8_t[size];
	
	memset(RAM, 0, size);
	memset(RAM_use, 0, size);
	
	RAM_base = base;
	RAM_size = size;
}