/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "c2/motorola/68000.h"

motorola68000::motorola68000(cmdi *pcmd)
: c2i(pcmd)
{
	// Default org if nothing is set
	c2_org = 0x10000;
	
	// Valid range of RAM
	c2_set_ram(0, 0x1000000);
}

motorola68000::~motorola68000()
{
}
