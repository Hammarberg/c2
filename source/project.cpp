/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/
#include "project.h"
#include "json.h"
#include "c2a.h"
#include "log.h"
#include "c2lib/include/c2/h/c2t.h"

#include <cstring>
#include <sys/stat.h>
#include <algorithm>

#ifndef _WIN32
#include <dlfcn.h>
#include <unistd.h>
#else
#include <direct.h>
#define popen _popen
#define pclose _pclose
#define chdir _chdir
#endif

const uint32_t MAGIC_VERSION = 1337*1337+4;

#define C2CACHE std::string(title+std::string("_c2cache"))

sproject::sproject()
    :command(this)
{
}

sproject::~sproject()
{
    unload_module();
}

sproject::stimestamp::stimestamp()
{
    memset(&mtim, 0, sizeof(mtim));
}

void sproject::stimestamp::save(FILE *fp)
{
    fwrite(&mtim, 1, sizeof(mtim), fp);
}

void sproject::stimestamp::load(FILE *fp)
{
    fread(&mtim, 1, sizeof(mtim), fp);
}

bool sproject::stimestamp::operator==(const stimestamp &o) const
{
    return memcmp(&mtim, &o.mtim, sizeof(mtim)) == 0;
}

void sproject::stimestamp::stat(const char *file)
{
    //printf("stat: %s\n", file);
    struct stat data;
    if(::stat(file, &data) >= 0)
    {
#if defined(_WIN32) || defined(_WIN64) || defined(__APPLE__)
        mtim = data.st_mtime;
#else
        mtim = uint64_t(data.st_mtim.tv_sec);
#endif
    }
}

void sproject::sdependency::save(FILE *fp)
{
    c2tools::save(fp, file);
}

void sproject::sdependency::load(FILE *fp)
{
    c2tools::load(fp, file);
}

void sproject::sdependency::stat()
{
    //printf("stat: %s\n", file.c_str());
    timestamp.stat(file.c_str());
}

void sproject::sfile::save(FILE *fp)
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

void sproject::sfile::load(FILE *fp, std::vector<std::shared_ptr<sdependency>> &dependencies)
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

bool sproject::sfile::is_dirty()
{
    if(!sproject::file_exist(obj.c_str()))	// No obj file, rebuild
	{
		VERBOSE(3, "%s is missing\n", obj.c_str());
        return true;
	}

    if(!dependency.size()) // There is always at least one unless imm was not loaded, then rebuild
	{
		VERBOSE(3, "im not loaded\n");
        return true;
	}

    for(size_t r=0;r<dependency.size();r++)	// Check if a dependency has been modified
    {
        if(!(dependency[r].second == dependency[r].first->timestamp))
		{
			VERBOSE(3, "Dependency change\n");
            return true;
		}
    }
    return false;
}

void sproject::sfile::clear_dirty()
{
    for(size_t r=0;r<dependency.size();r++)
    {
        dependency[r].second = dependency[r].first->timestamp;
    }
}

void sproject::clean_files()
{
    for(auto i=files.rbegin();i!=files.rend();i++)
    {
        if(!i->get()->active)
        {
            files.erase(i.base());
        }
    }
}

void sproject::clean_dependencies()
{
    for(auto i=dependencies.rbegin();i!=dependencies.rend();i++)
    {
        if(i->use_count() == 1 /* i->unique()*/)
        {
            dependencies.erase(i.base());
        }
    }
}

void sproject::stat_dependencies()
{
    for(auto i=dependencies.begin();i!=dependencies.end();i++)
    {
        i->get()->stat();
    }
}

void sproject::stat_files()
{
    for(auto i=files.rbegin();i!=files.rend();i++)
    {
        i->get()->file->stat();
    }
}

void sproject::index_dependencies()
{
    size_t index = 0;
    for(auto i=dependencies.begin();i!=dependencies.end();i++)
    {
        i->get()->index = index;
        index++;
    }
}

sproject::sfile *sproject::add_file(const std::string &file)
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


std::shared_ptr<sproject::sdependency> sproject::search_dependecy(const std::string &file)
{
    for(size_t r=0; r<dependencies.size(); r++)
    {
        auto ptr = dependencies[r];
        if(ptr->file == file)
            return ptr;
    }

    return nullptr;
}

std::shared_ptr<sproject::sdependency> sproject::add_dependency(const std::string &file)
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

