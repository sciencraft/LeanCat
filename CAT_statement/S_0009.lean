import Mathlib

open CategoryTheory

theorem exists_epic_not_surjective_in_Ring :
    ∃ (A B : RingCat) (f : A ⟶ B), Epi f ∧ ¬ Function.Surjective f := by
  sorry