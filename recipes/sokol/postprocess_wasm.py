#!/usr/bin/env python3
"""Apply Odin/Emscripten loader compatibility fixes to a linked HTML example."""

from __future__ import annotations

import sys
import shutil
from pathlib import Path


def main() -> int:
    html = Path(sys.argv[1]).resolve()
    loader = html.with_suffix(".js")

    loader_text = loader.read_text(encoding="utf-8")
    sync_needle = "function getWasmImports() {\n  // prepare imports"
    sync_replacement = """function getWasmImports() {
  // Odin grows WASM memory directly. Refresh Emscripten's ordinary typed-array
  // views before servicing the next imported JS/WebGL function.
  for (const name in wasmImports) {
    const original = wasmImports[name];
    if (typeof original === 'function') {
      wasmImports[name] = (...args) => {
        if (wasmMemory && HEAP8.buffer !== wasmMemory.buffer) updateMemoryViews();
        return original(...args);
      };
    }
  }
  // prepare imports"""
    if sync_needle in loader_text:
        loader_text = loader_text.replace(sync_needle, sync_replacement, 1)
    elif "Odin grows WASM memory directly" not in loader_text:
        raise RuntimeError(f"Could not locate Emscripten import setup in {loader}")

    import_needle = "    'env': wasmImports,\n    'wasi_snapshot_preview1': wasmImports,"
    import_replacement = (
        "    'env': wasmImports,\n"
        "    'odin_env': wasmImports,\n"
        "    'wasi_snapshot_preview1': wasmImports,"
    )
    if import_needle in loader_text:
        loader_text = loader_text.replace(import_needle, import_replacement, 1)
    elif "'odin_env': wasmImports" not in loader_text:
        raise RuntimeError(f"Could not locate Emscripten import map in {loader}")
    loader.write_text(
        loader_text,
        encoding="utf-8",
        newline="\n",
    )

    html_text = html.read_text(encoding="utf-8")
    fullscreen_css = """
html, body { width: 100%; height: 100%; margin: 0; overflow: hidden; }
body > :not(.emscripten_border):not(script) { display: none !important; }
div.emscripten_border { width: 100vw; height: 100vh; border: 0; }
canvas.emscripten { width: 100%; height: 100%; margin: 0; }
"""
    if fullscreen_css.strip() not in html_text and "</style>" in html_text:
        html_text = html_text.replace("</style>", fullscreen_css + "</style>", 1)
    elif "</style>" not in html_text:
        raise RuntimeError(f"Could not locate Emscripten stylesheet in {html}")
    html.write_text(
        html_text,
        encoding="utf-8",
        newline="\n",
    )

    if len(sys.argv) >= 4:
        destination = Path(sys.argv[2]).resolve()
        output_name = sys.argv[3]
        destination.mkdir(parents=True, exist_ok=True)
        for suffix in (".html", ".js", ".wasm"):
            source = html.with_suffix(suffix)
            shutil.copy2(source, destination / f"{output_name}{suffix}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
