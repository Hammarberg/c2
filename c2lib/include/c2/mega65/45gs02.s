/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/mos/4510.s"

#define C2_45GS02

macro adc [@n],z
{
	push16le($72ea);
	push8(n);
}

macro adcq @n
{
	if(n.bits()<=8){
		push24le($654242);
		push8(n);
	}else{
		push24le($6d4242);
		push16le(n);
	}
}

macro adcq (@n)
{
	push24le($724242);
	push8(n);
}

macro adcq [@n]
{
	push32le($72ea4242);
	push8(n);
}

macro and [@n],z
{
	push16le($32ea);
	push8(n);
}

macro andq @n
{
	if(n.bits()<=8){
		push24le($254242);
		push8(n);
	}else{
		push24le($2d4242);
		push16le(n);
	}
}

macro andq (@n)
{
	push24le($324242);
	push8(n);
}

macro andq [@n]
{
	push32le($32ea4242);
	push8(n);
}

macro aslq
{
	push24le($0a4242);
}

macro aslq @n
{
	if(n.bits()<=8){
		push24le($064242);
		push8(n);
	}else{
		push24le($0e4242);
		push16le(n);
	}
}

macro aslq @n,x
{
	if(n.bits()<=8){
		push24le($164242);
		push8(n);
	}else{
		push24le($1e4242);
		push16le(n);
	}
}

macro asrq
{
	push24le($434242);
}

macro asrq @n
{
	push24le($444242);
	push8(n);
}

macro asrq @n,x
{
	push24le($544242);
	push8(n);
}

macro bitq @n
{
	if(n.bits()<=8){
		push24le($244242);
		push8(n);
	}else{
		push24le($2c4242);
		push16le(n);
	}
}

macro cmp [@n],z
{
	push16le($d2ea);
	push8(n);
}

macro cmpq @n
{
	if(n.bits()<=8){
		push24le($c54242);
		push8(n);
	}else{
		push24le($cd4242);
		push16le(n);
	}
}

macro cmpq (@n)
{
	push24le($d24242);
	push8(n);
}

macro cmpq [@n]
{
	push32le($d2ea4242);
	push8(n);
}

macro deq
{
	push24le($3a4242);
}

macro deq @n
{
	if(n.bits()<=8){
		push24le($c64242);
		push8(n);
	}else{
		push24le($ce4242);
		push16le(n);
	}
}

macro deq @n,x
{
	if(n.bits()<=8){
		push24le($d64242);
		push8(n);
	}else{
		push24le($de4242);
		push16le(n);
	}
}

macro eor [@n],z
{
	push16le($52ea);
	push8(n);
}

macro eorq @n
{
	if(n.bits()<=8){
		push24le($454242);
		push8(n);
	}else{
		push24le($4d4242);
		push16le(n);
	}
}

macro eorq (@n)
{
	push24le($524242);
	push8(n);
}

macro eorq [@n]
{
	push32le($52ea4242);
	push8(n);
}

macro inq
{
	push24le($1a4242);
}

macro inq @n
{
	if(n.bits()<=8){
		push24le($e64242);
		push8(n);
	}else{
		push24le($ee4242);
		push16le(n);
	}
}

macro inq @n,x
{
	if(n.bits()<=8){
		push24le($f64242);
		push8(n);
	}else{
		push24le($fe4242);
		push16le(n);
	}
}

macro lda [@n],z
{
	push16le($b2ea);
	push8(n);
}

macro ldq @n
{
	if(n.bits()<=8){
		push24le($a54242);
		push8(n);
	}else{
		push24le($ad4242);
		push16le(n);
	}
}

macro ldq (@n),z
{
	push24le($b24242);
	push8(n);
}

macro ldq [@n],z
{
	push32le($b2ea4242);
	push8(n);
}

macro lsrq
{
	push24le($4a4242);
}

macro lsrq @n
{
	if(n.bits()<=8){
		push24le($464242);
		push8(n);
	}else{
		push24le($4e4242);
		push16le(n);
	}
}

macro lsrq @n,x
{
	if(n.bits()<=8){
		push24le($564242);
		push8(n);
	}else{
		push24le($5e4242);
		push16le(n);
	}
}

macro ora [@n],z
{
	push16le($12ea);
	push8(n);
}

macro orq @n
{
	if(n.bits()<=8){
		push24le($054242);
		push8(n);
	}else{
		push24le($0d4242);
		push16le(n);
	}
}

macro orq (@n)
{
	push24le($124242);
	push8(n);
}

macro orq [@n]
{
	push32le($12ea4242);
	push8(n);
}

macro resq @n,x
{
	if(n.bits()<=8){
		push24le($154242);
		push8(n);
	}else{
		push24le($1d4242);
		push16le(n);
	}
}

macro resq @n,y
{
	push24le($194242);
	push16le(n);
}

