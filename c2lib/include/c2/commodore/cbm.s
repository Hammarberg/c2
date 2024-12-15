/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once

macro basic_startup
{
	basic_v2("0 sys%d\n",int(.start));
.start:
}

macro screencode @data...
{
    for(size_t r=0;r<data.size();r++)
    {
        push8(ascii2screen(char(data[r])));
    }
}

macro petscii @data...
{
    for(size_t r=0;r<data.size();r++)
    {
        push8(ascii2petscii(char(data[r])));
    }
}

macro incprg @file, @param...
{
	size_t offset = 0;
	size_t length = -1;
	
	if(param.size() >= 1)
		offset = param[0];
	
	if(param.size() >= 2)
		length = param[1];
		
	loadbin(file.str(), offset + 2, length);
}

macro vice @in
{
	vice_cmd(in);
}

