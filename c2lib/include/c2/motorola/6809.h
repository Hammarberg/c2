/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/h/c2i.h"

class motorola6809 : public c2i
{
public:
	motorola6809(cmdi *pcmd)
	: c2i(pcmd)
	{}

	virtual ~motorola6809()
	{}

	void c2_6809_idx_direct_off(cint off, cint r1)
	{
		if(!off)
		{
			push8(0b10000100|r1<<5);
		}
		else if(c2st<5>(off))
		{
			push8(0b00000000|r1<<5|off&31);
		}
		else if(c2st<8>(off))
		{
			push8(0b10001000|r1<<5|off&255);
			push8(off);
		}
		else
		{
			push8(0b10001001|r1<<5);
			push16be(off);
		}
	}

	void c2_6809_idx_indirect_off(cint off, cint r1)
	{
		if(!off)
		{
			push8(0b10010100|r1<<5);
		}
		else if(c2st<8>(off))
		{
			push8(0b10011000|r1<<5|off&255);
			push8(off);
		}
		else
		{
			push8(0b10011001|r1<<5);
			push16be(off);
		}
	}

	void c2_6809_idx_direct_acc(cint r2, cint r1)
	{
		static const int post[]={0b10000110,0b10000101,0b10001011};
		push8(post[r2]|r1<<5);
	}

	void c2_6809_idx_indirect_acc(cint r2, cint r1)
	{
		static const int post[]={0b10010110,0b10010101,0b10011011};
		push8(post[r2]|r1<<5);
	}

	void c2_6809_idx_direct_pc(cint off)
	{
		if(c2st<8>(off))
		{
			push8(0b10001100);
			push8(off);
		}
		else
		{
			push8(0b10001101);
			push16be(off);
		}
	}

	void c2_6809_idx_indirect_pc(cint off)
	{
		if(c2st<8>(off))
		{
			push8(0b10011100);
			push8(off);
		}
		else
		{
			push8(0b10011101);
			push16be(off);
		}
	}
};
