@echo off
setlocal

set "FFMPEG_URL=https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-full-shared.7z"
set "FFMPEG_ARCHIVE=ffmpeg-release-full-shared.7z"

for %%I in ("%~dp0.") do set "RECIPE_DIR=%%~fI"
for %%I in ("%RECIPE_DIR%\..\..") do set "ROOT_DIR=%%~fI"

set "BUILD_DIR=%RECIPE_DIR%\build"
set "DOWNLOAD_DIR=%BUILD_DIR%\download"
set "EXTRACT_DIR=%BUILD_DIR%\extract"
set "ARCHIVE_PATH=%DOWNLOAD_DIR%\%FFMPEG_ARCHIVE%"
set "BINDGEN_DIR=%RECIPE_DIR%\bindgen"
set "BINDGEN_INPUT_DIR=%BINDGEN_DIR%\input"
set "GENERATED_DIR=%RECIPE_DIR%\generated"
set "BINDGEN_EXE=%ROOT_DIR%\bindgen\bindgen.exe"
set "ODIN_DIR=%ROOT_DIR%\odin\ffmpeg"
set "ODIN_LIB_DIR=%ODIN_DIR%\libs\windows\amd64"
set "MANIFEST=%RECIPE_DIR%\package.sjson"
set "COLLECTION_ARG=-collection:thirdparty=%ROOT_DIR%\odin"

echo [ffmpeg] Preparing directories...
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"
if errorlevel 1 goto :error
if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"
if errorlevel 1 goto :error

if not exist "%ARCHIVE_PATH%" (
    echo [ffmpeg] Downloading shared release archive...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri '%FFMPEG_URL%' -OutFile '%ARCHIVE_PATH%'"
    if errorlevel 1 goto :error
) else (
    echo [ffmpeg] Reusing downloaded archive: "%ARCHIVE_PATH%"
)

set "PACKAGE_DIR="
for /D %%I in ("%EXTRACT_DIR%\ffmpeg-*-full_build-shared") do (
    if exist "%%~fI\include\libavcodec\avcodec.h" if not defined PACKAGE_DIR set "PACKAGE_DIR=%%~fI"
)
if not defined PACKAGE_DIR for /D %%I in ("%EXTRACT_DIR%\*") do (
    if exist "%%~fI\include\libavcodec\avcodec.h" if not defined PACKAGE_DIR set "PACKAGE_DIR=%%~fI"
)

if not defined PACKAGE_DIR (
    call :find_7zip
    if errorlevel 1 goto :error

    echo [ffmpeg] Extracting archive...
    if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"
    if errorlevel 1 goto :error
    "%SEVEN_ZIP%" x -y "-o%EXTRACT_DIR%" "%ARCHIVE_PATH%" >nul
    if errorlevel 1 goto :error

    set "PACKAGE_DIR="
    for /D %%I in ("%EXTRACT_DIR%\ffmpeg-*-full_build-shared") do (
        if exist "%%~fI\include\libavcodec\avcodec.h" if not defined PACKAGE_DIR set "PACKAGE_DIR=%%~fI"
    )
    if not defined PACKAGE_DIR for /D %%I in ("%EXTRACT_DIR%\*") do (
        if exist "%%~fI\include\libavcodec\avcodec.h" if not defined PACKAGE_DIR set "PACKAGE_DIR=%%~fI"
    )
    if not defined PACKAGE_DIR (
        echo [ffmpeg] Could not find extracted FFmpeg package directory under "%EXTRACT_DIR%".
        goto :error
    )
    echo [ffmpeg] Found package: "%PACKAGE_DIR%"
) else (
    echo [ffmpeg] Reusing extracted package: "%PACKAGE_DIR%"
)

if not exist "%PACKAGE_DIR%\include\libavcodec\avcodec.h" (
    echo [ffmpeg] Missing FFmpeg headers in extracted package: "%PACKAGE_DIR%\include"
    goto :error
)

if not exist "%PACKAGE_DIR%\lib\avcodec.lib" (
    echo [ffmpeg] Missing FFmpeg import libraries in extracted package: "%PACKAGE_DIR%\lib"
    goto :error
)

if not exist "%PACKAGE_DIR%\bin\avcodec-*.dll" (
    echo [ffmpeg] Missing FFmpeg runtime DLLs in extracted package: "%PACKAGE_DIR%\bin"
    goto :error
)

echo [ffmpeg] Staging public headers for bindgen...
if not exist "%BINDGEN_INPUT_DIR%" mkdir "%BINDGEN_INPUT_DIR%"
if errorlevel 1 goto :error
robocopy "%PACKAGE_DIR%\include" "%BINDGEN_INPUT_DIR%" /E >nul
if errorlevel 8 goto :error

echo [ffmpeg] Copying Windows import libraries and runtime DLLs into odin\ffmpeg\libs\windows\amd64...
if not exist "%ODIN_LIB_DIR%" mkdir "%ODIN_LIB_DIR%"
if errorlevel 1 goto :error
robocopy "%PACKAGE_DIR%\lib" "%ODIN_LIB_DIR%" *.lib /XO >nul
if errorlevel 8 goto :error
robocopy "%PACKAGE_DIR%\bin" "%ODIN_LIB_DIR%" *.dll /XO /XC >nul
if errorlevel 8 goto :error