void sproject::extract_dependencies(sproject::sfile *data, const std::string &file, bool c2)
{
    data->dependency.clear();

    char buf[1024];
    std::string command = compiler + " ";
    command += lib_generate_includes(c2) + stdc + " -MM -MG " + quote_path(file);
    std::string output;

    VERBOSE(2,"Executing: %s\n", command.c_str());

#ifdef _WIN32
    command = "\"" + command + "\"";
#endif
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
                if(p[1] != ' ')
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

std::string sproject::make_intermediate_path(std::string file)
{
    std::replace(file.begin(), file.end(), '\\', '_');
    std::replace(file.begin(), file.end(), '/', '_');
    std::replace(file.begin(), file.end(), ' ', '_');
    std::replace(file.begin(), file.end(), ':', '_');
    std::filesystem::path path;
    path = intermediatedir / file;
    return path.string();
}

void sproject::save_imm(const std::filesystem::path &path)
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
        c2tools::save(fp, parser_files[r]);
    }

    fclose(fp);
}

void sproject::load_imm(const std::filesystem::path &path)
{
    FILE *fp = fopen(path.string().c_str(),"rb");
    if(!fp)
    {
		VERBOSE(3, "%s not found\n", path.string().c_str());
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
        c2tools::load(fp, stmp);
        parser_files.push_back(stmp);
    }

    fclose(fp);
}

bool sproject::file_exist(const char *path)
{
    return std::filesystem::exists(path);
}

std::string sproject::make_ext(const std::string &file, const char *ext)
{
    return file.substr(0, file.rfind('.')) + ext;
}

void sproject::sh_execute(const char *str, bool silent)
{
    char buf[1024];

#ifdef _WIN32
    std::string tmp = quote_path(str);
#else
    std::string tmp = str;
#endif
    VERBOSE(2 ,"Executing: %s\n", tmp.c_str());
    FILE *ep = popen(tmp.c_str(), "r");
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
        if (!silent)
        {
            fprintf(stderr, "%s\n", output.c_str());
        }

        throw "Compile error";
    }
}

void sproject::set_compiler()
{
    command.invoke("--compiler", [&](int arga, const char *argc[])
    {
        compiler = quote_path(argc[0]);
    });

    if(!compiler.size())
    {
        compiler = quote_path(lib_cfg_get_string("compiler"));
    }

    if(!compiler.size())
    {
        // Try auto detect
        static const char *list[]={
            "clang++",
#ifdef _WIN32
            "C:\\Program Files\\LLVM\\bin\\clang++",
            "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\Llvm\\x64\\bin\\clang++",
            "C:\\Program Files\\Microsoft Visual Studio\\2022\\Professional\\VC\\Tools\\Llvm\\x64\\bin\\clang++",
#endif
            "g++",
            nullptr};

        std::string tmp;
        for(int r=0; list[r]; r++)
        {
            bool found = false;

            try
            {
                tmp = quote_path(list[r]);
                tmp += " --version 2>&1";
                sh_execute(tmp.c_str(), true);
                found = true;
            }
            catch(const char *)
            {
            }

            if(found)
            {
                compiler = quote_path(list[r]);

                break;
            }
        }
    }

    if(!compiler.size())
    {
        throw "No compiler found in path. Either add clang/gcc to system path, specify the full path in config or set using --compiler";
    }

    if(compiler.find("clang") != std::string::npos)
    {
        stdc = " -std=c++17";
    }
    else
    {
        stdc = " -std=gnu++17";
    }
}

