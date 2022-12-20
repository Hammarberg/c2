/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/
#pragma once

// Long branch

macro lbpl @n
{
	static int longb = 0;
	static int rel = 0;
	rel = int(n) > int(@);
	if(c2st<8>(@+1-n + longb*3*rel))
	{
		longb = 0;
		bpl n
	}
	else
	{
		longb = 1;
		bmi +
		jmp n
	}
:
}

macro lbmi @n
{
	static int longb = 0;
	static int rel = 0;
	rel = int(n) > int(@);
	if(c2st<8>(@+1-n + longb*3*rel))
	{
		longb = 0;
		bmi n
	}
	else
	{
		longb = 1;
		bpl +
		jmp n
	}
:
}

macro lbvc @n
{
	static int longb = 0;
	static int rel = 0;
	rel = int(n) > int(@);
	if(c2st<8>(@+1-n + longb*3*rel))
	{
		longb = 0;
		bvc n
	}
	else
	{
		longb = 1;
		bvs +
		jmp n
	}
:
}

macro lbvs @n
{
	static int longb = 0;
	static int rel = 0;
	rel = int(n) > int(@);
	if(c2st<8>(@+1-n + longb*3*rel))
	{
		longb = 0;
		bvs n
	}
	else
	{
		longb = 1;
		bvc +
		jmp n
	}
:
}

macro lbcc @n
{
	static int longb = 0;
	static int rel = 0;
	rel = int(n) > int(@);
	if(c2st<8>(@+1-n + longb*3*rel))
	{
		longb = 0;
		bcc n
	}
	else
	{
		longb = 1;
		bcs +
		jmp n
	}
:
}

macro lbcs @n
{
	static int longb = 0;
	static int rel = 0;
	rel = int(n) > int(@);
	if(c2st<8>(@+1-n + longb*3*rel))
	{
		longb = 0;
		bcs n
	}
	else
	{
		longb = 1;
		bcc +
		jmp n
	}
:
}

macro lbeq @n
{
	static int longb = 0;
	static int rel = 0;
	rel = int(n) > int(@);
	if(c2st<8>(@+1-n + longb*3*rel))
	{
		longb = 0;
		beq n
	}
	else
	{
		longb = 1;
		bne +
		jmp n
	}
:
}

macro lbne @n
{
	static int longb = 0;
	static int rel = 0;
	rel = int(n) > int(@);
	if(c2st<8>(@+1-n + longb*3*rel))
	{
		longb = 0;
		bne n
	}
	else
	{
		longb = 1;
		beq +
		jmp n
	}
:
}
