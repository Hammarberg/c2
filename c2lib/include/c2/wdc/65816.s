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

#define C2_65816

/*
	Globals for 65816 m and x flags
*/

global c2_65816_m = 1
global c2_65816_x = 1

#define _m16    c2_65816_m = 0;
#define _m8     c2_65816_m = 1;
#define _a16    _m16
#define _a8     _m8
#define _x16    c2_65816_x = 0;
#define _x8     c2_65816_x = 1;
#define _i16    _x16
#define _i8     _x8

macro _longa @[on,off]i
{
	c2_65816_m = i;
}

macro _longi @[on,off]i
{
	c2_65816_x = i;
}

macro reg @[x8,x16,i8,i16,m8,m16,a8,a16]mode...
{
	cint seprep = 0, v[2] = {0,0};
	for(size_t i=0; i<mode.size(); i++)
	{
		cint ord = mode[i];
		cint sr = (ord & 1);
		seprep |= 1 << sr;
		v[sr] |= $10 << (ord >> 2);
	}

	if(seprep & 1)
	{
		sep #v[0]
	}

	if(seprep & 2)
	{
		rep #v[1]
	}
}

macro cpu @[emu,nat]mode
{
	if(!mode)
		sec
	else
		clc

	xce
}

macro adc #@n
{
	push8($69);
	if(c2_65816_m)push8(n);
	else push16le(n);
}

macro adc @n
{
	if(n.bits()<=8){
		push8($65);
		push8(n);
	}if(n.bits()<=16){
		push8($6d);
		push16le(n);
	}else{
		push8($6f);
		push24le(n);
	}
}

macro adc @n,s
{
	push8($63);
	push8(n);
}

macro adc @n,x
{
	if(n.bits()<=8){
		push8($75);
		push8(n);
	}if(n.bits()<=16){
		push8($7d);
		push16le(n);
	}else{
		push8($7f);
		push24le(n);
	}
}

macro adc @n,y
{
	push8($79);
	push16le(n);
}

macro adc (@n)
{
	push8($72);
	push8(n);
}

macro adc (@n),y
{
	push8($71);
	push8(n);
}

macro adc (@n,s),y
{
	push8($73);
	push8(n);
}

macro adc (@n,x)
{
	push8($61);
	push8(n);
}

macro adc [@n]
{
	push8($67);
	push8(n);
}

macro adc [@n],y
{
	push8($77);
	push8(n);
}

macro and #@n
{
	push8($29);
	if(c2_65816_m)push8(n);
	else push16le(n);
}

macro and @n
{
	if(n.bits()<=8){
		push8($25);
		push8(n);
	}if(n.bits()<=16){
		push8($2d);
		push16le(n);
	}else{
		push8($2f);
		push24le(n);
	}
}

macro and @n,s
{
	push8($23);
	push8(n);
}

macro and @n,x
{
	if(n.bits()<=8){
		push8($35);
		push8(n);
	}if(n.bits()<=16){
		push8($3d);
		push16le(n);
	}else{
		push8($3f);
		push24le(n);
	}
}

macro and @n,y
{
	push8($39);
	push16le(n);
}

macro and (@n)
{
	push8($32);
	push8(n);
}

macro and (@n),y
{
	push8($31);
	push8(n);
}

macro and (@n,s),y
{
	push8($33);
	push8(n);
}

macro and (@n,x)
{
	push8($21);
	push8(n);
}

macro and [@n]
{
	push8($27);
	push8(n);
}

macro and [@n],y
{
	push8($37);
	push8(n);
}

macro asl
{
	push8($0a);
}

macro asl @n
{
	if(n.bits()<=8){
		push8($06);
		push8(n);
	}else{
		push8($0e);
		push16le(n);
	}
}

macro asl @n,x
{
	if(n.bits()<=8){
		push8($16);
		push8(n);
	}else{
		push8($1e);
		push16le(n);
	}
}

macro asl a
{
	push8($0a);
}

macro bcc @n
{
	push8($90);
	push8(c2sr<8>(n-@-1));
}

macro bcs @n
{
	push8($b0);
	push8(c2sr<8>(n-@-1));
}

