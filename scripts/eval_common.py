#!/usr/bin/env python3
"""Shared helpers for LeanCat evaluation scripts."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import tempfile
import time
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MODEL = os.getenv("LEANCAT_MODEL", os.getenv("OPENAI_MODEL", "gpt-5.2"))
DEFAULT_BASE_URL = os.getenv("OPENAI_BASE_URL", "https://api.openai.com/v1")
INVALID_TOKEN_RE = re.compile(r"\b(sorry|admit|axiom|unsafe)\b")
MAX_LOG_OUTPUT_CHARS = 4000


def log(message: str) -> None:
    print(f"[LeanCat] {message}", flush=True)


def log_block(title: str, text: str, max_chars: int = MAX_LOG_OUTPUT_CHARS) -> None:
    if not text:
        return
    display = text if len(text) <= max_chars else text[:max_chars] + "\n...[truncated]"
    print(f"[LeanCat] {title}:\n{display}", flush=True)


def problem_ids(start: int, end: int) -> list[str]:
    if start < 1 or end < start or end > 100:
        raise ValueError("--start and --end must define a range within 1..100")
    return [f"{i:04d}" for i in range(start, end + 1)]


def load_problem(problem_id: str) -> tuple[str, str]:
    lean_path = ROOT / "CAT_statement" / f"S_{problem_id}.lean"
    md_path = ROOT / "problems" / f"{problem_id}.md"
    return (
        md_path.read_text(encoding="utf-8"),
        lean_path.read_text(encoding="utf-8"),
    )


def load_prompt(relative_path: str) -> str:
    return (ROOT / relative_path).read_text(encoding="utf-8").strip()


def render_prompt(template: str, **values: str) -> str:
    return template.format(**values)


def extract_lean_code(text: str) -> str:
    fenced = re.findall(r"```(?:lean4?|Lean4?)?\s*\n(.*?)```", text, flags=re.DOTALL)
    if fenced:
        return fenced[-1].strip()
    return text.strip()


def has_invalid_tokens(code: str) -> bool:
    return INVALID_TOKEN_RE.search(code) is not None


def verify_lean(code: str, timeout: int) -> tuple[bool, str]:
    if has_invalid_tokens(code):
        log("Lean verification skipped: forbidden token found")
        return False, "Candidate contains forbidden tokens: sorry/admit/axiom/unsafe."

    temp_dir = ROOT / ".lake" / "leancat_eval"
    temp_dir.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        mode="w",
        suffix=".lean",
        prefix="attempt_",
        dir=temp_dir,
        delete=False,
        encoding="utf-8",
    ) as handle:
        handle.write(code)
        temp_path = Path(handle.name)

    try:
        relative = temp_path.relative_to(ROOT)
        log(f"running Lean verifier on {relative}")
        result = subprocess.run(
            ["lake", "env", "lean", str(relative)],
            cwd=ROOT,
            text=True,
            encoding="utf-8",
            capture_output=True,
            timeout=timeout,
        )
        output = (result.stdout or "") + (result.stderr or "")
        log(f"Lean verifier finished with exit code {result.returncode}")
        if result.returncode != 0:
            log_block("Lean verifier output", output.strip())
        return result.returncode == 0, output.strip()
    except subprocess.TimeoutExpired:
        log(f"Lean verifier timed out after {timeout} seconds")
        return False, f"Lean verification timed out after {timeout} seconds."
    finally:
        try:
            temp_path.unlink()
        except OSError:
            pass


def chat_completion(
    prompt: str,
    model: str,
    temperature: float,
    max_tokens: int,
    base_url: str,
    api_key: str | None,
) -> str:
    if not api_key:
        raise RuntimeError("Set OPENAI_API_KEY or pass --api-key.")

    url = base_url.rstrip("/") + "/chat/completions"
    log(f"calling LLM model={model} base_url={base_url.rstrip('/')} prompt_chars={len(prompt)}")
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": temperature,
        "max_tokens": max_tokens,
    }
    data = json.dumps(payload).encode("utf-8")
    request = urllib.request.Request(
        url,
        data=data,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=600) as response:
            body = response.read().decode("utf-8")
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"LLM request failed: HTTP {exc.code}: {detail}") from exc

    parsed: dict[str, Any] = json.loads(body)
    content = parsed["choices"][0]["message"]["content"]
    log(f"LLM response received chars={len(content)}")
    return content


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def add_common_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--start", type=int, default=1, help="First problem id, 1-indexed.")
    parser.add_argument("--end", type=int, default=100, help="Last problem id, inclusive.")
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--temperature", type=float, default=1.0)
    parser.add_argument("--max-tokens", type=int, default=50000)
    parser.add_argument("--timeout", type=int, default=300, help="Lean timeout per attempt.")
    parser.add_argument("--base-url", default=DEFAULT_BASE_URL)
    parser.add_argument("--api-key", default=os.getenv("OPENAI_API_KEY"))
    parser.add_argument("--output-dir", type=Path, default=ROOT / "results")
    parser.add_argument("--resume", action="store_true", help="Skip attempts already on disk.")


def now_seconds() -> float:
    return time.time()
