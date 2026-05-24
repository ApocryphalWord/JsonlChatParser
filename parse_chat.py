"""Parse a JSONL chat export into a readable markdown text file.

Usage:
    python parse_chat.py input.jsonl [output.txt]

If output is omitted, writes <input>.txt next to the source file.
Each row becomes:

    ### <sender_name>

    <message body, markdown preserved>
"""

from __future__ import annotations

import json
import sys
from pathlib import Path


def parse(input_path: Path, output_path: Path) -> tuple[int, int, int]:
    written = 0
    skipped = 0
    line_num = 0

    with input_path.open("r", encoding="utf-8") as fin, \
         output_path.open("w", encoding="utf-8", newline="\n") as fout:
        for line in fin:
            line_num += 1
            stripped = line.strip()
            if not stripped:
                continue

            try:
                obj = json.loads(stripped)
            except json.JSONDecodeError as e:
                print(f"Line {line_num}: invalid JSON, skipped ({e.msg}).", file=sys.stderr)
                skipped += 1
                continue

            name = obj.get("sender_name") or "(unknown)"
            msg = obj.get("message") or ""
            msg = msg.replace("\r\n", "\n")

            fout.write(f"### {name}\n\n{msg}\n\n")
            written += 1

    return written, skipped, line_num


def main(argv: list[str]) -> int:
    if len(argv) < 2 or argv[1] in ("-h", "--help"):
        print(__doc__)
        return 1 if len(argv) < 2 else 0

    input_path = Path(argv[1])
    if not input_path.is_file():
        print(f"Input file not found: {input_path}", file=sys.stderr)
        return 1

    output_path = Path(argv[2]) if len(argv) >= 3 else input_path.with_suffix(".txt")

    written, skipped, line_num = parse(input_path, output_path)
    print(f"Parsed {written} message(s) from {line_num} line(s); {skipped} skipped.")
    print(f"Wrote: {output_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
