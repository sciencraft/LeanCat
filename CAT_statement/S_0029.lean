import Mathlib

open CategoryTheory

def RingCat.units : RingCat.{u} ⥤ Grp.{u} where
  obj R := .of Rˣ
  map f := Grp.ofHom (Units.map f.hom)

theorem exists_leftAdjoint_unitFunctor :
    ∃ (left : Grp.{u} ⥤ RingCat.{u}), Nonempty (left ⊣ RingCat.units.{u}) := by
    sorry
