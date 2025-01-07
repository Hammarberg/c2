/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/zilog/z80.s"

#define C2_Z80_UNDOCUMENTED

macro adc a,ixh
{
	push16le($8cdd);
}

macro adc a,ixl
{
	push16le($8ddd);
}

macro adc a,iyh
{
	push16le($8cfd);
}

macro adc a,iyl
{
	push16le($8dfd);
}

macro add a,ixh
{
	push16le($84dd);
}

macro add a,ixl
{
	push16le($85dd);
}

macro add a,iyh
{
	push16le($84fd);
}

macro add a,iyl
{
	push16le($85fd);
}

macro and ixh
{
	push16le($a4dd);
}

macro and ixl
{
	push16le($a5dd);
}

macro and iyh
{
	push16le($a4fd);
}

macro and iyl
{
	push16le($a5fd);
}

macro bit 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($40);
}

macro bit 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($40);
}

macro bit 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($40);
}

macro bit 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($40);
}

macro bit 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($40);
}

macro bit 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($40);
}

macro bit 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($48);
}

macro bit 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($48);
}

macro bit 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($48);
}

macro bit 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($48);
}

macro bit 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($48);
}

macro bit 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($48);
}

macro bit 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($50);
}

macro bit 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($50);
}

macro bit 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($50);
}

macro bit 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($50);
}

macro bit 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($50);
}

macro bit 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($50);
}

macro bit 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($58);
}

macro bit 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($58);
}

macro bit 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($58);
}

macro bit 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($58);
}

macro bit 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($58);
}

macro bit 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($58);
}

macro bit 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($60);
}

macro bit 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($60);
}

macro bit 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($60);
}

macro bit 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($60);
}

macro bit 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($60);
}

macro bit 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($60);
}

macro bit 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($68);
}

macro bit 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($68);
}

macro bit 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($68);
}

macro bit 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($68);
}

macro bit 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($68);
}

macro bit 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($68);
}

macro bit 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($70);
}

macro bit 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($70);
}

macro bit 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($70);
}

macro bit 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($70);
}

macro bit 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($70);
}

macro bit 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($70);
}

macro bit 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($78);
}

macro bit 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($78);
}

macro bit 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($78);
}

macro bit 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($78);
}

macro bit 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($78);
}

macro bit 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($78);
}

macro bit2 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($41);
}

macro bit2 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($41);
}

macro bit2 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($41);
}

macro bit2 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($41);
}

macro bit2 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($41);
}

macro bit2 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($41);
}

macro bit2 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($49);
}

macro bit2 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($49);
}

macro bit2 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($49);
}

macro bit2 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($49);
}

macro bit2 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($49);
}

macro bit2 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($49);
}

macro bit2 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($51);
}

macro bit2 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($51);
}

macro bit2 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($51);
}

macro bit2 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($51);
}

macro bit2 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($51);
}

macro bit2 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($51);
}

macro bit2 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($59);
}

macro bit2 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($59);
}

macro bit2 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($59);
}

macro bit2 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($59);
}

macro bit2 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($59);
}

macro bit2 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($59);
}

macro bit2 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($61);
}

macro bit2 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($61);
}

macro bit2 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($61);
}

macro bit2 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($61);
}

macro bit2 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($61);
}

macro bit2 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($61);
}

macro bit2 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($69);
}

macro bit2 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($69);
}

macro bit2 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($69);
}

macro bit2 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($69);
}

macro bit2 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($69);
}

macro bit2 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($69);
}

macro bit2 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($71);
}

macro bit2 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($71);
}

macro bit2 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($71);
}

macro bit2 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($71);
}

macro bit2 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($71);
}

macro bit2 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($71);
}

macro bit2 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($79);
}

macro bit2 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($79);
}

macro bit2 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($79);
}

macro bit2 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($79);
}

macro bit2 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($79);
}

macro bit2 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($79);
}

macro bit3 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($42);
}

macro bit3 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($42);
}

macro bit3 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($42);
}

macro bit3 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($42);
}

macro bit3 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($42);
}

macro bit3 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($42);
}

macro bit3 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($4a);
}

macro bit3 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($4a);
}

macro bit3 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($4a);
}

macro bit3 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($4a);
}

macro bit3 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($4a);
}

macro bit3 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($4a);
}

macro bit3 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($52);
}

macro bit3 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($52);
}

macro bit3 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($52);
}

macro bit3 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($52);
}

macro bit3 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($52);
}

macro bit3 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($52);
}

macro bit3 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($5a);
}

macro bit3 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($5a);
}

macro bit3 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($5a);
}

macro bit3 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($5a);
}

macro bit3 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($5a);
}

macro bit3 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($5a);
}

macro bit3 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($62);
}

macro bit3 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($62);
}

macro bit3 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($62);
}

macro bit3 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($62);
}

macro bit3 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($62);
}

macro bit3 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($62);
}

macro bit3 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($6a);
}

macro bit3 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($6a);
}

macro bit3 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($6a);
}

macro bit3 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($6a);
}

macro bit3 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($6a);
}

macro bit3 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($6a);
}

macro bit3 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($72);
}

macro bit3 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($72);
}

macro bit3 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($72);
}

macro bit3 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($72);
}

macro bit3 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($72);
}

macro bit3 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($72);
}

macro bit3 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($7a);
}

macro bit3 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($7a);
}

macro bit3 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($7a);
}

macro bit3 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($7a);
}

macro bit3 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($7a);
}

macro bit3 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($7a);
}

macro bit4 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($43);
}

macro bit4 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($43);
}

macro bit4 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($43);
}

macro bit4 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($43);
}

macro bit4 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($43);
}

macro bit4 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($43);
}

macro bit4 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($4b);
}

macro bit4 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($4b);
}

macro bit4 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($4b);
}

macro bit4 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($4b);
}

macro bit4 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($4b);
}

macro bit4 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($4b);
}

macro bit4 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($53);
}

macro bit4 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($53);
}

macro bit4 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($53);
}

macro bit4 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($53);
}

macro bit4 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($53);
}

macro bit4 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($53);
}

macro bit4 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($5b);
}

macro bit4 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($5b);
}

macro bit4 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($5b);
}

macro bit4 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($5b);
}

macro bit4 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($5b);
}

macro bit4 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($5b);
}

macro bit4 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($63);
}

macro bit4 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($63);
}

macro bit4 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($63);
}

macro bit4 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($63);
}

macro bit4 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($63);
}

macro bit4 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($63);
}

macro bit4 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($6b);
}

macro bit4 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($6b);
}

macro bit4 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($6b);
}

macro bit4 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($6b);
}

macro bit4 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($6b);
}

macro bit4 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($6b);
}

macro bit4 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($73);
}

macro bit4 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($73);
}

macro bit4 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($73);
}

macro bit4 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($73);
}

macro bit4 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($73);
}

macro bit4 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($73);
}

macro bit4 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($7b);
}

macro bit4 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($7b);
}

macro bit4 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($7b);
}

macro bit4 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($7b);
}

macro bit4 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($7b);
}

macro bit4 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($7b);
}

macro bit5 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($44);
}

macro bit5 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($44);
}

macro bit5 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($44);
}

macro bit5 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($44);
}

macro bit5 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($44);
}

macro bit5 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($44);
}

macro bit5 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($4c);
}

macro bit5 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($4c);
}

macro bit5 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($4c);
}

macro bit5 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($4c);
}

macro bit5 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($4c);
}

macro bit5 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($4c);
}

macro bit5 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($54);
}

macro bit5 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($54);
}

macro bit5 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($54);
}

macro bit5 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($54);
}

macro bit5 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($54);
}

macro bit5 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($54);
}

macro bit5 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($5c);
}

macro bit5 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($5c);
}

macro bit5 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($5c);
}

macro bit5 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($5c);
}

macro bit5 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($5c);
}

macro bit5 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($5c);
}

macro bit5 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($64);
}

