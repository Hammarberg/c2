/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/
#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#endif

#include "library.h"
#include "template.h"
#include "json.h"
#include <cstdlib>
#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif
#include <limits.h>

#define ENV_C2LIB_HOME "C2LIB_HOME"
#define C2LIB "c2lib"
#define NIX_GLOBAL "/usr/lib/" C2LIB
#define C2CONFIG "config.c2.json"

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
#ifdef _WIN32
		const char* home = getenv("LOCALAPPDATA");
#else
		const char *home = secure_getenv("HOME");
#endif
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
#ifdef _WIN32
		const char* envpath = getenv(ENV_C2LIB_HOME);
#else
		const char *envpath = secure_getenv(ENV_C2LIB_HOME);
#endif
		
		if(envpath)
		{
			std::filesystem::path tmp = envpath;
			
			if(std::filesystem::is_directory(tmp))
			{
				push_path(tmp);
			}
		}
	}
	
#ifndef _WIN32
	// Global path
	{
		std::filesystem::path tmp = NIX_GLOBAL;
		
		if(std::filesystem::is_directory(tmp))
		{
			push_path(tmp);
		}
	}
#endif

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
			path = path.parent_path().parent_path().parent_path();
			path /= C2LIB;

			if(!std::filesystem::is_directory(path))
			{
				path = path.parent_path().parent_path();
				path /= C2LIB;
			}

			if(std::filesystem::is_directory(path))
			{
				push_path(path);
			}
#endif
		}
	}
	
	// Load config in order
	load_config();
}

void clibrary::lib_basepath()
{
	// Project is known, set any library overrides
	std::filesystem::path base = C2LIB;
	
	if(std::filesystem::is_directory(base))
	{
		push_path(base, true);
	}
	
	// Override with any project specific config
	base /= C2CONFIG;
	load_config(base.string().c_str());
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

void clibrary::lib_get_file_path(const char *file, std::vector<std::filesystem::path> &out)
{
	for(size_t r=0; r<libraries.size(); r++)
	{
		std::filesystem::path path = libraries[r] / file;
		
		if(std::filesystem::is_regular_file(path))
		{
			out.push_back(path);
		}
	}
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

			cmd += "-I" + quote_path(user_include_paths[r].string());
		}
	}
	
	for(size_t r=0; r<library_include_paths.size(); r++)
	{
		if(cmd.size())
			cmd += " ";
			
		cmd += "-I" + quote_path(library_include_paths[r].string());
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

std::string clibrary::quote_path(std::string path)
{
	if (path.find(' ') != path.npos)
	{
		path = "\"" + path + "\"";
	}

	return path;
}

void clibrary::load_config()
{
	for(size_t r=0; r<libraries.size(); r++)
	{
		std::filesystem::path path = libraries[r] / C2CONFIG;
		load_config(path.string().c_str());
	}
}

void clibrary::load_config(const char *file)
{
	std::string buf;
	if(!ctemplate::loadfile_direct(file, buf))
		return;

	std::unique_ptr<json::base> cfg(json::base::Decode(buf.c_str()));
	
	// Templates
	json::array* p = (json::array*)cfg->Find("config");
	if (p)
	{
		if (p->GetType() != json::type::ARRAY)
		{
			throw "config type not array";
		}

		for (size_t r = 0; r < p->data.size(); r++)
		{
			json::pair* ppair = (json::pair*)p->data[r];
			if (ppair->GetType() != json::type::PAIR)
			{
				throw "Config type not pair";
			}
			
			config[ppair->first] = ppair->second->GetString();
		}
	}
}

std::string clibrary::lib_cfg_get_string(const char *name)
{
	auto i = config.find(name);
	
	if(i == config.end())
		return "";
		
	return i->second;
}
