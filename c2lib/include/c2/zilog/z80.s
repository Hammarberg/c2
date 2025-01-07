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

#define C2_Z80

// Reference links
// https://www.zilog.com/docs/z80/z80cpu_um.pdf
// http://www.z80.info/

macro adc a,(hl)
{
	push8($8e);
}

macro adc a,(ix)
{
	push16le($8edd);
	push8($00);
}

macro adc a,(ix+@d)
{
	push16le($8edd);
	push8(c2sr<8>(d));
}

macro adc a,(ix-@d)
{
	push16le($8edd);
	push8(c2sr<8>(-d));
}

macro adc a,(iy)
{
	push16le($8efd);
	push8($00);
}

macro adc a,(iy+@d)
{
	push16le($8efd);
	push8(c2sr<8>(d));
}

macro adc a,(iy-@d)
{
	push16le($8efd);
	push8(c2sr<8>(-d));
}

macro adc a,a
{
	push8($8f);
}

macro adc a,b
{
	push8($88);
}

macro adc a,c
{
	push8($89);
}

macro adc a,d
{
	push8($8a);
}

macro adc a,e
{
	push8($8b);
}

macro adc a,h
{
	push8($8c);
}

macro adc a,l
{
	push8($8d);
}

macro adc a,@n
{
	push8($ce);
	push8(n);
}

macro adc hl,bc
{
	push16le($4aed);
}

macro adc hl,de
{
	push16le($5aed);
}

macro adc hl,hl
{
	push16le($6aed);
}

macro adc hl,sp
{
	push16le($7aed);
}

macro add a,(hl)
{
	push8($86);
}

macro add a,(ix)
{
	push16le($86dd);
	push8($00);
}

macro add a,(ix+@d)
{
	push16le($86dd);
	push8(c2sr<8>(d));
}

macro add a,(ix-@d)
{
	push16le($86dd);
	push8(c2sr<8>(-d));
}

macro add a,(iy)
{
	push16le($86fd);
	push8($00);
}

macro add a,(iy+@d)
{
	push16le($86fd);
	push8(c2sr<8>(d));
}

macro add a,(iy-@d)
{
	push16le($86fd);
	push8(c2sr<8>(-d));
}

macro add a,a
{
	push8($87);
}

macro add a,b
{
	push8($80);
}

macro add a,c
{
	push8($81);
}

macro add a,d
{
	push8($82);
}

macro add a,e
{
	push8($83);
}

macro add a,h
{
	push8($84);
}

macro add a,l
{
	push8($85);
}

macro add a,@n
{
	push8($c6);
	push8(n);
}

macro add hl,bc
{
	push8($09);
}

macro add hl,de
{
	push8($19);
}

macro add hl,hl
{
	push8($29);
}

macro add hl,sp
{
	push8($39);
}

macro add ix,bc
{
	push16le($09dd);
}

macro add ix,de
{
	push16le($19dd);
}

macro add ix,ix
{
	push16le($29dd);
}

macro add ix,sp
{
	push16le($39dd);
}

macro add iy,bc
{
	push16le($09fd);
}

macro add iy,de
{
	push16le($19fd);
}

macro add iy,iy
{
	push16le($29fd);
}

macro add iy,sp
{
	push16le($39fd);
}

macro and (hl)
{
	push8($a6);
}

macro and (ix)
{
	push16le($a6dd);
	push8($00);
}

macro and (ix+@d)
{
	push16le($a6dd);
	push8(c2sr<8>(d));
}

macro and (ix-@d)
{
	push16le($a6dd);
	push8(c2sr<8>(-d));
}

macro and (iy)
{
	push16le($a6fd);
	push8($00);
}

macro and (iy+@d)
{
	push16le($a6fd);
	push8(c2sr<8>(d));
}

macro and (iy-@d)
{
	push16le($a6fd);
	push8(c2sr<8>(-d));
}

macro and a
{
	push8($a7);
}

macro and b
{
	push8($a0);
}

macro and c
{
	push8($a1);
}

macro and d
{
	push8($a2);
}

macro and e
{
	push8($a3);
}

macro and h
{
	push8($a4);
}

macro and l
{
	push8($a5);
}

macro and @n
{
	push8($e6);
	push8(n);
}

macro bit 0,(hl)
{
	push16le($46cb);
}

macro bit 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($46);
}

macro bit 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($46);
}

macro bit 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($46);
}

macro bit 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($46);
}

macro bit 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($46);
}

macro bit 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($46);
}

macro bit 0,a
{
	push16le($47cb);
}

macro bit 0,b
{
	push16le($40cb);
}

macro bit 0,c
{
	push16le($41cb);
}

macro bit 0,d
{
	push16le($42cb);
}

macro bit 0,e
{
	push16le($43cb);
}

macro bit 0,h
{
	push16le($44cb);
}

macro bit 0,l
{
	push16le($45cb);
}

macro bit 1,(hl)
{
	push16le($4ecb);
}

macro bit 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($4e);
}

macro bit 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($4e);
}

macro bit 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($4e);
}

macro bit 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($4e);
}

macro bit 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($4e);
}

macro bit 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($4e);
}

macro bit 1,a
{
	push16le($4fcb);
}

macro bit 1,b
{
	push16le($48cb);
}

macro bit 1,c
{
	push16le($49cb);
}

macro bit 1,d
{
	push16le($4acb);
}

macro bit 1,e
{
	push16le($4bcb);
}

macro bit 1,h
{
	push16le($4ccb);
}

macro bit 1,l
{
	push16le($4dcb);
}

macro bit 2,(hl)
{
	push16le($56cb);
}

macro bit 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($56);
}

macro bit 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($56);
}

macro bit 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($56);
}

macro bit 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($56);
}

macro bit 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($56);
}

macro bit 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($56);
}

macro bit 2,a
{
	push16le($57cb);
}

macro bit 2,b
{
	push16le($50cb);
}

macro bit 2,c
{
	push16le($51cb);
}

macro bit 2,d
{
	push16le($52cb);
}

macro bit 2,e
{
	push16le($53cb);
}

macro bit 2,h
{
	push16le($54cb);
}

macro bit 2,l
{
	push16le($55cb);
}

macro bit 3,(hl)
{
	push16le($5ecb);
}

macro bit 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($5e);
}

macro bit 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($5e);
}

macro bit 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($5e);
}

macro bit 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($5e);
}

macro bit 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($5e);
}

macro bit 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($5e);
}

macro bit 3,a
{
	push16le($5fcb);
}

macro bit 3,b
{
	push16le($58cb);
}

macro bit 3,c
{
	push16le($59cb);
}

macro bit 3,d
{
	push16le($5acb);
}

