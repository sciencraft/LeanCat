import Mathlib

open CategoryTheory

namespace CAT_statement_S_0037

universe u v w

variable {X : Type uX} [Category.{vX} X]

structure ConcreteCat (X : Type v) [Category X] where
  C : Type u
  [cat : Category C]
  U : C ⥤ X
  [U_Faithful : U.Faithful]

attribute [instance] ConcreteCat.cat ConcreteCat.U_Faithful


def IsConcreteFunc {A B : ConcreteCat (X := X)} (F : A.C ⥤ B.C) : Prop :=
  Nonempty ((F ⋙ B.U) ≅ A.U)


def SetConcrete : ConcreteCat (X := Type u) :=
{ C := Type u
  U := 𝟭 (Type u) }   


def TopConcrete : ConcreteCat (X := Type u) :=
{ C := TopCat.{u}
  U := (forget TopCat) }  

def ConcreteFuncsIso (A B : ConcreteCat (X := Type u)) : Type _ :=
  { F : A.C ⥤ B.C // IsConcreteFunc (A := A) (B := B) F }

theorem only_two_concrete_functors_from_Set_to_Top_iso :
    Nat.card (ConcreteFuncsIso SetConcrete TopConcrete) = 2 := by
  sorry

end CAT_statement_S_0037