#!/usr/bin/env python3
"""Generate Hugging Face JSONL records for LeanCat."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
EXPECTED_IDS = [f"{i:04d}" for i in range(1, 101)]


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8").strip()


def build_record(root: Path, problem_id: str, metadata: dict[str, Any]) -> dict[str, Any]:
    item = metadata[problem_id]
    problem_path = Path("problems") / f"{problem_id}.md"
    lean_path = Path("CAT_statement") / f"S_{problem_id}.lean"

    return {
        "problem_id": problem_id,
        "domain": item.get("domain", []),
        "level": item.get("level", ""),
        "tag": item.get("tag", []),
        "reference": item.get("reference", ""),
        "declaration": item.get("declaration", []),
        "problem_path": problem_path.as_posix(),
        "lean_path": lean_path.as_posix(),
        "natural_language_statement": read_text(root / problem_path),
        "formal_statement": read_text(root / lean_path),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "data" / "leancat_records.jsonl",
        help="Output JSONL path.",
    )
    args = parser.parse_args()

    metadata = json.loads((ROOT / "metadata.json").read_text(encoding="utf-8"))
    args.output.parent.mkdir(parents=True, exist_ok=True)

    with args.output.open("w", encoding="utf-8", newline="\n") as handle:
        for problem_id in EXPECTED_IDS:
            if problem_id not in metadata:
                raise KeyError(f"metadata.json missing problem id {problem_id}")
            record = build_record(ROOT, problem_id, metadata)
            handle.write(json.dumps(record, ensure_ascii=False) + "\n")

    print(f"Wrote {len(EXPECTED_IDS)} records to {args.output.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