macro beq @n
{
	push8($f0);
	push8(c2sr<8>(n-@-1));
}

macro bit #@n
{
	push8($89);
	if(c2_65816_m)push8(n);
	else push16le(n);
}

macro bit @n
{
	if(n.bits()<=8){
		push8($24);
		push8(n);
	}else{
		push8($2c);
		push16le(n);
	}
}

macro bit @n,x
{
	if(n.bits()<=8){
		push8($34);
		push8(n);
	}else{
		push8($3c);
		push16le(n);
	}
}

macro bmi @n
{
	push8($30);
	push8(c2sr<8>(n-@-1));
}

macro bne @n
{
	push8($d0);
	push8(c2sr<8>(n-@-1));
}

macro bpl @n
{
	push8($10);
	push8(c2sr<8>(n-@-1));
}

macro bra @n
{
	c2static lb;
	if(c2st<8>(n-(@+2+lb))){
		push8($80);
		push8(c2sr<8>(n-@-1));
		lb = 0;
	}else{
		push8($82);
		push16le(c2sr<16>(n-@-2));
		lb = 1;
	}
}

macro brk
{
	push8($00);
}

macro brl @n
{
	push8($82);
	push16le(c2sr<16>(n-@-2));
}

macro bvc @n
{
	push8($50);
	push8(c2sr<8>(n-@-1));
}

macro bvs @n
{
	push8($70);
	push8(c2sr<8>(n-@-1));
}

macro clc
{
	push8($18);
}

macro cld
{
	push8($d8);
}

macro cli
{
	push8($58);
}

macro clv
{
	push8($b8);
}

macro cmp #@n
{
	push8($c9);
	if(c2_65816_m)push8(n);
	else push16le(n);
}

macro cmp @n
{
	if(n.bits()<=8){
		push8($c5);
		push8(n);
	}if(n.bits()<=16){
		push8($cd);
		push16le(n);
	}else{
		push8($cf);
		push24le(n);
	}
}

macro cmp @n,s
{
	push8($c3);
	push8(n);
}

macro cmp @n,x
{
	if(n.bits()<=8){
		push8($d5);
		push8(n);
	}if(n.bits()<=16){
		push8($dd);
		push16le(n);
	}else{
		push8($df);
		push24le(n);
	}
}

macro cmp @n,y
{
	push8($d9);
	push16le(n);
}

macro cmp (@n)
{
	push8($d2);
	push8(n);
}

macro cmp (@n),y
{
	push8($d1);
	push8(n);
}

macro cmp (@n,s),y
{
	push8($d3);
	push8(n);
}

macro cmp (@n,x)
{
	push8($c1);
	push8(n);
}

macro cmp [@n]
{
	push8($c7);
	push8(n);
}

macro cmp [@n],y
{
	push8($d7);
	push8(n);
}

macro cop #@n
{
	push8($02);
	push8(n);
}

macro cpx #@n
{
	push8($e0);
	if(c2_65816_x)push8(n);
	else push16le(n);
}

macro cpx @n
{
	if(n.bits()<=8){
		push8($e4);
		push8(n);
	}else{
		push8($ec);
		push16le(n);
	}
}

macro cpy #@n
{
	push8($c0);
	if(c2_65816_x)push8(n);
	else push16le(n);
}

macro cpy @n
{
	if(n.bits()<=8){
		push8($c4);
		push8(n);
	}else{
		push8($cc);
		push16le(n);
	}
}

macro dec
{
	push8($3a);
}

macro dec @n
{
	if(n.bits()<=8){
		push8($c6);
		push8(n);
	}else{
		push8($ce);
		push16le(n);
	}
}

macro dec @n,x
{
	if(n.bits()<=8){
		push8($d6);
		push8(n);
	}else{
		push8($de);
		push16le(n);
	}
}

macro dec a
{
	push8($3a);
}

macro dex
{
	push8($ca);
}

macro dey
{
	push8($88);
}

macro eor #@n
{
	push8($49);
	if(c2_65816_m)push8(n);
	else push16le(n);
}

