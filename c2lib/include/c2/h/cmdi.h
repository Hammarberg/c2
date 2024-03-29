/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2c.h"

class cmdi : public c2c
{
public:
	virtual void add_args(int arga, char *args[]) = 0;
	virtual void add_args(const char *argstr, bool fromtemplate=false) = 0;
	virtual void declare(const char *slong, const char *sshort, const char *sinfo, int min_args = 0, int max_args = -1) = 0;
	virtual void printf_info() = 0;
	virtual int get_c2_exe_path(char *buffer, int buffersize) = 0;
	virtual int get_cmd_line(char *buffer, int buffersize) = 0;

	template<typename Function>
	void invoke(const char *sw, Function && fn, int min_args = -1, int max_args = -1)
	{
		int arga;
		const char **argc;
		for(int r=0;; r++)
		{
			if(!verify(r, sw, min_args, max_args, &arga, &argc))
				break;
				
			fn(arga, argc);
			cmdfree(argc);
		}
	}
	
protected:
	virtual bool verify(int iter, const char *sw, int min_args, int max_args, int *arga, const char ***argc) = 0;
	virtual void cmdfree(void *ptr) = 0;
};
