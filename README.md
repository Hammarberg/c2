# c2 cross assembler
### TODO and wish list
* Finish 68000 support.
* Amiga hunk format and utility classes.
* Optimize C++ lambda to generation to greatly improve compile times.
* Option to bypass project file and only use switches.
* Support 65816, 65802.
* Zilog 80 support.
* 8080 support.
* CP/M support.
* Templates for vic20, c264.
* Set pre-processor switch.
* Set variable switch.
* Flag and hash+store switches to intermediate data that would affect compile outcome.
* Cache labels between builds.
* More, deeper and prettier README.
## Overview
c2 is an assembler wrapper top of a C++ compiler. It's architecture independent in the sense that all assembly pseudo opcodes are built with macros. Macro files can be included with the standard C pre-processor.

Much of the syntax should be familiar to anyone with Assembly, C/C++, Java, JS, C# experience.

Some of the highlights:
* Macro oriented
* C pre-processor
* Inline C++ for additional meta-programming
* Multiple pass assembly for conditional code generation and forward references
### License
Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

This file is part of c2.

c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
### Contributors
John Hammarberg, Jocelyn Houle, Johan Samuelsson, Monstersgoboom
## Build & Installation
c2 requires llvm/clang++ or g++ for both building c2 itself and for running c2. At this point c2 has only been tested on 64 bit hosts with little endian.

Put the c2 executable in your path. Make sure the c2lib/ directory is next to c2 or two levels above (see c2lib section) and that a 64 bit compatible clang++ or g++ is in path.
### GNU/Linux/BSD/OSX
`make` and `sudo make install`

To uninstall, `sudo make uninstall`

If necessary, modify Makefile to your needs. Currently it's set to use `clang++` but `g++` works just as well. `-march=native` is set. While this can give extra optimizations for your particular CPU, it makes the executable less portable and have to be removed if you want to compile on an ARM CPU.
### Windows
c2 can be built with either VS2022 or clang/LLVM. If you don't already have clang installed, you will have to install it anyways since it's a dependency that is used by c2 during assembly.

Clone or unzip c2 to an empty folder.
#### Option 1: clang/LLVM
The easiest and recommended method is to install [clang/LLVM](https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.6/LLVM-15.0.6-win64.exe). Use the default installation path and/or select to set environment variables and path so c2 can find clang. If clang is not in path, c2 will look for clang at `C:\Program Files\LLVM\bin\clang++`.

