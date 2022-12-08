/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once

#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#endif

#include "linear.h"
#include "lines.h"
#include <string>

enum eflag : uint8_t
{
	NOTSET = 0,
	NEW = 1,		//1
	RETURN = 2,		//2
	SYSTEM = 4,		//3
	EXTERN = 8		//4
};

enum etype : uint8_t
{
	NONE = 0,
	NEWLINE,
	SPACE,
	ALPHA,
	NUM,
	OP,
	QUOTE,
	BQUOTE,
	BLOCK
};

#ifdef _MSC_VER
#pragma warning( push )
#pragma warning( disable : 4200 )
#endif
struct stok
{
	stok *prev, *next;
	
	etype type;
	eflag flag;
	
	uint16_t label_declared;
	
	uint16_t fileindex;

	uint16_t ord;
	uint32_t line;
	
	uint32_t root_labelindex;
	
	uint32_t scopeindex;
	uint32_t scopepos;
	
	char name[0];
	
	bool is_same_line(const stok *p) const 
	{
		return fileindex == p->fileindex && line == p->line;
	}
	
	bool cmpi(const stok *p) const 
	{
		for(int r=0;;r++)
		{
			const char a = name[r];
			const char b = p->name[r];
			
			if(a)
			{
				if(!b)return false;
			}
			else
			{
				if(!b)break;
				return false;
			}
				
			if(tolower(a) != tolower(b))
				return false;
		}
		
		return true;
	}
	
	bool cmpi(const char *s) const 
	{
		for(int r=0;;r++)
		{
			const char a = name[r];
			const char b = s[r];
			
			if(a)
			{
				if(!b)return false;
			}
			else
			{
				if(!b)break;
				return false;
			}
				
			if(tolower(a) != tolower(b))
				return false;
		}
		
		return true;
	}
	
	size_t size() const
	{
		return sizeof(stok) + strlen(name) + 1;
	}
	
	stok *get_next() 
	{
		return next;
	}
	
	stok *get_prev() const
	{
		return prev;
	}
	
	stok *get_prev_nonspace() 
	{
		stok *t = this;
		do
		{
			t = t->get_prev();
		}
		while(t && t->type == SPACE);
		
		if(!t)
			t = get_dud();
			
		return t;
	}
	
	stok *get_next_nonspace() 
	{
		stok *t = this;
		do
		{
			t = t->get_next();
		}
		while(t && t->type == SPACE);
		
		if(!t)
			t = get_dud();
		
		return t;
	}
	
	bool isend() const
	{
		return type == NONE;
	}
	
	void mute()
	{
		type = etype::SPACE;
		*name = 0;
	}
	
	static stok *get_dud();

	std::string format() const;
	
private:
	
};
#ifdef _MSC_VER
#pragma warning( pop )
#endif

const char *tokenize(const char *p, std::string &s, etype &t);
