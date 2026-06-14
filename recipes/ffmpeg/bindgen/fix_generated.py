from __future__ import annotations

import argparse
from pathlib import Path


DECLARATIONS_TO_REMOVE = [
    ("log.odin", "AVOptionRanges"),
    ("log.odin", "AVOption"),
    ("channel_layout.odin", "AVBPrint"),
    ("avio.odin", "AVBPrint"),
    ("frame.odin", "AVFrame"),
    ("avformat.odin", "AVCodecParserContext"),
    ("avformat.odin", "AVBPrint"),
    ("packet.odin", "AVFrameSideData"),
    ("codec_desc.odin", "AVProfile"),
]


def code_without_comments(line: str, in_block_comment: bool) -> tuple[str, bool]:
    code = []
    i = 0

    while i < len(line):
        if in_block_comment:
            end = line.find("*/", i)
            if end == -1:
                return "".join(code), True
            i = end + 2
            in_block_comment = False
            continue

        block_start = line.find("/*", i)
        line_start = line.find("//", i)

        if line_start != -1 and (block_start == -1 or line_start < block_start):
            code.append(line[i:line_start])
            return "".join(code), False

        if block_start == -1:
            code.append(line[i:])
            return "".join(code), False

        code.append(line[i:block_start])
        i = block_start + 2
        in_block_comment = True

    return "".join(code), in_block_comment


def declaration_end(lines: list[str], start: int) -> int:
    brace_depth = 0
    saw_brace = False
    in_block_comment = False

    for index in range(start, len(lines)):
        code, in_block_comment = code_without_comments(lines[index], in_block_comment)

        for char in code:
            if char == "{":
                brace_depth += 1
                saw_brace = True
            elif char == "}":
                brace_depth -= 1

        if not saw_brace or brace_depth <= 0:
            return index

    return start


def remove_declaration(path: Path, name: str) -> bool:
    if not path.exists():
        return False

    lines = path.read_text().splitlines()
    prefix = f"{name} ::"

    for start, line in enumerate(lines):
        if not line.startswith(prefix):
            continue

        end = declaration_end(lines, start)
        del lines[start : end + 1]
        path.write_text("\n".join(lines) + "\n")
        return True

    return False


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Remove duplicate declarations from generated FFmpeg Odin bindings.",
    )
    parser.add_argument(
        "odin_dir",
        nargs="?",
        default="../generated",
        type=Path,
        help="Generated Odin bindings directory.",
    )
    args = parser.parse_args()

    odin_dir = args.odin_dir.resolve()
    for filename, declaration in DECLARATIONS_TO_REMOVE:
        remove_declaration(odin_dir / filename, declaration)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
