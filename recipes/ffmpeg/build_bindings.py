#!/usr/bin/env python3
"""Fetch and stage the pinned Windows FFmpeg SDK, optionally regenerating Odin."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import urllib.request
from pathlib import Path


RECIPE_DIR = Path(__file__).resolve().parent
ROOT = RECIPE_DIR.parents[1]
sys.path.insert(0, str(RECIPE_DIR.parent))

from common import (  # noqa: E402
    bindgen_environment,
    command_exists,
    detect_platform,
    make_logger,
    resolve_bindgen,
    run,
    run_bindgen_checked,
)


FFMPEG_URL = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-full-shared.7z"
BUILD_DIR = RECIPE_DIR / "build"
ARCHIVE = BUILD_DIR / "download" / "ffmpeg-release-full-shared.7z"
EXTRACT_DIR = BUILD_DIR / "extract"
BINDGEN_DIR = RECIPE_DIR / "bindgen"
BINDGEN_INPUT_DIR = BINDGEN_DIR / "input"
GENERATED_DIR = RECIPE_DIR / "generated"
ODIN_DIR = ROOT / "odin" / "ffmpeg"
ODIN_LIB_DIR = ODIN_DIR / "libs" / "windows" / "amd64"
MANIFEST = RECIPE_DIR / "package.sjson"

log = make_logger("ffmpeg")


def find_package() -> Path | None:
    if not EXTRACT_DIR.exists():
        return None
    for candidate in sorted(EXTRACT_DIR.iterdir()):
        if (candidate / "include" / "libavcodec" / "avcodec.h").exists():
            return candidate
    return None


def find_7zip() -> str:
    for name in ("7z", "7za", "7zr"):
        found = shutil.which(name)
        if found:
            return found
    if os.name == "nt":
        for environment_name in ("ProgramFiles", "ProgramFiles(x86)"):
            root = os.environ.get(environment_name)
            if root:
                candidate = Path(root) / "7-Zip" / "7z.exe"
                if candidate.exists():
                    return str(candidate)
    raise FileNotFoundError("Could not find 7-Zip (7z, 7za, or 7zr).")


def prepare_package() -> Path:
    package = find_package()
    if package:
        log(f"Reusing extracted package: {package}")
        return package

    ARCHIVE.parent.mkdir(parents=True, exist_ok=True)
    if not ARCHIVE.exists():
        log(f"Downloading {FFMPEG_URL}")
        urllib.request.urlretrieve(FFMPEG_URL, ARCHIVE)
    else:
        log(f"Reusing downloaded archive: {ARCHIVE}")

    EXTRACT_DIR.mkdir(parents=True, exist_ok=True)
    seven_zip = find_7zip()
    log(f"Extracting with {seven_zip}")
    run([seven_zip, "x", "-y", f"-o{EXTRACT_DIR}", ARCHIVE], log=log)
    package = find_package()
    if not package:
        raise FileNotFoundError(f"Could not find an FFmpeg SDK under {EXTRACT_DIR}")
    return package


def copy_tree(source: Path, destination: Path) -> None:
    destination.mkdir(parents=True, exist_ok=True)
    shutil.copytree(source, destination, dirs_exist_ok=True)


def stage_sdk(package: Path) -> None:
    include = package / "include"
    libraries = package / "lib"
    binaries = package / "bin"
    if not (include / "libavcodec" / "avcodec.h").exists():
        raise FileNotFoundError(f"Missing FFmpeg headers under {include}")
    if not (libraries / "avcodec.lib").exists():
        raise FileNotFoundError(f"Missing FFmpeg import libraries under {libraries}")
    if not list(binaries.glob("avcodec-*.dll")):
        raise FileNotFoundError(f"Missing FFmpeg runtime DLLs under {binaries}")

    log("Staging public headers...")
    copy_tree(include, BINDGEN_INPUT_DIR)
    ODIN_LIB_DIR.mkdir(parents=True, exist_ok=True)
    log("Staging import libraries and runtime DLLs...")
    for pattern in ("*.lib", "*.dll"):
        source_dir = libraries if pattern == "*.lib" else binaries
        for source in source_dir.glob(pattern):
            destination = ODIN_LIB_DIR / source.name
            if not destination.exists() or source.stat().st_mtime_ns > destination.stat().st_mtime_ns:
                shutil.copy2(source, destination)
    for name in ("LICENSE", "README.txt"):
        source = package / name
        if source.exists():
            shutil.copy2(source, ODIN_DIR / name)


def compress_dlls() -> None:
    upx = shutil.which("upx")
    if not upx:
        log("Skipping DLL compression because upx was not found on PATH.")
        return
    for dll in sorted(ODIN_LIB_DIR.glob("*.dll")):
        probe = subprocess.run([upx, "-l", str(dll)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        if probe.returncode != 0:
            run([upx, "--best", dll], log=log)


def regenerate_bindings() -> None:
    host = detect_platform()
    bindgen = resolve_bindgen(host, ROOT)
    GENERATED_DIR.mkdir(parents=True, exist_ok=True)
    log("Regenerating Odin bindings...")
    run_bindgen_checked([str(bindgen), "."], cwd=BINDGEN_DIR, env=bindgen_environment(host), log=log)
    run([sys.executable, BINDGEN_DIR / "fix_generated.py", GENERATED_DIR], log=log)
    run([sys.executable, ROOT / "recipes" / "sync_generated.py", MANIFEST], log=log)


def run_checks() -> None:
    if not command_exists("odin"):
        log("Skipping Odin checks because odin was not found on PATH.")
        return
    collection = f"-collection:thirdparty={ROOT / 'odin'}"
    run(["odin", "check", ODIN_DIR, "-no-entry-point"], log=log)
    for name in ("create_empty_output", "grab_png_at_time", "raylib_video"):
        run(["odin", "check", ROOT / "examples" / "ffmpeg" / name, collection], log=log)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-bindgen", action="store_true")
    parser.add_argument("--skip-checks", action="store_true")
    parser.add_argument("--skip-upx", action="store_true")
    args = parser.parse_args()

    host = detect_platform()
    if host.os_name != "windows" or host.arch != "amd64":
        raise SystemExit("The prebuilt FFmpeg SDK recipe currently supports windows-amd64 only.")
    stage_sdk(prepare_package())
    if not args.skip_upx:
        compress_dlls()
    if not args.skip_bindgen:
        regenerate_bindings()
    if not args.skip_checks:
        run_checks()
    log("Done.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except subprocess.CalledProcessError as exc:
        log(f"Command failed with exit code {exc.returncode}.")
        raise SystemExit(exc.returncode)
