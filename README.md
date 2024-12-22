# c2 cross assembler
## Overview
The motivation behind c2 is to have an assembler framework capable of targeting a wide range of 8-32 bit CPU architectures while providing strong meta-programming capabilities.

Currently c2 supports 6502, 65c02, 65816, 4510/45gs02, 6809. Experimental support for z80 exist.

c2 is an assembler wrapper on top of a C++ compiler. It's highly configurable and architecture independent in the sense that all assembly pseudo opcodes are built with text macros. Macro files are included with the standard C pre-processor.

Much of the syntax should be familiar to anyone with Assembly, C/C++, Java, JS or C# experience.

Some of the highlights:
* Macro oriented
* C pre-processor
* Inline C++ for additional meta-programming
* Multiple pass assembly for conditional code generation with forward references
### License
Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

This file is part of c2.

c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
### Disclaimer
c2 is unstable and still under heavy development. Breaking changes can still happen.
### Main contributors
John Hammarberg, Jocelyn Houle, Johan Samuelsson, Monstersgoboom
# Build & Installation
c2 requires either clang++ or g++ for building c2 itself and for running c2. Clang is a bit faster on compile times.

At this point c2 has only been tested on 64 bit hosts with little endian (AMD64 and ARM64).
## Get the source
git clone https://github.com/Hammarberg/c2.git or download and extract the zip archive of the source.
## GNU/Linux/BSD/OSX
From the c2 root type `make` (or `make CXX=clang++ -j`) and a c2 executable will be created in the same folder.

Installation is optional as you can run c2 directly from the source root. If you want a system wide installation, `sudo make install` or if you prefer a user local installation `make install PREFIX=~/.local`.

