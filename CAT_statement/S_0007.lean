import Mathlib

open CategoryTheory

variable {C D : Type*} [Category C] [Category D]

theorem karoubi_universal_property [IsIdempotentComplete D] (F : C ⥤ D) :
    ∃! (F' : (Idempotents.Karoubi C) ⥤ D), (Idempotents.toKaroubi C) ⋙ F' = F := by
  sorry
