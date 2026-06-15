@echo off
setlocal

set "CONFIG=Release"
if not "%~1"=="" set "CONFIG=%~1"

for %%I in ("%~dp0.") do set "RECIPE_DIR=%%~fI"
for %%I in ("%RECIPE_DIR%\..\..") do set "ROOT_DIR=%%~fI"

set "SRC_DIR=%RECIPE_DIR%"
set "BUILD_DIR=%RECIPE_DIR%\build"
set "BINDGEN_DIR=%RECIPE_DIR%\bindgen"
set "BINDGEN_INPUT_DIR=%BINDGEN_DIR%\input"
set "GENERATED_DIR=%RECIPE_DIR%\generated"
set "ODIN_DIR=%ROOT_DIR%\odin\capstone"
set "ODIN_LIB_DIR=%ODIN_DIR%\libs\windows\amd64"
set "BINDGEN_EXE=%ROOT_DIR%\bindgen\bindgen.exe"
set "MANIFEST=%RECIPE_DIR%\package.sjson"
set "COLLECTION_ARG=-collection:thirdparty=%ROOT_DIR%\odin"

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

echo [capstone] Copying Windows libraries into odin\capstone\libs\windows\amd64...
if not exist "%ODIN_LIB_DIR%" mkdir "%ODIN_LIB_DIR%"
robocopy "%CAPSTONE_BUILD_OUTPUT%" "%ODIN_LIB_DIR%" capstone.lib capstone.dll capstone_static.lib /XO >nul
if errorlevel 8 goto :error

if not exist "%BINDGEN_EXE%" (
    echo [capstone] Missing bindgen executable: "%BINDGEN_EXE%"
    goto :error
)

echo [capstone] Regenerating Odin bindings...
if not exist "%GENERATED_DIR%" mkdir "%GENERATED_DIR%"
if errorlevel 1 goto :error

pushd "%BINDGEN_DIR%" >nul
"%BINDGEN_EXE%" . 2>&1
set "BINDGEN_RESULT=%ERRORLEVEL%"
popd >nul
if not "%BINDGEN_RESULT%"=="0" goto :error

call :sync_generated_bindings
if errorlevel 1 goto :error

where odin >nul 2>nul
if not errorlevel 1 (
    echo [capstone] Checking generated Odin package...
    odin check "%ODIN_DIR%" -no-entry-point
    if errorlevel 1 goto :error

    echo [capstone] Checking example...
    odin check "%ROOT_DIR%\examples\capstone\disasm_basic" "%COLLECTION_ARG%"
    if errorlevel 1 goto :error
) else (
    echo [capstone] Skipping Odin checks because odin.exe was not found on PATH.
)

echo [capstone] Done.
exit /b 0

:sync_generated_bindings
where python.exe >nul 2>nul
if not errorlevel 1 (
    python.exe "%ROOT_DIR%\recipes\sync_generated.py" "%MANIFEST%"
    exit /b %ERRORLEVEL%
)

where py.exe >nul 2>nul
if not errorlevel 1 (
    py.exe -3 "%ROOT_DIR%\recipes\sync_generated.py" "%MANIFEST%"
    exit /b %ERRORLEVEL%
)

echo [capstone] Missing Python. Install Python or place python.exe/py.exe on PATH to sync generated bindings.
exit /b 1

:error
echo [capstone] Failed.
exit /b 1
