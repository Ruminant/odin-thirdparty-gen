#!/usr/bin/env python3
"""Install release artifacts needed by the Odin thirdparty collection."""

from __future__ import annotations

import argparse
import hashlib
import json
import platform
import sys
import urllib.request
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_LOCK = ROOT / "thirdparty.lock.json"
DEFAULT_CACHE = ROOT / ".thirdparty-cache"
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


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def verify_sha256(path: Path, expected: str | None) -> None:
    if not expected:
        raise SystemExit(
            f"{path.name} has no sha256 in {DEFAULT_LOCK.name}. "
            "Run the matching package script after building the artifact."
        )

    actual = sha256_file(path)
    if actual.lower() != expected.lower():
        raise SystemExit(
            f"SHA256 mismatch for {path}:\n"
            f"  expected {expected}\n"
            f"  actual   {actual}"
        )


def download(url: str, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    print(f"[bootstrap] Downloading {url}")
    with urllib.request.urlopen(url) as response:
        with destination.open("wb") as output:
            while True:
                chunk = response.read(1024 * 1024)
                if not chunk:
                    break
                output.write(chunk)


def choose_archive(args: argparse.Namespace, artifact: dict[str, object]) -> Path:
    if args.archive:
        archive = Path(args.archive).resolve()
        if not archive.exists():
            raise SystemExit(f"Archive does not exist: {archive}")
        return archive

    asset = str(artifact["asset"])
    dist_archive = DEFAULT_DIST / asset
    if dist_archive.exists():
        print(f"[bootstrap] Using local dist artifact: {dist_archive}")
        return dist_archive

    cache_archive = Path(args.cache_dir).resolve() / asset
    expected_sha = artifact.get("sha256")
    if cache_archive.exists():
        if expected_sha and sha256_file(cache_archive) == str(expected_sha).lower():
            print(f"[bootstrap] Reusing cached artifact: {cache_archive}")
            return cache_archive
        print(f"[bootstrap] Cached artifact is stale: {cache_archive}")

    url = artifact.get("url")
    if not url:
        raise SystemExit(f"No URL configured for {asset}")
    download(str(url), cache_archive)
    return cache_archive


def safe_extract_zip(archive: Path, destination: Path) -> None:
    root = destination.resolve()
    with zipfile.ZipFile(archive) as zf:
        for member in zf.infolist():
            target = (root / member.filename).resolve()
            if target != root and root not in target.parents:
                raise SystemExit(f"Archive member escapes repository root: {member.filename}")
            if member.is_dir():
                target.mkdir(parents=True, exist_ok=True)
                continue
            target.parent.mkdir(parents=True, exist_ok=True)
            with zf.open(member) as source, target.open("wb") as output:
                output.write(source.read())


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--platform", default=None, help="Artifact platform key, e.g. windows-amd64")
    parser.add_argument("--kind", default="artifacts", choices=("artifacts", "tools"))
    parser.add_argument("--lock", default=DEFAULT_LOCK, type=Path)
    parser.add_argument("--archive", default=None, help="Use a local artifact zip instead of downloading")
    parser.add_argument("--cache-dir", default=DEFAULT_CACHE, type=Path)
    args = parser.parse_args()

    platform_key = args.platform or detect_platform()
    lock = json.loads(args.lock.read_text(encoding="utf-8"))
    artifact = lock.get(args.kind, {}).get(platform_key)
    if not artifact:
        known = ", ".join(sorted(lock.get(args.kind, {}).keys())) or "(none)"
        raise SystemExit(f"No {args.kind} entry configured for {platform_key}. Known entries: {known}")

    archive = choose_archive(args, artifact)
    verify_sha256(archive, artifact.get("sha256"))
    print(f"[bootstrap] Extracting {archive.name}")
    safe_extract_zip(archive, ROOT)
    print(f"[bootstrap] Installed {args.kind} for {platform_key}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
