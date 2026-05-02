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

def ConcreteFuncs (A B : ConcreteCat (X := Type u)) : Type _ :=
  { F : A.C ⥤ B.C // IsConcreteFunc (A := A) (B := B) F }

def ConcreteFuncsSetoid (A B : ConcreteCat (X := Type u)) :
    Setoid (ConcreteFuncs A B) where
  r F G := Nonempty (F.1 ≅ G.1)
  iseqv := by
    refine ⟨?_, ?_, ?_⟩
    · intro F
      exact ⟨Iso.refl F.1⟩
    · intro F G h
      rcases h with ⟨e⟩
      exact ⟨e.symm⟩
    · intro F G H hFG hGH
      rcases hFG with ⟨eFG⟩
      rcases hGH with ⟨eGH⟩
      exact ⟨eFG.trans eGH⟩

def ConcreteFuncClasses (A B : ConcreteCat (X := Type u)) : Type _ :=
  Quotient (ConcreteFuncsSetoid A B)

theorem only_two_concrete_functors_from_Set_to_Top_iso :
    Nat.card (ConcreteFuncClasses SetConcrete TopConcrete) = 2 := by
  sorry

end CAT_statement_S_0037
