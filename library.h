/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include <filesystem>
#include <vector>
#include <cstdio>


#define ENV_C2LIB_HOME "C2LIB_HOME"
#define C2LIB "c2lib"
#define NIX_GLOBAL "/usr/lib/" C2LIB

/*
 * Library path search order:
 * 
 * Project folder
 * Explicitly set
 * User local
 * Environment variable
 * System global
 * Relative to executable (fallback for development)
*/

class clibrary
{
public:
	clibrary();
	~clibrary();
	
	void lib_initialize(const std::vector<std::filesystem::path> &expaths);
	void lib_basepath();
	
	FILE *lib_fopen(const char *path, const char *mode);
	
	std::filesystem::path lib_get_file_path(const char *path);
	
	void lib_add_include_path(const char *path);
	
	std::string lib_generate_includes(bool c2);
	void lib_generate_includes_array(std::vector<std::string> &out);

private:

	void push_path(const std::filesystem::path &path, bool first = false);

	std::vector<std::filesystem::path> libraries;
	std::vector<std::filesystem::path> library_include_paths;
	std::vector<std::filesystem::path> user_include_paths;
};

