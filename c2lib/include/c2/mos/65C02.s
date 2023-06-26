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

#define C2_65C02
//	additional C02 instructions

macro adc (@n)
{
	push8($72);
	push8(n);
}

macro and (@n)
{
	push8($32);
	push8(n);
}

macro cmp (@n)
{
	push8($d2);
	push8(n);
}

macro eor (@n)
{
	push8($52);
	push8(n);
}

macro lda (@n)
{
	push8($b2);
	push8(n);
}

macro ora (@n)
{
	push8($12);
	push8(n);
}

macro sbc (@n)
{
	push8($f2);
	push8(n);
}

macro sta (@n)
{
	push8($92);
	push8(n);
}

macro bit #@n
{
	push8($89);
	push8(n);
}

macro bit @n,x
{
	if(n.bits() <= 8)
	{
			push8($34);
			push8(n);
	}
	else
	{
			push8($3c);
			push16le(n, true);
	}
}

macro dec
{
	push8($3a);
}

macro inc
{
	push8($1a);
}

macro jmp (@n),x
{
	push8($7c);
	push16le(n, true);
}

macro bra @n
{
	push8($80);
	push8(c2sr<8>(n-@-1));
}

macro phx
{
	push8($da);
}

macro phy
{
	push8($5a);
}

macro plx
{
	push8($fa);
}

macro ply
{
	push8($7a);
}

macro stz @n
{
	if(n.bits() <= 8)
	{
			push8($64);
			push8(n);
	}
	else
	{
			push8($9c);
			push16le(n, true);
	}
}

macro stz @n,x
{
	if(n.bits() <= 8)
	{
			push8($74);
			push8(n);
	}
	else
	{
			push8($9e);
			push16le(n, true);
	}
}

macro trb @n
{
	if(n.bits() <= 8)
	{
			push8($14);
			push8(n);
	}
	else
	{
			push8($1c);
			push16le(n, true);
	}
}

macro tsb @n
{
	if(n.bits() <= 8)
	{
			push8($04);
			push8(n);
	}
	else
	{
			push8($0c);
			push16le(n, true);
	}
}

//Branch on Bit Reset
// BBR and BBS test the specified zero page location and branch if the specified bit is clear (BBR) or set (BBS).
// Note that as with TRB, the term reset in BBR is used to mean clear.

macro bbr0 @i,@l
{
	push8($0f);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbr1 @i,@l
{
	push8($1f);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbr2 @i,@l
{
	push8($2f);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbr3 @i,@l
{
	push8($3f);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbr4 @i,@l
{
	push8($4f);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbr5 @i,@l
{
	push8($5f);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbr6 @i,@l
{
	push8($6f);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbr7 @i,@l
{
	push8($7f);
	push8(i);
	push8(c2sr<8>(l-@-1));
}


//Branch on Bit Set
// BBR and BBS test the specified zero page location and branch if the specified bit is clear (BBR) or set (BBS).
// Note that as with TRB, the term reset in BBR is used to mean clear.

macro bbs0 @i,@l
{
	push8($8f);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbs1 @i,@l
{
	push8($9f);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbs2 @i,@l
{
	push8($af);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbs3 @i,@l
{
	push8($bf);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbs4 @i,@l
{
	push8($cf);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbs5 @i,@l
{
	push8($df);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbs6 @i,@l
{
	push8($ef);
	push8(i);
	push8(c2sr<8>(l-@-1));
}
macro bbs7 @i,@l
{
	push8($ff);
	push8(i);
	push8(c2sr<8>(l-@-1));
}

//RMB SMB - Reset or Set Memory Bit

macro rmb0 @i
{
	push8($07);
	push8(i);
}
macro rmb1 @i
{
	push8($17);
	push8(i);
}
macro rmb2 @i
{
	push8($27);
	push8(i);
}
macro rmb3 @i
{
	push8($37);
	push8(i);
}
macro rmb4 @i
{
	push8($47);
	push8(i);
}
macro rmb5 @i
{
	push8($57);
	push8(i);
}
macro rmb6 @i
{
	push8($67);
	push8(i);
}
macro rmb7 @i
{
	push8($77);
	push8(i);
}

macro smb0 @i
{
	push8($87);
	push8(i);
}
macro smb1 @i
{
	push8($97);
	push8(i);
}
macro smb2 @i
{
	push8($a7);
	push8(i);
}
macro smb3 @i
{
	push8($b7);
	push8(i);
}
macro smb4 @i
{
	push8($c7);
	push8(i);
}
macro smb5 @i
{
	push8($d7);
	push8(i);
}
macro smb6 @i
{
	push8($e7);
	push8(i);
}
macro smb7 @i
{
	push8($f7);
	push8(i);
}

macro stp
{
	push8($db);
}

macro wai
{
	push8($cb);
}





