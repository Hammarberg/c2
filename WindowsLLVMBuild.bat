@echo off

set CXX=clang++ --version
call %CXX%
if %ERRORLEVEL% == 0 goto :found

set CXX=clang --version
call %CXX%
if %ERRORLEVEL% == 0 goto :found

set CXX="C:\Program Files\LLVM\bin\clang++" --version
call %CXX%
if %ERRORLEVEL% == 0 goto :found

set CXX="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\Llvm\x64\bin\clang++" --version
call %CXX%
if %ERRORLEVEL% == 0 goto :found

set CXX=g++ --version
call %CXX%
if %ERRORLEVEL% == 0 goto :found

echo "No compiler found"
goto :end

:found
SET CXX=%CXX:~0,-10%

%CXX% -Wall -O2 -std=c++17 -march=native -g -o c2.exe c2.cpp c2a.cpp json.cpp macro.cpp token.cpp tokfeed.cpp cmda.cpp template.cpp library.cpp

:end