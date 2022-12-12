/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "library.h"
#include <cstdlib>
#ifdef _WIN32
#include <windows.h>
#endif
//#include <fcntl.h>
#include <unistd.h>
#include <limits.h>

clibrary::clibrary()
{
}

clibrary::~clibrary()
{
}

void clibrary::lib_initialize(const std::vector<std::filesystem::path> &expaths)
{
	// Explicitly set paths
	for(size_t r=0; r<expaths.size(); r++)
	{
		if(std::filesystem::is_directory(expaths[r]))
		{
			push_path(expaths[r]);
		}
	}
	
	// Get user/local path
	//const char *home = getenv("HOME");
	{
		const char *home = secure_getenv("HOME");
		if(home)
		{
			std::filesystem::path tmp = home;
			tmp /= "." C2LIB;
			
			if(std::filesystem::is_directory(tmp))
			{
				push_path(tmp);
			}
			else
			{
				tmp = home;
				tmp /= C2LIB;
				if(std::filesystem::is_directory(tmp))
				{
					push_path(tmp);
				}
			}
		}
	}
	
	// From environment path
	{
		const char *envpath = secure_getenv("C2LIBRARY");
		
		if(envpath)
		{
			std::filesystem::path tmp = envpath;
			
			if(std::filesystem::is_directory(tmp))
			{
				push_path(tmp);
			}
		}
	}
	
	// Global path
	{
		std::filesystem::path tmp = NIX_GLOBAL;
		
		if(std::filesystem::is_directory(tmp))
		{
			push_path(tmp);
		}
	}

	// Relative to executable
	{	
#ifdef _WIN32
		char result[MAX_PATH] = {0};
		GetModuleFileNameA(NULL, result, MAX_PATH);
#else
		char result[PATH_MAX] = {0};
		/*ssize_t count =*/ readlink("/proc/self/exe", result, PATH_MAX);
#endif
		std::filesystem::path path = result;
		
		path = path.parent_path();
		path /= C2LIB;

		if(std::filesystem::is_directory(path))
		{
			push_path(path);
		}
		else
		{
#ifdef _WIN32
			// Check one and two levels up, since MSVC puts binary under x64/Debug.
			path = path.parent_path().parent_path();
			path /= "lib";

			if(!std::filesystem::is_directory(path))
			{
				path = path.parent_path().parent_path();
				path /= "lib";
			}

			if(std::filesystem::is_directory(path))
			{
				push_path(path);
			}
#endif
		}
	}
}

void clibrary::lib_basepath()
{
	std::filesystem::path base = C2LIB;
	
	if(std::filesystem::is_directory(base))
	{
		push_path(base);
	}
}

void clibrary::push_path(const std::filesystem::path &path, bool first)
{
	if(first)
	{
		libraries.insert(libraries.begin(), path);
	}
	else
	{
		libraries.push_back(path);
	}
	
	std::filesystem::path incpath = path / "include";
	if(std::filesystem::is_directory(incpath))
	{
		if(first)
		{
			library_include_paths.insert(library_include_paths.begin(), incpath);
		}
		else
		{
			library_include_paths.push_back(incpath);
		}
	}
}

FILE *clibrary::lib_fopen(const char *file, const char *mode)
{
	FILE *fp = nullptr;
	for(size_t r=0; r<libraries.size() && fp == nullptr; r++)
	{
		std::filesystem::path path = libraries[r] / file;
		
		fp = fopen(path.string().c_str(), mode);
	}
	return fp;
}

std::filesystem::path clibrary::lib_get_file_path(const char *file)
{
	for(size_t r=0; r<libraries.size(); r++)
	{
		std::filesystem::path path = libraries[r] / file;
		
		if(std::filesystem::is_regular_file(path))
		{
			return path;
		}
	}
	
	return "";
}

void clibrary::lib_add_include_path(const char *path)
{
	std::filesystem::path base = path;
	
	if(std::filesystem::is_directory(base))
	{
		user_include_paths.push_back(base);
	}
}

std::string clibrary::lib_generate_includes(bool c2)
{
	std::string cmd;
	
	if(c2)
	{
		for(size_t r=0; r<user_include_paths.size(); r++)
		{
			if(cmd.size())
				cmd += " ";
				
			cmd += "-I"+user_include_paths[r].string();
		}
	}
	
	for(size_t r=0; r<library_include_paths.size(); r++)
	{
		if(cmd.size())
			cmd += " ";
			
		cmd += "-I"+library_include_paths[r].string();
	}
	
	return cmd;
}

void clibrary::lib_generate_includes_array(std::vector<std::string> &out)
{
	std::string tmp;
	for(size_t r=0; r<user_include_paths.size(); r++)
	{
		tmp = user_include_paths[r].string();
#ifdef _WIN32
		tmp += "\\";
#else
		tmp += "/";
#endif
		out.push_back(tmp);
	}
	
	for(size_t r=0; r<library_include_paths.size(); r++)
	{
		tmp = library_include_paths[r].string();
#ifdef _WIN32
		tmp += "\\";
#else
		tmp += "/";
#endif
		out.push_back(tmp);
	}
}
