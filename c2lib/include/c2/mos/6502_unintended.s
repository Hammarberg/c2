/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "6502.s"

///////////////////////

macro anc #@n
{
	byte $0b, n
}

///////////////////////

macro sax @n,y
{
	byte $97, n
}

macro sax (@n,x)
{
	byte $83, n
}

macro sax @n
{
    if(n.bits() <= 8)
    {
		byte $87, n
    }
    else
    {
		byte $8f
		word n
    }
}

///////////////////////

macro arr #@n
{
	byte $6b, n
}

///////////////////////

macro alr #@n
{
	byte $4b, n
}

///////////////////////

macro sha @n,y
{
	byte $9f
	word n
}

macro sha (@n,y)
{
	byte $93, n
}

///////////////////////

macro sbx #@n
{
	byte $cb, n
}

///////////////////////

macro dcp (@n,x)
{
	byte $c3, n
}

macro dcp (@n),y
{
	byte $d3, n
}

macro dcp @n
{
    if(n.bits() <= 8)
    {
		byte $c7, n
    }
    else
    {
		byte $cf
		word n
    }
}

macro dcp @n,x
{
    if(n.bits() <= 8)
    {
		byte $d7, n
	}
	else
	{
		byte $df
		word n
	}
}

macro dcp @n,y
{
	byte $db
	word n
}

///////////////////////

macro isc (@n,x)
{
	byte $e3, n
}

macro isc (@n),y
{
	byte $f3, n
}

macro isc @n
{
    if(n.bits() <= 8)
    {
		byte $e7, n
	}
	else
	{
		byte $ef
		word n
	}
}

macro isc @n,x
{
    if(n.bits() <= 8)
    {
		byte $f7, n
	}
	else
	{
		byte $ff
		word n
	}
}

macro isc @n,y
{
	byte $fb
	word n
}

///////////////////////

macro las @n,y
{
	byte $bb
	word n
}

///////////////////////

macro lax #@n
{
	if(n != 0)
	{
		c2_warning("LAX immediate used with a non zero value")
	}
	
	byte $ab, n
}

macro lax (@n,x)
{
	byte $a3, n
}

macro lax (@n),y
{
	byte $b3, n
}

macro lax @n
{
    if(n.bits() <= 8)
    {
		byte $a7, n
	}
	else
	{
		byte $af
		word n
	}
}

macro lax @n,y
{
    if(n.bits() <= 8)
    {
		byte $b7, n
	}
	else
	{
		byte $bf
		word n
	}
}

///////////////////////

macro rla (@n,x)
{
	byte $23, n
}

macro rla (@n),y
{
	byte $33, n
}

macro rla @n
{
    if(n.bits() <= 8)
    {
		byte $27, n
	}
	else
	{
		byte $2f
		word n
	}
}

macro rla @n,x
{
    if(n.bits() <= 8)
    {
		byte $37, n
	}
	else
	{
		byte $3f
		word n
	}
}

macro rla @n,y
{
	byte $2b
	word n
}

///////////////////////

macro rra (@n,x)
{
	byte $63, n
}

macro rra (@n),y
{
	byte $73, n
}

macro rra @n
{
    if(n.bits() <= 8)
    {
		byte $67, n
	}
	else
	{
		byte $6f
		word n
	}
}

macro rra @n,x
{
    if(n.bits() <= 8)
    {
		byte $77, n
	}
	else
	{
		byte $7f
		word n
	}
}

macro rra @n,y
{
	byte $7b
	word n
}

///////////////////////

macro slo (@n,x)
{
	byte $03, n
}

macro slo (@n),y
{
	byte $13, n
}

macro slo @n
{
    if(n.bits() <= 8)
    {
		byte $07, n
	}
	else
	{
		byte $0f
		word n
	}
}

macro slo @n,x
{
    if(n.bits() <= 8)
    {
		byte $17, n
	}
	else
	{
		byte $1f
		word n
	}
}

macro slo @n,y
{
	byte $1b
	word n
}

///////////////////////

macro sre (@n,x)
{
	byte $43, n
}

macro sre (@n),y
{
	byte $53, n
}

macro sre @n
{
    if(n.bits() <= 8)
    {
		byte $47, n
	}
	else
	{
		byte $4f
		word n
	}
}

macro sre @n,x
{
    if(n.bits() <= 8)
    {
		byte $57, n
	}
	else
	{
		byte $5f
		word n
	}
}

macro sre @n,y
{
	byte $5b
	word n
}

///////////////////////

macro shx @n,y
{
	byte $9e
	word n
}

///////////////////////

macro shy @n,x
{
	byte $9c
	word n
}

///////////////////////

macro tas @n,y
{
	byte $9b
	word n
}

///////////////////////

macro ane #@n
{
	if(n != 0)
	{
		c2_warning("ANE immediate used with a non zero value")
	}
	byte $8b, n
}

///////////////////////

macro jam
{
	byte $02
}

///////////////////////

macro dop,nop2
{
	byte $04, $00
}

macro nop4
{
	byte $14, $00
}
