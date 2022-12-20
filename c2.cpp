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

#include "tokfeed.h"
#include "token.h"
#include "c2a.h"
#include "json.h"
#include "cmda.h"
#include "c2lib/include/c2/h/c2i.h"
#include "template.h"
#include "library.h"

#include <functional>
#include <ctime>
#include <filesystem>
#include <sys/stat.h>

#ifndef _WIN32
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
#define getcwd _getcwd
#endif


#define TITLE "c2 cross assembler 0.5  Copyright (C) 2022  John Hammarberg (CRT)\n"

const uint32_t MAGIC_VERSION = 1337*1337+3;

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

	n = fread(p, 1, n, fp);
	out.resize(n);
		
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

class sproject : public clibrary
{
public:

	sproject()
	{
	}
	
	~sproject()
	{
		unload_module();
	}
	
	bool verbose = false;

	cmda command;
	
	std::string compiler;

	std::filesystem::path basedir;
	std::filesystem::path intermediatedir = "imm";
	std::string title = "noname";
	std::string arguments;
	std::string execute;
	
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
			//printf("stat: %s\n", file);
			struct stat data;
			if(::stat(file, &data) >= 0)
			{
#ifdef	_WIN32
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
		bool stat_done = false;
		
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
			//printf("stat: %s\n", file.c_str());
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
	
	void stat_files()
	{
		for(auto i=files.rbegin();i!=files.rend();i++)
		{
			i->get()->file->stat();
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
	
	void extract_dependencies(sfile *data, const std::string &file, bool c2)
	{
		data->dependency.clear();

		char buf[1024];
		std::string command = compiler + " ";
		command += lib_generate_includes(c2) + " -MM -MG " + quote_path(file);
		std::string output;
		
		if (verbose)
		{
			fprintf(stderr, "Executing: %s\n", command.c_str());
		}

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
		{
			//printf("JPH CMD: '%s'\n", command.c_str());
			//printf("JPH OUT: '%s'\n", output.c_str());
			//printf("JPH FILE: '%s'\n", file.c_str());
			throw "Unexpected output";
		}

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
				//printf("Dep: %s\n", d.c_str());
				data->dependency.push_back(std::pair<std::shared_ptr<sdependency>, stimestamp>(add_dependency(d), stimestamp()));
			}
		}
	}
	
	std::string make_intermediate_path(std::string file)
	{
		std::replace(file.begin(), file.end(), '\\', '_');
		std::replace(file.begin(), file.end(), '/', '_');
		std::replace(file.begin(), file.end(), ' ', '_');
		std::replace(file.begin(), file.end(), ':', '_');
		std::filesystem::path path;
		path = intermediatedir / file;
		return path.string();
	}
	
	void save_imm(const std::filesystem::path &path)
	{
		FILE *fp = fopen(path.string().c_str(),"wb");
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
	
	void load_imm(const std::filesystem::path &path)
	{
		FILE *fp = fopen(path.string().c_str(),"rb");
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
		return std::filesystem::exists(path);
	}
	
	static std::string make_ext(const std::string &file, const char *ext)
	{
		return file.substr(0, file.rfind('.')) + ext;
	}
	
	void sh_execute(const char *str)
	{
		if(verbose)
		{
			fprintf(stderr ,"Executing: %s\n", str);
		}
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
			if(!verbose)
			{
				size_t t = output.find(char(0x0a));
				if(t != output.npos)
				{
					output = output.substr(0, t);
				}				
			}
			
			fprintf(stderr ,"%s\n", output.c_str());
			
			throw "Compile error";
		}
	}
	
	void set_compiler()
	{
		compiler = lib_cfg_get_string("compiler");
		if(!compiler.size())
		{
			// Try auto detect
			static const char *list[]={"clang++","clang","g++","gcc", nullptr};
			std::string tmp;
			for(int r=0; list[r]; r++)
			{
				bool found = false;
				
				try
				{
					tmp = list[r];
					tmp += " --version";
					sh_execute(tmp.c_str());
					found = true;
				}
				catch(const char *str)
				{
				}
				
				if(found)
				{
					compiler = list[r];
					break;
				}
			}
		}
		
		if(!compiler.size())
		{
			throw "No compiler found in path. Either add clang/gcc to system path or specify the path in config";
		}
	}
	
	bool load_project(const char* projectfile)
	{
		std::string bdata, tmp;
		if(!loadfile(projectfile, bdata))
			return false;
			
		// Stat projectfile before changing directory
		stimestamp tproj;
		tproj.stat(projectfile);

		std::unique_ptr<json::base> cfg(json::base::Decode(bdata.c_str()));

		// basedir
		basedir = projectfile;
		basedir = basedir.parent_path();

		tmp = cfg->Get("basedir").GetString();
		if (tmp.size())
		{
			basedir /= tmp;
		}

		chdir(basedir.string().c_str());
		lib_basepath();	// Let clibrary know we are in the project folder
		set_compiler();

		// Intermediate
		tmp = cfg->Get("intermediate").GetString();
		if (tmp.size())
		{
			intermediatedir = tmp;
		}

		std::filesystem::create_directories(intermediatedir);
		load_imm(intermediatedir / "c2cache");

		bool should_rebuild = false;
		
		// Invalidate everything if project file changed
		if(!(projecttime == tproj))
		{
			if(verbose)
			{
				fprintf(stderr, "%s is dirty\n", projectfile);
			}
			
			should_rebuild = true;
		}
		
		command.invoke("--rebuild", 0, 0, [&](int arga, const char *argc[])
		{
			should_rebuild = true;
		});

		if(should_rebuild)
		{
			dependencies.clear();
			files.clear();
		}
		
		projecttime = tproj;

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
				bool ext = ppair->second->Get("external").GetBool();

				std::filesystem::path path;
				if(ext)
				{
					path = lib_get_file_path(ppair->first.c_str());
				}
				else
				{
					path = ppair->first;
				}
				
				sfile* file = add_file(path.string());

				file->c2 = ppair->second->Get("c2").GetBool();
				file->flags = ppair->second->Get("flags").GetString();
				file->ext = ext;
			}
		}

