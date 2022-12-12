/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/c2.s"
#include "c2/mos/6502.s"
#include "c2/mos/6502_unintended.s"

macro basic_startup
{
	@ = $0801
	byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00
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

macro vice break
{
	c64_vice("break @");
}

macro vice @in
{
	c64_vice(in);
}