call :compress_dlls
if errorlevel 1 goto :error

echo [ffmpeg] Copying FFmpeg license and readme files into odin\ffmpeg...
for %%F in (LICENSE README.txt) do (
    if exist "%PACKAGE_DIR%\%%F" copy /Y "%PACKAGE_DIR%\%%F" "%ODIN_DIR%\%%F" >nul
)

if not exist "%BINDGEN_EXE%" (
    echo [ffmpeg] Missing bindgen executable: "%BINDGEN_EXE%"
    goto :error
)

echo [ffmpeg] Regenerating Odin bindings...
if not exist "%GENERATED_DIR%" mkdir "%GENERATED_DIR%"
if errorlevel 1 goto :error

pushd "%BINDGEN_DIR%" >nul
"%BINDGEN_EXE%" . 2>&1
set "BINDGEN_RESULT=%ERRORLEVEL%"
if "%BINDGEN_RESULT%"=="0" (
    call :fix_generated_bindings
    set "BINDGEN_RESULT=%ERRORLEVEL%"
)
popd >nul
if not "%BINDGEN_RESULT%"=="0" goto :error

call :sync_generated_bindings
if errorlevel 1 goto :error

where odin >nul 2>nul
if not errorlevel 1 (
    echo [ffmpeg] Checking generated Odin package...
    odin check "%ODIN_DIR%" -no-entry-point
    if errorlevel 1 goto :error

    echo [ffmpeg] Checking examples...
    odin check "%ROOT_DIR%\examples\ffmpeg\create_empty_output" "%COLLECTION_ARG%"
    if errorlevel 1 goto :error
    odin check "%ROOT_DIR%\examples\ffmpeg\grab_png_at_time" "%COLLECTION_ARG%"
    if errorlevel 1 goto :error
    odin check "%ROOT_DIR%\examples\ffmpeg\raylib_video" "%COLLECTION_ARG%"
    if errorlevel 1 goto :error
) else (
    echo [ffmpeg] Skipping Odin checks because odin.exe was not found on PATH.
)

echo [ffmpeg] Done.
echo [ffmpeg] Headers are staged in "%BINDGEN_INPUT_DIR%".
echo [ffmpeg] Libraries are staged in "%ODIN_LIB_DIR%".
exit /b 0

:fix_generated_bindings
where python.exe >nul 2>nul
if not errorlevel 1 (
    python.exe ".\fix_generated.py" "%GENERATED_DIR%"
    exit /b %ERRORLEVEL%
)

where py.exe >nul 2>nul
if not errorlevel 1 (
    py.exe -3 ".\fix_generated.py" "%GENERATED_DIR%"
    exit /b %ERRORLEVEL%
)

echo [ffmpeg] Missing Python. Install Python or place python.exe/py.exe on PATH to run bindgen cleanup.
exit /b 1

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

echo [ffmpeg] Missing Python. Install Python or place python.exe/py.exe on PATH to sync generated bindings.
exit /b 1

:find_7zip
set "SEVEN_ZIP="
for %%P in (7z.exe 7za.exe 7zr.exe) do (
    for /F "delims=" %%I in ('where %%P 2^>nul') do (
        if not defined SEVEN_ZIP set "SEVEN_ZIP=%%I"
    )
)
if not defined SEVEN_ZIP if exist "%ProgramFiles%\7-Zip\7z.exe" set "SEVEN_ZIP=%ProgramFiles%\7-Zip\7z.exe"
if not defined SEVEN_ZIP if exist "%ProgramFiles(x86)%\7-Zip\7z.exe" set "SEVEN_ZIP=%ProgramFiles(x86)%\7-Zip\7z.exe"
if not defined SEVEN_ZIP (
    echo [ffmpeg] Could not find 7-Zip. Install 7-Zip or place 7z.exe, 7za.exe, or 7zr.exe on PATH.
    exit /b 1
)
echo [ffmpeg] Using 7-Zip: "%SEVEN_ZIP%"
exit /b 0

:compress_dlls
set "UPX_EXE="
for /F "delims=" %%I in ('where upx.exe 2^>nul') do (
    if not defined UPX_EXE set "UPX_EXE=%%I"
)
if not defined UPX_EXE (
    echo [ffmpeg] Skipping DLL compression because upx.exe was not found on PATH.
    exit /b 0
)

echo [ffmpeg] Compressing Windows DLLs with UPX: "%UPX_EXE%"
for %%F in ("%ODIN_LIB_DIR%\*.dll") do (
    "%UPX_EXE%" -l "%%~fF" >nul 2>nul
    if errorlevel 1 (
        "%UPX_EXE%" --best "%%~fF"
        if errorlevel 1 exit /b 1
    ) else (
        echo [ffmpeg] Already compressed: "%%~nxF"
    )
)
exit /b 0

:error
echo [ffmpeg] Failed.
exit /b 1
