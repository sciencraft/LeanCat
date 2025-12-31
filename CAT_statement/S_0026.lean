import Mathlib

open CategoryTheory Functor

variable {C : Type u₁} [Category.{v₁} C] {D : Type u₂} [Category.{v₂} D]
variable {F : C ⥤ D} {G : D ⥤ C} {H : C ⥤ D}

theorem fullyFaithful_iff_of_adjoints (hFG : F ⊣ G) (hGH : G ⊣ H) :
    (F.Full ∧ F.Faithful) ↔ (H.Full ∧ H.Faithful) := by
  sorry