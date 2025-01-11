/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "c2/c64/c64.h"

#include <cstring>
#include <cstdio>
#include <vector>

#ifdef _WIN32
#define strcasecmp _stricmp
#endif

c64::c64(cmdi *pcmd)
: cbm(pcmd)
{
	// Default org if nothing is set
	c2_org = 0x0801;
	
	// Valid range of RAM
	c2_set_ram(0, 0x10000);

	c2_cmd.declare("--out-rle", "-R", "<from> <to> <start> [filename] [--sei] [--1 <value>] Outputs a Commodore RLE compressed PRG. Can compress $0200-$ffff. Parameters are similar to --out with exception for the start address/label that can also take 'basic_startup' as argument", 3, 4);
}

c64::~c64()
{
}

void c64::c2_pre()
{
	cbm::c2_pre();
}

void c64::c2_reset_pass()
{
	cbm::c2_reset_pass();
}

void c64::c2_post()
{
	cbm::c2_post();

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

		if(from < 0x0200 || from > to || from < RAM->base || from >= RAM->base+RAM->size || to < RAM->base || to > RAM->base+RAM->size)
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
		uint8_t *ram = RAM->ptr+from-RAM->base;

		int lit = 0;

		// To be decompressed backwards, start with a zero terminate
		stream.push(0, 1);

		// Main loop
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
				depack_from = safe_depack_base + move_bytes;
			}
			else
			{
				depack_from = save_to + stream.stream.size() - move_bytes;
			}

			memcpy(staging+save_to, &stream.stream[move_bytes], stream.stream.size() - move_bytes);
			save_to += int(stream.stream.size()) - move_bytes;

			move_from = save_to;

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
}
