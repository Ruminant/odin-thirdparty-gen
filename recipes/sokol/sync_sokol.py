from __future__ import annotations

import re
import shutil
import sys
import os
import argparse
from pathlib import Path


LIB_RE = re.compile(r'"([^"]*(?:sokol_|dcimgui_core)[^"]+\.(?:lib|dll|a|dylib|so))"')
EXAMPLE_IMPORT_RE = re.compile(r'import\s+([A-Za-z_][A-Za-z0-9_]*)\s+"(?:\.\./)+sokol/([^"]+)"')


def string_value(text: str, key: str) -> str:
    match = re.search(rf"(?m)^\s*{re.escape(key)}\s*=\s*\"([^\"]+)\"", text)
    if match is None:
        raise ValueError(f"Missing string key: {key}")
    return match.group(1)


def string_list(text: str, key: str) -> list[str]:
    match = re.search(rf"(?ms)^\s*{re.escape(key)}\s*=\s*\[(.*?)\]", text)
    if match is None:
        return []
    return re.findall(r"\"([^\"]+)\"", match.group(1))


def reset_dir(path: Path) -> None:
    if path.exists():
        shutil.rmtree(path)
    path.mkdir(parents=True, exist_ok=True)


def package_lib_prefix(package_root: Path, file_path: Path, os_name: str, arch: str) -> str:
    relative = os.path.relpath(package_root / "libs" / os_name / arch, file_path.parent)
    return relative.replace("\\", "/")


def library_platform(name: str) -> tuple[str, str] | None:
    if name.startswith("dcimgui") or "windows_x64" in name:
        return "windows", "amd64"
    if "macos_arm64" in name:
        return "darwin", "arm64"
    if "macos_x64" in name:
        return "darwin", "amd64"
    if "linux_x64" in name:
        return "linux", "amd64"
    return None


def patch_package_text(package_root: Path, path: Path, text: str) -> str:
    def replace_lib(match: re.Match[str]) -> str:
        name = Path(match.group(1)).name
        platform = library_platform(name)
        if platform is None:
            return match.group(0)
        lib_prefix = package_lib_prefix(package_root, path, *platform)
        return f'"{lib_prefix}/{name}"'

    return LIB_RE.sub(replace_lib, text)


def write_text_if_changed(path: Path, text: str) -> None:
    if path.exists() and path.read_text(encoding="utf-8") == text:
        return
    path.write_text(text, encoding="utf-8", newline="")


def patch_example_file(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    text = EXAMPLE_IMPORT_RE.sub(lambda m: f'import {m.group(1)} "thirdparty:sokol/{m.group(2)}"', text)
    path.write_text(text, encoding="utf-8", newline="")


def patch_example_text(text: str) -> str:
    return EXAMPLE_IMPORT_RE.sub(lambda m: f'import {m.group(1)} "thirdparty:sokol/{m.group(2)}"', text)


def copy_package(source: Path, output: Path) -> int:
    output.mkdir(parents=True, exist_ok=True)
    count = 0
    for source_file in source.rglob("*"):
        if not source_file.is_file():
            continue
        if source_file.suffix != ".odin":
            continue
        relative = source_file.relative_to(source)
        destination = output / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        text = source_file.read_text(encoding="utf-8")
        text = patch_package_text(output, destination, text)
        write_text_if_changed(destination, text)
        count += 1
    return count


def copy_example(source_examples: Path, output_examples: Path) -> int:
    example_name = "clear"
    source = source_examples / example_name
    destination = output_examples / example_name
    destination.mkdir(parents=True, exist_ok=True)
    count = 0
    for source_file in source.rglob("*"):
        if not source_file.is_file():
            continue
        relative = source_file.relative_to(source)
        target = destination / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        if target.suffix == ".odin":
            text = patch_example_text(source_file.read_text(encoding="utf-8"))
            write_text_if_changed(target, text)
        else:
            shutil.copy2(source_file, target)
        count += 1
    return count


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("manifest")
    parser.add_argument("repo_dir")
    parser.add_argument("--os", default="windows", help=argparse.SUPPRESS)
    parser.add_argument("--arch", default="amd64", help=argparse.SUPPRESS)
    args = parser.parse_args()

    manifest_path = Path(args.manifest).resolve()
    manifest_dir = manifest_path.parent
    manifest = manifest_path.read_text(encoding="utf-8")
    repo_dir = Path(args.repo_dir).resolve()

    source_package = repo_dir / string_value(manifest, "source_package_dir")
    output_package = (manifest_dir / string_value(manifest, "odin_output_dir")).resolve()
    output_examples = (manifest_dir / string_value(manifest, "example_output_dir")).resolve()

    if not source_package.exists():
        raise FileNotFoundError(f"Missing upstream sokol package: {source_package}")

    package_count = copy_package(source_package, output_package)
    example_count = copy_example(repo_dir / "examples", output_examples)

    for license_file in string_list(manifest, "license_files"):
        source = repo_dir / license_file
        if source.exists():
            shutil.copy2(source, output_package / license_file)

    print(f"Synced sokol package into {output_package} ({package_count} Odin files)")
    print(f"Synced sokol examples into {output_examples} ({example_count} Odin files)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
