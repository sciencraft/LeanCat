#!/usr/bin/env python3
"""Run static pass@k evaluation on LeanCat."""

from __future__ import annotations

import argparse
from pathlib import Path

from eval_common import (
    ROOT,
    add_common_args,
    chat_completion,
    extract_lean_code,
    load_problem,
    load_prompt,
    log,
    now_seconds,
    problem_ids,
    render_prompt,
    verify_lean,
    write_json,
)


def run_problem(args: argparse.Namespace, problem_id: str, template: str) -> dict:
    nl_statement, formal_statement = load_problem(problem_id)
    log(f"pass@k problem {problem_id}: loaded inputs")
    problem_dir = args.output_dir / "passk" / args.model / problem_id
    result_path = problem_dir / "result.json"
    if args.resume and result_path.exists():
        print(f"[{problem_id}] result exists, skipping")
        return {}

    attempts = []
    solved = False
    for attempt_index in range(1, args.k + 1):
        log(f"pass@k problem {problem_id}: attempt {attempt_index}/{args.k} started")
        attempt_path = problem_dir / f"attempt_{attempt_index}.json"
        lean_path = problem_dir / f"attempt_{attempt_index}.lean"
        if args.resume and attempt_path.exists():
            continue

        prompt = render_prompt(template, formal_statement=formal_statement)
        started_at = now_seconds()
        raw_response = chat_completion(
            prompt=prompt,
            model=args.model,
            temperature=args.temperature,
            max_tokens=args.max_tokens,
            base_url=args.base_url,
            api_key=args.api_key,
        )
        log(f"pass@k problem {problem_id}: extracting Lean candidate")
        candidate = extract_lean_code(raw_response)
        log(f"pass@k problem {problem_id}: verifying candidate chars={len(candidate)}")
        ok, verifier_output = verify_lean(candidate, timeout=args.timeout)
        elapsed_seconds = now_seconds() - started_at

        lean_path.parent.mkdir(parents=True, exist_ok=True)
        lean_path.write_text(candidate, encoding="utf-8")
        attempt = {
            "problem_id": problem_id,
            "attempt": attempt_index,
            "model": args.model,
            "temperature": args.temperature,
            "ok": ok,
            "elapsed_seconds": elapsed_seconds,
            "prompt": prompt,
            "raw_response": raw_response,
            "candidate_path": str(lean_path.relative_to(ROOT)),
            "verifier_output": verifier_output,
        }
        write_json(attempt_path, attempt)
        attempts.append(attempt)
        print(f"[{problem_id}] attempt {attempt_index}/{args.k}: {'ok' if ok else 'failed'}")
        if ok:
            solved = True
            if args.stop_on_success:
                break

    result = {
        "problem_id": problem_id,
        "model": args.model,
        "k": args.k,
        "solved": solved,
        "attempts": [
            {
                "attempt": item["attempt"],
                "ok": item["ok"],
                "elapsed_seconds": item["elapsed_seconds"],
                "candidate_path": item["candidate_path"],
            }
            for item in attempts
        ],
        "natural_language_statement": nl_statement,
        "formal_statement": formal_statement,
    }
    write_json(result_path, result)
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    add_common_args(parser)
    parser.add_argument("-k", "--k", type=int, default=4, help="Number of samples per problem.")
    parser.add_argument("--stop-on-success", action="store_true")
    args = parser.parse_args()

    log(
        f"starting pass@k start={args.start} end={args.end} model={args.model} "
        f"k={args.k} output_dir={args.output_dir}"
    )
    template = load_prompt("prompts/static_passk.md")
    results = []
    for problem_id in problem_ids(args.start, args.end):
        result = run_problem(args, problem_id, template)
        if result:
            results.append(result)

    solved = sum(1 for item in results if item.get("solved"))
    summary = {
        "mode": "static_passk",
        "model": args.model,
        "k": args.k,
        "start": args.start,
        "end": args.end,
        "solved": solved,
        "total": len(results),
    }
    summary_path = args.output_dir / "passk" / args.model / "summary.json"
    write_json(summary_path, summary)
    print(f"Summary: {solved}/{len(results)} solved")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
