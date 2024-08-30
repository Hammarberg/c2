/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "library.h"
#include "template.h"
#include "json.h"
#include "log.h"
#include <cstdlib>
#if defined(_WIN32) || defined(_WIN64)
#include <windows.h>
#else
#include <unistd.h>
#endif
#if defined(__APPLE__)
#include <mach-o/dyld.h>
#endif
#include <limits.h>

#define ENV_C2LIB_HOME "C2LIB_HOME"
#define C2LIB "c2lib"
#define C2CONFIG "config.c2.json"

int clibrary::verbose = 0;

clibrary::clibrary()
{
}

clibrary::~clibrary()
{
}

void clibrary::internal_init(const std::vector<std::filesystem::path> &expaths)
{
	// test lambda
	auto test_push_path=[this](const std::filesystem::path &in) -> bool
	{
		VERBOSE(3, "Testing library path %s\n", in.string().c_str());
		if(std::filesystem::is_directory(in))
		{
			push_path(in);
			return true;
		}
		return false;
	};

	// Explicitly set paths
	for(size_t r=0; r<expaths.size(); r++)
	{
		test_push_path(expaths[r]);
	}
	
	// ~/. and ~/
	{
#if defined(_WIN32) || defined(_WIN64)
		const char* homestr = getenv("LOCALAPPDATA");
#elif defined(__APPLE__) || defined(__CYGWIN__)
		const char *homestr = getenv("HOME");
#else
		const char *homestr = secure_getenv("HOME");
#endif
		if(homestr)
		{
			std::filesystem::path home = homestr;

			if(!test_push_path(home / "." C2LIB))
			{
				test_push_path(home / C2LIB);
			}
		}
	}
	
	// From environment path
	{
#if defined(_WIN32) || defined(_WIN64) || defined(__APPLE__) || defined(__CYGWIN__)
		const char* envpath = getenv(ENV_C2LIB_HOME);
#else
		const char *envpath = secure_getenv(ENV_C2LIB_HOME);
#endif
		if(envpath)
		{
			test_push_path(std::filesystem::canonical(envpath));
		}
	}
	
	// Relative to executable
	{
#if defined(_WIN32) || defined(_WIN64)
		char result[MAX_PATH] = {0};
		GetModuleFileNameA(NULL, result, MAX_PATH);
#elif defined(__APPLE__)
		char result[PATH_MAX] = {0};
		uint32_t bufsize = PATH_MAX;
		_NSGetExecutablePath(result, &bufsize);
#else
		char result[PATH_MAX] = {0};
		/*ssize_t count =*/ readlink("/proc/self/exe", result, PATH_MAX);
#endif
		std::filesystem::path exepath = result;
		std::filesystem::path exedir = exepath.parent_path();

		// Same folder as executable
		if(test_push_path(exedir / C2LIB))
			return;

		// ../lib/
		if(test_push_path(exedir.parent_path() / "lib/" C2LIB))
			return;
		
		// Visual studio dev
#if defined(_WIN32) || defined(_WIN64)
		if(test_push_path(exedir.parent_path().parent_path() / C2LIB))
			return;
#endif
	}
}

void clibrary::lib_initialize(const std::vector<std::filesystem::path> &expaths)
{
	internal_init(expaths);
	// Load config in order
	load_config();
}

void clibrary::lib_basepath()
{
	// Project is known, set any library overrides
	std::filesystem::path base = C2LIB;
	
	VERBOSE(3, "Testing library path %s\n", base.string().c_str());
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
	for(auto i : libraries)
	{
		if(i == path)
			return;
	}

	VERBOSE(2, "Adding library path %s\n", path.string().c_str());

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

bool clibrary::lib_load_file_direct(const char *path, std::string &out)
{
	FILE *fp = fopen(path, "r");
	if(!fp)
		return false;
		
	lib_utf_read(fp, out);
		
	fclose(fp);
	return true;
}

size_t clibrary::lib_utf_read(FILE *fp, char *buf, size_t size)
{
	size_t read = fread(buf, 1, size, fp);
	
	return read;
}

void clibrary::lib_utf_read(FILE *fp, std::string &out)
{
	fseek(fp, 0, SEEK_END);
	size_t n = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	
	out.resize(n);
	char *p = &(out[0]);

	size_t read = lib_utf_read(fp, p, n);
	out.resize(read);
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
#if defined(_WIN32) || defined(_WIN64)
		tmp += "\\";
#else
		tmp += "/";
#endif
		out.push_back(tmp);
	}
	
	for(size_t r=0; r<library_include_paths.size(); r++)
	{
		tmp = library_include_paths[r].string();
#if defined(_WIN32) || defined(_WIN64)
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
	if(!lib_load_file_direct(file, buf))
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

			std::string sec = ppair->second->GetString();

			if (sec.size() && config.find(ppair->first) == config.end())
			{
				config[ppair->first] = sec;
			}
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

void clibrary::lib_print()
{
	for(auto i : libraries)
	{
		fprintf(stderr, "%s\n", i.string().c_str());
	}

	for(auto i : config)
	{
		fprintf(stderr, "\"%s\" \"%s\"\n", i.first.c_str(), i.second.c_str());
	}
}

