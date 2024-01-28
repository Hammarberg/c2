/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "template.h"
#include "json.h"
#include "library.h"

#include <cstdio>
#include <memory>
#include <filesystem>

ctemplate::ctemplate(clibrary &inlib)
 : lib(inlib)
{
}

ctemplate::~ctemplate()
{
}

bool ctemplate::loadfile(const char *file, std::string &out)
{
	FILE *fp = lib.lib_fopen(file, "r");
	if(!fp)
		return false;
	
	clibrary::lib_utf_read(fp, out);
		
	fclose(fp);
	return true;
}

void ctemplate::tpl_list()
{
	std::vector<std::filesystem::path> out;
	lib.lib_get_file_path(TEMPLATESFILE, out);

	for(size_t r=0; r<out.size(); r++)
	{
		std::string buf;
		if(!clibrary::lib_load_file_direct(out[r].string().c_str(), buf))
			throw "Error loading " TEMPLATESFILE;

		std::unique_ptr<json::base> cfg(json::base::Decode(buf.c_str()));
		
		// Templates
		json::array* p = (json::array*)cfg->Find("templates");
		if (p)
		{
			if (p->GetType() != json::type::ARRAY)
			{
				throw "templates type not array";
			}

			json::iterate(p, json::PAIR, [](json::base *i)
			{
				json::pair* ppair = (json::pair*)i;
				std::string desc = ppair->second->Get("description").GetString();
				std::string tmp = ppair->first + ":";

				while(tmp.size() < 12)
					tmp += ' ';

				tmp += desc;

				fprintf(stdout, "%s\n", tmp.c_str());
			});

		}
		else
		{
			throw "No templates array found in" TEMPLATESFILE;
		}
	}
}

void ctemplate::tpl_file_move(ctemplate::tjson &tpl, const std::filesystem::path &destpath, std::vector<std::pair<std::string, std::string>> &translate, bool copyall)
{
	// Template
	json::array *p = (json::array*)tpl->Find("template");
	if (p)
	{
		json::iterate(p, json::PAIR, [&](json::base *i)
		{
			json::pair* ppair = (json::pair*)i;
			json::container *t = (json::container *)ppair->second;
			if(t->GetType() != json::type::CONTAINER)
				return;

			if (copyall || t->Get("c2").GetBool())
			{
				std::filesystem::path src = "template";
				src /= ppair->first;
				std::string dstfile = str_translate(t->Get("target").GetString(), translate);
				std::filesystem::path dst = destpath / dstfile;

				//printf("Move: %s -> %s\n",src.string().c_str(), dst.string().c_str());

				file_translate(src.string().c_str(), dst.string().c_str(), translate);
			}
		});
	}
}

ctemplate::tjson ctemplate::tpl_load(const char *intemplate)
{
	std::vector<std::filesystem::path> out;
	lib.lib_get_file_path(TEMPLATESFILE, out);

	json::container *t = nullptr;

	tjson cfg;

	for(size_t r=0; r<out.size() && t == nullptr; r++)
	{
		std::string buf;
		if(!clibrary::lib_load_file_direct(out[r].string().c_str(), buf))
			throw "Error loading " TEMPLATESFILE;

		cfg.reset(json::base::Decode(buf.c_str()));

		// Templates
		json::array *p = (json::array*)cfg->Find("templates");
		if (p)
		{
			if (p->GetType() != json::type::ARRAY)
			{
				throw "templates type not array";
			}

			for (size_t r = 0; r < p->data.size(); r++)
			{
				json::pair* ppair = (json::pair*)p->data[r];
				if (ppair->GetType() != json::type::PAIR)
				{
					throw "Config type not pair";
				}

				if(ppair->first == intemplate)
				{
					t = (json::container *)ppair->second;
					if (t->GetType() != json::type::CONTAINER)
					{
						throw "Expected container";
					}

					// Detach container
					ppair->second = nullptr;

					break;
				}
			}
		}
		else
		{
			throw "No templates array found in" TEMPLATESFILE;
		}
	}

	if(!t)
	{
		throw "Could not find specified template";
	}

	return tjson((json::base *)t);
}

void ctemplate::tpl_build_translate(const std::string &super, const std::string &title, const std::string &include,	std::vector<std::pair<std::string, std::string>>& translate)
{
	translate.push_back({ "{super}", super });
	translate.push_back({ "{title}", title });
	translate.push_back({ "{include}", include });
}

