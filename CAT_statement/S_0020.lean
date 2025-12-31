import Mathlib

open CategoryTheory

variable {C D : Type*} [Category C] [Category D] (F : C ⥤ D) (G : D ⥤ C)

theorem fully_faithful_iff_unit_isIso (adj : F ⊣ G) :
    (F.Full ∧ F.Faithful) ↔ IsIso adj.unit := by
  sorry