macro bit5 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($64);
}

macro bit5 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($64);
}

macro bit5 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($64);
}

macro bit5 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($64);
}

macro bit5 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($64);
}

macro bit5 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($6c);
}

macro bit5 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($6c);
}

macro bit5 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($6c);
}

macro bit5 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($6c);
}

macro bit5 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($6c);
}

macro bit5 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($6c);
}

macro bit5 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($74);
}

macro bit5 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($74);
}

macro bit5 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($74);
}

macro bit5 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($74);
}

macro bit5 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($74);
}

macro bit5 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($74);
}

macro bit5 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($7c);
}

macro bit5 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($7c);
}

macro bit5 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($7c);
}

macro bit5 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($7c);
}

macro bit5 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($7c);
}

macro bit5 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($7c);
}

macro bit6 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($45);
}

macro bit6 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($45);
}

macro bit6 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($45);
}

macro bit6 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($45);
}

macro bit6 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($45);
}

macro bit6 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($45);
}

macro bit6 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($4d);
}

macro bit6 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($4d);
}

macro bit6 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($4d);
}

macro bit6 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($4d);
}

macro bit6 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($4d);
}

macro bit6 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($4d);
}

macro bit6 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($55);
}

macro bit6 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($55);
}

macro bit6 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($55);
}

macro bit6 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($55);
}

macro bit6 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($55);
}

macro bit6 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($55);
}

macro bit6 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($5d);
}

macro bit6 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($5d);
}

macro bit6 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($5d);
}

macro bit6 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($5d);
}

macro bit6 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($5d);
}

macro bit6 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($5d);
}

macro bit6 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($65);
}

macro bit6 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($65);
}

macro bit6 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($65);
}

macro bit6 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($65);
}

macro bit6 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($65);
}

macro bit6 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($65);
}

macro bit6 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($6d);
}

macro bit6 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($6d);
}

macro bit6 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($6d);
}

macro bit6 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($6d);
}

macro bit6 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($6d);
}

macro bit6 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($6d);
}

macro bit6 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($75);
}

macro bit6 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($75);
}

macro bit6 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($75);
}

macro bit6 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($75);
}

macro bit6 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($75);
}

macro bit6 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($75);
}

macro bit6 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($7d);
}

macro bit6 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($7d);
}

macro bit6 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($7d);
}

macro bit6 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($7d);
}

macro bit6 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($7d);
}

macro bit6 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($7d);
}

macro bit7 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($47);
}

macro bit7 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($47);
}

macro bit7 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($47);
}

macro bit7 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($47);
}

macro bit7 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($47);
}

macro bit7 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($47);
}

macro bit7 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($4f);
}

macro bit7 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($4f);
}

macro bit7 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($4f);
}

macro bit7 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($4f);
}

macro bit7 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($4f);
}

macro bit7 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($4f);
}

macro bit7 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($57);
}

macro bit7 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($57);
}

macro bit7 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($57);
}

macro bit7 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($57);
}

macro bit7 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($57);
}

macro bit7 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($57);
}

macro bit7 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($5f);
}

macro bit7 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($5f);
}

macro bit7 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($5f);
}

macro bit7 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($5f);
}

macro bit7 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($5f);
}

macro bit7 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($5f);
}

macro bit7 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($67);
}

macro bit7 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($67);
}

macro bit7 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($67);
}

macro bit7 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($67);
}

macro bit7 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($67);
}

macro bit7 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($67);
}

macro bit7 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($6f);
}

macro bit7 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($6f);
}

macro bit7 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($6f);
}

macro bit7 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($6f);
}

macro bit7 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($6f);
}

macro bit7 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($6f);
}

macro bit7 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($77);
}

macro bit7 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($77);
}

macro bit7 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($77);
}

macro bit7 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($77);
}

macro bit7 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($77);
}

macro bit7 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($77);
}

macro bit7 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($7f);
}

macro bit7 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($7f);
}

macro bit7 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($7f);
}

macro bit7 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($7f);
}

macro bit7 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($7f);
}

macro bit7 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($7f);
}

macro cp ixh
{
	push16le($bcdd);
}

macro cp ixl
{
	push16le($bddd);
}

macro cp iyh
{
	push16le($bcfd);
}

macro cp iyl
{
	push16le($bdfd);
}

macro dec ixh
{
	push16le($25dd);
}

macro dec ixl
{
	push16le($2ddd);
}

macro dec iyh
{
	push16le($25fd);
}

macro dec iyl
{
	push16le($2dfd);
}

macro im 0
{
	push16le($66ed);
}

macro im 0/1
{
	push16le($4eed);
}

macro im 1
{
	push16le($76ed);
}

macro im 2
{
	push16le($7eed);
}

macro im2 0/1
{
	push16le($6eed);
}

macro in (c)
{
	push16le($70ed);
}

macro in f,(c)
{
	push16le($70ed);
}

macro inc ixh
{
	push16le($24dd);
}

macro inc ixl
{
	push16le($2cdd);
}

macro inc iyh
{
	push16le($24fd);
}

macro inc iyl
{
	push16le($2cfd);
}

macro ld a,ixh
{
	push16le($7cdd);
}

macro ld a,ixl
{
	push16le($7ddd);
}

macro ld a,iyh
{
	push16le($7cfd);
}

macro ld a,iyl
{
	push16le($7dfd);
}

macro ld a,res 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($87);
}

macro ld a,res 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($87);
}

macro ld a,res 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($87);
}

macro ld a,res 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($87);
}

macro ld a,res 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($87);
}

macro ld a,res 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($87);
}

macro ld a,res 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($8f);
}

macro ld a,res 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($8f);
}

macro ld a,res 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($8f);
}

macro ld a,res 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($8f);
}

macro ld a,res 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($8f);
}

macro ld a,res 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($8f);
}

macro ld a,res 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($97);
}

macro ld a,res 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($97);
}

macro ld a,res 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($97);
}

macro ld a,res 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($97);
}

macro ld a,res 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($97);
}

macro ld a,res 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($97);
}

macro ld a,res 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($9f);
}

macro ld a,res 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($9f);
}

macro ld a,res 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($9f);
}

macro ld a,res 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($9f);
}

macro ld a,res 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($9f);
}

macro ld a,res 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($9f);
}

macro ld a,res 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($a7);
}

macro ld a,res 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($a7);
}

macro ld a,res 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($a7);
}

macro ld a,res 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($a7);
}

macro ld a,res 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($a7);
}

macro ld a,res 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($a7);
}

macro ld a,res 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($af);
}

macro ld a,res 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($af);
}

macro ld a,res 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($af);
}

macro ld a,res 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($af);
}

macro ld a,res 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($af);
}

macro ld a,res 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($af);
}

macro ld a,res 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($b7);
}

macro ld a,res 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($b7);
}

macro ld a,res 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($b7);
}

macro ld a,res 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($b7);
}

macro ld a,res 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($b7);
}

macro ld a,res 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($b7);
}

macro ld a,res 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($bf);
}

macro ld a,res 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($bf);
}

macro ld a,res 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($bf);
}

macro ld a,res 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($bf);
}

macro ld a,res 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($bf);
}

macro ld a,res 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($bf);
}

macro ld a,rl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($17);
}

macro ld a,rl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($17);
}

macro ld a,rl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($17);
}

macro ld a,rl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($17);
}

macro ld a,rl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($17);
}

macro ld a,rl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($17);
}

macro ld a,rlc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($07);
}

macro ld a,rlc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($07);
}

macro ld a,rlc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($07);
}

macro ld a,rlc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($07);
}

macro ld a,rlc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($07);
}

macro ld a,rlc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($07);
}

macro ld a,rr (ix)
{
	push16le($cbdd);
	push8($00);
	push8($1f);
}

macro ld a,rr (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($1f);
}

macro ld a,rr (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($1f);
}

