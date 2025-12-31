import Mathlib

open CategoryTheory Limits


def CategoryProperties (C : Type u) [Category.{v} C] : Prop :=
  HasColimits C ∧
  (∃ (G : C), IsSeparator G) ∧
  ¬ WellPowered.{v} C ∧
  ¬ WellPowered.{v} Cᵒᵖ

theorem exists_cocomplete_separator_not_wellPowered_not_coWellPowered :
    ∃ (C : Type u) (I : Category.{v} C), @CategoryProperties C I := by
  sorry