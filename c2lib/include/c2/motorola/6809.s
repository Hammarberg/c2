/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/c2.s"

#define C2_6809

#define C2_6809_EXG d,x,y,u,s,pc,_pad1,_pad2,a,b,cc,dp
#define C2_6809_CC c,v,z,n,i,h,f,e
#define C2_6809_SS cc,a,b,dp,x,y,u,pc
#define C2_6809_SU cc,a,b,dp,x,y,s,pc
#define C2_6809_XYUS x,y,u,s
#define C2_6809_ABD a,b,d

macro abx
{
	push8($3a);
}

macro adca #@imm
{
	push8($89);
	push8(imm);
}

macro adca <@n
{
	push8($99);
	push8(n);
}

macro adca >@n
{
	push8($b9);
	push16be(n);
}

macro adca @n
{
	push8($b9);
	push16be(n);
}

macro adca @off,@[C2_6809_XYUS]r1
{
	push8($a9);
	c2_6809_idx_direct_off(off,r1);
}

macro adca [@off,@[C2_6809_XYUS]r1]
{
	push8($a9);
	c2_6809_idx_indirect_off(off,r1);
}

macro adca ,@[C2_6809_XYUS]r1
{
	push8($a9);
	c2_6809_idx_direct_off(0,r1);
}

macro adca [,@[C2_6809_XYUS]r1]
{
	push8($a9);
	c2_6809_idx_indirect_off(0,r1);
}

macro adca @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($a9);
	c2_6809_idx_direct_acc(r2,r1);
}

