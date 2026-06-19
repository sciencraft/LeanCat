#!/usr/bin/env python3
"""Run a LeanBridge-style retrieve-generate-verify loop on LeanCat."""

from __future__ import annotations

import argparse
import asyncio
import json
import os
import re
import subprocess
import sys
import traceback
from typing import Any

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


SEARCH_RE = re.compile(r"\[SEARCH:\s*(.*?)\]", flags=re.DOTALL)
LOCAL_SEARCH_SERVICE: Any | None = None


def get_local_search_service() -> Any:
    global LOCAL_SEARCH_SERVICE
    if LOCAL_SEARCH_SERVICE is not None:
        return LOCAL_SEARCH_SERVICE

    try:
        from lean_explore.search import Service
    except ImportError as exc:
        raise RuntimeError(
            "lean-explore local backend is not importable in this Python environment. "
            "Install it with `pip install lean-explore[local]` and run `lean-explore data fetch`, "
            "or use `--search-backend none` / `--search-backend command`."
        ) from exc

    try:
        log("initializing LeanExplore local Service")
        LOCAL_SEARCH_SERVICE = Service()
        log("LeanExplore local Service initialized")
    except FileNotFoundError as exc:
        raise RuntimeError(
            "LeanExplore local data files were not found. Run `lean-explore data fetch` "
            "in the same Python environment before using `--search-backend local`, "
            "or use `--search-backend none`."
        ) from exc
    return LOCAL_SEARCH_SERVICE


def close_local_search_service() -> None:
    global LOCAL_SEARCH_SERVICE
    service = LOCAL_SEARCH_SERVICE
    LOCAL_SEARCH_SERVICE = None
    if service is None:
        return

    for method_name in ("close", "shutdown"):
        method = getattr(service, method_name, None)
        if callable(method):
            log(f"closing LeanExplore local Service via {method_name}()")
            result = method()
            if asyncio.iscoroutine(result):
                asyncio.run(result)
            return
    log("LeanExplore local Service has no close/shutdown method; releasing reference")


def _field(item: Any, name: str, default: str = "") -> str:
    value = getattr(item, name, None)
    if value is None and isinstance(item, dict):
        value = item.get(name)
    if value is None:
        return default
    return str(value)


def format_search_results(results: list[Any]) -> str:
    blocks = []
    for index, item in enumerate(results, start=1):
        name = _field(item, "name") or _field(item, "title") or _field(item, "id", "unknown")
        module = _field(item, "module") or _field(item, "source_file")
        docstring = _field(item, "docstring")
        informal = _field(item, "informalization") or _field(item, "description") or _field(item, "informal_description")
        source = _field(item, "source_text") or _field(item, "statement")
        parts = [f"[{index}] {name}"]
        if module:
            parts.append(f"Module: {module}")
        if docstring:
            parts.append(f"Docstring: {docstring}")
        if informal:
            parts.append(f"Description: {informal}")
        if source:
            parts.append(f"Lean source:\n{source}")
        blocks.append("\n".join(parts))
    return "\n\n".join(blocks)


async def search_local(query: str, args: argparse.Namespace) -> str:
    service = get_local_search_service()
    log(
        f"LeanExplore local search query_chars={len(query)} "
        f"limit={args.search_limit} rerank_top={args.rerank_top}"
    )
    response = await service.search(
        query=query,
        limit=args.search_limit,
        rerank_top=args.rerank_top,
        packages=args.search_packages or None,
    )
    log(f"LeanExplore local search returned {len(response.results)} result(s)")
    return format_search_results(list(response.results))


async def search_api(query: str, args: argparse.Namespace) -> str:
    try:
        from lean_explore.api import ApiClient
    except ImportError as exc:
        raise RuntimeError(
            "lean-explore API client is not importable in this Python environment. "
            "Install it with `pip install lean-explore`, or use local mode."
        ) from exc

    client = ApiClient(api_key=args.leanexplore_api_key, timeout=args.search_timeout)
    log(f"LeanExplore API search query_chars={len(query)} limit={args.search_limit}")
    response = await client.search(
        query=query,
        limit=args.search_limit,
        rerank_top=args.rerank_top,
        packages=args.search_packages or None,
    )
    log(f"LeanExplore API search returned {len(response.results)} result(s)")
    return format_search_results(list(response.results))


