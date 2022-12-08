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

#include "template.h"
#include "json.h"

#include <cstdio>
#include <memory>
#include <filesystem>

static bool loadfile(const char *file, std::string &out)
{
	FILE *fp = fopen(file, "r");
	if(!fp)
		return false;
	
	fseek(fp, 0, SEEK_END);
	size_t n = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	
	out.resize(n);
	char *p = &(out[0]);

	fread(p, 1, n, fp);
		
	fclose(fp);
	return true;
}

ctemplate::ctemplate(const char *libpath)
 : basepath(libpath)
{
}

ctemplate::~ctemplate()
{
}

void ctemplate::list()
{
	std::string file = basepath + TEMPLATESFILE;
	std::string buf;
	if(!loadfile(file.c_str(), buf))
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

		for (size_t r = 0; r < p->data.size(); r++)
		{
			json::pair* ppair = (json::pair*)p->data[r];
			if (ppair->GetType() != json::type::PAIR)
			{
				throw "Config type not pair";
			}
			std::string desc = ppair->second->Get("description").GetString();
			std::string tmp = ppair->first + ":";
			
			while(tmp.size() < 12)
				tmp += ' ';
				
			tmp += desc;
			
			fprintf(stdout, "%s\n", tmp.c_str());
		}
	}
	else
	{
		throw "No templates array found in" TEMPLATESFILE;
	}
}

std::string ctemplate::create(int arga, const char *argc[])
{
	std::string file = basepath + TEMPLATESFILE;
	std::string buf;
	if(!loadfile(file.c_str(), buf))
		throw "Error loading " TEMPLATESFILE;

	std::unique_ptr<json::base> cfg(json::base::Decode(buf.c_str()));
	
	// Templates
	json::container *t = nullptr;
	json::array* p = (json::array*)cfg->Find("templates");
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
			std::string desc = ppair->second->Get("description").GetString();
			
			if(ppair->first == argc[0])
			{
				t = (json::container *)ppair->second;
				if (t->GetType() != json::type::CONTAINER)
				{
					throw "Expected container";
				}
				break;
			}
		}
	}
	else
	{
		throw "No templates array found in" TEMPLATESFILE;
	}
	
	if(!t)
	{
		throw "Could not find specified template";
	}
	
	std::string destpath;
	if(arga == 3)
	{
		destpath = argc[2];
		if(destpath[destpath.size()-1] != '/')
			destpath += '/';
		
		std::filesystem::create_directories(destpath);
	}
	
	std::string super = t->Get("super").GetString();
	std::string title = argc[1];
	
	std::vector<std::pair<std::string, std::string>> translate;
	translate.push_back({"{super}",super});
	translate.push_back({"{title}",title});
	
	std::string projfile = destpath + title + ".c2.json";
	
	if(std::filesystem::exists(projfile))
		throw "A project already exist";
	
	FILE *fp = fopen(projfile.c_str(), "w");
	
	fprintf(fp,
		"{\n"
		"\t\"title\" : \"%s\",\n"
		"\t\"basedir\":\".\",\n"
		"\t\"arguments\" : \"%s\",\n"
		"\t\"execute\" : \"%s\",\n"
		"\t\"files\":[\n",
		title.c_str(),
		str_translate(t->Get("arguments").GetString(), translate).c_str(),
		str_translate(t->Get("execute").GetString(), translate).c_str());
	
	p = (json::array*)t->Find("template");
	if (p->GetType() != json::type::ARRAY)
	{
		throw "template type not array";
	}
	
	for (size_t r = 0; r < p->data.size(); r++)
	{
		json::pair *ppair = (json::pair *)p->data[r];
		if (ppair->GetType() != json::type::PAIR)
		{
			throw "Config type not pair";
		}
		
		std::string src = basepath + "template/" + ppair->first;
		json::container *t = (json::container *)ppair->second;
		if (t->GetType() != json::type::CONTAINER)
		{
			throw "Expected container";
		}
		
		std::string dstfile = str_translate(t->Get("target").GetString(), translate);
		std::string dst = destpath + dstfile;
		file_translate(src.c_str(), dst.c_str(), translate);
		
		if(t->Get("c2").GetBool())
		{
			fprintf(fp,"\t\t\"%s\":{\n", dstfile.c_str());
			fprintf(fp,"\t\t\t\"c2\" : true,\n");
			fprintf(fp,"\t\t\t\"flags\" : \"%s\"\n",str_translate(t->Get("flags").GetString(), translate).c_str());
			fprintf(fp,"\t\t},\n");
		}
	}
	
	// source
	
	p = (json::array*)t->Find("source");
	if (p->GetType() != json::type::ARRAY)
	{
		throw "template type not array";
	}
	
	for (size_t r = 0; r < p->data.size(); r++)
	{
		json::pair *ppair = (json::pair *)p->data[r];
		if (ppair->GetType() != json::type::PAIR)
		{
			throw "Config type not pair";
		}
		
		std::filesystem::path src("source");
		src /= ppair->first;
		json::container *t = (json::container *)ppair->second;
		if (t->GetType() != json::type::CONTAINER)
		{
			throw "Expected container";
		}
		
		fprintf(fp,"\t\t\"%s\":{\n", src.string().c_str());
		
		fprintf(fp,"\t\t\t\"external\" : true,\n");
		fprintf(fp,"\t\t\t\"flags\" : \"%s\"\n",str_translate(t->Get("flags").GetString(), translate).c_str());
		fprintf(fp,"\t\t}%s\n", r != p->data.size()-1 ? "," : "");
	}
	
	fprintf(fp,"\t]\n}\n");
	
	fclose(fp);
	
	return projfile;
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
