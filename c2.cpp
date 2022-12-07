/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "tokfeed.h"
#include "token.h"
#include "c2a.h"
#include "json.h"
#include "cmda.h"
#include "lib/include/c2i.h"
#include "template.h"

#include <functional>
#include <ctime>
#include <filesystem>
#include <sys/stat.h>

#ifndef _MSC_VER
#include <dlfcn.h>
#include <unistd.h>
#include <limits.h>
#else
#include <windows.h>
#include <direct.h>
#define popen _popen
#define pclose _pclose
#define strcasecmp _stricmp
#define stat _stat
#define chdir _chdir
#endif


#define TITLE "c2 cross assembler 0.5  Copyright (C) 2022  John Hammarberg (CRT)\n"

const uint32_t MAGIC_VERSION = 1337*1337+2;

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

static void save(FILE *fp, const std::string &s)
{
	const char *p = s.c_str();
	for(;;p++)
	{
		fwrite(p, 1, 1, fp);
		if (!*p)break;
	}
}

static void load(FILE *fp, std::string &s)
{
	s.clear();
	char b;
	for(;;)
	{
		fread(&b, 1, 1, fp);
		if(!b)break;
		s += b;
	}
}

class sproject
{
public:

	sproject()
	{
		std::string path;
#ifdef _WIN32
		char result[MAX_PATH] = {0};
		GetModuleFileNameW(NULL, result, MAX_PATH);
		return path;
#else
		char result[PATH_MAX] = {0};
		ssize_t count = readlink("/proc/self/exe", result, PATH_MAX);
		if(!count)
			throw "Could not extract c2 path";
#endif		
		path = result;
		
		size_t n = path.rfind('/');
		if(n == path.npos)
			throw "Could not extract c2 path";
			
		c2_libdir = path.substr(0, n + 1) + "lib/";
		c2_incdir = c2_libdir + "include/";
		
		printf("%s\n", c2_libdir.c_str());
		printf("%s\n", c2_incdir.c_str());
		
	}
	
	~sproject()
	{
		unload_module();
	}
	
	std::string c2_libdir;
	std::string c2_incdir;
	
	cmda command;
	
	bool use_clang = true;

	std::string basedir;
	std::string intermediatedir = "imm/";
	std::string title = "noname";
	std::string arguments;
	std::string execute;
	
	std::string make_path(const std::string &file)
	{
		return basedir + file;
	}
	
	struct stimestamp
	{
		stimestamp()
		{
			memset(&mtim, 0, sizeof(mtim));
		}
		
		void save(FILE *fp)
		{
			fwrite(&mtim, 1, sizeof(mtim), fp);
		}
		
		void load(FILE *fp)
		{
			fread(&mtim, 1, sizeof(mtim), fp);
		}
		
		bool operator==(const stimestamp &o) const
		{
			if(!mtim) return false;
			return memcmp(&mtim, &o.mtim, sizeof(mtim)) == 0;
		}

		uint64_t mtim;

		void stat(const char *file)
		{
			struct stat data;
			if(::stat(file, &data) >= 0)
			{
#ifdef	_MSC_VER
				mtim = data.st_mtime;
#else
				mtim = uint64_t(data.st_mtim.tv_sec);
#endif
			}
		}
		
	};
	
	struct sdependency
	{
		std::string file;
		stimestamp timestamp;
		size_t index;
		
		void save(FILE *fp)
		{
			::save(fp, file);
		}
		
		void load(FILE *fp)
		{
			::load(fp, file);
		}

		void stat()
		{
			timestamp.stat(file.c_str());
		}
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
		
		void save(FILE *fp)
		{
			size_t n;
			n = file->index;
			fwrite(&n, 1, sizeof(n), fp);
			
			n = dependency.size();
			fwrite(&n, 1, sizeof(n), fp);
			for(size_t r=0; r<n; r++)
			{
				size_t t = dependency[r].first->index;
				fwrite(&t, 1, sizeof(t), fp);
				dependency[r].second.save(fp);
			}
		}
		
		void load(FILE *fp, std::vector<std::shared_ptr<sdependency>> &dependencies)
		{
			size_t n;
			fread(&n, 1, sizeof(n), fp);
			file = dependencies[n];
			
			fread(&n, 1, sizeof(n), fp);
			for(size_t r=0;r<n;r++)
			{
				size_t t;
				fread(&t, 1, sizeof(t), fp);
				
				stimestamp mtim;
				mtim.load(fp);
				
				dependency.push_back(std::pair<std::shared_ptr<sdependency>, stimestamp>(dependencies[t], mtim));
			}
		}
		
