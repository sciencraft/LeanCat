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

