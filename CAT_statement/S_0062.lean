import Mathlib

open CategoryTheory Limits


variable {C : Type u} [Category.{v} C]

theorem strongly_complete_of_strongly_cocomplete_of_separating_set
    [HasColimitsOfSize.{v, u} C] {𝒢 : Set C} [Small.{v} 𝒢] (h𝒢 : IsSeparating 𝒢) :
    HasLimitsOfSize.{v, u} C := by
  sorry