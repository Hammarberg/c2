/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include <string>
#include <vector>

class ctemplate
{
public:
	ctemplate(const char *libpath);
	~ctemplate();
	
	void list();
	std::string create(int arga, const char *argc[]);
	
	static std::string str_translate(std::string str, const std::vector<std::pair<std::string, std::string>> &translate);
	static void file_translate(const char *src, const char *dst, const std::vector<std::pair<std::string, std::string>> &translate);

private:
	std::string basepath;
};