macro ld a,rr (iy)
{
	push16le($cbfd);
	push8($00);
	push8($1f);
}

macro ld a,rr (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($1f);
}

macro ld a,rr (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($1f);
}

macro ld a,rrc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($0f);
}

macro ld a,rrc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($0f);
}

macro ld a,rrc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($0f);
}

macro ld a,rrc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($0f);
}

macro ld a,rrc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($0f);
}

macro ld a,rrc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($0f);
}

macro ld a,set 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($c7);
}

macro ld a,set 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($c7);
}

macro ld a,set 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($c7);
}

macro ld a,set 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($c7);
}

macro ld a,set 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($c7);
}

macro ld a,set 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($c7);
}

macro ld a,set 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($cf);
}

macro ld a,set 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($cf);
}

macro ld a,set 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($cf);
}

macro ld a,set 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($cf);
}

macro ld a,set 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($cf);
}

macro ld a,set 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($cf);
}

macro ld a,set 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($d7);
}

macro ld a,set 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($d7);
}

macro ld a,set 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($d7);
}

macro ld a,set 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($d7);
}

macro ld a,set 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($d7);
}

macro ld a,set 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($d7);
}

macro ld a,set 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($df);
}

macro ld a,set 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($df);
}

macro ld a,set 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($df);
}

macro ld a,set 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($df);
}

macro ld a,set 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($df);
}

macro ld a,set 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($df);
}

macro ld a,set 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($e7);
}

macro ld a,set 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($e7);
}

macro ld a,set 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($e7);
}

macro ld a,set 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($e7);
}

macro ld a,set 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($e7);
}

macro ld a,set 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($e7);
}

macro ld a,set 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ef);
}

macro ld a,set 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ef);
}

macro ld a,set 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ef);
}

macro ld a,set 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ef);
}

macro ld a,set 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ef);
}

macro ld a,set 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ef);
}

macro ld a,set 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($f7);
}

macro ld a,set 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($f7);
}

macro ld a,set 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($f7);
}

macro ld a,set 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($f7);
}

macro ld a,set 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($f7);
}

macro ld a,set 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($f7);
}

macro ld a,set 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ff);
}

macro ld a,set 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ff);
}

macro ld a,set 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ff);
}

macro ld a,set 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ff);
}

macro ld a,set 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ff);
}

macro ld a,set 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ff);
}

macro ld a,sla (ix)
{
	push16le($cbdd);
	push8($00);
	push8($27);
}

macro ld a,sla (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($27);
}

macro ld a,sla (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($27);
}

macro ld a,sla (iy)
{
	push16le($cbfd);
	push8($00);
	push8($27);
}

macro ld a,sla (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($27);
}

macro ld a,sla (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($27);
}

macro ld a,sll (ix)
{
	push16le($cbdd);
	push8($00);
	push8($37);
}

macro ld a,sll (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($37);
}

macro ld a,sll (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($37);
}

macro ld a,sll (iy)
{
	push16le($cbfd);
	push8($00);
	push8($37);
}

macro ld a,sll (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($37);
}

macro ld a,sll (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($37);
}

macro ld a,sra (ix)
{
	push16le($cbdd);
	push8($00);
	push8($2f);
}

macro ld a,sra (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($2f);
}

macro ld a,sra (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($2f);
}

macro ld a,sra (iy)
{
	push16le($cbfd);
	push8($00);
	push8($2f);
}

macro ld a,sra (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($2f);
}

macro ld a,sra (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($2f);
}

macro ld a,srl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($3f);
}

macro ld a,srl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($3f);
}

macro ld a,srl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($3f);
}

macro ld a,srl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($3f);
}

macro ld a,srl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($3f);
}

macro ld a,srl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($3f);
}

macro ld b,ixh
{
	push16le($44dd);
}

macro ld b,ixl
{
	push16le($45dd);
}

macro ld b,iyh
{
	push16le($44fd);
}

macro ld b,iyl
{
	push16le($45fd);
}

macro ld b,res 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($80);
}

macro ld b,res 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($80);
}

macro ld b,res 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($80);
}

macro ld b,res 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($80);
}

macro ld b,res 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($80);
}

macro ld b,res 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($80);
}

macro ld b,res 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($88);
}

macro ld b,res 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($88);
}

macro ld b,res 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($88);
}

macro ld b,res 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($88);
}

macro ld b,res 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($88);
}

macro ld b,res 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($88);
}

macro ld b,res 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($90);
}

macro ld b,res 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($90);
}

macro ld b,res 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($90);
}

macro ld b,res 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($90);
}

macro ld b,res 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($90);
}

macro ld b,res 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($90);
}

macro ld b,res 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($98);
}

macro ld b,res 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($98);
}

macro ld b,res 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($98);
}

macro ld b,res 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($98);
}

macro ld b,res 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($98);
}

macro ld b,res 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($98);
}

macro ld b,res 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($a0);
}

macro ld b,res 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($a0);
}

macro ld b,res 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($a0);
}

macro ld b,res 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($a0);
}

macro ld b,res 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($a0);
}

macro ld b,res 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($a0);
}

macro ld b,res 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($a8);
}

macro ld b,res 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($a8);
}

macro ld b,res 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($a8);
}

macro ld b,res 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($a8);
}

macro ld b,res 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($a8);
}

macro ld b,res 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($a8);
}

macro ld b,res 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($b0);
}

macro ld b,res 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($b0);
}

macro ld b,res 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($b0);
}

macro ld b,res 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($b0);
}

macro ld b,res 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($b0);
}

macro ld b,res 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($b0);
}

macro ld b,res 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($b8);
}

macro ld b,res 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($b8);
}

macro ld b,res 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($b8);
}

macro ld b,res 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($b8);
}

macro ld b,res 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($b8);
}

macro ld b,res 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($b8);
}

macro ld b,rl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($10);
}

macro ld b,rl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($10);
}

macro ld b,rl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($10);
}

macro ld b,rl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($10);
}

macro ld b,rl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($10);
}

macro ld b,rl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($10);
}

macro ld b,rlc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($00);
}

macro ld b,rlc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($00);
}

macro ld b,rlc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($00);
}

macro ld b,rlc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($00);
}

macro ld b,rlc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($00);
}

macro ld b,rlc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($00);
}

macro ld b,rr (ix)
{
	push16le($cbdd);
	push8($00);
	push8($18);
}

macro ld b,rr (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($18);
}

macro ld b,rr (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($18);
}

macro ld b,rr (iy)
{
	push16le($cbfd);
	push8($00);
	push8($18);
}

macro ld b,rr (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($18);
}

macro ld b,rr (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($18);
}

macro ld b,rrc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($08);
}

macro ld b,rrc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($08);
}

macro ld b,rrc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($08);
}

macro ld b,rrc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($08);
}

macro ld b,rrc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($08);
}

macro ld b,rrc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($08);
}

macro ld b,set 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($c0);
}

macro ld b,set 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($c0);
}

macro ld b,set 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($c0);
}

macro ld b,set 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($c0);
}

macro ld b,set 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($c0);
}

macro ld b,set 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($c0);
}

macro ld b,set 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($c8);
}

macro ld b,set 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($c8);
}

macro ld b,set 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($c8);
}

macro ld b,set 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($c8);
}

macro ld b,set 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($c8);
}

macro ld b,set 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($c8);
}

macro ld b,set 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($d0);
}

macro ld b,set 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($d0);
}

macro ld b,set 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($d0);
}

macro ld b,set 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($d0);
}

macro ld b,set 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($d0);
}

macro ld b,set 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($d0);
}

macro ld b,set 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($d8);
}

macro ld b,set 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($d8);
}

macro ld b,set 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($d8);
}

macro ld b,set 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($d8);
}

macro ld b,set 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($d8);
}

macro ld b,set 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($d8);
}

macro ld b,set 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($e0);
}

macro ld b,set 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($e0);
}

macro ld b,set 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($e0);
}

