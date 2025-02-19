﻿/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "c2/commodore/cbm.h"
#include "c2/h/c2b.h"

#define CRT_SECURE_NO_WARNINGS 1
#include <cstring>
#include <cstdio>
#include <cstdarg>
#include <climits>

#ifdef _WIN32
#define strcasecmp _stricmp
#endif

struct sc64internal
{
	std::vector<std::string> vice_cmd;
};

cbm::cbm(cmdi *pcmd)
: c2i(pcmd)
{
	c2_cmd.declare("--out-prg", "-P", "<from> <to> [filename]: Outputs a Commodore PRG. Parameters are the same as for --out", 2, 3);
	c2_cmd.declare("--vice-cmd", "-M", "[filename]: Outputs a VICE compatible monitor command file containing labels and breakpoints. Use -moncommands <filename> as VICE arguments.", 0, 1);
	
	sc64internal *p = new sc64internal;
	c64_internal = (void *)p;
}

cbm::~cbm()
{
	if(c64_internal)
	{
		sc64internal *p = (sc64internal *)c64_internal;
		delete p;
	}
}

char cbm::ascii2screen(char i)
{
	static const char *c64ascii2screentab="@abcdefghijklmnopqrstuvwxyz[~]^_ !\"#$%&'()*+,-./0123456789:;<=>?\\ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	const char *p = strchr(c64ascii2screentab, i ? i : '@');
	return p?int(p-c64ascii2screentab):i;
}

char cbm::ascii2petscii(char i)
{
	if(i >= 96)
		i -= 32;
	else if(i >= 64)
		i += 32;
	
	return i;
}

void cbm::basic_v2(const char *format, ...)
{
	va_list args;
	
	va_start (args, format);
	int n = vsnprintf (nullptr, 0, format, args);
	va_end (args);
	
	char *buffer = new char[n+8];
	
	va_start (args, format);
	vsnprintf (buffer, n + 8, format, args);
	va_end (args);
	
	char *p = buffer;
	
	static char cmd[][8]=
	{
		"end","for",
		"next","data",
		"input#",
		"input",
		"dim",
		"read",
		"let",
		"goto",
		"run",
		"if",
		"restore",
		"gosub",
		"return",
		"rem",
		"stop",
		"on",
		"wait",
		"load",
		"save",
		"verify",
		"def",
		"poke",
		"print#",
		"print",
		"cont",
		"list",
		"clr",
		"cmd",
		"sys",
		"open",
		"close",
		"get",
		"new",
		"tab(",
		"to",
		"fn",
		"spc(",
		"then",
		"not",
		"step",
		"+",
		"-",
		"*",
		"/",
		"^",
		"and",
		"or",
		">",
		"=",
		"<",
		"sgn",
		"int",
		"abs",
		"usr",
		"fre",
		"pos",
		"sqr",
		"rnd",
		"log",
		"exp",
		"cos",
		"sin",
		"tan",
		"atn",
		"peek",
		"len",
		"str$",
		"val",
		"asc",
		"chr$",
		"left$",
		"right$",
		"mid$",
		"go",
		"",
	};
	
	while(*p)
	{
		int quote = 0;
		
		// Back up org pointers
		c2_corg_backup org_backup = c2_backup_org();

		// Push a dummy 16 bit value
		push16le(0);
		
		int line;
		sscanf(p, "%d", &line);
		push16le(line);
		
		while((*p >= '0' && *p <= '9') || *p == ' ')p++;
			
		while(*p)
		{
			if(*p == '\"')
				quote = 1 - quote;
				
			bool found = false;
			int r;
			size_t n = 0;
			for(r=0;!quote;r++)
			{
				n = strlen(cmd[r]);
				if(!n)break;
				if(!strncmp(p, cmd[r], n))
				{
					found = true;
					break;
				}
			}

			if(found)
			{
				push8(0x80+r);
				p+=n;
			}
			else  if(*p != 0x0d)
			{
				push8(ascii2petscii(*p));
				p++;
			}

			if(*p == 0x0a)
			{
				p++;
				break;
			}
		}
		push8(0);
		
		// Back up org pointers
		cint pointer = c2_org.porg->a;
		c2_corg_backup org_backup_end = c2_backup_org();

		bool allow_overwrite_backup = c2_allow_overwrite;
		c2_allow_overwrite = true;
		
		// Restore to previous backup and dummy value
		c2_restore_org(org_backup);
		push16le(pointer);

		// Finally restore
		c2_restore_org(org_backup_end);
		c2_allow_overwrite = allow_overwrite_backup;
		
		if(!*p)
			break;
	}
	
	push16le(0);
	
	delete [] buffer;
}

