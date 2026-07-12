#!/usr/bin/env python3
"""Build the vendored Sokol sources for the host or Emscripten."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import tarfile
import urllib.request
from pathlib import Path


RECIPE_DIR = Path(__file__).resolve().parent
ROOT = RECIPE_DIR.parents[1]
sys.path.insert(0, str(RECIPE_DIR.parent))

from common import (  # noqa: E402
    HostPlatform,
    build_environment,
    command_exists,
    detect_platform,
    macos_deployment_target,
    make_logger,
    run,
)


SOURCE_DIR = RECIPE_DIR / "source" / "c"
BUILD_DIR = RECIPE_DIR / "build"
ODIN_DIR = ROOT / "odin" / "sokol"
EXAMPLES_DIR = ROOT / "examples" / "sokol"
DCIMGUI_DIR = RECIPE_DIR / "dcimgui"
DCIMGUI_GENERATED_DIR = DCIMGUI_DIR / "generated_bindings"
IMGUI_VERSION = "1.92.8-docking"
IMGUI_URL = f"https://github.com/ocornut/imgui/archive/refs/tags/v{IMGUI_VERSION}.tar.gz"
EMSCRIPTEN_VERSION = "6.0.2"
MODULES = ("log", "app", "gfx", "glue", "time", "audio", "debugtext", "shape", "gl", "fetch", "imgui")


log = make_logger("sokol")


def require_source() -> None:
    missing = [name for name in ("sokol_app.c", "sokol_gfx.h", "sokol_imgui.c") if not (SOURCE_DIR / name).exists()]
    if missing:
        raise FileNotFoundError(f"Missing vendored Sokol sources in {SOURCE_DIR}: {', '.join(missing)}")


def prepare_imgui() -> Path:
    source_dir = BUILD_DIR / "imgui" / f"imgui-{IMGUI_VERSION}"
    if (source_dir / "imgui.cpp").exists():
        return source_dir
    # Reuse an older CMake FetchContent checkout when upgrading this recipe in place.
    existing = BUILD_DIR / "dcimgui" / "windows-amd64" / "_deps" / "imgui-src"
    if (existing / "imgui.cpp").exists():
        source_dir.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(existing, source_dir, dirs_exist_ok=True)
        return source_dir
    archive = BUILD_DIR / "download" / f"imgui-{IMGUI_VERSION}.tar.gz"
    archive.parent.mkdir(parents=True, exist_ok=True)
    if not archive.exists():
        log(f"Downloading {IMGUI_URL}")
        urllib.request.urlretrieve(IMGUI_URL, archive)
    source_dir.parent.mkdir(parents=True, exist_ok=True)
    root = source_dir.parent.resolve()
    with tarfile.open(archive, "r:gz") as tf:
        for member in tf.getmembers():
            target = (root / member.name).resolve()
            if target != root and root not in target.parents:
                raise RuntimeError(f"Imgui archive member escapes extract dir: {member.name}")
        tf.extractall(root)
    if not (source_dir / "imgui.cpp").exists():
        raise FileNotFoundError(f"Dear ImGui archive did not contain {source_dir.name}")
    return source_dir


def find_tool(name: str) -> str:
    found = shutil.which(name)
    if found:
        return found
    if os.name == "nt":
        suffix = ".exe"
        candidates = []
        if os.environ.get("EMSDK"):
            candidates.append(Path(os.environ["EMSDK"]) / f"{name}{suffix}")
        candidates.append(Path("E:/dev/tools/emsdk/upstream/emscripten") / f"{name}{suffix}")
        for candidate in candidates:
            if candidate.exists():
                return str(candidate)
    raise FileNotFoundError(f"Missing {name}. Activate emsdk  {EMSCRIPTEN_VERSION} or add it to PATH.")


def emscripten_environment(host: HostPlatform) -> dict[str, str]:
    env = build_environment(host)
    emcc = Path(find_tool("emcc")).resolve()
    emscripten_dir = emcc.parent
    emsdk_dir = Path(env.get("EMSDK", emscripten_dir.parents[1])).resolve()
    path_entries = [str(emscripten_dir), str(emsdk_dir / "upstream" / "bin")]
    python_dirs = sorted((emsdk_dir / "python").glob("*_64bit"), reverse=True)
    node_dirs = sorted((emsdk_dir / "node").glob("*_64bit/bin"), reverse=True)
    path_entries.extend(str(path) for path in python_dirs[:1])
    path_entries.extend(str(path) for path in node_dirs[:1])
    env["EMSDK"] = str(emsdk_dir)
    env["PATH"] = os.pathsep.join([*path_entries, env.get("PATH", "")])
    return env


def include_args(msvc: bool = False, imgui_dir: Path | None = None) -> list[str]:
    prefix = "/I" if msvc else "-I"
    includes = [SOURCE_DIR, DCIMGUI_GENERATED_DIR]
    if imgui_dir:
        includes.append(imgui_dir)
    return [f"{prefix}{path}" for path in includes]


def msvc_environment() -> dict[str, str]:
    env = os.environ.copy()
    if shutil.which("cl.exe", path=env.get("PATH")) and shutil.which("lib.exe", path=env.get("PATH")):
        return env
    roots = [Path(os.environ.get("ProgramFiles", "")), Path(os.environ.get("ProgramFiles(x86)", ""))]
    for root in roots:
        for edition in ("Professional", "Community", "BuildTools"):
            script = root / "Microsoft Visual Studio" / "2022" / edition / "Common7" / "Tools" / "VsDevCmd.bat"
            if not script.exists():
                continue
            launcher = BUILD_DIR / "msvc_env.cmd"
            launcher.parent.mkdir(parents=True, exist_ok=True)
            launcher.write_text(
                f'@call "{script}" -arch=x64 -host_arch=x64 >nul\n@set\n',
                encoding="utf-8",
            )
            completed = subprocess.run(
                ["cmd.exe", "/d", "/c", launcher],
                check=True, text=True, stdout=subprocess.PIPE,
            )
            for line in completed.stdout.splitlines():
                if "=" in line:
                    key, value = line.split("=", 1)
                    env[key.upper() if key.upper() == "PATH" else key] = value
            return env
    raise FileNotFoundError("Visual Studio 2022 C++ tools were not found.")


def build_windows(host: HostPlatform, imgui_dir: Path) -> None:
    env = msvc_environment()
    cl = shutil.which("cl.exe", path=env.get("PATH"))
    lib = shutil.which("lib.exe", path=env.get("PATH"))
    if not cl or not lib:
        raise FileNotFoundError("cl.exe/lib.exe were not found after initializing Visual Studio.")
    out_dir = host.library_dir(ODIN_DIR)
    work_dir = BUILD_DIR / host.key
    out_dir.mkdir(parents=True, exist_ok=True)
    work_dir.mkdir(parents=True, exist_ok=True)
    for backend_name, backend_define in (("d3d11", "SOKOL_D3D11"), ("gl", "SOKOL_GLCORE")):
        for mode in ("debug", "release"):
            for module in MODULES:
                stem = f"sokol_{module}"
                obj = work_dir / f"{stem}_{backend_name}_{mode}.obj"
                output = out_dir / f"{stem}_windows_x64_{backend_name}_{mode}.lib"
                flags = ["/nologo", "/c", "/DIMPL", f"/D{backend_define}", *include_args(msvc=True, imgui_dir=imgui_dir)]
                flags += ["/Z7", "/D_DEBUG"] if mode == "debug" else ["/O2", "/DNDEBUG"]
                run([cl, *flags, SOURCE_DIR / f"{stem}.c", f"/Fo{obj}"], env=env, log=log)
                run([lib, "/nologo", f"/OUT:{output}", obj], env=env, log=log)
            dll = out_dir / f"sokol_dll_windows_x64_{backend_name}_{mode}.dll"
            import_lib = out_dir / f"sokol_dll_windows_x64_{backend_name}_{mode}.lib"
            dll_obj = work_dir / f"sokol_dll_{backend_name}_{mode}.obj"
            dll_flags = ["/nologo", "/DIMPL", "/DSOKOL_DLL", f"/D{backend_define}", *include_args(msvc=True, imgui_dir=imgui_dir)]
            dll_flags += ["/LDd", "/MDd", "/Z7", "/D_DEBUG"] if mode == "debug" else ["/LD", "/MD", "/O2", "/DNDEBUG"]
            run([
                cl, *dll_flags, SOURCE_DIR / "sokol.c", f"/Fo{dll_obj}", f"/Fe:{dll}",
                "/link", "/INCREMENTAL:NO", f"/IMPLIB:{import_lib}",
            ], env=env, log=log)


def build_unix(host: HostPlatform, imgui_dir: Path) -> None:
    if host.os_name == "darwin":
        compiler, archiver = "clang", "ar"
        backends = (("metal", "SOKOL_METAL"), ("gl", "SOKOL_GLCORE"))
        arch_token = "arm64" if host.arch == "arm64" else "x64"
        compiler_arch = "arm64" if host.arch == "arm64" else "x86_64"
    elif host.os_name == "linux" and host.arch == "amd64":
        compiler, archiver = "cc", "ar"
        backends = (("gl", "SOKOL_GLCORE"),)
        arch_token = "x64"
        compiler_arch = ""
    else:
        raise RuntimeError(f"Unsupported native Sokol target: {host.key}")
    out_dir = host.library_dir(ODIN_DIR)
    work_dir = BUILD_DIR / host.key
    out_dir.mkdir(parents=True, exist_ok=True)
    work_dir.mkdir(parents=True, exist_ok=True)
    env = build_environment(host)
    for backend_name, backend_define in backends:
        for mode in ("debug", "release"):
            for module in MODULES:
                stem = f"sokol_{module}"
                obj = work_dir / f"{stem}_{backend_name}_{mode}.o"
                output = out_dir / f"{stem}_macos_{arch_token}_{backend_name}_{mode}.a" if host.os_name == "darwin" else out_dir / f"{stem}_linux_x64_gl_{mode}.a"
                flags = ["-c", "-DIMPL", f"-D{backend_define}", *include_args(imgui_dir=imgui_dir)]
                flags += ["-g"] if mode == "debug" else ["-O2", "-DNDEBUG"]
                if host.os_name == "darwin":
                    flags += ["-x", "objective-c", "-arch", compiler_arch]
                else:
                    flags += ["-pthread"]
                run([compiler, *flags, SOURCE_DIR / f"{stem}.c", "-o", obj], env=env, log=log)
                run([archiver, "rcs", output, obj], env=env, log=log)
            if host.os_name == "darwin":
                combined_obj = work_dir / f"sokol_{backend_name}_{mode}.o"
                dylib = out_dir / f"sokol_dylib_macos_{arch_token}_{backend_name}_{mode}.dylib"
                flags = ["-c", "-DIMPL", "-DSOKOL_DLL", f"-D{backend_define}", *include_args(imgui_dir=imgui_dir)]
                flags += ["-g"] if mode == "debug" else ["-O2", "-DNDEBUG"]
                flags += ["-x", "objective-c", "-arch", compiler_arch]
                run([compiler, *flags, SOURCE_DIR / "sokol.c", "-o", combined_obj], env=env, log=log)
                frameworks = ["Foundation", "CoreGraphics", "Cocoa", "QuartzCore", "CoreAudio", "AudioToolbox"]
                frameworks += ["Metal", "MetalKit"] if backend_name == "metal" else ["OpenGL"]
                framework_args = [arg for name in frameworks for arg in ("-framework", name)]
                run([compiler, "-dynamiclib", "-arch", compiler_arch, *framework_args, "-o", dylib, combined_obj], env=env, log=log)


def build_dcimgui(host: HostPlatform, wasm: bool = False) -> Path:
    target_key = "web-wasm32" if wasm else host.key
    build_dir = BUILD_DIR / "dcimgui" / target_key
    output_dir = ODIN_DIR / "imgui" / "dear" / "lib" / ("web_wasm32" if wasm else f"{host.os_name}_{host.arch}")
    imgui_dir = prepare_imgui()
    if wasm:
        env = emscripten_environment(host)
        emxx = find_tool("em++")
        emar = find_tool("emar")
        work_dir = BUILD_DIR / "dcimgui" / target_key
        work_dir.mkdir(parents=True, exist_ok=True)
        output_dir.mkdir(parents=True, exist_ok=True)
        sources = [imgui_dir / name for name in ("imgui.cpp", "imgui_demo.cpp", "imgui_draw.cpp", "imgui_tables.cpp", "imgui_widgets.cpp")]
        sources.append(DCIMGUI_GENERATED_DIR / "dcimgui.cpp")
        objects = []
        for source in sources:
            obj = work_dir / f"{source.stem}.o"
            run([emxx, "-c", "-O2", "-DNDEBUG", "-std=c++11", f"-I{imgui_dir}", f"-I{DCIMGUI_GENERATED_DIR}", source, "-o", obj], env=env, log=log)
            objects.append(obj)
        run([emar, "rcs", output_dir / "libdcimgui_core.a", *objects], env=env, log=log)
        return output_dir
    configure = [
        "cmake", "-S", DCIMGUI_DIR, "-B", build_dir,
        f"-DSOKOL_DCIMGUI_IMGUI_VERSION={IMGUI_VERSION}",
        f"-DSOKOL_DCIMGUI_OUTPUT_DIR={output_dir}",
        f"-DFETCHCONTENT_SOURCE_DIR_IMGUI={imgui_dir}",
        "-DCMAKE_BUILD_TYPE=Release",
    ]
    if host.os_name == "darwin" and not wasm:
        configure.append(f"-DCMAKE_OSX_DEPLOYMENT_TARGET={macos_deployment_target()}")
    env = build_environment(host)
    run(configure, env=env, log=log)
    run(["cmake", "--build", build_dir, "--config", "Release"], env=env, log=log)
    return output_dir


def build_wasm(host: HostPlatform) -> None:
    emcc = find_tool("emcc")
    emar = find_tool("emar")
    out_dir = ODIN_DIR / "libs" / "web" / "wasm32"
    work_dir = BUILD_DIR / "web-wasm32"
    out_dir.mkdir(parents=True, exist_ok=True)
    work_dir.mkdir(parents=True, exist_ok=True)
    env = emscripten_environment(host)
    imgui_dir = prepare_imgui()
    build_dcimgui(host, wasm=True)
    for mode in ("debug", "release"):
        for module in MODULES:
            stem = f"sokol_{module}"
            obj = work_dir / f"{stem}_{mode}.o"
            output = out_dir / f"{stem}_wasm_gl_{mode}.a"
            flags = ["-c", "-DIMPL", "-DSOKOL_GLES3", *include_args(imgui_dir=imgui_dir)]
            flags += ["-g"] if mode == "debug" else ["-O2", "-DNDEBUG"]
            run([emcc, *flags, SOURCE_DIR / f"{stem}.c", "-o", obj], env=env, log=log)
            run([emar, "rcs", output, obj], env=env, log=log)


def build_wasm_example(host: HostPlatform) -> None:
    if not command_exists("odin"):
        log("Skipping WASM example because odin was not found on PATH.")
        return
    env = emscripten_environment(host)
    example_dir = BUILD_DIR / "example-wasm"
    example_dir.mkdir(parents=True, exist_ok=True)
    libs = ODIN_DIR / "libs" / "web" / "wasm32"
    common_archives = [libs / f"sokol_{name}_wasm_gl_release.a" for name in ("app", "gfx", "glue", "log")]
    for example_name in ("clear", "imgui"):
        obj = example_dir / (f"{example_name}.obj" if os.name == "nt" else f"{example_name}.o")
        run([
            "odin", "build", EXAMPLES_DIR / example_name, "-target:js_wasm32", "-build-mode:obj",
            f"-out:{obj}", f"-collection:thirdparty={ROOT / 'odin'}",
        ], log=log)
        archives = list(common_archives)
        linker = find_tool("emcc")
        if example_name == "imgui":
            linker = find_tool("em++")
            archives += [
                libs / "sokol_imgui_wasm_gl_release.a",
                ODIN_DIR / "imgui" / "dear" / "lib" / "web_wasm32" / "libdcimgui_core.a",
            ]
        run([
            linker, obj, *archives,
            "--js-library", RECIPE_DIR / "wasm" / "odin_runtime.js",
            "-sUSE_WEBGL2=1", "-sFULL_ES3=1", "-sALLOW_MEMORY_GROWTH=1",
            "-o", example_dir / f"{example_name}.html",
        ], env=env, log=log)


def run_odin_checks(skip_checks: bool) -> None:
    if skip_checks or not command_exists("odin"):
        log("Skipping Odin checks." if skip_checks else "Skipping Odin checks because odin was not found on PATH.")
        return
    collection_arg = f"-collection:thirdparty={ROOT / 'odin'}"
    packages = ["log", "app", "gfx", "glue", "fetch", "time", "audio", "debugtext", "shape", "gl", "helpers", "imgui", "imgui/dear"]
    for package in packages:
        run(["odin", "check", ODIN_DIR / package, "-no-entry-point"], log=log)
    run(["odin", "check", EXAMPLES_DIR / "clear", collection_arg], log=log)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target", choices=("native", "web-wasm32"), default="native")
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--skip-checks", action="store_true")
    parser.add_argument("--build-example", action="store_true", help="Also link the clear browser smoke test")
    args = parser.parse_args()
    host = detect_platform()
    require_source()
    if not args.skip_build:
        imgui_dir = prepare_imgui()
        if args.target == "web-wasm32":
            build_wasm(host)
        elif host.os_name == "windows":
            build_dcimgui(host)
            build_windows(host, imgui_dir)
        else:
            build_dcimgui(host)
            build_unix(host, imgui_dir)
    if args.target == "web-wasm32" and args.build_example:
        build_wasm_example(host)
    run_odin_checks(args.skip_checks)
    log("Done.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except subprocess.CalledProcessError as exc:
        log(f"Command failed with exit code {exc.returncode}.")
        raise SystemExit(exc.returncode)
