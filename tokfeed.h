/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once

#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#endif

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
	
	toklink()
	{
		pchain = new schain;
	}
	
	toklink(const toklink &o)
	: pos(o.pos)
	, end(o.end)
	, pchain(o.pchain)
	{
		pchain->ref();
	}
	
	toklink &operator=(const toklink &o)
	{
		pchain->deref();
		pos=o.pos;
		end=o.end;
		pchain=o.pchain;
		pchain->ref();
		
		return *this;
	}
	
	~toklink()
	{
		pchain->deref();
	}
	
	void restart(stok *op = nullptr, stok *oe = nullptr)
	{
		pos = op;
		end = oe;
		is_streaming = false;
	}
	
	void terminate(stok *o = nullptr)
	{
		end = o;
	}
	
	stok *get_pos()
	{
		return pos;
	}	
	
	stok *get_end()
	{
		return end;
	}	
	
	stok *pull_tok()
	{
		stok *o;
		
		if(pos == &TEND)
		{
			return nullptr;
		}
		
		if(end && pos == end)
		{
			pos = &TEND;
			return nullptr;
		}
		
		if(!pos)
		{
			o = pos = pchain->first;
		}
		else
		{
			if(is_streaming)
			{
				pos = pos->get_next();
			}
			
			o = pos;
		}
		
		is_streaming = true;
		
		return o;
	}
	
	void push_tok(stok *p)
	{
		if(!pchain->first)
		{
			pchain->first = pchain->last = p;
			p->prev = p->next = nullptr;
		}
		else if(pos)
		{
			link(p, pos);
			pos = p;
		}
		else
		{
			p->prev = pchain->last;
			p->next = nullptr;
			pchain->last->next = p;
			pchain->last = p;
		}
	}
	
	void unlink(stok *i)
	{
		if(i == pos)
		{
			if(i->next)
			{
				pos = i->next;
				is_streaming = false;
			}
			else
			{
				pos = &TEND;
			}
		}
		
		if(i->prev)i->prev->next=i->next;
		if(i->next)i->next->prev=i->prev;
		if(pchain->first==i)pchain->first=i->next;
		if(pchain->last==i)pchain->last=i->prev;
	}

	stok *link(stok *i, stok *a)
	{
		if(!a)
		{
			push_tok(i);
		}
		else
		{
			if(a->next)
			{
				i->next = a->next;
				a->next = i;
				i->prev = a;
				i->next->prev = i;
			}
			else
			{
				a->next=i;
				i->next=nullptr;
				i->prev=a;
				pchain->last=i;
			}
		}
		
		return i;
	}
	
	bool operator==(const toklink &o) const
	{
		stok *a = pchain->first;
		stok *b = o.pchain->first;
		
		for(;;)
		{
			if(a == nullptr && b == nullptr)
				break;
				
			if(a == nullptr || b == nullptr)
				return false;
				
			if(a->type != b->type || strcmp(a->name, b->name))
				return false;
				
			a = a->get_next();
			b = b->get_next();
		}
		
		return true;
	}
	
	static stok TEND;
	stok *pos = nullptr, *end = nullptr;
	bool is_streaming = false;
	
	int count()
	{
		int n = 0;
		stok *p = pchain->first;
		while(p)
		{
			n++;
			p = p->next;
		}
		return n;
	}
	
	struct schain
	{
		stok *first = nullptr, *last = nullptr;
		int refcount = 1;
		
		void ref()
		{
			refcount++;
		}
		
		void deref()
		{
			if(!--refcount)
			{
				delete this;
			}
		}
		
	}*pchain;
};
