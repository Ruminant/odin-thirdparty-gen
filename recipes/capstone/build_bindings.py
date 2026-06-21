#!/usr/bin/env python3
"""Fetch, build, and regenerate the Capstone Odin package."""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path


RECIPE_DIR = Path(__file__).resolve().parent
ROOT = RECIPE_DIR.parents[1]
sys.path.insert(0, str(RECIPE_DIR.parent))

from common import (  # noqa: E402
    HostPlatform,
    bindgen_environment,
    build_environment,
    command_exists,
    copy_newer,
    detect_platform,
    macos_deployment_target,
    make_logger,
    resolve_bindgen,
    run,
    run_bindgen_checked,
)

BUILD_DIR = RECIPE_DIR / "build"
BINDGEN_DIR = RECIPE_DIR / "bindgen"
BINDGEN_INPUT_DIR = BINDGEN_DIR / "input"
GENERATED_DIR = RECIPE_DIR / "generated"
MANIFEST = RECIPE_DIR / "package.sjson"
ODIN_DIR = ROOT / "odin" / "capstone"


log = make_logger("capstone")


def patch_staged_headers() -> None:
    tricore_header = BINDGEN_INPUT_DIR / "tricore.h"
    if not tricore_header.exists():
        return
    text = tricore_header.read_text(encoding="utf-8")
    defines = "\n".join(
        [
            "#ifndef CS_OP_INVALID",
            "#define CS_OP_INVALID 0",
            "#define CS_OP_REG 1",
            "#define CS_OP_IMM 2",
            "#define CS_OP_MEM 3",
            "#endif",
            "",
        ]
    )
    text = text.replace('\n#include "capstone.h"\n', "\n")
    if "#define CS_OP_INVALID 0" in text:
        tricore_header.write_text(text, encoding="utf-8")
        return
    marker = "#include <stdint.h>\n#endif\n"
    if marker not in text:
        raise RuntimeError(f"Could not find include marker in {tricore_header}")
    tricore_header.write_text(text.replace(marker, marker + "\n" + defines, 1), encoding="utf-8")


def stage_headers() -> None:
    include_dir = BUILD_DIR / "_deps" / "capstone-src" / "include"
    capstone_header = include_dir / "capstone" / "capstone.h"
    if not capstone_header.exists():
        raise FileNotFoundError(f"Missing fetched Capstone headers: {include_dir}")

    log("Staging public headers for bindgen...")
    BINDGEN_INPUT_DIR.mkdir(parents=True, exist_ok=True)
    for header in sorted((include_dir / "capstone").glob("*.h")):
        shutil.copy2(header, BINDGEN_INPUT_DIR / header.name)

    windowsce_dir = include_dir / "windowsce"
    if windowsce_dir.exists():
        staged_windowsce = BINDGEN_INPUT_DIR / "windowsce"
        staged_windowsce.mkdir(parents=True, exist_ok=True)
        for header in sorted(windowsce_dir.glob("*.h")):
            shutil.copy2(header, staged_windowsce / header.name)
    patch_staged_headers()


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


def normalize_generated_bindings() -> None:
    for path in sorted(GENERATED_DIR.glob("*.odin")):
        text = path.read_text(encoding="utf-8")
        text = text.replace(":: enum u32 {", ":: enum i32 {")
        text = text.replace("BIG_ENDIAN            = 2147483648,", "BIG_ENDIAN            = -2147483648,")
        if path.name == "capstone.odin":
            text = align_mode_enum_comments(text)
        if path.name == "tricore.odin":
            text = text.replace(
                "\nOP_INVALID :: 0\nOP_REG     :: 1\nOP_IMM     :: 2\nOP_MEM     :: 3\n",
                "\n",
            )
            text = text.replace("_ :: lib\n\n\n\n/// Operand type", "_ :: lib\n\n\n/// Operand type")
        path.write_text(text, encoding="utf-8")


def align_mode_enum_comments(text: str) -> str:
    start_marker = "mode :: enum i32 {\n"
    end_marker = "\n}\n\nmalloc_t"
    start = text.find(start_marker)
    end = text.find(end_marker, start)
    if start == -1 or end == -1:
        return text

    block_start = start + len(start_marker)
    block = text[block_start:end]
    lines = block.splitlines()
    comment_prefixes = []
    for line in lines:
        if "///<" not in line:
            continue
        prefix, _ = line.split("///<", 1)
        if "=" not in prefix:
            continue
        comment_prefixes.append(prefix.rstrip())

    if not comment_prefixes:
        return text

    comment_column = max(len(prefix) for prefix in comment_prefixes) + 1
    aligned = []
    for line in lines:
        if "///<" not in line:
            aligned.append(line)
            continue
        prefix, comment = line.split("///<", 1)
        if "=" not in prefix:
            aligned.append(line)
            continue
        prefix = prefix.rstrip()
        aligned.append(f"{prefix}{' ' * (comment_column - len(prefix))}///<{comment}")

    return text[:block_start] + "\n".join(aligned) + text[end:]


def regenerate_bindings(bindgen: Path, host: HostPlatform) -> None:
    log("Regenerating Odin bindings...")
    GENERATED_DIR.mkdir(parents=True, exist_ok=True)
    run_bindgen_checked([str(bindgen), "."], cwd=BINDGEN_DIR, env=bindgen_environment(host), log=log)
    normalize_generated_bindings()
    run([sys.executable, str(ROOT / "recipes" / "sync_generated.py"), str(MANIFEST)], log=log)


def run_odin_checks(skip_checks: bool) -> None:
    if skip_checks:
        log("Skipping Odin checks.")
        return
    if not command_exists("odin"):
        log("Skipping Odin checks because odin was not found on PATH.")
        return

    collection_arg = f"-collection:thirdparty={ROOT / 'odin'}"
    log("Checking generated Odin package...")
    run(["odin", "check", str(ODIN_DIR), "-no-entry-point"], log=log)
    log("Checking example...")
    run(["odin", "check", str(ROOT / "examples" / "capstone" / "disasm_basic"), collection_arg], log=log)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", default="Release", help="CMake build config")
    parser.add_argument("--skip-bindgen", action="store_true")
    parser.add_argument("--skip-checks", action="store_true")
    args = parser.parse_args()

    host = detect_platform()
    build_env = build_environment(host)

    log("Configuring CMake...")
    configure_command = ["cmake", "-S", str(RECIPE_DIR), "-B", str(BUILD_DIR)]
    if host.os_name == "darwin":
        configure_command.append(f"-DCMAKE_OSX_DEPLOYMENT_TARGET={macos_deployment_target()}")
    run(configure_command, env=build_env, log=log)

    log(f"Building {args.config} artifacts...")
    run(["cmake", "--build", str(BUILD_DIR), "--config", args.config], env=build_env, log=log)

    stage_headers()
    stage_libraries(args.config, host)

    if args.skip_bindgen:
        log("Skipping bindgen.")
    else:
        regenerate_bindings(resolve_bindgen(host, ROOT), host)

    run_odin_checks(args.skip_checks)
    log("Done.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except subprocess.CalledProcessError as exc:
        log(f"Command failed with exit code {exc.returncode}.")
        raise SystemExit(exc.returncode)
