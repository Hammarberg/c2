/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "tokfeed.h"

///////////////////////////////////////////////////////////////////////////////
// tokline
///////////////////////////////////////////////////////////////////////////////

stok *tokline::pull_tok()
{
	if(!psstr)
	{
		if(sline_number == size())
			return nullptr;
		
		psstr = (*this)[sline_number];
		sline_number++;
		
		ord = 0;
		line++;
		
		//printf("%s",psstr);
	}
	
	etype t;
	psstr = tokenize(psstr, stmp ,t);
	
	stok *tok = (stok *)mem.alloc(sizeof(stok) + stmp.size() + 1);
	tok->type = t;
	tok->flag = flag;
	tok->fileindex = fileindex;
	tok->ord = ord;
	tok->line = line;
	tok->label_declared = 0;
	tok->root_labelindex = -1;
	tok->scopeindex = -1;
	tok->scopepos = -1;
	
	memcpy(tok->name, stmp.c_str(), stmp.size() + 1);
	
	if(t != etype::SPACE)
	{
		switch (pre)
		{
			case 0:
				if(ord == 0 && t == etype::OP && stmp[0] == '#')
				{
					new_flag = 0;
					pre++;
				}
				break;
			
			case 1:
				new_line = (uint32_t)atoi(stmp.c_str());
				pre++;
				break;
			
			case 2:
				{
					if(stmp.substr(0, 2) == "./")
					{
						stmp = stmp.substr(2);
					}
					
					auto i = filemap.find(stmp);
					if(i == filemap.end())
					{
						new_fileindex = uint16_t(files.size());
						filemap.insert(std::pair<std::string, uint16_t>(stmp, new_fileindex));
						files.push_back(stmp);
					}
					else
					{
						new_fileindex = i->second;
					}
					pre++;
					break;
				}
			
			case 3:
				{
					int n = atoi(tok->name);
					new_flag |= 1 << (n - 1);
				}
				break;
		}
		
		ord++;
	}
	
	if(pre && psstr == nullptr)
	{
		assert(pre == 3);
		pre = 0;
		flag = eflag(new_flag);
		fileindex = new_fileindex;
		line = new_line - 1;
	}
	
	return tok;
}

///////////////////////////////////////////////////////////////////////////////
// tokoutfile
///////////////////////////////////////////////////////////////////////////////

void tokoutfile::push_tok(stok *o)
{
	assert(o);
	
	fputs(o->format().c_str(), fp);
	
}

///////////////////////////////////////////////////////////////////////////////
// toklink
///////////////////////////////////////////////////////////////////////////////

toklink::toklink()
{
	pchain = new schain;
}

toklink::toklink(const toklink &o)
: pos(o.pos)
, end(o.end)
, pchain(o.pchain)
{
	pchain->ref();
}

toklink &toklink::operator=(const toklink &o)
{
	pchain->deref();
	pos = o.pos;
	end = o.end;
	pchain = o.pchain;
	pchain->ref();

	return *this;
}

toklink::~toklink()
{
	pchain->deref();
}

void toklink::restart(stok *op, stok *oe)
{
	pos = op;
	end = oe;
	is_streaming = false;
}

void toklink::terminate(stok *o)
{
	end = o;
}

stok *toklink::get_pos()
{
	return pos;
}

stok *toklink::get_end()
{
	return end;
}

stok *toklink::pull_tok()
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

void toklink::push_tok(stok *p)
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

void toklink::unlink(stok *i)
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

stok *toklink::link(stok *i, stok *a)
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

bool toklink::operator==(const toklink &o) const
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

int toklink::count() const
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

void toklink::schain::ref()
{
	refcount++;
}

void toklink::schain::deref()
{
	if(!--refcount)
	{
		delete this;
	}
}

stok toklink::TEND;
