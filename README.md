# c2 cross assembler
### TODO and wish list
* Optimize C++ label template generation to greatly improve compile times.
* ~~Support local & global library folders.~~
* ~~Support user template/library configuration.~~
* ~~c2 file object to be exposed in c2i (also used by incbin internally).~~
* ~~Interface to stream stdout from external tools back into assembly.~~
* Option to bypass project file and only use switches.
* Cleanup/rewrite 6502 utilities and word extension.
* Support 65816, 65C02, 65802
* Finish 68000 support.
* Amiga hunk format and utility classes.
* Zilog 80 support.
* 8080 support.
* CP/M support.
* Cleanup error reporting.
* C64 RLE packer 0200-ffff.
* More, deeper and prettier README.
## Overview
c2 is an assembler wrapper top of a C++ compiler. c2 stems from retro/hobby assembler programming and the initial targets are common 8 and 16 bit platforms but doesn't have to be limited to that. It's architecture independent in the sense that all assembly pseudo opcodes are built with macros. Macro files can be included with the standard C pre-processor.

Much of the syntax should be familiar to anyone with Assembly, C/C++, Java, JS, C# experience.

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
Put the c2 executable root in your path. Make sure the lib/ directory is next to c2 and that a 64 bit compatible clang or gcc is in path. The later might not always be the case for Windows.
### GNU/Linux/BSD
`make`
### Windows
When installing VS2022, make sure to check the ticker to also install clang if you don't already have it installed.
# Usage
## Command line
`c2 --help`

Note that the help listing can extend with project specific options when a project file is loaded or detected.
## Templates overview
## Project files
## Your first simple project tutorial
`c2 --list-templates`

Create an empty folder for your project and step into it.

`c2 --create-project c64vice myawesomeproject`

Optionally you can create the destination path with c2 directly.

`c2 --create-project c64vice myawesomeproject sources/hack`

When executing c2 without arguments in a project folder, it will build/assemble automatically.
# Syntax
## Comments
Only C/C++ style comments are supported. This might hurt for some people used to `;` as comment prefix.
## Numbers
Decimal: `0, 1337`

Binary, prefixed with `0b` or `%` as in `0b10101010` or `%10100111001`.

Hexadecimal, prefixed with `0x` or `$` as in `0xfffd` or `$0x1B46B1`.

Octal numbers looks a lot like decimal number but are prefixed with a `0` as in `020, 02471`. Beware of this if you have a habit of prefixing decimal numbers with `0` for purey estetical reasons.

### Explicit bit size
You can explicitly force a bit size by prefixing hexadecimal, binary or octal numbers.

```
        lda $0002
```
## ORG pointer
Note, many classical assembler uses `*` for ORG but not c2. Instead the at (`@`) sign is used.

Syntax: `@ = <label/address>`

Example: `@ = 0xa00000` or `@ = base + $fe00`

ORG can be read as a variable.

Example:
```
        move.w @ + offset, d0
        bra @   //Loop forever
```
ORG is evaluated at the beginning of the line before any opcode is counted, just like a modern programming language. This can differ from some older assemblers where ORG was evaluated at its ordinal position, after any initial opcodes.
### Relocation with ORG pointer
The ORG pointer contains two internal pointers. One is the write pointer and the other is the address pointer. Normally these are set to one and the same address. It's possible to assemble code with absolute addressing of another location to the current writing pointer.

Syntax: `@ = <write address> [,addressing address]`

Example: `@ = @, $0200`

This would keep writing to the current ORG but change addressing as it would be located at `$0200`. The code would obviously have to be relocated to `$0200` before being executed. To reset the addressing pointer, just assign ORG to itself with one argument like: `@ = @`
## Labels
Labels represents an address. Labels are global in the assembly namespace, must to be unique and declared first on a line.

Syntax: `<name>:`

Example:
```
loop:   dex
        bpl loop
```
### Local labels
A label can be local under its parent label namespace when prefixed with a dot. This greatly reduses the risk of label name conflicts.

Syntax: `.<name>:`

Example:
```
start:
.loop:  dex
        bpl .loop
mid:
.loop:  dey
        bpl .loop
```
Local labels can be referenced from the outside of its parent scope by `<parent>.<local>`.

Example:
```
main:
        moveq #data.end - data, d0
data:
        dword $01020304, $baadbeef
.end:
```
### Anonymous labels
Anonymous labels doesn't have to be unique and are declared with a single colon at the beginning of a line.

