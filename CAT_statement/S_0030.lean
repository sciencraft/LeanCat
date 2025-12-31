import Mathlib

open CategoryTheory Functor

universe u v

theorem exists_not_reflective :
    ∃ (E C D : Type u)
    (_ : Category.{v} E) (_ : Category.{v} C) (_ : Category.{v} D) (i : C ⥤ D)
    (_ : Faithful i) (j : D ⥤ E) (_ : Faithful j),
    IsEmpty (Reflective i) ∧ Nonempty (Reflective (i ⋙ j)) := by
  sorry