/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include <string>
#include <unordered_map>
#include <vector>
#include <cstdio>

///////////////////////////////////////////////////////////////////////////////
// cmur3 adapted murmur3 hash
///////////////////////////////////////////////////////////////////////////////
#if defined(_MSC_VER)
#define ROTL64(x,y)	_rotl64(x,y)
#define BIG_CONSTANT(x) (x)
#else	// defined(_MSC_VER)
inline uint64_t rotl64(uint64_t x, int8_t r ){return (x << r) | (x >> (64 - r));}
#define ROTL64(x,y)	rotl64(x,y)
#define BIG_CONSTANT(x) (x##LLU)
#endif // !defined(_MSC_VER)

class cmur3
{
public:
	cmur3(uint64_t s = 0)
	{
		seed(s);
	}
	
	void seed(uint64_t s = 0)
	{
		hash.h1 = hash.h2 = s;
		len = 0;
	}
	
	struct shash
	{
		uint64_t h1;
		uint64_t h2;
	}hash;
	
	void finalize()
	{
		if(len&15)
		{
			int l = int(len);
			while(l&15)
			{
				key[l&15] = 0;
				l++;
			}
			update_block(key);
		}
		
		uint64_t h1 = hash.h1;
		uint64_t h2 = hash.h2;
		
		h1 ^= len; h2 ^= len;

		h1 += h2;
		h2 += h1;

		h1 = fmix64(h1);
		h2 = fmix64(h2);

		h1 += h2;
		h2 += h1;
		
		hash.h1 = h1;
		hash.h2 = h2;
	}
	
	void push8(uint8_t b)
	{
		key[len&15] = b;
		len++;
		if((len&15) == 0)
			update_block(key);
	}
	
	void push128(void *inkey)	// Don't use in the same session as push8
	{
		update_block(inkey);
		len += 16;
	}
	
private:
	static uint64_t fmix64 (uint64_t k)
	{
		k ^= k >> 33;
		k *= BIG_CONSTANT(0xff51afd7ed558ccd);
		k ^= k >> 33;
		k *= BIG_CONSTANT(0xc4ceb9fe1a85ec53);
		k ^= k >> 33;

		return k;
	}
	
	void update_block(void *inkey)
	{
		const uint64_t c1 = BIG_CONSTANT(0x87c37b91114253d5);
		const uint64_t c2 = BIG_CONSTANT(0x4cf5ad432745937f);

		const uint64_t * blocks = (const uint64_t *)(inkey);
		
		uint64_t h1 = hash.h1;
		uint64_t h2 = hash.h2;

		uint64_t k1 = blocks[0];
		uint64_t k2 = blocks[1];

		k1 *= c1; k1  = ROTL64(k1,31); k1 *= c2; h1 ^= k1;
		h1 = ROTL64(h1,27); h1 += h2; h1 = h1*5+0x52dce729;
		k2 *= c2; k2  = ROTL64(k2,33); k2 *= c1; h2 ^= k2;
		h2 = ROTL64(h2,31); h2 += h1; h2 = h2*5+0x38495ab5;
		
		hash.h1 = h1;
		hash.h2 = h2;
	}
	
	uint64_t len;
	uint8_t key[16];
};

///////////////////////////////////////////////////////////////////////////////
// c2i misc
///////////////////////////////////////////////////////////////////////////////

struct sdebugstack
{
	sdebugstack(int32_t ifileindex, int32_t iline)
	: fileindex(ifileindex)
	, line(iline)
	{}
	uint32_t fileindex;
	uint32_t line;
};

struct sinternal
{
	cmur3 hash_state;
	std::vector<sdebugstack> stack_history;
	std::vector<std::pair<c2i::c2_eloglevel, std::string>> log;
	std::vector<std::string> files;
	std::vector<std::string> include_paths;
	std::unordered_map<std::string, c2i::c2_vardata *> registered_vars;
	
	void get_sorted_vars(std::vector<std::pair<std::string, int64_t>> &out);
	bool lookup_var(const std::string &in, int64_t &out);
	
	FILE *search_fopen(const char *file)
	{
		FILE *fp = fopen(file, "rb");
		if(fp)
			return fp;
		
		std::string tmp = file;
		
		if(!tmp.size())
			return nullptr;
			
		//Is absolute? TODO Fix for windows
		if(tmp[0] == '/')
			return nullptr;
		
		for(size_t r=0; r<include_paths.size(); r++)
		{
			tmp = include_paths[r] + file;
			FILE *fp = fopen(tmp.c_str(), "rb");
			if(fp)
				return fp;
		}
		
		return nullptr;
	}
	
};