To uninstall, `sudo make uninstall` or `make uninstall PREFIX=~/.local`.
### Suggested Debian packages
`build-essential` or `clang` and `make`.
## Windows
Pre-compiled packages can be found at [binarybone.com/c2](https://binarybone.com/c2/). Tagged versions includes [WinLibs MinGW64](https://www.winlibs.com/) and are a standalone without additional dependencies: Unzip to any location and then double click `c2_cmd` to start a pre-configured command prompt.
### Option 1: VS2022 and clang
You need [Visual Studio 2022 Community](https://visualstudio.microsoft.com/vs/community/) or better installed. You also need to select the optional clang tools during VS install. It's possible to modify an existing VS installation to include it.

If you already have VS without clang or if you just want a more up to date clang, you can install it separately from [clang/LLVM](https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/LLVM-17.0.6-win64.exe).

Run `WindowsVSBuild.bat` and a c2 executable will be created. You may of course also open the solution in VS2022 and build there.
### Option 2: Cygwin
Clang seems outdated in Cygwin. Install gcc/g++ and GNU make and then follow the GNU/Linux instructions and set up any path needed.
### Option 3: MinGW / GNU tools
The Makefile will detect MinGW and apply appropriate switches: `make CXX=x86_64-w64-mingw32-g++`
### Windows PATH
My Computer -> Properties -> Advanced System Settings -> Environment Variables -> Edit path for either User or System. Set the path to the directory where `c2.exe` was built to.
## Verify c2
There are test scripts to verify the functionality and integrity of c2. For bash, `utils/test.sh` and for Windows, `utils\test.bat`.
# Usage
## Command line
When executing c2 without any arguments in a project folder, it will build/assemble and depending on the settings in the project file (`.c2.json`), it can automatically launch custom scripts or a target emulator. To get an overview of command line options:

`c2 --help` or simply `c2 -h`.

The help listing will extend with project specific options when a project file is detected or loaded. For example, a Motorola 68000 project might have different switches listed compared to a MOS 6502 project.

c2 command line switches comes in two variants, the descriptive long version prefixed with two dashes (`--`) and the short variant prefixed with a single dash (`-`). Switches can take optional arguments. The description of each switch has `<mandatory>` and `[optional]` argument fields. Arguments are separated from the switch with a space like `--out file.bin`. Short switches with no or only optional arguments can be stacked and in that case only the last switch of the stack can have arguments: `-rvVo file.bin` where `-o` is the short version of `--out`.
## Templates overview
When assembling with c2, the template selected sets the target architecture, project configuration and may provides additional tools, definitions or macros for the target platform.

Many templates provides a "hello word" as a starting point for new projects.

A template is specified at either at project creation (`--create-project`) or during direct assembly (`--direct`).
## Projects
c2 comes with an easy to use build system.
## Creating a c2 project
Each project is based on a template. To list templates.

`c2 --list-templates`

To create a new c2 project in the current folder, use `--create-project <template> <name> [path]`.

`c2 --create-project vectrex myawesomeproject`

Optionally you can create the destination path with c2 directly. For Windows, use backslashes (`\`) for paths.

`c2 --create-project 6502 myawesomeproject sources/hack`

When executing `c2` without arguments in a project folder, it will build/assemble and depending on the template and can automatically external tools like an emulator or a deployment script.
### Direct assembly
To use c2 with an external build system like `make`, use `--direct <template> [other arguments] <source>`.

Example: `c2 -d c64 game.asm`
## Compile and assembly errors, tips and tricks
Internally c2 translates much of the assembly source file into intermediate C++ for the first steps. When this goes wrong, the error can look very cryptic. The C++ compiler might mention pieces of code that does not look familiar to the assembly source. The important part here is to look at the line number and source file mentioned rather than the error itself. If it's still not obvious what is wrong in the assembly source, try the `--verbose` (`-v`) switch to view more of the compiler output.
# Syntax
## Comments
Only C/C++ style comments are supported with either `// comment ` or `/* comment */`. This might hurt for some people used to `;` as comment prefix.
## Numbers
Decimal: `0, 1337`

Binary, prefixed with `0b` or `%` as in `0b10101010` or `%10100111001`.

Hexadecimal, prefixed with `0x` or `$` as in `0xfffd` or `$1B46B1`.

Octal numbers looks a lot like decimal number but are prefixed with a `0` as in `020, 02471`. Beware of this if you have a habit of prefixing decimal numbers with `0` for esthetics.
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
    moveq #data.end - data, d0 //size of data as immediate
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
This mode works automatically when a scope is repeated. The label `.small` is in this case duplicated 10 times and automatically indexed. For a more explicit control over the labels see see indexed labels.
### Anonymous labels
Anonymous labels are declared with a single colon at the beginning of a line and can only be referenced with relative addressing.

Example:
```
:   dex
    bpl -
```
### Relative label addressing
When referencing a label, it's normally done by name. Anonymous labels can only be referenced with a relative count from the current location. To reference the previous label, anonymous or not, use a single `-`, to reference two labels back use `--`. In the same way, use one or more`+` to reference forward labels.
### Indexed labels
Indexed labels are useful when addressing auto-generated code or expanded macros.

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
c2 provides a built-in variable type.

Syntax: `var <name> [= expression]`
```
    var x = 5
    // When declaring and assigning a variable, there is no need to add a ';'.
    // If you re-assign it, it will be needed
    x = 10;
```
Currently, variables doesn't support label namespaces (design decisions yet to be made) and works more like C++ variables. If you need to limit a scope of a variable you can use C scopes:
```
    {
        var x = 5
        //Other code here
    }
    // x is no more
```
Variables remembers explicit bit counts and this is supported by some target.
```
    var src = $0002
    lda src //16 bit absolute rather than zero page addressing mode on 6502
```
Variables declared inside macros are automatically scoped to the macro.
### Global variable
A global variable works much like a regular variable except it can be referenced from inside macros or before it is even declared in the source.
```
    global myvalue = 128
```
### Indexed, array & string variables
A variable can be used as an array or string.
```
    var x = {12,34,$56}
    var y = "hollow world"

    // Use of logging and member method .str()
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
#### cint type
Internally c2 uses `cint` as the default signed 64 bit integer type. Variables and most calls are based upon cint.
## Macros
In its simplest form, macros are pieces of declared information that can be recalled by a reference at any point. They are expanded inline at the point of reference. When c2 encounters an alphanumerical, declared macros are searched for a match.

Syntax:
```
    macro <name>[,alias] [arguments]
    {
        [contents]
    }
```
Example:
```
    macro nop
    {
        byte $ea
    }
```
Macros are case insensitive and are simply recalled by name.

Example:
```
    nop
```
This will be expanded back to:
```
    byte $ea
```
In this example, byte is also a macro that will be expanded.

Macros have to be declared before the point of it being referenced and expanded. However, macros can reference other macros not yet declared as long as all macros are known at the time of reference/expansion.
### Macro namespace
Macros contain its own label namespace. Local labels can therefore be used inside a macro without risk of conflict. Global labels inside a macro has some use cases but is generally a bad idea since the macro can only be referenced once. For referencing data inside an expanded macro, look at indexed labels.
### Macro alias
Aliases for macros can be declared with a comma separated list.
```
    macro nop,slack,nada,eom
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
#### Macro overriding
Macros can be overridden with an identical macro declaration to a previously declared macro.
```
    macro set_marker @dst
    {
        lda #$00
        sta dst
    }

    // override/replace macro
    macro set_marker @dst
    {
        lda #$ff
        sta dst
        set_marker dst+1   //expand the original macro as part of this macro
    }
```
### String input
As input is handled in c2 variables, strings are valid expressions.
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
It is also possible to combine enum with variadic input.
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
All of the assembly source is included inside of the C++ method c2_pass(). This method and hence the expanded assembly macros are called multiple times, once for each pass. Each pass helps resolve references and conditionally expand any macros until everything is resolved or an error occurred. For each pass, the binary assembly output is run through an 128 bit murmur3 hash. When 2 consecutive hashes match, assembly is considered complete. c2 will stop with an error if a hash repeats itself non consecutively. This can happen if resolving forward references gets stuck with paradoxes, at which point you should rethink your code. If c2 gets to pass 50, it will also stop with an error. This would likely be due to a bug in c2 or the introduction of something random to the passes.

`C2_SECTION_ASM` and the following scope is a marker for c2 to know where to limit macro expansion to. `C2_SECTION_TOP` marks the spot where c2 will declare labels.

If you need to add additional C/C++ include files, this is the proper place to do it. By default c2 doesn't expose more of the C/C++ namespace than necessary. For advanced programmers, here you can also add your project specific extensions and even custom command line switches.

`c2_pre()` and `c2_post()` can be extended with pre and post assembly code. Post will only be executed if the assembly is successful.
## C pre-processor
You have the complete power of the C pre-processor. Some ideas and examples:
```
#include "mymacros.s"
#define SCREEN $0400
#define LIMIT8BIT(X) ((X)&$ff)

    lda #LIMIT8BIT(258)
    sta SCREEN
```
## Inline C++
All C/C++ loops, variables, if/else, case switches are available. As the assembly source resides inside the C++ method `c2_pass()` there are some logical restrictions. If you want to declare your own function, that's normally done as a member method in the .cpp-file. A way to get around this is to declare a lambda:
```
    auto storestring = [&](var str)
    {
        byte str
        byte 0 //zero terminate
    };

text:  storestring("hello world from assembly");
```
## Logging, warnings & errors
The following fuctions works much like printf() from C and other languages.

`c2_error(const char *format, ...)`

Will print and abort assembly.

`c2_info(const char *format, ...)`

Always print information, unless silenced with `--silent-info`.

`c2_verbose(const char *format, ...)`

Verbosely print where no-one printed before. Only visible with `-v`.

Example:
```
    if(x != 10)
    {
        c2_error("Expected x to be 10 but it was %d", int(x));
    }
```
## c2 C++ interface
### Custom C++ extensions
## c2lib directory
Besides the executable, c2 is also dependent on its library to operate. The library contains necessary include files, source files and templates for project creation.

`include/c2` contains target platform and architecture specific includes sorted in sub folders. The `h` folder is reserved for C++ includes used by c2.

`source` contains target platform and architecture specific C++ files compiled alongside projects.

`template` contains templated base files referenced by `templates.c2.json`. These are copied and translated to your project or intermediate folder when creating a new project or during direct assembly.
### c2lib search order
* In the project path alongside `<project>.c2.json`.
* Explicitly set with `--c2-library-dir` or `-D`.
* Home folder as `.c2lib` or `c2lib`. For windows `%LOCALAPPDATA%\c2lib`.
* At location of environment variable `C2LIB_HOME`.
* Alongside executable or`../lib/c2lib`. For Windows also two folders above the executable.

It's possible to copy, modify or extend parts of c2lib and place those modifications in your local directory to override. This is highly recommended if you want to add your own reusable templates or macro extensions.
## Include files & search order
Additional include search paths can be added with one or multiple `--include <path>` or `-i <path>`. This works for both pre-processor includes as well as incbin and c2 file system.

c2 searches the explicitly set paths first followed by the include folders in c2lib.
### c2config
# Defined targets / Templates
## 6502
A plain 6502 template with 64KB of RAM.
### c64
Commodore 64 with provided utilities.
### c64vice
Commodore 64 with provided utilities configured to auto lauch in VICE (x64sc) with symbols and optional breakpoints.
### atari2600
Atari2600 with 4KB of ROM at $f000
### NESnrom
NES NROM 256
## 65c02
A plain 65c02 template with 64KB of RAM.
### TG16
Turbo Grafx 16 HuC6280.
### mega65
MEGA65 (C65/DX64) 4510 & 45gs02.
## 6809
A plain 6809 template with 64KB of RAM.
### vectrex
GCE Vectrex with 32KB of ROM between $0000-$8000.
### dragon
Dragon 32/64, also highly compatible with Tandy Color Computer (CoCo). Configured with 64KB of RAM.
## 65816
Plain 65816.
### c64scpu
Commodore 64 Super CPU
## void
A plain template containing no included assembly pseudo opcodes. Useful for experimentation or rendering of binaries using macros and meta-programming. 10MB of RAM is allocated in the default project file, add more as needed.
# Targets
## Pre-defined macros
`c2lib/include/c2.s` is included in every c2 project and contains the following:

`incbin "<filename>" [, offset [, length] ]`
Includes a binary from the file system at current org. Optionally, byte offset and byte length can be given.

`incstream "<command>" [, offset [, length] ]`
Includes the stdout of the command at the current org. Optionally, byte offset and byte length can be given.

`postarg "<switch>"`
Adds c2 command line switches for the post assembly pass from the convenience of your source.

`repeat(X)` and `rrepeat(X)`
Repeats the following line or C code block X times. The variable `c2repn` can be read. `rrepeat` counts in reverse from X-1 to and including 0.

Example:
```
    repeat(10)
    {
        byte offset + c2repn*7
    }
```
`assemble "<source>"`
Externally assemble the source and include the results at the current ORG. Unlike the C pre-processor `#include` statement that merge at the source level, `assemble` will assemble the source separately and then merge at the binary level. This creates isolation between the including and included source and can improve build times on large projects.

Sharing of labels between the two source files must be set explicitly with `import`.

`import <label>`
Import a global label from an externally assembled source.

Example:
```
    // Import labels before use
    import data
    import routine

    move data, d0
    jmp routine

    assemble "dataset.asm"
```
## c64, c64vice and mega65
Commodore 8 bit platforms includes the following macros:

`basic_startup`
Set ORG and inserts a basic startup line. The machine code start address is the address immediately following the expanded macro.

`screencode "<string>"`
String as VIC screencode.

Example:
```
    screencode "hello world",0
```
`petscii "<string">`
String as PETSCII.

Example:
```
    petscii "data.seq"
```
`incprg "<filename>" [, offset [, length] ]`
Includes a Commodore PRG file from the file system at current org. Optionally, byte offset and byte length can be given. This is equivalent to `incbin` with 2 added to the offset effectively discarding the PRG header.

`vice "<cmd string>"`
Add a VICE emulator command. Use in conjunction with `--vice-cmd`. See the `c64vice` template and the VICE emulator documentation. `@` can be used to substitute the current ORG.

To set a break point at the current ORG from source:
```
    vice "break @"
```
## Dragon/CoCo
`dosheader <start>`
Set ORG to the given start address and insert a DOS binary header. This should be first in your source. When using this macro with switch `--out - +` the output is a Dragon/CoCo DOS compatible binary.

Example:
```
    dosheader $4000"
start:
    lda #$00
```