Run `WindowsLLVMBuild.bat` and a c2 executable should be created in the same folder.
#### Option 2: VS2022
If you prefer or already have [Visual Studio 2022 Community](https://visualstudio.microsoft.com/vs/community/) or better installed you can use that. However, you also need to select during install, or modify an existing installation to include clang tools as they are provided as an option in the VS installer. If clang is not in path, c2 will look for clang at `C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\Llvm\x64\bin\clang++`.

Run `WindowsVSBuild.bat` and a c2 executable should be created under `x64\Release\c2.exe`. You may of course also open the solution in VS2022 and build there.
#### PATH
My Computer -> Properties -> Advanced System Settings -> Environment Variables -> Edit path for either User or System. Set the path to the directory where `c2.exe` was built to.

If you are using VICE emulator with c2, it's great to also set `x64sc.exe` to path and it will launch automatically.
# Usage
## Command line
When executing c2 without any arguments in a project folder, it will build/assemble and depending on the settings in the project file, it can automatically launch an emulator if in path. However, there are many useful command line switches you can use directly or in conjunction with a project file. To get an overview:

`c2 --help` or simply `c2 -h`.

Note that the help listing will extend with project specific options when a project file is loaded or detected in the same folder. For example, a Motorola 68000 project might have different switches listed compared to a MOS 6502 project.

c2 command line switches comes in two variants, the descriptive long version prefixed with two dahses (`--`) and the short variant prefixed with a single dash (`-`). Switches can take optional arguments. The description of each switch has `<mandatory>` and `[optional]` argument fields. Arguments are separated from the switch with a space like `--out file.bin`. Short switches with no or only optional arguments can be stacked and in that case only the last switch of the stack can have arguments: `-rvVo file.bin` where `-o` is the short version of `--out`.
## Templates overview
## Project files
## Your first simple project tutorial
c2 comes with a set of predefined templates for creating new projects.

`c2 --list-templates`

Create an empty folder for your project and step into it.

`c2 --create-project c64vice myawesomeproject`

Optionally you can create the destination path with c2 directly. For Windows, use backslashes (`\`) for paths.

`c2 --create-project c64vice myawesomeproject sources/hack`

When executing c2 without arguments in a project folder, it will build/assemble and depending on the template, it can automatically launch an emulator if in path.
# Compile and assembly errors, tips and tricks
Internally c2 translates much of the assembly source file into intermediate C++ for the first steps. When this goes wrong, which it will do when a human inevitable makes a mistake like a typo or forgotten reference, the error can look very cryptic. The C++ compiler might mention pieces of code that does not look familiar to the assembly source. The important part here is to look at the line number and source file mentioned rather than the error itself. If it's still not obvious what is wrong in the assembly source, try the `--verbose` (`-v`) switch to view more of the compiler output.
# Syntax
## Comments
Only C/C++ style comments are supported. This might hurt for some people used to `;` as comment prefix.
## Numbers
Decimal: `0, 1337`

Binary, prefixed with `0b` or `%` as in `0b10101010` or `%10100111001`.

Hexadecimal, prefixed with `0x` or `$` as in `0xfffd` or `$1B46B1`.

Octal numbers looks a lot like decimal number but are prefixed with a `0` as in `020, 02471`. Beware of this if you have a habit of prefixing decimal numbers with `0` for esthetics.

### Explicit bit size
You can explicitly force a bit size by prefixing hexadecimal, binary or octal numbers.

```
        lda $0002
```
## ORG pointer
Note, many classical assemblers use `*` for ORG but not c2. Instead the at (`@`) sign is used.

Syntax: `@ = <address/expression>`

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
Labels represents an address. Labels are global in the assembly namespace, must be unique and declared first on a line.

Syntax: `<name>:`

Example:
```
loop:   dex
        bpl loop
```
### Local labels
A label can be local under its parent label namespace when prefixed with a dot. This greatly reduces the risk of label name conflicts.

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
#### Local labels in repeated scopes (auto indexed)
```
for(int index=0; index<10; index++)
{
        lda data+index
        beq .small
        bmi .exit
        sta store+index
.small:
}
.exit:
```
There is nothing to consider as a programmer here except that this mode works automatically when a scope is repeated. The label `.small` is in this case duplicated 10 times and automatically indexed. Beware this can break or cause bugs when scopes and repeats are too complicated for c2 to resolve. For a more explicit control over the labels see see indexed labels below.
### Anonymous labels
Anonymous labels are declared with a single colon at the beginning of a line and can only be referenced with relative addressing.

Example:
```
:       dex
        bpl -
```
### Relative label addressing
When referencing a label, it's normally done by name. Anonymous labels can only be referenced with a relative count from the current location. To reference the previous label, anonymous or not, use a single `-`, to reference two labels back use `--`. In the same way, use one or more`+` to reference forward labels.
### Indexed labels
Indexed labels are global in nature but they won't provide a namespace for local labels. They have to be declared and referenced with an index number or a variable. They are meant as a tool to address auto-generated code or expanded macros.

Syntax: `<name>[<index>]:`

Example:
```
        jmp data[10]

for(int index=0; index<20; index++)
{
data[index]:
        //Other code or data here
}
```
## c2 variables
c2 provides a variable type, internally it holds up to 64 bits signed.

Syntax: `var <name> [= expression]`
```
        var x = 5
        // When declaring and assigning a variable, there is no need to add a ';'.
        // If you re-assign it, it will be needed
        x = 10;
```
Currently, variables doesn't support label namespaces (design decisions yet to be made) and works more like C++ variables. If you need to limit a scope of a variable you can use C++ scopes:
```
{
        var x = 5
        //Other code here
}
```
Variables can hold and remenber explicit bit counts:
```
        var src = $0002
        lda src //Absolute rather than zero page addressing mode
```
Variables declared inside macros are automatically scoped to the macro.
### Indexed, array & string variables
A variable can be used as an array or string.
```
        var x = {12,34,$56}
        var y = "hollow world"

        c2_info("Assembling PETSCII: %s", y.str());
        petscii y

        // Use of member method .size()
        for(size_t i=0; i<x.size(); i++)
        {
                byte x[i]
        }
```
### C/C++ variables
You are free to use C/C++ variables in almost all cases where you would use a c2 variable. Just remember to apply `;` as in C-syntax.

Example:
```
        int y = $1234 + offset;
        move.b y, d0
```
## Macros
In its simplest form, macros are pieces of declared information that can be recalled by a reference at any point. They are expanded inline at the point of reference. When c2 encounters an alphanumerical, declared macros are searched for a match.

Syntax:
```
macro <name>,[alias] [arguments]
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
In this example, byte is also a macro that will be expanded.

Macros have to be declared before the point of it being referenced and expanded. However, macros can reference other macros not yet declared as long as all macros are known at the time of reference/expansion.
### Macro namespace
Macros contain its own label namespace. Local labels can therefore be used inside a macro without risk of conflict. Global labels inside a macro has some use cases but is generally a bad idea since the macro can only be referenced once. For referencing data inside an expanded macro, look at indexed labels.
### Macro alias
Aliases for macros can be declared with a comma separated list.
```
macro nop,slack,nada
{
        byte 0xea
}
        slack //same as nop
```
### Macro inputs
Macro inputs are carried in variables and are declared in the header of the macro. When a macro reference is examined for a match with a macro, arguments are examined against the declared header. Declared inputs are prefixed with `@` and are followed by a label name to carry that input. Other characters are matched literally to the reference.

Example:
```
macro move_byte @src, @dst
{
        lda src
        sta dst
}
        move_byte $1000, $1001
```
To recall `move_byte`, its name or alias must be referenced followed by at least one white space, a number or other expression for `@src`, a comma (`,`) and another expression for `@dst`. Note that `@` is in this context used to prefix a variable name in the macro header (not to be confused with ORG).
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
The difference between the these macros in this case is the prefix `#` for `@src`. It must be matched literally.

A referenced macro is matched against declared macros with the most parameter/operators first. While it's legal to completely wrap your expression in parentheses, this can however interfere with macro matching if you are not careful. Consider these examples:
```
        lda variable+2,y        //lda @n,y is matched
        lda (variable+2),y      //lda (@n),y indirect zero page is matched
        lda 2+(variable),y      //lda @n,y is matched
```
### String input
As input is handled in c2 variables, strings are valid expressions.
### Enum input
A macro input can be an enum much like a zero based C enum by declaring the input with a comma separated list with literals within square brackets. An input have to match one of the enum strings specified and the variable will hold the ordinal value.

Syntax:
```
@[<comma separated list>]<name>
```
Example:
```
macro set_color @[black,white,red,cyan,purple,green,blue,yellow]col
{
        lda #col
        sta $d021
}

        set_color green
```
### Variadic input
A variadic input must to be the last input of a macro declaration and it expects one or more comma separated expressions. The result is an array/string input.

Syntax:
```
@<name>...
```
Example:
```
macro store_data @address, @data...
{
        // Unrolled store
        for(size_t i=0; i<data.size(); i++)
        {
                lda #data[i]
                sta address+i
        }
}
        store_data $1000, 23, 24*2, -100, $bd
```
## yourproject.cpp
Your project comes with a .cpp-file. In most cases you can completely ignore this file as long as you keep it around and treat is as part of your project. To c2, this is your main source file as it itself includes your assembly file.
```
    void c2_pass() override
    {
        C2_SECTION_ASM
        {
            #include "yourasm.s"
        }
    }
```
You might realize now that all of your assembly is included inside of the C++ method c2_pass(). This method and hence your expanded assembly macros are called multiple times, once for each pass. Each pass helps resolve references and conditionally expand any macros until everything is resolved or an error occurred. For each pass, the binary assembly output is run through an 128 bit murmur3 hash. When 2 consecutive hashes match, assembly is considered complete. c2 will stop with an error of a hash repeats itself non consecutively. This can happen if resolving forward references gets stuck with paradoxes, at which point you should rethink your code. If c2 gets to pass 50, it will also stop with an error. This would likely be due to a bug in c2 or introduction of something random to the passes.

`C2_SECTION_ASM` and the following scope is a marker for c2 to know where to limit macro expansion to. `C2_SECTION_TOP` marks the spot where c2 will declare labels.

If you need to add additional C/C++ include files, this is the proper place to do it. By default c2 doesn't expose more of the C/C++ namespace than necessary. For advanced programmers, here you can also add your project specific extensions and even custom command line switches.

`c2_pre()` and `c2_post()` can be extended with pre and post assembly code. Post will only be executed if the assembly is successful.
## C pre-processor
There is not a lot to add here but you have the complete power of the C pre-processor. Some ideas and examples:
```
#include "mymacros.s"
#define SCREEN $0400
#define LIMIT8BIT(X) ((X)&$ff)

lda #LIMIT8BIT(258)
sta SCREEN
```
## Inline C++
All C/C++ loops, variables, if/else, case switches are available at your disposal. As your assembly source resides inside the C++ method `c2_pass()` there are some logical restrictions. If you want to declare your own functions you must normally do that as member methods in the .cpp-file. A way to get around this is to declare a struct:
```
        // Your assemblerfile.s
struct
{
        var mydata = loadvar("data.bin");

        size_t pos = 0;
        int get_next_byte()
        {
                if(pos == mydata.size())
                {
                        return -1;
                }

                int val = mydata[pos];
                pos++;
                return val;
        }
}mydata;

        lda #mydata.get_next_byte()
```
## Logging, warnings & errors
`c2_error(const char *format, ...)`, `c2_info(const char *format, ...)`, `c2_verbose(const char *format, ...)`
## c2 C++ interface
### Custom C++ extensions
## c2lib directory
Besides the executable, c2 is also dependent on its library to operate. The library contains necessary include files, source files and templates for project creation.

`include/c2` contains target platform and architecture specific includes sorted in sub folders. The `h` folder is reserved for C++ includes used by c2.

`source` contains target platform and architecture specific C++ files compiled alongside projects.

`template` contains templated base files referenced by `templates.c2.json`. These are copied and translated to your project folder when creating a new project.
### c2lib search order
* In the project path alongside `<project>.c2.json`
* Explicitly set with `--c2-library-dir`
* Nix home folder as `.c2lib` or `c2lib`. For windows `%LOCALAPPDATA%\c2lib`
* At location of environment variable `C2LIB_HOME`
* Nix global path `/usr/local/lib/c2lib`
* Alongside executable and two folders above the executable.

It's possible to copy, modify or extend parts of c2lib and place those modifications in your local directory to override. This is highly recommended if you want to add your own reusable templates or macro extensions.
## Include files & search order
Additional include search paths can be added with one or multiple `--include <path>` or `-i <path>`. This works for both pre-processor includes as well as incbin and c2 file system.

c2 searches the explicitly set paths first followed by the include folders in c2lib.
### c2config
# Defined targets / Templates
## 6502
A plain 6502 template with 64KB of RAM.
## c64
Commodore 64 with provided utilities.
### c64vice
Commodore 64 with provided utilities configured to auto-lauch in VICE (x64sc) with symbols and optional breakpoints.
### atari2600
Atari2600 with 4KB of ROM at $f000
## 68000
Highly experimental for c2 development, 68k CPU support is b0rken/buggy at best
## void
A plain template containing no included assembly pseudo opcodes. Useful for experimentation or rendering of binaries using macros and meta-programming. 10MB of RAM is allocated in the default project file, add more as needed.