ctemplate::tjson ctemplate::create(const char *intemplate, const char *intitle, const char *indestpath)
{
	std::filesystem::path destpath = indestpath;

	tjson tpl = tpl_load(intemplate);
	json::base *t = tpl.get();

	std::string super = t->Get("super").GetString();
	std::string title = intitle;
	std::string include = t->Get("include").GetString();

	std::vector<std::pair<std::string, std::string>> translate;
	tpl_build_translate(super, title, include, translate);

	json::container *c = new json::container();
	tjson proj = tjson(c);

	c->data.push_back(
		new json::pair(
			"title",
			new json::string(title)
		)
	);

	c->data.push_back(
		new json::pair(
			"basedir",
			new json::string(".")
		)
	);

	c->data.push_back(
		new json::pair(
			"arguments",
			new json::string(str_translate(t->Get("arguments").GetString(), translate).c_str())
		)
	);

	c->data.push_back(
		new json::pair(
			"execute",
			new json::string(str_translate(t->Get("execute").GetString(), translate).c_str())
		)
	);

	json::array *f = new json::array;

	c->data.push_back(
		new json::pair(
			"files",
			f
		)
	);

	// Template

	json::array* p = (json::array*)t->Find("template");
	if (p->GetType() != json::type::ARRAY)
	{
		throw "template type not array";
	}

	json::iterate(p, json::PAIR, [&](json::base *i)
	{
		json::pair* ppair = (json::pair*)i;

		json::container *t = (json::container *)ppair->second;
		if (t->GetType() != json::type::CONTAINER)
		{
			throw "Expected container";
		}

		if (t->Get("c2").GetBool())
		{
			std::string dstfile = str_translate(t->Get("target").GetString(), translate);

			json::container *c = new json::container;
			json::pair *p = new json::pair(dstfile, c);
			f->data.push_back(p);

			json::iterate(t, json::PAIR, [&](json::base *i)
			{
				json::pair* ppair = (json::pair*)i;
				if(ppair->first != "target")
				{
					if(ppair->second->GetType() == json::STRING)
					{
						c->data.push_back(new json::pair(ppair->first, new json::string(str_translate(ppair->second->GetString(), translate))));
					}
					else
					{
						c->data.push_back(ppair->Clone());
					}
				}
			});
		}
	});

	tpl_file_move(tpl, destpath, translate, true);

	// source

	p = (json::array*)t->Find("source");
	if (p->GetType() != json::type::ARRAY)
	{
		throw "source type not array";
	}

	json::iterate(p, json::PAIR, [&](json::base *i)
	{
		json::pair* ppair = (json::pair*)i;
		if(ppair->second->GetType() == json::CONTAINER)
		{
			json::container *c = (json::container *)ppair->second->Clone();
			if(!c->Find("external"))
			{
				c->data.push_back(
					new json::pair(
						"external",
						new json::boolean(true)
					)
				);
			}
			std::filesystem::path src("source");
			src /= ppair->first;
			f->data.push_back(new json::pair(src.string(), c));
		}
	});

	return proj;
}

std::string ctemplate::tpl_create(int arga, const char *argc[])
{
	std::string title = argc[1];
	std::filesystem::path destpath;
	if(arga == 3)
	{
		destpath = argc[2];
		std::filesystem::create_directories(destpath);
	}

	std::filesystem::path projfile = destpath / (title + ".c2.json");

	if(std::filesystem::exists(projfile))
		throw "A project already exist";

	ctemplate::tjson proj = create(argc[0], title.c_str(), destpath.string().c_str());

	std::string c2json = proj->Encode(false);

	FILE *fp = fopen(projfile.string().c_str(), "w");

	fwrite(c2json.c_str(), 1, c2json.size(), fp);

	fclose(fp);

	return projfile.string();
}

std::string ctemplate::str_translate(std::string str, const std::vector<std::pair<std::string, std::string>> &translate)
{
	for(size_t r=0;r<translate.size();r++)
	{
		const std::string &from = translate[r].first;
		const std::string &to = translate[r].second;
		
		size_t l;
		while((l = str.find(from)) != str.npos)
		{
			str.replace(l, from.size(), to);
		}
	}
	
	return str;
}

void ctemplate::file_translate(const char *src, const char *dst, const std::vector<std::pair<std::string, std::string>> &translate)
{
	std::string str;
	if(!loadfile(src, str))
		throw "Template file not found";
	
	str = str_translate(str, translate);
	
	FILE *fp = fopen(dst, "w");
	if(!fp)
		throw "Could not open destination file";

	fwrite(str.c_str(), 1, str.size(), fp);
	
	fclose(fp);
}
