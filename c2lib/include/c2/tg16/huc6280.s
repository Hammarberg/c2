/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/mos/65C02.s"

#define C2_HUC6280

macro bsr @n
{
	push8($44);
	push16le(n, true);
}

macro cly 
{
	push8($c2);
}

macro clx
{
	push8($82);
}

// Sets the HuC6280 to "high speed," or normal speed mode. The only use for this instruction is after a system reset, to ensure that the processor is in its high speed mode.
macro csh
{
	push8($d4);
}
//Sets the HuC6280 to low speed. The only use for this instruction appears to be for the US "country check" code// it does not appear anywhere else in HuC6280 code. Its use is discouraged.
macro csl
{
	push8($54);
}

macro set 
{
	push8($f4);
}

macro st0 #@n 
{
	push8($03);
	push8(n);
}

macro st1 #@n 
{
	push8($13);
	push8(n);
}

macro st2 #@n 
{
	push8($23);
	push8(n);
}

// Execute a memory move where the source address increments, and the destination address alternates between two addresses with each loop cycle. This is an extremely powerful instruction,
// mainly used for transferring data to the special video memory (e.g., backgrounds, etc.); from the main memory.
macro tia @src,@dst,@len 
{
	push8($e3);
	push16le(src, true);
	push16le(dst, true);
	push16le(len, true);
}

// Execute a memory move where the source and destination addresses decrement with each loop cycle.
// This is an extremely powerful instruction, mainly used for copying and moving data around in main memory.
macro tdd @src,@dst,@len 
{
	push8($c3);
	push16le(src, true);
	push16le(dst, true);
	push16le(len, true);
}

//  Execute a memory move where the source address increments with each loop cycle. This is an extremely powerful instruction, mainly used for transferring data from the special video memory (e.g., backgrounds, etc.) to the main memory.
macro tin @src,@dst,@len 
{
	push8($e3);
	push16le(src, true);
	push16le(dst, true);
	push16le(len, true);
}

// Execute a memory move where the source and destination addresses increment with each loop cycle. This is an extremely powerful instruction, mainly used for copying and moving blocks of data around in main memory
macro tii @src,@dst,@len 
{
	push8($73);
	push16le(src, true);
	push16le(dst, true);
	push16le(len, true);
}

// only one bit can be set in N 
macro tam #@n 
{
	push8($53);
	push8(n);
}

macro tma #@n 
{
	push8($43);
	push8(n);
}

macro tam0 
{
	push8($53);
	push8($1);
}
macro tam1
{
	push8($53);
	push8($2);
}
macro tam2
{
	push8($53);
	push8($4);
}
macro tam3
{
	push8($53);
	push8($8);
}
macro tam4
{
	push8($53);
	push8($10);
}
macro tam5
{
	push8($53);
	push8($20);
}
macro tam6
{
	push8($53);
	push8($40);
}
macro tam7
{
	push8($53);
	push8($80);
}

macro tma0 
{
	push8($43);
	push8($1);
}
macro tma1
{
	push8($43);
	push8($2);
}
macro tma2
{
	push8($43);
	push8($4);
}
macro tma3
{
	push8($43);
	push8($8);
}
macro tma4
{
	push8($43);
	push8($10);
}
macro tma5
{
	push8($43);
	push8($20);
}
macro tma6
{
	push8($43);
	push8($40);
}
macro tma7
{
	push8($43);
	push8($80);
}



macro tst #@a,@n
{
	if(n.bits() <= 8)
	{
		push8($83);
		push8(a);
		push8(n);
	}
	else
	{
		push8($93);
		push8(a);
		push16le(n, true);
	}
}

macro tst #@a,@n,x
{
	if(n.bits() <= 8)
	{
		push8($a3);
		push8(a);
		push8(n);
	}
	else
	{
		push8($b3);
		push8(a);
		push16le(n, true);
	}
}