		bool is_dirty()
		{
			if(!sproject::file_exist(obj.c_str()))	// No obj file, rebuild
				return true;
				
			if(!dependency.size()) // There is always at least one unless imm was not loaded, then rebuild
				return true;
			
			for(size_t r=0;r<dependency.size();r++)	// Check if a dependency has been modified
			{
				if(!(dependency[r].second == dependency[r].first->timestamp))
					return true;
			}
			return false;
		}
		
		void clear_dirty()
		{
			for(size_t r=0;r<dependency.size();r++)
			{
				dependency[r].second = dependency[r].first->timestamp;
			}
		}
	
	};
	
	void clean_files()
	{
		for(auto i=files.rbegin();i!=files.rend();i++)
		{
			if(!i->get()->active)
			{
				files.erase(i.base());
			}
		}
	}
	
	void clean_dependencies()
	{
		for(auto i=dependencies.rbegin();i!=dependencies.rend();i++)
		{
			if(i->use_count() == 1 /* i->unique()*/)
			{
				dependencies.erase(i.base());
			}
		}
	}
	
	void stat_dependencies()
	{
		for(auto i=dependencies.begin();i!=dependencies.end();i++)
		{
			i->get()->stat();
		}
	}
	
	void index_dependencies()
	{
		size_t index = 0;
		for(auto i=dependencies.begin();i!=dependencies.end();i++)
		{
			i->get()->index = index;
			index++;
		}
	}
	
	sfile *add_file(const std::string &file)
	{
		sfile *f;
		for(size_t r=0; r<files.size(); r++)
		{
			f = files[r].get();
			if(f->file->file == file)
			{
				f->active = true;
				return f;
			}
		}
		
		f = new sfile;
		files.push_back(std::unique_ptr<sfile>(f));
		f->file = add_dependency(file);
		f->active = true;
		
		return f;
	} 
	
	stimestamp projecttime;
	std::vector<std::unique_ptr<sfile> > files;
	std::vector<std::shared_ptr<sdependency> > dependencies;
	std::vector<std::string> parser_files;
	
	std::shared_ptr<sdependency> search_dependecy(const std::string &file)
	{
		for(size_t r=0; r<dependencies.size(); r++)
		{
			auto ptr = dependencies[r];
			if(ptr->file == file)
				return ptr;
		}
		
		return nullptr;
	} 
	
	std::shared_ptr<sdependency> add_dependency(const std::string &file)
	{
		auto d = search_dependecy(file);
		
		if(!d.get())
		{
			d = std::make_shared<sdependency>();
			d->file = file;
			d->stat();
			dependencies.push_back(d);
		}
		
		return d;
	}
	
	void extract_dependencies(sfile *data, const std::string &file)
	{
		data->dependency.clear();
		
		char buf[1024];
		std::string command = (use_clang ? "clang -I" + c2_incdir + " -MM -MG " : "g++ -I" + c2_incdir + " -MM -MG ") + file;
		std::string output;
		
		FILE *ep = popen(command.c_str(), "r");
		
		if(!ep)
			throw "File not found";

		size_t n;
		
		for(;;)
		{
			n = fread(buf, 1, sizeof(buf) - 1, ep);
			if(!n)
				break;
			
			buf[n] = 0;
			output += buf;
		}
		
		pclose(ep);
		
		n = output.find(':');
		
		if(n == std::string::npos)
			throw "Unexpected output";

		const char *p = &output[n+1];
		
		std::string d;
		while(*p)	
		{
			d.clear();
			
			for(;*p;p++)
			{
				if(*p == '\\') p++;
				else if(*p != ' ' && *p != 0x0d && *p != 0x0a) break;
			}
			
			for(;*p;p++)
			{
				if(*p == ' ' || *p == 0x0d || *p == 0x0a) break;
				else if(*p == '\\')
				{
					d += '\\';
					p++;
				}
				d += *p;
			}
			
			if(d.size())
			{
				data->dependency.push_back(std::pair<std::shared_ptr<sdependency>, stimestamp>(add_dependency(d), stimestamp()));
			}
		}
	}
	
