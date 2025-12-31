import Mathlib

open CategoryTheory Limits

variable {C : Type u} [Category.{v} C]

theorem has_limits_iff_has_products_and_pullbacks :
    HasLimitsOfSize.{v, v} C ↔ (∀ (J : Type v), HasLimitsOfShape (Discrete J) C) ∧ HasLimitsOfShape WalkingCospan C := by
  sorry