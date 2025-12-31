import Mathlib

open CategoryTheory Limits


variable {C D: Type*} [Category C] [Category D] (G : D ⥤ C)

theorem cocomplete_iff_hasCoequalizers_of_monadic [HasColimitsOfSize C] [MonadicRightAdjoint G] :
    HasColimitsOfSize D ↔ HasCoequalizers D := by
  sorry