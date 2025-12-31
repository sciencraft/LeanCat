import Mathlib

open CategoryTheory Limits

universe u₁ u₂ v₁

variable {C : Type u₁} {D : Type u₂} [Category.{v₁} C] [Category.{v₁} D]
variable {G : D ⥤ C} {F : C ⥤ D} (adjFG : F ⊣ G)
variable [HasCoequalizers D]
variable [G.ReflectsIsomorphisms]
variable [PreservesColimitsOfShape WalkingParallelPair G]


theorem monadicOfConservativePreservesCoequalizers :
    Nonempty (MonadicRightAdjoint G) := by
    sorry
