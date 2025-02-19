/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/motorola/6809.s"

// Memory and BASIC reference
// http://dragon32.info/info/

macro screencode @data...
{
    for(size_t r=0;r<data.size();r++)
    {
        push8(ascii2screen(char(data[r])));
    }
}

macro dosheader @start, @end
{
        C2_PREFIX		// Assemble to prefix, saved with --out
        byte $55
        byte $02
        word start
        word end-start
        word start
        byte $aa
		C2_BODY			// Resume assemble to the main body
		@ = start
}

macro dosheader @start
{
	dosheader start, c2_high_bound
}