macro bit 3,e
{
	push16le($5bcb);
}

macro bit 3,h
{
	push16le($5ccb);
}

macro bit 3,l
{
	push16le($5dcb);
}

macro bit 4,(hl)
{
	push16le($66cb);
}

macro bit 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($66);
}

macro bit 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($66);
}

macro bit 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($66);
}

macro bit 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($66);
}

macro bit 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($66);
}

macro bit 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($66);
}

macro bit 4,a
{
	push16le($67cb);
}

macro bit 4,b
{
	push16le($60cb);
}

macro bit 4,c
{
	push16le($61cb);
}

macro bit 4,d
{
	push16le($62cb);
}

macro bit 4,e
{
	push16le($63cb);
}

macro bit 4,h
{
	push16le($64cb);
}

macro bit 4,l
{
	push16le($65cb);
}

macro bit 5,(hl)
{
	push16le($6ecb);
}

macro bit 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($6e);
}

macro bit 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($6e);
}

macro bit 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($6e);
}

macro bit 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($6e);
}

macro bit 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($6e);
}

macro bit 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($6e);
}

macro bit 5,a
{
	push16le($6fcb);
}

macro bit 5,b
{
	push16le($68cb);
}

macro bit 5,c
{
	push16le($69cb);
}

macro bit 5,d
{
	push16le($6acb);
}

macro bit 5,e
{
	push16le($6bcb);
}

macro bit 5,h
{
	push16le($6ccb);
}

macro bit 5,l
{
	push16le($6dcb);
}

macro bit 6,(hl)
{
	push16le($76cb);
}

macro bit 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($76);
}

macro bit 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($76);
}

macro bit 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($76);
}

macro bit 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($76);
}

macro bit 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($76);
}

macro bit 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($76);
}

macro bit 6,a
{
	push16le($77cb);
}

macro bit 6,b
{
	push16le($70cb);
}

macro bit 6,c
{
	push16le($71cb);
}

macro bit 6,d
{
	push16le($72cb);
}

macro bit 6,e
{
	push16le($73cb);
}

macro bit 6,h
{
	push16le($74cb);
}

macro bit 6,l
{
	push16le($75cb);
}

macro bit 7,(hl)
{
	push16le($7ecb);
}

macro bit 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($7e);
}

macro bit 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($7e);
}

macro bit 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($7e);
}

macro bit 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($7e);
}

macro bit 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($7e);
}

macro bit 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($7e);
}

macro bit 7,a
{
	push16le($7fcb);
}

macro bit 7,b
{
	push16le($78cb);
}

macro bit 7,c
{
	push16le($79cb);
}

macro bit 7,d
{
	push16le($7acb);
}

macro bit 7,e
{
	push16le($7bcb);
}

macro bit 7,h
{
	push16le($7ccb);
}

macro bit 7,l
{
	push16le($7dcb);
}

macro call c,@n
{
	push8($dc);
	push16le(n);
}

macro call m,@n
{
	push8($fc);
	push16le(n);
}

macro call nc,@n
{
	push8($d4);
	push16le(n);
}

macro call nz,@n
{
	push8($c4);
	push16le(n);
}

macro call p,@n
{
	push8($f4);
	push16le(n);
}

macro call pe,@n
{
	push8($ec);
	push16le(n);
}

macro call po,@n
{
	push8($e4);
	push16le(n);
}

macro call z,@n
{
	push8($cc);
	push16le(n);
}

macro call @n
{
	push8($cd);
	push16le(n);
}

macro ccf
{
	push8($3f);
}

macro cp (hl)
{
	push8($be);
}

macro cp (ix)
{
	push16le($bedd);
	push8($00);
}

macro cp (ix+@d)
{
	push16le($bedd);
	push8(c2sr<8>(d));
}

macro cp (ix-@d)
{
	push16le($bedd);
	push8(c2sr<8>(-d));
}

macro cp (iy)
{
	push16le($befd);
	push8($00);
}

macro cp (iy+@d)
{
	push16le($befd);
	push8(c2sr<8>(d));
}

macro cp (iy-@d)
{
	push16le($befd);
	push8(c2sr<8>(-d));
}

macro cp a
{
	push8($bf);
}

macro cp b
{
	push8($b8);
}

macro cp c
{
	push8($b9);
}

macro cp d
{
	push8($ba);
}

macro cp e
{
	push8($bb);
}

macro cp h
{
	push8($bc);
}

macro cp l
{
	push8($bd);
}

macro cp @n
{
	push8($fe);
	push8(n);
}

macro cpd
{
	push16le($a9ed);
}

macro cpdr
{
	push16le($b9ed);
}

macro cpi
{
	push16le($a1ed);
}

macro cpir
{
	push16le($b1ed);
}

macro cpl
{
	push8($2f);
}

macro daa
{
	push8($27);
}

macro dec (hl)
{
	push8($35);
}

macro dec (ix)
{
	push16le($35dd);
	push8($00);
}

macro dec (ix+@d)
{
	push16le($35dd);
	push8(c2sr<8>(d));
}

macro dec (ix-@d)
{
	push16le($35dd);
	push8(c2sr<8>(-d));
}

macro dec (iy)
{
	push16le($35fd);
	push8($00);
}

macro dec (iy+@d)
{
	push16le($35fd);
	push8(c2sr<8>(d));
}

macro dec (iy-@d)
{
	push16le($35fd);
	push8(c2sr<8>(-d));
}

macro dec a
{
	push8($3d);
}

macro dec b
{
	push8($05);
}

macro dec bc
{
	push8($0b);
}

macro dec c
{
	push8($0d);
}

macro dec d
{
	push8($15);
}

macro dec de
{
	push8($1b);
}

macro dec e
{
	push8($1d);
}

macro dec h
{
	push8($25);
}

macro dec hl
{
	push8($2b);
}

macro dec ix
{
	push16le($2bdd);
}

macro dec iy
{
	push16le($2bfd);
}

macro dec l
{
	push8($2d);
}

macro dec sp
{
	push8($3b);
}

macro di
{
	push8($f3);
}

macro djnz @r
{
	push8($10);
	push8(c2sr<8>(r-@-1));
}

macro ei
{
	push8($fb);
}

macro ex (sp),hl
{
	push8($e3);
}

macro ex (sp),ix
{
	push16le($e3dd);
}

macro ex (sp),iy
{
	push16le($e3fd);
}

macro ex af,af
{
	push8($08);
}

macro ex de,hl
{
	push8($eb);
}

macro exx
{
	push8($d9);
}

macro halt
{
	push8($76);
}

macro im 0
{
	push16le($46ed);
}

macro im 1
{
	push16le($56ed);
}

macro im 2
{
	push16le($5eed);
}

