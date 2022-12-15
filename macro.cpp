/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "macro.h"

#ifdef _WIN32
#define strcasecmp _stricmp
#endif

void cmacro::print()
{
	printf("signature: ");
	signature.restart();
	stok *o;
	while((o = signature.pull_tok()))
	{
		printf("%s", o->format().c_str());
	}
	printf("\n");
	
	restart();
	while((o = pull_tok()))
	{
		printf("%s", o->format().c_str());
	}
	printf("\n");
}

bool cmacro::cmp(const cmacro &other)
{
	if(signature == other.signature)
	{
		if(inputs.size() == 0 && other.inputs.size() == 0)
			return true;
		
		if(inputs.size() != other.inputs.size())
			return false;

		for(size_t r=0; r<inputs.size(); r++)
		{
			auto &one = inputs[r].second;
			auto &two = other.inputs[r].second;
			
			if(one.size() != two.size())
				return false;
			
			for(size_t l=0; l<one.size(); l++)
			{
				if(strcasecmp(one[l], two[l]))
					return false;
			}
		}

		return true;
	}
	
	return false;
}
