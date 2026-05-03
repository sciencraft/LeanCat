# Evaluation Protocol

This artifact is intended to support reproducible evaluation of proof-generation
systems on LeanCat.

## Environment

- Lean toolchain: `leanprover/lean4:v4.19.0`
- Mathlib dependency: `v4.19.0`, pinned through `lakefile.lean` and
  `lake-manifest.json`
- Build command: `lake build`

Reviewers and users should run all checks from the repository root.

## Task Definition

Each task is a Lean file in `CAT_statement/S_XXXX.lean` paired with a
natural-language statement in `problems/XXXX.md` and metadata in
`metadata.json`.

A task is solved when a system replaces the target `sorry` placeholder or
placeholders with Lean code and the resulting file is accepted by Lean under the
pinned environment.

## Valid Proof Criteria

A submitted proof is valid only if all of the following hold:

- The corresponding Lean file compiles with Lean 4.19.0 and Mathlib v4.19.0.
- The theorem statement, local definitions, imports, namespaces, universes, and
  assumptions are not changed in a way that weakens or changes the intended
  task.
- The file contains no `sorry`, `admit`, `axiom`, or `unsafe` additions used to
  bypass proof obligations.
- No new external dependencies are introduced unless the evaluation setting
  explicitly permits them.
- The proof preserves the intended mathematical meaning of the task.

Compilation alone is not sufficient if a system changes the target statement or
shadows key definitions to make a different theorem easier.

## Recommended Reporting

Report results as raw counts and percentages over the 100 tasks. For small
splits, report raw counts prominently because one solved High-difficulty task is
2.5 percentage points.

For pass@k settings, a task is counted as solved if at least one of the k
independent attempts satisfies the valid proof criteria.

For interactive or retrieval-augmented settings, report:

- input form: formal statement only, natural language only, or both;
- retrieval access and corpus;
- maximum refinement iterations;
- generation budget;
- verification timeout;
- total wall-clock or service budget when available.

The paper experiments use a 300-second verification timeout per attempt unless
otherwise stated.

## Evaluation Drivers

This artifact includes two lightweight drivers. Both read the paired
`problems/XXXX.md` and `CAT_statement/S_XXXX.lean` files, call an
OpenAI-compatible chat-completions endpoint, extract Lean code from the response,
and check the candidate with `lake env lean`.

Configure the API with environment variables or command-line flags:

Windows PowerShell:
```powershell
$env:OPENAI_API_KEY="your_key"
$env:OPENAI_BASE_URL="https://api.openai.com/v1"
```

Linux/macOS:
```bash
export OPENAI_API_KEY="your_key"
export OPENAI_BASE_URL="https://api.openai.com/v1"
```

Static pass@k:

```bash
python scripts/passk.py --start 1 --end 100 --model gpt-5.2 -k 4
```

LeanBridge-style generate-verify-refine:

```bash
python scripts/leanbridge.py --start 1 --end 100 --model gpt-5.2 --max-iterations 4
```

By default, `leanbridge.py` uses the local LeanExplore backend:

```bash
pip install lean-explore[local]
lean-explore data fetch
python scripts/leanbridge.py --start 1 --end 100 --model gpt-5.2 --search-backend local
```

The hosted LeanExplore API can be selected with `--search-backend api`, but the
local backend is recommended when the hosted API is unavailable. To run the
verify-refine loop without retrieval, use `--search-backend none`. For custom
retrievers, use `--search-backend command --search-command "python path/to/search.py"`;
the command receives a query on stdin and writes retrieved Mathlib context to
stdout.

For local LeanExplore, the service is created once per Python process and reused
for all queries to avoid repeatedly loading the local indices and models. The
script prints progress logs with a `[LeanCat]` prefix, including search, LLM, and
Lean verification stages. The logs do not print API keys.

Outputs are written under `results/` by default. Use `--resume` to skip existing
result files.

## Dataset Integrity Check

Run:

```bash
python scripts/validate_dataset.py
```

This checks the expected file counts, metadata consistency, import coverage,
basic statement shape, and absence of root-level PDF files in the anonymized
artifact.