macro in a,(c)
{
	push16le($78ed);
}

macro in a,(@n)
{
	push8($db);
	push8(n);
}

macro in b,(c)
{
	push16le($40ed);
}

macro in c,(c)
{
	push16le($48ed);
}

macro in d,(c)
{
	push16le($50ed);
}

macro in e,(c)
{
	push16le($58ed);
}

macro in h,(c)
{
	push16le($60ed);
}

macro in l,(c)
{
	push16le($68ed);
}

macro inc (hl)
{
	push8($34);
}

macro inc (ix)
{
	push16le($34dd);
	push8($00);
}

macro inc (ix+@d)
{
	push16le($34dd);
	push8(c2sr<8>(d));
}

macro inc (ix-@d)
{
	push16le($34dd);
	push8(c2sr<8>(-d));
}

macro inc (iy)
{
	push16le($34fd);
	push8($00);
}

macro inc (iy+@d)
{
	push16le($34fd);
	push8(c2sr<8>(d));
}

macro inc (iy-@d)
{
	push16le($34fd);
	push8(c2sr<8>(-d));
}

macro inc a
{
	push8($3c);
}

macro inc b
{
	push8($04);
}

macro inc bc
{
	push8($03);
}

macro inc c
{
	push8($0c);
}

macro inc d
{
	push8($14);
}

macro inc de
{
	push8($13);
}

macro inc e
{
	push8($1c);
}

macro inc h
{
	push8($24);
}

macro inc hl
{
	push8($23);
}

macro inc ix
{
	push16le($23dd);
}

macro inc iy
{
	push16le($23fd);
}

macro inc l
{
	push8($2c);
}

macro inc sp
{
	push8($33);
}

macro ind
{
	push16le($aaed);
}

macro indr
{
	push16le($baed);
}

macro ini
{
	push16le($a2ed);
}

macro inir
{
	push16le($b2ed);
}

macro jp (hl)
{
	push8($e9);
}

macro jp (ix)
{
	push16le($e9dd);
}

macro jp (iy)
{
	push16le($e9fd);
}

macro jp c,@n
{
	push8($da);
	push16le(n);
}

macro jp m,@n
{
	push8($fa);
	push16le(n);
}

macro jp nc,@n
{
	push8($d2);
	push16le(n);
}

macro jp nz,@n
{
	push8($c2);
	push16le(n);
}

macro jp p,@n
{
	push8($f2);
	push16le(n);
}

macro jp pe,@n
{
	push8($ea);
	push16le(n);
}

macro jp po,@n
{
	push8($e2);
	push16le(n);
}

macro jp z,@n
{
	push8($ca);
	push16le(n);
}

macro jp @n
{
	push8($c3);
	push16le(n);
}

macro jr @r
{
	push8($18);
	push8(c2sr<8>(r-@-1));
}

macro jr c,@r
{
	push8($38);
	push8(c2sr<8>(r-@-1));
}

macro jr nc,@r
{
	push8($30);
	push8(c2sr<8>(r-@-1));
}

macro jr nz,@r
{
	push8($20);
	push8(c2sr<8>(r-@-1));
}

macro jr z,@r
{
	push8($28);
	push8(c2sr<8>(r-@-1));
}

macro ld (bc),a
{
	push8($02);
}

macro ld (de),a
{
	push8($12);
}

macro ld (hl),a
{
	push8($77);
}

macro ld (hl),b
{
	push8($70);
}

macro ld (hl),c
{
	push8($71);
}

macro ld (hl),d
{
	push8($72);
}

macro ld (hl),e
{
	push8($73);
}

macro ld (hl),h
{
	push8($74);
}

macro ld (hl),l
{
	push8($75);
}

macro ld (hl),@n
{
	push8($36);
	push8(n);
}

macro ld (ix),a
{
	push16le($77dd);
	push8($00);
}

macro ld (ix),b
{
	push16le($70dd);
	push8($00);
}

macro ld (ix),c
{
	push16le($71dd);
	push8($00);
}

macro ld (ix),d
{
	push16le($72dd);
	push8($00);
}

macro ld (ix),e
{
	push16le($73dd);
	push8($00);
}

macro ld (ix),h
{
	push16le($74dd);
	push8($00);
}

macro ld (ix),l
{
	push16le($75dd);
	push8($00);
}

macro ld (ix),@n
{
	push16le($36dd);
	push8($00);
	push8(n);
}

macro ld (ix+@d),a
{
	push16le($77dd);
	push8(c2sr<8>(d));
}

macro ld (ix+@d),b
{
	push16le($70dd);
	push8(c2sr<8>(d));
}

macro ld (ix+@d),c
{
	push16le($71dd);
	push8(c2sr<8>(d));
}

macro ld (ix+@d),d
{
	push16le($72dd);
	push8(c2sr<8>(d));
}

macro ld (ix+@d),e
{
	push16le($73dd);
	push8(c2sr<8>(d));
}

macro ld (ix+@d),h
{
	push16le($74dd);
	push8(c2sr<8>(d));
}

macro ld (ix+@d),l
{
	push16le($75dd);
	push8(c2sr<8>(d));
}

macro ld (ix+@d),@n
{
	push16le($36dd);
	push8(c2sr<8>(d));
	push8(n);
}

macro ld (ix-@d),a
{
	push16le($77dd);
	push8(c2sr<8>(-d));
}

macro ld (ix-@d),b
{
	push16le($70dd);
	push8(c2sr<8>(-d));
}

macro ld (ix-@d),c
{
	push16le($71dd);
	push8(c2sr<8>(-d));
}

macro ld (ix-@d),d
{
	push16le($72dd);
	push8(c2sr<8>(-d));
}

macro ld (ix-@d),e
{
	push16le($73dd);
	push8(c2sr<8>(-d));
}

macro ld (ix-@d),h
{
	push16le($74dd);
	push8(c2sr<8>(-d));
}

macro ld (ix-@d),l
{
	push16le($75dd);
	push8(c2sr<8>(-d));
}

macro ld (ix-@d),@n
{
	push16le($36dd);
	push8(c2sr<8>(d));
	push8(n);
}

macro ld (iy),a
{
	push16le($77fd);
	push8($00);
}

macro ld (iy),b
{
	push16le($70fd);
	push8($00);
}

macro ld (iy),c
{
	push16le($71fd);
	push8($00);
}

macro ld (iy),d
{
	push16le($72fd);
	push8($00);
}

macro ld (iy),e
{
	push16le($73fd);
	push8($00);
}

macro ld (iy),h
{
	push16le($74fd);
	push8($00);
}

macro ld (iy),l
{
	push16le($75fd);
	push8($00);
}

macro ld (iy),@n
{
	push16le($36fd);
	push8($00);
	push8(n);
}

