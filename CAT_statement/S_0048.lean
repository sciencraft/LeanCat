import Mathlib

open CategoryTheory Limits

variable {C : Type u} [Category.{v} C] {D : Type u} [Category.{v} D]


theorem hasColimits_of_reflective (i : C ⥤ D) [Reflective i] [HasColimits D] :
    HasColimits C := by
  sorry