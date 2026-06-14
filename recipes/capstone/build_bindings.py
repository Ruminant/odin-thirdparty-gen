#!/usr/bin/env python3
"""Fetch, build, and regenerate the Capstone Odin package."""

from __future__ import annotations

import argparse
import os
import platform
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import TypeAlias


RECIPE_DIR = Path(__file__).resolve().parent
ROOT = RECIPE_DIR.parents[1]
BUILD_DIR = RECIPE_DIR / "build"
BINDGEN_DIR = RECIPE_DIR / "bindgen"
BINDGEN_INPUT_DIR = BINDGEN_DIR / "input"
GENERATED_DIR = RECIPE_DIR / "generated"
MANIFEST = RECIPE_DIR / "package.sjson"
ODIN_DIR = ROOT / "odin" / "capstone"


CommandArg: TypeAlias = str | os.PathLike[str]


@dataclass(frozen=True)
class HostPlatform:
    os_name: str
    arch: str

    @property
    def key(self) -> str:
        return f"{self.os_name}-{self.arch}"

    @property
    def bindgen_exe_name(self) -> str:
        return "bindgen.exe" if self.os_name == "windows" else "bindgen"

    def library_dir(self, package_dir: Path) -> Path:
        return package_dir / "libs" / self.os_name / self.arch

    def tool_dir(self, root: Path) -> Path:
        return root / ".thirdparty-tools" / "bindgen" / self.key


def log(message: str) -> None:
    print(f"[capstone] {message}", flush=True)


def detect_platform() -> HostPlatform:
    system = platform.system().lower()
    machine = platform.machine().lower()

    os_name = {
        "windows": "windows",
        "darwin": "darwin",
        "linux": "linux",
    }.get(system)
    arch = {
        "amd64": "amd64",
        "x86_64": "amd64",
        "arm64": "arm64",
        "aarch64": "arm64",
    }.get(machine)

    if not os_name or not arch:
        raise SystemExit(f"Unsupported platform: {platform.system()} {platform.machine()}")
    return HostPlatform(os_name=os_name, arch=arch)


def command_exists(command: str) -> bool:
    return shutil.which(command) is not None


def run(command: list[CommandArg], cwd: Path | None = None) -> None:
    log("+ " + " ".join(os.fspath(arg) for arg in command))
    subprocess.run(command, cwd=cwd, check=True)


def copy_newer(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists() and destination.stat().st_mtime >= source.stat().st_mtime:
        return
    shutil.copy2(source, destination)


def stage_headers() -> None:
    include_dir = BUILD_DIR / "_deps" / "capstone-src" / "include"
    capstone_header = include_dir / "capstone" / "capstone.h"
    if not capstone_header.exists():
        raise FileNotFoundError(f"Missing fetched Capstone headers: {include_dir}")

    log("Staging public headers for bindgen...")
    BINDGEN_INPUT_DIR.mkdir(parents=True, exist_ok=True)
    for header in sorted((include_dir / "capstone").glob("*.h")):
        copy_newer(header, BINDGEN_INPUT_DIR / header.name)

    windowsce_dir = include_dir / "windowsce"
    if windowsce_dir.exists():
        staged_windowsce = BINDGEN_INPUT_DIR / "windowsce"
        staged_windowsce.mkdir(parents=True, exist_ok=True)
        for header in sorted(windowsce_dir.glob("*.h")):
            copy_newer(header, staged_windowsce / header.name)


def capstone_build_root(config: str) -> Path:
    build_root = BUILD_DIR / "_deps" / "capstone-build"
    if (build_root / config).exists():
        return build_root / config
    return build_root


def stage_libraries(config: str, host: HostPlatform) -> None:
    build_root = capstone_build_root(config)
    if not build_root.exists():
        raise FileNotFoundError(f"Missing Capstone build output: {build_root}")

    lib_dir = host.library_dir(ODIN_DIR)
    lib_dir.mkdir(parents=True, exist_ok=True)

    if host.os_name == "windows":
        names = ["capstone.lib", "capstone.dll", "capstone_static.lib"]
        sources = []
        for name in names:
            matches = sorted(build_root.rglob(name))
            if not matches:
                raise FileNotFoundError(f"Missing built Capstone artifact: {name} under {build_root}")
            sources.append(matches[0])
    else:
        patterns = ["libcapstone*.a", "libcapstone*.dylib", "libcapstone*.so", "libcapstone*.so.*"]
        sources = []
        for pattern in patterns:
            sources.extend(path for path in build_root.rglob(pattern) if path.is_file())
        sources = sorted(set(sources), key=lambda path: path.name)
        if not sources:
            raise FileNotFoundError(f"Missing built Capstone libraries under {build_root}")

    log(f"Copying libraries into {lib_dir.relative_to(ROOT)}...")
    for source in sources:
        copy_newer(source, lib_dir / source.name)


def resolve_bindgen(host: HostPlatform) -> Path:
    env_bindgen = os.environ.get("BINDGEN_EXE")
    candidates = []
    if env_bindgen:
        candidates.append(Path(env_bindgen))

    candidates.append(host.tool_dir(ROOT) / host.bindgen_exe_name)

    path_bindgen = shutil.which("bindgen")
    if path_bindgen:
        candidates.append(Path(path_bindgen))

    for candidate in candidates:
        if candidate.exists():
            return candidate.resolve()

    raise FileNotFoundError(
        "Missing bindgen executable. Run `just bootstrap-tools`, install bindgen on PATH, "
        "or set BINDGEN_EXE."
    )


def regenerate_bindings(bindgen: Path) -> None:
    log("Regenerating Odin bindings...")
    GENERATED_DIR.mkdir(parents=True, exist_ok=True)
    run([str(bindgen), "."], cwd=BINDGEN_DIR)
    run([sys.executable, str(ROOT / "recipes" / "sync_generated.py"), str(MANIFEST)])


def run_odin_checks(skip_checks: bool) -> None:
    if skip_checks:
        log("Skipping Odin checks.")
        return
    if not command_exists("odin"):
        log("Skipping Odin checks because odin was not found on PATH.")
        return

    collection_arg = f"-collection:thirdparty={ROOT / 'odin'}"
    log("Checking generated Odin package...")
    run(["odin", "check", str(ODIN_DIR), "-no-entry-point"])
    log("Checking example...")
    run(["odin", "check", str(ROOT / "examples" / "capstone" / "disasm_basic"), collection_arg])


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", default="Release", help="CMake build config")
    parser.add_argument("--skip-bindgen", action="store_true")
    parser.add_argument("--skip-checks", action="store_true")
    args = parser.parse_args()

    host = detect_platform()

    log("Configuring CMake...")
    run(["cmake", "-S", str(RECIPE_DIR), "-B", str(BUILD_DIR)])

    log(f"Building {args.config} artifacts...")
    run(["cmake", "--build", str(BUILD_DIR), "--config", args.config])

    stage_headers()
    stage_libraries(args.config, host)

    if args.skip_bindgen:
        log("Skipping bindgen.")
    else:
        regenerate_bindings(resolve_bindgen(host))

    run_odin_checks(args.skip_checks)
    log("Done.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except subprocess.CalledProcessError as exc:
        log(f"Command failed with exit code {exc.returncode}.")
        raise SystemExit(exc.returncode)