macro ld (iy+@d),a
{
	push16le($77fd);
	push8(c2sr<8>(d));
}

macro ld (iy+@d),b
{
	push16le($70fd);
	push8(c2sr<8>(d));
}

macro ld (iy+@d),c
{
	push16le($71fd);
	push8(c2sr<8>(d));
}

macro ld (iy+@d),d
{
	push16le($72fd);
	push8(c2sr<8>(d));
}

macro ld (iy+@d),e
{
	push16le($73fd);
	push8(c2sr<8>(d));
}

macro ld (iy+@d),h
{
	push16le($74fd);
	push8(c2sr<8>(d));
}

macro ld (iy+@d),l
{
	push16le($75fd);
	push8(c2sr<8>(d));
}

macro ld (iy+@d),@n
{
	push16le($36fd);
	push8(c2sr<8>(d));
	push8(n);
}

macro ld (iy-@d),a
{
	push16le($77fd);
	push8(c2sr<8>(-d));
}

macro ld (iy-@d),b
{
	push16le($70fd);
	push8(c2sr<8>(-d));
}

macro ld (iy-@d),c
{
	push16le($71fd);
	push8(c2sr<8>(-d));
}

macro ld (iy-@d),d
{
	push16le($72fd);
	push8(c2sr<8>(-d));
}

macro ld (iy-@d),e
{
	push16le($73fd);
	push8(c2sr<8>(-d));
}

macro ld (iy-@d),h
{
	push16le($74fd);
	push8(c2sr<8>(-d));
}

macro ld (iy-@d),l
{
	push16le($75fd);
	push8(c2sr<8>(-d));
}

macro ld (iy-@d),@n
{
	push16le($36fd);
	push8(c2sr<8>(d));
	push8(n);
}

macro ld (@nn),a
{
	push8($32);
	push16le(nn);
}

macro ld (@nn),bc
{
	push16le($43ed);
	push16le(nn);
}

macro ld (@nn),de
{
	push16le($53ed);
	push16le(nn);
}

macro ld (@nn),hl
{
	push8($22);
	push16le(nn);
}

macro ld (@nn),ix
{
	push16le($22dd);
	push16le(nn);
}

macro ld (@nn),iy
{
	push16le($22fd);
	push16le(nn);
}

macro ld (@nn),sp
{
	push16le($73ed);
	push16le(nn);
}

macro ld a,(bc)
{
	push8($0a);
}

macro ld a,(de)
{
	push8($1a);
}

macro ld a,(hl)
{
	push8($7e);
}

macro ld a,(ix)
{
	push16le($7edd);
	push8($00);
}

macro ld a,(ix+@d)
{
	push16le($7edd);
	push8(c2sr<8>(d));
}

macro ld a,(ix-@d)
{
	push16le($7edd);
	push8(c2sr<8>(-d));
}

macro ld a,(iy)
{
	push16le($7efd);
	push8($00);
}

macro ld a,(iy+@d)
{
	push16le($7efd);
	push8(c2sr<8>(d));
}

macro ld a,(iy-@d)
{
	push16le($7efd);
	push8(c2sr<8>(-d));
}

macro ld a,(@nn)
{
	push8($3a);
	push16le(nn);
}

macro ld a,a
{
	push8($7f);
}

macro ld a,b
{
	push8($78);
}

macro ld a,c
{
	push8($79);
}

macro ld a,d
{
	push8($7a);
}

macro ld a,e
{
	push8($7b);
}

macro ld a,h
{
	push8($7c);
}

macro ld a,i
{
	push16le($57ed);
}

macro ld a,l
{
	push8($7d);
}

macro ld a,r
{
	push16le($5fed);
}

macro ld a,@n
{
	push8($3e);
	push8(n);
}

macro ld b,(hl)
{
	push8($46);
}

macro ld b,(ix)
{
	push16le($46dd);
	push8($00);
}

macro ld b,(ix+@d)
{
	push16le($46dd);
	push8(c2sr<8>(d));
}

macro ld b,(ix-@d)
{
	push16le($46dd);
	push8(c2sr<8>(-d));
}

macro ld b,(iy)
{
	push16le($46fd);
	push8($00);
}

macro ld b,(iy+@d)
{
	push16le($46fd);
	push8(c2sr<8>(d));
}

macro ld b,(iy-@d)
{
	push16le($46fd);
	push8(c2sr<8>(-d));
}

macro ld b,a
{
	push8($47);
}

macro ld b,b
{
	push8($40);
}

macro ld b,c
{
	push8($41);
}

macro ld b,d
{
	push8($42);
}

macro ld b,e
{
	push8($43);
}

macro ld b,h
{
	push8($44);
}

macro ld b,l
{
	push8($45);
}

macro ld b,@n
{
	push8($06);
	push8(n);
}

macro ld bc,(@nn)
{
	push16le($4bed);
	push16le(nn);
}

macro ld bc,@nn
{
	push8($01);
	push16le(nn);
}

macro ld c,(hl)
{
	push8($4e);
}

macro ld c,(ix)
{
	push16le($4edd);
	push8($00);
}

macro ld c,(ix+@d)
{
	push16le($4edd);
	push8(c2sr<8>(d));
}

macro ld c,(ix-@d)
{
	push16le($4edd);
	push8(c2sr<8>(-d));
}

macro ld c,(iy)
{
	push16le($4efd);
	push8($00);
}

macro ld c,(iy+@d)
{
	push16le($4efd);
	push8(c2sr<8>(d));
}

macro ld c,(iy-@d)
{
	push16le($4efd);
	push8(c2sr<8>(-d));
}

macro ld c,a
{
	push8($4f);
}

macro ld c,b
{
	push8($48);
}

macro ld c,c
{
	push8($49);
}

macro ld c,d
{
	push8($4a);
}

macro ld c,e
{
	push8($4b);
}

macro ld c,h
{
	push8($4c);
}

macro ld c,l
{
	push8($4d);
}

macro ld c,@n
{
	push8($0e);
	push8(n);
}

macro ld d,(hl)
{
	push8($56);
}

macro ld d,(ix)
{
	push16le($56dd);
	push8($00);
}

macro ld d,(ix+@d)
{
	push16le($56dd);
	push8(c2sr<8>(d));
}

macro ld d,(ix-@d)
{
	push16le($56dd);
	push8(c2sr<8>(-d));
}

macro ld d,(iy)
{
	push16le($56fd);
	push8($00);
}

macro ld d,(iy+@d)
{
	push16le($56fd);
	push8(c2sr<8>(d));
}

macro ld d,(iy-@d)
{
	push16le($56fd);
	push8(c2sr<8>(-d));
}

