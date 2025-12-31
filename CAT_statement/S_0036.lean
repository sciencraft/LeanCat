import Mathlib

open CategoryTheory

theorem exists_category_not_concretizable_over_Type :
    ∃ (C : Type u) (_ : Category.{v} C), ¬ ∃ (F : C ⥤ Type v), F.Faithful := by
  sorry