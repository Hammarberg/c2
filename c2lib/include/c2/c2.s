/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once

macro incbin @file
{
	loadbin(file.str());
}

macro incbin @file, @param...
{
	size_t offset = 0;
	size_t length = -1;
	
	if(param.size() >= 1)
		offset = param[0];
	
	if(param.size() >= 2)
		length = param[1];
		
	loadbin(file.str(), offset, length);
}

macro incstream @cmd
{
	loadstream(cmd.str());
}

macro incstream @cmd, @param...
{
	size_t offset = 0;
	size_t length = -1;
	
	if(param.size() >= 1)
		offset = param[0];
	
	if(param.size() >= 2)
		length = param[1];
	
	loadstream(cmd.str(), offset, length);
}

macro postarg @arg
{
	c2_add_arg(arg.str());
}

#define repeat(TIMES) for(int c2repn=0;c2repn<(TIMES);c2repn++)
#define REPEAT repeat

#define rrepeat(TIMES) for(int c2repn=(TIMES)-1;c2repn>=0;c2repn--)
#define RREPEAT rrepeat

#define import(X) static var X(#X, nullptr, 1);
#define IMPORT import

macro assemble @src
{
	c2_subassemble(src.str());
}
#define ASSEMBLE assemble
