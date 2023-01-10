/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#define popen _popen
#define pclose _pclose
#endif

#include "c2/h/c2i.h"
#include "c2/h/c2b.h"

#include <cstdio>
#include <cstdarg>
#include <cstring>
#include <map>
#include <memory>
#include <algorithm>

#define ierror(...) c2_get_single()->c2_log(c2_eloglevel::error, nullptr, 0, __VA_ARGS__)
#define iwarning(...) c2_get_single()->c2_log(c2_eloglevel::warning, nullptr, 0, __VA_ARGS__)
#define iverbose(...) c2_get_single()->c2_log(c2_eloglevel::verbose, nullptr, 0, __VA_ARGS__)
#define iinfo(...) c2_get_single()->c2_log(c2_eloglevel::info, nullptr, 0, __VA_ARGS__)

template <typename T>
T swap_endian(T u)
{
    union
    {
        T u;
        unsigned char u8[sizeof(T)];
    } source, dest;

    source.u = u;

    for (size_t k = 0; k < sizeof(T); k++)
        dest.u8[k] = source.u8[sizeof(T) - k - 1];

    return dest.u;
}

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
	std::multimap<int64_t, std::string> sorted;
	
	for(auto i=registered_vars.begin(); i!=registered_vars.end(); i++)
	{
		if(!strstr(i->first.c_str(), "c2_auto_"))
			sorted.insert({i->second->get(),i->first});
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
// c2_file
///////////////////////////////////////////////////////////////////////////////

struct c2file_data
{
	FILE *fp = nullptr;
	int64_t size = 0;
};


c2i::c2_file::c2_file(const char *file)
{
	c2file_data *p = new c2file_data;
	pinternal = (void *)p;
	open(file);
}

c2i::c2_file::~c2_file()
{
	close();
	c2file_data *p = (c2file_data *)pinternal;
	delete p;
}

bool c2i::c2_file::open(const char *file)
{
	close();
	
	c2file_data *p = (c2file_data *)pinternal;
	sinternal *c2p = (sinternal *)c2_get_single()->pinternal;
	
	if(file)
	{
		p->fp = c2p->search_fopen(file);
		
		if(!p->fp)
		{
			ierror("File not found: %s", file);
			return false;
		}
		
		fseek(p->fp, 0, SEEK_END);
		p->size = (int64_t)ftell(p->fp);
		fseek(p->fp, 0, SEEK_SET);
		return true;
	}
	
	return false;
}

void c2i::c2_file::close()
{
	c2file_data *p = (c2file_data *)pinternal;
	if(p->fp)
	{
		fclose(p->fp);
		p->fp = nullptr;
		p->size = 0;
	}
}

int64_t c2i::c2_file::size()
{
	c2file_data *p = (c2file_data *)pinternal;
	return p->size;
}

int64_t c2i::c2_file::seek(int64_t newpos)
{
	c2file_data *p = (c2file_data *)pinternal;
	if(newpos < 0 || newpos > p->size)
	{
		ierror("Offset %d is beyond file size", int(newpos));
		return pos();
	}
	fseek(p->fp, long(newpos), SEEK_SET);
	return newpos;
}

int64_t c2i::c2_file::pos()
{
	c2file_data *p = (c2file_data *)pinternal;
	return (int64_t)ftell(p->fp);
}

bool c2i::c2_file::eof()
{
	c2file_data *p = (c2file_data *)pinternal;
	return feof(p->fp) != 0;
}

int64_t c2i::c2_file::pop8()
{
	c2file_data *p = (c2file_data *)pinternal;
	uint8_t d;
	fread(&d, 1, sizeof(d), p->fp);
	return d;
}

int64_t c2i::c2_file::pop16le()
{
	c2file_data *p = (c2file_data *)pinternal;
	uint16_t d;
	fread(&d, 1, sizeof(d), p->fp);
	return d;
}

int64_t c2i::c2_file::pop16be()
{
	c2file_data *p = (c2file_data *)pinternal;
	uint16_t d;
	fread(&d, 1, sizeof(d), p->fp);
	return swap_endian(d);
}

int64_t c2i::c2_file::pop32le()
{
	c2file_data *p = (c2file_data *)pinternal;
	uint32_t d;
	fread(&d, 1, sizeof(d), p->fp);
	return d;
}

int64_t c2i::c2_file::pop32be()
{
	c2file_data *p = (c2file_data *)pinternal;
	uint32_t d;
	fread(&d, 1, sizeof(d), p->fp);
	return swap_endian(d);
}

int64_t c2i::c2_file::pop64le()
{
	c2file_data *p = (c2file_data *)pinternal;
	int64_t d;
	fread(&d, 1, sizeof(d), p->fp);
	return d;
}

int64_t c2i::c2_file::pop64be()
{
	c2file_data *p = (c2file_data *)pinternal;
	int64_t d;
	fread(&d, 1, sizeof(d), p->fp);
	return swap_endian(d);
}

int64_t c2i::c2_file::read(void *ptr, int64_t size)
{
	c2file_data *p = (c2file_data *)pinternal;
	int rs = fread(ptr, 1, size, p->fp);
	return rs;
}

///////////////////////////////////////////////////////////////////////////////
// c2_sscope
///////////////////////////////////////////////////////////////////////////////

c2i::c2_sscope::c2_sscope(uint32_t fileindex, uint32_t line, uint32_t uid)
{
	c2i *i = c2i::c2_get_single();
	lix_backup = i->c2_lix;
	i->c2_lix = i->c2_scope_push(fileindex, line, uid);
}

c2i::c2_sscope::~c2_sscope()
{
	c2i *i = c2i::c2_get_single();
	i->c2_scope_pop();
	i->c2_lix = lix_backup;
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
	
	c2_cmd.add_info("--out", "-o", "<from> <to> [filename]: Outputs a binary. If no filename is given stdout will be used. To and from can be either addresses, labels or '-' or '+' as lowest/highest+1 address assembled.",2 ,3);
	c2_cmd.add_info("--out-c", "-C", "<from> <to> [filename]: Outputs a C-style formated hex array. Parameters are the same as for --out", 2, 3);
	c2_cmd.add_info("--dump-vars", "-V", "[filename]: Output variables. If no filename is given, stdout will be used", 0, 1);
	c2_cmd.add_info("--dump-enum", "-E", "[filename]: Output variables in C-style enum format. If no filename is given, stdout will be used", 0, 1);
	c2_cmd.add_info("--address-range", "-m", "<start> <end>: Set the valid memory address range available for the assembly to target. Addresses must be numerical", 2);
	c2_cmd.add_info("--assembly-hash", "-H", "Verbosly outputs a hash for each assembly step.");

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

void c2i::push8(int64_t b, bool isaddr)
{
	if(!var::inrange(8, b))
	{
		ierror("Byte overflow storing value %lld", b);
	}
	
	push(b);
}

void c2i::push16le(int64_t b, bool isaddr)
{
	if(!var::inrange(16, b))
	{
		ierror("Word overflow storing value %lld", b);
	}
	
	push(b&255);
	push(b>>8);
}

void c2i::push16be(int64_t b, bool isaddr)
{
	if(!var::inrange(16, b))
	{
		ierror("Word overflow");
	}
	
	push(b>>8);
	push(b);
}

void c2i::push32le(int64_t b, bool isaddr)
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

void c2i::push32be(int64_t b, bool isaddr)
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

void c2i::push64le(int64_t b, bool isaddr)
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

void c2i::push64be(int64_t b, bool isaddr)
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
	
	if(c2_assembly_hash)
	{
#ifndef _MSC_VER
		iinfo("%016lx%016lx", p->hash_state.hash.h1, p->hash_state.hash.h2);
#else
		iinfo("%016llx%016llx", p->hash_state.hash.h1, p->hash_state.hash.h2);
#endif
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
	p->scope_label_index_register.clear();
	
	memset(RAM, 0, RAM_size);
	memset(RAM_use, 0, RAM_size);
	
}

bool c2i::c2_assemble()
{
	sinternal *p = (sinternal *)pinternal;
	bool result = true;

	try
	{
		c2_pre();
		
		c2_cmd.invoke("--address-range", [&](int arga, const char *argc[])
		{
			int64_t from,to;
			
			if(!c2_resolve(argc[0], from, false))
				throw "--address-range could not resolve 'from' address";
			
			if(!c2_resolve(argc[1], to, false))
				throw "--address-range could not resolve 'to' address";
				
			if(from >= to || from < 0 )
				throw "--address-range addresses out of range";
				
			// Valid range of RAM
			c2_set_ram(from, to-from);
				
		});
		
		std::vector<cmur3::shash> history;
		
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
			
			if(!c2_assembly_hash)
			{
				fprintf(stderr, "Pass %d", pass);
			}
			c2_pass();
			p->hash_state.finalize();
			cmur3::shash hash = p->hash_state.hash;
			
			if(!c2_assembly_hash)
			{
				if(c2_verbose)
				{
#ifndef _MSC_VER
					fprintf(stderr, ": %016lx%016lx\n", hash.h1, hash.h2);
#else
					fprintf(stderr, ": %016llx%016llx\n", hash.h1, hash.h2);
#endif
				}
				else
				{
					fprintf(stderr, "\n");
				}
			}

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
	catch (...)
	{
		result = false;
		fprintf(stderr, "Unhandled exception\n");
	}

	std::vector<std::pair<c2_eloglevel, std::string>> &log = p->log;
	
	for(size_t r=0; r<log.size();r++)
	{
		c2_eloglevel level = log[r].first;
		
		if(level == c2_eloglevel::verbose && c2_verbose == false)
			continue;
		
		fprintf(stderr, "%s\n", log[r].second.c_str());

		if(level == c2_eloglevel::error)
		{
			result = false;
			break;
		}
	}
	
	if(result)
	{
		try
		{
			c2_cmd.add_args(p->added_arg.c_str());
			c2_post();
		}
		catch(const char *str)
		{
			result = false;
			std::string out = "error: ";
			out += str;
			fprintf(stderr, "%s\n", out.c_str());
		}
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

bool c2i::c2_resolve(const char *addr, int64_t &out, bool allow_labels)
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
		
		if(!allow_labels)
			return false;
		
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
#ifndef _MSC_VER
		sscanf(p, "%ld", &out);
#else
		sscanf(p, "%lld", &out);
#endif
		break;
	case oct:
#ifndef _MSC_VER
		sscanf(p, "%lo", &out);
#else
		sscanf(p, "%llo", &out);
#endif
		break;
	case hex:
#ifndef _MSC_VER
		sscanf(p, "%lx", &out);
#else
		sscanf(p, "%llx", &out);
#endif
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
	c2_cmd.invoke("--assembly-hash", [&](int arga, const char *argc[])
	{
		c2_assembly_hash = true;
	});
}

void c2i::c2_post()
{
	sinternal *p = (sinternal *)pinternal;
	
	c2_cmd.invoke("--out", [&](int arga, const char *argc[])
	{
		int64_t from,to;
		
		if(!c2_resolve(argc[0], from))
			throw "--out could not resolve 'from' address";
		
		if(!c2_resolve(argc[1], to))
			throw "--out could not resolve 'to' address";
			
		if(from > to || from < RAM_base || from > RAM_base+RAM_size || to < RAM_base || to > RAM_base+RAM_size)
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
	
	c2_cmd.invoke("--out-c", [&](int arga, const char *argc[])
	{
		int64_t from,to;
		
		if(!c2_resolve(argc[0], from))
			throw "--out-c could not resolve 'from' address";
		
		if(!c2_resolve(argc[1], to))
			throw "--out-c could not resolve 'to' address";
			
		if(from > to || from < RAM_base || from > RAM_base+RAM_size || to < RAM_base || to > RAM_base+RAM_size)
			throw "--out-c addresses out of range";
			
		FILE *fp = stdout;
		if(arga == 3)
		{
			fp = fopen(argc[2], "wb");
			if(!fp)
				throw "--out-c could not open file for writing";
		}
		
		fprintf(fp,"unsigned char c_%s[]={", p->title.c_str());
		
		int64_t size = to - from;
		const int64_t W = 8;
		for(int64_t r = 0; r < size; r++)
		{
			int b = RAM[from-RAM_base+r];
			if(r % W == 0)
			{
				fprintf(fp,"\n\t");
			}
			
			fprintf(fp,"0x%02x",b);
			
			if(r != size - 1)
			{
				fprintf(fp,",");
			}
		}
		
		fprintf(fp,"\n};\n");
		
		if(fp != stdout)
			fclose(fp);
	});
	
	c2_cmd.invoke("--dump-vars", [p](int arga, const char *argc[])
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
	
	c2_cmd.invoke("--dump-enum", [p](int arga, const char *argc[])
	{
		FILE *fp = stdout;
		if(arga)
		{
			fp = fopen(argc[0], "w");
			if(!fp)
				throw "--dump-enum could not open file for writing";
		}

		std::vector<std::pair<std::string, int64_t>> sorted;
		p->get_sorted_vars(sorted);
		
		fprintf(fp, "enum e_%s{\n", p->title.c_str());
			
		for(size_t r=0;r<sorted.size();r++)
		{
			std::string tmp = sorted[r].first;
			std::replace(tmp.begin(), tmp.end(), '.', '_');

			fprintf(fp, "\t%s = 0x%lx%s\n", tmp.c_str(), sorted[r].second, (r != sorted.size()-1 ? "," : ""));
		}
		fprintf(fp, "};\n");
		
		if(fp != stdout)
			fclose(fp);
	});
	
}

void c2i::loadbin(const char *path, size_t offset, size_t length)
{
	
	c2_file fp;
	
	if(!fp.open(path))
	{
		return;
	}
	
	int64_t size = fp.size();
	
	if(offset > size)
	{
		ierror("Requested offset (%d) to is beyond the file size for: %s", int(offset), path);
		return;
	}
	
	fp.seek(offset);
		
	int64_t toread;
	
	if(length == size_t(-1))
	{
		toread = size - offset;
	}
	else if(length > size - offset)
	{
		iwarning("Requested size (%d) to read is larger than the file size for: %s", int(length), path);
		toread = size - offset;
	}
	else
	{
		toread = length;
	}

	for(size_t r=0; r<toread; r++)
	{
		push(fp.pop8());
	}
}

c2i::var c2i::loadvar(const char *path, size_t offset, size_t length)
{
	var v;
	c2_file fp;
	
	if(!fp.open(path))
	{
		return v;
	}
	
	int64_t size = fp.size();
	
	if(offset > size)
	{
		ierror("Requested offset (%d) to is beyond the file size for: %s", int(offset), path);
		return v;
	}
	
	fp.seek(offset);
		
	int64_t toread;
	
	if(length == size_t(-1))
	{
		toread = size - offset;
	}
	else if(length > size - offset)
	{
		iwarning("Requested size (%d) to read is larger than the file size for: %s", int(length), path);
		toread = size - offset;
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
			v[r] = fp.pop8();
		}
	}

	return v;
}

void c2i::loadstream(const char *cmd, size_t offset, size_t length)
{
#ifdef _WIN32
	std::string command = cmd;
	command = "\"" + command + "\"";
	FILE *ep = popen(command.c_str(), "rb");
#else
	FILE *ep = popen(cmd, "r");
#endif

	if(!ep)
	{
		ierror("Error executing stream command: %s", cmd);
		return;
	}

	int n;
	size_t count = 0;
	uint8_t b;
	
	while(count < offset)
	{
		n = fread(&b, 1, sizeof(b), ep);
		if(!n)
		{
			ierror("Requested offset (%d) to is beyond the end of the stream", int(offset));
			pclose(ep);
			return;
		}
		count++;
	}
	
	count = 0;
	
	while(count < length)
	{
		n = fread(&b, 1, sizeof(b), ep);
		if(!n)
		{
			break;
		}
		push(b);
		count++;
	}
	
	pclose(ep);
}

void c2i::c2_add_arg(const char *format, ...)
{
	va_list args;
	
	va_start (args, format);
	int n = vsnprintf (nullptr, 0, format, args);
	va_end (args);
	
	char *buffer = new char[n+8];
	
	va_start (args, format);
	vsnprintf (buffer, n + 8, format, args);
	va_end (args);
	
	sinternal *p = (sinternal *)pinternal;
	p->added_arg = buffer;
	
	delete [] buffer;
}

int64_t c2i::c2_scope_push(uint32_t fileindex, uint32_t line, uint32_t uid)
{
	sinternal *p = (sinternal *)pinternal;
	p->stack_history.push_back(sdebugstack(fileindex, line));
	
	auto i = p->scope_label_index_register.find(uid);
	if(i == p->scope_label_index_register.end())
	{
		p->scope_label_index_register.insert({uid, 0});
		return 0;
	}
	
	i->second++;
	return i->second;
}

void c2i::c2_scope_pop()
{
	sinternal *p = (sinternal *)pinternal;
	p->stack_history.pop_back();
}

void c2i::c2_config_setup_info(const char *title, bool verbose)
{
	sinternal *p = (sinternal *)pinternal;
	p->title = title;
	c2_verbose = verbose;
}

void c2i::c2_config_setup_file(const char *file)
{
	sinternal *p = (sinternal *)pinternal;
	p->files.push_back(file);
}

void c2i::c2_config_setup_include(const char *include)
{
	sinternal *p = (sinternal *)pinternal;
	p->include_paths.push_back(include);
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
		case c2_eloglevel::verbose:
			out += "verbose: ";
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