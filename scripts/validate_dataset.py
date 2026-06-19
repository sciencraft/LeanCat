#!/usr/bin/env python3
"""Validate the LeanCat artifact structure.

This script performs lightweight checks that are useful before creating an
anonymous code release or submitting a dataset artifact for review.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EXPECTED_IDS = [f"{i:04d}" for i in range(1, 101)]
EXPECTED_LEVEL_COUNTS = {"Easy": 20, "Medium": 40, "High": 40}

def fail(errors: list[str], message: str) -> None:
    errors.append(message)


def warn(warnings: list[str], message: str) -> None:
    warnings.append(message)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def check_expected_files(errors: list[str]) -> None:
    for problem_id in EXPECTED_IDS:
        lean_path = ROOT / "CAT_statement" / f"S_{problem_id}.lean"
        md_path = ROOT / "problems" / f"{problem_id}.md"
        if not lean_path.is_file():
            fail(errors, f"missing Lean statement: {lean_path.relative_to(ROOT)}")
        if not md_path.is_file():
            fail(errors, f"missing natural-language problem: {md_path.relative_to(ROOT)}")

    lean_files = sorted((ROOT / "CAT_statement").glob("S_*.lean"))
    md_files = sorted((ROOT / "problems").glob("*.md"))
    if len(lean_files) != 100:
        fail(errors, f"expected 100 Lean statement files, found {len(lean_files)}")
    if len(md_files) != 100:
        fail(errors, f"expected 100 problem Markdown files, found {len(md_files)}")


def check_metadata(errors: list[str], warnings: list[str]) -> None:
    metadata_path = ROOT / "metadata.json"
    if not metadata_path.is_file():
        fail(errors, "missing metadata.json")
        return

    raw = read_text(metadata_path)

    try:
        metadata = json.loads(raw)
    except json.JSONDecodeError as exc:
        fail(errors, f"metadata.json is invalid JSON: {exc}")
        return

    keys = sorted(metadata.keys())
    if keys != EXPECTED_IDS:
        fail(errors, "metadata keys do not match expected ids 0001..0100")

    level_counts: dict[str, int] = {}
    empty_declarations = 0
    for problem_id in EXPECTED_IDS:
        item = metadata.get(problem_id)
        if not isinstance(item, dict):
            fail(errors, f"metadata entry {problem_id} is missing or not an object")
            continue

        for field in ["domain", "level", "tag", "reference", "declaration"]:
            if field not in item:
                fail(errors, f"metadata entry {problem_id} missing field {field}")

        level = item.get("level")
        if isinstance(level, str):
            level_counts[level] = level_counts.get(level, 0) + 1
        else:
            fail(errors, f"metadata entry {problem_id} has non-string level")

        if item.get("declaration") == []:
            empty_declarations += 1

    if level_counts != EXPECTED_LEVEL_COUNTS:
        fail(errors, f"difficulty counts mismatch: {level_counts}")
    if empty_declarations:
        warn(warnings, f"{empty_declarations} metadata entries have empty declaration lists")


def check_import_aggregator(errors: list[str]) -> None:
    aggregator = ROOT / "CAT_statement.lean"
    if not aggregator.is_file():
        fail(errors, "missing CAT_statement.lean")
        return

    contents = read_text(aggregator)
    for problem_id in EXPECTED_IDS:
        expected_import = f"import CAT_statement.S_{problem_id}"
        if expected_import not in contents:
            fail(errors, f"CAT_statement.lean missing import for S_{problem_id}")


def check_lean_statement_shape(errors: list[str]) -> None:
    declaration_re = re.compile(r"\b(theorem|lemma|example)\b")
    for problem_id in EXPECTED_IDS:
        lean_path = ROOT / "CAT_statement" / f"S_{problem_id}.lean"
        if not lean_path.is_file():
            continue
        contents = read_text(lean_path)
        if "sorry" not in contents:
            fail(errors, f"{lean_path.relative_to(ROOT)} contains no sorry placeholder")
        if not declaration_re.search(contents):
            fail(errors, f"{lean_path.relative_to(ROOT)} contains no theorem/lemma/example")


def check_anonymization(errors: list[str]) -> None:
    if list(ROOT.glob("*.pdf")):
        fail(errors, "root-level PDF files are not included in the anonymized artifact")


def main() -> int:
    errors: list[str] = []
    warnings: list[str] = []

    check_expected_files(errors)
    check_metadata(errors, warnings)
    check_import_aggregator(errors)
    check_lean_statement_shape(errors)
    check_anonymization(errors)

    for message in warnings:
        print(f"WARNING: {message}")
    for message in errors:
        print(f"ERROR: {message}")

    if errors:
        print(f"Validation failed with {len(errors)} error(s) and {len(warnings)} warning(s).")
        return 1

    print(f"Validation passed with {len(warnings)} warning(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
