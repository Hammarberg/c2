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
	if(c2st<8>(@+1-n))
	{
		bpl n
	}
	else
	{
		bmi +
		jmp n
:
	}
}

macro lbmi @n
{
	if(c2st<8>(@+1-n))
	{
		bmi n
	}
	else
	{
		bpl +
		jmp n
:
	}
}

macro lbvc @n
{
	if(c2st<8>(@+1-n))
	{
		bvc n
	}
	else
	{
		bvs +
		jmp n
:
	}
}

macro lbvs @n
{
	if(c2st<8>(@+1-n))
	{
		bvs n
	}
	else
	{
		bvc +
		jmp n
:
	}
}

macro lbcc @n
{
	if(c2st<8>(@+1-n))
	{
		bcc n
	}
	else
	{
		bcs +
		jmp n
:
	}
}

macro lbcs @n
{
	if(c2st<8>(@+1-n))
	{
		bcs n
	}
	else
	{
		bcc +
		jmp n
:
	}
}

macro lbne @n
{
	if(c2st<8>(@+1-n))
	{
		bne n
	}
	else
	{
		beq +
		jmp n
:
	}
}

macro lbeq @n
{
	if(c2st<8>(@+1-n))
	{
		beq n
	}
	else
	{
		bne +
		jmp n
:
	}
}