bool sproject::load_project(ctemplate::tjson cfg, const char* projectfile, bool readonly)
{
    std::string tmp;

    stimestamp tproj;
	bool direct = true;
	if(!cfg.get())
	{
		std::string bdata;
		if(!lib_load_file_direct(projectfile, bdata))
			return false;

		cfg.reset(json::base::Decode(bdata.c_str()));
		// Stat projectfile before changing directory
		tproj.stat(projectfile);
		direct = false;
	}

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

    tmp = cfg->Get("title").GetString();
    if (tmp.size()) title = tmp;

    arguments = cfg->Get("arguments").GetString();
    execute = cfg->Get("execute").GetString();
    template_name = cfg->Get("template").GetString();
    flags = cfg->Get("flags").GetString();

    if(!template_name.size())
    {
        VERBOSE(0, "Warning: %s is outdated and missing a template pair\n"
        "To repair, add: \"template\": \"template name here\",\n", projectfile);
    }

    // Intermediate
    tmp = cfg->Get("intermediate").GetString();
    if (tmp.size())
    {
        intermediatedir = tmp;
    }

    command.invoke("--clean", [&](int arga, const char *argc[])
    {
        std::filesystem::remove_all(intermediatedir);
    });

    if(!readonly)
    {
        std::filesystem::create_directories(intermediatedir);
    }

    load_imm(intermediatedir / C2CACHE);

    bool should_rebuild = false;

    // Invalidate everything if project file changed
    if(!direct && !(projecttime == tproj))
    {
        VERBOSE(2, "%s is dirty\n", projectfile);
        should_rebuild = true;
    }

    command.invoke("--rebuild", [&](int arga, const char *argc[])
    {
        should_rebuild = true;
    });

    if(should_rebuild)
    {
        dependencies.clear();
        files.clear();
    }

    projecttime = tproj;

    // Temporary hack not to completely break projects.
    bool c64 = false;

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

            // Temporary hack not to completely break projects
            if(ppair->first == "source/c64.cpp" || ppair->first == "source\\c64.cpp")
                c64 = true;
        }
    }

    // Library source files from template
    if(template_name.size())
    {
        tjson tp = tpl_load(template_name.c_str());

        json::array*p = (json::array*)tp->Find("source");
        if (p->GetType() != json::type::ARRAY)
        {
            throw "source type not array";
        }

        json::iterate(p, json::PAIR, [&](json::base *i)
        {
            json::pair* ppair = (json::pair*)i;
            if(ppair->second->GetType() == json::CONTAINER)
            {
                std::filesystem::path src("source");
                src /= ppair->first;

                sfile* file = add_file(lib_get_file_path(src.string().c_str()).string());

                file->c2 = ppair->second->Get("c2").GetBool();
                file->flags = ppair->second->Get("flags").GetString();
                file->ext = ppair->second->Get("external").GetBool();
            }
        });
    }
    else
    {
        // Temporary hack. If template is missing and c64.cpp was seen. cbm.cpp will also be needed.
        if(c64)
        {
            std::filesystem::path src("source");
            src /= "cbm.cpp";

            sfile* file = add_file(lib_get_file_path(src.string().c_str()).string());

            file->c2 = false;
            file->flags = "-O2";
            file->ext = true;
        }
    }

    clean_dependencies();
    clean_files();

    //stat_files();
    stat_dependencies();

    return true;
}

void sproject::build(bool doexecute)
{
    command.invoke("--include", [&](int arga, const char *argc[])
    {
        lib_add_include_path(argc[0]);
    });

    set_compiler();

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

        if(dirty)
        {
            VERBOSE(1, "%s is dirty\n", final_file.string().c_str());

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
            cmd += stdc + " -c -o " + quote_path(f->obj);

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

                precmd += stdc + " -E " + quote_path(f->file->file) + " > " + quote_path(i);

                sh_execute(precmd.c_str());
                parser.process(i.c_str(), ii.c_str());

                parser_files = parser.files;	//Update copy for imm

                cmd += " ";
                cmd += ii;
            }
            else
            {
                cmd += " -Wall ";
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
        save_imm(intermediatedir / C2CACHE);
    }

    std::string link_target = get_link_target();

    if(!dirty_link)
    {
        dirty_link = !file_exist(link_target.c_str());
    }

    if(dirty_link)
    {
        VERBOSE(1, "%s is dirty\n", link_target.c_str());
        cmd =
            compiler +
            stdc +
            (flags.size() ? " " + flags : "") +
            " -shared -o " +
            quote_path(link_target);

        for(size_t r=0; r<files.size(); r++)
        {
            cmd += " " + quote_path(files[r]->obj);
        }

        cmd += " 2>&1";
        sh_execute(cmd.c_str());
    }

    VERBOSE(2, "Shared object path: '%s'\n", link_target.c_str());

    if(!load_module())
    {
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
        VERBOSE(2 ,"Executing: %s\n", execute.c_str());

        system(execute.c_str());
    }
}

bool sproject::load_module(const char *name)
{
    std::string tmpname;
    if(!name)
    {
        tmpname = get_link_target();
        name = tmpname.c_str();
    }

    if(!hasm)
    {
        VERBOSE(3, "Attempting to load shared object %s\n", name);
#ifndef _WIN32
        hasm = dlopen(name, RTLD_LAZY);
#else
        hasm = LoadLibraryA(name);

        if (!hasm)
        {
            std::filesystem::path link_target_full = std::filesystem::absolute(name);

            VERBOSE(3, "Attempting to load shared object %s\n", link_target_full.string().c_str());

            hasm = LoadLibraryA(link_target_full.string().c_str());
        }
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
            VERBOSE(1, "Failed to resolve c2_get_object_instance\n");

            unload_module();
            return false;
        }
    }

    return true;
}

void sproject::unload_module()
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

std::string sproject::get_link_target()
{
#ifndef _WIN32
    return make_intermediate_path(make_ext(title, ".so"));
#else
    return make_intermediate_path(make_ext(title, ".dll"));
#endif
}
