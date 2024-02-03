/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include <filesystem>
#include <vector>
#include <map>
#include <cstdio>

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
	static bool lib_load_file_direct(const char *path, std::string &out);
	
	static size_t lib_utf_read(FILE *fp, char *buf, size_t size);
	static void lib_utf_read(FILE *fp, std::string &out);
	
	std::filesystem::path lib_get_file_path(const char *path);
	void lib_get_file_path(const char *path, std::vector<std::filesystem::path> &out);
	
	void lib_add_include_path(const char *path);
	std::string lib_generate_includes(bool c2);
	void lib_generate_includes_array(std::vector<std::string> &out);

	std::string lib_cfg_get_string(const char *name);

	static std::string quote_path(std::string path);
	
	static int verbose;

private:

	void push_path(const std::filesystem::path &path, bool first = false);

	std::vector<std::filesystem::path> libraries;
	std::vector<std::filesystem::path> library_include_paths;
	std::vector<std::filesystem::path> user_include_paths;
	
	void load_config();
	void load_config(const char *file);
	std::map<std::string,std::string> config;
};

