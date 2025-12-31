import Mathlib

open CategoryTheory Limits

universe u₁ v₁ u₂ v₂

variable {C : Type u₁} [Category.{v₁} C]
variable {E : Type u₂} [Category.{v₂} E]


theorem colimit_is_leftKanExtension_along_to_terminal
    (F : C ⥤ E) (K : C ⥤ PUnit) [HasColimit F] [K.HasLeftKanExtension F] :
    Nonempty ((K.leftKanExtension F).obj PUnit.unit ≅ colimit F) := by
  sorry