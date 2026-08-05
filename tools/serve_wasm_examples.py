#!/usr/bin/env python3
"""Serve the generated Sokol WebAssembly examples and open one in a browser."""

from __future__ import annotations

import argparse
import functools
import sys
import webbrowser
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import quote


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_DIRECTORY = ROOT / "recipes" / "sokol" / "build" / "example-wasm"


class WasmRequestHandler(SimpleHTTPRequestHandler):
    extensions_map = {
        **SimpleHTTPRequestHandler.extensions_map,
        ".js": "text/javascript",
        ".wasm": "application/wasm",
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", default=DEFAULT_DIRECTORY, type=Path)
    parser.add_argument("--example", default="clear", choices=("clear", "imgui"))
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", default=8000, type=int)
    parser.add_argument("--no-browser", action="store_true")
    args = parser.parse_args()

    if not 0 <= args.port <= 65535:
        raise SystemExit(f"Port must be between 0 and 65535: {args.port}")

    directory = args.directory.resolve()
    page = directory / f"{args.example}.html"
    if not page.is_file():
        raise SystemExit(f"Missing generated example: {page}. Build the WASM examples first.")

    handler = functools.partial(WasmRequestHandler, directory=str(directory))
    try:
        server = ThreadingHTTPServer((args.host, args.port), handler)
    except OSError as error:
        raise SystemExit(f"Could not start the example server on {args.host}:{args.port}: {error}") from error

    host, port = server.server_address[:2]
    url = f"http://{host}:{port}/{quote(page.name)}"
    print(f"[serve] Serving {directory}")
    print(f"[serve] Opening {url}")
    print("[serve] Press Ctrl+C to stop.")
    if not args.no_browser:
        webbrowser.open(url, new=2)

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n[serve] Stopped.")
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
