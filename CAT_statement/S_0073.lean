import Mathlib

open CategoryTheory Limits


theorem TopCat_forget_lifts_and_not_reflects_limits :
    (∀ {J : Type u} [Category.{v} J] (F : J ⥤ TopCat)
        (c : Cone (F ⋙ forget TopCat)) (hc : IsLimit c),
        Nonempty (IsLimit (TopCat.coneOfConeForget (c := c))) ∧
          Nonempty ((forget TopCat).mapCone (TopCat.coneOfConeForget (c := c)) ≅ c))
    ∧
    (∃ (J : Type u) (inst : Category.{v} J)
       (F : @CategoryTheory.Functor J inst TopCat _)
       (c : Limits.Cone F),
        Nonempty (IsLimit ((forget TopCat).mapCone c)) ∧ ¬ Nonempty (IsLimit c)) := by
  sorry
