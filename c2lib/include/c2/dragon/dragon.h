/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/motorola/6809.h"

class dragon : public motorola6809
{
public:
	dragon(cmdi *pcmd)
	: motorola6809(pcmd)
	{
		c2_org = 0x0;
		c2_set_ram(0, 0x10000);
	}

	virtual ~dragon()
	{}

	void c2_post() override
	{
		c2i::c2_post();
	}

	char ascii2screen(char i)
	{
		static const char *dragonascii2screentab="@abcdefghijklmnopqrstuvwxyz[\\]^_ !\"#$%&'()*+,-./0123456789:;<=>?";
		const char *p = c2_strchr(dragonascii2screentab, i ? i : '@');
		return p?int(p-dragonascii2screentab):i;
	}

};