	std::string make_intermediate_path(const std::string &file)
	{
		std::string tmp = file;
		std::replace( tmp.begin(), tmp.end(), '/', '_');
		return intermediatedir + tmp;
	}
	
	void save_imm(const std::string &path)
	{
		FILE *fp=fopen(path.c_str(),"wb");
		if(!fp)
			throw "Error opening file for writing";

		uint32_t magic = MAGIC_VERSION;
		fwrite(&magic, 1, sizeof(magic), fp);
		
		projecttime.save(fp);
		
		size_t n = dependencies.size();
		fwrite(&n, 1, sizeof(n), fp);
		for(size_t r=0;r<n;r++)
		{
			dependencies[r]->save(fp);
		}
		
		n = files.size();
		fwrite(&n, 1, sizeof(n), fp);
		for(size_t r=0;r<n;r++)
		{
			files[r]->save(fp);
		}
		
		n = parser_files.size();
		fwrite(&n, 1, sizeof(n), fp);
		for(size_t r=0;r<n;r++)
		{
			save(fp, parser_files[r]);
		}
		
		fclose(fp);
	}
	
	void load_imm(const std::string &path)
	{
		FILE *fp=fopen(path.c_str(),"rb");
		if(!fp)
		{
			return;
		}

		uint32_t magic;
		fread(&magic, 1, sizeof(magic), fp);
		if(magic != MAGIC_VERSION)
		{
			return;
		}
		
		projecttime.load(fp);
		
		size_t n;
		fread(&n, 1, sizeof(n), fp);
		for(size_t r=0;r<n;r++)
		{
			auto d = std::make_shared<sdependency>();
			d->load(fp);
			dependencies.push_back(d);
		}
		
		fread(&n, 1, sizeof(n), fp);
		for(size_t r=0;r<n;r++)
		{
			sfile *file = new sfile;
			file->load(fp, dependencies);
			files.push_back(std::unique_ptr<sfile>(file));
		}
		
		std::string stmp;
		fread(&n, 1, sizeof(n), fp);
		for(size_t r=0;r<n;r++)
		{
			load(fp, stmp);
			parser_files.push_back(stmp);
		}
		
		fclose(fp);
	}
	
	static bool file_exist(const char *path)
	{
		struct stat data;
		return ::stat(path, &data) >= 0;
	}
	
	static std::string make_ext(const std::string &file, const char *ext)
	{
		return file.substr(0, file.rfind('.')) + ext;
	}
	
	static void sh_execute(const char *str)
	{
		fprintf(stderr ,"%s\n", str);
		char buf[1024];
		FILE *ep = popen(str, "r");
		if(!ep)
		{
			throw "Error executing command";
		}
		
		std::string output;
		size_t n;
		
		for(;;)
		{
			n = fread(buf, 1, sizeof(buf) - 1, ep);
			if(!n)
				break;
			
			buf[n] = 0;
			output += buf;
		}
		
		int res = pclose(ep);
		
		if(res)
		{ 
			fprintf(stderr ,"%s\n", output.c_str());
			throw "Compile error";
		}
	}
	
	bool load_project(const char* buildfile)
	{
		std::string bdata, tmp;
		if(!loadfile(buildfile, bdata))
			return false;

		std::unique_ptr<json::base> cfg(json::base::Decode(bdata.c_str()));

		// basedir
		std::string::size_type n;
		basedir = buildfile;
		n = basedir.rfind('/');
		if (n != std::string::npos)
		{
			basedir = basedir.substr(0, n + 1);
		}
		else
		{
			basedir = "";
		}

		std::string config_basedir = cfg->Get("basedir").GetString();
		if (config_basedir[0] == '/')
		{
			basedir = config_basedir;
		}
		else if (config_basedir != ".")
		{
			basedir += config_basedir;
		}

		if (basedir.size() && basedir[basedir.size() - 1] != '/')
		{
			basedir += '/';
		}

		chdir(basedir.c_str());

		// Intermediate
		tmp = cfg->Get("intermediate").GetString();
		if (tmp.size()) intermediatedir = tmp;

		if (intermediatedir.size())
		{
			if (intermediatedir[intermediatedir.size() - 1] != '/')
			{
				intermediatedir += '/';
			}
		}

		std::filesystem::create_directories(intermediatedir);

		// If project is modified, rebuild
		
		bool should_load_imm = true;
		
		command.invoke("--rebuild", 0, 0, [&](int arga, const char *argc[])
		{
			should_load_imm = false;
		});

		if(should_load_imm)
		{
			load_imm(intermediatedir + "c2cache");
			
			stimestamp tproj;
			tproj.stat(buildfile);
			
			if(!(projecttime == tproj))
			{
				dependencies.clear();
				files.clear();
			}
			
			projecttime = tproj;
		}
		

		// Files
		json::array* pfiles = (json::array*)cfg->Find("files");
		if (pfiles)
		{
			if (pfiles->GetType() != json::type::ARRAY)
			{
				throw "Config type not array";
			}

			for (size_t r = 0; r < pfiles->data.size(); r++)
			{
				json::pair* ppair = (json::pair*)pfiles->data[r];
				if (ppair->GetType() != json::type::PAIR)
				{
					throw "Config type not pair";
				}

				sfile* file = add_file(ppair->first);

				file->c2 = ppair->second->Get("c2").GetBool();
				file->flags = ppair->second->Get("flags").GetString();
				file->ext = ppair->second->Get("external").GetBool();
			}
		}

		tmp = cfg->Get("title").GetString();
		if (tmp.size()) title = tmp;

		arguments = cfg->Get("arguments").GetString();
		execute = cfg->Get("execute").GetString();

		clean_dependencies();
		stat_dependencies();
		clean_files();
		
		return true;
	}

