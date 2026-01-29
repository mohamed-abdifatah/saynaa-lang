:: Copyright (c) 2022-2023 Mohamed Abdifatah. All rights reserved.
:: Distributed Under The MIT License

@echo off
setlocal enabledelayedexpansion
pushd %~dp0

:: Root directory of the project
set "project_root=%~dp0"

:: ----------------------------------------------------------------------------
:: DEPENDENCIES
:: ----------------------------------------------------------------------------
set "pcre2_path=%project_root%deps\pcre2"
set "pcre2_inc=/I"%pcre2_path%\include""
set "pcre2_lib="%pcre2_path%\lib\pcre2-8-static.lib""

:: ----------------------------------------------------------------------------
:: PARSE COMMAND LINE ARGUMENTS
:: ----------------------------------------------------------------------------
set "enable_debug=true"
set "use_shared_lib=false"

:PARSE_ARGS
if "%~1"=="" goto :CHECK_MSVC
if "%~1"=="-h" goto :PRINT_USAGE
if "%~1"=="-c" goto :CLEAN
if "%~1"=="-r" (set "enable_debug=false" & shift & goto :PARSE_ARGS)
if "%~1"=="-s" (set "use_shared_lib=true" & shift & goto :PARSE_ARGS)

echo Invalid argument "%~1"

:PRINT_USAGE
echo Usage: call build.bat [options ...]
echo options:
echo   -h  display this message
echo   -r  Compile the release version of saynaa (default = debug)
echo   -s  Link saynaa as a shared library (default = static link).
echo   -c  Clean all compiled/generated intermediate binaries.
goto :END

:: ----------------------------------------------------------------------------
:: INITIALIZE MSVC ENVIRONMENT
:: ----------------------------------------------------------------------------
:CHECK_MSVC
if defined INCLUDE goto :START

echo Not running on an MSVC prompt, searching for one...

:: Find vswhere.exe safely
set "vswhere=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "!vswhere!" set "vswhere=%ProgramFiles%\Microsoft Visual Studio\Installer\vswhere.exe"

if not exist "!vswhere!" (
    echo Error: can't find vswhere.exe
    goto :NO_VS_PROMPT
)

:: Get the installation path using vswhere
for /f "usebackq tokens=*" %%i in (`"!vswhere!" -latest -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
    set "install_path=%%i"
)

if not exist "!install_path!" (
    echo Error: can't find Visual Studio installation directory
    goto :NO_VS_PROMPT
)

echo Found at - "!install_path!"

:: Call vcvars64.bat to set up the environment
set "vcvars=!install_path!\VC\Auxiliary\Build\vcvars64.bat"
if not exist "!vcvars!" (
    echo Error: can't find vcvars64.bat
    goto :NO_VS_PROMPT
)

call "!vcvars!"
if errorlevel 1 goto :NO_VS_PROMPT
echo Initialized MSVC x86_64
goto :START

:NO_VS_PROMPT
echo You must open a "Visual Studio .NET Command Prompt" to run this script or ensure VS is installed.
exit /b 1

:: ----------------------------------------------------------------------------
:: START BUILD
:: ----------------------------------------------------------------------------
:START
set "target_dir=%project_root%obj\"
set "add_cflags=-W3 -GR /FS -EHsc"
set "add_linkflags=/SUBSYSTEM:CONSOLE"
set "add_defines=/D_CRT_SECURE_NO_WARNINGS /DPCRE2_STATIC"

if "!enable_debug!"=="false" (
    set "cflags=-O2 -MD /DNDEBUG"
) else (
    set "cflags=-MDd -ZI"
    set "add_defines=!add_defines! /DDEBUG"
)

if "!use_shared_lib!"=="true" (
    set "add_defines=!add_defines! /D_DLL_ /D_COMPILE_"
)

:: Create directories
if not exist "!target_dir!" mkdir "!target_dir!"
if not exist "!target_dir!lib\" mkdir "!target_dir!lib\"
if not exist "!target_dir!saynaa\" mkdir "!target_dir!saynaa\"
if not exist "!target_dir!cli\" mkdir "!target_dir!cli\"

:: ----------------------------------------------------------------------------
:: COMPILE CORE
:: ----------------------------------------------------------------------------
cd /d "!target_dir!saynaa"
cl /nologo /c !add_defines! !pcre2_inc! !add_cflags! !cflags! ^
    "!project_root!src\compiler\*.c" ^
    "!project_root!src\optionals\*.c" ^
    "!project_root!src\runtime\*.c" ^
    "!project_root!src\shared\*.c" ^
    "!project_root!src\utils\*.c"
if errorlevel 1 goto :FAIL

set "mylib=!target_dir!lib\saynaa.lib"
if "!use_shared_lib!"=="true" (
    set "mylib=!target_dir!bin\saynaa.lib"
    if not exist "!target_dir!bin\" mkdir "!target_dir!bin\"
    link /nologo /dll /out:"!target_dir!bin\saynaa.dll" /implib:"!mylib!" *.obj !pcre2_lib!
) else (
    lib /nologo !add_linkflags! /OUT:"!mylib!" *.obj
)
if errorlevel 1 goto :FAIL

:: ----------------------------------------------------------------------------
:: COMPILE CLI
:: ----------------------------------------------------------------------------
cd /d "!target_dir!cli"
cl /nologo /c !add_defines! !pcre2_inc! !add_cflags! !cflags! "!project_root!src\cli\*.c"
if errorlevel 1 goto :FAIL

:: Final Link
cd /d "!project_root!"
cl /nologo !add_defines! "!target_dir!cli\*.obj" "!mylib!" !pcre2_lib! /Fe"saynaa.exe"
if errorlevel 1 goto :FAIL

echo.
echo Compilation Success: saynaa.exe is ready.
goto :END

:CLEAN
if exist "obj" rmdir /S /Q "obj"
if exist "saynaa.exe" del "saynaa.exe"
echo Files were cleaned.
goto :END

:FAIL
echo Build failed.
exit /b 1

:END
popd
endlocal
