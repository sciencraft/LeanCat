# Dataset Card

## Dataset Summary

LeanCat is an evaluation dataset of 100 statement-level category-theory tasks in
Lean 4 and Mathlib. Each item contains a Lean theorem file, a paired
natural-language problem statement, and metadata describing topic, difficulty,
and source information.

This anonymized artifact contains Part I: 1-category theory.

## Motivation

LeanCat is designed to evaluate library-grounded abstraction in formal theorem
proving. The tasks emphasize Mathlib interface navigation, categorical
definitions, universal properties, and proof engineering in a mature formal
library.

## Composition

The dataset contains:

- `CAT_statement/S_0001.lean` through `CAT_statement/S_0100.lean`;
- `problems/0001.md` through `problems/0100.md`;
- `metadata.json` with topic, difficulty, source, and declaration fields;
- pinned Lean and Mathlib dependencies through `lean-toolchain`,
  `lakefile.lean`, and `lake-manifest.json`.

Each Lean file is intended to be self-contained at the statement level. The
provided theorem statements contain `sorry` placeholders because the dataset
asks systems to supply proofs.

## Collection and Curation

Problems were selected to cover core 1-category-theory interfaces and proof
patterns, including adjunctions, reflective and coreflective subcategories,
concrete categories, limits, colimits, cocompletions, abelian categories, and
monads.

Candidate statements were drafted, checked, and normalized against Mathlib
v4.19.0. Human review checked compilation, mathematical meaning, universe and
typeclass assumptions, and consistency between natural-language and Lean
statements.

## Intended Uses

Recommended uses include:

- evaluating proof-generation systems under explicit tool and retrieval
  assumptions;
- comparing formal-only and natural-language-plus-formal prompting protocols;
- studying failure modes in library-grounded theorem proving;
- auditing how systems use Mathlib abstractions.

## Out-of-Scope Uses

LeanCat should not be used to make fine-grained model rankings from very small
split-level differences. The High split has 40 tasks, so individual successes
can noticeably change percentages.

LeanCat should also not be used as evidence of broad mathematical reasoning
ability outside the stated Lean 4 / Mathlib / category-theory scope.

## Limitations

- The dataset is compact and domain-specific.
- Difficulty labels combine mathematical judgment with machine-facing
  formalization evidence.
- The release is tied to Lean 4.19.0 and Mathlib v4.19.0.
- Future Mathlib changes may alter task difficulty or compatibility.
- Some tasks require local bridge lemmas or definitions rather than direct
  theorem lookup.

## Responsible AI Metadata

- Personal or sensitive information: none. The dataset contains mathematical
  statements, Lean code, and bibliographic source annotations.
- Synthetic data: the dataset is not synthetic in the sense of generated
  personal or behavioral data. Some Lean statement drafts were assisted by LLMs
  and then reviewed by humans.
- Known biases: the dataset focuses on category theory and Mathlib, so it is not
  representative of all formal mathematics or all proof assistants.
- Social impact: the intended positive impact is more precise evaluation of
  reliable formalization systems. The main risk is overclaiming system ability
  from a compact evaluation dataset or underdocumented evaluation protocol.

## Maintenance

Releases should pin Lean and Mathlib versions, keep source metadata auditable,
and document any future task additions or compatibility updates.

## License

This artifact is distributed under the repository license. Users should also
respect the licenses and terms of upstream dependencies and cited source
materials.
