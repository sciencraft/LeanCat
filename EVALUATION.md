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

## Dataset Integrity Check

Run:

```bash
python scripts/validate_dataset.py
```

This checks the expected file counts, metadata consistency, import coverage,
basic statement shape, and anonymization-sensitive text patterns.
