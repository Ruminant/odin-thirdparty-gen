#!/usr/bin/env python3
"""Fetch, build, and sync the Sokol Odin package."""

from __future__ import annotations

import argparse
import os
import platform
import shutil
import subprocess
import sys
import tarfile
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from typing import TypeAlias


RECIPE_DIR = Path(__file__).resolve().parent
ROOT = RECIPE_DIR.parents[1]
BUILD_DIR = RECIPE_DIR / "build"
DOWNLOAD_DIR = BUILD_DIR / "download"
EXTRACT_DIR = BUILD_DIR / "extract"
MANIFEST = RECIPE_DIR / "package.sjson"
ODIN_DIR = ROOT / "odin" / "sokol"
EXAMPLES_DIR = ROOT / "examples" / "sokol"


CommandArg: TypeAlias = str | os.PathLike[str]


@dataclass(frozen=True)
class HostPlatform:
    os_name: str
    arch: str

    @property
    def key(self) -> str:
        return f"{self.os_name}-{self.arch}"

    @property
    def upstream_arch_token(self) -> str:
        return "x64" if self.arch == "amd64" else self.arch

    def library_dir(self, package_dir: Path) -> Path:
        return package_dir / "libs" / self.os_name / self.arch


def log(message: str) -> None:
    print(f"[sokol] {message}", flush=True)


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


def string_value(text: str, key: str) -> str:
    import re

    match = re.search(rf"(?m)^\s*{re.escape(key)}\s*=\s*\"([^\"]+)\"", text)
    if match is None:
        raise ValueError(f"Missing string key: {key}")
    return match.group(1)


def command_exists(command: str) -> bool:
    return shutil.which(command) is not None


def run(command: list[CommandArg], cwd: Path | None = None) -> None:
    log("+ " + " ".join(os.fspath(arg) for arg in command))
    subprocess.run(command, cwd=cwd, check=True)


