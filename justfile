set windows-shell := ["powershell.exe", "-NoProfile", "-Command"]

collection := "-collection:thirdparty=odin"
ffmpeg_path := "$(Resolve-Path ./odin/ffmpeg/libs/windows/amd64);$env:PATH"
python := if os_family() == "windows" { "py -3" } else { "python3" }

default:
    just --list

build-all platform="":
    zig build all {{ if platform != "" { "-Dplatform=" + platform } else { "" } }}

bootstrap platform="":
    {{python}} tools/bootstrap.py {{ if platform != "" { "--platform " + platform } else { "" } }}

bootstrap-tools:
    {{python}} tools/bootstrap.py --kind tools

package-release platform="":
    {{python}} tools/package_release.py {{platform}}

package-tools bindgen libclang="":
    {{python}} tools/package_tools.py "{{bindgen}}" --libclang "{{libclang}}"

build-capstone platform="":
    zig build capstone {{ if platform != "" { "-Dplatform=" + platform } else { "" } }}

build-ffmpeg:
    zig build ffmpeg -Dplatform=windows-amd64

build-sokol platform="":
    zig build sokol {{ if platform != "" { "-Dplatform=" + platform } else { "" } }}

build-sokol-wasm emsdk=env_var_or_default("EMSDK", ""):
    zig build sokol-wasm -Dplatform=web-wasm32 {{ if emsdk != "" { "-Demsdk=" + emsdk } else { "" } }}

example-sokol-wasm emsdk=env_var_or_default("EMSDK", ""):
    zig build sokol-wasm-examples -Dplatform=web-wasm32 {{ if emsdk != "" { "-Demsdk=" + emsdk } else { "" } }}

bindings:
    zig build bindings

check platform="":
    zig build check {{ if platform != "" { "-Dplatform=" + platform } else { "" } }}

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
    odin check odin/sokol/fetch -no-entry-point
    odin check odin/sokol/time -no-entry-point
    odin check odin/sokol/audio -no-entry-point
    odin check odin/sokol/debugtext -no-entry-point
    odin check odin/sokol/shape -no-entry-point
    odin check odin/sokol/gl -no-entry-point
    odin check odin/sokol/helpers -no-entry-point
    odin check odin/sokol/imgui -no-entry-point
    odin check odin/sokol/imgui/dear -no-entry-point
    odin check examples/sokol/clear {{collection}}
    odin check examples/sokol/fetch {{collection}}

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

example-sokol-fetch:
    odin run examples/sokol/fetch {{collection}} -out:examples/sokol/fetch/sokol_fetch.exe


clean-examples:
    Remove-Item -LiteralPath examples/capstone/disasm_basic/disasm_basic.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/ffmpeg/create_empty_output/create_empty_output.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/ffmpeg/create_empty_output/ffmpeg-empty-output.mkv -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/ffmpeg/grab_png_at_time/grab_png_at_time.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/ffmpeg/grab_png_at_time/output.png -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/ffmpeg/raylib_video/raylib_video.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/sokol/clear/sokol_clear.exe -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath examples/sokol/fetch/sokol_fetch.exe -Force -ErrorAction SilentlyContinue
