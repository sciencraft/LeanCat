import Mathlib

open CategoryTheory Limits

namespace CAT_statement_S_0059

universe w' w'₁ w w₁ v₁ v₂ v₃ u₁ u₂ u₃

variable {C : Type u₁} [Category.{v₁} C]
variable {D : Type u₂} [Category.{v₂} D]
variable {J : Type w} [Category.{w'} J] {K : J ⥤ C}

structure LiftableCone₂ (K : J ⥤ C) (F : C ⥤ D) (c : Cone (K ⋙ F)) where

  liftedCone : Cone K

  validLift : F.mapCone liftedCone ≅ c
  isLimit : IsLimit liftedCone

class LiftsLimit (K : J ⥤ C) (F : C ⥤ D) where

  lifts : ∀ c, IsLimit c → LiftableCone₂ K F c

theorem exists_functor_lifts_limit_and_not_faithful :
    ∃ (C : Type (u₁+1)) (_ : Category.{u₁} C) (D : Type u₂) (_ : Category.{u₂} D) (F : C ⥤ D), (∀ (J : Type u₁) (_ : Category.{w'} J) (K : J ⥤ C), Nonempty (LiftsLimit K F)) ∧
    ¬ F.Faithful := by
  sorry

end CAT_statement_S_0059
