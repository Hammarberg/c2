/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "token.h"
#include <cassert>

union sdud
{
	stok d;
	uint8_t zero[sizeof(d) + 1];
	sdud()
	{
		memset(zero, 0, sizeof(zero));
	}
};

stok *stok::get_dud()
{
	static sdud end;
	return &end.d;
}

/*
stok *stokens::get_first()
{
	return first;
}

stok *stokens::get_last()
{
	return last;
}

stokens::stok *stokens::clone(const stok *o)
{
	size_t n = o->size();
	stok *p = (stok *)alloc(n);
	memcpy(p, o, n);
	return p;
}

void stokens::replace(stok *o, stok *p)
{
	if((p->prev = o->prev) != nullptr)
	{
		p->prev->next = p;
	}
	else
	{
		first = p;
	}
	
	if((p->next = o->next) != nullptr)
	{
		p->next->prev = p;
	}
	else
	{
		last = p;
	}
}

void stokens::remove(stok *o)
{
	if(o->prev)
	{
		o->prev->next = o->next;
	}
	else
	{
		if((first = o->next) != nullptr)
		{
			o->next->prev = nullptr;
		}
	}
	
	if(o->next)
	{
		o->next->prev = o->prev;
	}
	else
	{
		if((last = o->prev) != nullptr)
		{
			o->prev->next = nullptr;
		}
	}
}
*/

	static bool _isspace(char b)
	{
		return b == 0x0d || b == ' ' || b == '\t';
	}

	static bool _isalpha(const char b)
	{
		return (b >= 'a' && b <= 'z') || (b >= 'A' && b <= 'Z')  || b == '_' || b == '.';
	}

	static bool _isdec(const char b)
	{
		return b >= '0' && b<= '9';
	}

	static bool _isnum(const char b)
	{
		return (b >= '0' && b<= '9') ||  (b >= 'a' && b<= 'f') || (b >= 'A' && b<= 'F') || (b == 'x') || (b == 'X') || (b == 'b') || (b == 'B');
	}


const char *tokenize(const char *p, std::string &s, etype &t)
{
	s = "";
	t = NONE;

	if(_isspace(*p))
	{
		do
		{
			s+=*p;
			p++;
		}
		while(_isspace(*p));
		
		t=SPACE;
	}
	else if(*p == 0x0a)
	{
		s+=*p;
		p++;
		
		t=SPACE;
	}
	else if(_isalpha(*p))
	{
		do
		{
			s += *p;
			p++;
		}
		while(_isalpha(*p) || _isdec(*p));
		
		t=ALPHA;
	}
	else if(_isdec(*p) || *p =='$')	// All numbers start with either 0-9 0x 0b 0X 0B $
	{
		do
		{
			s += *p;
			p++;
		}
		while(*p && _isnum(*p));
		
		t=NUM;
	}
	else if(*p == '\"')
	{
		bool esc = false;
		p++;
		
		while(*p)
		{
			if(!esc)
			{
				if(*p == '\"')
				{
					p++;
					break;
				}
				esc = *p == '\\';
			}
			else esc = false;
				
			s += *p;
			p++;
		}
		
		t=QUOTE;
	}
	else if(*p == '\'')
	{
		bool esc = false;
		p++;
		
		while(*p)
		{
			if(!esc)
			{
				if(*p == '\'')
				{
					p++;
					break;
				}
				esc = *p == '\\';
			}
			else esc = false;
				
			s += *p;
			p++;
		}
		
		t=BQUOTE;
	}
	else if(*p)
	{
		s += *p;
		t=OP;
		p++;
	}
	else
	{
		s="\n";
		t = SPACE;
		p = nullptr;
	}
	
	return p;
}

std::string stok::format() const
{
	std::string stmp;
	switch(type)
	{
	case etype::SPACE:
	case etype::ALPHA:
	case etype::NUM:
	case etype::OP:
	case etype::BLOCK:
		stmp = name;
		break;
	case etype::QUOTE:
		stmp = "\"";
		stmp += name;
		stmp += "\"";
		break;
	case etype::BQUOTE:
		stmp = "'";
		stmp += name;
		stmp += "'";
		break;
	default:
		assert(false);
		break;
	};
	
	return stmp;
}
