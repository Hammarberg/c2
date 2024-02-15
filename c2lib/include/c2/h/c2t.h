/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/
#pragma once
#include <cstdio>
#include <string>
#include <cstddef>

struct c2tools
{
    static void save(FILE *fp, const std::string &s)
    {
        const char *p = s.c_str();
        for(;;p++)
        {
            fputc(*p, fp);
            if (!*p)break;
        }
    }

    static void load(FILE *fp, std::string &s)
    {
        s.clear();
        int b;
        for(;;)
        {
            b = fgetc(fp);
            if(!b || b < 0)break;
            s += char(b);
        }
    }

    static size_t load(std::vector<char> &buf, size_t pos, std::string &s)
    {
        s.clear();
        int b;
        for(;;)
        {
            b = buf[pos];
            pos++;
            if(!b || b < 0)break;
            s += char(b);
        }
        return pos;
    }
};
