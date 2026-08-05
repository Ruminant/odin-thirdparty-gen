#!/usr/bin/env python3
"""Download, install, and activate a pinned repository-local Emscripten SDK."""

from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


REPOSITORY = "https://github.com/emscripten-core/emsdk.git"
VERSION_PATTERN = re.compile(r"^[0-9]+\.[0-9]+\.[0-9]+$")
MARKER_NAME = ".odin-thirdparty-emsdk-version"


def emcc_path(directory: Path) -> Path:
    suffix = ".exe" if sys.platform == "win32" else ""
    return directory / "upstream" / "emscripten" / f"emcc{suffix}"


def clone_emsdk(directory: Path, version: str) -> None:
    if directory.exists():
        raise SystemExit(
            f"Local Emscripten directory exists but does not contain emsdk.py: {directory}"
        )

    directory.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="emsdk-", dir=directory.parent) as temporary:
        checkout = Path(temporary) / "checkout"
        print(f"[emsdk] Downloading emsdk {version} into {directory}")
        subprocess.run(
            [
                "git",
                "clone",
                "--depth",
                "1",
                "--branch",
                version,
                REPOSITORY,
                str(checkout),
            ],
            check=True,
        )
        shutil.move(str(checkout), directory)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", required=True, type=Path)
    parser.add_argument("--version", default="6.0.2")
    args = parser.parse_args()

    if not VERSION_PATTERN.fullmatch(args.version):
        raise SystemExit(f"Invalid Emscripten version: {args.version!r}")

    directory = args.directory.resolve()
    manager = directory / "emsdk.py"
    marker = directory / MARKER_NAME
    compiler = emcc_path(directory)
    if marker.exists() and marker.read_text(encoding="utf-8").strip() == args.version and compiler.exists():
        print(f"[emsdk] Reusing Emscripten {args.version} from {directory}")
        return 0

    if not manager.exists():
        clone_emsdk(directory, args.version)

    print(f"[emsdk] Installing Emscripten {args.version}")
    subprocess.run([sys.executable, str(manager), "install", args.version], cwd=directory, check=True)
    subprocess.run([sys.executable, str(manager), "activate", args.version], cwd=directory, check=True)

    if not compiler.exists():
        raise SystemExit(f"Emscripten installation did not produce the expected compiler: {compiler}")
    marker.write_text(args.version + "\n", encoding="utf-8")
    print(f"[emsdk] Emscripten {args.version} is ready in {directory}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
