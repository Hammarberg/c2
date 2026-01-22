@echo off
cd "%~dp0"
setlocal

where git
if "%ERRORLEVEL%"=="0" (
	for /f "delims=" %%a in ('git describe --always') do set C2_GITVERSION=%%a
)

if "%C2_GITVERSION%"=="" (
	set C2_GITVERSION=not set
)

echo #define C2_VERSION ^"%C2_GITVERSION%^" > ..\c2gitversion.h

endlocal
