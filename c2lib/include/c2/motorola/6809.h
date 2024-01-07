/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/h/c2i.h"

class motorola6809 : public c2i
{
public:
	motorola6809(cmdi *pcmd);
	virtual ~motorola6809();
	void c2_pre() override;

	void c2_6809_idx_direct_off(cint off, cint r1);
	void c2_6809_idx_indirect_off(cint off, cint r1);
	void c2_6809_idx_direct_acc(cint r2, cint r1);
	void c2_6809_idx_indirect_acc(cint r2, cint r1);
	bool c2_6809_idx_direct_pc(cint off);
	bool c2_6809_idx_indirect_pc(cint off);

	bool c2_6809_longbranch = false;
	bool c2_6809_absolute = false;
};
