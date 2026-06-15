set windows-shell := ["powershell.exe", "-NoProfile", "-Command"]

collection := "-collection:thirdparty=odin"
ffmpeg_path := "$(Resolve-Path .\\odin\\ffmpeg\\libs\\windows\\amd64);$env:PATH"

default:
    just --list

all: capstone ffmpeg

capstone:
    .\recipes\capstone\build_bindings.bat

ffmpeg:
    .\recipes\ffmpeg\build_bindings.bat

check: check-capstone check-ffmpeg

check-capstone:
    odin check odin\capstone -no-entry-point
    odin check examples\capstone\disasm_basic {{collection}}

check-ffmpeg:
    odin check odin\ffmpeg -no-entry-point
    odin check examples\ffmpeg\create_empty_output {{collection}}
    odin check examples\ffmpeg\grab_png_at_time {{collection}}
    odin check examples\ffmpeg\raylib_video {{collection}}

example-capstone:
    odin run examples\capstone\disasm_basic {{collection}} -define:CAPSTONE_STATIC=true -out:examples\capstone\disasm_basic\disasm_basic.exe

example-ffmpeg-create:
    $env:PATH = "{{ffmpeg_path}}"; odin run examples\ffmpeg\create_empty_output {{collection}} -out:examples\ffmpeg\create_empty_output\create_empty_output.exe

example-ffmpeg-grab video seconds="10.0" output="output.png":
    $env:PATH = "{{ffmpeg_path}}"; odin run examples\ffmpeg\grab_png_at_time {{collection}} -out:examples\ffmpeg\grab_png_at_time\grab_png_at_time.exe -- -video="{{video}}" -seconds={{seconds}} -output="{{output}}"

example-ffmpeg-raylib video:
    $env:PATH = "{{ffmpeg_path}}"; odin run examples\ffmpeg\raylib_video {{collection}} -out:examples\ffmpeg\raylib_video\raylib_video.exe -- -video="{{video}}"

clean-examples:
    Remove-Item -LiteralPath examples\capstone\disasm_basic\disasm_basic.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples\ffmpeg\create_empty_output\create_empty_output.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples\ffmpeg\create_empty_output\ffmpeg-empty-output.mkv -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples\ffmpeg\grab_png_at_time\grab_png_at_time.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples\ffmpeg\grab_png_at_time\output.png -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples\ffmpeg\raylib_video\raylib_video.exe -Force -ErrorAction SilentlyContinue