macro ld b,set 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($e0);
}

macro ld b,set 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($e0);
}

macro ld b,set 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($e0);
}

macro ld b,set 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($e8);
}

macro ld b,set 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($e8);
}

macro ld b,set 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($e8);
}

macro ld b,set 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($e8);
}

macro ld b,set 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($e8);
}

macro ld b,set 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($e8);
}

macro ld b,set 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($f0);
}

macro ld b,set 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($f0);
}

macro ld b,set 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($f0);
}

macro ld b,set 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($f0);
}

macro ld b,set 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($f0);
}

macro ld b,set 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($f0);
}

macro ld b,set 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($f8);
}

macro ld b,set 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($f8);
}

macro ld b,set 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($f8);
}

macro ld b,set 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($f8);
}

macro ld b,set 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($f8);
}

macro ld b,set 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($f8);
}

macro ld b,sla (ix)
{
	push16le($cbdd);
	push8($00);
	push8($20);
}

macro ld b,sla (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($20);
}

macro ld b,sla (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($20);
}

macro ld b,sla (iy)
{
	push16le($cbfd);
	push8($00);
	push8($20);
}

macro ld b,sla (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($20);
}

macro ld b,sla (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($20);
}

macro ld b,sll (ix)
{
	push16le($cbdd);
	push8($00);
	push8($30);
}

macro ld b,sll (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($30);
}

macro ld b,sll (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($30);
}

macro ld b,sll (iy)
{
	push16le($cbfd);
	push8($00);
	push8($30);
}

macro ld b,sll (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($30);
}

macro ld b,sll (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($30);
}

macro ld b,sra (ix)
{
	push16le($cbdd);
	push8($00);
	push8($28);
}

macro ld b,sra (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($28);
}

macro ld b,sra (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($28);
}

macro ld b,sra (iy)
{
	push16le($cbfd);
	push8($00);
	push8($28);
}

macro ld b,sra (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($28);
}

macro ld b,sra (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($28);
}

macro ld b,srl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($38);
}

macro ld b,srl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($38);
}

macro ld b,srl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($38);
}

macro ld b,srl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($38);
}

macro ld b,srl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($38);
}

macro ld b,srl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($38);
}

macro ld c,ixh
{
	push16le($4cdd);
}

macro ld c,ixl
{
	push16le($4ddd);
}

macro ld c,iyh
{
	push16le($4cfd);
}

macro ld c,iyl
{
	push16le($4dfd);
}

macro ld c,res 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($81);
}

macro ld c,res 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($81);
}

macro ld c,res 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($81);
}

macro ld c,res 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($81);
}

macro ld c,res 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($81);
}

macro ld c,res 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($81);
}

macro ld c,res 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($89);
}

macro ld c,res 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($89);
}

macro ld c,res 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($89);
}

macro ld c,res 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($89);
}

macro ld c,res 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($89);
}

macro ld c,res 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($89);
}

macro ld c,res 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($91);
}

macro ld c,res 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($91);
}

macro ld c,res 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($91);
}

macro ld c,res 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($91);
}

macro ld c,res 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($91);
}

macro ld c,res 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($91);
}

macro ld c,res 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($99);
}

macro ld c,res 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($99);
}

macro ld c,res 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($99);
}

macro ld c,res 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($99);
}

macro ld c,res 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($99);
}

macro ld c,res 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($99);
}

macro ld c,res 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($a1);
}

macro ld c,res 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($a1);
}

macro ld c,res 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($a1);
}

macro ld c,res 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($a1);
}

macro ld c,res 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($a1);
}

macro ld c,res 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($a1);
}

macro ld c,res 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($a9);
}

macro ld c,res 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($a9);
}

macro ld c,res 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($a9);
}

macro ld c,res 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($a9);
}

macro ld c,res 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($a9);
}

macro ld c,res 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($a9);
}

macro ld c,res 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($b1);
}

macro ld c,res 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($b1);
}

macro ld c,res 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($b1);
}

macro ld c,res 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($b1);
}

macro ld c,res 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($b1);
}

macro ld c,res 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($b1);
}

macro ld c,res 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($b9);
}

macro ld c,res 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($b9);
}

macro ld c,res 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($b9);
}

macro ld c,res 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($b9);
}

macro ld c,res 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($b9);
}

macro ld c,res 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($b9);
}

macro ld c,rl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($11);
}

macro ld c,rl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($11);
}

macro ld c,rl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($11);
}

macro ld c,rl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($11);
}

macro ld c,rl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($11);
}

macro ld c,rl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($11);
}

macro ld c,rlc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($01);
}

macro ld c,rlc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($01);
}

macro ld c,rlc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($01);
}

macro ld c,rlc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($01);
}

macro ld c,rlc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($01);
}

macro ld c,rlc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($01);
}

macro ld c,rr (ix)
{
	push16le($cbdd);
	push8($00);
	push8($19);
}

macro ld c,rr (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($19);
}

macro ld c,rr (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($19);
}

macro ld c,rr (iy)
{
	push16le($cbfd);
	push8($00);
	push8($19);
}

macro ld c,rr (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($19);
}

macro ld c,rr (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($19);
}

macro ld c,rrc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($09);
}

macro ld c,rrc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($09);
}

macro ld c,rrc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($09);
}

macro ld c,rrc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($09);
}

macro ld c,rrc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($09);
}

macro ld c,rrc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($09);
}

macro ld c,set 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($c1);
}

macro ld c,set 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($c1);
}

macro ld c,set 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($c1);
}

macro ld c,set 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($c1);
}

macro ld c,set 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($c1);
}

macro ld c,set 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($c1);
}

macro ld c,set 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($c9);
}

macro ld c,set 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($c9);
}

macro ld c,set 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($c9);
}

macro ld c,set 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($c9);
}

macro ld c,set 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($c9);
}

macro ld c,set 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($c9);
}

macro ld c,set 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($d1);
}

macro ld c,set 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($d1);
}

macro ld c,set 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($d1);
}

macro ld c,set 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($d1);
}

macro ld c,set 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($d1);
}

macro ld c,set 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($d1);
}

macro ld c,set 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($d9);
}

macro ld c,set 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($d9);
}

macro ld c,set 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($d9);
}

macro ld c,set 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($d9);
}

macro ld c,set 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($d9);
}

macro ld c,set 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($d9);
}

macro ld c,set 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($e1);
}

macro ld c,set 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($e1);
}

macro ld c,set 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($e1);
}

macro ld c,set 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($e1);
}

macro ld c,set 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($e1);
}

macro ld c,set 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($e1);
}

macro ld c,set 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($e9);
}

macro ld c,set 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($e9);
}

macro ld c,set 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($e9);
}

macro ld c,set 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($e9);
}

macro ld c,set 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($e9);
}

macro ld c,set 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($e9);
}

macro ld c,set 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($f1);
}

macro ld c,set 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($f1);
}

macro ld c,set 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($f1);
}

macro ld c,set 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($f1);
}

macro ld c,set 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($f1);
}

macro ld c,set 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($f1);
}

macro ld c,set 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($f9);
}

macro ld c,set 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($f9);
}

macro ld c,set 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($f9);
}

macro ld c,set 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($f9);
}

macro ld c,set 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($f9);
}

macro ld c,set 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($f9);
}

macro ld c,sla (ix)
{
	push16le($cbdd);
	push8($00);
	push8($21);
}

macro ld c,sla (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($21);
}

macro ld c,sla (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($21);
}

macro ld c,sla (iy)
{
	push16le($cbfd);
	push8($00);
	push8($21);
}

macro ld c,sla (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($21);
}

macro ld c,sla (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($21);
}

macro ld c,sll (ix)
{
	push16le($cbdd);
	push8($00);
	push8($31);
}

macro ld c,sll (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($31);
}

macro ld c,sll (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($31);
}

macro ld c,sll (iy)
{
	push16le($cbfd);
	push8($00);
	push8($31);
}

