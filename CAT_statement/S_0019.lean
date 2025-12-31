import Mathlib

open CategoryTheory Limits

variable {C : Type*} {D : Type*} [Category.{v₁} C] [Category.{v₂} D]

theorem functor_hasLeftAdjoint_iff_structuredArrow_hasInitial
    (G : D ⥤ C) :
    G.IsRightAdjoint ↔ ∀ c : C, HasInitial (StructuredArrow c G) := by
  sorry
