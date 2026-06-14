#!/usr/bin/env python3
"""Package local binary artifacts and update thirdparty.lock.json."""

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


def platform_lib_dir(platform_key: str) -> Path:
    try:
        os_name, arch = platform_key.split("-", 1)
    except ValueError as exc:
        raise SystemExit(f"Invalid platform key: {platform_key}") from exc
    return Path("odin") / "*" / "libs" / os_name / arch


def collect_files(platform_key: str, source_root: Path) -> list[Path]:
    patterns = [
        platform_lib_dir(platform_key) / "**" / "*",
    ]

    files: list[Path] = []
    for pattern in patterns:
        files.extend(path for path in source_root.glob(str(pattern)) if path.is_file())

    return sorted(set(files), key=lambda path: path.as_posix().lower())


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


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("platform", nargs="?", default=None, help="Artifact platform key")
    parser.add_argument("--lock", default=DEFAULT_LOCK, type=Path)
    parser.add_argument("--dist", default=DEFAULT_DIST, type=Path)
    parser.add_argument("--source-root", default=ROOT, type=Path)
    parser.add_argument("--no-update-lock", action="store_true")
    args = parser.parse_args()

    platform_key = args.platform or detect_platform()
    lock = json.loads(args.lock.read_text(encoding="utf-8"))
    artifacts = lock.setdefault("artifacts", {})
    artifact = artifacts.setdefault(
        platform_key,
        {
            "asset": f"odin-thirdparty-artifacts-{platform_key}.zip",
            "url": None,
            "sha256": None,
            "size": None,
        },
    )

    asset = artifact.get("asset") or f"odin-thirdparty-artifacts-{platform_key}.zip"
    artifact["asset"] = asset
    artifact["url"] = artifact_url(lock, "artifacts", str(asset))

    source_root = args.source_root.resolve()
    files = collect_files(platform_key, source_root)
    if not files:
        raise SystemExit(f"No files found for {platform_key}; run the recipes first.")

    args.dist.mkdir(parents=True, exist_ok=True)
    archive = args.dist / str(asset)
    print(f"[package] Writing {archive}")
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for path in files:
            arcname = path.relative_to(source_root).as_posix()
            print(f"[package]   {arcname}")
            zf.write(path, arcname)

    artifact["sha256"] = sha256_file(archive)
    artifact["size"] = archive.stat().st_size

    if not args.no_update_lock:
        args.lock.write_text(json.dumps(lock, indent=2) + "\n", encoding="utf-8")
        print(f"[package] Updated {args.lock.relative_to(ROOT)}")

    print(f"[package] sha256 {artifact['sha256']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