macro ld d,a
{
	push8($57);
}

macro ld d,b
{
	push8($50);
}

macro ld d,c
{
	push8($51);
}

macro ld d,d
{
	push8($52);
}

macro ld d,e
{
	push8($53);
}

macro ld d,h
{
	push8($54);
}

macro ld d,l
{
	push8($55);
}

macro ld d,@n
{
	push8($16);
	push8(n);
}

macro ld de,(@nn)
{
	push16le($5bed);
	push16le(nn);
}

macro ld de,@nn
{
	push8($11);
	push16le(nn);
}

macro ld e,(hl)
{
	push8($5e);
}

macro ld e,(ix)
{
	push16le($5edd);
	push8($00);
}

macro ld e,(ix+@d)
{
	push16le($5edd);
	push8(c2sr<8>(d));
}

macro ld e,(ix-@d)
{
	push16le($5edd);
	push8(c2sr<8>(-d));
}

macro ld e,(iy)
{
	push16le($5efd);
	push8($00);
}

macro ld e,(iy+@d)
{
	push16le($5efd);
	push8(c2sr<8>(d));
}

macro ld e,(iy-@d)
{
	push16le($5efd);
	push8(c2sr<8>(-d));
}

macro ld e,a
{
	push8($5f);
}

macro ld e,b
{
	push8($58);
}

macro ld e,c
{
	push8($59);
}

macro ld e,d
{
	push8($5a);
}

macro ld e,e
{
	push8($5b);
}

macro ld e,h
{
	push8($5c);
}

macro ld e,l
{
	push8($5d);
}

macro ld e,@n
{
	push8($1e);
	push8(n);
}

macro ld h,(hl)
{
	push8($66);
}

macro ld h,(ix)
{
	push16le($66dd);
	push8($00);
}

macro ld h,(ix+@d)
{
	push16le($66dd);
	push8(c2sr<8>(d));
}

macro ld h,(ix-@d)
{
	push16le($66dd);
	push8(c2sr<8>(-d));
}

macro ld h,(iy)
{
	push16le($66fd);
	push8($00);
}

macro ld h,(iy+@d)
{
	push16le($66fd);
	push8(c2sr<8>(d));
}

macro ld h,(iy-@d)
{
	push16le($66fd);
	push8(c2sr<8>(-d));
}

macro ld h,a
{
	push8($67);
}

macro ld h,b
{
	push8($60);
}

macro ld h,c
{
	push8($61);
}

macro ld h,d
{
	push8($62);
}

macro ld h,e
{
	push8($63);
}

macro ld h,h
{
	push8($64);
}

macro ld h,l
{
	push8($65);
}

macro ld h,@n
{
	push8($26);
	push8(n);
}

macro ld hl,(@nn)
{
	push8($2a);
	push16le(nn);
}

macro ld hl,@nn
{
	push8($21);
	push16le(nn);
}

macro ld i,a
{
	push16le($47ed);
}

macro ld ix,(@nn)
{
	push16le($2add);
	push16le(nn);
}

macro ld ix,@nn
{
	push16le($21dd);
	push16le(nn);
}

macro ld iy,(@nn)
{
	push16le($2afd);
	push16le(nn);
}

macro ld iy,@nn
{
	push16le($21fd);
	push16le(nn);
}

macro ld l,(hl)
{
	push8($6e);
}

macro ld l,(ix)
{
	push16le($6edd);
	push8($00);
}

macro ld l,(ix+@d)
{
	push16le($6edd);
	push8(c2sr<8>(d));
}

macro ld l,(ix-@d)
{
	push16le($6edd);
	push8(c2sr<8>(-d));
}

macro ld l,(iy)
{
	push16le($6efd);
	push8($00);
}

macro ld l,(iy+@d)
{
	push16le($6efd);
	push8(c2sr<8>(d));
}

macro ld l,(iy-@d)
{
	push16le($6efd);
	push8(c2sr<8>(-d));
}

macro ld l,a
{
	push8($6f);
}

macro ld l,b
{
	push8($68);
}

macro ld l,c
{
	push8($69);
}

macro ld l,d
{
	push8($6a);
}

macro ld l,e
{
	push8($6b);
}

macro ld l,h
{
	push8($6c);
}

macro ld l,l
{
	push8($6d);
}

macro ld l,@n
{
	push8($2e);
	push8(n);
}

macro ld r,a
{
	push16le($4fed);
}

macro ld sp,(@nn)
{
	push16le($7bed);
	push16le(nn);
}

macro ld sp,hl
{
	push8($f9);
}

macro ld sp,ix
{
	push16le($f9dd);
}

macro ld sp,iy
{
	push16le($f9fd);
}

macro ld sp,@nn
{
	push8($31);
	push16le(nn);
}

macro ld2 (@nn),hl
{
	push16le($63ed);
	push16le(nn);
}

macro ld2 hl,(@nn)
{
	push16le($6bed);
	push16le(nn);
}

macro ldd
{
	push16le($a8ed);
}

macro lddr
{
	push16le($b8ed);
}

macro ldi
{
	push16le($a0ed);
}

macro ldir
{
	push16le($b0ed);
}

macro neg
{
	push16le($44ed);
}

macro nop
{
	push8($00);
}

macro or (hl)
{
	push8($b6);
}

macro or (ix)
{
	push16le($b6dd);
	push8($00);
}

macro or (ix+@d)
{
	push16le($b6dd);
	push8(c2sr<8>(d));
}

macro or (ix-@d)
{
	push16le($b6dd);
	push8(c2sr<8>(-d));
}

macro or (iy)
{
	push16le($b6fd);
	push8($00);
}

macro or (iy+@d)
{
	push16le($b6fd);
	push8(c2sr<8>(d));
}

macro or (iy-@d)
{
	push16le($b6fd);
	push8(c2sr<8>(-d));
}

macro or a
{
	push8($b7);
}

macro or b
{
	push8($b0);
}

macro or c
{
	push8($b1);
}

macro or d
{
	push8($b2);
}

macro or e
{
	push8($b3);
}

macro or h
{
	push8($b4);
}

macro or l
{
	push8($b5);
}

macro or @n
{
	push8($f6);
	push8(n);
}

macro otdr
{
	push16le($bbed);
}

macro otir
{
	push16le($b3ed);
}

macro out (c),a
{
	push16le($79ed);
}

macro out (c),b
{
	push16le($41ed);
}

macro out (c),c
{
	push16le($49ed);
}

macro out (c),d
{
	push16le($51ed);
}

macro out (c),e
{
	push16le($59ed);
}

macro out (c),h
{
	push16le($61ed);
}

macro out (c),l
{
	push16le($69ed);
}

macro out (@n),a
{
	push8($d3);
	push8(n);
}

