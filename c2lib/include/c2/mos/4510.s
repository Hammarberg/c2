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

#define C2_4510

macro adc #@n
{
	push8($69);
	push8(n);
}

macro adc @n
{
	if(n.bits()<=8){
		push8($65);
		push8(n);
	}else{
		push8($6d);
		push16le(n);
	}
}

macro adc @n,x
{
	if(n.bits()<=8){
		push8($75);
		push8(n);
	}else{
		push8($7d);
		push16le(n);
	}
}

macro adc @n,y
{
	push8($79);
	push16le(n);
}

macro adc (@n),y
{
	push8($71);
	push8(n);
}

macro adc (@n),z
{
	push8($72);
	push8(n);
}

macro adc (@n,x)
{
	push8($61);
	push8(n);
}

macro and #@n
{
	push8($29);
	push8(n);
}

macro and @n
{
	if(n.bits()<=8){
		push8($25);
		push8(n);
	}else{
		push8($2d);
		push16le(n);
	}
}

macro and @n,x
{
	if(n.bits()<=8){
		push8($35);
		push8(n);
	}else{
		push8($3d);
		push16le(n);
	}
}

macro and @n,y
{
	push8($39);
	push16le(n);
}

macro and (@n),y
{
	push8($31);
	push8(n);
}

macro and (@n),z
{
	push8($32);
	push8(n);
}