macro ld c,sll (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($31);
}

macro ld c,sll (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($31);
}

macro ld c,sra (ix)
{
	push16le($cbdd);
	push8($00);
	push8($29);
}

macro ld c,sra (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($29);
}

macro ld c,sra (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($29);
}

macro ld c,sra (iy)
{
	push16le($cbfd);
	push8($00);
	push8($29);
}

macro ld c,sra (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($29);
}

macro ld c,sra (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($29);
}

macro ld c,srl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($39);
}

macro ld c,srl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($39);
}

macro ld c,srl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($39);
}

macro ld c,srl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($39);
}

macro ld c,srl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($39);
}

macro ld c,srl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($39);
}

macro ld d,ixh
{
	push16le($54dd);
}

macro ld d,ixl
{
	push16le($55dd);
}

macro ld d,iyh
{
	push16le($54fd);
}

macro ld d,iyl
{
	push16le($55fd);
}

macro ld d,res 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($82);
}

macro ld d,res 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($82);
}

macro ld d,res 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($82);
}

macro ld d,res 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($82);
}

macro ld d,res 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($82);
}

macro ld d,res 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($82);
}

macro ld d,res 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($8a);
}

macro ld d,res 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($8a);
}

macro ld d,res 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($8a);
}

macro ld d,res 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($8a);
}

macro ld d,res 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($8a);
}

macro ld d,res 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($8a);
}

macro ld d,res 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($92);
}

macro ld d,res 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($92);
}

macro ld d,res 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($92);
}

macro ld d,res 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($92);
}

macro ld d,res 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($92);
}

macro ld d,res 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($92);
}

macro ld d,res 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($9a);
}

macro ld d,res 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($9a);
}

macro ld d,res 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($9a);
}

macro ld d,res 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($9a);
}

macro ld d,res 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($9a);
}

macro ld d,res 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($9a);
}

macro ld d,res 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($a2);
}

macro ld d,res 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($a2);
}

macro ld d,res 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($a2);
}

macro ld d,res 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($a2);
}

macro ld d,res 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($a2);
}

macro ld d,res 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($a2);
}

macro ld d,res 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($aa);
}

macro ld d,res 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($aa);
}

macro ld d,res 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($aa);
}

macro ld d,res 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($aa);
}

macro ld d,res 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($aa);
}

macro ld d,res 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($aa);
}

macro ld d,res 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($b2);
}

macro ld d,res 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($b2);
}

macro ld d,res 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($b2);
}

macro ld d,res 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($b2);
}

macro ld d,res 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($b2);
}

macro ld d,res 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($b2);
}

macro ld d,res 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ba);
}

macro ld d,res 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ba);
}

macro ld d,res 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ba);
}

macro ld d,res 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ba);
}

macro ld d,res 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ba);
}

macro ld d,res 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ba);
}

macro ld d,rl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($12);
}

macro ld d,rl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($12);
}

macro ld d,rl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($12);
}

macro ld d,rl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($12);
}

macro ld d,rl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($12);
}

macro ld d,rl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($12);
}

macro ld d,rlc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($02);
}

macro ld d,rlc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($02);
}

macro ld d,rlc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($02);
}

macro ld d,rlc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($02);
}

macro ld d,rlc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($02);
}

macro ld d,rlc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($02);
}

macro ld d,rr (ix)
{
	push16le($cbdd);
	push8($00);
	push8($1a);
}

macro ld d,rr (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($1a);
}

macro ld d,rr (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($1a);
}

macro ld d,rr (iy)
{
	push16le($cbfd);
	push8($00);
	push8($1a);
}

macro ld d,rr (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($1a);
}

macro ld d,rr (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($1a);
}

macro ld d,rrc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($0a);
}

macro ld d,rrc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($0a);
}

macro ld d,rrc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($0a);
}

macro ld d,rrc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($0a);
}

macro ld d,rrc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($0a);
}

macro ld d,rrc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($0a);
}

macro ld d,set 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($c2);
}

macro ld d,set 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($c2);
}

macro ld d,set 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($c2);
}

macro ld d,set 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($c2);
}

macro ld d,set 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($c2);
}

macro ld d,set 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($c2);
}

macro ld d,set 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ca);
}

macro ld d,set 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ca);
}

macro ld d,set 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ca);
}

macro ld d,set 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ca);
}

macro ld d,set 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ca);
}

macro ld d,set 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ca);
}

macro ld d,set 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($d2);
}

macro ld d,set 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($d2);
}

macro ld d,set 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($d2);
}

macro ld d,set 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($d2);
}

macro ld d,set 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($d2);
}

macro ld d,set 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($d2);
}

macro ld d,set 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($da);
}

macro ld d,set 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($da);
}

macro ld d,set 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($da);
}

macro ld d,set 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($da);
}

macro ld d,set 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($da);
}

macro ld d,set 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($da);
}

macro ld d,set 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($e2);
}

macro ld d,set 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($e2);
}

macro ld d,set 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($e2);
}

macro ld d,set 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($e2);
}

macro ld d,set 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($e2);
}

macro ld d,set 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($e2);
}

macro ld d,set 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ea);
}

macro ld d,set 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ea);
}

macro ld d,set 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ea);
}

macro ld d,set 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ea);
}

macro ld d,set 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ea);
}

macro ld d,set 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ea);
}

macro ld d,set 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($f2);
}

macro ld d,set 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($f2);
}

macro ld d,set 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($f2);
}

macro ld d,set 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($f2);
}

macro ld d,set 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($f2);
}

macro ld d,set 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($f2);
}

macro ld d,set 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($fa);
}

macro ld d,set 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($fa);
}

macro ld d,set 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($fa);
}

macro ld d,set 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($fa);
}

macro ld d,set 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($fa);
}

macro ld d,set 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($fa);
}

macro ld d,sla (ix)
{
	push16le($cbdd);
	push8($00);
	push8($22);
}

macro ld d,sla (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($22);
}

macro ld d,sla (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($22);
}

macro ld d,sla (iy)
{
	push16le($cbfd);
	push8($00);
	push8($22);
}

macro ld d,sla (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($22);
}

macro ld d,sla (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($22);
}

macro ld d,sll (ix)
{
	push16le($cbdd);
	push8($00);
	push8($32);
}

macro ld d,sll (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($32);
}

macro ld d,sll (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($32);
}

macro ld d,sll (iy)
{
	push16le($cbfd);
	push8($00);
	push8($32);
}

macro ld d,sll (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($32);
}

macro ld d,sll (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($32);
}

macro ld d,sra (ix)
{
	push16le($cbdd);
	push8($00);
	push8($2a);
}

macro ld d,sra (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($2a);
}

macro ld d,sra (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($2a);
}

macro ld d,sra (iy)
{
	push16le($cbfd);
	push8($00);
	push8($2a);
}

macro ld d,sra (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($2a);
}

macro ld d,sra (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($2a);
}

macro ld d,srl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($3a);
}

macro ld d,srl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($3a);
}

macro ld d,srl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($3a);
}

macro ld d,srl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($3a);
}

macro ld d,srl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($3a);
}

macro ld d,srl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($3a);
}

macro ld e,ixh
{
	push16le($5cdd);
}

macro ld e,ixl
{
	push16le($5ddd);
}

macro ld e,iyh
{
	push16le($5cfd);
}

macro ld e,iyl
{
	push16le($5dfd);
}

macro ld e,res 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($83);
}

macro ld e,res 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($83);
}

macro ld e,res 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($83);
}

macro ld e,res 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($83);
}

macro ld e,res 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($83);
}

macro ld e,res 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($83);
}

macro ld e,res 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($8b);
}

macro ld e,res 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($8b);
}

macro ld e,res 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($8b);
}

macro ld e,res 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($8b);
}

macro ld e,res 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($8b);
}

macro ld e,res 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($8b);
}

macro ld e,res 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($93);
}

