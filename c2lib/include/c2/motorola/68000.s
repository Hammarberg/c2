/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/c2.s"

#define C2_68000

#define C2Dn d0,d1,d2,d3,d4,d5,d6,d7
#define C2Dns d0,d1,d2,d3,d4,d5,d6,d7,d0.w,d1.w,d2.w,d3.w,d4.w,d5.w,d6.w,d7.w,d0.l,d1.l,d2.l,d3.l,d4.l,d5.l,d6.l,d7.l
#define C2An a0,a1,a2,a3,a4,a5,a6,a7
#define C2DAn d0,d1,d2,d3,d4,d5,d6,d7,a0,a1,a2,a3,a4,a5,a6,a7

macro abcd.b,abcd @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xc100|r1s|(r1d<<9));
}
macro abcd.b,abcd -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0xc108|r1s|(r1d<<9));
}
macro add.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xd000|r1s|(r1d<<9));
}
macro add.b (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xd010|r1s|(r1d<<9));
}
macro add.b (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xd018|r1s|(r1d<<9));
}
macro add.b -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xd020|r1s|(r1d<<9));
}
macro add.b @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xd028|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.b @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xd030|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro add.b (@is).w,@[C2Dn]r1d
{
	push16be(0xd038|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.b (@is).l,@[C2Dn]r1d
{
	push16be(0xd039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.b @is,@[C2Dn]r1d
{
	push16be(0xd039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.b #@is,@[C2Dn]r1d
{
	push16be(0xd03c|(r1d<<9));
	push16be(0|c2ur<8>(is));
}
macro add.b @is(pc),@[C2Dn]r1d
{
	push16be(0xd03a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.b @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xd03b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro add.b @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0xd110|(r1s<<9)|r1d);
}
macro add.b @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0xd118|(r1s<<9)|r1d);
}
macro add.b @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0xd120|(r1s<<9)|r1d);
}
macro add.b @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0xd128|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro add.b @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0xd130|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro add.b @[C2Dn]r1s,(@id).w
{
	push16be(0xd138|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro add.b @[C2Dn]r1s,(@id).l
{
	push16be(0xd139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro add.b @[C2Dn]r1s,@id
{
	push16be(0xd139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro add.w,add @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xd040|r1s|(r1d<<9));
}
macro add.w,add @[C2An]r1s,@[C2Dn]r1d
{
	push16be(0xd048|r1s|(r1d<<9));
}
macro add.w,add (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xd050|r1s|(r1d<<9));
}
macro add.w,add (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xd058|r1s|(r1d<<9));
}
macro add.w,add -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xd060|r1s|(r1d<<9));
}
macro add.w,add @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xd068|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.w,add @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xd070|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro add.w,add (@is).w,@[C2Dn]r1d
{
	push16be(0xd078|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.w,add (@is).l,@[C2Dn]r1d
{
	push16be(0xd079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.w,add @is,@[C2Dn]r1d
{
	push16be(0xd079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.w,add #@is,@[C2Dn]r1d
{
	push16be(0xd07c|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro add.w,add @is(pc),@[C2Dn]r1d
{
	push16be(0xd07a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.w,add @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xd07b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro add.w,add @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0xd150|(r1s<<9)|r1d);
}
macro add.w,add @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0xd158|(r1s<<9)|r1d);
}
macro add.w,add @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0xd160|(r1s<<9)|r1d);
}
macro add.w,add @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0xd168|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro add.w,add @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0xd170|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro add.w,add @[C2Dn]r1s,(@id).w
{
	push16be(0xd178|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro add.w,add @[C2Dn]r1s,(@id).l
{
	push16be(0xd179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro add.w,add @[C2Dn]r1s,@id
{
	push16be(0xd179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro add.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xd080|r1s|(r1d<<9));
}
macro add.l @[C2An]r1s,@[C2Dn]r1d
{
	push16be(0xd088|r1s|(r1d<<9));
}
macro add.l (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xd090|r1s|(r1d<<9));
}
macro add.l (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xd098|r1s|(r1d<<9));
}
macro add.l -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xd0a0|r1s|(r1d<<9));
}
macro add.l @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xd0a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xd0b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro add.l (@is).w,@[C2Dn]r1d
{
	push16be(0xd0b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.l (@is).l,@[C2Dn]r1d
{
	push16be(0xd0b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.l @is,@[C2Dn]r1d
{
	push16be(0xd0b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.l #@is,@[C2Dn]r1d
{
	push16be(0xd0bc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.l @is(pc),@[C2Dn]r1d
{
	push16be(0xd0ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.l @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xd0bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro add.l @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0xd190|(r1s<<9)|r1d);
}
macro add.l @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0xd198|(r1s<<9)|r1d);
}
macro add.l @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0xd1a0|(r1s<<9)|r1d);
}
macro add.l @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0xd1a8|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro add.l @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0xd1b0|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro add.l @[C2Dn]r1s,(@id).w
{
	push16be(0xd1b8|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro add.l @[C2Dn]r1s,(@id).l
{
	push16be(0xd1b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro add.l @[C2Dn]r1s,@id
{
	push16be(0xd1b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro add.w,add @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0xd0c0|r1s|(r1d<<9));
}
macro add.w,add @[C2An]r1s,@[C2An]r1d
{
	push16be(0xd0c8|r1s|(r1d<<9));
}
macro add.w,add (@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd0d0|r1s|(r1d<<9));
}
macro add.w,add (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0xd0d8|r1s|(r1d<<9));
}
macro add.w,add -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd0e0|r1s|(r1d<<9));
}
macro add.w,add @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd0e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.w,add @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xd0f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro add.w,add (@is).w,@[C2An]r1d
{
	push16be(0xd0f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.w,add (@is).l,@[C2An]r1d
{
	push16be(0xd0f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.w,add @is,@[C2An]r1d
{
	push16be(0xd0f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.w,add #@is,@[C2An]r1d
{
	push16be(0xd0fc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro add.w,add @is(pc),@[C2An]r1d
{
	push16be(0xd0fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.w,add @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xd0fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro add.l @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0xd1c0|r1s|(r1d<<9));
}
macro add.l @[C2An]r1s,@[C2An]r1d
{
	push16be(0xd1c8|r1s|(r1d<<9));
}
macro add.l (@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd1d0|r1s|(r1d<<9));
}
macro add.l (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0xd1d8|r1s|(r1d<<9));
}
macro add.l -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd1e0|r1s|(r1d<<9));
}
macro add.l @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd1e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xd1f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro add.l (@is).w,@[C2An]r1d
{
	push16be(0xd1f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.l (@is).l,@[C2An]r1d
{
	push16be(0xd1f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.l @is,@[C2An]r1d
{
	push16be(0xd1f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.l #@is,@[C2An]r1d
{
	push16be(0xd1fc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro add.l @is(pc),@[C2An]r1d
{
	push16be(0xd1fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro add.l @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xd1fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro adda.w,adda @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0xd0c0|r1s|(r1d<<9));
}
macro adda.w,adda @[C2An]r1s,@[C2An]r1d
{
	push16be(0xd0c8|r1s|(r1d<<9));
}
macro adda.w,adda (@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd0d0|r1s|(r1d<<9));
}
macro adda.w,adda (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0xd0d8|r1s|(r1d<<9));
}
macro adda.w,adda -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd0e0|r1s|(r1d<<9));
}
macro adda.w,adda @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd0e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro adda.w,adda @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xd0f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro adda.w,adda (@is).w,@[C2An]r1d
{
	push16be(0xd0f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro adda.w,adda (@is).l,@[C2An]r1d
{
	push16be(0xd0f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro adda.w,adda @is,@[C2An]r1d
{
	push16be(0xd0f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro adda.w,adda #@is,@[C2An]r1d
{
	push16be(0xd0fc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro adda.w,adda @is(pc),@[C2An]r1d
{
	push16be(0xd0fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro adda.w,adda @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xd0fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro adda.l @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0xd1c0|r1s|(r1d<<9));
}
macro adda.l @[C2An]r1s,@[C2An]r1d
{
	push16be(0xd1c8|r1s|(r1d<<9));
}
macro adda.l (@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd1d0|r1s|(r1d<<9));
}
macro adda.l (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0xd1d8|r1s|(r1d<<9));
}
macro adda.l -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd1e0|r1s|(r1d<<9));
}
macro adda.l @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xd1e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro adda.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xd1f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro adda.l (@is).w,@[C2An]r1d
{
	push16be(0xd1f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro adda.l (@is).l,@[C2An]r1d
{
	push16be(0xd1f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro adda.l @is,@[C2An]r1d
{
	push16be(0xd1f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro adda.l #@is,@[C2An]r1d
{
	push16be(0xd1fc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro adda.l @is(pc),@[C2An]r1d
{
	push16be(0xd1fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro adda.l @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xd1fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro addi.b #@is,@[C2Dn]r1d
{
	push16be(0x0600|r1d);
	push16be(0|c2ur<8>(is));
}
macro addi.b #@is,(@[C2An]r1d)
{
	push16be(0x0610|r1d);
	push16be(0|c2ur<8>(is));
}
macro addi.b #@is,(@[C2An]r1d)+
{
	push16be(0x0618|r1d);
	push16be(0|c2ur<8>(is));
}
macro addi.b #@is,-(@[C2An]r1d)
{
	push16be(0x0620|r1d);
	push16be(0|c2ur<8>(is));
}
macro addi.b #@is,@id(@[C2An]r1d)
{
	push16be(0x0628|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro addi.b #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0630|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro addi.b #@is,(@id).w
{
	push16be(0x0638);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro addi.b #@is,(@id).l
{
	push16be(0x0639);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro addi.b #@is,@id
{
	push16be(0x0639);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro addi.w,addi #@is,@[C2Dn]r1d
{
	push16be(0x0640|r1d);
	push16be(0|c2ur<16>(is));
}
macro addi.w,addi #@is,(@[C2An]r1d)
{
	push16be(0x0650|r1d);
	push16be(0|c2ur<16>(is));
}
macro addi.w,addi #@is,(@[C2An]r1d)+
{
	push16be(0x0658|r1d);
	push16be(0|c2ur<16>(is));
}
macro addi.w,addi #@is,-(@[C2An]r1d)
{
	push16be(0x0660|r1d);
	push16be(0|c2ur<16>(is));
}
macro addi.w,addi #@is,@id(@[C2An]r1d)
{
	push16be(0x0668|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro addi.w,addi #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0670|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro addi.w,addi #@is,(@id).w
{
	push16be(0x0678);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro addi.w,addi #@is,(@id).l
{
	push16be(0x0679);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro addi.w,addi #@is,@id
{
	push16be(0x0679);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro addi.l #@is,@[C2Dn]r1d
{
	push16be(0x0680|r1d);
	push32be(0|c2ur<32>(is));
}
macro addi.l #@is,(@[C2An]r1d)
{
	push16be(0x0690|r1d);
	push32be(0|c2ur<32>(is));
}
macro addi.l #@is,(@[C2An]r1d)+
{
	push16be(0x0698|r1d);
	push32be(0|c2ur<32>(is));
}
macro addi.l #@is,-(@[C2An]r1d)
{
	push16be(0x06a0|r1d);
	push32be(0|c2ur<32>(is));
}
macro addi.l #@is,@id(@[C2An]r1d)
{
	push16be(0x06a8|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro addi.l #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x06b0|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro addi.l #@is,(@id).w
{
	push16be(0x06b8);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro addi.l #@is,(@id).l
{
	push16be(0x06b9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro addi.l #@is,@id
{
	push16be(0x06b9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro addq.b #@qs,@[C2Dn]r1d
{
	push16be(0x5000|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.b #@qs,(@[C2An]r1d)
{
	push16be(0x5010|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.b #@qs,(@[C2An]r1d)+
{
	push16be(0x5018|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.b #@qs,-(@[C2An]r1d)
{
	push16be(0x5020|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.b #@qs,@id(@[C2An]r1d)
{
	push16be(0x5028|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro addq.b #@qs,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x5030|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro addq.b #@qs,(@id).w
{
	push16be(0x5038|(c2lh<1,8>(qs)&7)<<9));
	push16be(0|c2sr<16>(id));
}
macro addq.b #@qs,(@id).l
{
	push16be(0x5039|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro addq.b #@qs,@id
{
	push16be(0x5039|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro addq.w,addq #@qs,@[C2Dn]r1d
{
	push16be(0x5040|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.w,addq #@qs,@[C2An]r1d
{
	push16be(0x5048|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.w,addq #@qs,(@[C2An]r1d)
{
	push16be(0x5050|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.w,addq #@qs,(@[C2An]r1d)+
{
	push16be(0x5058|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.w,addq #@qs,-(@[C2An]r1d)
{
	push16be(0x5060|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.w,addq #@qs,@id(@[C2An]r1d)
{
	push16be(0x5068|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro addq.w,addq #@qs,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x5070|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro addq.w,addq #@qs,(@id).w
{
	push16be(0x5078|(c2lh<1,8>(qs)&7)<<9));
	push16be(0|c2sr<16>(id));
}
macro addq.w,addq #@qs,(@id).l
{
	push16be(0x5079|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro addq.w,addq #@qs,@id
{
	push16be(0x5079|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro addq.l #@qs,@[C2Dn]r1d
{
	push16be(0x5080|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.l #@qs,@[C2An]r1d
{
	push16be(0x5088|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.l #@qs,(@[C2An]r1d)
{
	push16be(0x5090|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.l #@qs,(@[C2An]r1d)+
{
	push16be(0x5098|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.l #@qs,-(@[C2An]r1d)
{
	push16be(0x50a0|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro addq.l #@qs,@id(@[C2An]r1d)
{
	push16be(0x50a8|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro addq.l #@qs,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x50b0|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro addq.l #@qs,(@id).w
{
	push16be(0x50b8|(c2lh<1,8>(qs)&7)<<9));
	push16be(0|c2sr<16>(id));
}
macro addq.l #@qs,(@id).l
{
	push16be(0x50b9|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro addq.l #@qs,@id
{
	push16be(0x50b9|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro addx.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xd100|r1s|(r1d<<9));
}
macro addx.b -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0xd108|r1s|(r1d<<9));
}
macro addx.w,addx @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xd140|r1s|(r1d<<9));
}
macro addx.w,addx -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0xd148|r1s|(r1d<<9));
}
macro addx.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xd180|r1s|(r1d<<9));
}
macro addx.l -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0xd188|r1s|(r1d<<9));
}
macro and.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xc000|r1s|(r1d<<9));
}
macro and.b (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc010|r1s|(r1d<<9));
}
macro and.b (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xc018|r1s|(r1d<<9));
}
macro and.b -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc020|r1s|(r1d<<9));
}
macro and.b @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc028|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro and.b @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xc030|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro and.b (@is).w,@[C2Dn]r1d
{
	push16be(0xc038|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro and.b (@is).l,@[C2Dn]r1d
{
	push16be(0xc039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro and.b @is,@[C2Dn]r1d
{
	push16be(0xc039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro and.b #@is,@[C2Dn]r1d
{
	push16be(0xc03c|(r1d<<9));
	push16be(0|c2ur<8>(is));
}
macro and.b @is(pc),@[C2Dn]r1d
{
	push16be(0xc03a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro and.b @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xc03b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro and.b @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0xc110|(r1s<<9)|r1d);
}
macro and.b @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0xc118|(r1s<<9)|r1d);
}
macro and.b @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0xc120|(r1s<<9)|r1d);
}
macro and.b @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0xc128|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro and.b @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0xc130|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro and.b @[C2Dn]r1s,(@id).w
{
	push16be(0xc138|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro and.b @[C2Dn]r1s,(@id).l
{
	push16be(0xc139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro and.b @[C2Dn]r1s,@id
{
	push16be(0xc139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro and.w,and @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xc040|r1s|(r1d<<9));
}
macro and.w,and (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc050|r1s|(r1d<<9));
}
macro and.w,and (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xc058|r1s|(r1d<<9));
}
macro and.w,and -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc060|r1s|(r1d<<9));
}
macro and.w,and @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc068|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro and.w,and @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xc070|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro and.w,and (@is).w,@[C2Dn]r1d
{
	push16be(0xc078|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro and.w,and (@is).l,@[C2Dn]r1d
{
	push16be(0xc079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro and.w,and @is,@[C2Dn]r1d
{
	push16be(0xc079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro and.w,and #@is,@[C2Dn]r1d
{
	push16be(0xc07c|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro and.w,and @is(pc),@[C2Dn]r1d
{
	push16be(0xc07a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro and.w,and @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xc07b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro and.w,and @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0xc150|(r1s<<9)|r1d);
}
macro and.w,and @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0xc158|(r1s<<9)|r1d);
}
macro and.w,and @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0xc160|(r1s<<9)|r1d);
}
macro and.w,and @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0xc168|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro and.w,and @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0xc170|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro and.w,and @[C2Dn]r1s,(@id).w
{
	push16be(0xc178|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro and.w,and @[C2Dn]r1s,(@id).l
{
	push16be(0xc179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro and.w,and @[C2Dn]r1s,@id
{
	push16be(0xc179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro and.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xc080|r1s|(r1d<<9));
}
macro and.l (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc090|r1s|(r1d<<9));
}
macro and.l (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xc098|r1s|(r1d<<9));
}
macro and.l -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc0a0|r1s|(r1d<<9));
}
macro and.l @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc0a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro and.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xc0b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro and.l (@is).w,@[C2Dn]r1d
{
	push16be(0xc0b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro and.l (@is).l,@[C2Dn]r1d
{
	push16be(0xc0b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro and.l @is,@[C2Dn]r1d
{
	push16be(0xc0b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro and.l #@is,@[C2Dn]r1d
{
	push16be(0xc0bc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro and.l @is(pc),@[C2Dn]r1d
{
	push16be(0xc0ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro and.l @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xc0bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro and.l @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0xc190|(r1s<<9)|r1d);
}
macro and.l @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0xc198|(r1s<<9)|r1d);
}
macro and.l @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0xc1a0|(r1s<<9)|r1d);
}
macro and.l @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0xc1a8|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro and.l @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0xc1b0|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro and.l @[C2Dn]r1s,(@id).w
{
	push16be(0xc1b8|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro and.l @[C2Dn]r1s,(@id).l
{
	push16be(0xc1b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro and.l @[C2Dn]r1s,@id
{
	push16be(0xc1b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro andi.b #@is,@[C2Dn]r1d
{
	push16be(0x0200|r1d);
	push16be(0|c2ur<8>(is));
}
macro andi.b #@is,(@[C2An]r1d)
{
	push16be(0x0210|r1d);
	push16be(0|c2ur<8>(is));
}
macro andi.b #@is,(@[C2An]r1d)+
{
	push16be(0x0218|r1d);
	push16be(0|c2ur<8>(is));
}
macro andi.b #@is,-(@[C2An]r1d)
{
	push16be(0x0220|r1d);
	push16be(0|c2ur<8>(is));
}
macro andi.b #@is,@id(@[C2An]r1d)
{
	push16be(0x0228|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro andi.b #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0230|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro andi.b #@is,(@id).w
{
	push16be(0x0238);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro andi.b #@is,(@id).l
{
	push16be(0x0239);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro andi.b #@is,@id
{
	push16be(0x0239);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro andi.w,andi #@is,@[C2Dn]r1d
{
	push16be(0x0240|r1d);
	push16be(0|c2ur<16>(is));
}
macro andi.w,andi #@is,(@[C2An]r1d)
{
	push16be(0x0250|r1d);
	push16be(0|c2ur<16>(is));
}
macro andi.w,andi #@is,(@[C2An]r1d)+
{
	push16be(0x0258|r1d);
	push16be(0|c2ur<16>(is));
}
macro andi.w,andi #@is,-(@[C2An]r1d)
{
	push16be(0x0260|r1d);
	push16be(0|c2ur<16>(is));
}
macro andi.w,andi #@is,@id(@[C2An]r1d)
{
	push16be(0x0268|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro andi.w,andi #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0270|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro andi.w,andi #@is,(@id).w
{
	push16be(0x0278);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro andi.w,andi #@is,(@id).l
{
	push16be(0x0279);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro andi.w,andi #@is,@id
{
	push16be(0x0279);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro andi.l #@is,@[C2Dn]r1d
{
	push16be(0x0280|r1d);
	push32be(0|c2ur<32>(is));
}
macro andi.l #@is,(@[C2An]r1d)
{
	push16be(0x0290|r1d);
	push32be(0|c2ur<32>(is));
}
macro andi.l #@is,(@[C2An]r1d)+
{
	push16be(0x0298|r1d);
	push32be(0|c2ur<32>(is));
}
macro andi.l #@is,-(@[C2An]r1d)
{
	push16be(0x02a0|r1d);
	push32be(0|c2ur<32>(is));
}
macro andi.l #@is,@id(@[C2An]r1d)
{
	push16be(0x02a8|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro andi.l #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x02b0|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro andi.l #@is,(@id).w
{
	push16be(0x02b8);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro andi.l #@is,(@id).l
{
	push16be(0x02b9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro andi.l #@is,@id
{
	push16be(0x02b9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro andi.b,andi #@is,ccr
{
	push16be(0x023c);
	push16be(0|c2ur<8>(is));
}
macro andi.w,andi #@is,sr
{
	push16be(0x027c);
	push16be(0|c2ur<16>(is));
}
macro asl.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe120|(r1s<<9)|r1d);
}
macro asl.w,asl @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe160|(r1s<<9)|r1d);
}
macro asl.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe1a0|(r1s<<9)|r1d);
}
macro asl.b #@qs,@[C2Dn]r1d
{
	push16be(0xe100|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro asl.w,asl #@qs,@[C2Dn]r1d
{
	push16be(0xe140|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro asl.l #@qs,@[C2Dn]r1d
{
	push16be(0xe180|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro asl.w,asl (@[C2An]r1s)
{
	push16be(0xe1d0|r1s);
}
macro asl.w,asl (@[C2An]r1s)+
{
	push16be(0xe1d8|r1s);
}
macro asl.w,asl -(@[C2An]r1s)
{
	push16be(0xe1e0|r1s);
}
macro asl.w,asl @is(@[C2An]r1s)
{
	push16be(0xe1e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro asl.w,asl @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xe1f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro asl.w,asl (@is).w
{
	push16be(0xe1f8);
	push16be(0|c2sr<16>(is));
}
macro asl.w,asl (@is).l
{
	push16be(0xe1f9);
	push32be(0|c2ur<32>(is),true);
}
macro asl.w,asl @is
{
	push16be(0xe1f9);
	push32be(0|c2ur<32>(is),true);
}
macro asr.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe020|(r1s<<9)|r1d);
}
macro asr.w,asr @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe060|(r1s<<9)|r1d);
}
macro asr.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe0a0|(r1s<<9)|r1d);
}
macro asr.b #@qs,@[C2Dn]r1d
{
	push16be(0xe000|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro asr.w,asr #@qs,@[C2Dn]r1d
{
	push16be(0xe040|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro asr.l #@qs,@[C2Dn]r1d
{
	push16be(0xe080|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro asr.w,asr (@[C2An]r1s)
{
	push16be(0xe0d0|r1s);
}
macro asr.w,asr (@[C2An]r1s)+
{
	push16be(0xe0d8|r1s);
}
macro asr.w,asr -(@[C2An]r1s)
{
	push16be(0xe0e0|r1s);
}
macro asr.w,asr @is(@[C2An]r1s)
{
	push16be(0xe0e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro asr.w,asr @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xe0f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro asr.w,asr (@is).w
{
	push16be(0xe0f8);
	push16be(0|c2sr<16>(is));
}
macro asr.w,asr (@is).l
{
	push16be(0xe0f9);
	push32be(0|c2ur<32>(is),true);
}
macro asr.w,asr @is
{
	push16be(0xe0f9);
	push32be(0|c2ur<32>(is),true);
}
macro bra.b @bs
{
	push16be(0x6000|c2b<8>(bs-@-2));
}
macro bra.w @bs
{
	push16be(0x6000);
	push16be(0|c2b<16>(bs-@));
}
macro bra @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bra.b bs
	}else{
		taken=1;
		bra.w bs
}
}
macro bsr.b @bs
{
	push16be(0x6100|c2b<8>(bs-@-2));
}
macro bsr.w @bs
{
	push16be(0x6100);
	push16be(0|c2b<16>(bs-@));
}
macro bsr @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bsr.b bs
	}else{
		taken=1;
		bsr.w bs
}
}
macro bhi.b @bs
{
	push16be(0x6200|c2b<8>(bs-@-2));
}
macro bhi.w @bs
{
	push16be(0x6200);
	push16be(0|c2b<16>(bs-@));
}
macro bhi @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bhi.b bs
	}else{
		taken=1;
		bhi.w bs
}
}
macro bls.b @bs
{
	push16be(0x6300|c2b<8>(bs-@-2));
}
macro bls.w @bs
{
	push16be(0x6300);
	push16be(0|c2b<16>(bs-@));
}
macro bls @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bls.b bs
	}else{
		taken=1;
		bls.w bs
}
}
macro bcc.b @bs
{
	push16be(0x6400|c2b<8>(bs-@-2));
}
macro bcc.w @bs
{
	push16be(0x6400);
	push16be(0|c2b<16>(bs-@));
}
macro bcc @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bcc.b bs
	}else{
		taken=1;
		bcc.w bs
}
}
macro bcs.b,blo.b @bs
{
	push16be(0x6500|c2b<8>(bs-@-2));
}
macro bcs.w,blo.w @bs
{
	push16be(0x6500);
	push16be(0|c2b<16>(bs-@));
}
macro bcs,blo @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bcs.b bs
	}else{
		taken=1;
		bcs.w bs
}
}
macro bne.b @bs
{
	push16be(0x6600|c2b<8>(bs-@-2));
}
macro bne.w @bs
{
	push16be(0x6600);
	push16be(0|c2b<16>(bs-@));
}
macro bne @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bne.b bs
	}else{
		taken=1;
		bne.w bs
}
}
macro beq.b @bs
{
	push16be(0x6700|c2b<8>(bs-@-2));
}
macro beq.w @bs
{
	push16be(0x6700);
	push16be(0|c2b<16>(bs-@));
}
macro beq @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		beq.b bs
	}else{
		taken=1;
		beq.w bs
}
}
macro bvc.b @bs
{
	push16be(0x6800|c2b<8>(bs-@-2));
}
macro bvc.w @bs
{
	push16be(0x6800);
	push16be(0|c2b<16>(bs-@));
}
macro bvc @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bvc.b bs
	}else{
		taken=1;
		bvc.w bs
}
}
macro bvs.b @bs
{
	push16be(0x6900|c2b<8>(bs-@-2));
}
macro bvs.w @bs
{
	push16be(0x6900);
	push16be(0|c2b<16>(bs-@));
}
macro bvs @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bvs.b bs
	}else{
		taken=1;
		bvs.w bs
}
}
macro bpl.b @bs
{
	push16be(0x6a00|c2b<8>(bs-@-2));
}
macro bpl.w @bs
{
	push16be(0x6a00);
	push16be(0|c2b<16>(bs-@));
}
macro bpl @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bpl.b bs
	}else{
		taken=1;
		bpl.w bs
}
}
macro bmi.b @bs
{
	push16be(0x6b00|c2b<8>(bs-@-2));
}
macro bmi.w @bs
{
	push16be(0x6b00);
	push16be(0|c2b<16>(bs-@));
}
macro bmi @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bmi.b bs
	}else{
		taken=1;
		bmi.w bs
}
}
macro bge.b @bs
{
	push16be(0x6c00|c2b<8>(bs-@-2));
}
macro bge.w @bs
{
	push16be(0x6c00);
	push16be(0|c2b<16>(bs-@));
}
macro bge @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bge.b bs
	}else{
		taken=1;
		bge.w bs
}
}
macro blt.b @bs
{
	push16be(0x6d00|c2b<8>(bs-@-2));
}
macro blt.w @bs
{
	push16be(0x6d00);
	push16be(0|c2b<16>(bs-@));
}
macro blt @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		blt.b bs
	}else{
		taken=1;
		blt.w bs
}
}
macro bgt.b @bs
{
	push16be(0x6e00|c2b<8>(bs-@-2));
}
macro bgt.w @bs
{
	push16be(0x6e00);
	push16be(0|c2b<16>(bs-@));
}
macro bgt @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		bgt.b bs
	}else{
		taken=1;
		bgt.w bs
}
}
macro ble.b @bs
{
	push16be(0x6f00|c2b<8>(bs-@-2));
}
macro ble.w @bs
{
	push16be(0x6f00);
	push16be(0|c2b<16>(bs-@));
}
macro ble @bs
{
	static int taken=0;
	if(c2bt<8>(bs-@-2,taken)){
		taken=0;
		ble.b bs
	}else{
		taken=1;
		ble.w bs
}
}
macro bchg.b @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x0150|(r1s<<9)|r1d);
}
macro bchg.b @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x0158|(r1s<<9)|r1d);
}
macro bchg.b @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x0160|(r1s<<9)|r1d);
}
macro bchg.b @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x0168|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro bchg.b @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0170|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro bchg.b @[C2Dn]r1s,(@id).w
{
	push16be(0x0178|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro bchg.b @[C2Dn]r1s,(@id).l
{
	push16be(0x0179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro bchg.b @[C2Dn]r1s,@id
{
	push16be(0x0179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro bchg.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x0140|(r1s<<9)|r1d);
}
macro bchg.b #@us,(@[C2An]r1d)
{
	push16be(0x0850|r1d);
	push16be(0|c2r<8>(us));
}
macro bchg.b #@us,(@[C2An]r1d)+
{
	push16be(0x0858|r1d);
	push16be(0|c2r<8>(us));
}
macro bchg.b #@us,-(@[C2An]r1d)
{
	push16be(0x0860|r1d);
	push16be(0|c2r<8>(us));
}
macro bchg.b #@us,@id(@[C2An]r1d)
{
	push16be(0x0868|r1d);
	push16be(0|c2r<8>(us));
	push16be(0|c2sr<16>(id));
}
macro bchg.b #@us,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0870|r1d);
	push16be(0|c2r<8>(us));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro bchg.b #@us,(@id).w
{
	push16be(0x0878);
	push16be(0|c2r<8>(us));
	push16be(0|c2sr<16>(id));
}
macro bchg.b #@us,(@id).l
{
	push16be(0x0879);
	push16be(0|c2r<8>(us));
	push32be(0|c2sr<32>(id),true);
}
macro bchg.b #@us,@id
{
	push16be(0x0879);
	push16be(0|c2r<8>(us));
	push32be(0|c2sr<32>(id),true);
}
macro bchg.l #@us,@[C2Dn]r1d
{
	push16be(0x0840|r1d);
	push16be(0|c2r<8>(us));
}
macro bclr.b @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x0190|(r1s<<9)|r1d);
}
macro bclr.b @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x0198|(r1s<<9)|r1d);
}
macro bclr.b @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x01a0|(r1s<<9)|r1d);
}
macro bclr.b @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x01a8|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro bclr.b @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x01b0|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro bclr.b @[C2Dn]r1s,(@id).w
{
	push16be(0x01b8|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro bclr.b @[C2Dn]r1s,(@id).l
{
	push16be(0x01b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro bclr.b @[C2Dn]r1s,@id
{
	push16be(0x01b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro bclr.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x0180|(r1s<<9)|r1d);
}
macro bclr.b #@us,(@[C2An]r1d)
{
	push16be(0x0890|r1d);
	push16be(0|c2r<8>(us));
}
macro bclr.b #@us,(@[C2An]r1d)+
{
	push16be(0x0898|r1d);
	push16be(0|c2r<8>(us));
}
macro bclr.b #@us,-(@[C2An]r1d)
{
	push16be(0x08a0|r1d);
	push16be(0|c2r<8>(us));
}
macro bclr.b #@us,@id(@[C2An]r1d)
{
	push16be(0x08a8|r1d);
	push16be(0|c2r<8>(us));
	push16be(0|c2sr<16>(id));
}
macro bclr.b #@us,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x08b0|r1d);
	push16be(0|c2r<8>(us));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro bclr.b #@us,(@id).w
{
	push16be(0x08b8);
	push16be(0|c2r<8>(us));
	push16be(0|c2sr<16>(id));
}
macro bclr.b #@us,(@id).l
{
	push16be(0x08b9);
	push16be(0|c2r<8>(us));
	push32be(0|c2sr<32>(id),true);
}
macro bclr.b #@us,@id
{
	push16be(0x08b9);
	push16be(0|c2r<8>(us));
	push32be(0|c2sr<32>(id),true);
}
macro bclr.l #@us,@[C2Dn]r1d
{
	push16be(0x0880|r1d);
	push16be(0|c2r<8>(us));
}
macro bset.b @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x01d0|(r1s<<9)|r1d);
}
macro bset.b @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x01d8|(r1s<<9)|r1d);
}
macro bset.b @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x01e0|(r1s<<9)|r1d);
}
macro bset.b @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x01e8|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro bset.b @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x01f0|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro bset.b @[C2Dn]r1s,(@id).w
{
	push16be(0x01f8|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro bset.b @[C2Dn]r1s,(@id).l
{
	push16be(0x01f9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro bset.b @[C2Dn]r1s,@id
{
	push16be(0x01f9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro bset.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x01c0|(r1s<<9)|r1d);
}
macro bset.b #@us,(@[C2An]r1d)
{
	push16be(0x08d0|r1d);
	push16be(0|c2r<8>(us));
}
macro bset.b #@us,(@[C2An]r1d)+
{
	push16be(0x08d8|r1d);
	push16be(0|c2r<8>(us));
}
macro bset.b #@us,-(@[C2An]r1d)
{
	push16be(0x08e0|r1d);
	push16be(0|c2r<8>(us));
}
macro bset.b #@us,@id(@[C2An]r1d)
{
	push16be(0x08e8|r1d);
	push16be(0|c2r<8>(us));
	push16be(0|c2sr<16>(id));
}
macro bset.b #@us,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x08f0|r1d);
	push16be(0|c2r<8>(us));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro bset.b #@us,(@id).w
{
	push16be(0x08f8);
	push16be(0|c2r<8>(us));
	push16be(0|c2sr<16>(id));
}
macro bset.b #@us,(@id).l
{
	push16be(0x08f9);
	push16be(0|c2r<8>(us));
	push32be(0|c2sr<32>(id),true);
}
macro bset.b #@us,@id
{
	push16be(0x08f9);
	push16be(0|c2r<8>(us));
	push32be(0|c2sr<32>(id),true);
}
macro bset.l #@us,@[C2Dn]r1d
{
	push16be(0x08c0|r1d);
	push16be(0|c2r<8>(us));
}
macro btst.b @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x0110|(r1s<<9)|r1d);
}
macro btst.b @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x0118|(r1s<<9)|r1d);
}
macro btst.b @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x0120|(r1s<<9)|r1d);
}
macro btst.b @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x0128|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro btst.b @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0130|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro btst.b @[C2Dn]r1s,(@id).w
{
	push16be(0x0138|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro btst.b @[C2Dn]r1s,(@id).l
{
	push16be(0x0139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro btst.b @[C2Dn]r1s,@id
{
	push16be(0x0139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro btst.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x0100|(r1s<<9)|r1d);
}
macro btst.b #@us,(@[C2An]r1d)
{
	push16be(0x0810|r1d);
	push16be(0|c2r<8>(us));
}
macro btst.b #@us,(@[C2An]r1d)+
{
	push16be(0x0818|r1d);
	push16be(0|c2r<8>(us));
}
macro btst.b #@us,-(@[C2An]r1d)
{
	push16be(0x0820|r1d);
	push16be(0|c2r<8>(us));
}
macro btst.b #@us,@id(@[C2An]r1d)
{
	push16be(0x0828|r1d);
	push16be(0|c2r<8>(us));
	push16be(0|c2sr<16>(id));
}
macro btst.b #@us,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0830|r1d);
	push16be(0|c2r<8>(us));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro btst.b #@us,(@id).w
{
	push16be(0x0838);
	push16be(0|c2r<8>(us));
	push16be(0|c2sr<16>(id));
}
macro btst.b #@us,(@id).l
{
	push16be(0x0839);
	push16be(0|c2r<8>(us));
	push32be(0|c2sr<32>(id),true);
}
macro btst.b #@us,@id
{
	push16be(0x0839);
	push16be(0|c2r<8>(us));
	push32be(0|c2sr<32>(id),true);
}
macro btst.l #@us,@[C2Dn]r1d
{
	push16be(0x0800|r1d);
	push16be(0|c2r<8>(us));
}
macro chk.w,chk @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x4180|r1s|(r1d<<9));
}
macro chk.w,chk (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x4190|r1s|(r1d<<9));
}
macro chk.w,chk (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x4198|r1s|(r1d<<9));
}
macro chk.w,chk -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x41a0|r1s|(r1d<<9));
}
macro chk.w,chk @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x41a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro chk.w,chk @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x41b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro chk.w,chk (@is).w,@[C2Dn]r1d
{
	push16be(0x41b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro chk.w,chk (@is).l,@[C2Dn]r1d
{
	push16be(0x41b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro chk.w,chk @is,@[C2Dn]r1d
{
	push16be(0x41b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro chk.w,chk #@is,@[C2Dn]r1d
{
	push16be(0x41bc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro chk.w,chk @is(pc),@[C2Dn]r1d
{
	push16be(0x41ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro chk.w,chk @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x41bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro clr.b @[C2Dn]r1s
{
	push16be(0x4200|r1s);
}
macro clr.b (@[C2An]r1s)
{
	push16be(0x4210|r1s);
}
macro clr.b (@[C2An]r1s)+
{
	push16be(0x4218|r1s);
}
macro clr.b -(@[C2An]r1s)
{
	push16be(0x4220|r1s);
}
macro clr.b @is(@[C2An]r1s)
{
	push16be(0x4228|r1s);
	push16be(0|c2sr<16>(is));
}
macro clr.b @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4230|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro clr.b (@is).w
{
	push16be(0x4238);
	push16be(0|c2sr<16>(is));
}
macro clr.b (@is).l
{
	push16be(0x4239);
	push32be(0|c2ur<32>(is),true);
}
macro clr.b @is
{
	push16be(0x4239);
	push32be(0|c2ur<32>(is),true);
}
macro clr.b @is(pc)
{
	push16be(0x423a);
	push16be(0|c2sr<16>(is));
}
macro clr.b @is(pc,@[C2Dns]r2s)
{
	push16be(0x423b);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro clr.w,clr @[C2Dn]r1s
{
	push16be(0x4240|r1s);
}
macro clr.w,clr (@[C2An]r1s)
{
	push16be(0x4250|r1s);
}
macro clr.w,clr (@[C2An]r1s)+
{
	push16be(0x4258|r1s);
}
macro clr.w,clr -(@[C2An]r1s)
{
	push16be(0x4260|r1s);
}
macro clr.w,clr @is(@[C2An]r1s)
{
	push16be(0x4268|r1s);
	push16be(0|c2sr<16>(is));
}
macro clr.w,clr @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4270|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro clr.w,clr (@is).w
{
	push16be(0x4278);
	push16be(0|c2sr<16>(is));
}
macro clr.w,clr (@is).l
{
	push16be(0x4279);
	push32be(0|c2ur<32>(is),true);
}
macro clr.w,clr @is
{
	push16be(0x4279);
	push32be(0|c2ur<32>(is),true);
}
macro clr.w,clr @is(pc)
{
	push16be(0x427a);
	push16be(0|c2sr<16>(is));
}
macro clr.w,clr @is(pc,@[C2Dns]r2s)
{
	push16be(0x427b);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro clr.l @[C2Dn]r1s
{
	push16be(0x4280|r1s);
}
macro clr.l (@[C2An]r1s)
{
	push16be(0x4290|r1s);
}
macro clr.l (@[C2An]r1s)+
{
	push16be(0x4298|r1s);
}
macro clr.l -(@[C2An]r1s)
{
	push16be(0x42a0|r1s);
}
macro clr.l @is(@[C2An]r1s)
{
	push16be(0x42a8|r1s);
	push16be(0|c2sr<16>(is));
}
macro clr.l @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x42b0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro clr.l (@is).w
{
	push16be(0x42b8);
	push16be(0|c2sr<16>(is));
}
macro clr.l (@is).l
{
	push16be(0x42b9);
	push32be(0|c2ur<32>(is),true);
}
macro clr.l @is
{
	push16be(0x42b9);
	push32be(0|c2ur<32>(is),true);
}
macro clr.l @is(pc)
{
	push16be(0x42ba);
	push16be(0|c2sr<16>(is));
}
macro clr.l @is(pc,@[C2Dns]r2s)
{
	push16be(0x42bb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmp.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xb000|r1s|(r1d<<9));
}
macro cmp.b (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xb010|r1s|(r1d<<9));
}
macro cmp.b (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xb018|r1s|(r1d<<9));
}
macro cmp.b -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xb020|r1s|(r1d<<9));
}
macro cmp.b @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xb028|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmp.b @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xb030|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmp.b (@is).w,@[C2Dn]r1d
{
	push16be(0xb038|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmp.b (@is).l,@[C2Dn]r1d
{
	push16be(0xb039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmp.b @is,@[C2Dn]r1d
{
	push16be(0xb039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmp.b #@is,@[C2Dn]r1d
{
	push16be(0xb03c|(r1d<<9));
	push16be(0|c2ur<8>(is));
}
macro cmp.b @is(pc),@[C2Dn]r1d
{
	push16be(0xb03a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmp.b @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xb03b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmp.w,cmp @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xb040|r1s|(r1d<<9));
}
macro cmp.w,cmp @[C2An]r1s,@[C2Dn]r1d
{
	push16be(0xb048|r1s|(r1d<<9));
}
macro cmp.w,cmp (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xb050|r1s|(r1d<<9));
}
macro cmp.w,cmp (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xb058|r1s|(r1d<<9));
}
macro cmp.w,cmp -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xb060|r1s|(r1d<<9));
}
macro cmp.w,cmp @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xb068|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmp.w,cmp @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xb070|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmp.w,cmp (@is).w,@[C2Dn]r1d
{
	push16be(0xb078|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmp.w,cmp (@is).l,@[C2Dn]r1d
{
	push16be(0xb079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmp.w,cmp @is,@[C2Dn]r1d
{
	push16be(0xb079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmp.w,cmp #@is,@[C2Dn]r1d
{
	push16be(0xb07c|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro cmp.w,cmp @is(pc),@[C2Dn]r1d
{
	push16be(0xb07a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmp.w,cmp @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xb07b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmp.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xb080|r1s|(r1d<<9));
}
macro cmp.l @[C2An]r1s,@[C2Dn]r1d
{
	push16be(0xb088|r1s|(r1d<<9));
}
macro cmp.l (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xb090|r1s|(r1d<<9));
}
macro cmp.l (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xb098|r1s|(r1d<<9));
}
macro cmp.l -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xb0a0|r1s|(r1d<<9));
}
macro cmp.l @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xb0a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmp.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xb0b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmp.l (@is).w,@[C2Dn]r1d
{
	push16be(0xb0b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmp.l (@is).l,@[C2Dn]r1d
{
	push16be(0xb0b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmp.l @is,@[C2Dn]r1d
{
	push16be(0xb0b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmp.l #@is,@[C2Dn]r1d
{
	push16be(0xb0bc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmp.l @is(pc),@[C2Dn]r1d
{
	push16be(0xb0ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmp.l @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xb0bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmpa.w,cmpa @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0xb0c0|r1s|(r1d<<9));
}
macro cmpa.w,cmpa @[C2An]r1s,@[C2An]r1d
{
	push16be(0xb0c8|r1s|(r1d<<9));
}
macro cmpa.w,cmpa (@[C2An]r1s),@[C2An]r1d
{
	push16be(0xb0d0|r1s|(r1d<<9));
}
macro cmpa.w,cmpa (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0xb0d8|r1s|(r1d<<9));
}
macro cmpa.w,cmpa -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xb0e0|r1s|(r1d<<9));
}
macro cmpa.w,cmpa @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xb0e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmpa.w,cmpa @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xb0f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmpa.w,cmpa (@is).w,@[C2An]r1d
{
	push16be(0xb0f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmpa.w,cmpa (@is).l,@[C2An]r1d
{
	push16be(0xb0f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmpa.w,cmpa @is,@[C2An]r1d
{
	push16be(0xb0f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmpa.w,cmpa #@is,@[C2An]r1d
{
	push16be(0xb0fc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro cmpa.w,cmpa @is(pc),@[C2An]r1d
{
	push16be(0xb0fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmpa.w,cmpa @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xb0fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmpa.l @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0xb1c0|r1s|(r1d<<9));
}
macro cmpa.l @[C2An]r1s,@[C2An]r1d
{
	push16be(0xb1c8|r1s|(r1d<<9));
}
macro cmpa.l (@[C2An]r1s),@[C2An]r1d
{
	push16be(0xb1d0|r1s|(r1d<<9));
}
macro cmpa.l (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0xb1d8|r1s|(r1d<<9));
}
macro cmpa.l -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xb1e0|r1s|(r1d<<9));
}
macro cmpa.l @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0xb1e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmpa.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xb1f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmpa.l (@is).w,@[C2An]r1d
{
	push16be(0xb1f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmpa.l (@is).l,@[C2An]r1d
{
	push16be(0xb1f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmpa.l @is,@[C2An]r1d
{
	push16be(0xb1f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmpa.l #@is,@[C2An]r1d
{
	push16be(0xb1fc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro cmpa.l @is(pc),@[C2An]r1d
{
	push16be(0xb1fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro cmpa.l @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0xb1fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro cmpi.b #@is,@[C2Dn]r1d
{
	push16be(0x0c00|r1d);
	push16be(0|c2ur<8>(is));
}
macro cmpi.b #@is,(@[C2An]r1d)
{
	push16be(0x0c10|r1d);
	push16be(0|c2ur<8>(is));
}
macro cmpi.b #@is,(@[C2An]r1d)+
{
	push16be(0x0c18|r1d);
	push16be(0|c2ur<8>(is));
}
macro cmpi.b #@is,-(@[C2An]r1d)
{
	push16be(0x0c20|r1d);
	push16be(0|c2ur<8>(is));
}
macro cmpi.b #@is,@id(@[C2An]r1d)
{
	push16be(0x0c28|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro cmpi.b #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0c30|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro cmpi.b #@is,(@id).w
{
	push16be(0x0c38);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro cmpi.b #@is,(@id).l
{
	push16be(0x0c39);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro cmpi.b #@is,@id
{
	push16be(0x0c39);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro cmpi.b #@is,#@id
{
	push16be(0x0c3c);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<8>(id));
}
macro cmpi.w,cmpi #@is,@[C2Dn]r1d
{
	push16be(0x0c40|r1d);
	push16be(0|c2ur<16>(is));
}
macro cmpi.w,cmpi #@is,(@[C2An]r1d)
{
	push16be(0x0c50|r1d);
	push16be(0|c2ur<16>(is));
}
macro cmpi.w,cmpi #@is,(@[C2An]r1d)+
{
	push16be(0x0c58|r1d);
	push16be(0|c2ur<16>(is));
}
macro cmpi.w,cmpi #@is,-(@[C2An]r1d)
{
	push16be(0x0c60|r1d);
	push16be(0|c2ur<16>(is));
}
macro cmpi.w,cmpi #@is,@id(@[C2An]r1d)
{
	push16be(0x0c68|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro cmpi.w,cmpi #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0c70|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro cmpi.w,cmpi #@is,(@id).w
{
	push16be(0x0c78);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro cmpi.w,cmpi #@is,(@id).l
{
	push16be(0x0c79);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro cmpi.w,cmpi #@is,@id
{
	push16be(0x0c79);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro cmpi.w,cmpi #@is,#@id
{
	push16be(0x0c7c);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro cmpi.l #@is,@[C2Dn]r1d
{
	push16be(0x0c80|r1d);
	push32be(0|c2ur<32>(is));
}
macro cmpi.l #@is,(@[C2An]r1d)
{
	push16be(0x0c90|r1d);
	push32be(0|c2ur<32>(is));
}
macro cmpi.l #@is,(@[C2An]r1d)+
{
	push16be(0x0c98|r1d);
	push32be(0|c2ur<32>(is));
}
macro cmpi.l #@is,-(@[C2An]r1d)
{
	push16be(0x0ca0|r1d);
	push32be(0|c2ur<32>(is));
}
macro cmpi.l #@is,@id(@[C2An]r1d)
{
	push16be(0x0ca8|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro cmpi.l #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0cb0|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro cmpi.l #@is,(@id).w
{
	push16be(0x0cb8);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro cmpi.l #@is,(@id).l
{
	push16be(0x0cb9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro cmpi.l #@is,@id
{
	push16be(0x0cb9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro cmpi.l #@is,#@id
{
	push16be(0x0cbc);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro cmpm.b (@[C2An]r1s)+,(@[C2An]r1d)+
{
	push16be(0xb108|r1s|(r1d<<9));
}
macro cmpm.w,cmpm (@[C2An]r1s)+,(@[C2An]r1d)+
{
	push16be(0xb148|r1s|(r1d<<9));
}
macro cmpm.l (@[C2An]r1s)+,(@[C2An]r1d)+
{
	push16be(0xb188|r1s|(r1d<<9));
}
macro dbt.w,dbt @[C2Dn]r1s,@bs
{
	push16be(0x50c8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbf.w,dbf,dbra.w,dbra @[C2Dn]r1s,@bs
{
	push16be(0x51c8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbhi.w,dbhi @[C2Dn]r1s,@bs
{
	push16be(0x52c8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbls.w,dbls @[C2Dn]r1s,@bs
{
	push16be(0x53c8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbcc.w,dbcc @[C2Dn]r1s,@bs
{
	push16be(0x54c8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbcs.w,dbcs @[C2Dn]r1s,@bs
{
	push16be(0x55c8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbne.w,dbne @[C2Dn]r1s,@bs
{
	push16be(0x56c8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbeq.w,dbeq @[C2Dn]r1s,@bs
{
	push16be(0x57c8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbvc.w,dbvc @[C2Dn]r1s,@bs
{
	push16be(0x58c8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbvs.w,dbvs @[C2Dn]r1s,@bs
{
	push16be(0x59c8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbpl.w,dbpl @[C2Dn]r1s,@bs
{
	push16be(0x5ac8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbmi.w,dbmi @[C2Dn]r1s,@bs
{
	push16be(0x5bc8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbge.w,dbge @[C2Dn]r1s,@bs
{
	push16be(0x5cc8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dblt.w,dblt @[C2Dn]r1s,@bs
{
	push16be(0x5dc8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dbgt.w,dbgt @[C2Dn]r1s,@bs
{
	push16be(0x5ec8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro dble.w,dble @[C2Dn]r1s,@bs
{
	push16be(0x5fc8|r1s);
	push16be(0|c2b<16>(bs-@));
}
macro divs.w,divs @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x81c0|r1s|(r1d<<9));
}
macro divs.w,divs (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x81d0|r1s|(r1d<<9));
}
macro divs.w,divs (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x81d8|r1s|(r1d<<9));
}
macro divs.w,divs -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x81e0|r1s|(r1d<<9));
}
macro divs.w,divs @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x81e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro divs.w,divs @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x81f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro divs.w,divs (@is).w,@[C2Dn]r1d
{
	push16be(0x81f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro divs.w,divs (@is).l,@[C2Dn]r1d
{
	push16be(0x81f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro divs.w,divs @is,@[C2Dn]r1d
{
	push16be(0x81f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro divs.w,divs #@is,@[C2Dn]r1d
{
	push16be(0x81fc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro divs.w,divs @is(pc),@[C2Dn]r1d
{
	push16be(0x81fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro divs.w,divs @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x81fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro divu.w,divu @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x80c0|r1s|(r1d<<9));
}
macro divu.w,divu (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x80d0|r1s|(r1d<<9));
}
macro divu.w,divu (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x80d8|r1s|(r1d<<9));
}
macro divu.w,divu -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x80e0|r1s|(r1d<<9));
}
macro divu.w,divu @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x80e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro divu.w,divu @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x80f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro divu.w,divu (@is).w,@[C2Dn]r1d
{
	push16be(0x80f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro divu.w,divu (@is).l,@[C2Dn]r1d
{
	push16be(0x80f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro divu.w,divu @is,@[C2Dn]r1d
{
	push16be(0x80f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro divu.w,divu #@is,@[C2Dn]r1d
{
	push16be(0x80fc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro divu.w,divu @is(pc),@[C2Dn]r1d
{
	push16be(0x80fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro divu.w,divu @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x80fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro eor.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xb100|(r1s<<9)|r1d);
}
macro eor.b @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0xb110|(r1s<<9)|r1d);
}
macro eor.b @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0xb118|(r1s<<9)|r1d);
}
macro eor.b @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0xb120|(r1s<<9)|r1d);
}
macro eor.b @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0xb128|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro eor.b @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0xb130|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro eor.b @[C2Dn]r1s,(@id).w
{
	push16be(0xb138|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro eor.b @[C2Dn]r1s,(@id).l
{
	push16be(0xb139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro eor.b @[C2Dn]r1s,@id
{
	push16be(0xb139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro eor.w,eor @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xb140|(r1s<<9)|r1d);
}
macro eor.w,eor @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0xb150|(r1s<<9)|r1d);
}
macro eor.w,eor @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0xb158|(r1s<<9)|r1d);
}
macro eor.w,eor @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0xb160|(r1s<<9)|r1d);
}
macro eor.w,eor @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0xb168|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro eor.w,eor @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0xb170|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro eor.w,eor @[C2Dn]r1s,(@id).w
{
	push16be(0xb178|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro eor.w,eor @[C2Dn]r1s,(@id).l
{
	push16be(0xb179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro eor.w,eor @[C2Dn]r1s,@id
{
	push16be(0xb179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro eor.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xb180|(r1s<<9)|r1d);
}
macro eor.l @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0xb190|(r1s<<9)|r1d);
}
macro eor.l @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0xb198|(r1s<<9)|r1d);
}
macro eor.l @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0xb1a0|(r1s<<9)|r1d);
}
macro eor.l @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0xb1a8|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro eor.l @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0xb1b0|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro eor.l @[C2Dn]r1s,(@id).w
{
	push16be(0xb1b8|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro eor.l @[C2Dn]r1s,(@id).l
{
	push16be(0xb1b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro eor.l @[C2Dn]r1s,@id
{
	push16be(0xb1b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro eori.b #@is,@[C2Dn]r1d
{
	push16be(0x0a00|r1d);
	push16be(0|c2ur<8>(is));
}
macro eori.b #@is,(@[C2An]r1d)
{
	push16be(0x0a10|r1d);
	push16be(0|c2ur<8>(is));
}
macro eori.b #@is,(@[C2An]r1d)+
{
	push16be(0x0a18|r1d);
	push16be(0|c2ur<8>(is));
}
macro eori.b #@is,-(@[C2An]r1d)
{
	push16be(0x0a20|r1d);
	push16be(0|c2ur<8>(is));
}
macro eori.b #@is,@id(@[C2An]r1d)
{
	push16be(0x0a28|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro eori.b #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0a30|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro eori.b #@is,(@id).w
{
	push16be(0x0a38);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro eori.b #@is,(@id).l
{
	push16be(0x0a39);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro eori.b #@is,@id
{
	push16be(0x0a39);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro eori.w,eori #@is,@[C2Dn]r1d
{
	push16be(0x0a40|r1d);
	push16be(0|c2ur<16>(is));
}
macro eori.w,eori #@is,(@[C2An]r1d)
{
	push16be(0x0a50|r1d);
	push16be(0|c2ur<16>(is));
}
macro eori.w,eori #@is,(@[C2An]r1d)+
{
	push16be(0x0a58|r1d);
	push16be(0|c2ur<16>(is));
}
macro eori.w,eori #@is,-(@[C2An]r1d)
{
	push16be(0x0a60|r1d);
	push16be(0|c2ur<16>(is));
}
macro eori.w,eori #@is,@id(@[C2An]r1d)
{
	push16be(0x0a68|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro eori.w,eori #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0a70|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro eori.w,eori #@is,(@id).w
{
	push16be(0x0a78);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro eori.w,eori #@is,(@id).l
{
	push16be(0x0a79);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro eori.w,eori #@is,@id
{
	push16be(0x0a79);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro eori.l #@is,@[C2Dn]r1d
{
	push16be(0x0a80|r1d);
	push32be(0|c2ur<32>(is));
}
macro eori.l #@is,(@[C2An]r1d)
{
	push16be(0x0a90|r1d);
	push32be(0|c2ur<32>(is));
}
macro eori.l #@is,(@[C2An]r1d)+
{
	push16be(0x0a98|r1d);
	push32be(0|c2ur<32>(is));
}
macro eori.l #@is,-(@[C2An]r1d)
{
	push16be(0x0aa0|r1d);
	push32be(0|c2ur<32>(is));
}
macro eori.l #@is,@id(@[C2An]r1d)
{
	push16be(0x0aa8|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro eori.l #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0ab0|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro eori.l #@is,(@id).w
{
	push16be(0x0ab8);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro eori.l #@is,(@id).l
{
	push16be(0x0ab9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro eori.l #@is,@id
{
	push16be(0x0ab9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro eori.b,eori #@is,ccr
{
	push16be(0x0a3c);
	push16be(0|c2ur<8>(is));
}
macro eori.w,eori #@is,sr
{
	push16be(0x0a7c);
	push16be(0|c2ur<16>(is));
}
macro exg.l,exg @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xc140|(r1s<<9)|r1d);
}
macro exg.l,exg @[C2An]r1s,@[C2An]r1d
{
	push16be(0xc148|(r1s<<9)|r1d);
}
macro exg.l,exg @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0xc188|(r1s<<9)|r1d);
}
macro ext.w,ext @[C2Dn]r1s
{
	push16be(0x4880|r1s);
}
macro ext.l @[C2Dn]r1s
{
	push16be(0x48c0|r1s);
}
macro illegal
{
	push16be(0x4afc);
}
macro jmp (@[C2An]r1s)
{
	push16be(0x4ed0|r1s);
}
macro jmp @is(@[C2An]r1s)
{
	push16be(0x4ee8|r1s);
	push16be(0|c2sr<16>(is));
}
macro jmp @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4ef0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro jmp (@is).w
{
	push16be(0x4ef8);
	push16be(0|c2sr<16>(is));
}
macro jmp (@is).l
{
	push16be(0x4ef9);
	push32be(0|c2ur<32>(is),true);
}
macro jmp @is
{
	push16be(0x4ef9);
	push32be(0|c2ur<32>(is),true);
}
macro jmp @is(pc)
{
	push16be(0x4efa);
	push16be(0|c2sr<16>(is));
}
macro jmp @is(pc,@[C2Dns]r2s)
{
	push16be(0x4efb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro jsr (@[C2An]r1s)
{
	push16be(0x4e90|r1s);
}
macro jsr @is(@[C2An]r1s)
{
	push16be(0x4ea8|r1s);
	push16be(0|c2sr<16>(is));
}
macro jsr @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4eb0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro jsr (@is).w
{
	push16be(0x4eb8);
	push16be(0|c2sr<16>(is));
}
macro jsr (@is).l
{
	push16be(0x4eb9);
	push32be(0|c2ur<32>(is),true);
}
macro jsr @is
{
	push16be(0x4eb9);
	push32be(0|c2ur<32>(is),true);
}
macro jsr @is(pc)
{
	push16be(0x4eba);
	push16be(0|c2sr<16>(is));
}
macro jsr @is(pc,@[C2Dns]r2s)
{
	push16be(0x4ebb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro lea.l,lea (@[C2An]r1s),@[C2An]r1d
{
	push16be(0x41d0|r1s|(r1d<<9));
}
macro lea.l,lea @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x41e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro lea.l,lea @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x41f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro lea.l,lea (@is).w,@[C2An]r1d
{
	push16be(0x41f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro lea.l,lea (@is).l,@[C2An]r1d
{
	push16be(0x41f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro lea.l,lea @is,@[C2An]r1d
{
	push16be(0x41f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro lea.l,lea @is(pc),@[C2An]r1d
{
	push16be(0x41fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro lea.l,lea @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x41fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro link @[C2An]r1s,#@us
{
	push16be(0x4e50|r1s);
	push16be(0|c2r<16>(us));
}
macro lsl.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe128|(r1s<<9)|r1d);
}
macro lsl.w,lsl @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe168|(r1s<<9)|r1d);
}
macro lsl.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe1a8|(r1s<<9)|r1d);
}
macro lsl.b #@qs,@[C2Dn]r1d
{
	push16be(0xe108|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro lsl.w,lsl #@qs,@[C2Dn]r1d
{
	push16be(0xe148|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro lsl.l #@qs,@[C2Dn]r1d
{
	push16be(0xe188|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro lsl.w,lsl (@[C2An]r1s)
{
	push16be(0xe1d0|r1s);
}
macro lsl.w,lsl (@[C2An]r1s)+
{
	push16be(0xe1d8|r1s);
}
macro lsl.w,lsl -(@[C2An]r1s)
{
	push16be(0xe1e0|r1s);
}
macro lsl.w,lsl @is(@[C2An]r1s)
{
	push16be(0xe1e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro lsl.w,lsl @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xe1f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro lsl.w,lsl (@is).w
{
	push16be(0xe1f8);
	push16be(0|c2sr<16>(is));
}
macro lsl.w,lsl (@is).l
{
	push16be(0xe1f9);
	push32be(0|c2ur<32>(is),true);
}
macro lsl.w,lsl @is
{
	push16be(0xe1f9);
	push32be(0|c2ur<32>(is),true);
}
macro lsr.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe020|(r1s<<9)|r1d);
}
macro lsr.w,lsr @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe060|(r1s<<9)|r1d);
}
macro lsr.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe0a0|(r1s<<9)|r1d);
}
macro lsr.b #@qs,@[C2Dn]r1d
{
	push16be(0xe000|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro lsr.w,lsr #@qs,@[C2Dn]r1d
{
	push16be(0xe040|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro lsr.l #@qs,@[C2Dn]r1d
{
	push16be(0xe080|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro lsr.w,lsr (@[C2An]r1s)
{
	push16be(0xe2d0|r1s);
}
macro lsr.w,lsr (@[C2An]r1s)+
{
	push16be(0xe2d8|r1s);
}
macro lsr.w,lsr -(@[C2An]r1s)
{
	push16be(0xe2e0|r1s);
}
macro lsr.w,lsr @is(@[C2An]r1s)
{
	push16be(0xe2e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro lsr.w,lsr @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xe2f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro lsr.w,lsr (@is).w
{
	push16be(0xe2f8);
	push16be(0|c2sr<16>(is));
}
macro lsr.w,lsr (@is).l
{
	push16be(0xe2f9);
	push32be(0|c2ur<32>(is),true);
}
macro lsr.w,lsr @is
{
	push16be(0xe2f9);
	push32be(0|c2ur<32>(is),true);
}
macro move.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x1000|r1s|(r1d<<9));
}
macro move.b @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0x1040|r1s|(r1d<<9));
}
macro move.b @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x1080|r1s|(r1d<<9));
}
macro move.b @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x10c0|r1s|(r1d<<9));
}
macro move.b @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x1100|r1s|(r1d<<9));
}
macro move.b @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x1140|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.b @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x1180|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b @[C2Dn]r1s,(@id).w
{
	push16be(0x11c0|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.b @[C2Dn]r1s,(@id).l
{
	push16be(0x13c0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.b @[C2Dn]r1s,@id
{
	push16be(0x13c0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.b (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x1010|r1s|(r1d<<9));
}
macro move.b (@[C2An]r1s),@[C2An]r1d
{
	push16be(0x1050|r1s|(r1d<<9));
}
macro move.b (@[C2An]r1s),(@[C2An]r1d)
{
	push16be(0x1090|r1s|(r1d<<9));
}
macro move.b (@[C2An]r1s),(@[C2An]r1d)+
{
	push16be(0x10d0|r1s|(r1d<<9));
}
macro move.b (@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x1110|r1s|(r1d<<9));
}
macro move.b (@[C2An]r1s),@id(@[C2An]r1d)
{
	push16be(0x1150|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.b (@[C2An]r1s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x1190|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b (@[C2An]r1s),(@id).w
{
	push16be(0x11d0|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.b (@[C2An]r1s),(@id).l
{
	push16be(0x13d0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.b (@[C2An]r1s),@id
{
	push16be(0x13d0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.b (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x1018|r1s|(r1d<<9));
}
macro move.b (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0x1058|r1s|(r1d<<9));
}
macro move.b (@[C2An]r1s)+,(@[C2An]r1d)
{
	push16be(0x1098|r1s|(r1d<<9));
}
macro move.b (@[C2An]r1s)+,(@[C2An]r1d)+
{
	push16be(0x10d8|r1s|(r1d<<9));
}
macro move.b (@[C2An]r1s)+,-(@[C2An]r1d)
{
	push16be(0x1118|r1s|(r1d<<9));
}
macro move.b (@[C2An]r1s)+,@id(@[C2An]r1d)
{
	push16be(0x1158|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.b (@[C2An]r1s)+,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x1198|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b (@[C2An]r1s)+,(@id).w
{
	push16be(0x11d8|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.b (@[C2An]r1s)+,(@id).l
{
	push16be(0x13d8|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.b (@[C2An]r1s)+,@id
{
	push16be(0x13d8|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.b -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x1020|r1s|(r1d<<9));
}
macro move.b -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x1060|r1s|(r1d<<9));
}
macro move.b -(@[C2An]r1s),(@[C2An]r1d)
{
	push16be(0x10a0|r1s|(r1d<<9));
}
macro move.b -(@[C2An]r1s),(@[C2An]r1d)+
{
	push16be(0x10e0|r1s|(r1d<<9));
}
macro move.b -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x1120|r1s|(r1d<<9));
}
macro move.b -(@[C2An]r1s),@id(@[C2An]r1d)
{
	push16be(0x1160|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.b -(@[C2An]r1s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x11a0|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b -(@[C2An]r1s),(@id).w
{
	push16be(0x11e0|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.b -(@[C2An]r1s),(@id).l
{
	push16be(0x13e0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.b -(@[C2An]r1s),@id
{
	push16be(0x13e0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.b @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x1028|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x1068|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b @is(@[C2An]r1s),(@[C2An]r1d)
{
	push16be(0x10a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b @is(@[C2An]r1s),(@[C2An]r1d)+
{
	push16be(0x10e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b @is(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x1128|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b @is(@[C2An]r1s),@id(@[C2An]r1d)
{
	push16be(0x1168|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.b @is(@[C2An]r1s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x11a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b @is(@[C2An]r1s),(@id).w
{
	push16be(0x11e8|r1s);
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.b @is(@[C2An]r1s),(@id).l
{
	push16be(0x13e8|r1s);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.b @is(@[C2An]r1s),@id
{
	push16be(0x13e8|r1s);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.b @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x1030|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.b @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x1070|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.b @is(@[C2An]r1s,@[C2Dns]r2s),(@[C2An]r1d)
{
	push16be(0x10b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.b @is(@[C2An]r1s,@[C2Dns]r2s),(@[C2An]r1d)+
{
	push16be(0x10f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.b @is(@[C2An]r1s,@[C2Dns]r2s),-(@[C2An]r1d)
{
	push16be(0x1130|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.b @is(@[C2An]r1s,@[C2Dns]r2s),@id(@[C2An]r1d)
{
	push16be(0x1170|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.b @is(@[C2An]r1s,@[C2Dns]r2s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x11b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b @is(@[C2An]r1s,@[C2Dns]r2s),(@id).w
{
	push16be(0x11f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.b @is(@[C2An]r1s,@[C2Dns]r2s),(@id).l
{
	push16be(0x13f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.b @is(@[C2An]r1s,@[C2Dns]r2s),@id
{
	push16be(0x13f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.b (@is).w,@[C2Dn]r1d
{
	push16be(0x1038|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b (@is).w,@[C2An]r1d
{
	push16be(0x1078|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b (@is).w,(@[C2An]r1d)
{
	push16be(0x10b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b (@is).w,(@[C2An]r1d)+
{
	push16be(0x10f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b (@is).w,-(@[C2An]r1d)
{
	push16be(0x1138|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b (@is).w,@id(@[C2An]r1d)
{
	push16be(0x1178|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.b (@is).w,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x11b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b (@is).w,(@id).w
{
	push16be(0x11f8);
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.b (@is).w,(@id).l
{
	push16be(0x13f8);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.b (@is).w,@id
{
	push16be(0x13f8);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.b (@is).l,@[C2Dn]r1d
{
	push16be(0x1039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.b (@is).l,@[C2An]r1d
{
	push16be(0x1079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.b (@is).l,(@[C2An]r1d)
{
	push16be(0x10b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.b (@is).l,(@[C2An]r1d)+
{
	push16be(0x10f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.b (@is).l,-(@[C2An]r1d)
{
	push16be(0x1139|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.b (@is).l,@id(@[C2An]r1d)
{
	push16be(0x1179|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.b (@is).l,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x11b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b (@is).l,(@id).w
{
	push16be(0x11f9);
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.b (@is).l,(@id).l
{
	push16be(0x13f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.b (@is).l,@id
{
	push16be(0x13f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.b @is,@[C2Dn]r1d
{
	push16be(0x1039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.b @is,@[C2An]r1d
{
	push16be(0x1079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.b @is,(@[C2An]r1d)
{
	push16be(0x10b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.b @is,(@[C2An]r1d)+
{
	push16be(0x10f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.b @is,-(@[C2An]r1d)
{
	push16be(0x1139|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.b @is,@id(@[C2An]r1d)
{
	push16be(0x1179|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.b @is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x11b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b @is,(@id).w
{
	push16be(0x11f9);
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.b @is,(@id).l
{
	push16be(0x13f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.b @is,@id
{
	push16be(0x13f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.b #@is,@[C2Dn]r1d
{
	push16be(0x103c|(r1d<<9));
	push16be(0|c2ur<8>(is));
}
macro move.b #@is,@[C2An]r1d
{
	push16be(0x107c|(r1d<<9));
	push16be(0|c2ur<8>(is));
}
macro move.b #@is,(@[C2An]r1d)
{
	push16be(0x10bc|(r1d<<9));
	push16be(0|c2ur<8>(is));
}
macro move.b #@is,(@[C2An]r1d)+
{
	push16be(0x10fc|(r1d<<9));
	push16be(0|c2ur<8>(is));
}
macro move.b #@is,-(@[C2An]r1d)
{
	push16be(0x113c|(r1d<<9));
	push16be(0|c2ur<8>(is));
}
macro move.b #@is,@id(@[C2An]r1d)
{
	push16be(0x117c|(r1d<<9));
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro move.b #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x11bc|(r1d<<9));
	push16be(0|c2ur<8>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b #@is,(@id).w
{
	push16be(0x11fc);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro move.b #@is,(@id).l
{
	push16be(0x13fc);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro move.b #@is,@id
{
	push16be(0x13fc);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro move.b @is(pc),@[C2Dn]r1d
{
	push16be(0x103a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b @is(pc),@[C2An]r1d
{
	push16be(0x107a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b @is(pc),(@[C2An]r1d)
{
	push16be(0x10ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b @is(pc),(@[C2An]r1d)+
{
	push16be(0x10fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b @is(pc),-(@[C2An]r1d)
{
	push16be(0x113a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.b @is(pc),@id(@[C2An]r1d)
{
	push16be(0x117a|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.b @is(pc),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x11ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b @is(pc),(@id).w
{
	push16be(0x11fa);
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.b @is(pc),(@id).l
{
	push16be(0x13fa);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.b @is(pc),@id
{
	push16be(0x13fa);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.b @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x103b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.b @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x107b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.b @is(pc,@[C2Dns]r2s),(@[C2An]r1d)
{
	push16be(0x10bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.b @is(pc,@[C2Dns]r2s),(@[C2An]r1d)+
{
	push16be(0x10fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.b @is(pc,@[C2Dns]r2s),-(@[C2An]r1d)
{
	push16be(0x113b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.b @is(pc,@[C2Dns]r2s),@id(@[C2An]r1d)
{
	push16be(0x117b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.b @is(pc,@[C2Dns]r2s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x11bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.b @is(pc,@[C2Dns]r2s),(@id).w
{
	push16be(0x11fb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.b @is(pc,@[C2Dns]r2s),(@id).l
{
	push16be(0x13fb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.b @is(pc,@[C2Dns]r2s),@id
{
	push16be(0x13fb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x3000|r1s|(r1d<<9));
}
macro move.w,move @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0x3040|r1s|(r1d<<9));
}
macro move.w,move @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x3080|r1s|(r1d<<9));
}
macro move.w,move @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x30c0|r1s|(r1d<<9));
}
macro move.w,move @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x3100|r1s|(r1d<<9));
}
macro move.w,move @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x3140|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.w,move @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x3180|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move @[C2Dn]r1s,(@id).w
{
	push16be(0x31c0|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.w,move @[C2Dn]r1s,(@id).l
{
	push16be(0x33c0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @[C2Dn]r1s,@id
{
	push16be(0x33c0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @[C2An]r1s,@[C2Dn]r1d
{
	push16be(0x3008|r1s|(r1d<<9));
}
macro move.w,move @[C2An]r1s,@[C2An]r1d
{
	push16be(0x3048|r1s|(r1d<<9));
}
macro move.w,move @[C2An]r1s,(@[C2An]r1d)
{
	push16be(0x3088|r1s|(r1d<<9));
}
macro move.w,move @[C2An]r1s,(@[C2An]r1d)+
{
	push16be(0x30c8|r1s|(r1d<<9));
}
macro move.w,move @[C2An]r1s,-(@[C2An]r1d)
{
	push16be(0x3108|r1s|(r1d<<9));
}
macro move.w,move @[C2An]r1s,@id(@[C2An]r1d)
{
	push16be(0x3148|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.w,move @[C2An]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x3188|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move @[C2An]r1s,(@id).w
{
	push16be(0x31c8|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.w,move @[C2An]r1s,(@id).l
{
	push16be(0x33c8|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @[C2An]r1s,@id
{
	push16be(0x33c8|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x3010|r1s|(r1d<<9));
}
macro move.w,move (@[C2An]r1s),@[C2An]r1d
{
	push16be(0x3050|r1s|(r1d<<9));
}
macro move.w,move (@[C2An]r1s),(@[C2An]r1d)
{
	push16be(0x3090|r1s|(r1d<<9));
}
macro move.w,move (@[C2An]r1s),(@[C2An]r1d)+
{
	push16be(0x30d0|r1s|(r1d<<9));
}
macro move.w,move (@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x3110|r1s|(r1d<<9));
}
macro move.w,move (@[C2An]r1s),@id(@[C2An]r1d)
{
	push16be(0x3150|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.w,move (@[C2An]r1s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x3190|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move (@[C2An]r1s),(@id).w
{
	push16be(0x31d0|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.w,move (@[C2An]r1s),(@id).l
{
	push16be(0x33d0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move (@[C2An]r1s),@id
{
	push16be(0x33d0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x3018|r1s|(r1d<<9));
}
macro move.w,move (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0x3058|r1s|(r1d<<9));
}
macro move.w,move (@[C2An]r1s)+,(@[C2An]r1d)
{
	push16be(0x3098|r1s|(r1d<<9));
}
macro move.w,move (@[C2An]r1s)+,(@[C2An]r1d)+
{
	push16be(0x30d8|r1s|(r1d<<9));
}
macro move.w,move (@[C2An]r1s)+,-(@[C2An]r1d)
{
	push16be(0x3118|r1s|(r1d<<9));
}
macro move.w,move (@[C2An]r1s)+,@id(@[C2An]r1d)
{
	push16be(0x3158|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.w,move (@[C2An]r1s)+,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x3198|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move (@[C2An]r1s)+,(@id).w
{
	push16be(0x31d8|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.w,move (@[C2An]r1s)+,(@id).l
{
	push16be(0x33d8|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move (@[C2An]r1s)+,@id
{
	push16be(0x33d8|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x3020|r1s|(r1d<<9));
}
macro move.w,move -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x3060|r1s|(r1d<<9));
}
macro move.w,move -(@[C2An]r1s),(@[C2An]r1d)
{
	push16be(0x30a0|r1s|(r1d<<9));
}
macro move.w,move -(@[C2An]r1s),(@[C2An]r1d)+
{
	push16be(0x30e0|r1s|(r1d<<9));
}
macro move.w,move -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x3120|r1s|(r1d<<9));
}
macro move.w,move -(@[C2An]r1s),@id(@[C2An]r1d)
{
	push16be(0x3160|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.w,move -(@[C2An]r1s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x31a0|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move -(@[C2An]r1s),(@id).w
{
	push16be(0x31e0|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.w,move -(@[C2An]r1s),(@id).l
{
	push16be(0x33e0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move -(@[C2An]r1s),@id
{
	push16be(0x33e0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x3028|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x3068|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(@[C2An]r1s),(@[C2An]r1d)
{
	push16be(0x30a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(@[C2An]r1s),(@[C2An]r1d)+
{
	push16be(0x30e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x3128|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(@[C2An]r1s),@id(@[C2An]r1d)
{
	push16be(0x3168|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.w,move @is(@[C2An]r1s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x31a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move @is(@[C2An]r1s),(@id).w
{
	push16be(0x31e8|r1s);
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.w,move @is(@[C2An]r1s),(@id).l
{
	push16be(0x33e8|r1s);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @is(@[C2An]r1s),@id
{
	push16be(0x33e8|r1s);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x3030|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x3070|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),(@[C2An]r1d)
{
	push16be(0x30b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),(@[C2An]r1d)+
{
	push16be(0x30f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),-(@[C2An]r1d)
{
	push16be(0x3130|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),@id(@[C2An]r1d)
{
	push16be(0x3170|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x31b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),(@id).w
{
	push16be(0x31f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),(@id).l
{
	push16be(0x33f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),@id
{
	push16be(0x33f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move (@is).w,@[C2Dn]r1d
{
	push16be(0x3038|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move (@is).w,@[C2An]r1d
{
	push16be(0x3078|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move (@is).w,(@[C2An]r1d)
{
	push16be(0x30b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move (@is).w,(@[C2An]r1d)+
{
	push16be(0x30f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move (@is).w,-(@[C2An]r1d)
{
	push16be(0x3138|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move (@is).w,@id(@[C2An]r1d)
{
	push16be(0x3178|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.w,move (@is).w,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x31b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move (@is).w,(@id).w
{
	push16be(0x31f8);
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.w,move (@is).w,(@id).l
{
	push16be(0x33f8);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move (@is).w,@id
{
	push16be(0x33f8);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move (@is).l,@[C2Dn]r1d
{
	push16be(0x3039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move (@is).l,@[C2An]r1d
{
	push16be(0x3079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move (@is).l,(@[C2An]r1d)
{
	push16be(0x30b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move (@is).l,(@[C2An]r1d)+
{
	push16be(0x30f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move (@is).l,-(@[C2An]r1d)
{
	push16be(0x3139|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move (@is).l,@id(@[C2An]r1d)
{
	push16be(0x3179|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.w,move (@is).l,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x31b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move (@is).l,(@id).w
{
	push16be(0x31f9);
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.w,move (@is).l,(@id).l
{
	push16be(0x33f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.w,move (@is).l,@id
{
	push16be(0x33f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.w,move @is,@[C2Dn]r1d
{
	push16be(0x3039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move @is,@[C2An]r1d
{
	push16be(0x3079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move @is,(@[C2An]r1d)
{
	push16be(0x30b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move @is,(@[C2An]r1d)+
{
	push16be(0x30f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move @is,-(@[C2An]r1d)
{
	push16be(0x3139|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move @is,@id(@[C2An]r1d)
{
	push16be(0x3179|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.w,move @is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x31b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move @is,(@id).w
{
	push16be(0x31f9);
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.w,move @is,(@id).l
{
	push16be(0x33f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.w,move @is,@id
{
	push16be(0x33f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.w,move #@is,@[C2Dn]r1d
{
	push16be(0x303c|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro move.w,move #@is,@[C2An]r1d
{
	push16be(0x307c|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro move.w,move #@is,(@[C2An]r1d)
{
	push16be(0x30bc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro move.w,move #@is,(@[C2An]r1d)+
{
	push16be(0x30fc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro move.w,move #@is,-(@[C2An]r1d)
{
	push16be(0x313c|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro move.w,move #@is,@id(@[C2An]r1d)
{
	push16be(0x317c|(r1d<<9));
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro move.w,move #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x31bc|(r1d<<9));
	push16be(0|c2ur<16>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move #@is,(@id).w
{
	push16be(0x31fc);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro move.w,move #@is,(@id).l
{
	push16be(0x33fc);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro move.w,move #@is,@id
{
	push16be(0x33fc);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro move.w,move @is(pc),@[C2Dn]r1d
{
	push16be(0x303a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(pc),@[C2An]r1d
{
	push16be(0x307a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(pc),(@[C2An]r1d)
{
	push16be(0x30ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(pc),(@[C2An]r1d)+
{
	push16be(0x30fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(pc),-(@[C2An]r1d)
{
	push16be(0x313a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(pc),@id(@[C2An]r1d)
{
	push16be(0x317a|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.w,move @is(pc),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x31ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move @is(pc),(@id).w
{
	push16be(0x31fa);
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.w,move @is(pc),(@id).l
{
	push16be(0x33fa);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @is(pc),@id
{
	push16be(0x33fa);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x303b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x307b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @is(pc,@[C2Dns]r2s),(@[C2An]r1d)
{
	push16be(0x30bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @is(pc,@[C2Dns]r2s),(@[C2An]r1d)+
{
	push16be(0x30fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @is(pc,@[C2Dns]r2s),-(@[C2An]r1d)
{
	push16be(0x313b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @is(pc,@[C2Dns]r2s),@id(@[C2An]r1d)
{
	push16be(0x317b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.w,move @is(pc,@[C2Dns]r2s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x31bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move @is(pc,@[C2Dns]r2s),(@id).w
{
	push16be(0x31fb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.w,move @is(pc,@[C2Dns]r2s),(@id).l
{
	push16be(0x33fb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @is(pc,@[C2Dns]r2s),@id
{
	push16be(0x33fb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x2000|r1s|(r1d<<9));
}
macro move.l @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0x2040|r1s|(r1d<<9));
}
macro move.l @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x2080|r1s|(r1d<<9));
}
macro move.l @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x20c0|r1s|(r1d<<9));
}
macro move.l @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x2100|r1s|(r1d<<9));
}
macro move.l @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x2140|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.l @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x2180|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l @[C2Dn]r1s,(@id).w
{
	push16be(0x21c0|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.l @[C2Dn]r1s,(@id).l
{
	push16be(0x23c0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.l @[C2Dn]r1s,@id
{
	push16be(0x23c0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.l @[C2An]r1s,@[C2Dn]r1d
{
	push16be(0x2008|r1s|(r1d<<9));
}
macro move.l @[C2An]r1s,@[C2An]r1d
{
	push16be(0x2048|r1s|(r1d<<9));
}
macro move.l @[C2An]r1s,(@[C2An]r1d)
{
	push16be(0x2088|r1s|(r1d<<9));
}
macro move.l @[C2An]r1s,(@[C2An]r1d)+
{
	push16be(0x20c8|r1s|(r1d<<9));
}
macro move.l @[C2An]r1s,-(@[C2An]r1d)
{
	push16be(0x2108|r1s|(r1d<<9));
}
macro move.l @[C2An]r1s,@id(@[C2An]r1d)
{
	push16be(0x2148|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.l @[C2An]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x2188|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l @[C2An]r1s,(@id).w
{
	push16be(0x21c8|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.l @[C2An]r1s,(@id).l
{
	push16be(0x23c8|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.l @[C2An]r1s,@id
{
	push16be(0x23c8|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.l (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x2010|r1s|(r1d<<9));
}
macro move.l (@[C2An]r1s),@[C2An]r1d
{
	push16be(0x2050|r1s|(r1d<<9));
}
macro move.l (@[C2An]r1s),(@[C2An]r1d)
{
	push16be(0x2090|r1s|(r1d<<9));
}
macro move.l (@[C2An]r1s),(@[C2An]r1d)+
{
	push16be(0x20d0|r1s|(r1d<<9));
}
macro move.l (@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x2110|r1s|(r1d<<9));
}
macro move.l (@[C2An]r1s),@id(@[C2An]r1d)
{
	push16be(0x2150|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.l (@[C2An]r1s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x2190|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l (@[C2An]r1s),(@id).w
{
	push16be(0x21d0|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.l (@[C2An]r1s),(@id).l
{
	push16be(0x23d0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.l (@[C2An]r1s),@id
{
	push16be(0x23d0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.l (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x2018|r1s|(r1d<<9));
}
macro move.l (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0x2058|r1s|(r1d<<9));
}
macro move.l (@[C2An]r1s)+,(@[C2An]r1d)
{
	push16be(0x2098|r1s|(r1d<<9));
}
macro move.l (@[C2An]r1s)+,(@[C2An]r1d)+
{
	push16be(0x20d8|r1s|(r1d<<9));
}
macro move.l (@[C2An]r1s)+,-(@[C2An]r1d)
{
	push16be(0x2118|r1s|(r1d<<9));
}
macro move.l (@[C2An]r1s)+,@id(@[C2An]r1d)
{
	push16be(0x2158|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.l (@[C2An]r1s)+,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x2198|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l (@[C2An]r1s)+,(@id).w
{
	push16be(0x21d8|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.l (@[C2An]r1s)+,(@id).l
{
	push16be(0x23d8|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.l (@[C2An]r1s)+,@id
{
	push16be(0x23d8|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.l -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x2020|r1s|(r1d<<9));
}
macro move.l -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x2060|r1s|(r1d<<9));
}
macro move.l -(@[C2An]r1s),(@[C2An]r1d)
{
	push16be(0x20a0|r1s|(r1d<<9));
}
macro move.l -(@[C2An]r1s),(@[C2An]r1d)+
{
	push16be(0x20e0|r1s|(r1d<<9));
}
macro move.l -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x2120|r1s|(r1d<<9));
}
macro move.l -(@[C2An]r1s),@id(@[C2An]r1d)
{
	push16be(0x2160|r1s|(r1d<<9));
	push16be(0|c2sr<16>(id));
}
macro move.l -(@[C2An]r1s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x21a0|r1s|(r1d<<9));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l -(@[C2An]r1s),(@id).w
{
	push16be(0x21e0|r1s);
	push16be(0|c2sr<16>(id));
}
macro move.l -(@[C2An]r1s),(@id).l
{
	push16be(0x23e0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.l -(@[C2An]r1s),@id
{
	push16be(0x23e0|r1s);
	push32be(0|c2sr<32>(id),true);
}
macro move.l @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x2028|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x2068|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l @is(@[C2An]r1s),(@[C2An]r1d)
{
	push16be(0x20a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l @is(@[C2An]r1s),(@[C2An]r1d)+
{
	push16be(0x20e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l @is(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x2128|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l @is(@[C2An]r1s),@id(@[C2An]r1d)
{
	push16be(0x2168|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.l @is(@[C2An]r1s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x21a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l @is(@[C2An]r1s),(@id).w
{
	push16be(0x21e8|r1s);
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.l @is(@[C2An]r1s),(@id).l
{
	push16be(0x23e8|r1s);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.l @is(@[C2An]r1s),@id
{
	push16be(0x23e8|r1s);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x2030|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x2070|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.l @is(@[C2An]r1s,@[C2Dns]r2s),(@[C2An]r1d)
{
	push16be(0x20b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.l @is(@[C2An]r1s,@[C2Dns]r2s),(@[C2An]r1d)+
{
	push16be(0x20f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.l @is(@[C2An]r1s,@[C2Dns]r2s),-(@[C2An]r1d)
{
	push16be(0x2130|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.l @is(@[C2An]r1s,@[C2Dns]r2s),@id(@[C2An]r1d)
{
	push16be(0x2170|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.l @is(@[C2An]r1s,@[C2Dns]r2s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x21b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l @is(@[C2An]r1s,@[C2Dns]r2s),(@id).w
{
	push16be(0x21f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.l @is(@[C2An]r1s,@[C2Dns]r2s),(@id).l
{
	push16be(0x23f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.l @is(@[C2An]r1s,@[C2Dns]r2s),@id
{
	push16be(0x23f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.l (@is).w,@[C2Dn]r1d
{
	push16be(0x2038|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l (@is).w,@[C2An]r1d
{
	push16be(0x2078|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l (@is).w,(@[C2An]r1d)
{
	push16be(0x20b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l (@is).w,(@[C2An]r1d)+
{
	push16be(0x20f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l (@is).w,-(@[C2An]r1d)
{
	push16be(0x2138|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l (@is).w,@id(@[C2An]r1d)
{
	push16be(0x2178|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.l (@is).w,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x21b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l (@is).w,(@id).w
{
	push16be(0x21f8);
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.l (@is).w,(@id).l
{
	push16be(0x23f8);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.l (@is).w,@id
{
	push16be(0x23f8);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.l (@is).l,@[C2Dn]r1d
{
	push16be(0x2039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l (@is).l,@[C2An]r1d
{
	push16be(0x2079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l (@is).l,(@[C2An]r1d)
{
	push16be(0x20b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l (@is).l,(@[C2An]r1d)+
{
	push16be(0x20f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l (@is).l,-(@[C2An]r1d)
{
	push16be(0x2139|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l (@is).l,@id(@[C2An]r1d)
{
	push16be(0x2179|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.l (@is).l,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x21b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l (@is).l,(@id).w
{
	push16be(0x21f9);
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.l (@is).l,(@id).l
{
	push16be(0x23f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.l (@is).l,@id
{
	push16be(0x23f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.l @is,@[C2Dn]r1d
{
	push16be(0x2039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l @is,@[C2An]r1d
{
	push16be(0x2079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l @is,(@[C2An]r1d)
{
	push16be(0x20b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l @is,(@[C2An]r1d)+
{
	push16be(0x20f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l @is,-(@[C2An]r1d)
{
	push16be(0x2139|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l @is,@id(@[C2An]r1d)
{
	push16be(0x2179|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.l @is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x21b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l @is,(@id).w
{
	push16be(0x21f9);
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.l @is,(@id).l
{
	push16be(0x23f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.l @is,@id
{
	push16be(0x23f9);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.l #@is,@[C2Dn]r1d
{
	push16be(0x203c|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l #@is,@[C2An]r1d
{
	push16be(0x207c|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l #@is,(@[C2An]r1d)
{
	push16be(0x20bc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l #@is,(@[C2An]r1d)+
{
	push16be(0x20fc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l #@is,-(@[C2An]r1d)
{
	push16be(0x213c|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro move.l #@is,@id(@[C2An]r1d)
{
	push16be(0x217c|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.l #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x21bc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l #@is,(@id).w
{
	push16be(0x21fc);
	push32be(0|c2ur<32>(is),true);
	push16be(0|c2ur<16>(id));
}
macro move.l #@is,(@id).l
{
	push16be(0x23fc);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.l #@is,@id
{
	push16be(0x23fc);
	push32be(0|c2ur<32>(is),true);
	push32be(0|c2ur<32>(id),true);
}
macro move.l @is(pc),@[C2Dn]r1d
{
	push16be(0x203a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l @is(pc),@[C2An]r1d
{
	push16be(0x207a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l @is(pc),(@[C2An]r1d)
{
	push16be(0x20ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l @is(pc),(@[C2An]r1d)+
{
	push16be(0x20fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l @is(pc),-(@[C2An]r1d)
{
	push16be(0x213a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro move.l @is(pc),@id(@[C2An]r1d)
{
	push16be(0x217a|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.l @is(pc),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x21ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l @is(pc),(@id).w
{
	push16be(0x21fa);
	push16be(0|c2sr<16>(is));
	push16be(0|c2sr<16>(id));
}
macro move.l @is(pc),(@id).l
{
	push16be(0x23fa);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.l @is(pc),@id
{
	push16be(0x23fa);
	push16be(0|c2sr<16>(is));
	push32be(0|c2sr<32>(id),true);
}
macro move.l @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x203b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.l @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x207b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.l @is(pc,@[C2Dns]r2s),(@[C2An]r1d)
{
	push16be(0x20bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.l @is(pc,@[C2Dns]r2s),(@[C2An]r1d)+
{
	push16be(0x20fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.l @is(pc,@[C2Dns]r2s),-(@[C2An]r1d)
{
	push16be(0x213b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.l @is(pc,@[C2Dns]r2s),@id(@[C2An]r1d)
{
	push16be(0x217b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.l @is(pc,@[C2Dns]r2s),@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x21bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.l @is(pc,@[C2Dns]r2s),(@id).w
{
	push16be(0x21fb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push16be(0|c2sr<16>(id));
}
macro move.l @is(pc,@[C2Dns]r2s),(@id).l
{
	push16be(0x23fb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro move.l @is(pc,@[C2Dns]r2s),@id
{
	push16be(0x23fb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
	push32be(0|c2sr<32>(id),true);
}
macro movea.w,movea @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0x3040|r1s|(r1d<<9));
}
macro movea.w,movea @[C2An]r1s,@[C2An]r1d
{
	push16be(0x3048|r1s|(r1d<<9));
}
macro movea.w,movea (@[C2An]r1s),@[C2An]r1d
{
	push16be(0x3050|r1s|(r1d<<9));
}
macro movea.w,movea (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0x3058|r1s|(r1d<<9));
}
macro movea.w,movea -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x3060|r1s|(r1d<<9));
}
macro movea.w,movea @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x3068|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro movea.w,movea @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x3070|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movea.w,movea (@is).w,@[C2An]r1d
{
	push16be(0x3078|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro movea.w,movea (@is).l,@[C2An]r1d
{
	push16be(0x3079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro movea.w,movea @is,@[C2An]r1d
{
	push16be(0x3079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro movea.w,movea #@is,@[C2An]r1d
{
	push16be(0x307c|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro movea.w,movea @is(pc),@[C2An]r1d
{
	push16be(0x307a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro movea.w,movea @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x307b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movea.l @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0x2040|r1s|(r1d<<9));
}
macro movea.l @[C2An]r1s,@[C2An]r1d
{
	push16be(0x2048|r1s|(r1d<<9));
}
macro movea.l (@[C2An]r1s),@[C2An]r1d
{
	push16be(0x2050|r1s|(r1d<<9));
}
macro movea.l (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0x2058|r1s|(r1d<<9));
}
macro movea.l -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x2060|r1s|(r1d<<9));
}
macro movea.l @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x2068|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro movea.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x2070|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movea.l (@is).w,@[C2An]r1d
{
	push16be(0x2078|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro movea.l (@is).l,@[C2An]r1d
{
	push16be(0x2079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro movea.l @is,@[C2An]r1d
{
	push16be(0x2079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro movea.l #@is,@[C2An]r1d
{
	push16be(0x207c|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro movea.l @is(pc),@[C2An]r1d
{
	push16be(0x207a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro movea.l @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x207b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move @[C2Dn]r1s,ccr
{
	push16be(0x44c0|r1s);
}
macro move.w,move (@[C2An]r1s),ccr
{
	push16be(0x44d0|r1s);
}
macro move.w,move (@[C2An]r1s)+,ccr
{
	push16be(0x44d8|r1s);
}
macro move.w,move -(@[C2An]r1s),ccr
{
	push16be(0x44e0|r1s);
}
macro move.w,move @is(@[C2An]r1s),ccr
{
	push16be(0x44e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(@[C2An]r1s,@[C2Dns]r2s),ccr
{
	push16be(0x44f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move (@is).w,ccr
{
	push16be(0x44f8);
	push16be(0|c2sr<16>(is));
}
macro move.w,move (@is).l,ccr
{
	push16be(0x44f9);
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move @is,ccr
{
	push16be(0x44f9);
	push32be(0|c2ur<32>(is),true);
}
macro move.w,move #@is,ccr
{
	push16be(0x44fc);
	push16be(0|c2ur<16>(is));
}
macro move.w,move @is(pc),ccr
{
	push16be(0x44fa);
	push16be(0|c2sr<16>(is));
}
macro move.w,move @is(pc,@[C2Dns]r2s),ccr
{
	push16be(0x44fb);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro move.w,move sr,@[C2Dn]r1d
{
	push16be(0x40c0|r1d);
}
macro move.w,move sr,(@[C2An]r1d)
{
	push16be(0x40d0|r1d);
}
macro move.w,move sr,(@[C2An]r1d)+
{
	push16be(0x40d8|r1d);
}
macro move.w,move sr,-(@[C2An]r1d)
{
	push16be(0x40e0|r1d);
}
macro move.w,move sr,@id(@[C2An]r1d)
{
	push16be(0x40e8|r1d);
	push16be(0|c2sr<16>(id));
}
macro move.w,move sr,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x40f0|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro move.w,move sr,(@id).w
{
	push16be(0x40f8);
	push16be(0|c2sr<16>(id));
}
macro move.w,move sr,(@id).l
{
	push16be(0x40f9);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move sr,@id
{
	push16be(0x40f9);
	push32be(0|c2sr<32>(id),true);
}
macro move.w,move @[C2An]r1s,usp
{
	push16be(0x4e60|r1s);
}
macro move.w,move usp,@[C2An]r1d
{
	push16be(0x4e68|r1d);
}
macro movem.w,movem @[C2DAn]c0,(@[C2An]r1d)
{
	push16be(0x4890|r1d);
	push16be(c2sb(c0));
}
macro movem.w,movem @[C2DAn]c0,-(@[C2An]r1d)
{
	push16be(0x48a0|r1d);
	push16be(c2sbr(c0));
}
macro movem.w,movem @[C2DAn]c0,@id(@[C2An]r1d)
{
	push16be(0x48a8|r1d);
	push16be(c2sb(c0));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48b0|r1d);
	push16be(c2sb(c0));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.w,movem @[C2DAn]c0,(@id).w
{
	push16be(0x48b8);
	push16be(c2sb(c0));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0,(@id).l
{
	push16be(0x48b9);
	push16be(c2sb(c0));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem @[C2DAn]c0,@id
{
	push16be(0x48b9);
	push16be(c2sb(c0));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem (@[C2An]r1s),@[C2DAn]c0
{
	push16be(0x4c90|r1s);
	push16be(c2sb(c0));
}
macro movem.w,movem (@[C2An]r1s)+,@[C2DAn]c0
{
	push16be(0x4c98|r1s);
	push16be(c2sb(c0));
}
macro movem.w,movem @is(@[C2An]r1s),@[C2DAn]c0
{
	push16be(0x4ca8|r1s);
	push16be(c2sb(c0));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0
{
	push16be(0x4cb0|r1s);
	push16be(c2sb(c0));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem (@is).w,@[C2DAn]c0
{
	push16be(0x4cb8);
	push16be(c2sb(c0));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem (@is).l,@[C2DAn]c0
{
	push16be(0x4cb9);
	push16be(c2sb(c0));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is,@[C2DAn]c0
{
	push16be(0x4cb9);
	push16be(c2sb(c0));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is(pc),@[C2DAn]c0
{
	push16be(0x4cba);
	push16be(c2sb(c0));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(pc,@[C2Dns]r2s),@[C2DAn]c0
{
	push16be(0x4cbb);
	push16be(c2sb(c0));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l @[C2DAn]c0,(@[C2An]r1d)
{
	push16be(0x48d0|r1d);
	push16be(c2sb(c0));
}
macro movem.l @[C2DAn]c0,-(@[C2An]r1d)
{
	push16be(0x48e0|r1d);
	push16be(c2sbr(c0));
}
macro movem.l @[C2DAn]c0,@id(@[C2An]r1d)
{
	push16be(0x48e8|r1d);
	push16be(c2sb(c0));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48f0|r1d);
	push16be(c2sb(c0));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.l @[C2DAn]c0,(@id).w
{
	push16be(0x48f8);
	push16be(c2sb(c0));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0,(@id).l
{
	push16be(0x48f9);
	push16be(c2sb(c0));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l @[C2DAn]c0,@id
{
	push16be(0x48f9);
	push16be(c2sb(c0));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l (@[C2An]r1s),@[C2DAn]c0
{
	push16be(0x4cd0|r1s);
	push16be(c2sb(c0));
}
macro movem.l (@[C2An]r1s)+,@[C2DAn]c0
{
	push16be(0x4cd8|r1s);
	push16be(c2sb(c0));
}
macro movem.l @is(@[C2An]r1s),@[C2DAn]c0
{
	push16be(0x4ce8|r1s);
	push16be(c2sb(c0));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0
{
	push16be(0x4cf0|r1s);
	push16be(c2sb(c0));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l (@is).w,@[C2DAn]c0
{
	push16be(0x4cf8);
	push16be(c2sb(c0));
	push16be(0|c2sr<16>(is));
}
macro movem.l (@is).l,@[C2DAn]c0
{
	push16be(0x4cf9);
	push16be(c2sb(c0));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is,@[C2DAn]c0
{
	push16be(0x4cf9);
	push16be(c2sb(c0));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is(pc),@[C2DAn]c0
{
	push16be(0x4cfa);
	push16be(c2sb(c0));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(pc,@[C2Dns]r2s),@[C2DAn]c0
{
	push16be(0x4cfb);
	push16be(c2sb(c0));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1,(@[C2An]r1d)
{
	push16be(0x4890|r1d);
	push16be(c2sb(c0)|c2sb(c1));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1,-(@[C2An]r1d)
{
	push16be(0x48a0|r1d);
	push16be(c2sbr(c0)|c2sbr(c1));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1,@id(@[C2An]r1d)
{
	push16be(0x48a8|r1d);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48b0|r1d);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1,(@id).w
{
	push16be(0x48b8);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1,(@id).l
{
	push16be(0x48b9);
	push16be(c2sb(c0)|c2sb(c1));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1,@id
{
	push16be(0x48b9);
	push16be(c2sb(c0)|c2sb(c1));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem (@[C2An]r1s),@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4c90|r1s);
	push16be(c2sb(c0)|c2sb(c1));
}
macro movem.w,movem (@[C2An]r1s)+,@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4c98|r1s);
	push16be(c2sb(c0)|c2sb(c1));
}
macro movem.w,movem @is(@[C2An]r1s),@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4ca8|r1s);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cb0|r1s);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem (@is).w,@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cb8);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem (@is).l,@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cb9);
	push16be(c2sb(c0)|c2sb(c1));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is,@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cb9);
	push16be(c2sb(c0)|c2sb(c1));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is(pc),@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cba);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(pc,@[C2Dns]r2s),@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cbb);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1,(@[C2An]r1d)
{
	push16be(0x48d0|r1d);
	push16be(c2sb(c0)|c2sb(c1));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1,-(@[C2An]r1d)
{
	push16be(0x48e0|r1d);
	push16be(c2sbr(c0)|c2sbr(c1));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1,@id(@[C2An]r1d)
{
	push16be(0x48e8|r1d);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48f0|r1d);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1,(@id).w
{
	push16be(0x48f8);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1,(@id).l
{
	push16be(0x48f9);
	push16be(c2sb(c0)|c2sb(c1));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1,@id
{
	push16be(0x48f9);
	push16be(c2sb(c0)|c2sb(c1));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l (@[C2An]r1s),@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cd0|r1s);
	push16be(c2sb(c0)|c2sb(c1));
}
macro movem.l (@[C2An]r1s)+,@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cd8|r1s);
	push16be(c2sb(c0)|c2sb(c1));
}
macro movem.l @is(@[C2An]r1s),@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4ce8|r1s);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cf0|r1s);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l (@is).w,@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cf8);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|c2sr<16>(is));
}
macro movem.l (@is).l,@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cf9);
	push16be(c2sb(c0)|c2sb(c1));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is,@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cf9);
	push16be(c2sb(c0)|c2sb(c1));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is(pc),@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cfa);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(pc,@[C2Dns]r2s),@[C2DAn]c0/@[C2DAn]c1
{
	push16be(0x4cfb);
	push16be(c2sb(c0)|c2sb(c1));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1,(@[C2An]r1d)
{
	push16be(0x4890|r1d);
	push16be(c2sb(c0,c1));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1,-(@[C2An]r1d)
{
	push16be(0x48a0|r1d);
	push16be(c2sbr(c0,c1));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1,@id(@[C2An]r1d)
{
	push16be(0x48a8|r1d);
	push16be(c2sb(c0,c1));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48b0|r1d);
	push16be(c2sb(c0,c1));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1,(@id).w
{
	push16be(0x48b8);
	push16be(c2sb(c0,c1));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1,(@id).l
{
	push16be(0x48b9);
	push16be(c2sb(c0,c1));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1,@id
{
	push16be(0x48b9);
	push16be(c2sb(c0,c1));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem (@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4c90|r1s);
	push16be(c2sb(c0,c1));
}
macro movem.w,movem (@[C2An]r1s)+,@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4c98|r1s);
	push16be(c2sb(c0,c1));
}
macro movem.w,movem @is(@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4ca8|r1s);
	push16be(c2sb(c0,c1));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cb0|r1s);
	push16be(c2sb(c0,c1));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem (@is).w,@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cb8);
	push16be(c2sb(c0,c1));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem (@is).l,@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cb9);
	push16be(c2sb(c0,c1));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is,@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cb9);
	push16be(c2sb(c0,c1));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is(pc),@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cba);
	push16be(c2sb(c0,c1));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(pc,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cbb);
	push16be(c2sb(c0,c1));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1,(@[C2An]r1d)
{
	push16be(0x48d0|r1d);
	push16be(c2sb(c0,c1));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1,-(@[C2An]r1d)
{
	push16be(0x48e0|r1d);
	push16be(c2sbr(c0,c1));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1,@id(@[C2An]r1d)
{
	push16be(0x48e8|r1d);
	push16be(c2sb(c0,c1));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48f0|r1d);
	push16be(c2sb(c0,c1));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1,(@id).w
{
	push16be(0x48f8);
	push16be(c2sb(c0,c1));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1,(@id).l
{
	push16be(0x48f9);
	push16be(c2sb(c0,c1));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1,@id
{
	push16be(0x48f9);
	push16be(c2sb(c0,c1));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l (@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cd0|r1s);
	push16be(c2sb(c0,c1));
}
macro movem.l (@[C2An]r1s)+,@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cd8|r1s);
	push16be(c2sb(c0,c1));
}
macro movem.l @is(@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4ce8|r1s);
	push16be(c2sb(c0,c1));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cf0|r1s);
	push16be(c2sb(c0,c1));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l (@is).w,@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cf8);
	push16be(c2sb(c0,c1));
	push16be(0|c2sr<16>(is));
}
macro movem.l (@is).l,@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cf9);
	push16be(c2sb(c0,c1));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is,@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cf9);
	push16be(c2sb(c0,c1));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is(pc),@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cfa);
	push16be(c2sb(c0,c1));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(pc,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1
{
	push16be(0x4cfb);
	push16be(c2sb(c0,c1));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,(@[C2An]r1d)
{
	push16be(0x4890|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,-(@[C2An]r1d)
{
	push16be(0x48a0|r1d);
	push16be(c2sbr(c0,c1)|c2sbr(c2));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,@id(@[C2An]r1d)
{
	push16be(0x48a8|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48b0|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,(@id).w
{
	push16be(0x48b8);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,(@id).l
{
	push16be(0x48b9);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,@id
{
	push16be(0x48b9);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem (@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4c90|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2));
}
macro movem.w,movem (@[C2An]r1s)+,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4c98|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2));
}
macro movem.w,movem @is(@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4ca8|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cb0|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem (@is).w,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cb8);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem (@is).l,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cb9);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cb9);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is(pc),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cba);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(pc,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cbb);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,(@[C2An]r1d)
{
	push16be(0x48d0|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,-(@[C2An]r1d)
{
	push16be(0x48e0|r1d);
	push16be(c2sbr(c0,c1)|c2sbr(c2));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,@id(@[C2An]r1d)
{
	push16be(0x48e8|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48f0|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,(@id).w
{
	push16be(0x48f8);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,(@id).l
{
	push16be(0x48f9);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2,@id
{
	push16be(0x48f9);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l (@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cd0|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2));
}
macro movem.l (@[C2An]r1s)+,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cd8|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2));
}
macro movem.l @is(@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4ce8|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cf0|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l (@is).w,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cf8);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|c2sr<16>(is));
}
macro movem.l (@is).l,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cf9);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cf9);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is(pc),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cfa);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(pc,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2
{
	push16be(0x4cfb);
	push16be(c2sb(c0,c1)||c2sb(c2));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,(@[C2An]r1d)
{
	push16be(0x4890|r1d);
	push16be(c2sb(c0)||c2sb(c1,c2));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,-(@[C2An]r1d)
{
	push16be(0x48a0|r1d);
	push16be(c2sbr(c0)|c2sbr(c1,c2));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,@id(@[C2An]r1d)
{
	push16be(0x48a8|r1d);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48b0|r1d);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,(@id).w
{
	push16be(0x48b8);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,(@id).l
{
	push16be(0x48b9);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,@id
{
	push16be(0x48b9);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem (@[C2An]r1s),@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4c90|r1s);
	push16be(c2sb(c0)||c2sb(c1,c2));
}
macro movem.w,movem (@[C2An]r1s)+,@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4c98|r1s);
	push16be(c2sb(c0)||c2sb(c1,c2));
}
macro movem.w,movem @is(@[C2An]r1s),@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4ca8|r1s);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cb0|r1s);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem (@is).w,@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cb8);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem (@is).l,@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cb9);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is,@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cb9);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is(pc),@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cba);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(pc,@[C2Dns]r2s),@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cbb);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,(@[C2An]r1d)
{
	push16be(0x48d0|r1d);
	push16be(c2sb(c0)||c2sb(c1,c2));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,-(@[C2An]r1d)
{
	push16be(0x48e0|r1d);
	push16be(c2sbr(c0)|c2sbr(c1,c2));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,@id(@[C2An]r1d)
{
	push16be(0x48e8|r1d);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48f0|r1d);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,(@id).w
{
	push16be(0x48f8);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,(@id).l
{
	push16be(0x48f9);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l @[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2,@id
{
	push16be(0x48f9);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l (@[C2An]r1s),@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cd0|r1s);
	push16be(c2sb(c0)||c2sb(c1,c2));
}
macro movem.l (@[C2An]r1s)+,@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cd8|r1s);
	push16be(c2sb(c0)||c2sb(c1,c2));
}
macro movem.l @is(@[C2An]r1s),@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4ce8|r1s);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cf0|r1s);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l (@is).w,@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cf8);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|c2sr<16>(is));
}
macro movem.l (@is).l,@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cf9);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is,@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cf9);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is(pc),@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cfa);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(pc,@[C2Dns]r2s),@[C2DAn]c0/@[C2DAn]c1-@[C2DAn]c2
{
	push16be(0x4cfb);
	push16be(c2sb(c0)||c2sb(c1,c2));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,(@[C2An]r1d)
{
	push16be(0x4890|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,-(@[C2An]r1d)
{
	push16be(0x48a0|r1d);
	push16be(c2sbr(c0,c1)|c2sbr(c2,c3));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,@id(@[C2An]r1d)
{
	push16be(0x48a8|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48b0|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,(@id).w
{
	push16be(0x48b8);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|c2sr<16>(id));
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,(@id).l
{
	push16be(0x48b9);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,@id
{
	push16be(0x48b9);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push32be(0|c2sr<32>(id),true);
}
macro movem.w,movem (@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4c90|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
}
macro movem.w,movem (@[C2An]r1s)+,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4c98|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
}
macro movem.w,movem @is(@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4ca8|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cb0|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.w,movem (@is).w,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cb8);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem (@is).l,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cb9);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cb9);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push32be(0|c2ur<32>(is),true);
}
macro movem.w,movem @is(pc),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cba);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|c2sr<16>(is));
}
macro movem.w,movem @is(pc,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cbb);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,(@[C2An]r1d)
{
	push16be(0x48d0|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,-(@[C2An]r1d)
{
	push16be(0x48e0|r1d);
	push16be(c2sbr(c0,c1)|c2sbr(c2,c3));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,@id(@[C2An]r1d)
{
	push16be(0x48e8|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x48f0|r1d);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,(@id).w
{
	push16be(0x48f8);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|c2sr<16>(id));
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,(@id).l
{
	push16be(0x48f9);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l @[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3,@id
{
	push16be(0x48f9);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push32be(0|c2sr<32>(id),true);
}
macro movem.l (@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cd0|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
}
macro movem.l (@[C2An]r1s)+,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cd8|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
}
macro movem.l @is(@[C2An]r1s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4ce8|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cf0|r1s);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movem.l (@is).w,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cf8);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|c2sr<16>(is));
}
macro movem.l (@is).l,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cf9);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is,@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cf9);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push32be(0|c2ur<32>(is),true);
}
macro movem.l @is(pc),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cfa);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|c2sr<16>(is));
}
macro movem.l @is(pc,@[C2Dns]r2s),@[C2DAn]c0-@[C2DAn]c1/@[C2DAn]c2-@[C2DAn]c3
{
	push16be(0x4cfb);
	push16be(c2sb(c0,c1)||c2sb(c2,c3));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro movep.w,movep @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x0108|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro movep.w,movep @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x0188|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro movep.l @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x0148|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro movep.l @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x01c8|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro moveq.l,moveq #@us,@[C2Dn]r1d
{
	push16be(0x7000|c2r<8>(us)|(r1d<<9));
}
macro muls.w,muls @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xc1c0|r1s|(r1d<<9));
}
macro muls.w,muls (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc1d0|r1s|(r1d<<9));
}
macro muls.w,muls (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xc1d8|r1s|(r1d<<9));
}
macro muls.w,muls -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc1e0|r1s|(r1d<<9));
}
macro muls.w,muls @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc1e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro muls.w,muls @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xc1f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro muls.w,muls (@is).w,@[C2Dn]r1d
{
	push16be(0xc1f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro muls.w,muls (@is).l,@[C2Dn]r1d
{
	push16be(0xc1f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro muls.w,muls @is,@[C2Dn]r1d
{
	push16be(0xc1f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro muls.w,muls #@is,@[C2Dn]r1d
{
	push16be(0xc1fc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro muls.w,muls @is(pc),@[C2Dn]r1d
{
	push16be(0xc1fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro muls.w,muls @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xc1fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro mulu.w,mulu @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xc0c0|r1s|(r1d<<9));
}
macro mulu.w,mulu (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc0d0|r1s|(r1d<<9));
}
macro mulu.w,mulu (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0xc0d8|r1s|(r1d<<9));
}
macro mulu.w,mulu -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc0e0|r1s|(r1d<<9));
}
macro mulu.w,mulu @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0xc0e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro mulu.w,mulu @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xc0f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro mulu.w,mulu (@is).w,@[C2Dn]r1d
{
	push16be(0xc0f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro mulu.w,mulu (@is).l,@[C2Dn]r1d
{
	push16be(0xc0f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro mulu.w,mulu @is,@[C2Dn]r1d
{
	push16be(0xc0f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro mulu.w,mulu #@is,@[C2Dn]r1d
{
	push16be(0xc0fc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro mulu.w,mulu @is(pc),@[C2Dn]r1d
{
	push16be(0xc0fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro mulu.w,mulu @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0xc0fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro nbcd.b,nbcd @[C2Dn]r1s
{
	push16be(0x4800|r1s);
}
macro nbcd.b,nbcd (@[C2An]r1s)
{
	push16be(0x4810|r1s);
}
macro nbcd.b,nbcd (@[C2An]r1s)+
{
	push16be(0x4818|r1s);
}
macro nbcd.b,nbcd -(@[C2An]r1s)
{
	push16be(0x4820|r1s);
}
macro nbcd.b,nbcd @is(@[C2An]r1s)
{
	push16be(0x4828|r1s);
	push16be(0|c2sr<16>(is));
}
macro nbcd.b,nbcd @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4830|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro nbcd.b,nbcd (@is).w
{
	push16be(0x4838);
	push16be(0|c2sr<16>(is));
}
macro nbcd.b,nbcd (@is).l
{
	push16be(0x4839);
	push32be(0|c2ur<32>(is),true);
}
macro nbcd.b,nbcd @is
{
	push16be(0x4839);
	push32be(0|c2ur<32>(is),true);
}
macro neg.b @[C2Dn]r1s
{
	push16be(0xc400|r1s);
}
macro neg.b (@[C2An]r1s)
{
	push16be(0xc410|r1s);
}
macro neg.b (@[C2An]r1s)+
{
	push16be(0xc418|r1s);
}
macro neg.b -(@[C2An]r1s)
{
	push16be(0xc420|r1s);
}
macro neg.b @is(@[C2An]r1s)
{
	push16be(0xc428|r1s);
	push16be(0|c2sr<16>(is));
}
macro neg.b @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xc430|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro neg.b (@is).w
{
	push16be(0xc438);
	push16be(0|c2sr<16>(is));
}
macro neg.b (@is).l
{
	push16be(0xc439);
	push32be(0|c2ur<32>(is),true);
}
macro neg.b @is
{
	push16be(0xc439);
	push32be(0|c2ur<32>(is),true);
}
macro neg.w,neg @[C2Dn]r1s
{
	push16be(0xc440|r1s);
}
macro neg.w,neg (@[C2An]r1s)
{
	push16be(0xc450|r1s);
}
macro neg.w,neg (@[C2An]r1s)+
{
	push16be(0xc458|r1s);
}
macro neg.w,neg -(@[C2An]r1s)
{
	push16be(0xc460|r1s);
}
macro neg.w,neg @is(@[C2An]r1s)
{
	push16be(0xc468|r1s);
	push16be(0|c2sr<16>(is));
}
macro neg.w,neg @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xc470|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro neg.w,neg (@is).w
{
	push16be(0xc478);
	push16be(0|c2sr<16>(is));
}
macro neg.w,neg (@is).l
{
	push16be(0xc479);
	push32be(0|c2ur<32>(is),true);
}
macro neg.w,neg @is
{
	push16be(0xc479);
	push32be(0|c2ur<32>(is),true);
}
macro neg.l @[C2Dn]r1s
{
	push16be(0xc480|r1s);
}
macro neg.l (@[C2An]r1s)
{
	push16be(0xc490|r1s);
}
macro neg.l (@[C2An]r1s)+
{
	push16be(0xc498|r1s);
}
macro neg.l -(@[C2An]r1s)
{
	push16be(0xc4a0|r1s);
}
macro neg.l @is(@[C2An]r1s)
{
	push16be(0xc4a8|r1s);
	push16be(0|c2sr<16>(is));
}
macro neg.l @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xc4b0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro neg.l (@is).w
{
	push16be(0xc4b8);
	push16be(0|c2sr<16>(is));
}
macro neg.l (@is).l
{
	push16be(0xc4b9);
	push32be(0|c2ur<32>(is),true);
}
macro neg.l @is
{
	push16be(0xc4b9);
	push32be(0|c2ur<32>(is),true);
}
macro negx.b @[C2Dn]r1s
{
	push16be(0xc000|r1s);
}
macro negx.b (@[C2An]r1s)
{
	push16be(0xc010|r1s);
}
macro negx.b (@[C2An]r1s)+
{
	push16be(0xc018|r1s);
}
macro negx.b -(@[C2An]r1s)
{
	push16be(0xc020|r1s);
}
macro negx.b @is(@[C2An]r1s)
{
	push16be(0xc028|r1s);
	push16be(0|c2sr<16>(is));
}
macro negx.b @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xc030|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro negx.b (@is).w
{
	push16be(0xc038);
	push16be(0|c2sr<16>(is));
}
macro negx.b (@is).l
{
	push16be(0xc039);
	push32be(0|c2ur<32>(is),true);
}
macro negx.b @is
{
	push16be(0xc039);
	push32be(0|c2ur<32>(is),true);
}
macro negx.w,negx @[C2Dn]r1s
{
	push16be(0xc040|r1s);
}
macro negx.w,negx (@[C2An]r1s)
{
	push16be(0xc050|r1s);
}
macro negx.w,negx (@[C2An]r1s)+
{
	push16be(0xc058|r1s);
}
macro negx.w,negx -(@[C2An]r1s)
{
	push16be(0xc060|r1s);
}
macro negx.w,negx @is(@[C2An]r1s)
{
	push16be(0xc068|r1s);
	push16be(0|c2sr<16>(is));
}
macro negx.w,negx @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xc070|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro negx.w,negx (@is).w
{
	push16be(0xc078);
	push16be(0|c2sr<16>(is));
}
macro negx.w,negx (@is).l
{
	push16be(0xc079);
	push32be(0|c2ur<32>(is),true);
}
macro negx.w,negx @is
{
	push16be(0xc079);
	push32be(0|c2ur<32>(is),true);
}
macro negx.l @[C2Dn]r1s
{
	push16be(0xc080|r1s);
}
macro negx.l (@[C2An]r1s)
{
	push16be(0xc090|r1s);
}
macro negx.l (@[C2An]r1s)+
{
	push16be(0xc098|r1s);
}
macro negx.l -(@[C2An]r1s)
{
	push16be(0xc0a0|r1s);
}
macro negx.l @is(@[C2An]r1s)
{
	push16be(0xc0a8|r1s);
	push16be(0|c2sr<16>(is));
}
macro negx.l @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xc0b0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro negx.l (@is).w
{
	push16be(0xc0b8);
	push16be(0|c2sr<16>(is));
}
macro negx.l (@is).l
{
	push16be(0xc0b9);
	push32be(0|c2ur<32>(is),true);
}
macro negx.l @is
{
	push16be(0xc0b9);
	push32be(0|c2ur<32>(is),true);
}
macro nop
{
	push16be(0x4e71);
}
macro not.b @[C2Dn]r1s
{
	push16be(0x4600|r1s);
}
macro not.b (@[C2An]r1s)
{
	push16be(0x4610|r1s);
}
macro not.b (@[C2An]r1s)+
{
	push16be(0x4618|r1s);
}
macro not.b -(@[C2An]r1s)
{
	push16be(0x4620|r1s);
}
macro not.b @is(@[C2An]r1s)
{
	push16be(0x4628|r1s);
	push16be(0|c2sr<16>(is));
}
macro not.b @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4630|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro not.b (@is).w
{
	push16be(0x4638);
	push16be(0|c2sr<16>(is));
}
macro not.b (@is).l
{
	push16be(0x4639);
	push32be(0|c2ur<32>(is),true);
}
macro not.b @is
{
	push16be(0x4639);
	push32be(0|c2ur<32>(is),true);
}
macro not.w,not @[C2Dn]r1s
{
	push16be(0x4640|r1s);
}
macro not.w,not (@[C2An]r1s)
{
	push16be(0x4650|r1s);
}
macro not.w,not (@[C2An]r1s)+
{
	push16be(0x4658|r1s);
}
macro not.w,not -(@[C2An]r1s)
{
	push16be(0x4660|r1s);
}
macro not.w,not @is(@[C2An]r1s)
{
	push16be(0x4668|r1s);
	push16be(0|c2sr<16>(is));
}
macro not.w,not @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4670|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro not.w,not (@is).w
{
	push16be(0x4678);
	push16be(0|c2sr<16>(is));
}
macro not.w,not (@is).l
{
	push16be(0x4679);
	push32be(0|c2ur<32>(is),true);
}
macro not.w,not @is
{
	push16be(0x4679);
	push32be(0|c2ur<32>(is),true);
}
macro not.l @[C2Dn]r1s
{
	push16be(0x4680|r1s);
}
macro not.l (@[C2An]r1s)
{
	push16be(0x4690|r1s);
}
macro not.l (@[C2An]r1s)+
{
	push16be(0x4698|r1s);
}
macro not.l -(@[C2An]r1s)
{
	push16be(0x46a0|r1s);
}
macro not.l @is(@[C2An]r1s)
{
	push16be(0x46a8|r1s);
	push16be(0|c2sr<16>(is));
}
macro not.l @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x46b0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro not.l (@is).w
{
	push16be(0x46b8);
	push16be(0|c2sr<16>(is));
}
macro not.l (@is).l
{
	push16be(0x46b9);
	push32be(0|c2ur<32>(is),true);
}
macro not.l @is
{
	push16be(0x46b9);
	push32be(0|c2ur<32>(is),true);
}
macro or.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x8000|r1s|(r1d<<9));
}
macro or.b (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x8010|r1s|(r1d<<9));
}
macro or.b (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x8018|r1s|(r1d<<9));
}
macro or.b -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x8020|r1s|(r1d<<9));
}
macro or.b @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x8028|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro or.b @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x8030|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro or.b (@is).w,@[C2Dn]r1d
{
	push16be(0x8038|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro or.b (@is).l,@[C2Dn]r1d
{
	push16be(0x8039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro or.b @is,@[C2Dn]r1d
{
	push16be(0x8039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro or.b #@is,@[C2Dn]r1d
{
	push16be(0x803c|(r1d<<9));
	push16be(0|c2ur<8>(is));
}
macro or.b @is(pc),@[C2Dn]r1d
{
	push16be(0x803a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro or.b @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x803b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro or.b @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x8110|(r1s<<9)|r1d);
}
macro or.b @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x8118|(r1s<<9)|r1d);
}
macro or.b @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x8120|(r1s<<9)|r1d);
}
macro or.b @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x8128|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro or.b @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x8130|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro or.b @[C2Dn]r1s,(@id).w
{
	push16be(0x8138|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro or.b @[C2Dn]r1s,(@id).l
{
	push16be(0x8139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro or.b @[C2Dn]r1s,@id
{
	push16be(0x8139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro or.w,or @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x8040|r1s|(r1d<<9));
}
macro or.w,or (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x8050|r1s|(r1d<<9));
}
macro or.w,or (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x8058|r1s|(r1d<<9));
}
macro or.w,or -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x8060|r1s|(r1d<<9));
}
macro or.w,or @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x8068|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro or.w,or @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x8070|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro or.w,or (@is).w,@[C2Dn]r1d
{
	push16be(0x8078|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro or.w,or (@is).l,@[C2Dn]r1d
{
	push16be(0x8079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro or.w,or @is,@[C2Dn]r1d
{
	push16be(0x8079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro or.w,or #@is,@[C2Dn]r1d
{
	push16be(0x807c|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro or.w,or @is(pc),@[C2Dn]r1d
{
	push16be(0x807a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro or.w,or @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x807b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro or.w,or @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x8150|(r1s<<9)|r1d);
}
macro or.w,or @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x8158|(r1s<<9)|r1d);
}
macro or.w,or @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x8160|(r1s<<9)|r1d);
}
macro or.w,or @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x8168|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro or.w,or @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x8170|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro or.w,or @[C2Dn]r1s,(@id).w
{
	push16be(0x8178|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro or.w,or @[C2Dn]r1s,(@id).l
{
	push16be(0x8179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro or.w,or @[C2Dn]r1s,@id
{
	push16be(0x8179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro or.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x8080|r1s|(r1d<<9));
}
macro or.l (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x8090|r1s|(r1d<<9));
}
macro or.l (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x8098|r1s|(r1d<<9));
}
macro or.l -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x80a0|r1s|(r1d<<9));
}
macro or.l @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x80a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro or.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x80b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro or.l (@is).w,@[C2Dn]r1d
{
	push16be(0x80b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro or.l (@is).l,@[C2Dn]r1d
{
	push16be(0x80b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro or.l @is,@[C2Dn]r1d
{
	push16be(0x80b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro or.l #@is,@[C2Dn]r1d
{
	push16be(0x80bc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro or.l @is(pc),@[C2Dn]r1d
{
	push16be(0x80ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro or.l @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x80bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro or.l @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x8190|(r1s<<9)|r1d);
}
macro or.l @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x8198|(r1s<<9)|r1d);
}
macro or.l @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x81a0|(r1s<<9)|r1d);
}
macro or.l @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x81a8|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro or.l @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x81b0|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro or.l @[C2Dn]r1s,(@id).w
{
	push16be(0x81b8|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro or.l @[C2Dn]r1s,(@id).l
{
	push16be(0x81b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro or.l @[C2Dn]r1s,@id
{
	push16be(0x81b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro ori.b #@is,@[C2Dn]r1d
{
	push16be(0|r1d);
	push16be(0|c2ur<8>(is));
}
macro ori.b #@is,(@[C2An]r1d)
{
	push16be(0x0010|r1d);
	push16be(0|c2ur<8>(is));
}
macro ori.b #@is,(@[C2An]r1d)+
{
	push16be(0x0018|r1d);
	push16be(0|c2ur<8>(is));
}
macro ori.b #@is,-(@[C2An]r1d)
{
	push16be(0x0020|r1d);
	push16be(0|c2ur<8>(is));
}
macro ori.b #@is,@id(@[C2An]r1d)
{
	push16be(0x0028|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro ori.b #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0030|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro ori.b #@is,(@id).w
{
	push16be(0x0038);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro ori.b #@is,(@id).l
{
	push16be(0x0039);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro ori.b #@is,@id
{
	push16be(0x0039);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro ori.w,ori #@is,@[C2Dn]r1d
{
	push16be(0x0040|r1d);
	push16be(0|c2ur<16>(is));
}
macro ori.w,ori #@is,(@[C2An]r1d)
{
	push16be(0x0050|r1d);
	push16be(0|c2ur<16>(is));
}
macro ori.w,ori #@is,(@[C2An]r1d)+
{
	push16be(0x0058|r1d);
	push16be(0|c2ur<16>(is));
}
macro ori.w,ori #@is,-(@[C2An]r1d)
{
	push16be(0x0060|r1d);
	push16be(0|c2ur<16>(is));
}
macro ori.w,ori #@is,@id(@[C2An]r1d)
{
	push16be(0x0068|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro ori.w,ori #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0070|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro ori.w,ori #@is,(@id).w
{
	push16be(0x0078);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro ori.w,ori #@is,(@id).l
{
	push16be(0x0079);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro ori.w,ori #@is,@id
{
	push16be(0x0079);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro ori.l #@is,@[C2Dn]r1d
{
	push16be(0x0080|r1d);
	push32be(0|c2ur<32>(is));
}
macro ori.l #@is,(@[C2An]r1d)
{
	push16be(0x0090|r1d);
	push32be(0|c2ur<32>(is));
}
macro ori.l #@is,(@[C2An]r1d)+
{
	push16be(0x0098|r1d);
	push32be(0|c2ur<32>(is));
}
macro ori.l #@is,-(@[C2An]r1d)
{
	push16be(0x00a0|r1d);
	push32be(0|c2ur<32>(is));
}
macro ori.l #@is,@id(@[C2An]r1d)
{
	push16be(0x00a8|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro ori.l #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x00b0|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro ori.l #@is,(@id).w
{
	push16be(0x00b8);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro ori.l #@is,(@id).l
{
	push16be(0x00b9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro ori.l #@is,@id
{
	push16be(0x00b9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro ori.b,ori #@is,ccr
{
	push16be(0x003c);
	push16be(0|c2ur<8>(is));
}
macro pea.l,pea (@[C2An]r1s)
{
	push16be(0x4850|r1s);
}
macro pea.l,pea @is(@[C2An]r1s)
{
	push16be(0x4868|r1s);
	push16be(0|c2sr<16>(is));
}
macro pea.l,pea @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4870|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro pea.l,pea (@is).w
{
	push16be(0x4878);
	push16be(0|c2sr<16>(is));
}
macro pea.l,pea (@is).l
{
	push16be(0x4879);
	push32be(0|c2ur<32>(is),true);
}
macro pea.l,pea @is
{
	push16be(0x4879);
	push32be(0|c2ur<32>(is),true);
}
macro pea.l,pea @is(pc)
{
	push16be(0x487a);
	push16be(0|c2sr<16>(is));
}
macro pea.l,pea @is(pc,@[C2Dns]r2s)
{
	push16be(0x487b);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro reset
{
	push16be(0x4e70);
}
macro rol.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe138|(r1s<<9)|r1d);
}
macro rol.w,rol @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe178|(r1s<<9)|r1d);
}
macro rol.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe1b8|(r1s<<9)|r1d);
}
macro rol.b #@qs,@[C2Dn]r1d
{
	push16be(0xe118|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro rol.w,rol #@qs,@[C2Dn]r1d
{
	push16be(0xe158|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro rol.l #@qs,@[C2Dn]r1d
{
	push16be(0xe198|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro rol.w,rol (@[C2An]r1s)
{
	push16be(0xe7d0|r1s);
}
macro rol.w,rol (@[C2An]r1s)+
{
	push16be(0xe7d8|r1s);
}
macro rol.w,rol -(@[C2An]r1s)
{
	push16be(0xe7e0|r1s);
}
macro rol.w,rol @is(@[C2An]r1s)
{
	push16be(0xe7e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro rol.w,rol @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xe7f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro rol.w,rol (@is).w
{
	push16be(0xe7f8);
	push16be(0|c2sr<16>(is));
}
macro rol.w,rol (@is).l
{
	push16be(0xe7f9);
	push32be(0|c2ur<32>(is),true);
}
macro rol.w,rol @is
{
	push16be(0xe7f9);
	push32be(0|c2ur<32>(is),true);
}
macro ror.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe038|(r1s<<9)|r1d);
}
macro ror.w,ror @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe078|(r1s<<9)|r1d);
}
macro ror.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe0b8|(r1s<<9)|r1d);
}
macro ror.b #@qs,@[C2Dn]r1d
{
	push16be(0xe018|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro ror.w,ror #@qs,@[C2Dn]r1d
{
	push16be(0xe058|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro ror.l #@qs,@[C2Dn]r1d
{
	push16be(0xe098|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro ror.w,ror (@[C2An]r1s)
{
	push16be(0xe6d0|r1s);
}
macro ror.w,ror (@[C2An]r1s)+
{
	push16be(0xe6d8|r1s);
}
macro ror.w,ror -(@[C2An]r1s)
{
	push16be(0xe6e0|r1s);
}
macro ror.w,ror @is(@[C2An]r1s)
{
	push16be(0xe6e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro ror.w,ror @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xe6f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro ror.w,ror (@is).w
{
	push16be(0xe6f8);
	push16be(0|c2sr<16>(is));
}
macro ror.w,ror (@is).l
{
	push16be(0xe6f9);
	push32be(0|c2ur<32>(is),true);
}
macro ror.w,ror @is
{
	push16be(0xe6f9);
	push32be(0|c2ur<32>(is),true);
}
macro roxl.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe130|(r1s<<9)|r1d);
}
macro roxl.w,roxl @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe170|(r1s<<9)|r1d);
}
macro roxl.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe1b0|(r1s<<9)|r1d);
}
macro roxl.b #@qs,@[C2Dn]r1d
{
	push16be(0xe110|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro roxl.w,roxl #@qs,@[C2Dn]r1d
{
	push16be(0xe150|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro roxl.l #@qs,@[C2Dn]r1d
{
	push16be(0xe190|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro roxl.w,roxl (@[C2An]r1s)
{
	push16be(0xe5d0|r1s);
}
macro roxl.w,roxl (@[C2An]r1s)+
{
	push16be(0xe5d8|r1s);
}
macro roxl.w,roxl -(@[C2An]r1s)
{
	push16be(0xe5e0|r1s);
}
macro roxl.w,roxl @is(@[C2An]r1s)
{
	push16be(0xe5e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro roxl.w,roxl @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xe5f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro roxl.w,roxl (@is).w
{
	push16be(0xe5f8);
	push16be(0|c2sr<16>(is));
}
macro roxl.w,roxl (@is).l
{
	push16be(0xe5f9);
	push32be(0|c2ur<32>(is),true);
}
macro roxl.w,roxl @is
{
	push16be(0xe5f9);
	push32be(0|c2ur<32>(is),true);
}
macro roxr.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe030|(r1s<<9)|r1d);
}
macro roxr.w,roxr @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe070|(r1s<<9)|r1d);
}
macro roxr.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0xe0b0|(r1s<<9)|r1d);
}
macro roxr.b #@qs,@[C2Dn]r1d
{
	push16be(0xe010|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro roxr.w,roxr #@qs,@[C2Dn]r1d
{
	push16be(0xe050|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro roxr.l #@qs,@[C2Dn]r1d
{
	push16be(0xe090|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro roxr.w,roxr (@[C2An]r1s)
{
	push16be(0xe4d0|r1s);
}
macro roxr.w,roxr (@[C2An]r1s)+
{
	push16be(0xe4d8|r1s);
}
macro roxr.w,roxr -(@[C2An]r1s)
{
	push16be(0xe4e0|r1s);
}
macro roxr.w,roxr @is(@[C2An]r1s)
{
	push16be(0xe4e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro roxr.w,roxr @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0xe4f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro roxr.w,roxr (@is).w
{
	push16be(0xe4f8);
	push16be(0|c2sr<16>(is));
}
macro roxr.w,roxr (@is).l
{
	push16be(0xe4f9);
	push32be(0|c2ur<32>(is),true);
}
macro roxr.w,roxr @is
{
	push16be(0xe4f9);
	push32be(0|c2ur<32>(is),true);
}
macro rte
{
	push16be(0x4e73);
}
macro rtr
{
	push16be(0x4e77);
}
macro rts
{
	push16be(0x4e75);
}
macro sbcd.b,sbcd @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x8100|r1s|(r1d<<9));
}
macro sbcd.b,sbcd -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x8108|r1s|(r1d<<9));
}
macro st.b,st @[C2Dn]r1s
{
	push16be(0x50c0|r1s);
}
macro st.b,st (@[C2An]r1s)
{
	push16be(0x50d0|r1s);
}
macro st.b,st (@[C2An]r1s)+
{
	push16be(0x50d8|r1s);
}
macro st.b,st -(@[C2An]r1s)
{
	push16be(0x50e0|r1s);
}
macro st.b,st @is(@[C2An]r1s)
{
	push16be(0x50e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro st.b,st @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x50f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro st.b,st (@is).w
{
	push16be(0x50f8);
	push16be(0|c2sr<16>(is));
}
macro st.b,st (@is).l
{
	push16be(0x50f9);
	push32be(0|c2ur<32>(is),true);
}
macro st.b,st @is
{
	push16be(0x50f9);
	push32be(0|c2ur<32>(is),true);
}
macro sf.b,sf @[C2Dn]r1s
{
	push16be(0x51c0|r1s);
}
macro sf.b,sf (@[C2An]r1s)
{
	push16be(0x51d0|r1s);
}
macro sf.b,sf (@[C2An]r1s)+
{
	push16be(0x51d8|r1s);
}
macro sf.b,sf -(@[C2An]r1s)
{
	push16be(0x51e0|r1s);
}
macro sf.b,sf @is(@[C2An]r1s)
{
	push16be(0x51e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro sf.b,sf @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x51f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sf.b,sf (@is).w
{
	push16be(0x51f8);
	push16be(0|c2sr<16>(is));
}
macro sf.b,sf (@is).l
{
	push16be(0x51f9);
	push32be(0|c2ur<32>(is),true);
}
macro sf.b,sf @is
{
	push16be(0x51f9);
	push32be(0|c2ur<32>(is),true);
}
macro shi.b,shi @[C2Dn]r1s
{
	push16be(0x52c0|r1s);
}
macro shi.b,shi (@[C2An]r1s)
{
	push16be(0x52d0|r1s);
}
macro shi.b,shi (@[C2An]r1s)+
{
	push16be(0x52d8|r1s);
}
macro shi.b,shi -(@[C2An]r1s)
{
	push16be(0x52e0|r1s);
}
macro shi.b,shi @is(@[C2An]r1s)
{
	push16be(0x52e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro shi.b,shi @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x52f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro shi.b,shi (@is).w
{
	push16be(0x52f8);
	push16be(0|c2sr<16>(is));
}
macro shi.b,shi (@is).l
{
	push16be(0x52f9);
	push32be(0|c2ur<32>(is),true);
}
macro shi.b,shi @is
{
	push16be(0x52f9);
	push32be(0|c2ur<32>(is),true);
}
macro sls.b,sls @[C2Dn]r1s
{
	push16be(0x53c0|r1s);
}
macro sls.b,sls (@[C2An]r1s)
{
	push16be(0x53d0|r1s);
}
macro sls.b,sls (@[C2An]r1s)+
{
	push16be(0x53d8|r1s);
}
macro sls.b,sls -(@[C2An]r1s)
{
	push16be(0x53e0|r1s);
}
macro sls.b,sls @is(@[C2An]r1s)
{
	push16be(0x53e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro sls.b,sls @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x53f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sls.b,sls (@is).w
{
	push16be(0x53f8);
	push16be(0|c2sr<16>(is));
}
macro sls.b,sls (@is).l
{
	push16be(0x53f9);
	push32be(0|c2ur<32>(is),true);
}
macro sls.b,sls @is
{
	push16be(0x53f9);
	push32be(0|c2ur<32>(is),true);
}
macro scc.b,scc @[C2Dn]r1s
{
	push16be(0x54c0|r1s);
}
macro scc.b,scc (@[C2An]r1s)
{
	push16be(0x54d0|r1s);
}
macro scc.b,scc (@[C2An]r1s)+
{
	push16be(0x54d8|r1s);
}
macro scc.b,scc -(@[C2An]r1s)
{
	push16be(0x54e0|r1s);
}
macro scc.b,scc @is(@[C2An]r1s)
{
	push16be(0x54e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro scc.b,scc @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x54f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro scc.b,scc (@is).w
{
	push16be(0x54f8);
	push16be(0|c2sr<16>(is));
}
macro scc.b,scc (@is).l
{
	push16be(0x54f9);
	push32be(0|c2ur<32>(is),true);
}
macro scc.b,scc @is
{
	push16be(0x54f9);
	push32be(0|c2ur<32>(is),true);
}
macro scs.b,scs @[C2Dn]r1s
{
	push16be(0x55c0|r1s);
}
macro scs.b,scs (@[C2An]r1s)
{
	push16be(0x55d0|r1s);
}
macro scs.b,scs (@[C2An]r1s)+
{
	push16be(0x55d8|r1s);
}
macro scs.b,scs -(@[C2An]r1s)
{
	push16be(0x55e0|r1s);
}
macro scs.b,scs @is(@[C2An]r1s)
{
	push16be(0x55e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro scs.b,scs @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x55f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro scs.b,scs (@is).w
{
	push16be(0x55f8);
	push16be(0|c2sr<16>(is));
}
macro scs.b,scs (@is).l
{
	push16be(0x55f9);
	push32be(0|c2ur<32>(is),true);
}
macro scs.b,scs @is
{
	push16be(0x55f9);
	push32be(0|c2ur<32>(is),true);
}
macro sne.b,sne @[C2Dn]r1s
{
	push16be(0x56c0|r1s);
}
macro sne.b,sne (@[C2An]r1s)
{
	push16be(0x56d0|r1s);
}
macro sne.b,sne (@[C2An]r1s)+
{
	push16be(0x56d8|r1s);
}
macro sne.b,sne -(@[C2An]r1s)
{
	push16be(0x56e0|r1s);
}
macro sne.b,sne @is(@[C2An]r1s)
{
	push16be(0x56e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro sne.b,sne @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x56f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sne.b,sne (@is).w
{
	push16be(0x56f8);
	push16be(0|c2sr<16>(is));
}
macro sne.b,sne (@is).l
{
	push16be(0x56f9);
	push32be(0|c2ur<32>(is),true);
}
macro sne.b,sne @is
{
	push16be(0x56f9);
	push32be(0|c2ur<32>(is),true);
}
macro seq.b,seq @[C2Dn]r1s
{
	push16be(0x57c0|r1s);
}
macro seq.b,seq (@[C2An]r1s)
{
	push16be(0x57d0|r1s);
}
macro seq.b,seq (@[C2An]r1s)+
{
	push16be(0x57d8|r1s);
}
macro seq.b,seq -(@[C2An]r1s)
{
	push16be(0x57e0|r1s);
}
macro seq.b,seq @is(@[C2An]r1s)
{
	push16be(0x57e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro seq.b,seq @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x57f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro seq.b,seq (@is).w
{
	push16be(0x57f8);
	push16be(0|c2sr<16>(is));
}
macro seq.b,seq (@is).l
{
	push16be(0x57f9);
	push32be(0|c2ur<32>(is),true);
}
macro seq.b,seq @is
{
	push16be(0x57f9);
	push32be(0|c2ur<32>(is),true);
}
macro svc.b,svc @[C2Dn]r1s
{
	push16be(0x58c0|r1s);
}
macro svc.b,svc (@[C2An]r1s)
{
	push16be(0x58d0|r1s);
}
macro svc.b,svc (@[C2An]r1s)+
{
	push16be(0x58d8|r1s);
}
macro svc.b,svc -(@[C2An]r1s)
{
	push16be(0x58e0|r1s);
}
macro svc.b,svc @is(@[C2An]r1s)
{
	push16be(0x58e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro svc.b,svc @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x58f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro svc.b,svc (@is).w
{
	push16be(0x58f8);
	push16be(0|c2sr<16>(is));
}
macro svc.b,svc (@is).l
{
	push16be(0x58f9);
	push32be(0|c2ur<32>(is),true);
}
macro svc.b,svc @is
{
	push16be(0x58f9);
	push32be(0|c2ur<32>(is),true);
}
macro svs.b,svs @[C2Dn]r1s
{
	push16be(0x59c0|r1s);
}
macro svs.b,svs (@[C2An]r1s)
{
	push16be(0x59d0|r1s);
}
macro svs.b,svs (@[C2An]r1s)+
{
	push16be(0x59d8|r1s);
}
macro svs.b,svs -(@[C2An]r1s)
{
	push16be(0x59e0|r1s);
}
macro svs.b,svs @is(@[C2An]r1s)
{
	push16be(0x59e8|r1s);
	push16be(0|c2sr<16>(is));
}
macro svs.b,svs @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x59f0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro svs.b,svs (@is).w
{
	push16be(0x59f8);
	push16be(0|c2sr<16>(is));
}
macro svs.b,svs (@is).l
{
	push16be(0x59f9);
	push32be(0|c2ur<32>(is),true);
}
macro svs.b,svs @is
{
	push16be(0x59f9);
	push32be(0|c2ur<32>(is),true);
}
macro spl.b,spl @[C2Dn]r1s
{
	push16be(0x5ac0|r1s);
}
macro spl.b,spl (@[C2An]r1s)
{
	push16be(0x5ad0|r1s);
}
macro spl.b,spl (@[C2An]r1s)+
{
	push16be(0x5ad8|r1s);
}
macro spl.b,spl -(@[C2An]r1s)
{
	push16be(0x5ae0|r1s);
}
macro spl.b,spl @is(@[C2An]r1s)
{
	push16be(0x5ae8|r1s);
	push16be(0|c2sr<16>(is));
}
macro spl.b,spl @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x5af0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro spl.b,spl (@is).w
{
	push16be(0x5af8);
	push16be(0|c2sr<16>(is));
}
macro spl.b,spl (@is).l
{
	push16be(0x5af9);
	push32be(0|c2ur<32>(is),true);
}
macro spl.b,spl @is
{
	push16be(0x5af9);
	push32be(0|c2ur<32>(is),true);
}
macro smi.b,smi @[C2Dn]r1s
{
	push16be(0x5bc0|r1s);
}
macro smi.b,smi (@[C2An]r1s)
{
	push16be(0x5bd0|r1s);
}
macro smi.b,smi (@[C2An]r1s)+
{
	push16be(0x5bd8|r1s);
}
macro smi.b,smi -(@[C2An]r1s)
{
	push16be(0x5be0|r1s);
}
macro smi.b,smi @is(@[C2An]r1s)
{
	push16be(0x5be8|r1s);
	push16be(0|c2sr<16>(is));
}
macro smi.b,smi @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x5bf0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro smi.b,smi (@is).w
{
	push16be(0x5bf8);
	push16be(0|c2sr<16>(is));
}
macro smi.b,smi (@is).l
{
	push16be(0x5bf9);
	push32be(0|c2ur<32>(is),true);
}
macro smi.b,smi @is
{
	push16be(0x5bf9);
	push32be(0|c2ur<32>(is),true);
}
macro sge.b,sge @[C2Dn]r1s
{
	push16be(0x5cc0|r1s);
}
macro sge.b,sge (@[C2An]r1s)
{
	push16be(0x5cd0|r1s);
}
macro sge.b,sge (@[C2An]r1s)+
{
	push16be(0x5cd8|r1s);
}
macro sge.b,sge -(@[C2An]r1s)
{
	push16be(0x5ce0|r1s);
}
macro sge.b,sge @is(@[C2An]r1s)
{
	push16be(0x5ce8|r1s);
	push16be(0|c2sr<16>(is));
}
macro sge.b,sge @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x5cf0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sge.b,sge (@is).w
{
	push16be(0x5cf8);
	push16be(0|c2sr<16>(is));
}
macro sge.b,sge (@is).l
{
	push16be(0x5cf9);
	push32be(0|c2ur<32>(is),true);
}
macro sge.b,sge @is
{
	push16be(0x5cf9);
	push32be(0|c2ur<32>(is),true);
}
macro slt.b,slt @[C2Dn]r1s
{
	push16be(0x5dc0|r1s);
}
macro slt.b,slt (@[C2An]r1s)
{
	push16be(0x5dd0|r1s);
}
macro slt.b,slt (@[C2An]r1s)+
{
	push16be(0x5dd8|r1s);
}
macro slt.b,slt -(@[C2An]r1s)
{
	push16be(0x5de0|r1s);
}
macro slt.b,slt @is(@[C2An]r1s)
{
	push16be(0x5de8|r1s);
	push16be(0|c2sr<16>(is));
}
macro slt.b,slt @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x5df0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro slt.b,slt (@is).w
{
	push16be(0x5df8);
	push16be(0|c2sr<16>(is));
}
macro slt.b,slt (@is).l
{
	push16be(0x5df9);
	push32be(0|c2ur<32>(is),true);
}
macro slt.b,slt @is
{
	push16be(0x5df9);
	push32be(0|c2ur<32>(is),true);
}
macro sgt.b,sgt @[C2Dn]r1s
{
	push16be(0x5ec0|r1s);
}
macro sgt.b,sgt (@[C2An]r1s)
{
	push16be(0x5ed0|r1s);
}
macro sgt.b,sgt (@[C2An]r1s)+
{
	push16be(0x5ed8|r1s);
}
macro sgt.b,sgt -(@[C2An]r1s)
{
	push16be(0x5ee0|r1s);
}
macro sgt.b,sgt @is(@[C2An]r1s)
{
	push16be(0x5ee8|r1s);
	push16be(0|c2sr<16>(is));
}
macro sgt.b,sgt @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x5ef0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sgt.b,sgt (@is).w
{
	push16be(0x5ef8);
	push16be(0|c2sr<16>(is));
}
macro sgt.b,sgt (@is).l
{
	push16be(0x5ef9);
	push32be(0|c2ur<32>(is),true);
}
macro sgt.b,sgt @is
{
	push16be(0x5ef9);
	push32be(0|c2ur<32>(is),true);
}
macro sle.b,sle @[C2Dn]r1s
{
	push16be(0x5fc0|r1s);
}
macro sle.b,sle (@[C2An]r1s)
{
	push16be(0x5fd0|r1s);
}
macro sle.b,sle (@[C2An]r1s)+
{
	push16be(0x5fd8|r1s);
}
macro sle.b,sle -(@[C2An]r1s)
{
	push16be(0x5fe0|r1s);
}
macro sle.b,sle @is(@[C2An]r1s)
{
	push16be(0x5fe8|r1s);
	push16be(0|c2sr<16>(is));
}
macro sle.b,sle @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x5ff0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sle.b,sle (@is).w
{
	push16be(0x5ff8);
	push16be(0|c2sr<16>(is));
}
macro sle.b,sle (@is).l
{
	push16be(0x5ff9);
	push32be(0|c2ur<32>(is),true);
}
macro sle.b,sle @is
{
	push16be(0x5ff9);
	push32be(0|c2ur<32>(is),true);
}
macro stop #@us
{
	push16be(0x4e72);
	push16be(0|c2r<16>(us));
}
macro sub.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x9000|r1s|(r1d<<9));
}
macro sub.b (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x9010|r1s|(r1d<<9));
}
macro sub.b (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x9018|r1s|(r1d<<9));
}
macro sub.b -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x9020|r1s|(r1d<<9));
}
macro sub.b @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x9028|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro sub.b @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x9030|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sub.b (@is).w,@[C2Dn]r1d
{
	push16be(0x9038|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro sub.b (@is).l,@[C2Dn]r1d
{
	push16be(0x9039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro sub.b @is,@[C2Dn]r1d
{
	push16be(0x9039|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro sub.b #@is,@[C2Dn]r1d
{
	push16be(0x903c|(r1d<<9));
	push16be(0|c2ur<8>(is));
}
macro sub.b @is(pc),@[C2Dn]r1d
{
	push16be(0x903a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro sub.b @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x903b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sub.b @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x9110|(r1s<<9)|r1d);
}
macro sub.b @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x9118|(r1s<<9)|r1d);
}
macro sub.b @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x9120|(r1s<<9)|r1d);
}
macro sub.b @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x9128|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro sub.b @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x9130|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro sub.b @[C2Dn]r1s,(@id).w
{
	push16be(0x9138|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro sub.b @[C2Dn]r1s,(@id).l
{
	push16be(0x9139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro sub.b @[C2Dn]r1s,@id
{
	push16be(0x9139|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro sub.w,sub @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x9040|r1s|(r1d<<9));
}
macro sub.w,sub @[C2An]r1s,@[C2Dn]r1d
{
	push16be(0x9048|r1s|(r1d<<9));
}
macro sub.w,sub (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x9050|r1s|(r1d<<9));
}
macro sub.w,sub (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x9058|r1s|(r1d<<9));
}
macro sub.w,sub -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x9060|r1s|(r1d<<9));
}
macro sub.w,sub @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x9068|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro sub.w,sub @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x9070|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sub.w,sub (@is).w,@[C2Dn]r1d
{
	push16be(0x9078|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro sub.w,sub (@is).l,@[C2Dn]r1d
{
	push16be(0x9079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro sub.w,sub @is,@[C2Dn]r1d
{
	push16be(0x9079|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro sub.w,sub #@is,@[C2Dn]r1d
{
	push16be(0x907c|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro sub.w,sub @is(pc),@[C2Dn]r1d
{
	push16be(0x907a|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro sub.w,sub @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x907b|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sub.w,sub @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x9150|(r1s<<9)|r1d);
}
macro sub.w,sub @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x9158|(r1s<<9)|r1d);
}
macro sub.w,sub @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x9160|(r1s<<9)|r1d);
}
macro sub.w,sub @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x9168|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro sub.w,sub @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x9170|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro sub.w,sub @[C2Dn]r1s,(@id).w
{
	push16be(0x9178|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro sub.w,sub @[C2Dn]r1s,(@id).l
{
	push16be(0x9179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro sub.w,sub @[C2Dn]r1s,@id
{
	push16be(0x9179|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro sub.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x9080|r1s|(r1d<<9));
}
macro sub.l @[C2An]r1s,@[C2Dn]r1d
{
	push16be(0x9088|r1s|(r1d<<9));
}
macro sub.l (@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x9090|r1s|(r1d<<9));
}
macro sub.l (@[C2An]r1s)+,@[C2Dn]r1d
{
	push16be(0x9098|r1s|(r1d<<9));
}
macro sub.l -(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x90a0|r1s|(r1d<<9));
}
macro sub.l @is(@[C2An]r1s),@[C2Dn]r1d
{
	push16be(0x90a8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro sub.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x90b0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sub.l (@is).w,@[C2Dn]r1d
{
	push16be(0x90b8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro sub.l (@is).l,@[C2Dn]r1d
{
	push16be(0x90b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro sub.l @is,@[C2Dn]r1d
{
	push16be(0x90b9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro sub.l #@is,@[C2Dn]r1d
{
	push16be(0x90bc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro sub.l @is(pc),@[C2Dn]r1d
{
	push16be(0x90ba|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro sub.l @is(pc,@[C2Dns]r2s),@[C2Dn]r1d
{
	push16be(0x90bb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro sub.l @[C2Dn]r1s,(@[C2An]r1d)
{
	push16be(0x9190|(r1s<<9)|r1d);
}
macro sub.l @[C2Dn]r1s,(@[C2An]r1d)+
{
	push16be(0x9198|(r1s<<9)|r1d);
}
macro sub.l @[C2Dn]r1s,-(@[C2An]r1d)
{
	push16be(0x91a0|(r1s<<9)|r1d);
}
macro sub.l @[C2Dn]r1s,@id(@[C2An]r1d)
{
	push16be(0x91a8|(r1s<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro sub.l @[C2Dn]r1s,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x91b0|(r1s<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro sub.l @[C2Dn]r1s,(@id).w
{
	push16be(0x91b8|(r1s<<9));
	push16be(0|c2sr<16>(id));
}
macro sub.l @[C2Dn]r1s,(@id).l
{
	push16be(0x91b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro sub.l @[C2Dn]r1s,@id
{
	push16be(0x91b9|(r1s<<9));
	push32be(0|c2sr<32>(id),true);
}
macro suba.w,suba @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0x90c0|r1s|(r1d<<9));
}
macro suba.w,suba @[C2An]r1s,@[C2An]r1d
{
	push16be(0x90c8|r1s|(r1d<<9));
}
macro suba.w,suba (@[C2An]r1s),@[C2An]r1d
{
	push16be(0x90d0|r1s|(r1d<<9));
}
macro suba.w,suba (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0x90d8|r1s|(r1d<<9));
}
macro suba.w,suba -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x90e0|r1s|(r1d<<9));
}
macro suba.w,suba @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x90e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro suba.w,suba @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x90f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro suba.w,suba (@is).w,@[C2An]r1d
{
	push16be(0x90f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro suba.w,suba (@is).l,@[C2An]r1d
{
	push16be(0x90f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro suba.w,suba @is,@[C2An]r1d
{
	push16be(0x90f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro suba.w,suba #@is,@[C2An]r1d
{
	push16be(0x90fc|(r1d<<9));
	push16be(0|c2ur<16>(is));
}
macro suba.w,suba @is(pc),@[C2An]r1d
{
	push16be(0x90fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro suba.w,suba @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x90fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro suba.l @[C2Dn]r1s,@[C2An]r1d
{
	push16be(0x91c0|r1s|(r1d<<9));
}
macro suba.l @[C2An]r1s,@[C2An]r1d
{
	push16be(0x91c8|r1s|(r1d<<9));
}
macro suba.l (@[C2An]r1s),@[C2An]r1d
{
	push16be(0x91d0|r1s|(r1d<<9));
}
macro suba.l (@[C2An]r1s)+,@[C2An]r1d
{
	push16be(0x91d8|r1s|(r1d<<9));
}
macro suba.l -(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x91e0|r1s|(r1d<<9));
}
macro suba.l @is(@[C2An]r1s),@[C2An]r1d
{
	push16be(0x91e8|r1s|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro suba.l @is(@[C2An]r1s,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x91f0|r1s|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro suba.l (@is).w,@[C2An]r1d
{
	push16be(0x91f8|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro suba.l (@is).l,@[C2An]r1d
{
	push16be(0x91f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro suba.l @is,@[C2An]r1d
{
	push16be(0x91f9|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro suba.l #@is,@[C2An]r1d
{
	push16be(0x91fc|(r1d<<9));
	push32be(0|c2ur<32>(is),true);
}
macro suba.l @is(pc),@[C2An]r1d
{
	push16be(0x91fa|(r1d<<9));
	push16be(0|c2sr<16>(is));
}
macro suba.l @is(pc,@[C2Dns]r2s),@[C2An]r1d
{
	push16be(0x91fb|(r1d<<9));
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro subi.b #@is,@[C2Dn]r1d
{
	push16be(0x0400|r1d);
	push16be(0|c2ur<8>(is));
}
macro subi.b #@is,(@[C2An]r1d)
{
	push16be(0x0410|r1d);
	push16be(0|c2ur<8>(is));
}
macro subi.b #@is,(@[C2An]r1d)+
{
	push16be(0x0418|r1d);
	push16be(0|c2ur<8>(is));
}
macro subi.b #@is,-(@[C2An]r1d)
{
	push16be(0x0420|r1d);
	push16be(0|c2ur<8>(is));
}
macro subi.b #@is,@id(@[C2An]r1d)
{
	push16be(0x0428|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro subi.b #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0430|r1d);
	push16be(0|c2ur<8>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro subi.b #@is,(@id).w
{
	push16be(0x0438);
	push16be(0|c2ur<8>(is));
	push16be(0|c2ur<16>(id));
}
macro subi.b #@is,(@id).l
{
	push16be(0x0439);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro subi.b #@is,@id
{
	push16be(0x0439);
	push16be(0|c2ur<8>(is));
	push32be(0|c2ur<32>(id),true);
}
macro subi.w,subi #@is,@[C2Dn]r1d
{
	push16be(0x0440|r1d);
	push16be(0|c2ur<16>(is));
}
macro subi.w,subi #@is,(@[C2An]r1d)
{
	push16be(0x0450|r1d);
	push16be(0|c2ur<16>(is));
}
macro subi.w,subi #@is,(@[C2An]r1d)+
{
	push16be(0x0458|r1d);
	push16be(0|c2ur<16>(is));
}
macro subi.w,subi #@is,-(@[C2An]r1d)
{
	push16be(0x0460|r1d);
	push16be(0|c2ur<16>(is));
}
macro subi.w,subi #@is,@id(@[C2An]r1d)
{
	push16be(0x0468|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro subi.w,subi #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x0470|r1d);
	push16be(0|c2ur<16>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro subi.w,subi #@is,(@id).w
{
	push16be(0x0478);
	push16be(0|c2ur<16>(is));
	push16be(0|c2ur<16>(id));
}
macro subi.w,subi #@is,(@id).l
{
	push16be(0x0479);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro subi.w,subi #@is,@id
{
	push16be(0x0479);
	push16be(0|c2ur<16>(is));
	push32be(0|c2ur<32>(id),true);
}
macro subi.l #@is,@[C2Dn]r1d
{
	push16be(0x0480|r1d);
	push32be(0|c2ur<32>(is));
}
macro subi.l #@is,(@[C2An]r1d)
{
	push16be(0x0490|r1d);
	push32be(0|c2ur<32>(is));
}
macro subi.l #@is,(@[C2An]r1d)+
{
	push16be(0x0498|r1d);
	push32be(0|c2ur<32>(is));
}
macro subi.l #@is,-(@[C2An]r1d)
{
	push16be(0x04a0|r1d);
	push32be(0|c2ur<32>(is));
}
macro subi.l #@is,@id(@[C2An]r1d)
{
	push16be(0x04a8|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro subi.l #@is,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x04b0|r1d);
	push32be(0|c2ur<32>(is));
	push16be(0|((r2d&7)<<12)|c2ur<8>(id)|(((r2d>>3)&1)<<11));
}
macro subi.l #@is,(@id).w
{
	push16be(0x04b8);
	push32be(0|c2ur<32>(is));
	push16be(0|c2ur<16>(id));
}
macro subi.l #@is,(@id).l
{
	push16be(0x04b9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro subi.l #@is,@id
{
	push16be(0x04b9);
	push32be(0|c2ur<32>(is));
	push32be(0|c2ur<32>(id),true);
}
macro subq.b #@qs,@[C2Dn]r1d
{
	push16be(0x5100|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.b #@qs,(@[C2An]r1d)
{
	push16be(0x5110|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.b #@qs,(@[C2An]r1d)+
{
	push16be(0x5118|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.b #@qs,-(@[C2An]r1d)
{
	push16be(0x5120|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.b #@qs,@id(@[C2An]r1d)
{
	push16be(0x5128|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro subq.b #@qs,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x5130|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro subq.b #@qs,(@id).w
{
	push16be(0x5138|(c2lh<1,8>(qs)&7)<<9));
	push16be(0|c2sr<16>(id));
}
macro subq.b #@qs,(@id).l
{
	push16be(0x5139|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro subq.b #@qs,@id
{
	push16be(0x5139|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro subq.w,subq #@qs,@[C2Dn]r1d
{
	push16be(0x5140|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.w,subq #@qs,@[C2An]r1d
{
	push16be(0x5148|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.w,subq #@qs,(@[C2An]r1d)
{
	push16be(0x5150|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.w,subq #@qs,(@[C2An]r1d)+
{
	push16be(0x5158|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.w,subq #@qs,-(@[C2An]r1d)
{
	push16be(0x5160|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.w,subq #@qs,@id(@[C2An]r1d)
{
	push16be(0x5168|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro subq.w,subq #@qs,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x5170|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro subq.w,subq #@qs,(@id).w
{
	push16be(0x5178|(c2lh<1,8>(qs)&7)<<9));
	push16be(0|c2sr<16>(id));
}
macro subq.w,subq #@qs,(@id).l
{
	push16be(0x5179|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro subq.w,subq #@qs,@id
{
	push16be(0x5179|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro subq.l #@qs,@[C2Dn]r1d
{
	push16be(0x5180|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.l #@qs,@[C2An]r1d
{
	push16be(0x5188|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.l #@qs,(@[C2An]r1d)
{
	push16be(0x5190|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.l #@qs,(@[C2An]r1d)+
{
	push16be(0x5198|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.l #@qs,-(@[C2An]r1d)
{
	push16be(0x51a0|(c2lh<1,8>(qs)&7)<<9)|r1d);
}
macro subq.l #@qs,@id(@[C2An]r1d)
{
	push16be(0x51a8|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|c2sr<16>(id));
}
macro subq.l #@qs,@id(@[C2An]r1d,@[C2Dnd]r2d)
{
	push16be(0x51b0|(c2lh<1,8>(qs)&7)<<9)|r1d);
	push16be(0|((r2d&7)<<12)|c2sr<8>(id)|(((r2d>>3)&1)<<11));
}
macro subq.l #@qs,(@id).w
{
	push16be(0x51b8|(c2lh<1,8>(qs)&7)<<9));
	push16be(0|c2sr<16>(id));
}
macro subq.l #@qs,(@id).l
{
	push16be(0x51b9|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro subq.l #@qs,@id
{
	push16be(0x51b9|(c2lh<1,8>(qs)&7)<<9));
	push32be(0|c2sr<32>(id),true);
}
macro subx.b @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x9100|r1s|(r1d<<9));
}
macro subx.b -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x9108|r1s|(r1d<<9));
}
macro subx.w,subx @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x9140|r1s|(r1d<<9));
}
macro subx.w,subx -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x9148|r1s|(r1d<<9));
}
macro subx.l @[C2Dn]r1s,@[C2Dn]r1d
{
	push16be(0x9180|r1s|(r1d<<9));
}
macro subx.l -(@[C2An]r1s),-(@[C2An]r1d)
{
	push16be(0x9188|r1s|(r1d<<9));
}
macro swap.w,swap @[C2Dn]r1s
{
	push16be(0x4840|r1s);
}
macro tas.b,tas @[C2Dn]r1s
{
	push16be(0x4ac0|r1s);
}
macro tas.b,tas (@[C2An]r1s)
{
	push16be(0x4ad0|r1s);
}
macro tas.b,tas (@[C2An]r1s)+
{
	push16be(0x4ad8|r1s);
}
macro tas.b,tas -(@[C2An]r1s)
{
	push16be(0x4ae0|r1s);
}
macro tas.b,tas @is(@[C2An]r1s)
{
	push16be(0x4ae8|r1s);
	push16be(0|c2sr<16>(is));
}
macro tas.b,tas @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4af0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro tas.b,tas (@is).w
{
	push16be(0x4af8);
	push16be(0|c2sr<16>(is));
}
macro tas.b,tas (@is).l
{
	push16be(0x4af9);
	push32be(0|c2ur<32>(is),true);
}
macro tas.b,tas @is
{
	push16be(0x4af9);
	push32be(0|c2ur<32>(is),true);
}
macro trap #@us
{
	push16be(0x4e40|c2r<4>(us));
}
macro trapv
{
	push16be(0x4e76);
}
macro tst.b @[C2Dn]r1s
{
	push16be(0x4a00|r1s);
}
macro tst.b (@[C2An]r1s)
{
	push16be(0x4a10|r1s);
}
macro tst.b (@[C2An]r1s)+
{
	push16be(0x4a18|r1s);
}
macro tst.b -(@[C2An]r1s)
{
	push16be(0x4a20|r1s);
}
macro tst.b @is(@[C2An]r1s)
{
	push16be(0x4a28|r1s);
	push16be(0|c2sr<16>(is));
}
macro tst.b @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4a30|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro tst.b (@is).w
{
	push16be(0x4a38);
	push16be(0|c2sr<16>(is));
}
macro tst.b (@is).l
{
	push16be(0x4a39);
	push32be(0|c2ur<32>(is),true);
}
macro tst.b @is
{
	push16be(0x4a39);
	push32be(0|c2ur<32>(is),true);
}
macro tst.w,tst @[C2Dn]r1s
{
	push16be(0x4a40|r1s);
}
macro tst.w,tst (@[C2An]r1s)
{
	push16be(0x4a50|r1s);
}
macro tst.w,tst (@[C2An]r1s)+
{
	push16be(0x4a58|r1s);
}
macro tst.w,tst -(@[C2An]r1s)
{
	push16be(0x4a60|r1s);
}
macro tst.w,tst @is(@[C2An]r1s)
{
	push16be(0x4a68|r1s);
	push16be(0|c2sr<16>(is));
}
macro tst.w,tst @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4a70|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro tst.w,tst (@is).w
{
	push16be(0x4a78);
	push16be(0|c2sr<16>(is));
}
macro tst.w,tst (@is).l
{
	push16be(0x4a79);
	push32be(0|c2ur<32>(is),true);
}
macro tst.w,tst @is
{
	push16be(0x4a79);
	push32be(0|c2ur<32>(is),true);
}
macro tst.l @[C2Dn]r1s
{
	push16be(0x4a80|r1s);
}
macro tst.l (@[C2An]r1s)
{
	push16be(0x4a90|r1s);
}
macro tst.l (@[C2An]r1s)+
{
	push16be(0x4a98|r1s);
}
macro tst.l -(@[C2An]r1s)
{
	push16be(0x4aa0|r1s);
}
macro tst.l @is(@[C2An]r1s)
{
	push16be(0x4aa8|r1s);
	push16be(0|c2sr<16>(is));
}
macro tst.l @is(@[C2An]r1s,@[C2Dns]r2s)
{
	push16be(0x4ab0|r1s);
	push16be(0|((r2s&7)<<12)|c2sr<8>(is)|(((r2s>>3)&0x1)<<11));
}
macro tst.l (@is).w
{
	push16be(0x4ab8);
	push16be(0|c2sr<16>(is));
}
macro tst.l (@is).l
{
	push16be(0x4ab9);
	push32be(0|c2ur<32>(is),true);
}
macro tst.l @is
{
	push16be(0x4ab9);
	push32be(0|c2ur<32>(is),true);
}
macro unlk @[C2An]r1s
{
	push16be(0x4e58|r1s);
}
macro byte @data
{
    push8(data);
}

macro byte @data...
{
    for(size_t r=0;r<data.size();r++)
        push8(data[r]);
}

macro word @data
{
    push16be(data);
}

macro word @data...
{
    for(size_t r=0;r<data.size();r++)
        push16be(data[r]);
}

macro wordle @data
{
    push16le(data);
}

macro wordle @data...
{
    for(size_t r=0;r<data.size();r++)
        push16le(data[r]);
}

macro dword @data
{
    push32be(data);
}

macro dword @data...
{
    for(size_t r=0;r<data.size();r++)
        push32be(data[r]);
}

macro dwordle @data
{
    push32le(data);
}

macro dwordle @data...
{
    for(size_t r=0;r<data.size();r++)
        push16le(data[r]);
}

macro align @n
{
    @ = ((@+(n-1))/n)*n
}
