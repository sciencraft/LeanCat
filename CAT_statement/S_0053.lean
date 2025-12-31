import Mathlib

open CategoryTheory Limits

variable {D : Type u} [Category.{v} D] [HasLimits D] [LocallySmall.{v} D]
variable {C : Type u} [Category.{v} C]
variable (G : D ⥤ C)

theorem has_left_adjoint_iff_continuous_and_initials :
    G.IsRightAdjoint ↔ PreservesLimits G ∧ ∀ (c : C), HasInitial (StructuredArrow c G) := by
  sorry