def search_command(query: str, args: argparse.Namespace) -> str:
    """Run an optional external retrieval command.

    The command receives the query on stdin and should print retrieval context on
    stdout.
    """

    if not args.search_command:
        return ""

    log(f"running search command query_chars={len(query)}")
    try:
        result = subprocess.run(
            args.search_command,
            input=query,
            text=True,
            encoding="utf-8",
            capture_output=True,
            shell=True,
            timeout=args.search_timeout,
            cwd=ROOT,
        )
    except subprocess.TimeoutExpired:
        log(f"search command timed out after {args.search_timeout} seconds")
        return f"[search timed out after {args.search_timeout} seconds]"

    if result.returncode != 0:
        log(f"search command failed exit_code={result.returncode}")
        return (result.stderr or result.stdout or "").strip()
    log(f"search command returned chars={len(result.stdout)}")
    return result.stdout.strip()


def run_search(query: str, args: argparse.Namespace) -> str:
    if args.search_backend == "none":
        log("search skipped: backend=none")
        return ""
    if args.search_backend == "command":
        return search_command(query, args)
    if args.search_backend == "api":
        return asyncio.run(search_api(query, args))
    return asyncio.run(search_local(query, args))


def initial_search_context(nl_statement: str, formal_statement: str, args: argparse.Namespace) -> tuple[str, list[dict]]:
    if args.search_backend == "none":
        return "", []

    query = nl_statement if args.input_mode != "formal" else formal_statement
    context = run_search(query, args)
    return context, [{"query": query, "context": context, "source": "initial"}]


def call_llm(args: argparse.Namespace, prompt: str) -> str:
    return chat_completion(
        prompt=prompt,
        model=args.model,
        temperature=args.temperature,
        max_tokens=args.max_tokens,
        base_url=args.base_url,
        api_key=args.api_key,
    )


