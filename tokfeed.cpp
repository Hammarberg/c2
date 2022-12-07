/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "tokfeed.h"

stok toklink::TEND;

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

void tokoutfile::push_tok(stok *o)
{
	assert(o);
	
	fputs(o->format().c_str(), fp);
	
}
