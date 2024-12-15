/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/
#include "cmda.h"
#include "c2lib/include/c2/h/c2i.h"
#include "c2lib/include/c2/h/c2c.h"
#include "template.h"

#ifdef _WIN32
#include <windows.h>
#endif

class sproject : public ctemplate
{
public:

	sproject();
	~sproject();

	struct stimestamp
	{
		uint64_t mtim;

		stimestamp();
		void save(FILE *fp);
		void load(FILE *fp);
		bool operator==(const stimestamp &o) const;
		void stat(const char *file);
	};

	struct sdependency
	{
		std::string file;
		stimestamp timestamp;
		size_t index;
		bool stat_done = false;

		void save(FILE *fp);
		void load(FILE *fp);
		void stat();
	};

	struct sfile
	{
		std::shared_ptr<sdependency> file;
		bool c2;
		bool ext;
		std::string flags;
		std::vector<std::pair<std::shared_ptr<sdependency>, stimestamp>> dependency;
		bool active = false;
		std::string obj;

		void save(FILE *fp);
		void load(FILE *fp, std::vector<std::shared_ptr<sdependency>> &dependencies);

		bool is_dirty();
		void clear_dirty();
	};

	cmda command;

	std::string compiler;
	std::string stdc;

	std::filesystem::path basedir;
	std::string title = "noname";
	std::string arguments;
	std::string execute;
	std::string template_name;

	stimestamp projecttime;
	std::vector<std::unique_ptr<sfile> > files;
	std::vector<std::shared_ptr<sdependency> > dependencies;
	std::vector<std::string> parser_files;

	void clean_files();
	void clean_dependencies();
	void stat_dependencies();
	void stat_files();
	void index_dependencies();
	sfile *add_file(const std::string &file);
	std::shared_ptr<sdependency> search_dependecy(const std::string &file);
	std::shared_ptr<sdependency> add_dependency(const std::string &file);
	void extract_dependencies(sfile *data, const std::string &file, bool c2);
	std::string make_intermediate_path(std::string file);
	void save_imm(const std::filesystem::path &path);
	void load_imm(const std::filesystem::path &path);
	static bool file_exist(const char *path);
	static std::string make_ext(const std::string &file, const char *ext);
	void sh_execute(const char *str, bool silent = false);
	void set_compiler();
	bool load_project(ctemplate::tjson cfg, const char* projectfile, bool readonly);
	void build(bool doexecute);

	c2i *(*c2_object_instance)(cmdi *) = nullptr;
#ifndef _WIN32
	void *hasm = nullptr;
#else
	HMODULE hasm = nullptr;
#endif

	bool load_module(const char *name = nullptr);
	void unload_module();
	std::string get_link_target();
};
