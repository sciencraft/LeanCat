import Mathlib

open CategoryTheory

variable {C : Type*} [Category C]


theorem monic_of_comp_monic {X Y Z : C} (g : X ⟶ Y) (f : Y ⟶ Z)
    [Mono (g ≫ f)] : Mono g := by
  sorry