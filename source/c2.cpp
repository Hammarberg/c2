/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#include "project.h"
#include <cstdint>

#include "version.h"
#ifndef _MSC_VER
#include "gitversion.h"
#else
#define C2_GITVERSION "VS build"
#endif

static std::string version()
{
	std::string str = C2_VERSION;

	if(std::string(C2_GITVERSION) != "not set")
		str += " (" C2_GITVERSION ")";

	return str;
}

static std::string title()
{
	return std::string("c2 cross assembler version: " + version () + " - " C2_TAG "\nCopyright (C) 2022-2024  John Hammarberg (CRT)");
}

int main(int arga, char *argc[])
{
	try
	{
		sproject proj;
		proj.command.add_args(arga, argc);
		
		proj.command.declare("--help", "-h", "Show this help");
		proj.command.declare("--version", nullptr, "Show version");
		proj.command.declare("--license", "-L", "Show GPL3");
		proj.command.declare("--rebuild", "-r", "Force a project rebuild");
		proj.command.declare("--clean", nullptr, "Delete project intermediate files");
		proj.command.declare("--no-execute", "-X", "Do not execute anything after build");
		proj.command.declare("--no-build", "-B", "Do not build");
		proj.command.declare("--project", "-p", "<filename>: Explicitly load project file", 1);
		proj.command.declare("--direct", "-d", "<template> <source>: Direct assembly", 2);
		proj.command.declare("--create-project", "-c", "<template> <name> [path]: Creates a new project based on the specified template. If a path is given it will be created and used, otherwise the current directory is used", 2, 3);
		proj.command.declare("--list-templates", "-l", "List available templates for project creation");
		proj.command.declare("--c2-library-dir", "-D", "<path>: Add a c2 library path", 1);
		proj.command.declare("--c2-status", nullptr, "Print c2 library paths and configuration");
		proj.command.declare("--compiler", "-C", "<path>: Explicitly set compiler", 1);
		proj.command.declare("--include", "-i", "<path>: Add an include search path for source and binaries", 1);
		proj.command.declare("--verbose", "-v", "Output more information. Can be stacked for even more: -vvv");
		
		bool doexecute = true;
		bool dobuild = true;
		std::string projpath;
		
		proj.command.invoke("--verbose", [&](int arga, const char *argc[])
		{
			proj.verbose++;
		});
		
		{
			std::vector<std::filesystem::path> exlib;
			proj.command.invoke("--c2-library-dir", [&](int arga, const char *argc[])
			{
				exlib.push_back(argc[0]);
			});
			
			proj.lib_initialize(exlib);
		}
		
		proj.command.invoke("--no-execute", [&](int arga, const char *argc[])
		{
			doexecute = false;
		});
		
		proj.command.invoke("--no-build", [&](int arga, const char *argc[])
		{
			dobuild = false;
		});
		
		proj.command.invoke("--clean", [&](int arga, const char *argc[])
		{
			dobuild = false;
		});

		bool loaded = false;
		
		ctemplate::tjson direct_tpl;
		proj.command.invoke("--direct", [&](int arga, const char *argc[])
		{
			direct_tpl = proj.tpl_direct(arga, argc);
		});

		proj.command.invoke("--project", [&](int arga, const char *argc[])
		{
			projpath = argc[0];
		});
		
		if(!projpath.size())
		{
			projpath = proj.command.main();
		}
		
		proj.command.invoke("--create-project", [&](int arga, const char *argc[])
		{
			projpath = proj.tpl_create(arga, argc);
			doexecute = false; //Only build
		});
		
		if(projpath.size() || direct_tpl.get())
		{
			if(!proj.load_project(direct_tpl, projpath.c_str(), !dobuild))
			{
				throw "Error loading project file";
			}
			loaded = true;
			proj.command.add_args(proj.arguments.c_str(), true);	//Arguments from template
		}
		
		proj.command.invoke("--help", [&](int arga, const char *argc[])
		{
			// Try load and instance shared object
			if(loaded && proj.load_module())
			{
				proj.c2_object_instance(&proj.command);
			}
			else
			{
				// Look for any shared objects in the intermediatedir
				if(std::filesystem::exists(proj.intermediatedir))
				{
					for (auto const &entry : std::filesystem::directory_iterator(proj.intermediatedir))
					{
						std::string tmp = entry.path().string();

						size_t s = tmp.size();
#ifndef _WIN32
						if(s >= 3 && tmp.substr(s-3,3) == ".so")
#else
						if(s >= 4 && tmp.substr(s-4,4) == ".dll")
#endif
						{
							if(proj.load_module(tmp.c_str()))
							{
								proj.c2_object_instance(&proj.command);
								break;
							}
						}
					}
				}
			}
			
			fprintf(stdout, "%s\n", title().c_str());

			proj.command.printf_info();
			dobuild = false;
			doexecute = false;
		});
		
		proj.command.invoke("--version", [&](int arga, const char *argc[])
		{
			fprintf(stdout, "%s\n", version().c_str());
			dobuild = false;
			doexecute = false;
		});

		proj.command.invoke("--license", [&](int arga, const char *argc[])
		{
			fprintf(stdout, "%s\n\nc2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\n"
							"c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\n"
							"You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.\n",
							title().c_str());
			
			dobuild = false;
			doexecute = false;
		});
		
		proj.command.invoke("--list-templates", [&](int arga, const char *argc[])
		{
			ctemplate tpl(proj);
			tpl.tpl_list();
			dobuild = false;
			doexecute = false;
		});

		proj.command.invoke("--c2-status", [&](int arga, const char *argc[])
		{
			proj.lib_print();
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