	void build(bool doexecute)
	{
		c2a parser;
		std::string cmd, precmd;
		
		bool dirty_link = false;
		
		for(size_t r=0;r<files.size();r++)
		{
			sproject::sfile *f = files[r].get();
			f->obj = make_intermediate_path(make_ext(f->file->file, ".o"));
			
			std::string final_file;
			if(f->ext)
				final_file = c2_libdir;
			
			final_file += f->file->file;
			
			
			bool dirty = f->is_dirty();
			
			if(dirty)
			{
				dirty_link = true;
				extract_dependencies(f, final_file);
				
#ifndef _MSC_VER
				cmd = use_clang ? "clang -I" + c2_incdir + " -g -c -Wall -fpic" : "g++ -I" + c2_incdir + " -g -c -Wall -fpic";
#else
				cmd = use_clang ? "clang -I" + c2_incdir + " -g -c -Wall" : "g++ -I" + c2_incdir + " -g -c -Wall";
#endif

				if(f->flags.size())
				{
					cmd += " " + f->flags;
				}
				
				cmd += " -o " + f->obj;
					
				if(f->c2)
				{
					std::string i = make_intermediate_path(make_ext(f->file->file, ".ii"));
					std::string ii = make_intermediate_path(make_ext(f->file->file, ".ii.ii"));
					
					precmd = use_clang ? "clang" : "g++";
					precmd += " -I" + c2_incdir;

					if(f->flags.size())
					{
						precmd += " " + f->flags;
					}

					precmd += " -E " + f->file->file + " > " + i;
 
					sh_execute(precmd.c_str());
					parser.process(i.c_str(), ii.c_str());
					
					parser_files = parser.files;	//Update copy for imm
					
					cmd += " " + ii;
				}
				else
				{
					
					cmd += " " + final_file;
				}
				
				cmd += " 2>&1";
				
				sh_execute(cmd.c_str());
				f->clear_dirty();
			}
		}
		
		if(dirty_link)
		{
			index_dependencies();
			save_imm(intermediatedir + "c2cache");
		}
		
		std::string link_target = get_link_target();

		if(!dirty_link)
		{
			dirty_link = !file_exist(link_target.c_str());
		}
		
		if(dirty_link)
		{
			cmd = (use_clang ? "clang -g -shared -o " : "g++ -g -shared -o ") + link_target;
			for(size_t r=0; r<files.size(); r++)
			{
				cmd += " " + files[r]->obj;
			}
			
			cmd += " 2>&1";
			sh_execute(cmd.c_str());
		}

		if(!load_module(link_target.c_str()))
			throw "Failed to load shared object";

		c2i *p = c2_object_instance(&command);
		
		for(size_t r=0; r<parser_files.size(); r++)
		{
			p->c2_config_setup_file(parser_files[r].c_str());
		}
		
		if(!p->c2_assemble())
		{
			throw "Assembly failed";
		}
		
		unload_module();

		if(doexecute && execute.size())
		{
			system(execute.c_str());
		}
	}
	
	c2i *(*c2_object_instance)(cmdi *) = nullptr;
#ifndef _MSC_VER
	void *hasm = nullptr;
#else
	HMODULE hasm;
#endif
	
