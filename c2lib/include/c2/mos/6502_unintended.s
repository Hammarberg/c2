/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "6502.s"

#define C2_6502_UNINTENDED

// For reference: https://csdb.dk/release/?id=212346

///////////////////////

macro anc #@n
{
	push8($0b);
	push8(n);
}

///////////////////////

macro sax @n,y
{
	push8($97);
	push8(n);
}

macro sax (@n,x)
{
	push8($83);
	push8(n);
}

macro sax @n
{
    if(n.bits() <= 8)
    {
		push8($87);
		push8(n);
    }
    else
    {
		push8($8f);
		push16le(n, true);
    }
}

///////////////////////

macro arr #@n
{
	push8($6b);
	push8(n);
}

///////////////////////

macro alr #@n
{
	push8($4b);
	push8(n);
}

///////////////////////

macro sha @n,y
{
	push8($9f);
	push16le(n, true);
}

macro sha (@n,y)
{
	push8($93);
	push8(n);
}

///////////////////////

macro sbx #@n
{
	push8($cb);
	push8(n);
}

///////////////////////

macro dcp (@n,x)
{
	push8($c3);
	push8(n);
}

macro dcp (@n),y
{
	push8($d3);
	push8(n);
}

macro dcp @n
{
    if(n.bits() <= 8)
    {
		push8($c7);
		push8(n);
    }
    else
    {
		push8($cf);
		push16le(n, true);
    }
}

macro dcp @n,x
{
    if(n.bits() <= 8)
    {
		push8($d7);
		push8(n);
	}
	else
	{
		push8($df);
		push16le(n, true);
	}
}

macro dcp @n,y
{
	push8($db);
	push16le(n, true);
}

///////////////////////

macro isc (@n,x)
{
	push8($e3);
	push8(n);
}

macro isc (@n),y
{
	push8($f3);
	push8(n);
}

macro isc @n
{
    if(n.bits() <= 8)
    {
		push8($e7);
		push8(n);
	}
	else
	{
		push8($ef);
		push16le(n, true);
	}
}

macro isc @n,x
{
    if(n.bits() <= 8)
    {
		push8($f7);
		push8(n);
	}
	else
	{
		push8($ff);
		push16le(n, true);
	}
}

macro isc @n,y
{
	push8($fb);
	push16le(n, true);
}

///////////////////////

macro las @n,y
{
	push8($bb);
	push16le(n, true);
}

///////////////////////

macro lax #@n
{
	if(n != 0)
	{
		c2_warning("LAX immediate used with a non zero value")
	}
	
	push8($ab);
	push8(n);
}

macro lax (@n,x)
{
	push8($a3);
	push8(n);
}

macro lax (@n),y
{
	push8($b3);
	push8(n);
}

macro lax @n
{
    if(n.bits() <= 8)
    {
		push8($a7);
		push8(n);
	}
	else
	{
		push8($af);
		push16le(n, true);
	}
}

macro lax @n,y
{
    if(n.bits() <= 8)
    {
		push8($b7);
		push8(n);
	}
	else
	{
		push8($bf);
		push16le(n, true);
	}
}

///////////////////////

macro rla (@n,x)
{
	push8($23);
	push8(n);
}

macro rla (@n),y
{
	push8($33);
	push8(n);
}

macro rla @n
{
    if(n.bits() <= 8)
    {
		push8($27);
		push8(n);
	}
	else
	{
		push8($2f);
		push16le(n, true);
	}
}

macro rla @n,x
{
    if(n.bits() <= 8)
    {
		push8($37);
		push8(n);
	}
	else
	{
		push8($3f);
		push16le(n, true);
	}
}

macro rla @n,y
{
	push8($2b);
	push16le(n, true);
}

///////////////////////

macro rra (@n,x)
{
	push8($63);
	push8(n);
}

macro rra (@n),y
{
	push8($73);
	push8(n);
}

macro rra @n
{
    if(n.bits() <= 8)
    {
		push8($67);
		push8(n);
	}
	else
	{
		push8($6f);
		push16le(n, true);
	}
}

macro rra @n,x
{
    if(n.bits() <= 8)
    {
		push8($77);
		push8(n);
	}
	else
	{
		push8($7f);
		push16le(n, true);
	}
}

macro rra @n,y
{
	push8($7b);
	push16le(n, true);
}

///////////////////////

macro slo (@n,x)
{
	push8($03);
	push8(n);
}

macro slo (@n),y
{
	push8($13);
	push8(n);
}

macro slo @n
{
    if(n.bits() <= 8)
    {
		push8($07);
		push8(n);
	}
	else
	{
		push8($0f);
		push16le(n, true);
	}
}

macro slo @n,x
{
    if(n.bits() <= 8)
    {
		push8($17);
		push8(n);
	}
	else
	{
		push8($1f);
		push16le(n, true);
	}
}

macro slo @n,y
{
	push8($1b);
	push16le(n, true);
}

///////////////////////

macro sre (@n,x)
{
	push8($43);
	push8(n);
}

macro sre (@n),y
{
	push8($53);
	push8(n);
}

macro sre @n
{
    if(n.bits() <= 8)
    {
		push8($47);
		push8(n);
	}
	else
	{
		push8($4f);
		push16le(n, true);
	}
}

macro sre @n,x
{
    if(n.bits() <= 8)
    {
		push8($57);
		push8(n);
	}
	else
	{
		push8($5f);
		push16le(n, true);
	}
}

macro sre @n,y
{
	push8($5b);
	push16le(n, true);
}

///////////////////////

macro shx @n,y
{
	push8($9e);
	push16le(n, true);
}

///////////////////////

macro shy @n,x
{
	push8($9c);
	push16le(n, true);
}

///////////////////////

macro tas @n,y
{
	push8($9b);
	push16le(n, true);
}

///////////////////////

macro ane #@n
{
	if(n != 0)
	{
		c2_warning("ANE immediate used with a non zero value")
	}
	
	push8($8b);
	push8(n);
}

///////////////////////

macro jam
{
	push8($02);
}

///////////////////////

macro dop,nop3
{
	push8($04);
	push8($00);
}

macro nop4
{
	push8($14);
	push8($00);
}
