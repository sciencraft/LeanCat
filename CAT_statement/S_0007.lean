import Mathlib

open CategoryTheory

variable {C D : Type*} [Category C] [Category D]

theorem karoubi_universal_property [IsIdempotentComplete D] (F : C ⥤ D) :
    ∃ (F' : Idempotents.Karoubi C ⥤ D), Nonempty ((Idempotents.toKaroubi C) ⋙ F' ≅ F) := by
  sorry

theorem karoubi_universal_property_unique_up_to_iso [IsIdempotentComplete D] {F : C ⥤ D}
    {F₁ F₂ : Idempotents.Karoubi C ⥤ D}
    (h₁ : Nonempty ((Idempotents.toKaroubi C) ⋙ F₁ ≅ F))
    (h₂ : Nonempty ((Idempotents.toKaroubi C) ⋙ F₂ ≅ F)) :
    Nonempty (F₁ ≅ F₂) := by
  sorry
