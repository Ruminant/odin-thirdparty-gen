@echo off
setlocal

set "CONFIG=Release"
if not "%~1"=="" set "CONFIG=%~1"

for %%I in ("%~dp0..") do set "CAPSTONE_DIR=%%~fI"
for %%I in ("%CAPSTONE_DIR%\..") do set "ROOT_DIR=%%~fI"

set "SRC_DIR=%CAPSTONE_DIR%\src"
set "BUILD_DIR=%CAPSTONE_DIR%\build"
set "BINDGEN_DIR=%CAPSTONE_DIR%\bindgen"
set "BINDGEN_INPUT_DIR=%BINDGEN_DIR%\input"
set "ODIN_LIB_DIR=%CAPSTONE_DIR%\odin\lib\windows"
set "BINDGEN_EXE=%ROOT_DIR%\bindgen\bindgen.exe"

echo [capstone] Configuring CMake...
cmake -S "%SRC_DIR%" -B "%BUILD_DIR%"
if errorlevel 1 goto :error

echo [capstone] Building %CONFIG% artifacts...
cmake --build "%BUILD_DIR%" --config "%CONFIG%"
if errorlevel 1 goto :error

set "CAPSTONE_SOURCE_INCLUDE=%BUILD_DIR%\_deps\capstone-src\include"
set "CAPSTONE_BUILD_OUTPUT=%BUILD_DIR%\_deps\capstone-build\%CONFIG%"

if not exist "%CAPSTONE_SOURCE_INCLUDE%\capstone\capstone.h" (
    echo [capstone] Missing fetched Capstone headers: "%CAPSTONE_SOURCE_INCLUDE%"
    goto :error
)

if not exist "%CAPSTONE_BUILD_OUTPUT%\capstone_static.lib" (
    echo [capstone] Missing built Capstone artifacts: "%CAPSTONE_BUILD_OUTPUT%"
    goto :error
)

echo [capstone] Staging public headers for bindgen...
if not exist "%BINDGEN_INPUT_DIR%" mkdir "%BINDGEN_INPUT_DIR%"
copy /Y "%CAPSTONE_SOURCE_INCLUDE%\capstone\*.h" "%BINDGEN_INPUT_DIR%\" >nul
if errorlevel 1 goto :error

if exist "%CAPSTONE_SOURCE_INCLUDE%\windowsce" (
    if not exist "%BINDGEN_INPUT_DIR%\windowsce" mkdir "%BINDGEN_INPUT_DIR%\windowsce"
    copy /Y "%CAPSTONE_SOURCE_INCLUDE%\windowsce\*.h" "%BINDGEN_INPUT_DIR%\windowsce\" >nul
    if errorlevel 1 goto :error
)

echo [capstone] Copying Windows libraries into odin\lib\windows...
if not exist "%ODIN_LIB_DIR%" mkdir "%ODIN_LIB_DIR%"
copy /Y "%CAPSTONE_BUILD_OUTPUT%\capstone.lib" "%ODIN_LIB_DIR%\capstone.lib" >nul
if errorlevel 1 goto :error
copy /Y "%CAPSTONE_BUILD_OUTPUT%\capstone.dll" "%ODIN_LIB_DIR%\capstone.dll" >nul
if errorlevel 1 goto :error
copy /Y "%CAPSTONE_BUILD_OUTPUT%\capstone_static.lib" "%ODIN_LIB_DIR%\capstone_static.lib" >nul
if errorlevel 1 goto :error

if not exist "%BINDGEN_EXE%" (
    echo [capstone] Missing bindgen executable: "%BINDGEN_EXE%"
    goto :error
)

echo [capstone] Regenerating Odin bindings...
pushd "%BINDGEN_DIR%" >nul
"%BINDGEN_EXE%" . 2>&1
set "BINDGEN_RESULT=%ERRORLEVEL%"
popd >nul
if not "%BINDGEN_RESULT%"=="0" goto :error

where odin >nul 2>nul
if not errorlevel 1 (
    echo [capstone] Checking generated Odin package...
    odin check "%CAPSTONE_DIR%\odin" -no-entry-point
    if errorlevel 1 goto :error

    echo [capstone] Checking example...
    odin check "%CAPSTONE_DIR%\example"
    if errorlevel 1 goto :error
) else (
    echo [capstone] Skipping Odin checks because odin.exe was not found on PATH.
)

echo [capstone] Done.
exit /b 0

:error
echo [capstone] Failed.
exit /b 1
