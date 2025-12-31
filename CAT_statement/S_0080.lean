import Mathlib

open CategoryTheory

variable {C : Type*} [Category C] [Abelian C]

theorem isIso_iff_mono_and_epi {X Y : C} (f : X ⟶ Y) :
    IsIso f ↔ (Mono f ∧ Epi f) := by
  sorry