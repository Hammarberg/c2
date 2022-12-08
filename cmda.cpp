/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "cmda.h"
#include <cstdlib>
#include <filesystem>

#include <cstdio>

void cmda::add_args(int arga, char *args[])
{
	for(int r=0;r<arga;r++)
	{
		sargs.push_back(args[r]);
	}
}

void cmda::add_args(const char *argstr)
{
	const char *p = argstr;
	std::string tmp;
	for(;;)
	{
		tmp.clear();
		
		while(*p == ' ')
			p++;
		
		if(!*p)
			break;
		
		for(;*p && *p != ' ';p++)
		{
			if(*p == '\"')
			{
				p++;
				while(*p)
				{
					if(*p == '\"')
					{
						break;
					}
					
					tmp += *p;
					p++;
				}
			}
			else
			{
				tmp += *p;
			}
		}
		if(tmp.size())
			sargs.push_back(tmp);
	}
}

void cmda::add_info(const char *slong, const char *sshort, const char *sinfo)
{
	data.push_back({slong, sshort, sinfo});
}

void cmda::cswitch::print()
{
	std::string tmp;
	tmp = sshort;
	while(tmp.size() < 5)
		tmp += ' ';
		
	tmp += slong;

	size_t r = 0;
	while (r < sinfo.size())
	{
		while(tmp.size() < 22)
			tmp += ' ';
			
		while (r < sinfo.size())
		{
			if(tmp.size() >= 70 && sinfo[r] == ' ')
			{
				r++;
				break;
			}
			
			tmp += sinfo[r];
			r++;
		}
		fprintf(stderr, "%s\n", tmp.c_str());
		tmp = "";
	}
}

void cmda::printf_info()
{
	for(size_t r=0;r<data.size();r++)
	{
		data[r].print();
	}
	throw "";
}

bool cmda::verify(int iter, const char *sw, int min_args, int max_args, int *arga, const char ***argc)
{
	std::string info,s1,s2;
	cswitch *pd = nullptr;
	for(size_t r=0; r<data.size(); r++)
	{
		cswitch &d = data[r];
		if(d.slong == sw || d.sshort == sw)
		{
			info = d.sinfo;
			s1 = d.slong;
			s2 = d.sshort;
			pd = &d;
			break;
		}
	}
	
	if(!s1.size())
	{
		s1 = sw;
	}
	
	int fc = 0;
	for(size_t r = 0; r<sargs.size(); r++)
	{
		if(s1 == sargs[r] || s2 == sargs[r])
		{
			if(fc == iter)
			{
				r++;
				int start = int(r), count = 0;
				for(; r<sargs.size() /*&& count < max_args*/; r++, count++)
				{
					if(sargs[r].size() > 1 && sargs[r][0] == '-')
					{
						break;
					}
				}
				
				if(count < min_args || count > max_args)
				{
					if(pd)
						pd->print();
						
					throw "Wrong number of arguments";
				}
				
				if(count)
				{
					*argc = (const char **)malloc(sizeof(const char *) * count);
					
					const char **tmp = *argc;
					
					for(int l=0; l<count; l++)
					{
						tmp[l] = sargs[start + l].c_str();
					}
				}
				else
				{
					*argc = nullptr;
				}
				
				*arga = count;
				
				return true;
			}
			else
			{
				fc++;
			}
		}
	}
	
	return false;
}

void cmda::cmdfree(void *ptr)
{
	if(ptr)
		free(ptr);
}

std::string cmda::main()
{
	if(sargs.size() >= 2)
	{
		if(sargs[1][0] != '-')
			return sargs[1].c_str();
	}
	
	std::string project;
	
    for (auto const &entry : std::filesystem::directory_iterator(".")) 
    {
		std::string tmp = entry.path().string();
		
		size_t s = tmp.size();
		if(s >= 8)
		{
			if(tmp.substr(s-8,8) == ".c2.json")
			{
				if(project != "")
				{
					fprintf(stderr, "Multiple project files found in the current directory. Specify one as the first argument or via --project <filename>.\n");
					return "";
				}
				project = tmp;
			}
		}
    }
	
	return project;
}
