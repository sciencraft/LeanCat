# LeanCat: A Benchmark Suite for Formal Category Theory in Lean 4

[![arXiv](https://img.shields.io/badge/arXiv-2512.24796-b31b1b.svg)](https://arxiv.org/abs/2512.24796)


**LeanCat** is a benchmark suite of **100 statement-level problems** in **Lean 4** (mathlib), designed to stress-test **abstraction-heavy, library-grounded reasoning** in formal mathematics. This repository contains Part I: 1-Category Theory.

## Overview

LeanCat addresses a critical gap in automated theorem proving benchmarks by focusing on **category theory** - the unifying language of modern mathematics that requires sophisticated abstraction and library navigation skills. While existing benchmarks target olympiad-style problems or undergraduate mathematics, LeanCat challenges AI systems with research-level categorical reasoning.


## Paper 

- **arXiv**: [https://arxiv.org/abs/2512.24796](https://arxiv.org/abs/2512.24796)

&gt; **Note**: This repository is the **public release mirror**. Active development happens in a private repo, and we periodically sync public artifacts here.

## Repository Structure
```text
LeanCat/
├── CAT_statement/          # Formal Lean 4 statements of benchmark problems
├── problems/               # Natural language problem descriptions (Markdown)
├── .github/               
├── CAT_statement.lean     # Main Lean 4 file containing all statement imports
├── lakefile.lean          
├── lean-toolchain         # Use Lean version 4.19.0
├── metadata.json          # Problem metadata (difficulty, tags, refs)
├── LeanCat.pdf            # PDF version of the benchmark
├── lake-manifest.json    
├── .gitignore            
└── LICENSE               
```

## Quick Start

1. Install Lean via `elan`: https://leanprover-community.github.io/get_started.html
2. Build the project:
```bash
# Clone the repository
git clone https://github.com/sciencraft/LeanCat.git
cd LeanCat

# Build with lake
lake build
```
Our benchmark is build with Lean + Mathlib @ 4.19.0.

## Benchmark Content

### Problem Categories (100 problems total for 1-Category Theory)

1. **Basic Category Properties** (Problems 1-18): Fundamental results about categories, morphisms, monomorphisms, epimorphisms, initial/terminal objects

2. **Adjunctions** (Problems 19–24, 26–29): Adjoint functors, universal properties, comma categories

3. **Reflective and Coreflective Subcategories** (Problems 30-33): Subcategory properties and classifications

4. **Concrete Categories** (Problems 34-41): Categories with faithful forgetful functors to Set

5. **Limits and Colimits** (Problems 42-73): The largest cluster covering limits, colimits, and related constructions

6. **Cocompletions** (Problems 74-78): Recent work on cocompletions requiring new definitions

7. **Abelian Categories** (Problems 79-90): Homological algebra concepts, kernels, cokernels, exact sequences

8. **Monads** (Problems 24, 91-100): Monads, Kleisli and Eilenberg-Moore categories

### Difficulty Distribution

- **Easy**: 20 problems (≤6/10 difficulty score)
- **Medium**: 42 problems (6-8.5/10 difficulty score)  
- **High**: 38 problems (≥8.5/10 difficulty score)



## Citation
```bibtex
@article{xu2025leancat,
  title={LeanCat: A Benchmark Suite for Formal Category Theory in Lean (Part I: 1-Categories)},
  author={Xu, Rongge and Dai, Hui and Fu, Yiming and Jiang, Jiedong and Nie, Tianjiao and Wang, Hongwei and Wang, Junkai and Yang, Holiverse and Yang, Jiatong and Zhang, Zhi-Hao},
  journal={arXiv preprint arXiv:2512.24796},
  year={2025}
}
```