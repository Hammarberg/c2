/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/h/c2i.h"

class c64 : public c2i
{
public:
	c64(cmdi *pcmd);
	virtual ~c64();
	static char ascii2screen(char i);
	static char ascii2petscii(char i);
	void basic(const char *format, ...);
	
	void loadsid(const char *path, var &init, var &play);
	
	void c2_reset_pass() override;
	void c2_post() override;
	
	void c64_vice(var v);
	
	void *c64_internal = nullptr;

	int64_t incprgorg(const char *file, size_t offset = 0, size_t length = -1);
};