macro eor @n
{
	if(n.bits()<=8){
		push8($45);
		push8(n);
	}if(n.bits()<=16){
		push8($4d);
		push16le(n);
	}else{
		push8($4f);
		push24le(n);
	}
}

macro eor @n,s
{
	push8($43);
	push8(n);
}

macro eor @n,x
{
	if(n.bits()<=8){
		push8($55);
		push8(n);
	}if(n.bits()<=16){
		push8($5d);
		push16le(n);
	}else{
		push8($5f);
		push24le(n);
	}
}

macro eor @n,y
{
	push8($59);
	push16le(n);
}

macro eor (@n)
{
	push8($52);
	push8(n);
}

macro eor (@n),y
{
	push8($51);
	push8(n);
}

macro eor (@n,s),y
{
	push8($53);
	push8(n);
}

macro eor (@n,x)
{
	push8($41);
	push8(n);
}

macro eor [@n]
{
	push8($47);
	push8(n);
}

macro eor [@n],y
{
	push8($57);
	push8(n);
}

macro inc
{
	push8($1a);
}

macro inc @n
{
	if(n.bits()<=8){
		push8($e6);
		push8(n);
	}else{
		push8($ee);
		push16le(n);
	}
}

macro inc @n,x
{
	if(n.bits()<=8){
		push8($f6);
		push8(n);
	}else{
		push8($fe);
		push16le(n);
	}
}

macro inc a
{
	push8($1a);
}

macro inx
{
	push8($e8);
}

macro iny
{
	push8($c8);
}

macro jmp @n
{
	if(n.bits()<=16){
		push8($4c);
		push16le(n);
	}else{
		push8($5c);
		push24le(n);
	}
}

macro jmp (@n)
{
	push8($6c);
	push16le(n);
}

macro jmp (@n,x)
{
	push8($7c);
	push16le(n);
}

macro jmp [@n]
{
	push8($dc);
	push16le(n);
}

macro jsr @n
{
	if(n.bits()<=16){
		push8($20);
		push16le(n);
	}else{
		push8($22);
		push24le(n);
	}
}

macro jsr (@n,x)
{
	push8($fc);
	push16le(n);
}

macro lda #@n
{
	push8($a9);
	if(c2_65816_m)push8(n);
	else push16le(n);
}

macro lda @n
{
	if(n.bits()<=8){
		push8($a5);
		push8(n);
	}if(n.bits()<=16){
		push8($ad);
		push16le(n);
	}else{
		push8($af);
		push24le(n);
	}
}

macro lda @n,s
{
	push8($a3);
	push8(n);
}

macro lda @n,x
{
	if(n.bits()<=8){
		push8($b5);
		push8(n);
	}if(n.bits()<=16){
		push8($bd);
		push16le(n);
	}else{
		push8($bf);
		push24le(n);
	}
}

macro lda @n,y
{
	push8($b9);
	push16le(n);
}

macro lda (@n)
{
	push8($b2);
	push8(n);
}

macro lda (@n),y
{
	push8($b1);
	push8(n);
}

macro lda (@n,s),y
{
	push8($b3);
	push8(n);
}

macro lda (@n,x)
{
	push8($a1);
	push8(n);
}

macro lda [@n]
{
	push8($a7);
	push8(n);
}

macro lda [@n],y
{
	push8($b7);
	push8(n);
}

macro ldx #@n
{
	push8($a2);
	if(c2_65816_x)push8(n);
	else push16le(n);
}

macro ldx @n
{
	if(n.bits()<=8){
		push8($a6);
		push8(n);
	}else{
		push8($ae);
		push16le(n);
	}
}

macro ldx @n,y
{
	if(n.bits()<=8){
		push8($b6);
		push8(n);
	}else{
		push8($be);
		push16le(n);
	}
}

macro ldy #@n
{
	push8($a0);
	if(c2_65816_x)push8(n);
	else push16le(n);
}

macro ldy @n
{
	if(n.bits()<=8){
		push8($a4);
		push8(n);
	}else{
		push8($ac);
		push16le(n);
	}
}

macro ldy @n,x
{
	if(n.bits()<=8){
		push8($b4);
		push8(n);
	}else{
		push8($bc);
		push16le(n);
	}
}

