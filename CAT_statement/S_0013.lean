import Mathlib

open CategoryTheory

universe u


structure CommCStarAlgCat : Type (u + 1) where
  of ::

  carrier : Type u
  [commCStarAlgebra : CommCStarAlgebra carrier]

attribute [instance] CommCStarAlgCat.commCStarAlgebra

namespace CommCStarAlgCat

instance : CoeSort CommCStarAlgCat (Type u) :=
  ⟨CommCStarAlgCat.carrier⟩

instance : Category CommCStarAlgCat where
  Hom A B := A →⋆ₐ[ℂ] B
  id A := StarAlgHom.id ℂ A
  comp f g := g.comp f

end CommCStarAlgCat

theorem gelfandDuality : Nonempty (CompHaus.{u} ≌ (CommCStarAlgCat.{u})ᵒᵖ) := by
  sorry
