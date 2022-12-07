/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "linear.h"
#include <cstdio>
#include <cstring>

class slines : public std::vector<char *>
{
public:

	slines(slinear_alloc<> &inmem)
	:mem(inmem)
	{}
	
	~slines()
	{
	}
	
	bool load(const char *file)
	{
		FILE *fp=fopen(file, "r");
		if(!fp)
		return false;

		fseek(fp, 0, SEEK_END);
		size_t size = ftell(fp);
		fseek(fp, 0, SEEK_SET);

		char *data = (char *)mem.alloc(size + 1);
		fread(data, 1, size, fp);
		fclose(fp);
		data[size] = 0;

		char *p = data, *s;
		while((s = strchr(p, 0x0a)))
		{
			*s = 0;
			push_back(p);
			p = s + 1;
		}
		
		push_back(p);
		
		return true;
	}
	
private:
	slinear_alloc<> &mem;
};

