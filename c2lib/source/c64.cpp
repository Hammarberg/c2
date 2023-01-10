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

#ifdef _WIN32
#define strcasecmp _stricmp
#endif


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
	
	c2_cmd.add_info("--out-prg", "-P", "<from> <to> [filename]: Outputs a Commodore PRG. Parameters are the same as for --out", 2, 3);
	c2_cmd.add_info("--out-rle", "-R", "<from> <to> <start> [filename] [--sei] [--1 <value>] Outputs a Commodore RLE compressed PRG. Can compress $0200-$ffff. Parameters are similar to --out with exception for the start address/label that can also take 'basic_startup' as argument", 3, 4);
	c2_cmd.add_info("--vice-cmd", "-M", "[filename]: Outputs a VICE comapatible monitor command file contianing labels and breakpoints. Use -moncommands <filename> as VICE arguments.", 0, 1);
	
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
	
	c2_cmd.invoke("--out-prg", [&](int arga, const char *argc[])
	{
		int64_t from,to;
		
		if(!c2_resolve(argc[0], from))
			throw "--out-prg could not resolve 'from' address";
		
		if(!c2_resolve(argc[1], to))
			throw "--out-prg could not resolve 'to' address";
			
		if(from > to || from < RAM_base || from > RAM_base+RAM_size || to < RAM_base || to > RAM_base+RAM_size)
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
	
	bool sei = false;
	c2_cmd.invoke("--sei", [&](int arga, const char *argc[])
	{
		sei = true;
	});
	
	int64_t z1 = 0x37;
	c2_cmd.invoke("--1", [&](int arga, const char *argc[])
	{
		if(!c2_resolve(argc[0], z1))
			throw "-1 could not resolve 1 value";
	}, 1);
	
	c2_cmd.invoke("--out-rle", [&](int arga, const char *argc[])
	{
		int64_t from,to,start;
		
		if(!c2_resolve(argc[0], from))
			throw "--out-rle could not resolve 'from' address";
		
		if(!c2_resolve(argc[1], to))
			throw "--out-rle could not resolve 'to' address";
			
		if(from < 0x0200 || from > to || from < RAM_base || from >= RAM_base+RAM_size || to < RAM_base || to >= RAM_base+RAM_size)
			throw "--out-rle addresses out of range";

		bool basic_startup = false;
		if(strcasecmp(argc[2],"basic_startup"))
		{
			if(!c2_resolve(argc[2], start))
				throw "--out-rle could not resolve 'start' address";
		}
		else
		{
			basic_startup = true;
			start = 0xa659;
			
			if(from > 0x0800)
				from = 0x0800;
		}
			
		struct
		{
			std::vector<uint8_t> stream;
			int save = 0;
			int safe = 0;

			void push(int n, int gain)
			{
				save += gain;
				if(save > safe)
					safe = save;
				
				stream.push_back(n & 255);
			}
		}stream;

		int size = int(to - from);
		uint8_t *ram = RAM+from-RAM_base;
		
		int lit = 0;
		
		// To be decompressed backwards, start with a zero terminate
		stream.push(0, 1);
		
		for(int r = 0; r<size;)
		{
			int l;
			uint8_t b = ram[r];
			for(l=1; r+l<size && l<128; l++)
			{
				if(b != ram[r+l])
					break;
			}
			
			if(l >= 3)
			{
				if(lit)
				{
					stream.push(lit, 1);
					lit = 0;
				}
				
				stream.push(b, 1);
				int t = 0 - l;
				stream.push(t, t + 1);
				
				r += l;
			}
			else
			{
				lit++;
				stream.push(b, 0);
				
				if(lit == 127)
				{
					stream.push(lit, 1);
					lit = 0;
				}
				r++;
			}
		}
		if(lit)
		{
			stream.push(lit, 1);
			lit = 0;
		}
		
		// Configure depacker
#include "c64_depack.c"
#include "c64_depack_enum.c"
		
		uint8_t staging[0x10000*2];
		int save_to = 0x0801;
		memcpy(staging+save_to, c_rle, sizeof(c_rle));
		save_to += int(sizeof(c_rle));
		
		int packed_data = save_to;
		
		int safe_depack_base = int(from) - (stream.safe + 1);
		
		int move_bytes = 0;
		int move_from = 0;
		int depack_from;
		int depack_to = int(to);
		
		int packed_stream_start = save_to;
		int packed_stream_end = save_to + int(stream.stream.size());
		
		if(packed_data <= safe_depack_base || from >= packed_stream_end || to <= packed_stream_start)
		{
			// No move
			memcpy(staging+save_to, &stream.stream[0], stream.stream.size());
			save_to += int(stream.stream.size());
			
			depack_from = save_to;
			
			move_bytes = 0;
			move_from = 0;
			safe_depack_base = 0;
		}
		else
		{
			// Move
			move_bytes = packed_data - safe_depack_base;
			
			if(move_bytes > int(stream.stream.size()))
			{
				move_bytes = int(stream.stream.size());
			}
			
			memcpy(staging+save_to, &stream.stream[move_bytes], stream.stream.size() - move_bytes);
			save_to += int(stream.stream.size()) - move_bytes;
			
			move_from = save_to;
			depack_from = save_to;
			
			memcpy(staging+save_to, &stream.stream[0], move_bytes);
			save_to += move_bytes;
		}
		
		if(save_to > 0xd000)
		{
			throw "--out-rle could not compress to a 202 block PRG. Use a cruncher!";
		}
		
		// Configure depacker
		int offset = 256 - (move_bytes & 255);
		
		/*
		printf(
		"move_bytes       %x\n"
		"offset           %x\n"
		"move_from        %x\n"
		"safe_depack_base %x\n"
		"depack_to        %x\n"
		"depack_from      %x\n",
		move_bytes,
		offset,
		move_from,
		safe_depack_base,
		depack_to,
		depack_from);
		*/
		
		staging[copystart + depack_csl - depack + 1] = uint8_t(offset);
		staging[copystart + depack_csh - depack + 1] = uint8_t(move_bytes  >> 8);
		
		staging[copystart + depack_cs - depack + 1] = uint8_t((move_from - offset) & 255);
		staging[copystart + depack_cs - depack + 2] = uint8_t((move_from - offset) >> 8);
		
		staging[copystart + depack_cd - depack + 1] = uint8_t((safe_depack_base - offset) & 255);
		staging[copystart + depack_cd - depack + 2] = uint8_t((safe_depack_base - offset) >> 8);
		
		staging[copystart + depack_da - depack + 1] = uint8_t(depack_to & 255);
		staging[copystart + depack_da - depack + 2] = uint8_t(depack_to  >> 8);
		
		staging[copystart + depack_sa - depack + 1] = uint8_t(depack_from & 255);
		staging[copystart + depack_sa - depack + 2] = uint8_t(depack_from  >> 8);
		
		staging[copystart + depack_one - depack + 1] = uint8_t(z1);
		
		if(sei)
			staging[copystart + depack_cli - depack + 0] = 0xea;
		
		if(!basic_startup)
			staging[copystart + depack_jump - depack + 0] = 0x4c;
			
		staging[copystart + depack_jump - depack + 1] = uint8_t(start & 255);
		staging[copystart + depack_jump - depack + 2] = uint8_t(start  >> 8);
		
		// Save
		FILE *fp = stdout;
		if(arga == 4)
		{
			fp = fopen(argc[3], "wb");
			if(!fp)
				throw "--out-rle could not open file for writing";
		}
		
		uint16_t prg = 0x0801;
		fwrite(&prg, 1, sizeof(prg), fp);
		
		fwrite(staging+prg, 1, save_to-prg, fp);
		
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
	
	c2_file fp;
	if(!fp.open(path))
	{
		c2_error("SID file not found");
		return;
	}

	fp.read(&head, sizeof(head));
	
	long offset = swap_endian(head.offset);
	uint16_t load_address = swap_endian(head.load_address);
	init = swap_endian(head.init_address);
	play = swap_endian(head.play_address);

	fp.seek(offset);
	if(!load_address)
	{
		fp.read(&load_address, sizeof(load_address));
	}
	
	int64_t write = load_address;
	while(!fp.eof())
	{
		c2_poke(write, fp.pop8());
		write++;
	}
	
	c2_verbose("SID $%04x-$%04x, init $%04x, play $%04x", int(load_address), int(write), int(init), int(play));
}
