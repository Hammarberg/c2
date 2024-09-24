/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "tokfeed.h"

/*
 * Macro signatures in a std::string object
 * 
 * @ = input, can either be ALPHA or NUM
 * ~ = array
 * ... signals variable parameters
 * 
 * Anything else is a literal. All literals are stored in lower case
 * 
 * a space must separates the macro and parameters
 * spaces in parameters are ignored
 * 
 * declaration: lda #@n
 * signature:   lda #@
 * 
 * declaration: .byte @data...
 * signature:   .byte ~
 * 
 * declaration:  move.l #@data, d0
 * signature:    move.l #@,d0
 * 
 * Indexed argument match: @Dn must match any static literal listed and will be assigned the indexed number
 * declaration:  move.l #@data, @[d0,d1,d2,d3,d4,d5,d6,d7]Dn
 * signature:    move.l #@,@
*/

class cmacro : public toklink
{
public:

	cmacro(){}
	virtual ~cmacro(){}

	toklink signature;
	std::vector<std::pair<std::string, std::vector<const char *>>> inputs;
	
	bool cmp(const cmacro &other);
	void print();

	int disablecount = 0;
	
private:
	//stok *current = nullptr;
};
