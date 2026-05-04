---
license: cc-by-4.0
language:
  - en
tags:
  - lean4
  - mathlib
  - formal-theorem-proving
  - category-theory
  - benchmark
  - proof-generation
pretty_name: LeanCat
size_categories:
  - n<1K
task_categories:
  - text-generation
configs:
  - config_name: default
    data_files:
      - split: test
        path: data/leancat_records.jsonl
---

# LeanCat: A Lean Dataset for Evaluating Library-Grounded Category-Theoretic Reasoning

This is an anonymized review artifact.

**LeanCat** is a dataset of **100 statement-level problems** in **Lean 4** (mathlib), designed to stress-test **abstraction-heavy, library-grounded reasoning** in formal mathematics. This repository contains Part I: 1-Category Theory.

## Overview

LeanCat addresses a critical gap in automated theorem proving evaluation datasets by focusing on **category theory** - the unifying language of modern mathematics that requires sophisticated abstraction and library navigation skills. While existing benchmarks target olympiad-style problems or undergraduate mathematics, LeanCat challenges AI systems with research-level categorical reasoning.



## Repository Structure
```text
LeanCat/
├── CAT_statement/          # Formal Lean 4 statements of dataset problems
├── problems/               # Natural language problem descriptions (Markdown)
├── data/                   # JSONL records for Hugging Face dataset viewing
│   └── leancat_records.jsonl # One record per dataset problem
├── configs/                # Evaluation protocol configuration
├── prompts/                # Prompt templates used by baseline protocols
├── scripts/                # Dataset validation utilities
├── .github/               
├── CAT_statement.lean     # Main Lean 4 file containing all statement imports
├── DATASET_CARD.md        # Dataset documentation and responsible-use notes
├── EVALUATION.md          # Proof validation and reporting protocol
├── lakefile.lean          
├── lean-toolchain         # Use Lean version 4.19.0
├── metadata.json          # Problem metadata (difficulty, tags, refs)
├── lake-manifest.json    
├── .gitignore            
└── LICENSE               
```

## Quick Start

1. Install Lean via `elan`: https://leanprover-community.github.io/get_started.html
2. Build the project:
```bash
# Build with lake
lake build
```
The dataset artifact builds with Lean 4.19.0 and mathlib 4.19.0.

To validate the artifact structure, run:
```bash
python scripts/validate_dataset.py
```

For Hugging Face hosting and programmatic loading, the derived JSONL index is
provided at `data/leancat_records.jsonl`. It contains one record per problem,
including the problem id, metadata fields, source file paths, natural-language
statement, and Lean formal statement. Regenerate it after metadata or statement
edits with:
```bash
python scripts/generate_hf_records.py
```

The NeurIPS Croissant metadata file with Responsible AI fields is provided as
`croissant.json`. This file is the validated submission version for
OpenReview; the Hugging Face Croissant API may still expose the platform's
automatically generated core-metadata version.

To run the provided evaluation drivers with an OpenAI-compatible chat API:
```powershell
$env:OPENAI_API_KEY="your_key"
$env:OPENAI_BASE_URL="https://api.openai.com/v1"
python scripts/passk.py --start 1 --end 1 --model gpt-5.2 -k 4
python scripts/leanbridge.py --start 1 --end 1 --model gpt-5.2 --max-iterations 4
```

On Linux/macOS:
```bash
export OPENAI_API_KEY="your_key"
export OPENAI_BASE_URL="https://api.openai.com/v1"
python scripts/passk.py --start 1 --end 1 --model gpt-5.2 -k 4
python scripts/leanbridge.py --start 1 --end 1 --model gpt-5.2 --max-iterations 4
```

`leanbridge.py` uses the local LeanExplore backend by default. Install and
prepare it with `pip install lean-explore[local]` and `lean-explore data fetch`.
The local LeanExplore service is initialized once per process and reused across
queries. Use `--search-backend none` for a no-search refinement loop. Outputs
are written under `results/`, which is ignored by git.

## Evaluation Protocol

Each Lean file contains a dataset statement with one or more `sorry` placeholders. A problem is solved when the placeholders are replaced by a proof and the file is accepted by Lean under the pinned toolchain and dependencies in this artifact. The aggregate project can be checked with `lake build`.

See `EVALUATION.md` for the full proof validity and reporting protocol. See
`DATASET_CARD.md` for dataset documentation and responsible-use notes.

## Benchmark Content

### Problem Categories (100 problems total for 1-Category Theory)

1. **Basic Category Properties** (Problems 1-18): Fundamental results about categories, morphisms, monomorphisms, epimorphisms, initial/terminal objects

2. **Adjunctions** (Problems 19–29): Adjoint functors, universal properties, comma categories

3. **Reflective and Coreflective Subcategories** (Problems 30-33): Subcategory properties and classifications

4. **Concrete Categories** (Problems 34-41): Categories with faithful forgetful functors to Set

5. **Limits and Colimits** (Problems 42-73): The largest cluster covering limits, colimits, and related constructions

6. **Cocompletions** (Problems 74-78): Recent work on cocompletions requiring new definitions

7. **Abelian Categories** (Problems 79-90): Homological algebra concepts, kernels, cokernels, exact sequences

8. **Monads** (Problems 91-100): Monads, Kleisli and Eilenberg-Moore categories

### Difficulty Distribution

- **Easy**: 20 problems (≤5.54/10 difficulty score)
- **Medium**: 40 problems (5.54-7.8/10 difficulty score)  
- **High**: 40 problems (≥7.8/10 difficulty score)

## License

Dataset contents, including LeanCat problem statements, natural-language
descriptions, and metadata, are released under CC BY 4.0. Evaluation scripts and
software code are released under the repository MIT license.