macro outd
{
	push16le($abed);
}

macro outi
{
	push16le($a3ed);
}

macro pop af
{
	push8($f1);
}

macro pop bc
{
	push8($c1);
}

macro pop de
{
	push8($d1);
}

macro pop hl
{
	push8($e1);
}

macro pop ix
{
	push16le($e1dd);
}

macro pop iy
{
	push16le($e1fd);
}

macro push af
{
	push8($f5);
}

macro push bc
{
	push8($c5);
}

macro push de
{
	push8($d5);
}

macro push hl
{
	push8($e5);
}

macro push ix
{
	push16le($e5dd);
}

macro push iy
{
	push16le($e5fd);
}

macro res 0,(hl)
{
	push16le($86cb);
}

macro res 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($86);
}

macro res 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($86);
}

macro res 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($86);
}

macro res 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($86);
}

macro res 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($86);
}

macro res 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($86);
}

macro res 0,a
{
	push16le($87cb);
}

macro res 0,b
{
	push16le($80cb);
}

macro res 0,c
{
	push16le($81cb);
}

macro res 0,d
{
	push16le($82cb);
}

macro res 0,e
{
	push16le($83cb);
}

macro res 0,h
{
	push16le($84cb);
}

macro res 0,l
{
	push16le($85cb);
}

macro res 1,(hl)
{
	push16le($8ecb);
}

macro res 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($8e);
}

macro res 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($8e);
}

macro res 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($8e);
}

macro res 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($8e);
}

macro res 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($8e);
}

macro res 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($8e);
}

macro res 1,a
{
	push16le($8fcb);
}

macro res 1,b
{
	push16le($88cb);
}

macro res 1,c
{
	push16le($89cb);
}

macro res 1,d
{
	push16le($8acb);
}

macro res 1,e
{
	push16le($8bcb);
}

macro res 1,h
{
	push16le($8ccb);
}

macro res 1,l
{
	push16le($8dcb);
}

macro res 2,(hl)
{
	push16le($96cb);
}

macro res 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($96);
}

macro res 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($96);
}

macro res 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($96);
}

macro res 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($96);
}

macro res 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($96);
}

macro res 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($96);
}

macro res 2,a
{
	push16le($97cb);
}

macro res 2,b
{
	push16le($90cb);
}

macro res 2,c
{
	push16le($91cb);
}

macro res 2,d
{
	push16le($92cb);
}

macro res 2,e
{
	push16le($93cb);
}

macro res 2,h
{
	push16le($94cb);
}

macro res 2,l
{
	push16le($95cb);
}

macro res 3,(hl)
{
	push16le($9ecb);
}

macro res 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($9e);
}

macro res 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($9e);
}

macro res 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($9e);
}

macro res 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($9e);
}

macro res 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($9e);
}

macro res 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($9e);
}

macro res 3,a
{
	push16le($9fcb);
}

macro res 3,b
{
	push16le($98cb);
}

macro res 3,c
{
	push16le($99cb);
}

macro res 3,d
{
	push16le($9acb);
}

macro res 3,e
{
	push16le($9bcb);
}

macro res 3,h
{
	push16le($9ccb);
}

macro res 3,l
{
	push16le($9dcb);
}

macro res 4,(hl)
{
	push16le($a6cb);
}

macro res 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($a6);
}

macro res 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($a6);
}

macro res 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($a6);
}

macro res 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($a6);
}

macro res 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($a6);
}

macro res 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($a6);
}

macro res 4,a
{
	push16le($a7cb);
}

macro res 4,b
{
	push16le($a0cb);
}

macro res 4,c
{
	push16le($a1cb);
}

macro res 4,d
{
	push16le($a2cb);
}

macro res 4,e
{
	push16le($a3cb);
}

macro res 4,h
{
	push16le($a4cb);
}

macro res 4,l
{
	push16le($a5cb);
}

macro res 5,(hl)
{
	push16le($aecb);
}

macro res 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ae);
}

macro res 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ae);
}

macro res 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ae);
}

macro res 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ae);
}

macro res 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ae);
}

macro res 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ae);
}

macro res 5,a
{
	push16le($afcb);
}

macro res 5,b
{
	push16le($a8cb);
}

macro res 5,c
{
	push16le($a9cb);
}

macro res 5,d
{
	push16le($aacb);
}

macro res 5,e
{
	push16le($abcb);
}

macro res 5,h
{
	push16le($accb);
}

macro res 5,l
{
	push16le($adcb);
}

macro res 6,(hl)
{
	push16le($b6cb);
}

macro res 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($b6);
}

macro res 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($b6);
}

macro res 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($b6);
}

macro res 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($b6);
}

macro res 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($b6);
}

macro res 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($b6);
}

macro res 6,a
{
	push16le($b7cb);
}

macro res 6,b
{
	push16le($b0cb);
}

macro res 6,c
{
	push16le($b1cb);
}

macro res 6,d
{
	push16le($b2cb);
}

macro res 6,e
{
	push16le($b3cb);
}

macro res 6,h
{
	push16le($b4cb);
}

macro res 6,l
{
	push16le($b5cb);
}

macro res 7,(hl)
{
	push16le($becb);
}

macro res 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($be);
}

macro res 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($be);
}

macro res 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($be);
}

macro res 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($be);
}

macro res 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($be);
}

macro res 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($be);
}

macro res 7,a
{
	push16le($bfcb);
}

macro res 7,b
{
	push16le($b8cb);
}

macro res 7,c
{
	push16le($b9cb);
}

macro res 7,d
{
	push16le($bacb);
}

macro res 7,e
{
	push16le($bbcb);
}

macro res 7,h
{
	push16le($bccb);
}

macro res 7,l
{
	push16le($bdcb);
}

macro ret
{
	push8($c9);
}

macro ret c
{
	push8($d8);
}

macro ret m
{
	push8($f8);
}

macro ret nc
{
	push8($d0);
}

macro ret nz
{
	push8($c0);
}

macro ret p
{
	push8($f0);
}

macro ret pe
{
	push8($e8);
}

macro ret po
{
	push8($e0);
}

macro ret z
{
	push8($c8);
}

macro reti
{
	push16le($4ded);
}

macro retn
{
	push16le($45ed);
}

macro rl (hl)
{
	push16le($16cb);
}

macro rl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($16);
}

macro rl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($16);
}

macro rl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($16);
}

macro rl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($16);
}

macro rl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($16);
}

macro rl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($16);
}

macro rl a
{
	push16le($17cb);
}

macro rl b
{
	push16le($10cb);
}

macro rl c
{
	push16le($11cb);
}

macro rl d
{
	push16le($12cb);
}

macro rl e
{
	push16le($13cb);
}