def run_problem(args: argparse.Namespace, problem_id: str, generate_template: str, refine_template: str) -> dict:
    nl_statement, formal_statement = load_problem(problem_id)
    log(f"leanbridge problem {problem_id}: loaded inputs mode={args.input_mode}")
    problem_dir = args.output_dir / "leanbridge" / args.model / problem_id
    result_path = problem_dir / "result.json"
    if args.resume and result_path.exists():
        print(f"[{problem_id}] result exists, skipping")
        return {}

    if args.input_mode == "formal":
        nl_input = ""
        formal_input = formal_statement
    elif args.input_mode == "nl":
        nl_input = nl_statement
        formal_input = ""
    else:
        nl_input = nl_statement
        formal_input = formal_statement

    search_context, searches = initial_search_context(nl_input or nl_statement, formal_input or formal_statement, args)
    if search_context:
        log(f"leanbridge problem {problem_id}: initial search context chars={len(search_context)}")
    attempts = []
    current_candidate = ""
    last_error = ""
    solved = False

    for iteration in range(1, args.max_iterations + 1):
        log(f"leanbridge problem {problem_id}: iteration {iteration}/{args.max_iterations} started")
        started_at = now_seconds()
        if iteration == 1:
            prompt = render_prompt(
                generate_template,
                nl_statement=nl_input,
                formal_statement=formal_input,
                search_contents=search_context,
            )
        else:
            prompt = render_prompt(
                refine_template,
                original_proof=current_candidate,
                error_messages=last_error,
            )

        log(f"leanbridge problem {problem_id}: prompt chars={len(prompt)}")
        raw_response = call_llm(args, prompt)
        search_match = SEARCH_RE.search(raw_response)
        if search_match and iteration < args.max_iterations:
            query = search_match.group(1).strip()
            log(f"leanbridge problem {problem_id}: model requested search `{query[:120]}`")
            context = run_search(query, args)
            searches.append({"query": query, "context": context, "source": f"iteration_{iteration}"})
            last_error = "\n\n".join(
                part
                for part in [
                    last_error,
                    f"Additional Mathlib search results for query '{query}':\n{context}",
                ]
                if part
            )
            attempts.append(
                {
                    "iteration": iteration,
                    "kind": "search",
                    "query": query,
                    "context": context,
                    "raw_response": raw_response,
                }
            )
            print(f"[{problem_id}] iteration {iteration}: search requested")
            continue

        current_candidate = extract_lean_code(raw_response)
        log(f"leanbridge problem {problem_id}: verifying candidate chars={len(current_candidate)}")
        ok, verifier_output = verify_lean(current_candidate, timeout=args.timeout)
        elapsed_seconds = now_seconds() - started_at
        lean_path = problem_dir / f"iteration_{iteration}.lean"
        lean_path.parent.mkdir(parents=True, exist_ok=True)
        lean_path.write_text(current_candidate, encoding="utf-8")

        attempt = {
            "iteration": iteration,
            "kind": "proof",
            "ok": ok,
            "elapsed_seconds": elapsed_seconds,
            "prompt": prompt,
            "raw_response": raw_response,
            "candidate_path": str(lean_path.relative_to(ROOT)),
            "verifier_output": verifier_output,
        }
        attempts.append(attempt)
        print(f"[{problem_id}] iteration {iteration}/{args.max_iterations}: {'ok' if ok else 'failed'}")
        if ok:
            solved = True
            break
        last_error = verifier_output

    result = {
        "problem_id": problem_id,
        "model": args.model,
        "input_mode": args.input_mode,
        "solved": solved,
        "max_iterations": args.max_iterations,
        "search_backend": args.search_backend,
        "search_command": args.search_command,
        "searches": searches,
        "attempts": attempts,
        "natural_language_statement": nl_statement,
        "formal_statement": formal_statement,
    }
    write_json(result_path, result)
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    add_common_args(parser)
    parser.add_argument("--max-iterations", type=int, default=4)
    parser.add_argument("--input-mode", choices=["nl", "formal", "nl+formal"], default="nl+formal")
    parser.add_argument(
        "--search-backend",
        choices=["local", "api", "command", "none"],
        default="local",
        help="LeanExplore retrieval backend. Default is local because the hosted API may be unavailable.",
    )
    parser.add_argument("--search-limit", type=int, default=3)
    parser.add_argument("--rerank-top", type=int, default=25)
    parser.add_argument(
        "--search-packages",
        nargs="*",
        default=["Mathlib"],
        help="LeanExplore package filters, e.g. Mathlib Std. Use no values to disable filtering.",
    )
    parser.add_argument("--leanexplore-api-key", default=None)
    parser.add_argument(
        "--search-command",
        default="",
        help="Used only with --search-backend command. Reads query from stdin and writes context to stdout.",
    )
    parser.add_argument("--search-timeout", type=int, default=60)
    args = parser.parse_args()

    log(
        f"starting leanbridge start={args.start} end={args.end} model={args.model} "
        f"input_mode={args.input_mode} search_backend={args.search_backend} "
        f"max_iterations={args.max_iterations} output_dir={args.output_dir}"
    )
    generate_template = load_prompt("prompts/leanbridge_generate.md")
    refine_template = load_prompt("prompts/leanbridge_refine.md")
    results = []
    for problem_id in problem_ids(args.start, args.end):
        result = run_problem(args, problem_id, generate_template, refine_template)
        if result:
            results.append(result)

    solved = sum(1 for item in results if item.get("solved"))
    summary = {
        "mode": "leanbridge",
        "model": args.model,
        "input_mode": args.input_mode,
        "max_iterations": args.max_iterations,
        "search_backend": args.search_backend,
        "start": args.start,
        "end": args.end,
        "solved": solved,
        "total": len(results),
    }
    summary_path = args.output_dir / "leanbridge" / args.model / "summary.json"
    write_json(summary_path, summary)
    print(f"Summary: {solved}/{len(results)} solved")
    return 0


if __name__ == "__main__":
    if any(arg in {"-h", "--help"} for arg in sys.argv[1:]):
        raise SystemExit(main())

    exit_code = 1
    try:
        exit_code = main()
    except SystemExit as exc:
        exit_code = int(exc.code) if isinstance(exc.code, int) else 1
    except KeyboardInterrupt:
        log("interrupted by user")
        exit_code = 130
    except Exception:
        log("fatal error")
        traceback.print_exc()
        exit_code = 1
    finally:
        close_local_search_service()
        os._exit(exit_code)