macro ld e,res 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($93);
}

macro ld e,res 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($93);
}

macro ld e,res 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($93);
}

macro ld e,res 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($93);
}

macro ld e,res 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($93);
}

macro ld e,res 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($9b);
}

macro ld e,res 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($9b);
}

macro ld e,res 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($9b);
}

macro ld e,res 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($9b);
}

macro ld e,res 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($9b);
}

macro ld e,res 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($9b);
}

macro ld e,res 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($a3);
}

macro ld e,res 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($a3);
}

macro ld e,res 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($a3);
}

macro ld e,res 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($a3);
}

macro ld e,res 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($a3);
}

macro ld e,res 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($a3);
}

macro ld e,res 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ab);
}

macro ld e,res 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ab);
}

macro ld e,res 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ab);
}

macro ld e,res 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ab);
}

macro ld e,res 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ab);
}

macro ld e,res 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ab);
}

macro ld e,res 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($b3);
}

macro ld e,res 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($b3);
}

macro ld e,res 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($b3);
}

macro ld e,res 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($b3);
}

macro ld e,res 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($b3);
}

macro ld e,res 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($b3);
}

macro ld e,res 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($bb);
}

macro ld e,res 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($bb);
}

macro ld e,res 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($bb);
}

macro ld e,res 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($bb);
}

macro ld e,res 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($bb);
}

macro ld e,res 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($bb);
}

macro ld e,rl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($13);
}

macro ld e,rl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($13);
}

macro ld e,rl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($13);
}

macro ld e,rl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($13);
}

macro ld e,rl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($13);
}

macro ld e,rl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($13);
}

macro ld e,rlc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($03);
}

macro ld e,rlc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($03);
}

macro ld e,rlc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($03);
}

macro ld e,rlc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($03);
}

macro ld e,rlc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($03);
}

macro ld e,rlc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($03);
}

macro ld e,rr (ix)
{
	push16le($cbdd);
	push8($00);
	push8($1b);
}

macro ld e,rr (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($1b);
}

macro ld e,rr (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($1b);
}

macro ld e,rr (iy)
{
	push16le($cbfd);
	push8($00);
	push8($1b);
}

macro ld e,rr (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($1b);
}

macro ld e,rr (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($1b);
}

macro ld e,rrc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($0b);
}

macro ld e,rrc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($0b);
}

macro ld e,rrc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($0b);
}

macro ld e,rrc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($0b);
}

macro ld e,rrc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($0b);
}

macro ld e,rrc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($0b);
}

macro ld e,set 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($c3);
}

macro ld e,set 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($c3);
}

macro ld e,set 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($c3);
}

macro ld e,set 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($c3);
}

macro ld e,set 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($c3);
}

macro ld e,set 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($c3);
}

macro ld e,set 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($cb);
}

macro ld e,set 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($cb);
}

macro ld e,set 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($cb);
}

macro ld e,set 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($cb);
}

macro ld e,set 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($cb);
}

macro ld e,set 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($cb);
}

macro ld e,set 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($d3);
}

macro ld e,set 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($d3);
}

macro ld e,set 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($d3);
}

macro ld e,set 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($d3);
}

macro ld e,set 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($d3);
}

macro ld e,set 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($d3);
}

macro ld e,set 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($db);
}

macro ld e,set 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($db);
}

macro ld e,set 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($db);
}

macro ld e,set 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($db);
}

macro ld e,set 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($db);
}

macro ld e,set 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($db);
}

macro ld e,set 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($e3);
}

macro ld e,set 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($e3);
}

macro ld e,set 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($e3);
}

macro ld e,set 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($e3);
}

macro ld e,set 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($e3);
}

macro ld e,set 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($e3);
}

macro ld e,set 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($eb);
}

macro ld e,set 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($eb);
}

macro ld e,set 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($eb);
}

macro ld e,set 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($eb);
}

macro ld e,set 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($eb);
}

macro ld e,set 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($eb);
}

macro ld e,set 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($f3);
}

macro ld e,set 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($f3);
}

macro ld e,set 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($f3);
}

macro ld e,set 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($f3);
}

macro ld e,set 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($f3);
}

macro ld e,set 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($f3);
}

macro ld e,set 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($fb);
}

macro ld e,set 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($fb);
}

macro ld e,set 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($fb);
}

macro ld e,set 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($fb);
}

macro ld e,set 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($fb);
}

macro ld e,set 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($fb);
}

macro ld e,sla (ix)
{
	push16le($cbdd);
	push8($00);
	push8($23);
}

macro ld e,sla (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($23);
}

macro ld e,sla (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($23);
}

macro ld e,sla (iy)
{
	push16le($cbfd);
	push8($00);
	push8($23);
}

macro ld e,sla (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($23);
}

macro ld e,sla (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($23);
}

macro ld e,sll (ix)
{
	push16le($cbdd);
	push8($00);
	push8($33);
}

macro ld e,sll (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($33);
}

macro ld e,sll (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($33);
}

macro ld e,sll (iy)
{
	push16le($cbfd);
	push8($00);
	push8($33);
}

macro ld e,sll (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($33);
}

macro ld e,sll (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($33);
}

macro ld e,sra (ix)
{
	push16le($cbdd);
	push8($00);
	push8($2b);
}

macro ld e,sra (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($2b);
}

macro ld e,sra (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($2b);
}

macro ld e,sra (iy)
{
	push16le($cbfd);
	push8($00);
	push8($2b);
}

macro ld e,sra (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($2b);
}

macro ld e,sra (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($2b);
}

macro ld e,srl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($3b);
}

macro ld e,srl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($3b);
}

macro ld e,srl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($3b);
}

macro ld e,srl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($3b);
}

macro ld e,srl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($3b);
}

macro ld e,srl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($3b);
}

macro ld h,res 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($84);
}

macro ld h,res 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($84);
}

macro ld h,res 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($84);
}

macro ld h,res 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($84);
}

macro ld h,res 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($84);
}

macro ld h,res 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($84);
}

macro ld h,res 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($8c);
}

macro ld h,res 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($8c);
}

macro ld h,res 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($8c);
}

macro ld h,res 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($8c);
}

macro ld h,res 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($8c);
}

macro ld h,res 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($8c);
}

macro ld h,res 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($94);
}

macro ld h,res 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($94);
}

macro ld h,res 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($94);
}

macro ld h,res 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($94);
}

macro ld h,res 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($94);
}

macro ld h,res 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($94);
}

macro ld h,res 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($9c);
}

macro ld h,res 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($9c);
}

macro ld h,res 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($9c);
}

macro ld h,res 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($9c);
}

macro ld h,res 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($9c);
}

macro ld h,res 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($9c);
}

macro ld h,res 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($a4);
}

macro ld h,res 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($a4);
}

macro ld h,res 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($a4);
}

macro ld h,res 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($a4);
}

macro ld h,res 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($a4);
}

macro ld h,res 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($a4);
}

macro ld h,res 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ac);
}

macro ld h,res 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ac);
}

macro ld h,res 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ac);
}

macro ld h,res 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ac);
}

macro ld h,res 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ac);
}

macro ld h,res 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ac);
}

macro ld h,res 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($b4);
}

macro ld h,res 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($b4);
}

macro ld h,res 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($b4);
}

macro ld h,res 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($b4);
}

macro ld h,res 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($b4);
}

macro ld h,res 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($b4);
}

macro ld h,res 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($bc);
}

macro ld h,res 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($bc);
}

macro ld h,res 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($bc);
}

macro ld h,res 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($bc);
}

macro ld h,res 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($bc);
}

macro ld h,res 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($bc);
}

macro ld h,rl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($14);
}

macro ld h,rl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($14);
}

macro ld h,rl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($14);
}

macro ld h,rl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($14);
}

macro ld h,rl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($14);
}

macro ld h,rl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($14);
}

macro ld h,rlc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($04);
}