macro and (@n,x)
{
	push8($21);
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

macro asr
{
	push8($43);
}

macro asr @n
{
	push8($44);
	push8(n);
}

macro asr @n,x
{
	push8($54);
	push8(n);
}

macro asr a
{
	push8($43);
}

macro asw @n
{
	push8($cb);
	push16le(n);
}

macro bbr0 @n,@r
{
	push8($0f);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbr1 @n,@r
{
	push8($1f);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbr2 @n,@r
{
	push8($2f);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbr3 @n,@r
{
	push8($3f);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbr4 @n,@r
{
	push8($4f);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbr5 @n,@r
{
	push8($5f);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbr6 @n,@r
{
	push8($6f);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbr7 @n,@r
{
	push8($7f);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbs0 @n,@r
{
	push8($8f);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbs1 @n,@r
{
	push8($9f);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbs2 @n,@r
{
	push8($af);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbs3 @n,@r
{
	push8($bf);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbs4 @n,@r
{
	push8($cf);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbs5 @n,@r
{
	push8($df);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbs6 @n,@r
{
	push8($ef);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bbs7 @n,@r
{
	push8($ff);
	push8(n);
	push8(c2sr<8>(r-@-1));
}

macro bcc @r
{
	c2static lb;
	if(c2st<8>(r-(@+2+lb))){
		push8($90);
		push8(c2sr<8>(r-@-1));
		lb = 0;
	}else{
		push8($93);
		push16le(c2sr<16>(r-@-2));
		lb = 1;
	}
}

macro bcs @r
{
	c2static lb;
	if(c2st<8>(r-(@+2+lb))){
		push8($b0);
		push8(c2sr<8>(r-@-1));
		lb = 0;
	}else{
		push8($b3);
		push16le(c2sr<16>(r-@-2));
		lb = 1;
	}
}

macro beq @r
{
	c2static lb;
	if(c2st<8>(r-(@+2+lb))){
		push8($f0);
		push8(c2sr<8>(r-@-1));
		lb = 0;
	}else{
		push8($f3);
		push16le(c2sr<16>(r-@-2));
		lb = 1;
	}
}

macro bit #@n
{
	push8($89);
	push8(n);
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

macro bmi @r
{
	c2static lb;
	if(c2st<8>(r-(@+2+lb))){
		push8($30);
		push8(c2sr<8>(r-@-1));
		lb = 0;
	}else{
		push8($33);
		push16le(c2sr<16>(r-@-2));
		lb = 1;
	}
}

macro bne @r
{
	c2static lb;
	if(c2st<8>(r-(@+2+lb))){
		push8($d0);
		push8(c2sr<8>(r-@-1));
		lb = 0;
	}else{
		push8($d3);
		push16le(c2sr<16>(r-@-2));
		lb = 1;
	}
}

macro bpl @r
{
	c2static lb;
	if(c2st<8>(r-(@+2+lb))){
		push8($10);
		push8(c2sr<8>(r-@-1));
		lb = 0;
	}else{
		push8($13);
		push16le(c2sr<16>(r-@-2));
		lb = 1;
	}
}

macro bra @r
{
	c2static lb;
	if(c2st<8>(r-(@+2+lb))){
		push8($80);
		push8(c2sr<8>(r-@-1));
		lb = 0;
	}else{
		push8($83);
		push16le(c2sr<16>(r-@-2));
		lb = 1;
	}
}

macro brk
{
	push8($00);
}

macro bsr @r
{
	push8($63);
	push16le(c2sr<16>(r-@-2));
}

macro bvc @r
{
	c2static lb;
	if(c2st<8>(r-(@+2+lb))){
		push8($50);
		push8(c2sr<8>(r-@-1));
		lb = 0;
	}else{
		push8($53);
		push16le(c2sr<16>(r-@-2));
		lb = 1;
	}
}

macro bvs @r
{
	c2static lb;
	if(c2st<8>(r-(@+2+lb))){
		push8($70);
		push8(c2sr<8>(r-@-1));
		lb = 0;
	}else{
		push8($73);
		push16le(c2sr<16>(r-@-2));
		lb = 1;
	}
}

macro clc
{
	push8($18);
}

macro cld
{
	push8($d8);
}

macro cle
{
	push8($02);
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
	push8(n);
}

macro cmp @n
{
	if(n.bits()<=8){
		push8($c5);
		push8(n);
	}else{
		push8($cd);
		push16le(n);
	}
}

macro cmp @n,x
{
	if(n.bits()<=8){
		push8($d5);
		push8(n);
	}else{
		push8($dd);
		push16le(n);
	}
}

macro cmp @n,y
{
	push8($d9);
	push16le(n);
}

macro cmp (@n),y
{
	push8($d1);
	push8(n);
}

macro cmp (@n),z
{
	push8($d2);
	push8(n);
}

macro cmp (@n,x)
{
	push8($c1);
	push8(n);
}

macro cpx #@n
{
	push8($e0);
	push8(n);
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
	push8(n);
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

macro cpz #@n
{
	push8($c2);
	push8(n);
}

macro cpz @n
{
	if(n.bits()<=8){
		push8($d4);
		push8(n);
	}else{
		push8($dc);
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

macro dew @n
{
	push8($c3);
	push8(n);
}

macro dex
{
	push8($ca);
}

macro dey
{
	push8($88);
}

macro dez
{
	push8($3b);
}

macro eom,nop
{
	push8($ea);
}

macro eor #@n
{
	push8($49);
	push8(n);
}

macro eor @n
{
	if(n.bits()<=8){
		push8($45);
		push8(n);
	}else{
		push8($4d);
		push16le(n);
	}
}

macro eor @n,x
{
	if(n.bits()<=8){
		push8($55);
		push8(n);
	}else{
		push8($5d);
		push16le(n);
	}
}

macro eor @n,y
{
	push8($59);
	push16le(n);
}

macro eor (@n),y
{
	push8($51);
	push8(n);
}

macro eor (@n),z
{
	push8($52);
	push8(n);
}

macro eor (@n,x)
{
	push8($41);
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

macro inw @n
{
	push8($e3);
	push8(n);
}

macro inx
{
	push8($e8);
}

macro iny
{
	push8($c8);
}

macro inz
{
	push8($1b);
}

macro jmp @n
{
	push8($4c);
	push16le(n);
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

macro jsr @n
{
	push8($20);
	push16le(n);
}

macro jsr (@n)
{
	push8($22);
	push16le(n);
}

macro jsr (@n,x)
{
	push8($23);
	push16le(n);
}

macro lbcc @r
{
	push8($93);
	push16le(c2sr<16>(r-@-2));
}

macro lbcs @r
{
	push8($b3);
	push16le(c2sr<16>(r-@-2));
}

macro lbeq @r
{
	push8($f3);
	push16le(c2sr<16>(r-@-2));
}

macro lbmi @r
{
	push8($33);
	push16le(c2sr<16>(r-@-2));
}

macro lbne @r
{
	push8($d3);
	push16le(c2sr<16>(r-@-2));
}

macro lbpl @r
{
	push8($13);
	push16le(c2sr<16>(r-@-2));
}

macro lbra @r
{
	push8($83);
	push16le(c2sr<16>(r-@-2));
}

macro lbvc @r
{
	push8($53);
	push16le(c2sr<16>(r-@-2));
}

macro lbvs @r
{
	push8($73);
	push16le(c2sr<16>(r-@-2));
}

macro lda #@n
{
	push8($a9);
	push8(n);
}

macro lda @n
{
	if(n.bits()<=8){
		push8($a5);
		push8(n);
	}else{
		push8($ad);
		push16le(n);
	}
}

macro lda @n,x
{
	if(n.bits()<=8){
		push8($b5);
		push8(n);
	}else{
		push8($bd);
		push16le(n);
	}
}

macro lda @n,y
{
	push8($b9);
	push16le(n);
}

macro lda (@n),y
{
	push8($b1);
	push8(n);
}

macro lda (@n),z
{
	push8($b2);
	push8(n);
}

macro lda (@n,sp),y
{
	push8($e2);
	push8(n);
}

macro lda (@n,x)
{
	push8($a1);
	push8(n);
}

macro ldx #@n
{
	push8($a2);
	push8(n);
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
	push8(n);
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

macro ldz #@n
{
	push8($a3);
	push8(n);
}

macro ldz @n
{
	push8($ab);
	push16le(n);
}

macro ldz @n,x
{
	push8($bb);
	push16le(n);
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

macro map
{
	push8($5c);
}

macro neg
{
	push8($42);
}

macro neg a
{
	push8($42);
}

macro ora #@n
{
	push8($09);
	push8(n);
}

macro ora @n
{
	if(n.bits()<=8){
		push8($05);
		push8(n);
	}else{
		push8($0d);
		push16le(n);
	}
}

macro ora @n,x
{
	if(n.bits()<=8){
		push8($15);
		push8(n);
	}else{
		push8($1d);
		push16le(n);
	}
}

macro ora @n,y
{
	push8($19);
	push16le(n);
}

macro ora (@n),y
{
	push8($11);
	push8(n);
}

macro ora (@n),z
{
	push8($12);
	push8(n);
}

macro ora (@n,x)
{
	push8($01);
	push8(n);
}

macro pha
{
	push8($48);
}

macro php
{
	push8($08);
}

macro phw #@n
{
	push8($f4);
	push16le(n);
}

macro phw @n
{
	push8($fc);
	push16le(n);
}

macro phx
{
	push8($da);
}

macro phy
{
	push8($5a);
}

macro phz
{
	push8($db);
}

macro pla
{
	push8($68);
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

macro plz
{
	push8($fb);
}

macro rmb0 @n
{
	push8($07);
	push8(n);
}

macro rmb1 @n
{
	push8($17);
	push8(n);
}

macro rmb2 @n
{
	push8($27);
	push8(n);
}

macro rmb3 @n
{
	push8($37);
	push8(n);
}

macro rmb4 @n
{
	push8($47);
	push8(n);
}

macro rmb5 @n
{
	push8($57);
	push8(n);
}

macro rmb6 @n
{
	push8($67);
	push8(n);
}

macro rmb7 @n
{
	push8($77);
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

macro row @n
{
	push8($eb);
	push16le(n);
}

macro rti
{
	push8($40);
}

macro rts
{
	push8($60);
}

macro rts #@n
{
	push8($62);
	push8(n);
}

macro sbc #@n
{
	push8($e9);
	push8(n);
}

macro sbc @n
{
	if(n.bits()<=8){
		push8($e5);
		push8(n);
	}else{
		push8($ed);
		push16le(n);
	}
}

macro sbc @n,x
{
	if(n.bits()<=8){
		push8($f5);
		push8(n);
	}else{
		push8($fd);
		push16le(n);
	}
}

macro sbc @n,y
{
	push8($f9);
	push16le(n);
}

macro sbc (@n),y
{
	push8($f1);
	push8(n);
}

macro sbc (@n),z
{
	push8($f2);
	push8(n);
}

macro sbc (@n,x)
{
	push8($e1);
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

macro see
{
	push8($03);
}

macro sei
{
	push8($78);
}

macro smb0 @n
{
	push8($87);
	push8(n);
}

macro smb1 @n
{
	push8($97);
	push8(n);
}

macro smb2 @n
{
	push8($a7);
	push8(n);
}

macro smb3 @n
{
	push8($b7);
	push8(n);
}

macro smb4 @n
{
	push8($c7);
	push8(n);
}

macro smb5 @n
{
	push8($d7);
	push8(n);
}

macro smb6 @n
{
	push8($e7);
	push8(n);
}

macro smb7 @n
{
	push8($f7);
	push8(n);
}

macro sta @n
{
	if(n.bits()<=8){
		push8($85);
		push8(n);
	}else{
		push8($8d);
		push16le(n);
	}
}

macro sta @n,x
{
	if(n.bits()<=8){
		push8($95);
		push8(n);
	}else{
		push8($9d);
		push16le(n);
	}
}

macro sta @n,y
{
	push8($99);
	push16le(n);
}

macro sta (@n),y
{
	push8($91);
	push8(n);
}

macro sta (@n),z
{
	push8($92);
	push8(n);
}

macro sta (@n,sp),y
{
	push8($82);
	push8(n);
}

macro sta (@n,x)
{
	push8($81);
	push8(n);
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
	if(n.bits()<=8){
		push8($96);
		push8(n);
	}else{
		push8($9b);
		push16le(n);
	}
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
	if(n.bits()<=8){
		push8($94);
		push8(n);
	}else{
		push8($8b);
		push16le(n);
	}
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

macro tab
{
	push8($5b);
}

macro tax
{
	push8($aa);
}

macro tay
{
	push8($a8);
}

macro taz
{
	push8($4b);
}

macro tba
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

macro tsx
{
	push8($ba);
}

macro tsy
{
	push8($0b);
}

macro txa
{
	push8($8a);
}

macro txs
{
	push8($9a);
}

macro tya
{
	push8($98);
}

macro tys
{
	push8($2b);
}

macro tza
{
	push8($6b);
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