void cbm::c2_post()
{
	c2i::c2_post();

	c2_cmd.invoke("--out-prg", [&](int arga, const char *argc[])
	{
		int64_t from,to;
		
		if(!c2_resolve(argc[0], from))
			throw "--out-prg could not resolve 'from' address";
		
		if(!c2_resolve(argc[1], to))
			throw "--out-prg could not resolve 'to' address";
			
		if(from > to || from < RAM->base || from > RAM->base+RAM->size || to < RAM->base || to > RAM->base+RAM->size)
			throw "--out-prg addresses out of range";

		FILE *fp = stdout;
		if(arga == 3)
		{
			fp = fopen(argc[2], "wb");
			if(!fp)
				throw "--out-prg could not open file for writing";
		}
		
		uint16_t hdr = uint16_t(from);
		fwrite(&hdr, 1, sizeof(hdr), fp);
		fwrite(RAM->ptr+from-RAM->base, 1, to - from, fp);
		
		if(fp != stdout)
			fclose(fp);
	});
	
	c2_cmd.invoke("--vice-cmd", [&](int arga, const char *argc[])
	{
		FILE *fp = stdout;
		if(arga == 1)
		{
			fp = fopen(argc[0], "wb");
			if(!fp)
				throw "--vice-cmd could not open file for writing";
		}
		
		sinternal *c2ip = (sinternal *)c2_get_internal();
		std::vector<std::pair<std::string, int64_t>> sorted;
		c2ip->get_sorted_vars(sorted);
		
		for(size_t r=0;r<sorted.size();r++)
		{
			fprintf(fp, "add_label %04lx .%s\n", sorted[r].second, sorted[r].first.c_str());
		}
		
		sc64internal *c64ip = (sc64internal *)c64_internal;
		
		for(size_t r=0;r<c64ip->vice_cmd.size();r++)
		{
			fprintf(fp, "%s\n", c64ip->vice_cmd[r].c_str());
		}
		
		if(fp != stdout)
			fclose(fp);
	});
}

void cbm::vice_cmd(var v)
{
	std::string tmp;
	for(size_t r=0;r<v.size();r++)
	{
		tmp += char(v[r]);
	}
	
	char s[16];
	sprintf(s,"%lx", c2_org.porg->a);
		
	size_t r;
	while((r = tmp.find('@')) != tmp.npos)
	{
		tmp.replace(r, 1, s);
	}
	
	sc64internal *p = (sc64internal *)c64_internal;
	p->vice_cmd.push_back(tmp);
}

void cbm::c2_reset_pass()
{
	c2i::c2_reset_pass();
	
	sc64internal *p = (sc64internal *)c64_internal;
	p->vice_cmd.clear();
}

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

cbm::sid cbm::load_sid(const char *path)
{
	sid obj;

	struct shead
	{
		uint32_t magic;
		uint16_t version;
		uint16_t offset;
		uint16_t load_address;
		uint16_t init_address;
		uint16_t play_address;
		uint16_t songs;
		uint16_t start_song;
		uint32_t speed;		//Big endian
	}head;
	
	c2_file fp;
	if(!fp.open(path))
	{
		c2_error("SID file not found");
		return obj;
	}

	fp.read(&head, sizeof(head));
	
	long offset = swap_endian(head.offset);
	uint16_t load_address = swap_endian(head.load_address);
	obj.init = swap_endian(head.init_address);
	obj.play = swap_endian(head.play_address);

	fp.seek(offset);
	if(!load_address)
	{
		fp.read(&load_address, sizeof(load_address));
	}

	obj.address = load_address;

	size_t size = fp.size() - fp.pos();
	obj.size = size;

	for(size_t r=0;r<size;r++)
	{
		obj.data[r] = fp.pop8();
	}
	
	c2_verbose("SID $%04x-$%04x, init $%04x, play $%04x", int(load_address), int(load_address+size), int(obj.init), int(obj.play));

	return obj;
}

void cbm::place_sid(sid &obj)
{
	for(size_t r=0; r<obj.data.size(); r++)
	{
		push8(obj.data[r]);
	}
}

int64_t cbm::incprgorg(const char *file, size_t offset, size_t length)
{
	c2_file fp;

	if(!fp.open(file))
	{
		return 0;
	}

	int64_t size = fp.size();

	if(size < 2)
	{
		c2_error("A PRG file must at least be 2 bytes: %s", file);
		return 0;
	}

	int64_t o = fp.pop16le();

	c2_org = o;

	loadbin(file, 2, length);

	return o;
}