macro ld h,rlc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($04);
}

macro ld h,rlc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($04);
}

macro ld h,rlc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($04);
}

macro ld h,rlc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($04);
}

macro ld h,rlc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($04);
}

macro ld h,rr (ix)
{
	push16le($cbdd);
	push8($00);
	push8($1c);
}

macro ld h,rr (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($1c);
}

macro ld h,rr (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($1c);
}

macro ld h,rr (iy)
{
	push16le($cbfd);
	push8($00);
	push8($1c);
}

macro ld h,rr (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($1c);
}

macro ld h,rr (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($1c);
}

macro ld h,rrc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($0c);
}

macro ld h,rrc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($0c);
}

macro ld h,rrc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($0c);
}

macro ld h,rrc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($0c);
}

macro ld h,rrc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($0c);
}

macro ld h,rrc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($0c);
}

macro ld h,set 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($c4);
}

macro ld h,set 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($c4);
}

macro ld h,set 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($c4);
}

macro ld h,set 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($c4);
}

macro ld h,set 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($c4);
}

macro ld h,set 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($c4);
}

macro ld h,set 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($cc);
}

macro ld h,set 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($cc);
}

macro ld h,set 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($cc);
}

macro ld h,set 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($cc);
}

macro ld h,set 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($cc);
}

macro ld h,set 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($cc);
}

macro ld h,set 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($d4);
}

macro ld h,set 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($d4);
}

macro ld h,set 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($d4);
}

macro ld h,set 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($d4);
}

macro ld h,set 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($d4);
}

macro ld h,set 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($d4);
}

macro ld h,set 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($dc);
}

macro ld h,set 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($dc);
}

macro ld h,set 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($dc);
}

macro ld h,set 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($dc);
}

macro ld h,set 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($dc);
}

macro ld h,set 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($dc);
}

macro ld h,set 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($e4);
}

macro ld h,set 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($e4);
}

macro ld h,set 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($e4);
}

macro ld h,set 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($e4);
}

macro ld h,set 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($e4);
}

macro ld h,set 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($e4);
}

macro ld h,set 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ec);
}

macro ld h,set 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ec);
}

macro ld h,set 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ec);
}

macro ld h,set 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ec);
}

macro ld h,set 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ec);
}

macro ld h,set 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ec);
}

macro ld h,set 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($f4);
}

macro ld h,set 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($f4);
}

macro ld h,set 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($f4);
}

macro ld h,set 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($f4);
}

macro ld h,set 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($f4);
}

macro ld h,set 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($f4);
}

macro ld h,set 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($fc);
}

macro ld h,set 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($fc);
}

macro ld h,set 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($fc);
}

macro ld h,set 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($fc);
}

macro ld h,set 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($fc);
}

macro ld h,set 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($fc);
}

macro ld h,sla (ix)
{
	push16le($cbdd);
	push8($00);
	push8($24);
}

macro ld h,sla (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($24);
}

macro ld h,sla (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($24);
}

macro ld h,sla (iy)
{
	push16le($cbfd);
	push8($00);
	push8($24);
}

macro ld h,sla (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($24);
}

macro ld h,sla (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($24);
}

macro ld h,sll (ix)
{
	push16le($cbdd);
	push8($00);
	push8($34);
}

macro ld h,sll (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($34);
}

macro ld h,sll (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($34);
}

macro ld h,sll (iy)
{
	push16le($cbfd);
	push8($00);
	push8($34);
}

macro ld h,sll (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($34);
}

macro ld h,sll (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($34);
}

macro ld h,sra (ix)
{
	push16le($cbdd);
	push8($00);
	push8($2c);
}

macro ld h,sra (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($2c);
}

macro ld h,sra (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($2c);
}

macro ld h,sra (iy)
{
	push16le($cbfd);
	push8($00);
	push8($2c);
}

macro ld h,sra (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($2c);
}

macro ld h,sra (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($2c);
}

macro ld h,srl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($3c);
}

macro ld h,srl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($3c);
}

macro ld h,srl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($3c);
}

macro ld h,srl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($3c);
}

macro ld h,srl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($3c);
}

macro ld h,srl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($3c);
}

macro ld ixh,a
{
	push16le($67dd);
}

macro ld ixh,b
{
	push16le($60dd);
}

macro ld ixh,c
{
	push16le($61dd);
}

macro ld ixh,d
{
	push16le($62dd);
}

macro ld ixh,e
{
	push16le($63dd);
}

macro ld ixh,ixh
{
	push16le($64dd);
}

macro ld ixh,ixl
{
	push16le($65dd);
}

macro ld ixh,@n
{
	push16le($26dd);
	push8(n);
}

macro ld ixl,a
{
	push16le($6fdd);
}

macro ld ixl,b
{
	push16le($68dd);
}

macro ld ixl,c
{
	push16le($69dd);
}

macro ld ixl,d
{
	push16le($6add);
}

macro ld ixl,e
{
	push16le($6bdd);
}

macro ld ixl,ixh
{
	push16le($6cdd);
}

macro ld ixl,ixl
{
	push16le($6ddd);
}

macro ld ixl,@n
{
	push16le($2edd);
	push8(n);
}

macro ld iyh,a
{
	push16le($67fd);
}

macro ld iyh,b
{
	push16le($60fd);
}

macro ld iyh,c
{
	push16le($61fd);
}

macro ld iyh,d
{
	push16le($62fd);
}

macro ld iyh,e
{
	push16le($63fd);
}

macro ld iyh,iyh
{
	push16le($64fd);
}

macro ld iyh,iyl
{
	push16le($65fd);
}

macro ld iyh,@n
{
	push16le($26fd);
	push8(n);
}

macro ld iyl,a
{
	push16le($6ffd);
}

macro ld iyl,b
{
	push16le($68fd);
}

macro ld iyl,c
{
	push16le($69fd);
}

macro ld iyl,d
{
	push16le($6afd);
}

macro ld iyl,e
{
	push16le($6bfd);
}

macro ld iyl,iyh
{
	push16le($6cfd);
}

macro ld iyl,iyl
{
	push16le($6dfd);
}

macro ld iyl,@n
{
	push16le($2efd);
	push8(n);
}

macro ld l,res 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($85);
}

macro ld l,res 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($85);
}

macro ld l,res 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($85);
}

macro ld l,res 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($85);
}

macro ld l,res 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($85);
}

macro ld l,res 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($85);
}

macro ld l,res 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($8d);
}

macro ld l,res 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($8d);
}

macro ld l,res 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($8d);
}

macro ld l,res 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($8d);
}

macro ld l,res 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($8d);
}

macro ld l,res 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($8d);
}

macro ld l,res 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($95);
}

macro ld l,res 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($95);
}

macro ld l,res 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($95);
}

macro ld l,res 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($95);
}

macro ld l,res 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($95);
}

macro ld l,res 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($95);
}

macro ld l,res 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($9d);
}

macro ld l,res 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($9d);
}

macro ld l,res 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($9d);
}

macro ld l,res 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($9d);
}

macro ld l,res 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($9d);
}

macro ld l,res 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($9d);
}

macro ld l,res 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($a5);
}

macro ld l,res 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($a5);
}

macro ld l,res 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($a5);
}

macro ld l,res 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($a5);
}

macro ld l,res 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($a5);
}

macro ld l,res 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($a5);
}

macro ld l,res 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ad);
}

macro ld l,res 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ad);
}

macro ld l,res 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ad);
}

macro ld l,res 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ad);
}

macro ld l,res 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ad);
}

macro ld l,res 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ad);
}

macro ld l,res 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($b5);
}

macro ld l,res 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($b5);
}

macro ld l,res 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($b5);
}

macro ld l,res 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($b5);
}

macro ld l,res 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($b5);
}

macro ld l,res 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($b5);
}

macro ld l,res 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($bd);
}

macro ld l,res 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($bd);
}

macro ld l,res 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($bd);
}

