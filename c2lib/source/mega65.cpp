/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "c2/mega65/mega65.h"

mega65::mega65(cmdi *pcmd)
: cbm(pcmd)
{
	// Default org if nothing is set
	c2_org = 0x2000;
	
	// Valid range of RAM
	c2_set_ram(0, 0x10000);
}

mega65::~mega65()
{
}

void mega65::c2_pre()
{
	cbm::c2_pre();
}

void mega65::c2_reset_pass()
{
	cbm::c2_reset_pass();
}

void mega65::c2_post()
{
	cbm::c2_post();
}