def download(url: str, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    log(f"Downloading {url}")
    with urllib.request.urlopen(url) as response, destination.open("wb") as output:
        while True:
            chunk = response.read(1024 * 1024)
            if not chunk:
                break
            output.write(chunk)


def safe_extract_tar(archive: Path, destination: Path) -> None:
    root = destination.resolve()
    with tarfile.open(archive, "r:gz") as tf:
        for member in tf.getmembers():
            target = (root / member.name).resolve()
            if target != root and root not in target.parents:
                raise RuntimeError(f"Archive member escapes extract dir: {member.name}")
        tf.extractall(root)


def find_package_dir(source_package_dir: str) -> Path | None:
    if not EXTRACT_DIR.exists():
        return None
    for child in sorted(EXTRACT_DIR.iterdir()):
        if child.is_dir() and (child / source_package_dir).exists():
            return child
    return None


def prepare_package(manifest: str) -> Path:
    upstream_url = string_value(manifest, "upstream_url")
    archive_name = string_value(manifest, "archive_name")
    source_package_dir = string_value(manifest, "source_package_dir")
    archive = DOWNLOAD_DIR / archive_name

    DOWNLOAD_DIR.mkdir(parents=True, exist_ok=True)
    EXTRACT_DIR.mkdir(parents=True, exist_ok=True)

    if archive.exists():
        log(f"Reusing downloaded archive: {archive}")
    else:
        download(upstream_url, archive)

    package_dir = find_package_dir(source_package_dir)
    if package_dir is None:
        log("Extracting archive...")
        safe_extract_tar(archive, EXTRACT_DIR)
        package_dir = find_package_dir(source_package_dir)

    if package_dir is None:
        raise FileNotFoundError(f"Could not find extracted Sokol package under {EXTRACT_DIR}")
    log(f"Using package: {package_dir}")
    return package_dir


def find_vsdevcmd() -> Path | None:
    roots = [
        Path(os.environ.get("ProgramFiles", "")),
        Path(os.environ.get("ProgramFiles(x86)", "")),
    ]
    editions = ["Professional", "Community", "BuildTools"]
    for root in roots:
        if not root:
            continue
        for edition in editions:
            candidate = root / "Microsoft Visual Studio" / "2022" / edition / "Common7" / "Tools" / "VsDevCmd.bat"
            if candidate.exists():
                return candidate
    return None


def run_windows_build(sokol_dir: Path) -> None:
    script = sokol_dir / "build_clibs_windows.cmd"
    if not script.exists():
        raise FileNotFoundError(f"Missing upstream Windows build script: {script}")

    if command_exists("cl.exe"):
        run(["cmd.exe", "/d", "/c", script.name], cwd=sokol_dir)
        return

    vsdevcmd = find_vsdevcmd()
    if vsdevcmd is None:
        raise FileNotFoundError("cl.exe was not found. Run from a Visual Studio Developer Command Prompt or install VS Build Tools.")

    launcher = BUILD_DIR / "run_sokol_windows_build.cmd"
    launcher.write_text(
        "\n".join(
            [
                "@echo off",
                f'call "{vsdevcmd}" -arch=x64 -host_arch=x64',
                "if errorlevel 1 exit /b %ERRORLEVEL%",
                f'cd /d "{sokol_dir}"',
                "if errorlevel 1 exit /b %ERRORLEVEL%",
                f'call "{script.name}"',
                "exit /b %ERRORLEVEL%",
                "",
            ]
        ),
        encoding="utf-8",
    )
    run(["cmd.exe", "/d", "/c", launcher], cwd=sokol_dir)


def build_platform_libs(host: HostPlatform, sokol_dir: Path) -> None:
    if host.os_name == "windows":
        run_windows_build(sokol_dir)
        return

    if host.os_name == "darwin":
        run(["sh", sokol_dir / "build_clibs_macos.sh"], cwd=sokol_dir)
        run(["sh", sokol_dir / "build_clibs_macos_dylib.sh"], cwd=sokol_dir)
        return

    if host.os_name == "linux":
        if host.arch != "amd64":
            raise RuntimeError("Upstream Sokol Linux script currently builds x64 artifacts only.")
        run(["sh", sokol_dir / "build_clibs_linux.sh"], cwd=sokol_dir)
        return

    raise RuntimeError(f"Unsupported Sokol platform: {host.key}")


def built_library_patterns(host: HostPlatform) -> list[str]:
    if host.os_name == "windows":
        return ["*.lib", "*.dll"]
    if host.os_name == "darwin":
        return ["*.a", "*.dylib"]
    if host.os_name == "linux":
        return ["*.a", "*.so"]
    return []


def belongs_to_host(path: Path, host: HostPlatform) -> bool:
    name = path.name
    if host.os_name == "windows":
        return "_windows_x64_" in name
    if host.os_name == "darwin":
        return f"_macos_{host.upstream_arch_token}_" in name
    if host.os_name == "linux":
        return "_linux_x64_" in name
    return False


def copy_newer(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists() and destination.stat().st_mtime >= source.stat().st_mtime:
        return
    shutil.copy2(source, destination)


def vendored_windows_lib_dirs(host: HostPlatform) -> list[Path]:
    if host.os_name != "windows":
        return []
    relative = Path("odin") / "sokol" / "libs" / "windows" / "amd64"
    return [
        ROOT / relative,
        ROOT / ".local-artifacts" / relative,
        ROOT / ".local-artifacts" / "recent-build" / relative,
    ]


def stage_libraries(host: HostPlatform, package_dir: Path) -> None:
    sokol_dir = package_dir / "sokol"
    output_dir = host.library_dir(ODIN_DIR)
    output_dir.mkdir(parents=True, exist_ok=True)

    sources: list[Path] = []
    for pattern in built_library_patterns(host):
        sources.extend(path for path in sokol_dir.rglob(pattern) if path.is_file() and belongs_to_host(path, host))

    if not sources:
        raise FileNotFoundError(f"No built Sokol libraries found for {host.key} under {sokol_dir}")

    log(f"Copying libraries into {output_dir.relative_to(ROOT)}...")
    for source in sorted(set(sources), key=lambda path: path.name):
        copy_newer(source, output_dir / source.name)

    vendored = []
    for directory in vendored_windows_lib_dirs(host):
        if directory.exists():
            vendored.extend(directory.glob("dcimgui*.lib"))

    if vendored:
        log("Copying vendored dcimgui Windows libraries...")
        for source in sorted(set(vendored), key=lambda path: path.name):
            copy_newer(source, output_dir / source.name)
    elif host.os_name == "windows":
        log("Warning: no vendored dcimgui Windows libraries were found.")


def sync_package(host: HostPlatform, package_dir: Path) -> None:
    log("Syncing Odin package and examples...")
    run(
        [
            sys.executable,
            RECIPE_DIR / "sync_sokol.py",
            MANIFEST,
            package_dir,
            "--os",
            host.os_name,
            "--arch",
            host.arch,
        ]
    )


def run_odin_checks(skip_checks: bool) -> None:
    if skip_checks:
        log("Skipping Odin checks.")
        return
    if not command_exists("odin"):
        log("Skipping Odin checks because odin was not found on PATH.")
        return

    collection_arg = f"-collection:thirdparty={ROOT / 'odin'}"
    checks = [
        ODIN_DIR / "log",
        ODIN_DIR / "app",
        ODIN_DIR / "gfx",
        ODIN_DIR / "glue",
        ODIN_DIR / "time",
        ODIN_DIR / "audio",
        ODIN_DIR / "debugtext",
        ODIN_DIR / "shape",
        ODIN_DIR / "gl",
        ODIN_DIR / "helpers",
        ODIN_DIR / "imgui",
        ODIN_DIR / "imgui" / "dear",
    ]
    log("Checking core packages...")
    for package in checks:
        run(["odin", "check", package, "-no-entry-point"])
    log("Checking clear example...")
    run(["odin", "check", EXAMPLES_DIR / "clear", collection_arg])


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--skip-checks", action="store_true")
    args = parser.parse_args()

    host = detect_platform()
    manifest = MANIFEST.read_text(encoding="utf-8")
    package_dir = prepare_package(manifest)

    if args.skip_build:
        log("Skipping native library build.")
    else:
        build_platform_libs(host, package_dir / "sokol")

    sync_package(host, package_dir)
    stage_libraries(host, package_dir)
    run_odin_checks(args.skip_checks)
    log("Done.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except subprocess.CalledProcessError as exc:
        log(f"Command failed with exit code {exc.returncode}.")
        raise SystemExit(exc.returncode)
