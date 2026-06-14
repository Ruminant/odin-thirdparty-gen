from __future__ import annotations

import re
import shutil
import sys
from pathlib import Path


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


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: sync_generated.py <package.sjson>", file=sys.stderr)
        return 2

    manifest_path = Path(sys.argv[1]).resolve()
    manifest_dir = manifest_path.parent
    manifest = manifest_path.read_text(encoding="utf-8")

    output_dir = (manifest_dir / string_value(manifest, "odin_output_dir")).resolve()
    generated_dir = (manifest_dir / string_value(manifest, "generated_dir")).resolve()
    handwritten = set(string_list(manifest, "handwritten"))

    if not generated_dir.exists():
        raise FileNotFoundError(f"Generated directory does not exist: {generated_dir}")

    generated_files = sorted(generated_dir.glob("*.odin"))
    if not generated_files:
        raise RuntimeError(f"No generated Odin files found in {generated_dir}")

    output_dir.mkdir(parents=True, exist_ok=True)

    for filename in sorted(handwritten):
        handwritten_path = output_dir / filename
        if not handwritten_path.exists():
            raise FileNotFoundError(f"Handwritten Odin file listed in manifest is missing: {handwritten_path}")

    generated_names = {path.name for path in generated_files}

    for old_file in output_dir.glob("*.odin"):
        if old_file.name in handwritten or old_file.name in generated_names:
            continue
        old_file.unlink()

    copied = 0
    unchanged = 0
    for generated_file in generated_files:
        destination = output_dir / generated_file.name
        if destination.exists() and destination.read_bytes() == generated_file.read_bytes():
            unchanged += 1
            continue
        if destination.exists():
            destination.unlink()
        shutil.copy2(generated_file, destination)
        copied += 1

    print(f"Synced {len(generated_files)} generated Odin files into {output_dir} ({copied} copied, {unchanged} unchanged)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