macro lsr
{
	push8($4a);
}

macro lsr @n
{
	if(n.bits()<=8){
		push8($46);
		push8(n);
	}else{
		push8($4e);
		push16le(n);
	}
}

macro lsr @n,x
{
	if(n.bits()<=8){
		push8($56);
		push8(n);
	}else{
		push8($5e);
		push16le(n);
	}
}

macro lsr a
{
	push8($4a);
}

macro mvn @n1,@n2
{
	push8($54);
	push8(n2);
	push8(n1);
}

macro mvp @n1,@n2
{
	push8($44);
	push8(n2);
	push8(n1);
}

macro nop
{
	push8($ea);
}

macro ora #@n
{
	push8($09);
	if(c2_65816_m)push8(n);
	else push16le(n);
}

macro ora @n
{
	if(n.bits()<=8){
		push8($05);
		push8(n);
	}if(n.bits()<=16){
		push8($0d);
		push16le(n);
	}else{
		push8($0f);
		push24le(n);
	}
}

macro ora @n,s
{
	push8($03);
	push8(n);
}

macro ora @n,x
{
	if(n.bits()<=8){
		push8($15);
		push8(n);
	}if(n.bits()<=16){
		push8($1d);
		push16le(n);
	}else{
		push8($1f);
		push24le(n);
	}
}

macro ora @n,y
{
	push8($19);
	push16le(n);
}

macro ora (@n)
{
	push8($12);
	push8(n);
}

macro ora (@n),y
{
	push8($11);
	push8(n);
}

macro ora (@n,s),y
{
	push8($13);
	push8(n);
}

macro ora (@n,x)
{
	push8($01);
	push8(n);
}

macro ora [@n]
{
	push8($07);
	push8(n);
}

macro ora [@n],y
{
	push8($17);
	push8(n);
}

macro pea @n
{
	push8($f4);
	push16le(n);
}

macro pei (@n)
{
	push8($d4);
	push8(n);
}

macro per @n
{
	push8($62);
	push16le(c2sr<16>(n-@-2));
}

macro pha
{
	push8($48);
}

macro phb
{
	push8($8b);
}

macro phd
{
	push8($0b);
}

macro phk
{
	push8($4b);
}

macro php
{
	push8($08);
}

macro phx
{
	push8($da);
}

macro phy
{
	push8($5a);
}

macro pla
{
	push8($68);
}

macro plb
{
	push8($ab);
}

macro pld
{
	push8($2b);
}

macro plp
{
	push8($28);
}

macro plx
{
	push8($fa);
}

macro ply
{
	push8($7a);
}

macro rep #@n
{
	push8($c2);
	push8(n);
}

macro rol
{
	push8($2a);
}

macro rol @n
{
	if(n.bits()<=8){
		push8($26);
		push8(n);
	}else{
		push8($2e);
		push16le(n);
	}
}

macro rol @n,x
{
	if(n.bits()<=8){
		push8($36);
		push8(n);
	}else{
		push8($3e);
		push16le(n);
	}
}

macro rol a
{
	push8($2a);
}

macro ror
{
	push8($6a);
}

macro ror @n
{
	if(n.bits()<=8){
		push8($66);
		push8(n);
	}else{
		push8($6e);
		push16le(n);
	}
}

macro ror @n,x
{
	if(n.bits()<=8){
		push8($76);
		push8(n);
	}else{
		push8($7e);
		push16le(n);
	}
}

macro ror a
{
	push8($6a);
}

macro rti
{
	push8($40);
}

macro rtl
{
	push8($6b);
}

macro rts
{
	push8($60);
}

macro sbc #@n
{
	push8($e9);
	if(c2_65816_m)push8(n);
	else push16le(n);
}

macro sbc @n
{
	if(n.bits()<=8){
		push8($e5);
		push8(n);
	}if(n.bits()<=16){
		push8($ed);
		push16le(n);
	}else{
		push8($ef);
		push24le(n);
	}
}

macro sbc @n,s
{
	push8($e3);
	push8(n);
}

