set windows-shell := ["powershell.exe", "-NoProfile", "-Command"]

collection := "-collection:thirdparty=odin"
ffmpeg_path := "$(Resolve-Path ./odin/ffmpeg/libs/windows/amd64);$env:PATH"
python := if os_family() == "windows" { "py -3" } else { "python3" }

default:
    just --list

build-all: build-capstone build-ffmpeg build-sokol

bootstrap:
    {{python}} tools/bootstrap.py

bootstrap-tools:
    {{python}} tools/bootstrap.py --kind tools

package-release platform="":
    {{python}} tools/package_release.py {{platform}}

package-tools bindgen libclang="":
    {{python}} tools/package_tools.py "{{bindgen}}" --libclang "{{libclang}}"

build-capstone:
    {{python}} recipes/capstone/build_bindings.py

build-ffmpeg:
    ./recipes/ffmpeg/build_bindings.bat

build-sokol:
    {{python}} recipes/sokol/build_bindings.py

check: check-capstone check-ffmpeg check-sokol

check-capstone:
    odin check odin/capstone -no-entry-point
    odin check examples/capstone/disasm_basic {{collection}}

check-ffmpeg:
    odin check odin/ffmpeg -no-entry-point
    odin check examples/ffmpeg/create_empty_output {{collection}}
    odin check examples/ffmpeg/grab_png_at_time {{collection}}
    odin check examples/ffmpeg/raylib_video {{collection}}

check-sokol:
    odin check odin/sokol/log -no-entry-point
    odin check odin/sokol/app -no-entry-point
    odin check odin/sokol/gfx -no-entry-point
    odin check odin/sokol/glue -no-entry-point
    odin check odin/sokol/time -no-entry-point
    odin check odin/sokol/audio -no-entry-point
    odin check odin/sokol/debugtext -no-entry-point
    odin check odin/sokol/shape -no-entry-point
    odin check odin/sokol/gl -no-entry-point
    odin check odin/sokol/helpers -no-entry-point
    odin check odin/sokol/imgui -no-entry-point
    odin check odin/sokol/imgui/dear -no-entry-point
    odin check examples/sokol/clear {{collection}}

example-capstone:
    odin run examples/capstone/disasm_basic {{collection}} -define:CAPSTONE_STATIC=true -out:examples/capstone/disasm_basic/disasm_basic.exe

example-ffmpeg-create:
    $env:PATH = "{{ffmpeg_path}}"; odin run examples/ffmpeg/create_empty_output {{collection}} -out:examples/ffmpeg/create_empty_output/create_empty_output.exe

example-ffmpeg-grab video seconds="10.0" output="output.png":
    $env:PATH = "{{ffmpeg_path}}"; odin run examples/ffmpeg/grab_png_at_time {{collection}} -out:examples/ffmpeg/grab_png_at_time/grab_png_at_time.exe -- -video="{{video}}" -seconds={{seconds}} -output="{{output}}"

example-ffmpeg-raylib video:
    $env:PATH = "{{ffmpeg_path}}"; odin run examples/ffmpeg/raylib_video {{collection}} -out:examples/ffmpeg/raylib_video/raylib_video.exe -- -video="{{video}}"

example-sokol-clear:
    odin run examples/sokol/clear {{collection}} -out:examples/sokol/clear/sokol_clear.exe

example-sokol-imgui:
    odin run examples/sokol/imgui {{collection}} -out:examples/sokol/clear/sokol_imgui.exe


clean-examples:
    Remove-Item -LiteralPath examples/capstone/disasm_basic/disasm_basic.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/ffmpeg/create_empty_output/create_empty_output.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/ffmpeg/create_empty_output/ffmpeg-empty-output.mkv -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/ffmpeg/grab_png_at_time/grab_png_at_time.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/ffmpeg/grab_png_at_time/output.png -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/ffmpeg/raylib_video/raylib_video.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/sokol/clear/sokol_clear.exe -Force -ErrorAction SilentlyContinue
