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

#include "c2version.h"
#include "c2gitversion.h"
#define C2_DISPLAYVERSION C2_VERSION " (" C2_GITVERSION ")"

#define TITLE "c2 cross assembler version: " C2_DISPLAYVERSION "\nCopyright (C) 2022-2024  John Hammarberg (CRT)\n"

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
		proj.command.declare("--no-execute", "-X", "Do not execute anything after build");
		proj.command.declare("--no-build", "-B", "Do not build");
		proj.command.declare("--project", "-p", "<filename>: Explicitly load project file", 1);
		proj.command.declare("--create-project", "-c", "<template> <name> [path]: Creates a new project based on the specified template. If a path is given it will be created and used, otherwise the current directory is used", 2, 3);
		proj.command.declare("--list-templates", "-l", "List available templates for project creation");
		proj.command.declare("--c2-library-dir", "-D", "<path>: Add a c2 library path", 1);
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
		
		bool loaded = false;
		
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
			ctemplate tpl(proj);
			projpath = tpl.tpl_create(arga, argc);
			doexecute = false; //Only build
		});
		
		if(projpath.size())
		{
			if(!proj.load_project(nullptr, projpath.c_str(), !dobuild))
			{
				throw "Error loading project file";
			}
			loaded = true;
			proj.command.add_args(proj.arguments.c_str());
		}
		
		proj.command.invoke("--help", [&](int arga, const char *argc[])
		{
			if(loaded)
			{
				// Try load and instance shared object
				if(proj.load_module())
				{
					proj.c2_object_instance(&proj.command);
				}
			}
			
			fprintf(stdout, TITLE);

			proj.command.printf_info();
			dobuild = false;
			doexecute = false;
		});
		
		proj.command.invoke("--version", [&](int arga, const char *argc[])
		{
			fprintf(stdout, C2_DISPLAYVERSION "\n");
			dobuild = false;
			doexecute = false;
		});

		proj.command.invoke("--license", [&](int arga, const char *argc[])
		{
			fprintf(stdout, TITLE);

			fprintf(stdout, "\nc2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\n"
							"c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\n"
							"You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.\n");
			
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
