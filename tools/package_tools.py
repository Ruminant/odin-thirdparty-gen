#!/usr/bin/env python3
"""Package local bindgen tooling and update thirdparty.lock.json."""

from __future__ import annotations

import argparse
import hashlib
import json
import platform
import sys
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_LOCK = ROOT / "thirdparty.lock.json"
DEFAULT_DIST = ROOT / "dist"


def detect_platform() -> str:
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
    return f"{os_name}-{arch}"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def release_for_kind(lock: dict[str, object], kind: str) -> dict[str, str]:
    return lock.get("releases", {}).get(kind, lock["release"])


def artifact_url(lock: dict[str, object], kind: str, asset: str) -> str:
    release = release_for_kind(lock, kind)
    return (
        f"https://github.com/{release['owner']}/{release['repo']}"
        f"/releases/download/{release['tag']}/{asset}"
    )


def staged_name(platform_key: str, path: Path) -> Path:
    return Path(".thirdparty-tools") / "bindgen" / platform_key / path.name


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("bindgen", type=Path, help="Path to bindgen executable")
    parser.add_argument("--libclang", default="", help="Optional path to libclang.dll")
    parser.add_argument("--platform", default=None, help="Tool platform key")
    parser.add_argument("--lock", default=DEFAULT_LOCK, type=Path)
    parser.add_argument("--dist", default=DEFAULT_DIST, type=Path)
    parser.add_argument("--no-update-lock", action="store_true")
    args = parser.parse_args()

    platform_key = args.platform or detect_platform()
    bindgen = args.bindgen.resolve()
    if not bindgen.is_file():
        raise SystemExit(f"bindgen executable does not exist: {bindgen}")

    files = [(bindgen, staged_name(platform_key, bindgen))]

    libclang = args.libclang
    if libclang:
        libclang = Path(libclang).resolve()
    elif platform_key.startswith("windows-"):
        candidate = bindgen.parent / "libclang.dll"
        libclang = candidate if candidate.exists() else None

    if libclang:
        if not libclang.is_file():
            raise SystemExit(f"libclang does not exist: {libclang}")
        files.append((libclang, staged_name(platform_key, libclang)))
    elif platform_key.startswith("windows-"):
        print("[package-tools] Warning: libclang.dll was not provided or found next to bindgen.")

    lock = json.loads(args.lock.read_text(encoding="utf-8"))
    tools = lock.setdefault("tools", {})
    tool = tools.setdefault(
        platform_key,
        {
            "asset": f"odin-thirdparty-tools-{platform_key}.zip",
            "url": None,
            "sha256": None,
            "size": None,
        },
    )
    asset = tool.get("asset") or f"odin-thirdparty-tools-{platform_key}.zip"
    tool["asset"] = asset
    tool["url"] = artifact_url(lock, "tools", str(asset))

    args.dist.mkdir(parents=True, exist_ok=True)
    archive = args.dist / str(asset)
    print(f"[package-tools] Writing {archive}")
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for source, arcname in files:
            print(f"[package-tools]   {arcname.as_posix()}")
            zf.write(source, arcname.as_posix())

    tool["sha256"] = sha256_file(archive)
    tool["size"] = archive.stat().st_size

    if not args.no_update_lock:
        args.lock.write_text(json.dumps(lock, indent=2) + "\n", encoding="utf-8")
        print(f"[package-tools] Updated {args.lock.relative_to(ROOT)}")

    print(f"[package-tools] sha256 {tool['sha256']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