macro ld l,res 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($bd);
}

macro ld l,res 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($bd);
}

macro ld l,res 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($bd);
}

macro ld l,rl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($15);
}

macro ld l,rl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($15);
}

macro ld l,rl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($15);
}

macro ld l,rl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($15);
}

macro ld l,rl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($15);
}

macro ld l,rl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($15);
}

macro ld l,rlc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($05);
}

macro ld l,rlc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($05);
}

macro ld l,rlc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($05);
}

macro ld l,rlc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($05);
}

macro ld l,rlc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($05);
}

macro ld l,rlc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($05);
}

macro ld l,rr (ix)
{
	push16le($cbdd);
	push8($00);
	push8($1d);
}

macro ld l,rr (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($1d);
}

macro ld l,rr (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($1d);
}

macro ld l,rr (iy)
{
	push16le($cbfd);
	push8($00);
	push8($1d);
}

macro ld l,rr (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($1d);
}

macro ld l,rr (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($1d);
}

macro ld l,rrc (ix)
{
	push16le($cbdd);
	push8($00);
	push8($0d);
}

macro ld l,rrc (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($0d);
}

macro ld l,rrc (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($0d);
}

macro ld l,rrc (iy)
{
	push16le($cbfd);
	push8($00);
	push8($0d);
}

macro ld l,rrc (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($0d);
}

macro ld l,rrc (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($0d);
}

macro ld l,set 0,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($c5);
}

macro ld l,set 0,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($c5);
}

macro ld l,set 0,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($c5);
}

macro ld l,set 0,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($c5);
}

macro ld l,set 0,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($c5);
}

macro ld l,set 0,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($c5);
}

macro ld l,set 1,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($cd);
}

macro ld l,set 1,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($cd);
}

macro ld l,set 1,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($cd);
}

macro ld l,set 1,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($cd);
}

macro ld l,set 1,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($cd);
}

macro ld l,set 1,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($cd);
}

macro ld l,set 2,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($d5);
}

macro ld l,set 2,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($d5);
}

macro ld l,set 2,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($d5);
}

macro ld l,set 2,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($d5);
}

macro ld l,set 2,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($d5);
}

macro ld l,set 2,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($d5);
}

macro ld l,set 3,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($dd);
}

macro ld l,set 3,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($dd);
}

macro ld l,set 3,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($dd);
}

macro ld l,set 3,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($dd);
}

macro ld l,set 3,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($dd);
}

macro ld l,set 3,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($dd);
}

macro ld l,set 4,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($e5);
}

macro ld l,set 4,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($e5);
}

macro ld l,set 4,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($e5);
}

macro ld l,set 4,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($e5);
}

macro ld l,set 4,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($e5);
}

macro ld l,set 4,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($e5);
}

macro ld l,set 5,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($ed);
}

macro ld l,set 5,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($ed);
}

macro ld l,set 5,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($ed);
}

macro ld l,set 5,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($ed);
}

macro ld l,set 5,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($ed);
}

macro ld l,set 5,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($ed);
}

macro ld l,set 6,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($f5);
}

macro ld l,set 6,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($f5);
}

macro ld l,set 6,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($f5);
}

macro ld l,set 6,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($f5);
}

macro ld l,set 6,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($f5);
}

macro ld l,set 6,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($f5);
}

macro ld l,set 7,(ix)
{
	push16le($cbdd);
	push8($00);
	push8($fd);
}

macro ld l,set 7,(ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($fd);
}

macro ld l,set 7,(ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($fd);
}

macro ld l,set 7,(iy)
{
	push16le($cbfd);
	push8($00);
	push8($fd);
}

macro ld l,set 7,(iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($fd);
}

macro ld l,set 7,(iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($fd);
}

macro ld l,sla (ix)
{
	push16le($cbdd);
	push8($00);
	push8($25);
}

macro ld l,sla (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($25);
}

macro ld l,sla (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($25);
}

macro ld l,sla (iy)
{
	push16le($cbfd);
	push8($00);
	push8($25);
}

macro ld l,sla (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($25);
}

macro ld l,sla (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($25);
}

macro ld l,sll (ix)
{
	push16le($cbdd);
	push8($00);
	push8($35);
}

macro ld l,sll (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($35);
}

macro ld l,sll (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($35);
}

macro ld l,sll (iy)
{
	push16le($cbfd);
	push8($00);
	push8($35);
}

macro ld l,sll (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($35);
}

macro ld l,sll (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($35);
}

macro ld l,sra (ix)
{
	push16le($cbdd);
	push8($00);
	push8($2d);
}

macro ld l,sra (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($2d);
}

macro ld l,sra (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($2d);
}

macro ld l,sra (iy)
{
	push16le($cbfd);
	push8($00);
	push8($2d);
}

macro ld l,sra (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($2d);
}

macro ld l,sra (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($2d);
}

macro ld l,srl (ix)
{
	push16le($cbdd);
	push8($00);
	push8($3d);
}

macro ld l,srl (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($3d);
}

macro ld l,srl (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($3d);
}

macro ld l,srl (iy)
{
	push16le($cbfd);
	push8($00);
	push8($3d);
}

macro ld l,srl (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($3d);
}

macro ld l,srl (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($3d);
}

macro neg
{
	push16le($4ced);
}

macro neg2
{
	push16le($54ed);
}

macro neg3
{
	push16le($5ced);
}

macro neg4
{
	push16le($64ed);
}

macro neg5
{
	push16le($6ced);
}

macro neg6
{
	push16le($74ed);
}

macro neg7
{
	push16le($7ced);
}

macro or ixh
{
	push16le($b4dd);
}

macro or ixl
{
	push16le($b5dd);
}

macro or iyh
{
	push16le($b4fd);
}

macro or iyl
{
	push16le($b5fd);
}

macro out (c),0
{
	push16le($71ed);
}

macro retn
{
	push16le($55ed);
}

macro retn2
{
	push16le($5ded);
}

macro retn3
{
	push16le($65ed);
}

macro retn4
{
	push16le($6ded);
}

macro retn5
{
	push16le($75ed);
}

macro retn6
{
	push16le($7ded);
}

macro sbc a,ixh
{
	push16le($9cdd);
}

macro sbc a,ixl
{
	push16le($9ddd);
}

macro sbc a,iyh
{
	push16le($9cfd);
}

macro sbc a,iyl
{
	push16le($9dfd);
}

macro sll (hl)
{
	push16le($36cb);
}

macro sll (ix)
{
	push16le($cbdd);
	push8($00);
	push8($36);
}

macro sll (ix+@d)
{
	push16le($cbdd);
	push8(c2sr<8>(d));
	push8($36);
}

macro sll (ix-@d)
{
	push16le($cbdd);
	push8(c2sr<8>(-d));
	push8($36);
}

macro sll (iy)
{
	push16le($cbfd);
	push8($00);
	push8($36);
}

macro sll (iy+@d)
{
	push16le($cbfd);
	push8(c2sr<8>(d));
	push8($36);
}

macro sll (iy-@d)
{
	push16le($cbfd);
	push8(c2sr<8>(-d));
	push8($36);
}

macro sll a
{
	push16le($37cb);
}

macro sll b
{
	push16le($30cb);
}

macro sll c
{
	push16le($31cb);
}

macro sll d
{
	push16le($32cb);
}

macro sll e
{
	push16le($33cb);
}

macro sll h
{
	push16le($34cb);
}

macro sll l
{
	push16le($35cb);
}

macro sub ixh
{
	push16le($94dd);
}

macro sub ixl
{
	push16le($95dd);
}

macro sub iyh
{
	push16le($94fd);
}

macro sub iyl
{
	push16le($95fd);
}

macro xor ixh
{
	push16le($acdd);
}

macro xor ixl
{
	push16le($addd);
}

macro xor iyh
{
	push16le($acfd);
}

macro xor iyl
{
	push16le($adfd);
}

