@echo off
setlocal

set "SOKOL_URL=https://github.com/Ruminant/sokol-odin-imgui/archive/refs/heads/main.tar.gz"
set "SOKOL_ARCHIVE=sokol-odin-imgui-main.tar.gz"

for %%I in ("%~dp0.") do set "RECIPE_DIR=%%~fI"
for %%I in ("%RECIPE_DIR%\..\..") do set "ROOT_DIR=%%~fI"

set "BUILD_DIR=%RECIPE_DIR%\build"
set "DOWNLOAD_DIR=%BUILD_DIR%\download"
set "EXTRACT_DIR=%BUILD_DIR%\extract"
set "ARCHIVE_PATH=%DOWNLOAD_DIR%\%SOKOL_ARCHIVE%"
set "MANIFEST=%RECIPE_DIR%\package.sjson"
set "ODIN_DIR=%ROOT_DIR%\odin\sokol"
set "ODIN_LIB_DIR=%ODIN_DIR%\libs\windows\amd64"
set "COLLECTION_ARG=-collection:thirdparty=%ROOT_DIR%\odin"

echo [sokol] Preparing directories...
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"
if errorlevel 1 goto :error
if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"
if errorlevel 1 goto :error

if not exist "%ARCHIVE_PATH%" (
    echo [sokol] Downloading upstream archive...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri '%SOKOL_URL%' -OutFile '%ARCHIVE_PATH%'"
    if errorlevel 1 goto :error
) else (
    echo [sokol] Reusing downloaded archive: "%ARCHIVE_PATH%"
)

call :find_package_dir
if not defined PACKAGE_DIR (
    echo [sokol] Extracting archive...
    tar -xzf "%ARCHIVE_PATH%" -C "%EXTRACT_DIR%"
    if errorlevel 1 goto :error
    call :find_package_dir
)

if not defined PACKAGE_DIR (
    echo [sokol] Could not find extracted sokol-odin-imgui package under "%EXTRACT_DIR%".
    goto :error
)
echo [sokol] Using package: "%PACKAGE_DIR%"

if not exist "%PACKAGE_DIR%\sokol\build_clibs_windows.cmd" (
    echo [sokol] Missing upstream Windows build script.
    goto :error
)

call :ensure_msvc
if errorlevel 1 goto :error

echo [sokol] Building Windows C libraries...
pushd "%PACKAGE_DIR%\sokol" >nul
call build_clibs_windows.cmd
set "BUILD_RESULT=%ERRORLEVEL%"
popd >nul
if not "%BUILD_RESULT%"=="0" goto :error

echo [sokol] Syncing Odin package and examples...
call :sync_sokol
if errorlevel 1 goto :error

echo [sokol] Copying Windows libraries into odin\sokol\libs\windows\amd64...
if not exist "%ODIN_LIB_DIR%" mkdir "%ODIN_LIB_DIR%"
if errorlevel 1 goto :error
for /R "%PACKAGE_DIR%\sokol" %%F in (*.lib *.dll) do (
    copy /Y "%%~fF" "%ODIN_LIB_DIR%\" >nul
    if errorlevel 1 goto :error
)

where odin >nul 2>nul
if not errorlevel 1 (
    echo [sokol] Checking core packages...
    odin check "%ODIN_DIR%\log" -no-entry-point
    if errorlevel 1 goto :error
    odin check "%ODIN_DIR%\app" -no-entry-point
    if errorlevel 1 goto :error
    odin check "%ODIN_DIR%\gfx" -no-entry-point
    if errorlevel 1 goto :error
    odin check "%ODIN_DIR%\glue" -no-entry-point
    if errorlevel 1 goto :error
    odin check "%ODIN_DIR%\time" -no-entry-point
    if errorlevel 1 goto :error

    echo [sokol] Checking clear example...
    odin check "%ROOT_DIR%\examples\sokol\clear" "%COLLECTION_ARG%"
    if errorlevel 1 goto :error
) else (
    echo [sokol] Skipping Odin checks because odin.exe was not found on PATH.
)

echo [sokol] Done.
exit /b 0

:find_package_dir
set "PACKAGE_DIR="
for /D %%I in ("%EXTRACT_DIR%\sokol-odin-imgui-*") do (
    if exist "%%~fI\sokol\build_clibs_windows.cmd" if not defined PACKAGE_DIR set "PACKAGE_DIR=%%~fI"
)
exit /b 0

:ensure_msvc
where cl.exe >nul 2>nul
if not errorlevel 1 exit /b 0

set "VSDEVCMD="
if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat" set "VSDEVCMD=%ProgramFiles%\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat"
if not defined VSDEVCMD if exist "%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" set "VSDEVCMD=%ProgramFiles%\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
if not defined VSDEVCMD if exist "%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\VsDevCmd.bat" set "VSDEVCMD=%ProgramFiles%\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\VsDevCmd.bat"

if not defined VSDEVCMD (
    echo [sokol] cl.exe was not found. Run from a Visual Studio Developer Command Prompt or install VS Build Tools.
    exit /b 1
)

echo [sokol] Initializing MSVC environment: "%VSDEVCMD%"
call "%VSDEVCMD%" -arch=x64 -host_arch=x64
if errorlevel 1 exit /b 1
where cl.exe >nul 2>nul
if errorlevel 1 (
    echo [sokol] cl.exe was still not found after VsDevCmd.
    exit /b 1
)
exit /b 0

:sync_sokol
where python.exe >nul 2>nul
if not errorlevel 1 (
    python.exe "%RECIPE_DIR%\sync_sokol.py" "%MANIFEST%" "%PACKAGE_DIR%"
    exit /b %ERRORLEVEL%
)

where py.exe >nul 2>nul
if not errorlevel 1 (
    py.exe -3 "%RECIPE_DIR%\sync_sokol.py" "%MANIFEST%" "%PACKAGE_DIR%"
    exit /b %ERRORLEVEL%
)

echo [sokol] Missing Python. Install Python or place python.exe/py.exe on PATH to sync files.
exit /b 1

:error
echo [sokol] Failed.
exit /b 1
