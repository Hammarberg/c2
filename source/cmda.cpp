/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

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

void cmda::declare(const char *slong, const char *sshort, const char *sinfo, int min_args, int max_args)
{
	// Verify switches
	std::string stmp = slong;
	if(stmp.size() < 3 || (stmp.size() >= 3 && stmp.substr(0, 2) != "--"))
	{
		throw "Invalid long switch declared";
	}
	
	if(sshort)
	{
		stmp = sshort;
		if(stmp.size() != 2 || stmp[0] != '-' || stmp[1] == '-')
		{
			throw "Invalid short switch declared";
		}
	}
	
	for(size_t r=0; r<data.size(); r++)
	{
		if(data[r].slong == slong || (sshort && data[r].sshort == sshort))
		{
			if(sshort)
				fprintf(stderr, "Declaring switch %s, %s\n", sshort, slong);
			else
				fprintf(stderr, "Declaring switch %s\n", slong);
			
			data[r].print();
			throw "Switch already declared";
		}
	}
	
	data.push_back({slong, sshort ? sshort : "", sinfo, min_args, max_args});
}

void cmda::cswitch::print()
{
	std::string tmp;
	
	if(sshort.size())
		tmp = sshort + ",";
		
	while(tmp.size() < 4)
		tmp += ' ';
		
	tmp += slong;

	size_t r = 0;
	while (r < sinfo.size())
	{
		while(tmp.size() < 25)
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
		fprintf(stdout, "%s\n", tmp.c_str());
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
			min_args = d.min_args;
			max_args = d.max_args;
			pd = &d;
			break;
		}
	}
	
	if(min_args == -1)
		min_args = 0;
	
	if(max_args == -1)
		max_args = min_args;
	
	if(!s1.size())
	{
		s1 = sw;
	}
	
	int fc = 0;
	for(size_t r = 0; r<sargs.size(); r++)
	{
		std::string &arg = sargs[r];
		
		if(arg[0] != '-')
			continue;
		
		bool match = s1 == arg || s2 == arg;
		bool checkargcount = true;
		
		if(s2.size() && !match && arg.size() >= 3 && arg[1] != '-')
		{
			auto i = arg.find(s2[1]);
			if(i != arg.npos)
			{
				if(i != arg.size() - 1)
				{
					checkargcount = false;
				}
				
				match = true;
			}
		}
		
		if(match)
		{
			if(fc == iter)
			{
				r++;
				int start = int(r), count = 0;
				for(; checkargcount && r<sargs.size(); r++, count++)
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
		std::string &tmp = sargs[1];
		if(tmp[0] != '-')
		{
			size_t s = tmp.size();
			if(s >= 8 && tmp.substr(s-8,8) == ".c2.json")
			{
				return tmp.c_str();
			}
		}
	}
	
	std::string project;
	
    for (auto const &entry : std::filesystem::directory_iterator(".")) 
    {
		std::string tmp = entry.path().string();
		
		size_t s = tmp.size();
		if(s >= 8 && tmp.substr(s-8,8) == ".c2.json")
		{
			if(project != "")
			{
				fprintf(stderr, "Multiple project files found in the current directory. Specify one as the first argument or via --project <filename>.\n");
				return "";
			}
			project = tmp;
		}
    }
	
	return project;
}
