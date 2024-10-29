/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once

#include "token.h"
#include "lines.h"
#include <cassert>
#include <vector>
#include <unordered_map>

class tokline : public slines
{
public:

	tokline(slinear_alloc<> &inmem, std::vector<std::string> &hfiles)
	: slines(inmem)
	, mem(inmem)
	, files(hfiles)
	{
		files.push_back("");
		filemap[""] = 0;
	}
	
	stok *pull_tok();
	
private:
	slinear_alloc<> &mem;
	
	const char *psstr = nullptr;
	size_t sline_number = 0;
	std::string stmp;
	uint16_t ord = 0;
	
	std::vector<std::string> &files;
	std::unordered_map<std::string, uint16_t> filemap;
	
	uint16_t fileindex = 0;
	eflag flag = NOTSET;
	uint32_t line = 0;

	int pre = 0;
	uint16_t new_fileindex = 0;
	uint16_t new_flag = 0;
	uint32_t new_line = 0;
};

class tokoutfile
{
public:

	tokoutfile(const char *file)
	{
		fp = fopen(file,"w");
		assert(fp);
	}
	
	~tokoutfile()
	{
		fclose(fp);
	}

	void push_tok(stok *o);
	
private:
	FILE *fp;
	std::string stmp;
};

class toklink
{
public:
	
	toklink();
	toklink(const toklink &o);
	toklink &operator=(const toklink &o);
	~toklink();
	
	void restart(stok *op = nullptr, stok *oe = nullptr);
	void terminate(stok *o = nullptr);
	
	stok *get_pos();
	stok *get_end();
	stok *pull_tok();
	void push_tok(stok *p);
	void unlink(stok *i);
	stok *link(stok *i, stok *a);
	
	int count() const;

	bool operator==(const toklink &o) const;
	
	static stok TEND;
	stok *pos = nullptr, *end = nullptr;
	bool is_streaming = false;
	
	struct schain
	{
		stok *first = nullptr, *last = nullptr;
		int refcount = 1;
		
		void ref();
		void deref();
		
	}*pchain;
};
