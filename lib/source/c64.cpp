/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "c2/c64/c64.h"
#include "c2/h/c2b.h"
#define CRT_SECURE_NO_WARNINGS 1
#include <cstring>
#include <cstdio>
#include <cstdarg>
#include <climits>

struct sc64internal
{
	std::vector<std::string> vice_cmd;
};

c64::c64(cmdi *pcmd)
: c2i(pcmd)
{
	// Default org if nothing is set
	c2_org = 0x1000;
	
	// Valid range of RAM
	c2_set_ram(0, 0x10000);
	
	c2_cmd.add_info("--out-prg", "-op", "<from> <to> [filename]: Outputs a Commodore PRG. Parameters are the same as for --out");
	c2_cmd.add_info("--vice-cmd", "-vc", "[filename]: Outputs a VICE comapatible monitor command file contianing labels and breakpoints. Use -moncommands <filename> as VICE arguments.");
	
	sc64internal *p = new sc64internal;
	c64_internal = (void *)p;
}

c64::~c64()
{
	if(c64_internal)
	{
		sc64internal *p = (sc64internal *)c64_internal;
		delete p;
	}
}

char c64::ascii2screen(char i)
{
	static const char *c64ascii2screentab="@abcdefghijklmnopqrstuvwxyz[~]^_ !\"#$%&'()*+,-./0123456789:;<=>?\\ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	const char *p = strchr(c64ascii2screentab, i ? i : '@');
	return p?int(p-c64ascii2screentab):i;
}

char c64::ascii2petscii(char i)
{
	if(i >= 96)
		i -= 32;
	else if(i >= 64)
		i += 32;
	
	return i;
}

void c64::basic(const char *format, ...)
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
		int64_t save_a, save_w;
		c2_org.backup(save_a, save_w);
		
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
			else
			{
				push8(ascii2petscii(*p));
				p++;
			}
			if(*p == '\n')
			{
				p++;
				break;
			}
		}
		push8(0);
		
		// Back up org pointers
		int64_t restore_a, restore_w;
		c2_org.backup(restore_a, restore_w);
		bool allow_overwrite_backup = c2_allow_overwrite;
		c2_allow_overwrite = true;
		
		// Restore to previous backup and dummy value
		c2_org.restore(save_a, save_w);
		push16le(restore_a);
		
		// Finally restore
		c2_org.restore(restore_a, restore_w);
		c2_allow_overwrite = allow_overwrite_backup;
		
		if(!*p)
			break;
	}
	
	push16le(0);
	
	delete [] buffer;
}

void c64::c2_post()
{
	c2i::c2_post();
	
	c2_cmd.invoke("--out-prg", 2, 3, [&](int arga, const char *argc[])
	{
		int64_t from,to;
		
		if(!c2_resolve(argc[0], from))
			throw "--out-prg could not resolve 'from' address";
		
		if(!c2_resolve(argc[1], to))
			throw "--out-prg could not resolve 'to' address";
			
		if(from > to || from < RAM_base || from >= RAM_base+RAM_size || to < RAM_base || to >= RAM_base+RAM_size)
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
		fwrite(RAM+from-RAM_base, 1, to - from, fp);
		
		if(fp != stdout)
			fclose(fp);
	});
	
	c2_cmd.invoke("--vice-cmd", 0, 1, [&](int arga, const char *argc[])
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
			fprintf(fp, "add_label %04x .%s\n", sorted[r].second, sorted[r].first.c_str());
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

void c64::c64_vice(var v)
{
	std::string tmp;
	for(size_t r=0;r<v.size();r++)
	{
		tmp += char(v[r]);
	}
	
	char s[16];
	sprintf(s,"%lx", c2_org.orga);
		
	size_t r;
	while((r = tmp.find('@')) != tmp.npos)
	{
		tmp.replace(r, 1, s);
	}
	
	sc64internal *p = (sc64internal *)c64_internal;
	p->vice_cmd.push_back(tmp);
}

void c64::c2_reset_pass()
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

void c64::loadsid(const char *path, var &init, var &play)
{
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
	
	FILE *fp = fopen(path, "rb");
	if(!fp)
	{
		error("SID file not found");
		return;
	}
	
	fread(&head, 1, sizeof(head), fp);
	
	long offset = swap_endian(head.offset);
	uint16_t load_address = swap_endian(head.load_address);
	init = swap_endian(head.init_address);
	play = swap_endian(head.play_address);

	fseek(fp, offset, SEEK_SET);
	if(!load_address)
	{
		fread(&load_address, 1, sizeof(load_address), fp);
	}
	
	int64_t write = load_address;
	uint8_t b;
	while(fread(&b, 1, 1, fp))
	{
		c2_poke(write, b);
		write++;
	}
	
	verbose("SID $%04x-$%04x, init $%04x, play $%04x", int(load_address), int(write), int(init), int(play));
	
	fclose(fp);
}