		tmp = cfg->Get("title").GetString();
		if (tmp.size()) title = tmp;

		arguments = cfg->Get("arguments").GetString();
		execute = cfg->Get("execute").GetString();

		clean_dependencies();
		clean_files();
		
		//stat_files();
		stat_dependencies();
		
		return true;
	}
	
	void build(bool doexecute)
	{
		command.invoke("--include", 1, 1, [&](int arga, const char *argc[])
		{
			lib_add_include_path(argc[0]);
		});
		
		c2a parser(verbose);
		std::string cmd, precmd;
		
		bool dirty_link = false;
		
		for(size_t r=0;r<files.size();r++)
		{
			sproject::sfile *f = files[r].get();

			f->obj = make_intermediate_path(make_ext(f->file->file, ".o"));

			std::string file_subpath = f->file->file;

#ifdef _WIN32
			// Fix windows path to use backslashes.
			std::replace(file_subpath.begin(), file_subpath.end(), '/', '\\');
#endif
			std::filesystem::path final_file = file_subpath;
			
			bool dirty = f->is_dirty();
			if(verbose && dirty)
			{
				fprintf(stderr, "%s is dirty\n", final_file.string().c_str());
			}
			
			if(dirty)
			{
				dirty_link = true;
				extract_dependencies(f, final_file.string(), f->c2);

				cmd = compiler + " ";
				if(!f->c2)
				{
					cmd += lib_generate_includes(f->c2);
				}
				
				if(f->flags.size())
				{
					if(!f->c2)cmd += " ";
					cmd += f->flags;
				}
				
#ifndef _WIN32
				cmd += " -fpic";
#endif
				cmd += " -g -c -Wall -o " + quote_path(f->obj);
					
				if(f->c2)
				{
					std::string i = make_intermediate_path(make_ext(file_subpath, ".ii"));
					std::string ii = make_intermediate_path(make_ext(file_subpath, ".ii.ii"));
					
					precmd = compiler + " ";
					precmd += lib_generate_includes(true);

					if(f->flags.size())
					{
						precmd += " " + f->flags;
					}

					precmd += " -E " + quote_path(f->file->file) + " > " + quote_path(i);
 
					sh_execute(precmd.c_str());
					parser.process(i.c_str(), ii.c_str());
					
					parser_files = parser.files;	//Update copy for imm
					
					cmd += " ";
					cmd += ii;
				}
				else
				{
					cmd += " ";
					cmd += quote_path(final_file.string());
				}
				
				cmd += " 2>&1";
				
				sh_execute(cmd.c_str());
				f->clear_dirty();
			}
		}
		
		if(dirty_link)
		{
			index_dependencies();
			save_imm(intermediatedir / "c2cache");
		}
		
		std::string link_target = get_link_target();

		if(!dirty_link)
		{
			dirty_link = !file_exist(link_target.c_str());
		}
		
		if(dirty_link)
		{
			if(verbose)
			{
				fprintf(stderr, "%s is dirty\n", link_target.c_str());
			}
			
			cmd = compiler + " ";
			cmd += " -g -shared -o " + quote_path(link_target);
			for(size_t r=0; r<files.size(); r++)
			{
				cmd += " " + quote_path(files[r]->obj);
			}
			
			cmd += " 2>&1";
			sh_execute(cmd.c_str());
		}

		if (verbose)
		{
			fprintf(stderr, "Shared object path: '%s'\n", link_target.c_str());
		}

		if(!load_module(link_target.c_str()))
		{
			std::filesystem::path link_target_full = std::filesystem::absolute(link_target);
			if(!load_module(link_target_full.string().c_str()))
				throw "Failed to load shared object";
		}

		c2i *p = c2_object_instance(&command);
		
		p->c2_config_setup_info(title.c_str(), verbose);
		
		for(size_t r=0; r<parser_files.size(); r++)
		{
			p->c2_config_setup_file(parser_files[r].c_str());
		}

		{
			std::vector<std::string> includes;
			lib_generate_includes_array(includes);
			for(size_t r=0; r<includes.size(); r++)
			{
				p->c2_config_setup_include(includes[r].c_str());
			}
		}
		
		if(!p->c2_assemble())
		{
			throw "Assembly failed";
		}
		
		unload_module();

		if(doexecute && execute.size())
		{
			if(verbose)
			{
				fprintf(stderr ,"Executing: %s\n", execute.c_str());
			}
			
			system(execute.c_str());
		}
	}
	
	c2i *(*c2_object_instance)(cmdi *) = nullptr;
