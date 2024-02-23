@echo off
cd "%~dp0..\"
set "c2dir=%cd%"

for /r examples %%i in ("*.hash") do (
	pushd %%~pi
	
	echo %%~pi
	
	"%c2dir%\c2.exe" --clean
	
	for /f "tokens=*" %%a in ('"%c2dir%\c2.exe" --hash -rX') do (
		for /f "tokens=* delims=" %%b in (.hash) do (
			echo a: %%a
			echo b: %%b
			
			if not "%%a" == "%%b" (
				echo hash failure
				exit /b 1
			)
		)
		if %ERRORLEVEL% neq 0 ( exit /b 1 )
	)
	
	if %ERRORLEVEL% neq 0 (	exit /b 1 )
	
	popd
)

if %ERRORLEVEL% neq 0 ( exit /b 1 )

echo Success