macro resq (@n),y
{
	push24le($114242);
	push8(n);
}

macro resq (@n,x)
{
	push24le($014242);
	push8(n);
}

macro resq2 @n,x
{
	if(n.bits()<=8){
		push24le($344242);
		push8(n);
	}else{
		push24le($3c4242);
		push16le(n);
	}
}

macro resq2 @n,y
{
	push24le($394242);
	push16le(n);
}

macro resq2 (@n),y
{
	push24le($314242);
	push8(n);
}

macro resq2 (@n,x)
{
	push24le($214242);
	push8(n);
}

macro resq3 @n,x
{
	if(n.bits()<=8){
		push24le($354242);
		push8(n);
	}else{
		push24le($3d4242);
		push16le(n);
	}
}

macro resq3 @n,y
{
	push24le($594242);
	push16le(n);
}

macro resq3 (@n),y
{
	push24le($514242);
	push8(n);
}

macro resq3 (@n,x)
{
	push24le($414242);
	push8(n);
}

macro resq4 @n,x
{
	if(n.bits()<=8){
		push24le($554242);
		push8(n);
	}else{
		push24le($5d4242);
		push16le(n);
	}
}

macro resq4 @n,y
{
	push24le($794242);
	push16le(n);
}

macro resq4 (@n),y
{
	push24le($714242);
	push8(n);
}

macro resq4 (@n,x)
{
	push24le($614242);
	push8(n);
}

macro resq5 @n,x
{
	if(n.bits()<=8){
		push24le($754242);
		push8(n);
	}else{
		push24le($7d4242);
		push16le(n);
	}
}

macro rolq
{
	push24le($2a4242);
}

macro rolq @n
{
	if(n.bits()<=8){
		push24le($264242);
		push8(n);
	}else{
		push24le($2e4242);
		push16le(n);
	}
}

macro rolq @n,x
{
	if(n.bits()<=8){
		push24le($364242);
		push8(n);
	}else{
		push24le($3e4242);
		push16le(n);
	}
}

macro rorq
{
	push24le($6a4242);
}

macro rorq @n
{
	if(n.bits()<=8){
		push24le($664242);
		push8(n);
	}else{
		push24le($6e4242);
		push16le(n);
	}
}

macro rorq @n,x
{
	if(n.bits()<=8){
		push24le($764242);
		push8(n);
	}else{
		push24le($7e4242);
		push16le(n);
	}
}

macro rsvq @n,x
{
	if(n.bits()<=8){
		push24le($954242);
		push8(n);
	}else{
		push24le($9d4242);
		push16le(n);
	}
}

macro rsvq @n,y
{
	push24le($994242);
	push16le(n);
}

macro rsvq (@n),y
{
	push24le($914242);
	push8(n);
}

macro rsvq (@n,sp),y
{
	push24le($824242);
	push8(n);
}

macro rsvq (@n,x)
{
	push24le($814242);
	push8(n);
}

macro rsvq2 @n,x
{
	if(n.bits()<=8){
		push24le($d54242);
		push8(n);
	}else{
		push24le($dd4242);
		push16le(n);
	}
}

macro rsvq2 @n,y
{
	push24le($d94242);
	push16le(n);
}

macro rsvq2 (@n),y
{
	push24le($d14242);
	push8(n);
}

macro rsvq2 (@n,x)
{
	push24le($a14242);
	push8(n);
}

macro rsvq3 @n,x
{
	if(n.bits()<=8){
		push24le($f54242);
		push8(n);
	}else{
		push24le($fd4242);
		push16le(n);
	}
}

macro rsvq3 @n,y
{
	push24le($f94242);
	push16le(n);
}

macro rsvq3 (@n),y
{
	push24le($f14242);
	push8(n);
}

macro rsvq3 (@n,x)
{
	push24le($c14242);
	push8(n);
}

macro rsvq4 (@n,x)
{
	push24le($e14242);
	push8(n);
}

macro sbc [@n],z
{
	push16le($f2ea);
	push8(n);
}

macro sbcq @n
{
	if(n.bits()<=8){
		push24le($e54242);
		push8(n);
	}else{
		push24le($ed4242);
		push16le(n);
	}
}

macro sbcq (@n)
{
	push24le($f24242);
	push8(n);
}

macro sbcq [@n]
{
	push32le($f2ea4242);
	push8(n);
}

macro sta [@n],z
{
	push16le($92ea);
	push8(n);
}

macro stq @n
{
	if(n.bits()<=8){
		push24le($854242);
		push8(n);
	}else{
		push24le($8d4242);
		push16le(n);
	}
}

macro stq (@n)
{
	push24le($924242);
	push8(n);
}

macro stq [@n]
{
	push32le($92ea4242);
	push8(n);
}

macro dword @data
{
    push32le(data);
}

macro dword @data...
{
    for(size_t r=0;r<data.size();r++)
        push32le(data[r]);
}
