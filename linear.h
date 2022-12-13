/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once

#include <cstdint>
#include <vector>
#include <cstdlib>

template<size_t BSIZE = 1024 * 1024>
class slinear_alloc
{
	public:
	
	slinear_alloc()
	{
		ptr = 0;
		size_left = 0;
	}
	
	~slinear_alloc()
	{
		for(auto i:buffers)
		{
			free(i);
		}
	}
	
	void *alloc(size_t n)
	{
		n = (n+7)&(~7); //Align
		
		if(n >= size_left)
		{
			size_t ta = n > BSIZE ? n : BSIZE;

			ptr = (uintptr_t)malloc(size_left = ta);
			buffers.push_back((void *)ptr);
		}
		
		return grab(n);
	}
	
	private:
	uintptr_t ptr;
	size_t size_left;
	
	void *grab(size_t n)
	{
		void *ret = (void *)ptr;
		ptr += n;
		size_left -= n;
		return ret;
	}
	
	std::vector<void *> buffers;
};