#ifndef _WIN32
	void *hasm = nullptr;
#else
	HMODULE hasm;
#endif
	
	bool load_module(const char *path)
	{
		if(!hasm)
		{
#ifndef _WIN32
			hasm = dlopen(path, RTLD_LAZY);
#else
			hasm = LoadLibraryA(path);
#endif
			if(!hasm)
				return false;

#ifndef _WIN32
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
#ifndef _WIN32
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
#ifndef _WIN32
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
		proj.command.add_info("--c2-library-dir", "-c2l", "<path>: Add a c2 library path");
		proj.command.add_info("--include", "-i", "<path>: Add an include search path for source and binaries");
		proj.command.add_info("--verbose", "-v", "Output more information");
		
		bool doexecute = true;
		bool dobuild = true;
		std::string projpath;
		
		proj.command.invoke("--verbose", 0, 0, [&](int arga, const char *argc[])
		{
			proj.verbose = true;
		});
		
		{
			std::vector<std::filesystem::path> exlib;
			proj.command.invoke("--c2-library-dir", 1, 1, [&](int arga, const char *argc[])
			{
				exlib.push_back(argc[0]);
			});
			
			proj.lib_initialize(exlib);
		}
		
		proj.command.invoke("--no-execute", 0, 0, [&](int arga, const char *argc[])
		{
			doexecute = false;
		});
		
		proj.command.invoke("--no-build", 0, 0, [&](int arga, const char *argc[])
		{
			dobuild = false;
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
		
		proj.command.invoke("--create-project", 2, 3, [&](int arga, const char *argc[])
		{
			ctemplate tpl(proj);
			projpath = tpl.create(arga, argc);
			doexecute = false; //Only build
		});
		
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
		
		proj.command.invoke("--list-templates", 0, 0, [&](int arga, const char *argc[])
		{
			ctemplate tpl(proj);
			tpl.list();
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