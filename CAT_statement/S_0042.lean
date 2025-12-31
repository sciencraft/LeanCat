import Mathlib

open CategoryTheory Limits Functor

variable {C : Type u₁} [Category.{v₁} C] {D : Type u₂} [Category.{v₂} D]

lemma fully_faithful_reflects_limits_and_colimits (F : C ⥤ D) [Full F] [Faithful F] :
    ReflectsLimits F ∧ ReflectsColimits F := by
  sorry