macro rl h
{
	push16le($14cb);
}

macro rl l
{
	push16le($15cb);
}

macro rla
{
	push8($17);
}

macro rlc (hl)
{
	push16le($06cb);
}

macro rlc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($06);
}

macro rlc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($06);
}

macro rlc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($06);
}

macro rlc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($06);
}

macro rlc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($06);
}

macro rlc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($06);
}

macro rlc a
{
	push16le($07cb);
}

macro rlc b
{
	push16le($00cb);
}

macro rlc c
{
	push16le($01cb);
}

macro rlc d
{
	push16le($02cb);
}

macro rlc e
{
	push16le($03cb);
}

macro rlc h
{
	push16le($04cb);
}

macro rlc l
{
	push16le($05cb);
}

macro rlca
{
	push8($07);
}

macro rld
{
	push16le($6fed);
}

macro rr (hl)
{
	push16le($1ecb);
}

macro rr (ix)
{
	push16le($cbdd);
	push8($00);
	push8($1e);
}

macro rr (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($1e);
}

macro rr (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($1e);
}

macro rr (iy)
{
	push16le($cbfd);
	push8($00);
	push8($1e);
}

macro rr (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($1e);
}

macro rr (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($1e);
}

macro rr a
{
	push16le($1fcb);
}

macro rr b
{
	push16le($18cb);
}

macro rr c
{
	push16le($19cb);
}

macro rr d
{
	push16le($1acb);
}

macro rr e
{
	push16le($1bcb);
}

macro rr h
{
	push16le($1ccb);
}

macro rr l
{
	push16le($1dcb);
}

macro rra
{
	push8($1f);
}

macro rrc (hl)
{
	push16le($0ecb);
}

macro rrc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($0e);
}

macro rrc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($0e);
}

macro rrc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($0e);
}

macro rrc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($0e);
}

macro rrc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($0e);
}

macro rrc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($0e);
}

macro rrc a
{
	push16le($0fcb);
}

macro rrc b
{
	push16le($08cb);
}

macro rrc c
{
	push16le($09cb);
}

macro rrc d
{
	push16le($0acb);
}

macro rrc e
{
	push16le($0bcb);
}

macro rrc h
{
	push16le($0ccb);
}

macro rrc l
{
	push16le($0dcb);
}

macro rrca
{
	push8($0f);
}

macro rrd
{
	push16le($67ed);
}

macro sbc a,(hl)
{
	push8($9e);
}

macro sbc a,(ix)
{
	push16le($9edd);
	push8($00);
}

macro sbc a,(ix+@d)
{
	push16le($9edd);
	push8(c2sr<8>(d));
}

macro sbc a,(ix-@d)
{
	push16le($9edd);
	push8(c2sr<8>(-d));
}

macro sbc a,(iy)
{
	push16le($9efd);
	push8($00);
}

macro sbc a,(iy+@d)
{
	push16le($9efd);
	push8(c2sr<8>(d));
}

macro sbc a,(iy-@d)
{
	push16le($9efd);
	push8(c2sr<8>(-d));
}

macro sbc a,a
{
	push8($9f);
}

macro sbc a,b
{
	push8($98);
}

macro sbc a,c
{
	push8($99);
}

macro sbc a,d
{
	push8($9a);
}

macro sbc a,e
{
	push8($9b);
}

macro sbc a,h
{
	push8($9c);
}

macro sbc a,l
{
	push8($9d);
}

macro sbc a,@n
{
	push8($de);
	push8(n);
}

macro sbc hl,bc
{
	push16le($42ed);
}

macro sbc hl,de
{
	push16le($52ed);
}

macro sbc hl,hl
{
	push16le($62ed);
}

macro sbc hl,sp
{
	push16le($72ed);
}

macro scf
{
	push8($37);
}

macro set 0,(hl)
{
	push16le($c6cb);
}

macro set 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($c6);
}

macro set 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($c6);
}

macro set 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($c6);
}

macro set 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($c6);
}

macro set 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($c6);
}

macro set 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($c6);
}

macro set 0,a
{
	push16le($c7cb);
}

macro set 0,b
{
	push16le($c0cb);
}

macro set 0,c
{
	push16le($c1cb);
}

macro set 0,d
{
	push16le($c2cb);
}

macro set 0,e
{
	push16le($c3cb);
}

macro set 0,h
{
	push16le($c4cb);
}

macro set 0,l
{
	push16le($c5cb);
}

macro set 1,(hl)
{
	push16le($cecb);
}

macro set 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ce);
}

macro set 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ce);
}

macro set 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ce);
}

macro set 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ce);
}

macro set 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ce);
}

macro set 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ce);
}

macro set 1,a
{
	push16le($cfcb);
}

macro set 1,b
{
	push16le($c8cb);
}

macro set 1,c
{
	push16le($c9cb);
}

macro set 1,d
{
	push16le($cacb);
}

macro set 1,e
{
	push16le($cbcb);
}

macro set 1,h
{
	push16le($cccb);
}

macro set 1,l
{
	push16le($cdcb);
}

macro set 2,(hl)
{
	push16le($d6cb);
}

macro set 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($d6);
}

macro set 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($d6);
}

macro set 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($d6);
}

macro set 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($d6);
}

macro set 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($d6);
}

macro set 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($d6);
}

macro set 2,a
{
	push16le($d7cb);
}

macro set 2,b
{
	push16le($d0cb);
}

macro set 2,c
{
	push16le($d1cb);
}

macro set 2,d
{
	push16le($d2cb);
}

macro set 2,e
{
	push16le($d3cb);
}

macro set 2,h
{
	push16le($d4cb);
}

macro set 2,l
{
	push16le($d5cb);
}

macro set 3,(hl)
{
	push16le($decb);
}

macro set 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($de);
}

macro set 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($de);
}

macro set 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($de);
}

macro set 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($de);
}

macro set 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($de);
}

macro set 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($de);
}

macro set 3,a
{
	push16le($dfcb);
}

macro set 3,b
{
	push16le($d8cb);
}

macro set 3,c
{
	push16le($d9cb);
}

macro set 3,d
{
	push16le($dacb);
}

macro set 3,e
{
	push16le($dbcb);
}

macro set 3,h
{
	push16le($dccb);
}

macro set 3,l
{
	push16le($ddcb);
}

macro set 4,(hl)
{
	push16le($e6cb);
}

macro set 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($e6);
}

macro set 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($e6);
}

macro set 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($e6);
}

macro set 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($e6);
}

macro set 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($e6);
}

macro set 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($e6);
}

macro set 4,a
{
	push16le($e7cb);
}

macro set 4,b
{
	push16le($e0cb);
}

