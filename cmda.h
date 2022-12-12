/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2lib/include/c2/h/cmdi.h"
#include <string>
#include <vector>

class cmda : public cmdi
{
public:
	void add_args(int arga, char *args[]) override;
	void add_args(const char *argstr) override;
	void add_info(const char *slong, const char *sshort, const char *sinfo) override;
	void printf_info() override;
	bool verify(int iter, const char *sw, int min_args, int max_args, int *arga, const char ***argc) override;
	void cmdfree(void *ptr) override;
	
	std::string main();
	
private:

	std::vector<std::string> sargs;
	
	struct cswitch
	{
		std::string slong;
		std::string sshort;
		std::string sinfo;
		
		void print();
	};
	
	std::vector<cswitch> data;
};
