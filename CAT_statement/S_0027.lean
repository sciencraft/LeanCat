import Mathlib

open CategoryTheory

theorem int_endofunctor_hasLeftAdjoint_iff_hasRightAdjoint (f : ℤ ⥤ ℤ) :
    f.IsRightAdjoint ↔ f.IsLeftAdjoint := by
  sorry