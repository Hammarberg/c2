# c2 cross assembler
## Overview
c2 is an assembler wrapper top of a C++ compiler. c2 stems from retro/hobby assembler programming and the initial targets are common 8 and 16 bit platforms but doesn't have to be limited to that. It's architecture independend in the sense that all assembly pseudo opcodes are built with macros. Macro files can be included with the standard C pre-processor.

Some of the highlights:
* Macro oriented
* C pre-processor
* Inline C++ for additional meta-programming
* Multiple pass assembly for conditional code generation and forward references
### License
Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

This file is part of c2.

c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
### Contributors
John Hammarberg, Jocelyn Houle, Johan Samuelsson
## Build & Installation
make

VS2022 should also be able to build with the project file.

Put the c2 executable root in your path. Make sure the lib/ directory is next to c2 and that a 64 bit compatible clang or gcc is in path. The later might not always be the case in Windows.
### GNU/Linux/BSD
### Windows
# Usage
## Command line
c2 --help

Note that the help listing can extend with project specific options when a project file is loaded or detected.
## Templates overview
## Project files
## Your first simple project tutorial
c2 --list-templates

Create an empty folder for your project and step into it.

c2 --create-project c64vice myawesomeproject

When executing c2 without arguments in a project folder, it will build/assemble automatically.
# Syntax
## Comments
Only C/C++ style comments are supported.
## Numbers
## ORG pointer
Syntax: @ = <label/address>

Example: @ = $1000
### Relocation with ORG pointer
The ORG pointer contains two internal cursors. One is write location and the other is address location. Normally these are set to one and the same address. To assemble code with absolute adressing mode for another location than the writing cursor, use the relocation ORG pointer mode.

Syntax: @ = <label/address> \[,relocation label/address\]

Example: @ = @, $0200

This would keep writing to the current ORG but change addressing as it would be located at $0200.
To reset the addressing cursor, just assign ORG to itself with one argument like: @ = @
## Labels
### Local labels
### Anonymous labels
### Indexed labels
### Alternative label addressing
## Variables
### Indexed variables
## Macros
### Macro input
### Variadic macro input
## C pre-processor
## Inline C++
## Logging, warnings & errors
## c2 C++ interface
## yourproject.cpp / yourproject.s
# Defined targets / Templates
## 6502
A plain 6502 template with 64KB of RAM.
## vic20
## c264
## c64
Commodore 64 with provided utilities.
### c64vice
Commodore 64 with provided utilities configured to auto-lauch in VICE (x64) with symbols and optional breakpoints.
## c65
## 68000
## 68020
## ocs
## ecs
## z80
## msx
## 8080
## void
A plain template containing no included assembly pseudo opcodes. Useful for experimentation or rendering of binaries using macros and meta-programming. 10MB of RAM is allocated in the default project file, add more as needed.
