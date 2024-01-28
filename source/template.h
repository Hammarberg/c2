/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "library.h"
#include "json.h"
#include <string>
#include <vector>
#include <filesystem>
#include <memory>

#define TEMPLATESFILE "templates.c2.json"

class ctemplate
{
friend class clibrary;
public:
	ctemplate(clibrary &inlib);
	~ctemplate();

	void tpl_list();
	std::string tpl_create(int arga, const char *argc[]);

private:
	clibrary &lib;
	bool loadfile(const char *file, std::string &out);
	void file_translate(const char *src, const char *dst, const std::vector<std::pair<std::string, std::string>> &translate);
	static std::string str_translate(std::string str, const std::vector<std::pair<std::string, std::string>> &translate);

	typedef std::shared_ptr<json::base> tjson;

	tjson tpl_load(const char *intemplate);
	tjson create(const char *intemplate, const char *intitle, const char *indestpath);
	void tpl_file_move(ctemplate::tjson &tpl, const std::filesystem::path &destpath, std::vector<std::pair<std::string, std::string>> &translate, bool copyall);

	void tpl_build_translate(const std::string& super, const std::string& title, const std::string& include, std::vector<std::pair<std::string, std::string>>& translate);
};