macro adca [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($a9);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro adca ,@[C2_6809_XYUS]r1+
{
	push8($a9);
	push8(%10000000|r1<<5);
}

macro adca ,@[C2_6809_XYUS]r1++
{
	push8($a9);
	push8(%10000001|r1<<5);
}

macro adca [,@[C2_6809_XYUS]r1++]
{
	push8($a9);
	push8(%10010001|r1<<5);
}

macro adca ,-@[C2_6809_XYUS]r1
{
	push8($a9);
	push8(%10000010|r1<<5);
}

macro adca ,--@[C2_6809_XYUS]r1
{
	push8($a9);
	push8(%10000011|r1<<5);
}

macro adca [,--@[C2_6809_XYUS]r1]
{
	push8($a9);
	push8(%10010011|r1<<5);
}

macro adca @off,pc
{
	push8($a9);
	c2_6809_idx_direct_pc(off);
}

macro adca [@off,pc]
{
	push8($a9);
	c2_6809_idx_indirect_pc(off);
}

macro adca @off,pcr
{
	push8($a9);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro adca [@off,pcr]
{
	push8($a9);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro adca [@addr]
{
	push8($a9);
	push8(%10011111);
	push16be(addr);
}

macro adcb #@imm
{
	push8($c9);
	push8(imm);
}

macro adcb <@n
{
	push8($d9);
	push8(n);
}

macro adcb >@n
{
	push8($f9);
	push16be(n);
}

macro adcb @n
{
	push8($f9);
	push16be(n);
}

macro adcb @off,@[C2_6809_XYUS]r1
{
	push8($e9);
	c2_6809_idx_direct_off(off,r1);
}

macro adcb [@off,@[C2_6809_XYUS]r1]
{
	push8($e9);
	c2_6809_idx_indirect_off(off,r1);
}

macro adcb ,@[C2_6809_XYUS]r1
{
	push8($e9);
	c2_6809_idx_direct_off(0,r1);
}

macro adcb [,@[C2_6809_XYUS]r1]
{
	push8($e9);
	c2_6809_idx_indirect_off(0,r1);
}

macro adcb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($e9);
	c2_6809_idx_direct_acc(r2,r1);
}

macro adcb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($e9);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro adcb ,@[C2_6809_XYUS]r1+
{
	push8($e9);
	push8(%10000000|r1<<5);
}

macro adcb ,@[C2_6809_XYUS]r1++
{
	push8($e9);
	push8(%10000001|r1<<5);
}

macro adcb [,@[C2_6809_XYUS]r1++]
{
	push8($e9);
	push8(%10010001|r1<<5);
}

macro adcb ,-@[C2_6809_XYUS]r1
{
	push8($e9);
	push8(%10000010|r1<<5);
}

macro adcb ,--@[C2_6809_XYUS]r1
{
	push8($e9);
	push8(%10000011|r1<<5);
}

macro adcb [,--@[C2_6809_XYUS]r1]
{
	push8($e9);
	push8(%10010011|r1<<5);
}

macro adcb @off,pc
{
	push8($e9);
	c2_6809_idx_direct_pc(off);
}

macro adcb [@off,pc]
{
	push8($e9);
	c2_6809_idx_indirect_pc(off);
}

macro adcb @off,pcr
{
	push8($e9);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro adcb [@off,pcr]
{
	push8($e9);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro adcb [@addr]
{
	push8($e9);
	push8(%10011111);
	push16be(addr);
}

macro adda #@imm
{
	push8($8b);
	push8(imm);
}

macro adda <@n
{
	push8($9b);
	push8(n);
}

macro adda >@n
{
	push8($bb);
	push16be(n);
}

macro adda @n
{
	push8($bb);
	push16be(n);
}

macro adda @off,@[C2_6809_XYUS]r1
{
	push8($ab);
	c2_6809_idx_direct_off(off,r1);
}

macro adda [@off,@[C2_6809_XYUS]r1]
{
	push8($ab);
	c2_6809_idx_indirect_off(off,r1);
}

macro adda ,@[C2_6809_XYUS]r1
{
	push8($ab);
	c2_6809_idx_direct_off(0,r1);
}

macro adda [,@[C2_6809_XYUS]r1]
{
	push8($ab);
	c2_6809_idx_indirect_off(0,r1);
}

macro adda @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($ab);
	c2_6809_idx_direct_acc(r2,r1);
}

macro adda [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($ab);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro adda ,@[C2_6809_XYUS]r1+
{
	push8($ab);
	push8(%10000000|r1<<5);
}

macro adda ,@[C2_6809_XYUS]r1++
{
	push8($ab);
	push8(%10000001|r1<<5);
}

macro adda [,@[C2_6809_XYUS]r1++]
{
	push8($ab);
	push8(%10010001|r1<<5);
}

macro adda ,-@[C2_6809_XYUS]r1
{
	push8($ab);
	push8(%10000010|r1<<5);
}

macro adda ,--@[C2_6809_XYUS]r1
{
	push8($ab);
	push8(%10000011|r1<<5);
}

macro adda [,--@[C2_6809_XYUS]r1]
{
	push8($ab);
	push8(%10010011|r1<<5);
}

macro adda @off,pc
{
	push8($ab);
	c2_6809_idx_direct_pc(off);
}

macro adda [@off,pc]
{
	push8($ab);
	c2_6809_idx_indirect_pc(off);
}

macro adda @off,pcr
{
	push8($ab);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro adda [@off,pcr]
{
	push8($ab);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro adda [@addr]
{
	push8($ab);
	push8(%10011111);
	push16be(addr);
}

macro addb #@imm
{
	push8($cb);
	push8(imm);
}

macro addb <@n
{
	push8($db);
	push8(n);
}

macro addb >@n
{
	push8($fb);
	push16be(n);
}

macro addb @n
{
	push8($fb);
	push16be(n);
}

macro addb @off,@[C2_6809_XYUS]r1
{
	push8($eb);
	c2_6809_idx_direct_off(off,r1);
}

macro addb [@off,@[C2_6809_XYUS]r1]
{
	push8($eb);
	c2_6809_idx_indirect_off(off,r1);
}

macro addb ,@[C2_6809_XYUS]r1
{
	push8($eb);
	c2_6809_idx_direct_off(0,r1);
}

macro addb [,@[C2_6809_XYUS]r1]
{
	push8($eb);
	c2_6809_idx_indirect_off(0,r1);
}

macro addb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($eb);
	c2_6809_idx_direct_acc(r2,r1);
}

macro addb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($eb);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro addb ,@[C2_6809_XYUS]r1+
{
	push8($eb);
	push8(%10000000|r1<<5);
}

macro addb ,@[C2_6809_XYUS]r1++
{
	push8($eb);
	push8(%10000001|r1<<5);
}

macro addb [,@[C2_6809_XYUS]r1++]
{
	push8($eb);
	push8(%10010001|r1<<5);
}

macro addb ,-@[C2_6809_XYUS]r1
{
	push8($eb);
	push8(%10000010|r1<<5);
}

macro addb ,--@[C2_6809_XYUS]r1
{
	push8($eb);
	push8(%10000011|r1<<5);
}

macro addb [,--@[C2_6809_XYUS]r1]
{
	push8($eb);
	push8(%10010011|r1<<5);
}

macro addb @off,pc
{
	push8($eb);
	c2_6809_idx_direct_pc(off);
}

macro addb [@off,pc]
{
	push8($eb);
	c2_6809_idx_indirect_pc(off);
}

macro addb @off,pcr
{
	push8($eb);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro addb [@off,pcr]
{
	push8($eb);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro addb [@addr]
{
	push8($eb);
	push8(%10011111);
	push16be(addr);
}

macro addd #@imm
{
	push8($c3);
	push16be(imm);
}

macro addd <@n
{
	push8($d3);
	push8(n);
}

macro addd >@n
{
	push8($f3);
	push16be(n);
}

macro addd @n
{
	push8($f3);
	push16be(n);
}

macro addd @off,@[C2_6809_XYUS]r1
{
	push8($e3);
	c2_6809_idx_direct_off(off,r1);
}

macro addd [@off,@[C2_6809_XYUS]r1]
{
	push8($e3);
	c2_6809_idx_indirect_off(off,r1);
}

macro addd ,@[C2_6809_XYUS]r1
{
	push8($e3);
	c2_6809_idx_direct_off(0,r1);
}

macro addd [,@[C2_6809_XYUS]r1]
{
	push8($e3);
	c2_6809_idx_indirect_off(0,r1);
}

macro addd @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($e3);
	c2_6809_idx_direct_acc(r2,r1);
}

macro addd [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($e3);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro addd ,@[C2_6809_XYUS]r1+
{
	push8($e3);
	push8(%10000000|r1<<5);
}

macro addd ,@[C2_6809_XYUS]r1++
{
	push8($e3);
	push8(%10000001|r1<<5);
}

macro addd [,@[C2_6809_XYUS]r1++]
{
	push8($e3);
	push8(%10010001|r1<<5);
}

macro addd ,-@[C2_6809_XYUS]r1
{
	push8($e3);
	push8(%10000010|r1<<5);
}

macro addd ,--@[C2_6809_XYUS]r1
{
	push8($e3);
	push8(%10000011|r1<<5);
}

macro addd [,--@[C2_6809_XYUS]r1]
{
	push8($e3);
	push8(%10010011|r1<<5);
}

macro addd @off,pc
{
	push8($e3);
	c2_6809_idx_direct_pc(off);
}

macro addd [@off,pc]
{
	push8($e3);
	c2_6809_idx_indirect_pc(off);
}

macro addd @off,pcr
{
	push8($e3);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro addd [@off,pcr]
{
	push8($e3);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro addd [@addr]
{
	push8($e3);
	push8(%10011111);
	push16be(addr);
}

macro anda #@imm
{
	push8($84);
	push8(imm);
}

macro anda <@n
{
	push8($94);
	push8(n);
}

macro anda >@n
{
	push8($b4);
	push16be(n);
}

macro anda @n
{
	push8($b4);
	push16be(n);
}

macro anda @off,@[C2_6809_XYUS]r1
{
	push8($a4);
	c2_6809_idx_direct_off(off,r1);
}

macro anda [@off,@[C2_6809_XYUS]r1]
{
	push8($a4);
	c2_6809_idx_indirect_off(off,r1);
}

macro anda ,@[C2_6809_XYUS]r1
{
	push8($a4);
	c2_6809_idx_direct_off(0,r1);
}

macro anda [,@[C2_6809_XYUS]r1]
{
	push8($a4);
	c2_6809_idx_indirect_off(0,r1);
}

macro anda @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($a4);
	c2_6809_idx_direct_acc(r2,r1);
}

macro anda [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($a4);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro anda ,@[C2_6809_XYUS]r1+
{
	push8($a4);
	push8(%10000000|r1<<5);
}

macro anda ,@[C2_6809_XYUS]r1++
{
	push8($a4);
	push8(%10000001|r1<<5);
}

macro anda [,@[C2_6809_XYUS]r1++]
{
	push8($a4);
	push8(%10010001|r1<<5);
}

macro anda ,-@[C2_6809_XYUS]r1
{
	push8($a4);
	push8(%10000010|r1<<5);
}

macro anda ,--@[C2_6809_XYUS]r1
{
	push8($a4);
	push8(%10000011|r1<<5);
}

macro anda [,--@[C2_6809_XYUS]r1]
{
	push8($a4);
	push8(%10010011|r1<<5);
}

macro anda @off,pc
{
	push8($a4);
	c2_6809_idx_direct_pc(off);
}

macro anda [@off,pc]
{
	push8($a4);
	c2_6809_idx_indirect_pc(off);
}

macro anda @off,pcr
{
	push8($a4);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro anda [@off,pcr]
{
	push8($a4);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro anda [@addr]
{
	push8($a4);
	push8(%10011111);
	push16be(addr);
}

macro andb #@imm
{
	push8($c4);
	push8(imm);
}

macro andb <@n
{
	push8($d4);
	push8(n);
}

macro andb >@n
{
	push8($f4);
	push16be(n);
}

macro andb @n
{
	push8($f4);
	push16be(n);
}

macro andb @off,@[C2_6809_XYUS]r1
{
	push8($e4);
	c2_6809_idx_direct_off(off,r1);
}

macro andb [@off,@[C2_6809_XYUS]r1]
{
	push8($e4);
	c2_6809_idx_indirect_off(off,r1);
}

macro andb ,@[C2_6809_XYUS]r1
{
	push8($e4);
	c2_6809_idx_direct_off(0,r1);
}

macro andb [,@[C2_6809_XYUS]r1]
{
	push8($e4);
	c2_6809_idx_indirect_off(0,r1);
}

macro andb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($e4);
	c2_6809_idx_direct_acc(r2,r1);
}

macro andb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($e4);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro andb ,@[C2_6809_XYUS]r1+
{
	push8($e4);
	push8(%10000000|r1<<5);
}

macro andb ,@[C2_6809_XYUS]r1++
{
	push8($e4);
	push8(%10000001|r1<<5);
}

macro andb [,@[C2_6809_XYUS]r1++]
{
	push8($e4);
	push8(%10010001|r1<<5);
}

macro andb ,-@[C2_6809_XYUS]r1
{
	push8($e4);
	push8(%10000010|r1<<5);
}

macro andb ,--@[C2_6809_XYUS]r1
{
	push8($e4);
	push8(%10000011|r1<<5);
}

macro andb [,--@[C2_6809_XYUS]r1]
{
	push8($e4);
	push8(%10010011|r1<<5);
}

macro andb @off,pc
{
	push8($e4);
	c2_6809_idx_direct_pc(off);
}

macro andb [@off,pc]
{
	push8($e4);
	c2_6809_idx_indirect_pc(off);
}

macro andb @off,pcr
{
	push8($e4);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro andb [@off,pcr]
{
	push8($e4);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro andb [@addr]
{
	push8($e4);
	push8(%10011111);
	push16be(addr);
}

macro andcc #@imm
{
	push8($1c);
	push8(imm);
}

macro asr <@n
{
	push8($07);
	push8(n);
}

macro asr >@n
{
	push8($77);
	push16be(n);
}

macro asr @n
{
	push8($77);
	push16be(n);
}

macro asr @off,@[C2_6809_XYUS]r1
{
	push8($67);
	c2_6809_idx_direct_off(off,r1);
}

macro asr [@off,@[C2_6809_XYUS]r1]
{
	push8($67);
	c2_6809_idx_indirect_off(off,r1);
}

macro asr ,@[C2_6809_XYUS]r1
{
	push8($67);
	c2_6809_idx_direct_off(0,r1);
}

macro asr [,@[C2_6809_XYUS]r1]
{
	push8($67);
	c2_6809_idx_indirect_off(0,r1);
}

macro asr @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($67);
	c2_6809_idx_direct_acc(r2,r1);
}

macro asr [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($67);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro asr ,@[C2_6809_XYUS]r1+
{
	push8($67);
	push8(%10000000|r1<<5);
}

macro asr ,@[C2_6809_XYUS]r1++
{
	push8($67);
	push8(%10000001|r1<<5);
}

macro asr [,@[C2_6809_XYUS]r1++]
{
	push8($67);
	push8(%10010001|r1<<5);
}

macro asr ,-@[C2_6809_XYUS]r1
{
	push8($67);
	push8(%10000010|r1<<5);
}

macro asr ,--@[C2_6809_XYUS]r1
{
	push8($67);
	push8(%10000011|r1<<5);
}

macro asr [,--@[C2_6809_XYUS]r1]
{
	push8($67);
	push8(%10010011|r1<<5);
}

macro asr @off,pc
{
	push8($67);
	c2_6809_idx_direct_pc(off);
}

macro asr [@off,pc]
{
	push8($67);
	c2_6809_idx_indirect_pc(off);
}

macro asr @off,pcr
{
	push8($67);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro asr [@off,pcr]
{
	push8($67);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro asr [@addr]
{
	push8($67);
	push8(%10011111);
	push16be(addr);
}

macro asra
{
	push8($47);
}

macro asrb
{
	push8($57);
}

macro beq @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($27);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($1027);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbeq @addr
{
	push16be($1027);
	push16be(c2sr<16>(addr-@-2));
}

macro bge @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($2c);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($102c);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbge @addr
{
	push16be($102c);
	push16be(c2sr<16>(addr-@-2));
}

macro bgt @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($2e);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($102e);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbgt @addr
{
	push16be($102e);
	push16be(c2sr<16>(addr-@-2));
}

macro bhi @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($22);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($1022);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbhi @addr
{
	push16be($1022);
	push16be(c2sr<16>(addr-@-2));
}

macro bhs,bcc @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($24);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($1024);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbhs,lbcc @addr
{
	push16be($1024);
	push16be(c2sr<16>(addr-@-2));
}

macro bita #@imm
{
	push8($85);
	push8(imm);
}

macro bita <@n
{
	push8($95);
	push8(n);
}

macro bita >@n
{
	push8($b5);
	push16be(n);
}

macro bita @n
{
	push8($b5);
	push16be(n);
}

macro bita @off,@[C2_6809_XYUS]r1
{
	push8($a5);
	c2_6809_idx_direct_off(off,r1);
}

macro bita [@off,@[C2_6809_XYUS]r1]
{
	push8($a5);
	c2_6809_idx_indirect_off(off,r1);
}

macro bita ,@[C2_6809_XYUS]r1
{
	push8($a5);
	c2_6809_idx_direct_off(0,r1);
}

macro bita [,@[C2_6809_XYUS]r1]
{
	push8($a5);
	c2_6809_idx_indirect_off(0,r1);
}

macro bita @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($a5);
	c2_6809_idx_direct_acc(r2,r1);
}

macro bita [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($a5);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro bita ,@[C2_6809_XYUS]r1+
{
	push8($a5);
	push8(%10000000|r1<<5);
}

macro bita ,@[C2_6809_XYUS]r1++
{
	push8($a5);
	push8(%10000001|r1<<5);
}

macro bita [,@[C2_6809_XYUS]r1++]
{
	push8($a5);
	push8(%10010001|r1<<5);
}

macro bita ,-@[C2_6809_XYUS]r1
{
	push8($a5);
	push8(%10000010|r1<<5);
}

macro bita ,--@[C2_6809_XYUS]r1
{
	push8($a5);
	push8(%10000011|r1<<5);
}

macro bita [,--@[C2_6809_XYUS]r1]
{
	push8($a5);
	push8(%10010011|r1<<5);
}

macro bita @off,pc
{
	push8($a5);
	c2_6809_idx_direct_pc(off);
}

macro bita [@off,pc]
{
	push8($a5);
	c2_6809_idx_indirect_pc(off);
}

macro bita @off,pcr
{
	push8($a5);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro bita [@off,pcr]
{
	push8($a5);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro bita [@addr]
{
	push8($a5);
	push8(%10011111);
	push16be(addr);
}

macro bitb #@imm
{
	push8($c5);
	push8(imm);
}

macro bitb <@n
{
	push8($d5);
	push8(n);
}

macro bitb >@n
{
	push8($f5);
	push16be(n);
}

macro bitb @n
{
	push8($f5);
	push16be(n);
}

macro bitb @off,@[C2_6809_XYUS]r1
{
	push8($e5);
	c2_6809_idx_direct_off(off,r1);
}

macro bitb [@off,@[C2_6809_XYUS]r1]
{
	push8($e5);
	c2_6809_idx_indirect_off(off,r1);
}

macro bitb ,@[C2_6809_XYUS]r1
{
	push8($e5);
	c2_6809_idx_direct_off(0,r1);
}

macro bitb [,@[C2_6809_XYUS]r1]
{
	push8($e5);
	c2_6809_idx_indirect_off(0,r1);
}

macro bitb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($e5);
	c2_6809_idx_direct_acc(r2,r1);
}

macro bitb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($e5);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro bitb ,@[C2_6809_XYUS]r1+
{
	push8($e5);
	push8(%10000000|r1<<5);
}

macro bitb ,@[C2_6809_XYUS]r1++
{
	push8($e5);
	push8(%10000001|r1<<5);
}

macro bitb [,@[C2_6809_XYUS]r1++]
{
	push8($e5);
	push8(%10010001|r1<<5);
}

macro bitb ,-@[C2_6809_XYUS]r1
{
	push8($e5);
	push8(%10000010|r1<<5);
}

macro bitb ,--@[C2_6809_XYUS]r1
{
	push8($e5);
	push8(%10000011|r1<<5);
}

macro bitb [,--@[C2_6809_XYUS]r1]
{
	push8($e5);
	push8(%10010011|r1<<5);
}

macro bitb @off,pc
{
	push8($e5);
	c2_6809_idx_direct_pc(off);
}

macro bitb [@off,pc]
{
	push8($e5);
	c2_6809_idx_indirect_pc(off);
}

macro bitb @off,pcr
{
	push8($e5);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro bitb [@off,pcr]
{
	push8($e5);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro bitb [@addr]
{
	push8($e5);
	push8(%10011111);
	push16be(addr);
}

macro ble @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($2f);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($102f);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lble @addr
{
	push16be($102f);
	push16be(c2sr<16>(addr-@-2));
}

macro blo,bcs @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($25);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($1025);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lblo,lbcs @addr
{
	push16be($1025);
	push16be(c2sr<16>(addr-@-2));
}

macro bls @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($23);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($1023);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbls @addr
{
	push16be($1023);
	push16be(c2sr<16>(addr-@-2));
}

macro blt @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($2d);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($102d);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lblt @addr
{
	push16be($102d);
	push16be(c2sr<16>(addr-@-2));
}

macro bmi @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($2b);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($102b);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbmi @addr
{
	push16be($102b);
	push16be(c2sr<16>(addr-@-2));
}

macro bne @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($26);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($1026);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbne @addr
{
	push16be($1026);
	push16be(c2sr<16>(addr-@-2));
}

macro bpl @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($2a);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($102a);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbpl @addr
{
	push16be($102a);
	push16be(c2sr<16>(addr-@-2));
}

macro bra @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*1))){
		lb=0;
		push8($20);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		if(!c2_6809_absolute){
			push8($16);
			push16be(c2sr<16>(addr-@-2));
		}else{
			push8($7e);
			push16be(addr);
		}
	}
}

macro lbra @addr
{
	if(!c2_6809_absolute){
		push8($16);
		push16be(c2sr<16>(addr-@-2));
	}else{
		push8($7e);
		push16be(addr);
	}
}

macro brn @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($21);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($1021);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbrn @addr
{
	push16be($1021);
	push16be(c2sr<16>(addr-@-2));
}

macro bsr @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*1))){
		lb=0;
		push8($8d);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		if(!c2_6809_absolute){
			push8($17);
			push16be(c2sr<16>(addr-@-2));
		}else{
			push8($bd);
			push16be(addr);
		}
	}
}

macro lbsr @addr
{
	if(!c2_6809_absolute){
		push8($17);
		push16be(c2sr<16>(addr-@-2));
	}else{
		push8($bd);
		push16be(addr);
	}
}

macro bvc @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($28);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($1028);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbvc @addr
{
	push16be($1028);
	push16be(c2sr<16>(addr-@-2));
}

macro bvs @addr
{
	c2static lb;
	if(!c2_6809_longbranch || c2st<8>(addr-(@+2+lb*2))){
		lb=0;
		push8($29);
		push8(c2sr<8>(addr-@-1));
	}else{
		lb=1;
		push16be($1029);
		push16be(c2sr<16>(addr-@-2));
	}
}

macro lbvs @addr
{
	push16be($1029);
	push16be(c2sr<16>(addr-@-2));
}

macro clr <@n
{
	push8($0f);
	push8(n);
}

macro clr >@n
{
	push8($7f);
	push16be(n);
}

macro clr @n
{
	push8($7f);
	push16be(n);
}

macro clr @off,@[C2_6809_XYUS]r1
{
	push8($6f);
	c2_6809_idx_direct_off(off,r1);
}

macro clr [@off,@[C2_6809_XYUS]r1]
{
	push8($6f);
	c2_6809_idx_indirect_off(off,r1);
}

macro clr ,@[C2_6809_XYUS]r1
{
	push8($6f);
	c2_6809_idx_direct_off(0,r1);
}

macro clr [,@[C2_6809_XYUS]r1]
{
	push8($6f);
	c2_6809_idx_indirect_off(0,r1);
}

macro clr @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($6f);
	c2_6809_idx_direct_acc(r2,r1);
}

macro clr [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($6f);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro clr ,@[C2_6809_XYUS]r1+
{
	push8($6f);
	push8(%10000000|r1<<5);
}

macro clr ,@[C2_6809_XYUS]r1++
{
	push8($6f);
	push8(%10000001|r1<<5);
}

macro clr [,@[C2_6809_XYUS]r1++]
{
	push8($6f);
	push8(%10010001|r1<<5);
}

macro clr ,-@[C2_6809_XYUS]r1
{
	push8($6f);
	push8(%10000010|r1<<5);
}

macro clr ,--@[C2_6809_XYUS]r1
{
	push8($6f);
	push8(%10000011|r1<<5);
}

macro clr [,--@[C2_6809_XYUS]r1]
{
	push8($6f);
	push8(%10010011|r1<<5);
}

macro clr @off,pc
{
	push8($6f);
	c2_6809_idx_direct_pc(off);
}

macro clr [@off,pc]
{
	push8($6f);
	c2_6809_idx_indirect_pc(off);
}

macro clr @off,pcr
{
	push8($6f);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro clr [@off,pcr]
{
	push8($6f);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro clr [@addr]
{
	push8($6f);
	push8(%10011111);
	push16be(addr);
}

macro clra
{
	push8($4f);
}

macro clrb
{
	push8($5f);
}

macro cmpa #@imm
{
	push8($81);
	push8(imm);
}

macro cmpa <@n
{
	push8($91);
	push8(n);
}

macro cmpa >@n
{
	push8($b1);
	push16be(n);
}

macro cmpa @n
{
	push8($b1);
	push16be(n);
}

macro cmpa @off,@[C2_6809_XYUS]r1
{
	push8($a1);
	c2_6809_idx_direct_off(off,r1);
}

macro cmpa [@off,@[C2_6809_XYUS]r1]
{
	push8($a1);
	c2_6809_idx_indirect_off(off,r1);
}

macro cmpa ,@[C2_6809_XYUS]r1
{
	push8($a1);
	c2_6809_idx_direct_off(0,r1);
}

macro cmpa [,@[C2_6809_XYUS]r1]
{
	push8($a1);
	c2_6809_idx_indirect_off(0,r1);
}

macro cmpa @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($a1);
	c2_6809_idx_direct_acc(r2,r1);
}

macro cmpa [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($a1);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro cmpa ,@[C2_6809_XYUS]r1+
{
	push8($a1);
	push8(%10000000|r1<<5);
}

macro cmpa ,@[C2_6809_XYUS]r1++
{
	push8($a1);
	push8(%10000001|r1<<5);
}

macro cmpa [,@[C2_6809_XYUS]r1++]
{
	push8($a1);
	push8(%10010001|r1<<5);
}

macro cmpa ,-@[C2_6809_XYUS]r1
{
	push8($a1);
	push8(%10000010|r1<<5);
}

macro cmpa ,--@[C2_6809_XYUS]r1
{
	push8($a1);
	push8(%10000011|r1<<5);
}

macro cmpa [,--@[C2_6809_XYUS]r1]
{
	push8($a1);
	push8(%10010011|r1<<5);
}

macro cmpa @off,pc
{
	push8($a1);
	c2_6809_idx_direct_pc(off);
}

macro cmpa [@off,pc]
{
	push8($a1);
	c2_6809_idx_indirect_pc(off);
}

macro cmpa @off,pcr
{
	push8($a1);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro cmpa [@off,pcr]
{
	push8($a1);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro cmpa [@addr]
{
	push8($a1);
	push8(%10011111);
	push16be(addr);
}

macro cmpb #@imm
{
	push8($c1);
	push8(imm);
}

macro cmpb <@n
{
	push8($d1);
	push8(n);
}

macro cmpb >@n
{
	push8($f1);
	push16be(n);
}

macro cmpb @n
{
	push8($f1);
	push16be(n);
}

macro cmpb @off,@[C2_6809_XYUS]r1
{
	push8($e1);
	c2_6809_idx_direct_off(off,r1);
}

macro cmpb [@off,@[C2_6809_XYUS]r1]
{
	push8($e1);
	c2_6809_idx_indirect_off(off,r1);
}

macro cmpb ,@[C2_6809_XYUS]r1
{
	push8($e1);
	c2_6809_idx_direct_off(0,r1);
}

macro cmpb [,@[C2_6809_XYUS]r1]
{
	push8($e1);
	c2_6809_idx_indirect_off(0,r1);
}

macro cmpb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($e1);
	c2_6809_idx_direct_acc(r2,r1);
}

macro cmpb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($e1);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro cmpb ,@[C2_6809_XYUS]r1+
{
	push8($e1);
	push8(%10000000|r1<<5);
}

macro cmpb ,@[C2_6809_XYUS]r1++
{
	push8($e1);
	push8(%10000001|r1<<5);
}

macro cmpb [,@[C2_6809_XYUS]r1++]
{
	push8($e1);
	push8(%10010001|r1<<5);
}

macro cmpb ,-@[C2_6809_XYUS]r1
{
	push8($e1);
	push8(%10000010|r1<<5);
}

macro cmpb ,--@[C2_6809_XYUS]r1
{
	push8($e1);
	push8(%10000011|r1<<5);
}

macro cmpb [,--@[C2_6809_XYUS]r1]
{
	push8($e1);
	push8(%10010011|r1<<5);
}

macro cmpb @off,pc
{
	push8($e1);
	c2_6809_idx_direct_pc(off);
}

macro cmpb [@off,pc]
{
	push8($e1);
	c2_6809_idx_indirect_pc(off);
}

macro cmpb @off,pcr
{
	push8($e1);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro cmpb [@off,pcr]
{
	push8($e1);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro cmpb [@addr]
{
	push8($e1);
	push8(%10011111);
	push16be(addr);
}

macro cmpd #@imm
{
	push16be($1083);
	push16be(imm);
}

macro cmpd <@n
{
	push16be($1093);
	push8(n);
}

macro cmpd >@n
{
	push16be($10b3);
	push16be(n);
}

macro cmpd @n
{
	push16be($10b3);
	push16be(n);
}

macro cmpd @off,@[C2_6809_XYUS]r1
{
	push16be($10a3);
	c2_6809_idx_direct_off(off,r1);
}

macro cmpd [@off,@[C2_6809_XYUS]r1]
{
	push16be($10a3);
	c2_6809_idx_indirect_off(off,r1);
}

macro cmpd ,@[C2_6809_XYUS]r1
{
	push16be($10a3);
	c2_6809_idx_direct_off(0,r1);
}

macro cmpd [,@[C2_6809_XYUS]r1]
{
	push16be($10a3);
	c2_6809_idx_indirect_off(0,r1);
}

macro cmpd @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push16be($10a3);
	c2_6809_idx_direct_acc(r2,r1);
}

macro cmpd [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push16be($10a3);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro cmpd ,@[C2_6809_XYUS]r1+
{
	push16be($10a3);
	push8(%10000000|r1<<5);
}

macro cmpd ,@[C2_6809_XYUS]r1++
{
	push16be($10a3);
	push8(%10000001|r1<<5);
}

macro cmpd [,@[C2_6809_XYUS]r1++]
{
	push16be($10a3);
	push8(%10010001|r1<<5);
}

macro cmpd ,-@[C2_6809_XYUS]r1
{
	push16be($10a3);
	push8(%10000010|r1<<5);
}

macro cmpd ,--@[C2_6809_XYUS]r1
{
	push16be($10a3);
	push8(%10000011|r1<<5);
}

macro cmpd [,--@[C2_6809_XYUS]r1]
{
	push16be($10a3);
	push8(%10010011|r1<<5);
}

macro cmpd @off,pc
{
	push16be($10a3);
	c2_6809_idx_direct_pc(off);
}

macro cmpd [@off,pc]
{
	push16be($10a3);
	c2_6809_idx_indirect_pc(off);
}

macro cmpd @off,pcr
{
	push16be($10a3);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro cmpd [@off,pcr]
{
	push16be($10a3);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro cmpd [@addr]
{
	push16be($10a3);
	push8(%10011111);
	push16be(addr);
}

macro cmps #@imm
{
	push16be($118c);
	push16be(imm);
}

macro cmps <@n
{
	push16be($119c);
	push8(n);
}

macro cmps >@n
{
	push16be($11bc);
	push16be(n);
}

macro cmps @n
{
	push16be($11bc);
	push16be(n);
}

macro cmps @off,@[C2_6809_XYUS]r1
{
	push16be($11ac);
	c2_6809_idx_direct_off(off,r1);
}

macro cmps [@off,@[C2_6809_XYUS]r1]
{
	push16be($11ac);
	c2_6809_idx_indirect_off(off,r1);
}

macro cmps ,@[C2_6809_XYUS]r1
{
	push16be($11ac);
	c2_6809_idx_direct_off(0,r1);
}

macro cmps [,@[C2_6809_XYUS]r1]
{
	push16be($11ac);
	c2_6809_idx_indirect_off(0,r1);
}

macro cmps @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push16be($11ac);
	c2_6809_idx_direct_acc(r2,r1);
}

macro cmps [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push16be($11ac);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro cmps ,@[C2_6809_XYUS]r1+
{
	push16be($11ac);
	push8(%10000000|r1<<5);
}

macro cmps ,@[C2_6809_XYUS]r1++
{
	push16be($11ac);
	push8(%10000001|r1<<5);
}

macro cmps [,@[C2_6809_XYUS]r1++]
{
	push16be($11ac);
	push8(%10010001|r1<<5);
}

macro cmps ,-@[C2_6809_XYUS]r1
{
	push16be($11ac);
	push8(%10000010|r1<<5);
}

macro cmps ,--@[C2_6809_XYUS]r1
{
	push16be($11ac);
	push8(%10000011|r1<<5);
}

macro cmps [,--@[C2_6809_XYUS]r1]
{
	push16be($11ac);
	push8(%10010011|r1<<5);
}

macro cmps @off,pc
{
	push16be($11ac);
	c2_6809_idx_direct_pc(off);
}

macro cmps [@off,pc]
{
	push16be($11ac);
	c2_6809_idx_indirect_pc(off);
}

macro cmps @off,pcr
{
	push16be($11ac);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro cmps [@off,pcr]
{
	push16be($11ac);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro cmps [@addr]
{
	push16be($11ac);
	push8(%10011111);
	push16be(addr);
}

macro cmpu #@imm
{
	push16be($1183);
	push16be(imm);
}

macro cmpu <@n
{
	push16be($1193);
	push8(n);
}

macro cmpu >@n
{
	push16be($11b3);
	push16be(n);
}

macro cmpu @n
{
	push16be($11b3);
	push16be(n);
}

macro cmpu @off,@[C2_6809_XYUS]r1
{
	push16be($11a3);
	c2_6809_idx_direct_off(off,r1);
}

macro cmpu [@off,@[C2_6809_XYUS]r1]
{
	push16be($11a3);
	c2_6809_idx_indirect_off(off,r1);
}

macro cmpu ,@[C2_6809_XYUS]r1
{
	push16be($11a3);
	c2_6809_idx_direct_off(0,r1);
}

macro cmpu [,@[C2_6809_XYUS]r1]
{
	push16be($11a3);
	c2_6809_idx_indirect_off(0,r1);
}

macro cmpu @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push16be($11a3);
	c2_6809_idx_direct_acc(r2,r1);
}

macro cmpu [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push16be($11a3);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro cmpu ,@[C2_6809_XYUS]r1+
{
	push16be($11a3);
	push8(%10000000|r1<<5);
}

macro cmpu ,@[C2_6809_XYUS]r1++
{
	push16be($11a3);
	push8(%10000001|r1<<5);
}

macro cmpu [,@[C2_6809_XYUS]r1++]
{
	push16be($11a3);
	push8(%10010001|r1<<5);
}

macro cmpu ,-@[C2_6809_XYUS]r1
{
	push16be($11a3);
	push8(%10000010|r1<<5);
}

macro cmpu ,--@[C2_6809_XYUS]r1
{
	push16be($11a3);
	push8(%10000011|r1<<5);
}

macro cmpu [,--@[C2_6809_XYUS]r1]
{
	push16be($11a3);
	push8(%10010011|r1<<5);
}

macro cmpu @off,pc
{
	push16be($11a3);
	c2_6809_idx_direct_pc(off);
}

macro cmpu [@off,pc]
{
	push16be($11a3);
	c2_6809_idx_indirect_pc(off);
}

macro cmpu @off,pcr
{
	push16be($11a3);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro cmpu [@off,pcr]
{
	push16be($11a3);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro cmpu [@addr]
{
	push16be($11a3);
	push8(%10011111);
	push16be(addr);
}

macro cmpx #@imm
{
	push8($8c);
	push16be(imm);
}

macro cmpx <@n
{
	push8($9c);
	push8(n);
}

macro cmpx >@n
{
	push8($bc);
	push16be(n);
}

macro cmpx @n
{
	push8($bc);
	push16be(n);
}

macro cmpx @off,@[C2_6809_XYUS]r1
{
	push8($ac);
	c2_6809_idx_direct_off(off,r1);
}

macro cmpx [@off,@[C2_6809_XYUS]r1]
{
	push8($ac);
	c2_6809_idx_indirect_off(off,r1);
}

macro cmpx ,@[C2_6809_XYUS]r1
{
	push8($ac);
	c2_6809_idx_direct_off(0,r1);
}

macro cmpx [,@[C2_6809_XYUS]r1]
{
	push8($ac);
	c2_6809_idx_indirect_off(0,r1);
}

macro cmpx @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($ac);
	c2_6809_idx_direct_acc(r2,r1);
}

macro cmpx [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($ac);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro cmpx ,@[C2_6809_XYUS]r1+
{
	push8($ac);
	push8(%10000000|r1<<5);
}

macro cmpx ,@[C2_6809_XYUS]r1++
{
	push8($ac);
	push8(%10000001|r1<<5);
}

macro cmpx [,@[C2_6809_XYUS]r1++]
{
	push8($ac);
	push8(%10010001|r1<<5);
}

macro cmpx ,-@[C2_6809_XYUS]r1
{
	push8($ac);
	push8(%10000010|r1<<5);
}

macro cmpx ,--@[C2_6809_XYUS]r1
{
	push8($ac);
	push8(%10000011|r1<<5);
}

macro cmpx [,--@[C2_6809_XYUS]r1]
{
	push8($ac);
	push8(%10010011|r1<<5);
}

macro cmpx @off,pc
{
	push8($ac);
	c2_6809_idx_direct_pc(off);
}

macro cmpx [@off,pc]
{
	push8($ac);
	c2_6809_idx_indirect_pc(off);
}

macro cmpx @off,pcr
{
	push8($ac);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro cmpx [@off,pcr]
{
	push8($ac);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro cmpx [@addr]
{
	push8($ac);
	push8(%10011111);
	push16be(addr);
}

macro cmpy #@imm
{
	push16be($108c);
	push16be(imm);
}

macro cmpy <@n
{
	push16be($109c);
	push8(n);
}

macro cmpy >@n
{
	push16be($10bc);
	push16be(n);
}

macro cmpy @n
{
	push16be($10bc);
	push16be(n);
}

macro cmpy @off,@[C2_6809_XYUS]r1
{
	push16be($10ac);
	c2_6809_idx_direct_off(off,r1);
}

macro cmpy [@off,@[C2_6809_XYUS]r1]
{
	push16be($10ac);
	c2_6809_idx_indirect_off(off,r1);
}

macro cmpy ,@[C2_6809_XYUS]r1
{
	push16be($10ac);
	c2_6809_idx_direct_off(0,r1);
}

macro cmpy [,@[C2_6809_XYUS]r1]
{
	push16be($10ac);
	c2_6809_idx_indirect_off(0,r1);
}

macro cmpy @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push16be($10ac);
	c2_6809_idx_direct_acc(r2,r1);
}

macro cmpy [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push16be($10ac);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro cmpy ,@[C2_6809_XYUS]r1+
{
	push16be($10ac);
	push8(%10000000|r1<<5);
}

macro cmpy ,@[C2_6809_XYUS]r1++
{
	push16be($10ac);
	push8(%10000001|r1<<5);
}

macro cmpy [,@[C2_6809_XYUS]r1++]
{
	push16be($10ac);
	push8(%10010001|r1<<5);
}

macro cmpy ,-@[C2_6809_XYUS]r1
{
	push16be($10ac);
	push8(%10000010|r1<<5);
}

macro cmpy ,--@[C2_6809_XYUS]r1
{
	push16be($10ac);
	push8(%10000011|r1<<5);
}

macro cmpy [,--@[C2_6809_XYUS]r1]
{
	push16be($10ac);
	push8(%10010011|r1<<5);
}

macro cmpy @off,pc
{
	push16be($10ac);
	c2_6809_idx_direct_pc(off);
}

macro cmpy [@off,pc]
{
	push16be($10ac);
	c2_6809_idx_indirect_pc(off);
}

macro cmpy @off,pcr
{
	push16be($10ac);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro cmpy [@off,pcr]
{
	push16be($10ac);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro cmpy [@addr]
{
	push16be($10ac);
	push8(%10011111);
	push16be(addr);
}

macro com <@n
{
	push8($03);
	push8(n);
}

macro com >@n
{
	push8($73);
	push16be(n);
}

macro com @n
{
	push8($73);
	push16be(n);
}

macro com @off,@[C2_6809_XYUS]r1
{
	push8($63);
	c2_6809_idx_direct_off(off,r1);
}

macro com [@off,@[C2_6809_XYUS]r1]
{
	push8($63);
	c2_6809_idx_indirect_off(off,r1);
}

macro com ,@[C2_6809_XYUS]r1
{
	push8($63);
	c2_6809_idx_direct_off(0,r1);
}

macro com [,@[C2_6809_XYUS]r1]
{
	push8($63);
	c2_6809_idx_indirect_off(0,r1);
}

macro com @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($63);
	c2_6809_idx_direct_acc(r2,r1);
}

macro com [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($63);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro com ,@[C2_6809_XYUS]r1+
{
	push8($63);
	push8(%10000000|r1<<5);
}

macro com ,@[C2_6809_XYUS]r1++
{
	push8($63);
	push8(%10000001|r1<<5);
}

macro com [,@[C2_6809_XYUS]r1++]
{
	push8($63);
	push8(%10010001|r1<<5);
}

macro com ,-@[C2_6809_XYUS]r1
{
	push8($63);
	push8(%10000010|r1<<5);
}

macro com ,--@[C2_6809_XYUS]r1
{
	push8($63);
	push8(%10000011|r1<<5);
}

macro com [,--@[C2_6809_XYUS]r1]
{
	push8($63);
	push8(%10010011|r1<<5);
}

macro com @off,pc
{
	push8($63);
	c2_6809_idx_direct_pc(off);
}

macro com [@off,pc]
{
	push8($63);
	c2_6809_idx_indirect_pc(off);
}

macro com @off,pcr
{
	push8($63);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro com [@off,pcr]
{
	push8($63);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro com [@addr]
{
	push8($63);
	push8(%10011111);
	push16be(addr);
}

macro coma
{
	push8($43);
}

macro comb
{
	push8($53);
}

macro cwai @[C2_6809_CC]iflag...
{
	push8($3c);
	uint8_t mask=$ff;
	for(size_t r=0;r<iflag.size();r++)
		mask&=~(1<<iflag[r]);
	push8(mask);
}

macro cwai #@mask
{
	push8($3c);
	push8(mask);
}

macro daa
{
	push8($19);
}

macro dec <@n
{
	push8($0a);
	push8(n);
}

macro dec >@n
{
	push8($7a);
	push16be(n);
}

macro dec @n
{
	push8($7a);
	push16be(n);
}

macro dec @off,@[C2_6809_XYUS]r1
{
	push8($6a);
	c2_6809_idx_direct_off(off,r1);
}

macro dec [@off,@[C2_6809_XYUS]r1]
{
	push8($6a);
	c2_6809_idx_indirect_off(off,r1);
}

macro dec ,@[C2_6809_XYUS]r1
{
	push8($6a);
	c2_6809_idx_direct_off(0,r1);
}

macro dec [,@[C2_6809_XYUS]r1]
{
	push8($6a);
	c2_6809_idx_indirect_off(0,r1);
}

macro dec @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($6a);
	c2_6809_idx_direct_acc(r2,r1);
}

macro dec [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($6a);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro dec ,@[C2_6809_XYUS]r1+
{
	push8($6a);
	push8(%10000000|r1<<5);
}

macro dec ,@[C2_6809_XYUS]r1++
{
	push8($6a);
	push8(%10000001|r1<<5);
}

macro dec [,@[C2_6809_XYUS]r1++]
{
	push8($6a);
	push8(%10010001|r1<<5);
}

macro dec ,-@[C2_6809_XYUS]r1
{
	push8($6a);
	push8(%10000010|r1<<5);
}

macro dec ,--@[C2_6809_XYUS]r1
{
	push8($6a);
	push8(%10000011|r1<<5);
}

macro dec [,--@[C2_6809_XYUS]r1]
{
	push8($6a);
	push8(%10010011|r1<<5);
}

macro dec @off,pc
{
	push8($6a);
	c2_6809_idx_direct_pc(off);
}

macro dec [@off,pc]
{
	push8($6a);
	c2_6809_idx_indirect_pc(off);
}

macro dec @off,pcr
{
	push8($6a);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro dec [@off,pcr]
{
	push8($6a);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro dec [@addr]
{
	push8($6a);
	push8(%10011111);
	push16be(addr);
}

macro deca
{
	push8($4a);
}

macro decb
{
	push8($5a);
}

macro eora #@imm
{
	push8($88);
	push8(imm);
}

macro eora <@n
{
	push8($98);
	push8(n);
}

macro eora >@n
{
	push8($b8);
	push16be(n);
}

macro eora @n
{
	push8($b8);
	push16be(n);
}

macro eora @off,@[C2_6809_XYUS]r1
{
	push8($a8);
	c2_6809_idx_direct_off(off,r1);
}

macro eora [@off,@[C2_6809_XYUS]r1]
{
	push8($a8);
	c2_6809_idx_indirect_off(off,r1);
}

macro eora ,@[C2_6809_XYUS]r1
{
	push8($a8);
	c2_6809_idx_direct_off(0,r1);
}

macro eora [,@[C2_6809_XYUS]r1]
{
	push8($a8);
	c2_6809_idx_indirect_off(0,r1);
}

macro eora @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($a8);
	c2_6809_idx_direct_acc(r2,r1);
}

macro eora [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($a8);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro eora ,@[C2_6809_XYUS]r1+
{
	push8($a8);
	push8(%10000000|r1<<5);
}

macro eora ,@[C2_6809_XYUS]r1++
{
	push8($a8);
	push8(%10000001|r1<<5);
}

macro eora [,@[C2_6809_XYUS]r1++]
{
	push8($a8);
	push8(%10010001|r1<<5);
}

macro eora ,-@[C2_6809_XYUS]r1
{
	push8($a8);
	push8(%10000010|r1<<5);
}

macro eora ,--@[C2_6809_XYUS]r1
{
	push8($a8);
	push8(%10000011|r1<<5);
}

macro eora [,--@[C2_6809_XYUS]r1]
{
	push8($a8);
	push8(%10010011|r1<<5);
}

macro eora @off,pc
{
	push8($a8);
	c2_6809_idx_direct_pc(off);
}

macro eora [@off,pc]
{
	push8($a8);
	c2_6809_idx_indirect_pc(off);
}

macro eora @off,pcr
{
	push8($a8);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro eora [@off,pcr]
{
	push8($a8);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro eora [@addr]
{
	push8($a8);
	push8(%10011111);
	push16be(addr);
}

macro eorb #@imm
{
	push8($c8);
	push8(imm);
}

macro eorb <@n
{
	push8($d8);
	push8(n);
}

macro eorb >@n
{
	push8($f8);
	push16be(n);
}

macro eorb @n
{
	push8($f8);
	push16be(n);
}

macro eorb @off,@[C2_6809_XYUS]r1
{
	push8($e8);
	c2_6809_idx_direct_off(off,r1);
}

macro eorb [@off,@[C2_6809_XYUS]r1]
{
	push8($e8);
	c2_6809_idx_indirect_off(off,r1);
}

macro eorb ,@[C2_6809_XYUS]r1
{
	push8($e8);
	c2_6809_idx_direct_off(0,r1);
}

macro eorb [,@[C2_6809_XYUS]r1]
{
	push8($e8);
	c2_6809_idx_indirect_off(0,r1);
}

macro eorb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($e8);
	c2_6809_idx_direct_acc(r2,r1);
}

macro eorb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($e8);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro eorb ,@[C2_6809_XYUS]r1+
{
	push8($e8);
	push8(%10000000|r1<<5);
}

macro eorb ,@[C2_6809_XYUS]r1++
{
	push8($e8);
	push8(%10000001|r1<<5);
}

macro eorb [,@[C2_6809_XYUS]r1++]
{
	push8($e8);
	push8(%10010001|r1<<5);
}

macro eorb ,-@[C2_6809_XYUS]r1
{
	push8($e8);
	push8(%10000010|r1<<5);
}

macro eorb ,--@[C2_6809_XYUS]r1
{
	push8($e8);
	push8(%10000011|r1<<5);
}

macro eorb [,--@[C2_6809_XYUS]r1]
{
	push8($e8);
	push8(%10010011|r1<<5);
}

macro eorb @off,pc
{
	push8($e8);
	c2_6809_idx_direct_pc(off);
}

macro eorb [@off,pc]
{
	push8($e8);
	c2_6809_idx_indirect_pc(off);
}

macro eorb @off,pcr
{
	push8($e8);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro eorb [@off,pcr]
{
	push8($e8);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro eorb [@addr]
{
	push8($e8);
	push8(%10011111);
	push16be(addr);
}

macro exg @[C2_6809_EXG]r1,@[C2_6809_EXG]r2
{
	push8($1e);
	push8(r1<<4|r2);
}

macro inc <@n
{
	push8($0c);
	push8(n);
}

macro inc >@n
{
	push8($7c);
	push16be(n);
}

macro inc @n
{
	push8($7c);
	push16be(n);
}

macro inc @off,@[C2_6809_XYUS]r1
{
	push8($6c);
	c2_6809_idx_direct_off(off,r1);
}

macro inc [@off,@[C2_6809_XYUS]r1]
{
	push8($6c);
	c2_6809_idx_indirect_off(off,r1);
}

macro inc ,@[C2_6809_XYUS]r1
{
	push8($6c);
	c2_6809_idx_direct_off(0,r1);
}

macro inc [,@[C2_6809_XYUS]r1]
{
	push8($6c);
	c2_6809_idx_indirect_off(0,r1);
}

macro inc @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($6c);
	c2_6809_idx_direct_acc(r2,r1);
}

macro inc [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($6c);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro inc ,@[C2_6809_XYUS]r1+
{
	push8($6c);
	push8(%10000000|r1<<5);
}

macro inc ,@[C2_6809_XYUS]r1++
{
	push8($6c);
	push8(%10000001|r1<<5);
}

macro inc [,@[C2_6809_XYUS]r1++]
{
	push8($6c);
	push8(%10010001|r1<<5);
}

macro inc ,-@[C2_6809_XYUS]r1
{
	push8($6c);
	push8(%10000010|r1<<5);
}

macro inc ,--@[C2_6809_XYUS]r1
{
	push8($6c);
	push8(%10000011|r1<<5);
}

macro inc [,--@[C2_6809_XYUS]r1]
{
	push8($6c);
	push8(%10010011|r1<<5);
}

macro inc @off,pc
{
	push8($6c);
	c2_6809_idx_direct_pc(off);
}

macro inc [@off,pc]
{
	push8($6c);
	c2_6809_idx_indirect_pc(off);
}

macro inc @off,pcr
{
	push8($6c);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro inc [@off,pcr]
{
	push8($6c);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro inc [@addr]
{
	push8($6c);
	push8(%10011111);
	push16be(addr);
}

macro inca
{
	push8($4c);
}

macro incb
{
	push8($5c);
}

macro jmp <@n
{
	push8($0e);
	push8(n);
}

macro jmp >@n
{
	push8($7e);
	push16be(n);
}

macro jmp @n
{
	push8($7e);
	push16be(n);
}

macro jmp @off,@[C2_6809_XYUS]r1
{
	push8($6e);
	c2_6809_idx_direct_off(off,r1);
}

macro jmp [@off,@[C2_6809_XYUS]r1]
{
	push8($6e);
	c2_6809_idx_indirect_off(off,r1);
}

macro jmp ,@[C2_6809_XYUS]r1
{
	push8($6e);
	c2_6809_idx_direct_off(0,r1);
}

macro jmp [,@[C2_6809_XYUS]r1]
{
	push8($6e);
	c2_6809_idx_indirect_off(0,r1);
}

macro jmp @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($6e);
	c2_6809_idx_direct_acc(r2,r1);
}

macro jmp [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($6e);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro jmp ,@[C2_6809_XYUS]r1+
{
	push8($6e);
	push8(%10000000|r1<<5);
}

macro jmp ,@[C2_6809_XYUS]r1++
{
	push8($6e);
	push8(%10000001|r1<<5);
}

macro jmp [,@[C2_6809_XYUS]r1++]
{
	push8($6e);
	push8(%10010001|r1<<5);
}

macro jmp ,-@[C2_6809_XYUS]r1
{
	push8($6e);
	push8(%10000010|r1<<5);
}

macro jmp ,--@[C2_6809_XYUS]r1
{
	push8($6e);
	push8(%10000011|r1<<5);
}

macro jmp [,--@[C2_6809_XYUS]r1]
{
	push8($6e);
	push8(%10010011|r1<<5);
}

macro jmp @off,pc
{
	push8($6e);
	c2_6809_idx_direct_pc(off);
}

macro jmp [@off,pc]
{
	push8($6e);
	c2_6809_idx_indirect_pc(off);
}

macro jmp @off,pcr
{
	push8($6e);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro jmp [@off,pcr]
{
	push8($6e);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro jmp [@addr]
{
	push8($6e);
	push8(%10011111);
	push16be(addr);
}

macro jsr <@n
{
	push8($9d);
	push8(n);
}

macro jsr >@n
{
	push8($bd);
	push16be(n);
}

macro jsr @n
{
	push8($bd);
	push16be(n);
}

macro jsr @off,@[C2_6809_XYUS]r1
{
	push8($ad);
	c2_6809_idx_direct_off(off,r1);
}

macro jsr [@off,@[C2_6809_XYUS]r1]
{
	push8($ad);
	c2_6809_idx_indirect_off(off,r1);
}

macro jsr ,@[C2_6809_XYUS]r1
{
	push8($ad);
	c2_6809_idx_direct_off(0,r1);
}

macro jsr [,@[C2_6809_XYUS]r1]
{
	push8($ad);
	c2_6809_idx_indirect_off(0,r1);
}

macro jsr @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($ad);
	c2_6809_idx_direct_acc(r2,r1);
}

macro jsr [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($ad);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro jsr ,@[C2_6809_XYUS]r1+
{
	push8($ad);
	push8(%10000000|r1<<5);
}

macro jsr ,@[C2_6809_XYUS]r1++
{
	push8($ad);
	push8(%10000001|r1<<5);
}

macro jsr [,@[C2_6809_XYUS]r1++]
{
	push8($ad);
	push8(%10010001|r1<<5);
}

macro jsr ,-@[C2_6809_XYUS]r1
{
	push8($ad);
	push8(%10000010|r1<<5);
}

macro jsr ,--@[C2_6809_XYUS]r1
{
	push8($ad);
	push8(%10000011|r1<<5);
}

macro jsr [,--@[C2_6809_XYUS]r1]
{
	push8($ad);
	push8(%10010011|r1<<5);
}

macro jsr @off,pc
{
	push8($ad);
	c2_6809_idx_direct_pc(off);
}

macro jsr [@off,pc]
{
	push8($ad);
	c2_6809_idx_indirect_pc(off);
}

macro jsr @off,pcr
{
	push8($ad);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro jsr [@off,pcr]
{
	push8($ad);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro jsr [@addr]
{
	push8($ad);
	push8(%10011111);
	push16be(addr);
}

macro lda #@imm
{
	push8($86);
	push8(imm);
}

macro lda <@n
{
	push8($96);
	push8(n);
}

macro lda >@n
{
	push8($b6);
	push16be(n);
}

macro lda @n
{
	push8($b6);
	push16be(n);
}

macro lda @off,@[C2_6809_XYUS]r1
{
	push8($a6);
	c2_6809_idx_direct_off(off,r1);
}

macro lda [@off,@[C2_6809_XYUS]r1]
{
	push8($a6);
	c2_6809_idx_indirect_off(off,r1);
}

macro lda ,@[C2_6809_XYUS]r1
{
	push8($a6);
	c2_6809_idx_direct_off(0,r1);
}

macro lda [,@[C2_6809_XYUS]r1]
{
	push8($a6);
	c2_6809_idx_indirect_off(0,r1);
}

macro lda @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($a6);
	c2_6809_idx_direct_acc(r2,r1);
}

macro lda [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($a6);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro lda ,@[C2_6809_XYUS]r1+
{
	push8($a6);
	push8(%10000000|r1<<5);
}

macro lda ,@[C2_6809_XYUS]r1++
{
	push8($a6);
	push8(%10000001|r1<<5);
}

macro lda [,@[C2_6809_XYUS]r1++]
{
	push8($a6);
	push8(%10010001|r1<<5);
}

macro lda ,-@[C2_6809_XYUS]r1
{
	push8($a6);
	push8(%10000010|r1<<5);
}

macro lda ,--@[C2_6809_XYUS]r1
{
	push8($a6);
	push8(%10000011|r1<<5);
}

macro lda [,--@[C2_6809_XYUS]r1]
{
	push8($a6);
	push8(%10010011|r1<<5);
}

macro lda @off,pc
{
	push8($a6);
	c2_6809_idx_direct_pc(off);
}

macro lda [@off,pc]
{
	push8($a6);
	c2_6809_idx_indirect_pc(off);
}

macro lda @off,pcr
{
	push8($a6);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro lda [@off,pcr]
{
	push8($a6);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro lda [@addr]
{
	push8($a6);
	push8(%10011111);
	push16be(addr);
}

macro ldb #@imm
{
	push8($c6);
	push8(imm);
}

macro ldb <@n
{
	push8($d6);
	push8(n);
}

macro ldb >@n
{
	push8($f6);
	push16be(n);
}

macro ldb @n
{
	push8($f6);
	push16be(n);
}

macro ldb @off,@[C2_6809_XYUS]r1
{
	push8($e6);
	c2_6809_idx_direct_off(off,r1);
}

macro ldb [@off,@[C2_6809_XYUS]r1]
{
	push8($e6);
	c2_6809_idx_indirect_off(off,r1);
}

macro ldb ,@[C2_6809_XYUS]r1
{
	push8($e6);
	c2_6809_idx_direct_off(0,r1);
}

macro ldb [,@[C2_6809_XYUS]r1]
{
	push8($e6);
	c2_6809_idx_indirect_off(0,r1);
}

macro ldb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($e6);
	c2_6809_idx_direct_acc(r2,r1);
}

macro ldb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($e6);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro ldb ,@[C2_6809_XYUS]r1+
{
	push8($e6);
	push8(%10000000|r1<<5);
}

macro ldb ,@[C2_6809_XYUS]r1++
{
	push8($e6);
	push8(%10000001|r1<<5);
}

macro ldb [,@[C2_6809_XYUS]r1++]
{
	push8($e6);
	push8(%10010001|r1<<5);
}

macro ldb ,-@[C2_6809_XYUS]r1
{
	push8($e6);
	push8(%10000010|r1<<5);
}

macro ldb ,--@[C2_6809_XYUS]r1
{
	push8($e6);
	push8(%10000011|r1<<5);
}

macro ldb [,--@[C2_6809_XYUS]r1]
{
	push8($e6);
	push8(%10010011|r1<<5);
}

macro ldb @off,pc
{
	push8($e6);
	c2_6809_idx_direct_pc(off);
}

macro ldb [@off,pc]
{
	push8($e6);
	c2_6809_idx_indirect_pc(off);
}

macro ldb @off,pcr
{
	push8($e6);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro ldb [@off,pcr]
{
	push8($e6);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro ldb [@addr]
{
	push8($e6);
	push8(%10011111);
	push16be(addr);
}

macro ldd #@imm
{
	push8($cc);
	push16be(imm);
}

macro ldd <@n
{
	push8($dc);
	push8(n);
}

macro ldd >@n
{
	push8($fc);
	push16be(n);
}

macro ldd @n
{
	push8($fc);
	push16be(n);
}

macro ldd @off,@[C2_6809_XYUS]r1
{
	push8($ec);
	c2_6809_idx_direct_off(off,r1);
}

macro ldd [@off,@[C2_6809_XYUS]r1]
{
	push8($ec);
	c2_6809_idx_indirect_off(off,r1);
}

macro ldd ,@[C2_6809_XYUS]r1
{
	push8($ec);
	c2_6809_idx_direct_off(0,r1);
}

macro ldd [,@[C2_6809_XYUS]r1]
{
	push8($ec);
	c2_6809_idx_indirect_off(0,r1);
}

macro ldd @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($ec);
	c2_6809_idx_direct_acc(r2,r1);
}

macro ldd [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($ec);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro ldd ,@[C2_6809_XYUS]r1+
{
	push8($ec);
	push8(%10000000|r1<<5);
}

macro ldd ,@[C2_6809_XYUS]r1++
{
	push8($ec);
	push8(%10000001|r1<<5);
}

macro ldd [,@[C2_6809_XYUS]r1++]
{
	push8($ec);
	push8(%10010001|r1<<5);
}

macro ldd ,-@[C2_6809_XYUS]r1
{
	push8($ec);
	push8(%10000010|r1<<5);
}

macro ldd ,--@[C2_6809_XYUS]r1
{
	push8($ec);
	push8(%10000011|r1<<5);
}

macro ldd [,--@[C2_6809_XYUS]r1]
{
	push8($ec);
	push8(%10010011|r1<<5);
}

macro ldd @off,pc
{
	push8($ec);
	c2_6809_idx_direct_pc(off);
}

macro ldd [@off,pc]
{
	push8($ec);
	c2_6809_idx_indirect_pc(off);
}

macro ldd @off,pcr
{
	push8($ec);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro ldd [@off,pcr]
{
	push8($ec);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro ldd [@addr]
{
	push8($ec);
	push8(%10011111);
	push16be(addr);
}

macro lds #@imm
{
	push16be($10ce);
	push16be(imm);
}

macro lds <@n
{
	push16be($10de);
	push8(n);
}

macro lds >@n
{
	push16be($10fe);
	push16be(n);
}

macro lds @n
{
	push16be($10fe);
	push16be(n);
}

macro lds @off,@[C2_6809_XYUS]r1
{
	push16be($10ee);
	c2_6809_idx_direct_off(off,r1);
}

macro lds [@off,@[C2_6809_XYUS]r1]
{
	push16be($10ee);
	c2_6809_idx_indirect_off(off,r1);
}

macro lds ,@[C2_6809_XYUS]r1
{
	push16be($10ee);
	c2_6809_idx_direct_off(0,r1);
}

macro lds [,@[C2_6809_XYUS]r1]
{
	push16be($10ee);
	c2_6809_idx_indirect_off(0,r1);
}

macro lds @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push16be($10ee);
	c2_6809_idx_direct_acc(r2,r1);
}

macro lds [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push16be($10ee);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro lds ,@[C2_6809_XYUS]r1+
{
	push16be($10ee);
	push8(%10000000|r1<<5);
}

macro lds ,@[C2_6809_XYUS]r1++
{
	push16be($10ee);
	push8(%10000001|r1<<5);
}

macro lds [,@[C2_6809_XYUS]r1++]
{
	push16be($10ee);
	push8(%10010001|r1<<5);
}

macro lds ,-@[C2_6809_XYUS]r1
{
	push16be($10ee);
	push8(%10000010|r1<<5);
}

macro lds ,--@[C2_6809_XYUS]r1
{
	push16be($10ee);
	push8(%10000011|r1<<5);
}

macro lds [,--@[C2_6809_XYUS]r1]
{
	push16be($10ee);
	push8(%10010011|r1<<5);
}

macro lds @off,pc
{
	push16be($10ee);
	c2_6809_idx_direct_pc(off);
}

macro lds [@off,pc]
{
	push16be($10ee);
	c2_6809_idx_indirect_pc(off);
}

macro lds @off,pcr
{
	push16be($10ee);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro lds [@off,pcr]
{
	push16be($10ee);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro lds [@addr]
{
	push16be($10ee);
	push8(%10011111);
	push16be(addr);
}

macro ldu #@imm
{
	push8($ce);
	push16be(imm);
}

macro ldu <@n
{
	push8($de);
	push8(n);
}

macro ldu >@n
{
	push8($fe);
	push16be(n);
}

macro ldu @n
{
	push8($fe);
	push16be(n);
}

macro ldu @off,@[C2_6809_XYUS]r1
{
	push8($ee);
	c2_6809_idx_direct_off(off,r1);
}

macro ldu [@off,@[C2_6809_XYUS]r1]
{
	push8($ee);
	c2_6809_idx_indirect_off(off,r1);
}

macro ldu ,@[C2_6809_XYUS]r1
{
	push8($ee);
	c2_6809_idx_direct_off(0,r1);
}

macro ldu [,@[C2_6809_XYUS]r1]
{
	push8($ee);
	c2_6809_idx_indirect_off(0,r1);
}

macro ldu @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($ee);
	c2_6809_idx_direct_acc(r2,r1);
}

macro ldu [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($ee);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro ldu ,@[C2_6809_XYUS]r1+
{
	push8($ee);
	push8(%10000000|r1<<5);
}

macro ldu ,@[C2_6809_XYUS]r1++
{
	push8($ee);
	push8(%10000001|r1<<5);
}

macro ldu [,@[C2_6809_XYUS]r1++]
{
	push8($ee);
	push8(%10010001|r1<<5);
}

macro ldu ,-@[C2_6809_XYUS]r1
{
	push8($ee);
	push8(%10000010|r1<<5);
}

macro ldu ,--@[C2_6809_XYUS]r1
{
	push8($ee);
	push8(%10000011|r1<<5);
}

macro ldu [,--@[C2_6809_XYUS]r1]
{
	push8($ee);
	push8(%10010011|r1<<5);
}

macro ldu @off,pc
{
	push8($ee);
	c2_6809_idx_direct_pc(off);
}

macro ldu [@off,pc]
{
	push8($ee);
	c2_6809_idx_indirect_pc(off);
}

macro ldu @off,pcr
{
	push8($ee);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro ldu [@off,pcr]
{
	push8($ee);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro ldu [@addr]
{
	push8($ee);
	push8(%10011111);
	push16be(addr);
}

macro ldx #@imm
{
	push8($8e);
	push16be(imm);
}

macro ldx <@n
{
	push8($9e);
	push8(n);
}

macro ldx >@n
{
	push8($be);
	push16be(n);
}

macro ldx @n
{
	push8($be);
	push16be(n);
}

macro ldx @off,@[C2_6809_XYUS]r1
{
	push8($ae);
	c2_6809_idx_direct_off(off,r1);
}

macro ldx [@off,@[C2_6809_XYUS]r1]
{
	push8($ae);
	c2_6809_idx_indirect_off(off,r1);
}

macro ldx ,@[C2_6809_XYUS]r1
{
	push8($ae);
	c2_6809_idx_direct_off(0,r1);
}

macro ldx [,@[C2_6809_XYUS]r1]
{
	push8($ae);
	c2_6809_idx_indirect_off(0,r1);
}

macro ldx @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($ae);
	c2_6809_idx_direct_acc(r2,r1);
}

macro ldx [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($ae);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro ldx ,@[C2_6809_XYUS]r1+
{
	push8($ae);
	push8(%10000000|r1<<5);
}

macro ldx ,@[C2_6809_XYUS]r1++
{
	push8($ae);
	push8(%10000001|r1<<5);
}

macro ldx [,@[C2_6809_XYUS]r1++]
{
	push8($ae);
	push8(%10010001|r1<<5);
}

macro ldx ,-@[C2_6809_XYUS]r1
{
	push8($ae);
	push8(%10000010|r1<<5);
}

macro ldx ,--@[C2_6809_XYUS]r1
{
	push8($ae);
	push8(%10000011|r1<<5);
}

macro ldx [,--@[C2_6809_XYUS]r1]
{
	push8($ae);
	push8(%10010011|r1<<5);
}

macro ldx @off,pc
{
	push8($ae);
	c2_6809_idx_direct_pc(off);
}

macro ldx [@off,pc]
{
	push8($ae);
	c2_6809_idx_indirect_pc(off);
}

macro ldx @off,pcr
{
	push8($ae);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro ldx [@off,pcr]
{
	push8($ae);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro ldx [@addr]
{
	push8($ae);
	push8(%10011111);
	push16be(addr);
}

macro ldy #@imm
{
	push16be($108e);
	push16be(imm);
}

macro ldy <@n
{
	push16be($109e);
	push8(n);
}

macro ldy >@n
{
	push16be($10be);
	push16be(n);
}

macro ldy @n
{
	push16be($10be);
	push16be(n);
}

macro ldy @off,@[C2_6809_XYUS]r1
{
	push16be($10ae);
	c2_6809_idx_direct_off(off,r1);
}

macro ldy [@off,@[C2_6809_XYUS]r1]
{
	push16be($10ae);
	c2_6809_idx_indirect_off(off,r1);
}

macro ldy ,@[C2_6809_XYUS]r1
{
	push16be($10ae);
	c2_6809_idx_direct_off(0,r1);
}

macro ldy [,@[C2_6809_XYUS]r1]
{
	push16be($10ae);
	c2_6809_idx_indirect_off(0,r1);
}

macro ldy @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push16be($10ae);
	c2_6809_idx_direct_acc(r2,r1);
}

macro ldy [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push16be($10ae);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro ldy ,@[C2_6809_XYUS]r1+
{
	push16be($10ae);
	push8(%10000000|r1<<5);
}

macro ldy ,@[C2_6809_XYUS]r1++
{
	push16be($10ae);
	push8(%10000001|r1<<5);
}

macro ldy [,@[C2_6809_XYUS]r1++]
{
	push16be($10ae);
	push8(%10010001|r1<<5);
}

macro ldy ,-@[C2_6809_XYUS]r1
{
	push16be($10ae);
	push8(%10000010|r1<<5);
}

macro ldy ,--@[C2_6809_XYUS]r1
{
	push16be($10ae);
	push8(%10000011|r1<<5);
}

macro ldy [,--@[C2_6809_XYUS]r1]
{
	push16be($10ae);
	push8(%10010011|r1<<5);
}

macro ldy @off,pc
{
	push16be($10ae);
	c2_6809_idx_direct_pc(off);
}

macro ldy [@off,pc]
{
	push16be($10ae);
	c2_6809_idx_indirect_pc(off);
}

macro ldy @off,pcr
{
	push16be($10ae);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro ldy [@off,pcr]
{
	push16be($10ae);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro ldy [@addr]
{
	push16be($10ae);
	push8(%10011111);
	push16be(addr);
}

macro leas @off,@[C2_6809_XYUS]r1
{
	push8($32);
	c2_6809_idx_direct_off(off,r1);
}

macro leas [@off,@[C2_6809_XYUS]r1]
{
	push8($32);
	c2_6809_idx_indirect_off(off,r1);
}

macro leas ,@[C2_6809_XYUS]r1
{
	push8($32);
	c2_6809_idx_direct_off(0,r1);
}

macro leas [,@[C2_6809_XYUS]r1]
{
	push8($32);
	c2_6809_idx_indirect_off(0,r1);
}

macro leas @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($32);
	c2_6809_idx_direct_acc(r2,r1);
}

macro leas [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($32);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro leas ,@[C2_6809_XYUS]r1+
{
	push8($32);
	push8(%10000000|r1<<5);
}

macro leas ,@[C2_6809_XYUS]r1++
{
	push8($32);
	push8(%10000001|r1<<5);
}

macro leas [,@[C2_6809_XYUS]r1++]
{
	push8($32);
	push8(%10010001|r1<<5);
}

macro leas ,-@[C2_6809_XYUS]r1
{
	push8($32);
	push8(%10000010|r1<<5);
}

macro leas ,--@[C2_6809_XYUS]r1
{
	push8($32);
	push8(%10000011|r1<<5);
}

macro leas [,--@[C2_6809_XYUS]r1]
{
	push8($32);
	push8(%10010011|r1<<5);
}

macro leas @off,pc
{
	push8($32);
	c2_6809_idx_direct_pc(off);
}

macro leas [@off,pc]
{
	push8($32);
	c2_6809_idx_indirect_pc(off);
}

macro leas @off,pcr
{
	push8($32);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro leas [@off,pcr]
{
	push8($32);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro leas [@addr]
{
	push8($32);
	push8(%10011111);
	push16be(addr);
}

macro leau @off,@[C2_6809_XYUS]r1
{
	push8($33);
	c2_6809_idx_direct_off(off,r1);
}

macro leau [@off,@[C2_6809_XYUS]r1]
{
	push8($33);
	c2_6809_idx_indirect_off(off,r1);
}

macro leau ,@[C2_6809_XYUS]r1
{
	push8($33);
	c2_6809_idx_direct_off(0,r1);
}

macro leau [,@[C2_6809_XYUS]r1]
{
	push8($33);
	c2_6809_idx_indirect_off(0,r1);
}

macro leau @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($33);
	c2_6809_idx_direct_acc(r2,r1);
}

macro leau [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($33);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro leau ,@[C2_6809_XYUS]r1+
{
	push8($33);
	push8(%10000000|r1<<5);
}

macro leau ,@[C2_6809_XYUS]r1++
{
	push8($33);
	push8(%10000001|r1<<5);
}

macro leau [,@[C2_6809_XYUS]r1++]
{
	push8($33);
	push8(%10010001|r1<<5);
}

macro leau ,-@[C2_6809_XYUS]r1
{
	push8($33);
	push8(%10000010|r1<<5);
}

macro leau ,--@[C2_6809_XYUS]r1
{
	push8($33);
	push8(%10000011|r1<<5);
}

macro leau [,--@[C2_6809_XYUS]r1]
{
	push8($33);
	push8(%10010011|r1<<5);
}

macro leau @off,pc
{
	push8($33);
	c2_6809_idx_direct_pc(off);
}

macro leau [@off,pc]
{
	push8($33);
	c2_6809_idx_indirect_pc(off);
}

macro leau @off,pcr
{
	push8($33);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro leau [@off,pcr]
{
	push8($33);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro leau [@addr]
{
	push8($33);
	push8(%10011111);
	push16be(addr);
}

macro leax @off,@[C2_6809_XYUS]r1
{
	push8($30);
	c2_6809_idx_direct_off(off,r1);
}

macro leax [@off,@[C2_6809_XYUS]r1]
{
	push8($30);
	c2_6809_idx_indirect_off(off,r1);
}

macro leax ,@[C2_6809_XYUS]r1
{
	push8($30);
	c2_6809_idx_direct_off(0,r1);
}

macro leax [,@[C2_6809_XYUS]r1]
{
	push8($30);
	c2_6809_idx_indirect_off(0,r1);
}

macro leax @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($30);
	c2_6809_idx_direct_acc(r2,r1);
}

macro leax [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($30);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro leax ,@[C2_6809_XYUS]r1+
{
	push8($30);
	push8(%10000000|r1<<5);
}

macro leax ,@[C2_6809_XYUS]r1++
{
	push8($30);
	push8(%10000001|r1<<5);
}

macro leax [,@[C2_6809_XYUS]r1++]
{
	push8($30);
	push8(%10010001|r1<<5);
}

macro leax ,-@[C2_6809_XYUS]r1
{
	push8($30);
	push8(%10000010|r1<<5);
}

macro leax ,--@[C2_6809_XYUS]r1
{
	push8($30);
	push8(%10000011|r1<<5);
}

macro leax [,--@[C2_6809_XYUS]r1]
{
	push8($30);
	push8(%10010011|r1<<5);
}

macro leax @off,pc
{
	push8($30);
	c2_6809_idx_direct_pc(off);
}

macro leax [@off,pc]
{
	push8($30);
	c2_6809_idx_indirect_pc(off);
}

macro leax @off,pcr
{
	push8($30);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro leax [@off,pcr]
{
	push8($30);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro leax [@addr]
{
	push8($30);
	push8(%10011111);
	push16be(addr);
}

macro leay @off,@[C2_6809_XYUS]r1
{
	push8($31);
	c2_6809_idx_direct_off(off,r1);
}

macro leay [@off,@[C2_6809_XYUS]r1]
{
	push8($31);
	c2_6809_idx_indirect_off(off,r1);
}

macro leay ,@[C2_6809_XYUS]r1
{
	push8($31);
	c2_6809_idx_direct_off(0,r1);
}

macro leay [,@[C2_6809_XYUS]r1]
{
	push8($31);
	c2_6809_idx_indirect_off(0,r1);
}

macro leay @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($31);
	c2_6809_idx_direct_acc(r2,r1);
}

macro leay [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($31);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro leay ,@[C2_6809_XYUS]r1+
{
	push8($31);
	push8(%10000000|r1<<5);
}

macro leay ,@[C2_6809_XYUS]r1++
{
	push8($31);
	push8(%10000001|r1<<5);
}

macro leay [,@[C2_6809_XYUS]r1++]
{
	push8($31);
	push8(%10010001|r1<<5);
}

macro leay ,-@[C2_6809_XYUS]r1
{
	push8($31);
	push8(%10000010|r1<<5);
}

macro leay ,--@[C2_6809_XYUS]r1
{
	push8($31);
	push8(%10000011|r1<<5);
}

macro leay [,--@[C2_6809_XYUS]r1]
{
	push8($31);
	push8(%10010011|r1<<5);
}

macro leay @off,pc
{
	push8($31);
	c2_6809_idx_direct_pc(off);
}

macro leay [@off,pc]
{
	push8($31);
	c2_6809_idx_indirect_pc(off);
}

macro leay @off,pcr
{
	push8($31);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro leay [@off,pcr]
{
	push8($31);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro leay [@addr]
{
	push8($31);
	push8(%10011111);
	push16be(addr);
}

macro lsl,asl <@n
{
	push8($08);
	push8(n);
}

macro lsl,asl >@n
{
	push8($78);
	push16be(n);
}

macro lsl,asl @n
{
	push8($78);
	push16be(n);
}

macro lsl,asl @off,@[C2_6809_XYUS]r1
{
	push8($68);
	c2_6809_idx_direct_off(off,r1);
}

macro lsl,asl [@off,@[C2_6809_XYUS]r1]
{
	push8($68);
	c2_6809_idx_indirect_off(off,r1);
}

macro lsl,asl ,@[C2_6809_XYUS]r1
{
	push8($68);
	c2_6809_idx_direct_off(0,r1);
}

macro lsl,asl [,@[C2_6809_XYUS]r1]
{
	push8($68);
	c2_6809_idx_indirect_off(0,r1);
}

macro lsl,asl @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($68);
	c2_6809_idx_direct_acc(r2,r1);
}

macro lsl,asl [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($68);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro lsl,asl ,@[C2_6809_XYUS]r1+
{
	push8($68);
	push8(%10000000|r1<<5);
}

macro lsl,asl ,@[C2_6809_XYUS]r1++
{
	push8($68);
	push8(%10000001|r1<<5);
}

macro lsl,asl [,@[C2_6809_XYUS]r1++]
{
	push8($68);
	push8(%10010001|r1<<5);
}

macro lsl,asl ,-@[C2_6809_XYUS]r1
{
	push8($68);
	push8(%10000010|r1<<5);
}

macro lsl,asl ,--@[C2_6809_XYUS]r1
{
	push8($68);
	push8(%10000011|r1<<5);
}

macro lsl,asl [,--@[C2_6809_XYUS]r1]
{
	push8($68);
	push8(%10010011|r1<<5);
}

macro lsl,asl @off,pc
{
	push8($68);
	c2_6809_idx_direct_pc(off);
}

macro lsl,asl [@off,pc]
{
	push8($68);
	c2_6809_idx_indirect_pc(off);
}

macro lsl,asl @off,pcr
{
	push8($68);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro lsl,asl [@off,pcr]
{
	push8($68);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro lsl,asl [@addr]
{
	push8($68);
	push8(%10011111);
	push16be(addr);
}

macro lsla,asla
{
	push8($48);
}

macro lslb,aslb
{
	push8($58);
}

macro lsr <@n
{
	push8($04);
	push8(n);
}

macro lsr >@n
{
	push8($74);
	push16be(n);
}

macro lsr @n
{
	push8($74);
	push16be(n);
}

macro lsr @off,@[C2_6809_XYUS]r1
{
	push8($64);
	c2_6809_idx_direct_off(off,r1);
}

macro lsr [@off,@[C2_6809_XYUS]r1]
{
	push8($64);
	c2_6809_idx_indirect_off(off,r1);
}

macro lsr ,@[C2_6809_XYUS]r1
{
	push8($64);
	c2_6809_idx_direct_off(0,r1);
}

macro lsr [,@[C2_6809_XYUS]r1]
{
	push8($64);
	c2_6809_idx_indirect_off(0,r1);
}

macro lsr @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($64);
	c2_6809_idx_direct_acc(r2,r1);
}

macro lsr [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($64);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro lsr ,@[C2_6809_XYUS]r1+
{
	push8($64);
	push8(%10000000|r1<<5);
}

macro lsr ,@[C2_6809_XYUS]r1++
{
	push8($64);
	push8(%10000001|r1<<5);
}

macro lsr [,@[C2_6809_XYUS]r1++]
{
	push8($64);
	push8(%10010001|r1<<5);
}

macro lsr ,-@[C2_6809_XYUS]r1
{
	push8($64);
	push8(%10000010|r1<<5);
}

macro lsr ,--@[C2_6809_XYUS]r1
{
	push8($64);
	push8(%10000011|r1<<5);
}

macro lsr [,--@[C2_6809_XYUS]r1]
{
	push8($64);
	push8(%10010011|r1<<5);
}

macro lsr @off,pc
{
	push8($64);
	c2_6809_idx_direct_pc(off);
}

macro lsr [@off,pc]
{
	push8($64);
	c2_6809_idx_indirect_pc(off);
}

macro lsr @off,pcr
{
	push8($64);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro lsr [@off,pcr]
{
	push8($64);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro lsr [@addr]
{
	push8($64);
	push8(%10011111);
	push16be(addr);
}

macro lsra
{
	push8($44);
}

macro lsrb
{
	push8($54);
}

macro mul
{
	push8($3d);
}

macro neg <@n
{
	push8($00);
	push8(n);
}

macro neg >@n
{
	push8($70);
	push16be(n);
}

macro neg @n
{
	push8($70);
	push16be(n);
}

macro neg @off,@[C2_6809_XYUS]r1
{
	push8($60);
	c2_6809_idx_direct_off(off,r1);
}

macro neg [@off,@[C2_6809_XYUS]r1]
{
	push8($60);
	c2_6809_idx_indirect_off(off,r1);
}

macro neg ,@[C2_6809_XYUS]r1
{
	push8($60);
	c2_6809_idx_direct_off(0,r1);
}

macro neg [,@[C2_6809_XYUS]r1]
{
	push8($60);
	c2_6809_idx_indirect_off(0,r1);
}

macro neg @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($60);
	c2_6809_idx_direct_acc(r2,r1);
}

macro neg [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($60);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro neg ,@[C2_6809_XYUS]r1+
{
	push8($60);
	push8(%10000000|r1<<5);
}

macro neg ,@[C2_6809_XYUS]r1++
{
	push8($60);
	push8(%10000001|r1<<5);
}

macro neg [,@[C2_6809_XYUS]r1++]
{
	push8($60);
	push8(%10010001|r1<<5);
}

macro neg ,-@[C2_6809_XYUS]r1
{
	push8($60);
	push8(%10000010|r1<<5);
}

macro neg ,--@[C2_6809_XYUS]r1
{
	push8($60);
	push8(%10000011|r1<<5);
}

macro neg [,--@[C2_6809_XYUS]r1]
{
	push8($60);
	push8(%10010011|r1<<5);
}

macro neg @off,pc
{
	push8($60);
	c2_6809_idx_direct_pc(off);
}

macro neg [@off,pc]
{
	push8($60);
	c2_6809_idx_indirect_pc(off);
}

macro neg @off,pcr
{
	push8($60);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro neg [@off,pcr]
{
	push8($60);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro neg [@addr]
{
	push8($60);
	push8(%10011111);
	push16be(addr);
}

macro nega
{
	push8($40);
}

macro negb
{
	push8($50);
}

macro nop
{
	push8($12);
}

macro ora #@imm
{
	push8($8a);
	push8(imm);
}

macro ora <@n
{
	push8($9a);
	push8(n);
}

macro ora >@n
{
	push8($ba);
	push16be(n);
}

macro ora @n
{
	push8($ba);
	push16be(n);
}

macro ora @off,@[C2_6809_XYUS]r1
{
	push8($aa);
	c2_6809_idx_direct_off(off,r1);
}

macro ora [@off,@[C2_6809_XYUS]r1]
{
	push8($aa);
	c2_6809_idx_indirect_off(off,r1);
}

macro ora ,@[C2_6809_XYUS]r1
{
	push8($aa);
	c2_6809_idx_direct_off(0,r1);
}

macro ora [,@[C2_6809_XYUS]r1]
{
	push8($aa);
	c2_6809_idx_indirect_off(0,r1);
}

macro ora @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($aa);
	c2_6809_idx_direct_acc(r2,r1);
}

macro ora [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($aa);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro ora ,@[C2_6809_XYUS]r1+
{
	push8($aa);
	push8(%10000000|r1<<5);
}

macro ora ,@[C2_6809_XYUS]r1++
{
	push8($aa);
	push8(%10000001|r1<<5);
}

macro ora [,@[C2_6809_XYUS]r1++]
{
	push8($aa);
	push8(%10010001|r1<<5);
}

macro ora ,-@[C2_6809_XYUS]r1
{
	push8($aa);
	push8(%10000010|r1<<5);
}

macro ora ,--@[C2_6809_XYUS]r1
{
	push8($aa);
	push8(%10000011|r1<<5);
}

macro ora [,--@[C2_6809_XYUS]r1]
{
	push8($aa);
	push8(%10010011|r1<<5);
}

macro ora @off,pc
{
	push8($aa);
	c2_6809_idx_direct_pc(off);
}

macro ora [@off,pc]
{
	push8($aa);
	c2_6809_idx_indirect_pc(off);
}

macro ora @off,pcr
{
	push8($aa);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro ora [@off,pcr]
{
	push8($aa);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro ora [@addr]
{
	push8($aa);
	push8(%10011111);
	push16be(addr);
}

macro orb #@imm
{
	push8($ca);
	push8(imm);
}

macro orb <@n
{
	push8($da);
	push8(n);
}

macro orb >@n
{
	push8($fa);
	push16be(n);
}

macro orb @n
{
	push8($fa);
	push16be(n);
}

macro orb @off,@[C2_6809_XYUS]r1
{
	push8($ea);
	c2_6809_idx_direct_off(off,r1);
}

macro orb [@off,@[C2_6809_XYUS]r1]
{
	push8($ea);
	c2_6809_idx_indirect_off(off,r1);
}

macro orb ,@[C2_6809_XYUS]r1
{
	push8($ea);
	c2_6809_idx_direct_off(0,r1);
}

macro orb [,@[C2_6809_XYUS]r1]
{
	push8($ea);
	c2_6809_idx_indirect_off(0,r1);
}

macro orb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($ea);
	c2_6809_idx_direct_acc(r2,r1);
}

macro orb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($ea);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro orb ,@[C2_6809_XYUS]r1+
{
	push8($ea);
	push8(%10000000|r1<<5);
}

macro orb ,@[C2_6809_XYUS]r1++
{
	push8($ea);
	push8(%10000001|r1<<5);
}

macro orb [,@[C2_6809_XYUS]r1++]
{
	push8($ea);
	push8(%10010001|r1<<5);
}

macro orb ,-@[C2_6809_XYUS]r1
{
	push8($ea);
	push8(%10000010|r1<<5);
}

macro orb ,--@[C2_6809_XYUS]r1
{
	push8($ea);
	push8(%10000011|r1<<5);
}

macro orb [,--@[C2_6809_XYUS]r1]
{
	push8($ea);
	push8(%10010011|r1<<5);
}

macro orb @off,pc
{
	push8($ea);
	c2_6809_idx_direct_pc(off);
}

macro orb [@off,pc]
{
	push8($ea);
	c2_6809_idx_indirect_pc(off);
}

macro orb @off,pcr
{
	push8($ea);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro orb [@off,pcr]
{
	push8($ea);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro orb [@addr]
{
	push8($ea);
	push8(%10011111);
	push16be(addr);
}

macro orcc #@imm
{
	push8($1a);
	push8(imm);
}

macro pshs @[C2_6809_SS]iflag...
{
	push8($34);
	uint8_t mask=0;
	for(size_t r=0;r<iflag.size();r++)
		mask|=1<<iflag[r];
	push8(mask);
}

macro pshs #@mask
{
	push8($34);
	push8(mask);
}

macro pshu @[C2_6809_SU]iflag...
{
	push8($36);
	uint8_t mask = 0;
	for(size_t r=0;r<iflag.size();r++)
		mask|=1<<iflag[r];
	push8(mask);
}

macro pshu #@mask
{
	push8($36);
	push8(mask);
}

macro puls @[C2_6809_SS]iflag...
{
	push8($35);
	uint8_t mask=0;
	for(size_t r=0;r<iflag.size();r++)
		mask|=1<<iflag[r];
	push8(mask);
}

macro puls #@mask
{
	push8($35);
	push8(mask);
}

macro pulu @[C2_6809_SU]iflag...
{
	push8($37);
	uint8_t mask = 0;
	for(size_t r=0;r<iflag.size();r++)
		mask|=1<<iflag[r];
	push8(mask);
}

macro pulu #@mask
{
	push8($37);
	push8(mask);
}

macro reset
{
	push8($3e);
}

macro rol <@n
{
	push8($09);
	push8(n);
}

macro rol >@n
{
	push8($79);
	push16be(n);
}

macro rol @n
{
	push8($79);
	push16be(n);
}

macro rol @off,@[C2_6809_XYUS]r1
{
	push8($69);
	c2_6809_idx_direct_off(off,r1);
}

macro rol [@off,@[C2_6809_XYUS]r1]
{
	push8($69);
	c2_6809_idx_indirect_off(off,r1);
}

macro rol ,@[C2_6809_XYUS]r1
{
	push8($69);
	c2_6809_idx_direct_off(0,r1);
}

macro rol [,@[C2_6809_XYUS]r1]
{
	push8($69);
	c2_6809_idx_indirect_off(0,r1);
}

macro rol @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($69);
	c2_6809_idx_direct_acc(r2,r1);
}

macro rol [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($69);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro rol ,@[C2_6809_XYUS]r1+
{
	push8($69);
	push8(%10000000|r1<<5);
}

macro rol ,@[C2_6809_XYUS]r1++
{
	push8($69);
	push8(%10000001|r1<<5);
}

macro rol [,@[C2_6809_XYUS]r1++]
{
	push8($69);
	push8(%10010001|r1<<5);
}

macro rol ,-@[C2_6809_XYUS]r1
{
	push8($69);
	push8(%10000010|r1<<5);
}

macro rol ,--@[C2_6809_XYUS]r1
{
	push8($69);
	push8(%10000011|r1<<5);
}

macro rol [,--@[C2_6809_XYUS]r1]
{
	push8($69);
	push8(%10010011|r1<<5);
}

macro rol @off,pc
{
	push8($69);
	c2_6809_idx_direct_pc(off);
}

macro rol [@off,pc]
{
	push8($69);
	c2_6809_idx_indirect_pc(off);
}

macro rol @off,pcr
{
	push8($69);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro rol [@off,pcr]
{
	push8($69);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro rol [@addr]
{
	push8($69);
	push8(%10011111);
	push16be(addr);
}

macro rola
{
	push8($49);
}

macro rolb
{
	push8($59);
}

macro ror <@n
{
	push8($06);
	push8(n);
}

macro ror >@n
{
	push8($76);
	push16be(n);
}

macro ror @n
{
	push8($76);
	push16be(n);
}

macro ror @off,@[C2_6809_XYUS]r1
{
	push8($66);
	c2_6809_idx_direct_off(off,r1);
}

macro ror [@off,@[C2_6809_XYUS]r1]
{
	push8($66);
	c2_6809_idx_indirect_off(off,r1);
}

macro ror ,@[C2_6809_XYUS]r1
{
	push8($66);
	c2_6809_idx_direct_off(0,r1);
}

macro ror [,@[C2_6809_XYUS]r1]
{
	push8($66);
	c2_6809_idx_indirect_off(0,r1);
}

macro ror @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($66);
	c2_6809_idx_direct_acc(r2,r1);
}

macro ror [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($66);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro ror ,@[C2_6809_XYUS]r1+
{
	push8($66);
	push8(%10000000|r1<<5);
}

macro ror ,@[C2_6809_XYUS]r1++
{
	push8($66);
	push8(%10000001|r1<<5);
}

macro ror [,@[C2_6809_XYUS]r1++]
{
	push8($66);
	push8(%10010001|r1<<5);
}

macro ror ,-@[C2_6809_XYUS]r1
{
	push8($66);
	push8(%10000010|r1<<5);
}

macro ror ,--@[C2_6809_XYUS]r1
{
	push8($66);
	push8(%10000011|r1<<5);
}

macro ror [,--@[C2_6809_XYUS]r1]
{
	push8($66);
	push8(%10010011|r1<<5);
}

macro ror @off,pc
{
	push8($66);
	c2_6809_idx_direct_pc(off);
}

macro ror [@off,pc]
{
	push8($66);
	c2_6809_idx_indirect_pc(off);
}

macro ror @off,pcr
{
	push8($66);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro ror [@off,pcr]
{
	push8($66);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro ror [@addr]
{
	push8($66);
	push8(%10011111);
	push16be(addr);
}

macro rora
{
	push8($46);
}

macro rorb
{
	push8($56);
}

macro rti
{
	push8($3b);
}

macro rts
{
	push8($39);
}

macro sbca #@imm
{
	push8($82);
	push8(imm);
}

macro sbca <@n
{
	push8($92);
	push8(n);
}

macro sbca >@n
{
	push8($b2);
	push16be(n);
}

macro sbca @n
{
	push8($b2);
	push16be(n);
}

macro sbca @off,@[C2_6809_XYUS]r1
{
	push8($a2);
	c2_6809_idx_direct_off(off,r1);
}

macro sbca [@off,@[C2_6809_XYUS]r1]
{
	push8($a2);
	c2_6809_idx_indirect_off(off,r1);
}

macro sbca ,@[C2_6809_XYUS]r1
{
	push8($a2);
	c2_6809_idx_direct_off(0,r1);
}

macro sbca [,@[C2_6809_XYUS]r1]
{
	push8($a2);
	c2_6809_idx_indirect_off(0,r1);
}

macro sbca @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($a2);
	c2_6809_idx_direct_acc(r2,r1);
}

macro sbca [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($a2);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro sbca ,@[C2_6809_XYUS]r1+
{
	push8($a2);
	push8(%10000000|r1<<5);
}

macro sbca ,@[C2_6809_XYUS]r1++
{
	push8($a2);
	push8(%10000001|r1<<5);
}

macro sbca [,@[C2_6809_XYUS]r1++]
{
	push8($a2);
	push8(%10010001|r1<<5);
}

macro sbca ,-@[C2_6809_XYUS]r1
{
	push8($a2);
	push8(%10000010|r1<<5);
}

macro sbca ,--@[C2_6809_XYUS]r1
{
	push8($a2);
	push8(%10000011|r1<<5);
}

macro sbca [,--@[C2_6809_XYUS]r1]
{
	push8($a2);
	push8(%10010011|r1<<5);
}

macro sbca @off,pc
{
	push8($a2);
	c2_6809_idx_direct_pc(off);
}

macro sbca [@off,pc]
{
	push8($a2);
	c2_6809_idx_indirect_pc(off);
}

macro sbca @off,pcr
{
	push8($a2);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro sbca [@off,pcr]
{
	push8($a2);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro sbca [@addr]
{
	push8($a2);
	push8(%10011111);
	push16be(addr);
}

macro sbcb #@imm
{
	push8($c2);
	push8(imm);
}

macro sbcb <@n
{
	push8($d2);
	push8(n);
}

macro sbcb >@n
{
	push8($f2);
	push16be(n);
}

macro sbcb @n
{
	push8($f2);
	push16be(n);
}

macro sbcb @off,@[C2_6809_XYUS]r1
{
	push8($e2);
	c2_6809_idx_direct_off(off,r1);
}

macro sbcb [@off,@[C2_6809_XYUS]r1]
{
	push8($e2);
	c2_6809_idx_indirect_off(off,r1);
}

macro sbcb ,@[C2_6809_XYUS]r1
{
	push8($e2);
	c2_6809_idx_direct_off(0,r1);
}

macro sbcb [,@[C2_6809_XYUS]r1]
{
	push8($e2);
	c2_6809_idx_indirect_off(0,r1);
}

macro sbcb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($e2);
	c2_6809_idx_direct_acc(r2,r1);
}

macro sbcb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($e2);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro sbcb ,@[C2_6809_XYUS]r1+
{
	push8($e2);
	push8(%10000000|r1<<5);
}

macro sbcb ,@[C2_6809_XYUS]r1++
{
	push8($e2);
	push8(%10000001|r1<<5);
}

macro sbcb [,@[C2_6809_XYUS]r1++]
{
	push8($e2);
	push8(%10010001|r1<<5);
}

macro sbcb ,-@[C2_6809_XYUS]r1
{
	push8($e2);
	push8(%10000010|r1<<5);
}

macro sbcb ,--@[C2_6809_XYUS]r1
{
	push8($e2);
	push8(%10000011|r1<<5);
}

macro sbcb [,--@[C2_6809_XYUS]r1]
{
	push8($e2);
	push8(%10010011|r1<<5);
}

macro sbcb @off,pc
{
	push8($e2);
	c2_6809_idx_direct_pc(off);
}

macro sbcb [@off,pc]
{
	push8($e2);
	c2_6809_idx_indirect_pc(off);
}

macro sbcb @off,pcr
{
	push8($e2);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro sbcb [@off,pcr]
{
	push8($e2);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro sbcb [@addr]
{
	push8($e2);
	push8(%10011111);
	push16be(addr);
}

macro sex
{
	push8($1d);
}

macro sta <@n
{
	push8($97);
	push8(n);
}

macro sta >@n
{
	push8($b7);
	push16be(n);
}

macro sta @n
{
	push8($b7);
	push16be(n);
}

macro sta @off,@[C2_6809_XYUS]r1
{
	push8($a7);
	c2_6809_idx_direct_off(off,r1);
}

macro sta [@off,@[C2_6809_XYUS]r1]
{
	push8($a7);
	c2_6809_idx_indirect_off(off,r1);
}

macro sta ,@[C2_6809_XYUS]r1
{
	push8($a7);
	c2_6809_idx_direct_off(0,r1);
}

macro sta [,@[C2_6809_XYUS]r1]
{
	push8($a7);
	c2_6809_idx_indirect_off(0,r1);
}

macro sta @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($a7);
	c2_6809_idx_direct_acc(r2,r1);
}

macro sta [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($a7);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro sta ,@[C2_6809_XYUS]r1+
{
	push8($a7);
	push8(%10000000|r1<<5);
}

macro sta ,@[C2_6809_XYUS]r1++
{
	push8($a7);
	push8(%10000001|r1<<5);
}

macro sta [,@[C2_6809_XYUS]r1++]
{
	push8($a7);
	push8(%10010001|r1<<5);
}

macro sta ,-@[C2_6809_XYUS]r1
{
	push8($a7);
	push8(%10000010|r1<<5);
}

macro sta ,--@[C2_6809_XYUS]r1
{
	push8($a7);
	push8(%10000011|r1<<5);
}

macro sta [,--@[C2_6809_XYUS]r1]
{
	push8($a7);
	push8(%10010011|r1<<5);
}

macro sta @off,pc
{
	push8($a7);
	c2_6809_idx_direct_pc(off);
}

macro sta [@off,pc]
{
	push8($a7);
	c2_6809_idx_indirect_pc(off);
}

macro sta @off,pcr
{
	push8($a7);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro sta [@off,pcr]
{
	push8($a7);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro sta [@addr]
{
	push8($a7);
	push8(%10011111);
	push16be(addr);
}

macro stb <@n
{
	push8($d7);
	push8(n);
}

macro stb >@n
{
	push8($f7);
	push16be(n);
}

macro stb @n
{
	push8($f7);
	push16be(n);
}

macro stb @off,@[C2_6809_XYUS]r1
{
	push8($e7);
	c2_6809_idx_direct_off(off,r1);
}

macro stb [@off,@[C2_6809_XYUS]r1]
{
	push8($e7);
	c2_6809_idx_indirect_off(off,r1);
}

macro stb ,@[C2_6809_XYUS]r1
{
	push8($e7);
	c2_6809_idx_direct_off(0,r1);
}

macro stb [,@[C2_6809_XYUS]r1]
{
	push8($e7);
	c2_6809_idx_indirect_off(0,r1);
}

macro stb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($e7);
	c2_6809_idx_direct_acc(r2,r1);
}

macro stb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($e7);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro stb ,@[C2_6809_XYUS]r1+
{
	push8($e7);
	push8(%10000000|r1<<5);
}

macro stb ,@[C2_6809_XYUS]r1++
{
	push8($e7);
	push8(%10000001|r1<<5);
}

macro stb [,@[C2_6809_XYUS]r1++]
{
	push8($e7);
	push8(%10010001|r1<<5);
}

macro stb ,-@[C2_6809_XYUS]r1
{
	push8($e7);
	push8(%10000010|r1<<5);
}

macro stb ,--@[C2_6809_XYUS]r1
{
	push8($e7);
	push8(%10000011|r1<<5);
}

macro stb [,--@[C2_6809_XYUS]r1]
{
	push8($e7);
	push8(%10010011|r1<<5);
}

macro stb @off,pc
{
	push8($e7);
	c2_6809_idx_direct_pc(off);
}

macro stb [@off,pc]
{
	push8($e7);
	c2_6809_idx_indirect_pc(off);
}

macro stb @off,pcr
{
	push8($e7);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro stb [@off,pcr]
{
	push8($e7);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro stb [@addr]
{
	push8($e7);
	push8(%10011111);
	push16be(addr);
}

macro std <@n
{
	push8($dd);
	push8(n);
}

macro std >@n
{
	push8($fd);
	push16be(n);
}

macro std @n
{
	push8($fd);
	push16be(n);
}

macro std @off,@[C2_6809_XYUS]r1
{
	push8($ed);
	c2_6809_idx_direct_off(off,r1);
}

macro std [@off,@[C2_6809_XYUS]r1]
{
	push8($ed);
	c2_6809_idx_indirect_off(off,r1);
}

macro std ,@[C2_6809_XYUS]r1
{
	push8($ed);
	c2_6809_idx_direct_off(0,r1);
}

macro std [,@[C2_6809_XYUS]r1]
{
	push8($ed);
	c2_6809_idx_indirect_off(0,r1);
}

macro std @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($ed);
	c2_6809_idx_direct_acc(r2,r1);
}

macro std [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($ed);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro std ,@[C2_6809_XYUS]r1+
{
	push8($ed);
	push8(%10000000|r1<<5);
}

macro std ,@[C2_6809_XYUS]r1++
{
	push8($ed);
	push8(%10000001|r1<<5);
}

macro std [,@[C2_6809_XYUS]r1++]
{
	push8($ed);
	push8(%10010001|r1<<5);
}

macro std ,-@[C2_6809_XYUS]r1
{
	push8($ed);
	push8(%10000010|r1<<5);
}

macro std ,--@[C2_6809_XYUS]r1
{
	push8($ed);
	push8(%10000011|r1<<5);
}

macro std [,--@[C2_6809_XYUS]r1]
{
	push8($ed);
	push8(%10010011|r1<<5);
}

macro std @off,pc
{
	push8($ed);
	c2_6809_idx_direct_pc(off);
}

macro std [@off,pc]
{
	push8($ed);
	c2_6809_idx_indirect_pc(off);
}

macro std @off,pcr
{
	push8($ed);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro std [@off,pcr]
{
	push8($ed);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro std [@addr]
{
	push8($ed);
	push8(%10011111);
	push16be(addr);
}

macro sts <@n
{
	push16be($10df);
	push8(n);
}

macro sts >@n
{
	push16be($10ff);
	push16be(n);
}

macro sts @n
{
	push16be($10ff);
	push16be(n);
}

macro sts @off,@[C2_6809_XYUS]r1
{
	push16be($10ef);
	c2_6809_idx_direct_off(off,r1);
}

macro sts [@off,@[C2_6809_XYUS]r1]
{
	push16be($10ef);
	c2_6809_idx_indirect_off(off,r1);
}

macro sts ,@[C2_6809_XYUS]r1
{
	push16be($10ef);
	c2_6809_idx_direct_off(0,r1);
}

macro sts [,@[C2_6809_XYUS]r1]
{
	push16be($10ef);
	c2_6809_idx_indirect_off(0,r1);
}

macro sts @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push16be($10ef);
	c2_6809_idx_direct_acc(r2,r1);
}

macro sts [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push16be($10ef);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro sts ,@[C2_6809_XYUS]r1+
{
	push16be($10ef);
	push8(%10000000|r1<<5);
}

macro sts ,@[C2_6809_XYUS]r1++
{
	push16be($10ef);
	push8(%10000001|r1<<5);
}

macro sts [,@[C2_6809_XYUS]r1++]
{
	push16be($10ef);
	push8(%10010001|r1<<5);
}

macro sts ,-@[C2_6809_XYUS]r1
{
	push16be($10ef);
	push8(%10000010|r1<<5);
}

macro sts ,--@[C2_6809_XYUS]r1
{
	push16be($10ef);
	push8(%10000011|r1<<5);
}

macro sts [,--@[C2_6809_XYUS]r1]
{
	push16be($10ef);
	push8(%10010011|r1<<5);
}

macro sts @off,pc
{
	push16be($10ef);
	c2_6809_idx_direct_pc(off);
}

macro sts [@off,pc]
{
	push16be($10ef);
	c2_6809_idx_indirect_pc(off);
}

macro sts @off,pcr
{
	push16be($10ef);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro sts [@off,pcr]
{
	push16be($10ef);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro sts [@addr]
{
	push16be($10ef);
	push8(%10011111);
	push16be(addr);
}

macro stu <@n
{
	push8($df);
	push8(n);
}

macro stu >@n
{
	push8($ff);
	push16be(n);
}

macro stu @n
{
	push8($ff);
	push16be(n);
}

macro stu @off,@[C2_6809_XYUS]r1
{
	push8($ef);
	c2_6809_idx_direct_off(off,r1);
}

macro stu [@off,@[C2_6809_XYUS]r1]
{
	push8($ef);
	c2_6809_idx_indirect_off(off,r1);
}

macro stu ,@[C2_6809_XYUS]r1
{
	push8($ef);
	c2_6809_idx_direct_off(0,r1);
}

macro stu [,@[C2_6809_XYUS]r1]
{
	push8($ef);
	c2_6809_idx_indirect_off(0,r1);
}

macro stu @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($ef);
	c2_6809_idx_direct_acc(r2,r1);
}

macro stu [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($ef);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro stu ,@[C2_6809_XYUS]r1+
{
	push8($ef);
	push8(%10000000|r1<<5);
}

macro stu ,@[C2_6809_XYUS]r1++
{
	push8($ef);
	push8(%10000001|r1<<5);
}

macro stu [,@[C2_6809_XYUS]r1++]
{
	push8($ef);
	push8(%10010001|r1<<5);
}

macro stu ,-@[C2_6809_XYUS]r1
{
	push8($ef);
	push8(%10000010|r1<<5);
}

macro stu ,--@[C2_6809_XYUS]r1
{
	push8($ef);
	push8(%10000011|r1<<5);
}

macro stu [,--@[C2_6809_XYUS]r1]
{
	push8($ef);
	push8(%10010011|r1<<5);
}

macro stu @off,pc
{
	push8($ef);
	c2_6809_idx_direct_pc(off);
}

macro stu [@off,pc]
{
	push8($ef);
	c2_6809_idx_indirect_pc(off);
}

macro stu @off,pcr
{
	push8($ef);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro stu [@off,pcr]
{
	push8($ef);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro stu [@addr]
{
	push8($ef);
	push8(%10011111);
	push16be(addr);
}

macro stx <@n
{
	push8($9f);
	push8(n);
}

macro stx >@n
{
	push8($bf);
	push16be(n);
}

macro stx @n
{
	push8($bf);
	push16be(n);
}

macro stx @off,@[C2_6809_XYUS]r1
{
	push8($af);
	c2_6809_idx_direct_off(off,r1);
}

macro stx [@off,@[C2_6809_XYUS]r1]
{
	push8($af);
	c2_6809_idx_indirect_off(off,r1);
}

macro stx ,@[C2_6809_XYUS]r1
{
	push8($af);
	c2_6809_idx_direct_off(0,r1);
}

macro stx [,@[C2_6809_XYUS]r1]
{
	push8($af);
	c2_6809_idx_indirect_off(0,r1);
}

macro stx @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($af);
	c2_6809_idx_direct_acc(r2,r1);
}

macro stx [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($af);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro stx ,@[C2_6809_XYUS]r1+
{
	push8($af);
	push8(%10000000|r1<<5);
}

macro stx ,@[C2_6809_XYUS]r1++
{
	push8($af);
	push8(%10000001|r1<<5);
}

macro stx [,@[C2_6809_XYUS]r1++]
{
	push8($af);
	push8(%10010001|r1<<5);
}

macro stx ,-@[C2_6809_XYUS]r1
{
	push8($af);
	push8(%10000010|r1<<5);
}

macro stx ,--@[C2_6809_XYUS]r1
{
	push8($af);
	push8(%10000011|r1<<5);
}

macro stx [,--@[C2_6809_XYUS]r1]
{
	push8($af);
	push8(%10010011|r1<<5);
}

macro stx @off,pc
{
	push8($af);
	c2_6809_idx_direct_pc(off);
}

macro stx [@off,pc]
{
	push8($af);
	c2_6809_idx_indirect_pc(off);
}

macro stx @off,pcr
{
	push8($af);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro stx [@off,pcr]
{
	push8($af);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro stx [@addr]
{
	push8($af);
	push8(%10011111);
	push16be(addr);
}

macro sty <@n
{
	push16be($109f);
	push8(n);
}

macro sty >@n
{
	push16be($10bf);
	push16be(n);
}

macro sty @n
{
	push16be($10bf);
	push16be(n);
}

macro sty @off,@[C2_6809_XYUS]r1
{
	push16be($10af);
	c2_6809_idx_direct_off(off,r1);
}

macro sty [@off,@[C2_6809_XYUS]r1]
{
	push16be($10af);
	c2_6809_idx_indirect_off(off,r1);
}

macro sty ,@[C2_6809_XYUS]r1
{
	push16be($10af);
	c2_6809_idx_direct_off(0,r1);
}

macro sty [,@[C2_6809_XYUS]r1]
{
	push16be($10af);
	c2_6809_idx_indirect_off(0,r1);
}

macro sty @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push16be($10af);
	c2_6809_idx_direct_acc(r2,r1);
}

macro sty [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push16be($10af);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro sty ,@[C2_6809_XYUS]r1+
{
	push16be($10af);
	push8(%10000000|r1<<5);
}

macro sty ,@[C2_6809_XYUS]r1++
{
	push16be($10af);
	push8(%10000001|r1<<5);
}

macro sty [,@[C2_6809_XYUS]r1++]
{
	push16be($10af);
	push8(%10010001|r1<<5);
}

macro sty ,-@[C2_6809_XYUS]r1
{
	push16be($10af);
	push8(%10000010|r1<<5);
}

macro sty ,--@[C2_6809_XYUS]r1
{
	push16be($10af);
	push8(%10000011|r1<<5);
}

macro sty [,--@[C2_6809_XYUS]r1]
{
	push16be($10af);
	push8(%10010011|r1<<5);
}

macro sty @off,pc
{
	push16be($10af);
	c2_6809_idx_direct_pc(off);
}

macro sty [@off,pc]
{
	push16be($10af);
	c2_6809_idx_indirect_pc(off);
}

macro sty @off,pcr
{
	push16be($10af);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro sty [@off,pcr]
{
	push16be($10af);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro sty [@addr]
{
	push16be($10af);
	push8(%10011111);
	push16be(addr);
}

macro suba #@imm
{
	push8($80);
	push8(imm);
}

macro suba <@n
{
	push8($90);
	push8(n);
}

macro suba >@n
{
	push8($b0);
	push16be(n);
}

macro suba @n
{
	push8($b0);
	push16be(n);
}

macro suba @off,@[C2_6809_XYUS]r1
{
	push8($a0);
	c2_6809_idx_direct_off(off,r1);
}

macro suba [@off,@[C2_6809_XYUS]r1]
{
	push8($a0);
	c2_6809_idx_indirect_off(off,r1);
}

macro suba ,@[C2_6809_XYUS]r1
{
	push8($a0);
	c2_6809_idx_direct_off(0,r1);
}

macro suba [,@[C2_6809_XYUS]r1]
{
	push8($a0);
	c2_6809_idx_indirect_off(0,r1);
}

macro suba @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($a0);
	c2_6809_idx_direct_acc(r2,r1);
}

macro suba [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($a0);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro suba ,@[C2_6809_XYUS]r1+
{
	push8($a0);
	push8(%10000000|r1<<5);
}

macro suba ,@[C2_6809_XYUS]r1++
{
	push8($a0);
	push8(%10000001|r1<<5);
}

macro suba [,@[C2_6809_XYUS]r1++]
{
	push8($a0);
	push8(%10010001|r1<<5);
}

macro suba ,-@[C2_6809_XYUS]r1
{
	push8($a0);
	push8(%10000010|r1<<5);
}

macro suba ,--@[C2_6809_XYUS]r1
{
	push8($a0);
	push8(%10000011|r1<<5);
}

macro suba [,--@[C2_6809_XYUS]r1]
{
	push8($a0);
	push8(%10010011|r1<<5);
}

macro suba @off,pc
{
	push8($a0);
	c2_6809_idx_direct_pc(off);
}

macro suba [@off,pc]
{
	push8($a0);
	c2_6809_idx_indirect_pc(off);
}

macro suba @off,pcr
{
	push8($a0);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro suba [@off,pcr]
{
	push8($a0);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro suba [@addr]
{
	push8($a0);
	push8(%10011111);
	push16be(addr);
}

macro subb #@imm
{
	push8($c0);
	push8(imm);
}

macro subb <@n
{
	push8($d0);
	push8(n);
}

macro subb >@n
{
	push8($f0);
	push16be(n);
}

macro subb @n
{
	push8($f0);
	push16be(n);
}

macro subb @off,@[C2_6809_XYUS]r1
{
	push8($e0);
	c2_6809_idx_direct_off(off,r1);
}

macro subb [@off,@[C2_6809_XYUS]r1]
{
	push8($e0);
	c2_6809_idx_indirect_off(off,r1);
}

macro subb ,@[C2_6809_XYUS]r1
{
	push8($e0);
	c2_6809_idx_direct_off(0,r1);
}

macro subb [,@[C2_6809_XYUS]r1]
{
	push8($e0);
	c2_6809_idx_indirect_off(0,r1);
}

macro subb @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($e0);
	c2_6809_idx_direct_acc(r2,r1);
}

macro subb [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($e0);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro subb ,@[C2_6809_XYUS]r1+
{
	push8($e0);
	push8(%10000000|r1<<5);
}

macro subb ,@[C2_6809_XYUS]r1++
{
	push8($e0);
	push8(%10000001|r1<<5);
}

macro subb [,@[C2_6809_XYUS]r1++]
{
	push8($e0);
	push8(%10010001|r1<<5);
}

macro subb ,-@[C2_6809_XYUS]r1
{
	push8($e0);
	push8(%10000010|r1<<5);
}

macro subb ,--@[C2_6809_XYUS]r1
{
	push8($e0);
	push8(%10000011|r1<<5);
}

macro subb [,--@[C2_6809_XYUS]r1]
{
	push8($e0);
	push8(%10010011|r1<<5);
}

macro subb @off,pc
{
	push8($e0);
	c2_6809_idx_direct_pc(off);
}

macro subb [@off,pc]
{
	push8($e0);
	c2_6809_idx_indirect_pc(off);
}

macro subb @off,pcr
{
	push8($e0);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro subb [@off,pcr]
{
	push8($e0);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro subb [@addr]
{
	push8($e0);
	push8(%10011111);
	push16be(addr);
}

macro subd #@imm
{
	push8($83);
	push16be(imm);
}

macro subd <@n
{
	push8($93);
	push8(n);
}

macro subd >@n
{
	push8($b3);
	push16be(n);
}

macro subd @n
{
	push8($b3);
	push16be(n);
}

macro subd @off,@[C2_6809_XYUS]r1
{
	push8($a3);
	c2_6809_idx_direct_off(off,r1);
}

macro subd [@off,@[C2_6809_XYUS]r1]
{
	push8($a3);
	c2_6809_idx_indirect_off(off,r1);
}

macro subd ,@[C2_6809_XYUS]r1
{
	push8($a3);
	c2_6809_idx_direct_off(0,r1);
}

macro subd [,@[C2_6809_XYUS]r1]
{
	push8($a3);
	c2_6809_idx_indirect_off(0,r1);
}

macro subd @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($a3);
	c2_6809_idx_direct_acc(r2,r1);
}

macro subd [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($a3);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro subd ,@[C2_6809_XYUS]r1+
{
	push8($a3);
	push8(%10000000|r1<<5);
}

macro subd ,@[C2_6809_XYUS]r1++
{
	push8($a3);
	push8(%10000001|r1<<5);
}

macro subd [,@[C2_6809_XYUS]r1++]
{
	push8($a3);
	push8(%10010001|r1<<5);
}

macro subd ,-@[C2_6809_XYUS]r1
{
	push8($a3);
	push8(%10000010|r1<<5);
}

macro subd ,--@[C2_6809_XYUS]r1
{
	push8($a3);
	push8(%10000011|r1<<5);
}

macro subd [,--@[C2_6809_XYUS]r1]
{
	push8($a3);
	push8(%10010011|r1<<5);
}

macro subd @off,pc
{
	push8($a3);
	c2_6809_idx_direct_pc(off);
}

macro subd [@off,pc]
{
	push8($a3);
	c2_6809_idx_indirect_pc(off);
}

macro subd @off,pcr
{
	push8($a3);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro subd [@off,pcr]
{
	push8($a3);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro subd [@addr]
{
	push8($a3);
	push8(%10011111);
	push16be(addr);
}

macro swi
{
	push8($3f);
}

macro swi2
{
	push16be($103f);
}

macro swi3
{
	push16be($113f);
}

macro sync
{
	push8($13);
}

macro tfr @[C2_6809_EXG]r1,@[C2_6809_EXG]r2
{
	push8($1f);
	push8(r1<<4|r2);
}

macro tst <@n
{
	push8($0d);
	push8(n);
}

macro tst >@n
{
	push8($7d);
	push16be(n);
}

macro tst @n
{
	push8($7d);
	push16be(n);
}

macro tst @off,@[C2_6809_XYUS]r1
{
	push8($6d);
	c2_6809_idx_direct_off(off,r1);
}

macro tst [@off,@[C2_6809_XYUS]r1]
{
	push8($6d);
	c2_6809_idx_indirect_off(off,r1);
}

macro tst ,@[C2_6809_XYUS]r1
{
	push8($6d);
	c2_6809_idx_direct_off(0,r1);
}

macro tst [,@[C2_6809_XYUS]r1]
{
	push8($6d);
	c2_6809_idx_indirect_off(0,r1);
}

macro tst @[C2_6809_ABD]r2,@[C2_6809_XYUS]r1
{
	push8($6d);
	c2_6809_idx_direct_acc(r2,r1);
}

macro tst [@[C2_6809_ABD]r2,@[C2_6809_XYUS]r1]
{
	push8($6d);
	c2_6809_idx_indirect_acc(r2,r1);
}

macro tst ,@[C2_6809_XYUS]r1+
{
	push8($6d);
	push8(%10000000|r1<<5);
}

macro tst ,@[C2_6809_XYUS]r1++
{
	push8($6d);
	push8(%10000001|r1<<5);
}

macro tst [,@[C2_6809_XYUS]r1++]
{
	push8($6d);
	push8(%10010001|r1<<5);
}

macro tst ,-@[C2_6809_XYUS]r1
{
	push8($6d);
	push8(%10000010|r1<<5);
}

macro tst ,--@[C2_6809_XYUS]r1
{
	push8($6d);
	push8(%10000011|r1<<5);
}

macro tst [,--@[C2_6809_XYUS]r1]
{
	push8($6d);
	push8(%10010011|r1<<5);
}

macro tst @off,pc
{
	push8($6d);
	c2_6809_idx_direct_pc(off);
}

macro tst [@off,pc]
{
	push8($6d);
	c2_6809_idx_indirect_pc(off);
}

macro tst @off,pcr
{
	push8($6d);
	static bool ol=false;
	ol=c2_6809_idx_direct_pc(off-(@+2+1*ol));
}

macro tst [@off,pcr]
{
	push8($6d);
	static bool ol=false;
	ol=c2_6809_idx_indirect_pc(off-(@+2+1*ol));
}

macro tst [@addr]
{
	push8($6d);
	push8(%10011111);
	push16be(addr);
}

macro tsta
{
	push8($4d);
}

macro tstb
{
	push8($5d);
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

macro align @n
{
    @ = ((@+(n-1))/n)*n
}