macro sbc @n,x
{
	if(n.bits()<=8){
		push8($f5);
		push8(n);
	}if(n.bits()<=16){
		push8($fd);
		push16le(n);
	}else{
		push8($ff);
		push24le(n);
	}
}

macro sbc @n,y
{
	push8($f9);
	push16le(n);
}

macro sbc (@n)
{
	push8($f2);
	push8(n);
}

macro sbc (@n),y
{
	push8($f1);
	push8(n);
}

macro sbc (@n,s),y
{
	push8($f3);
	push8(n);
}

macro sbc (@n,x)
{
	push8($e1);
	push8(n);
}

macro sbc [@n]
{
	push8($e7);
	push8(n);
}

macro sbc [@n],y
{
	push8($f7);
	push8(n);
}

macro sec
{
	push8($38);
}

macro sed
{
	push8($f8);
}

macro sei
{
	push8($78);
}

macro sep #@n
{
	push8($e2);
	push8(n);
}

macro sta @n
{
	if(n.bits()<=8){
		push8($85);
		push8(n);
	}if(n.bits()<=16){
		push8($8d);
		push16le(n);
	}else{
		push8($8f);
		push24le(n);
	}
}

macro sta @n,s
{
	push8($83);
	push8(n);
}

macro sta @n,x
{
	if(n.bits()<=8){
		push8($95);
		push8(n);
	}if(n.bits()<=16){
		push8($9d);
		push16le(n);
	}else{
		push8($9f);
		push24le(n);
	}
}

macro sta @n,y
{
	push8($99);
	push16le(n);
}

macro sta (@n)
{
	push8($92);
	push8(n);
}

macro sta (@n),y
{
	push8($91);
	push8(n);
}

macro sta (@n,s),y
{
	push8($93);
	push8(n);
}

macro sta (@n,x)
{
	push8($81);
	push8(n);
}

macro sta [@n]
{
	push8($87);
	push8(n);
}

macro sta [@n],y
{
	push8($97);
	push8(n);
}

macro stp
{
	push8($db);
}

macro stx @n
{
	if(n.bits()<=8){
		push8($86);
		push8(n);
	}else{
		push8($8e);
		push16le(n);
	}
}

macro stx @n,y
{
	push8($96);
	push8(n);
}

macro sty @n
{
	if(n.bits()<=8){
		push8($84);
		push8(n);
	}else{
		push8($8c);
		push16le(n);
	}
}

macro sty @n,x
{
	push8($94);
	push8(n);
}

macro stz @n
{
	if(n.bits()<=8){
		push8($64);
		push8(n);
	}else{
		push8($9c);
		push16le(n);
	}
}

macro stz @n,x
{
	if(n.bits()<=8){
		push8($74);
		push8(n);
	}else{
		push8($9e);
		push16le(n);
	}
}

macro tax
{
	push8($aa);
}

macro tay
{
	push8($a8);
}

macro tcd,tad
{
	push8($5b);
}

macro tcs,tas
{
	push8($1b);
}

macro tdc,tda
{
	push8($7b);
}

macro trb @n
{
	if(n.bits()<=8){
		push8($14);
		push8(n);
	}else{
		push8($1c);
		push16le(n);
	}
}

macro tsb @n
{
	if(n.bits()<=8){
		push8($04);
		push8(n);
	}else{
		push8($0c);
		push16le(n);
	}
}

macro tsc,tsa
{
	push8($3b);
}

macro tsx
{
	push8($ba);
}

macro txa
{
	push8($8a);
}

macro txs
{
	push8($9a);
}

macro txy
{
	push8($9b);
}

macro tya
{
	push8($98);
}

macro tyx
{
	push8($bb);
}

macro wai
{
	push8($cb);
}

macro wdm #@n
{
	push8($42);
	push8(n);
}

macro xba,swa
{
	push8($eb);
}

macro xce
{
	push8($fb);
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
    push16le(data);
}

macro word @data...
{
    for(size_t r=0;r<data.size();r++)
        push16le(data[r]);
}

macro sword @data
{
    push24le(data);
}

macro sword @data...
{
    for(size_t r=0;r<data.size();r++)
        push24le(data[r]);
}

macro align @n
{
    @ = ((@+(n-1))/n)*n
}