	bool load_module(const char *path)
	{
		if(!hasm)
		{
#ifndef _MSC_VER
			hasm = dlopen(path, RTLD_LAZY);
#else
			hasm = LoadLibraryA(path);
#endif
			if(!hasm)
				return false;

#ifndef _MSC_VER
			c2_object_instance = (c2i *(*)(cmdi *)) dlsym(hasm, "c2_get_object_instance");
#else
			c2_object_instance = (c2i *(*)(cmdi *)) GetProcAddress(hasm, "c2_get_object_instance");
#endif
			if(!c2_object_instance)
			{
				unload_module();
				return false;
			}
		}
		
		return true;
	}
	
	void unload_module()
	{
		if(hasm)
		{
#ifndef _MSC_VER
			dlclose(hasm);
#else
			FreeLibrary(hasm);
#endif
			hasm = nullptr;
			c2_object_instance = nullptr;
		}
	}
	
	std::string get_link_target()
	{
#ifndef _MSC_VER
		return make_intermediate_path(make_ext(title, ".so"));
#else
		return make_intermediate_path(make_ext(title, ".dll"));
#endif
	}
};

int main(int arga, char *argc[])
{
	try
	{
		sproject proj;
		proj.command.add_args(arga, argc);
		
		proj.command.add_info("--help", "-h", "Show this help");
		proj.command.add_info("--license", "-gpl", "Show GPL3");
		proj.command.add_info("--rebuild", "-r", "Force a project rebuild");
		proj.command.add_info("--no-execute", "-ne", "Do not execute anything after build");
		proj.command.add_info("--no-build", "-nb", "Do not build");
		proj.command.add_info("--project", "-p", "<filename>: Explicitly load project file");
		proj.command.add_info("--create-project", "-cp", "<template> <name> [path]: Creates a new project based on the specified template. If a path is given it will be created and used, otherwise the current directory is used");
		proj.command.add_info("--list-templates", "-lt", "List available templates for project creation");
		
		bool doexecute = true;
		bool dobuild = true;
		std::string projpath;
		
		proj.command.invoke("--no-execute", 0, 0, [&](int arga, const char *argc[])
		{
			doexecute = false;
		});
		
		proj.command.invoke("--no-build", 0, 0, [&](int arga, const char *argc[])
		{
			dobuild = false;
		});
		
		proj.command.invoke("--create-project", 2, 3, [&](int arga, const char *argc[])
		{
			ctemplate tpl(proj.c2_libdir.c_str());
			projpath = tpl.create(arga, argc);
			doexecute = false; //Only build
		});
		
		proj.command.invoke("--list-templates", 0, 0, [&](int arga, const char *argc[])
		{
			ctemplate tpl(proj.c2_libdir.c_str());
			tpl.list();
			throw "";
		});
		
		bool loaded = false;
		
		proj.command.invoke("--project", 1, 1, [&](int arga, const char *argc[])
		{
			projpath = argc[0];
		});
		
		if(!projpath.size())
		{
			projpath = proj.command.main();
		}
		
		if(projpath.size())
		{
			if(!proj.load_project(projpath.c_str()))
			{
				throw "Error loading project file";
			}
			loaded = true;
			proj.command.add_args(proj.arguments.c_str());
		}
		
		proj.command.invoke("--help", 0, 0, [&](int arga, const char *argc[])
		{
			if(loaded)
			{
				// Try load and instance shared object
				if(proj.load_module(proj.get_link_target().c_str()))
				{
					proj.c2_object_instance(&proj.command);
				}
			}
			
			fprintf(stderr, TITLE);
			proj.command.printf_info();
			dobuild = false;
			doexecute = false;
		});
		
		proj.command.invoke("--license", 0, 0, [&](int arga, const char *argc[])
		{
			fprintf(stderr, TITLE);

			fprintf(stderr, "\nc2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\n"
							"c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\n"
							"You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.\n");
			
			dobuild = false;
			doexecute = false;
		});
		
		if(loaded && dobuild)
		{
			proj.build(doexecute);
		}
	}
	catch(const char *str)
	{
		if(*str)
		{
			fprintf(stderr, "%s\n", str);
			return -1;
		}
	}
	catch(...)
	{
		fprintf(stderr, "Unhandled exception\n");
		return -1;
	}
	
	return 0;
}