Example:
```
:       dex
        bpl -
```
### Relative label addressing
When referencing a label, it's normally done by name. Anonymous labels can only be referenced with a relative count from the current location. To reference the previous label use a single `-`, to reference two labels back use `--`, etc. In the same way, use one or more`+` to reference forward labels.
### Indexed labels
Indexed labels are global in nature but they won't provide a namespace for local labels. They have to be declared and referenced with an index number or a variable.

Syntax: `<name>[<index>]:`

Example:
```
data[0]: byte $bd
data[1]: byte $ff
```
## Variables
c2 provides a variable type, internally it holds up to 64 bits signed.

Syntax: `var <name> [= expression]`

```
        var x = 5
```
Currently, variables doesn't support label namespaces (design decisions yet to be made) and works more like C++ variables. If you need to limit a scope of a variable you can use C++ scopes:
```
{
        var x = 5
        //Other code here
}
```
Variables can hold and remeber explicit bit counts:
```
        var src = $0002
        lda src //Absolute rather than zero page addressing mode
```
Variables declared inside macros are automatically scoped to the macro.
### C/C++ variables
You are free to use C/C++ variables in almost all cases where you would use an assembler variable. Just remember to apply `;` as in C-syntax.

Example:
```
        int y = $1234 + offset;
```
### Indexed variables
## Macros
In its simplest form, macros are pieces of declared information that can be recalled by a reference at any point. They are expanded inline at the point of reference. When c2 encounters an alphanumerical, declared macros are searched for a match.

Syntax:
```
macro <name> [arguments]
{
        [contents]
}
```
Example:
```
macro nop
{
        byte 0xea
}
```
Macros are case insensitive and are simply recalled by name.

Example:
```
        nop
```
This will be expanded back to:
```
        byte 0xea
```
Macros contain its own label namespace. Local labels can therefore be used inside a macro without risk of conflict. Global labels inside a macro is generally a bad idea since the macro can only be referenced once. For referencing data inside an expanded macro, look at indexed labels.
### Macro inputs
Macro inputs are carried in c2 variables and are declared in the header of the macro.

Example:
```
macro move_byte @src, @dst
{
        lda src
        sta dst
}

        move_byte $1000, $1001
```
`@` is in this context used to prefix a variable name in the macro header (not to be confused with ORG). Other literals declared in the header have to match the reference.

Syntax: `@<name>`
#### Macro overloading
Macros can be overloaded using the same name but with unique input declarations.
```
macro move_byte #@src, @dst
{
        lda #src
        sta dst
}
macro move_byte @src, @dst
{
        lda src
        sta dst
}
        move_byte #123, $1000
        move_byte $1000, $2000
```
Matching of a macro is done in the order they are declared. When using paranthesis in expressions, consider these examples:
```
macro dowork @input
{
        //First
}

macro dowork (@input)
{
        //Second
}

        dowork 5*(3+1)          //Matches only the first
        dowork (5*(3+1))        //Matches the first but would also match the second, is that intentional?
```
### Indexed input
### Variadic input
## C pre-processor
## Inline C++
### C++ expressions
## Logging, warnings & errors
## c2 C++ interface
## yourproject.cpp / yourproject.s
### Custom C++ extensions
## c2lib directory
Besides the executable, c2 is also dependent on its library to operate. The library contains necessary include files, source files and templates for project creation.

`include/c2` contains target platform and architecture specific includes sorted in sub folders. The `h` folder is reserved for C++ includes used by c2.

`source` contains target platform and architecture specific C++ files compiled alongside projects.

`template` contains templated base files referenced by `templates.c2.json`. These are copied and translated to your project folder when creating a new project.
### c2lib search order
* In the project path alongsone `<project>.c2.json`
* Explicitly set with `--c2-library-dir`
* Nix home folder as `.c2lib` or `c2lib`. For windows `%LOCALAPPDATA%\c2lib`
* At location of environment variable `C2LIB_HOME`
* Nix global path `/usr/lib/c2lib`
* Alongside executable

It's possible to copy, modify or extend parts of c2lib and place those modifications in your local directory to override.
## Include files & search order
Additional include search paths can be added with one or multiple `--include <path>` or `-i <path>`. This works for both pre-processor includes as well as incbin or c2 file system.

It searches the explicitly set paths first followed by the include folders in c2lib.
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