macro set 4,c
{
	push16le($e1cb);
}

macro set 4,d
{
	push16le($e2cb);
}

macro set 4,e
{
	push16le($e3cb);
}

macro set 4,h
{
	push16le($e4cb);
}

macro set 4,l
{
	push16le($e5cb);
}

macro set 5,(hl)
{
	push16le($eecb);
}

macro set 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ee);
}

macro set 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ee);
}

macro set 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ee);
}

macro set 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ee);
}

macro set 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ee);
}

macro set 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ee);
}

macro set 5,a
{
	push16le($efcb);
}

macro set 5,b
{
	push16le($e8cb);
}

macro set 5,c
{
	push16le($e9cb);
}

macro set 5,d
{
	push16le($eacb);
}

macro set 5,e
{
	push16le($ebcb);
}

macro set 5,h
{
	push16le($eccb);
}

macro set 5,l
{
	push16le($edcb);
}

macro set 6,(hl)
{
	push16le($f6cb);
}

macro set 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($f6);
}

macro set 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($f6);
}

macro set 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($f6);
}

macro set 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($f6);
}

macro set 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($f6);
}

macro set 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($f6);
}

macro set 6,a
{
	push16le($f7cb);
}

macro set 6,b
{
	push16le($f0cb);
}

macro set 6,c
{
	push16le($f1cb);
}

macro set 6,d
{
	push16le($f2cb);
}

macro set 6,e
{
	push16le($f3cb);
}

macro set 6,h
{
	push16le($f4cb);
}

macro set 6,l
{
	push16le($f5cb);
}

macro set 7,(hl)
{
	push16le($fecb);
}

macro set 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($fe);
}

macro set 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($fe);
}

macro set 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($fe);
}

macro set 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($fe);
}

macro set 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($fe);
}

macro set 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($fe);
}

macro set 7,a
{
	push16le($ffcb);
}

macro set 7,b
{
	push16le($f8cb);
}

macro set 7,c
{
	push16le($f9cb);
}

macro set 7,d
{
	push16le($facb);
}

macro set 7,e
{
	push16le($fbcb);
}

macro set 7,h
{
	push16le($fccb);
}

macro set 7,l
{
	push16le($fdcb);
}

macro sla (hl)
{
	push16le($26cb);
}

macro sla (ix)
{
	push16le($cbdd);
	push8($00);
	push8($26);
}

macro sla (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($26);
}

macro sla (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($26);
}

macro sla (iy)
{
	push16le($cbfd);
	push8($00);
	push8($26);
}

macro sla (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($26);
}

macro sla (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($26);
}

macro sla a
{
	push16le($27cb);
}

macro sla b
{
	push16le($20cb);
}

macro sla c
{
	push16le($21cb);
}

macro sla d
{
	push16le($22cb);
}

macro sla e
{
	push16le($23cb);
}

macro sla h
{
	push16le($24cb);
}

macro sla l
{
	push16le($25cb);
}

macro sra (hl)
{
	push16le($2ecb);
}

macro sra (ix)
{
	push16le($cbdd);
	push8($00);
	push8($2e);
}

macro sra (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($2e);
}

macro sra (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($2e);
}

macro sra (iy)
{
	push16le($cbfd);
	push8($00);
	push8($2e);
}

macro sra (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($2e);
}

macro sra (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($2e);
}

macro sra a
{
	push16le($2fcb);
}

macro sra b
{
	push16le($28cb);
}

macro sra c
{
	push16le($29cb);
}

macro sra d
{
	push16le($2acb);
}

macro sra e
{
	push16le($2bcb);
}

macro sra h
{
	push16le($2ccb);
}

macro sra l
{
	push16le($2dcb);
}

macro srl (hl)
{
	push16le($3ecb);
}

macro srl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($3e);
}

macro srl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($3e);
}

macro srl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($3e);
}

macro srl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($3e);
}

macro srl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($3e);
}

macro srl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($3e);
}

macro srl a
{
	push16le($3fcb);
}

macro srl b
{
	push16le($38cb);
}

macro srl c
{
	push16le($39cb);
}

macro srl d
{
	push16le($3acb);
}

macro srl e
{
	push16le($3bcb);
}

macro srl h
{
	push16le($3ccb);
}

macro srl l
{
	push16le($3dcb);
}

macro sub (hl)
{
	push8($96);
}

macro sub (ix)
{
	push16le($96dd);
	push8($00);
}

macro sub (ix+@d)
{
	push16le($96dd);
	push8(c2sr<8>(d));
}

macro sub (ix-@d)
{
	push16le($96dd);
	push8(c2sr<8>(-d));
}

macro sub (iy)
{
	push16le($96fd);
	push8($00);
}

macro sub (iy+@d)
{
	push16le($96fd);
	push8(c2sr<8>(d));
}

macro sub (iy-@d)
{
	push16le($96fd);
	push8(c2sr<8>(-d));
}

macro sub a
{
	push8($97);
}

macro sub b
{
	push8($90);
}

macro sub c
{
	push8($91);
}

macro sub d
{
	push8($92);
}

macro sub e
{
	push8($93);
}

macro sub h
{
	push8($94);
}

macro sub l
{
	push8($95);
}

macro sub @n
{
	push8($d6);
	push8(n);
}

macro xor (hl)
{
	push8($ae);
}

macro xor (ix)
{
	push16le($aedd);
	push8($00);
}

macro xor (ix+@d)
{
	push16le($aedd);
	push8(c2sr<8>(d));
}

macro xor (ix-@d)
{
	push16le($aedd);
	push8(c2sr<8>(-d));
}

macro xor (iy)
{
	push16le($aefd);
	push8($00);
}

macro xor (iy+@d)
{
	push16le($aefd);
	push8(c2sr<8>(d));
}

macro xor (iy-@d)
{
	push16le($aefd);
	push8(c2sr<8>(-d));
}

macro xor a
{
	push8($af);
}

macro xor b
{
	push8($a8);
}

macro xor c
{
	push8($a9);
}

macro xor d
{
	push8($aa);
}

macro xor e
{
	push8($ab);
}

macro xor h
{
	push8($ac);
}

macro xor l
{
	push8($ad);
}

macro xor @n
{
	push8($ee);
	push8(n);
}

macro rst @n
{
    switch(n)
    {
        case $0:
            push8($c7);
            break;
        case $8:
            push8($cf);
            break;
        case $10:
            push8($d7);
            break;
        case $18:
            push8($df);
            break;
        case $20:
            push8($e7);
            break;
        case $28:
            push8($ef);
            break;
        case $30:
            push8($f7);
            break;
        case $38:
            push8($ff);
            break;
        default:
            c2_error("Invalid rst parameter");
            break;
    }
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
