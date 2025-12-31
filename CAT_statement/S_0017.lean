import Mathlib

open CategoryTheory Limits TopologicalSpace

namespace CAT_statement_S_0019

universe u uX

variable {X : Type uX} [Category.{vX} X]

namespace AHS

structure ConcreteCat (X : Type v) [Category X] where
  C : Type u
  [cat : Category C]
  U : C ⥤ X
  [U_Faithful : U.Faithful]

attribute [instance] ConcreteCat.cat ConcreteCat.U_Faithful


def IsInitialHom {C : ConcreteCat (X:= X)} {A B : C.C} (f : A ⟶ B) : Prop :=
  ∀ ⦃Z : C.C⦄ (g : C.U.obj Z ⟶ C.U.obj A),
    (∃ h : Z ⟶ B, C.U.map h = g ≫ C.U.map f) →
      (∃ k : Z ⟶ A, C.U.map k = g)


def IsEmbedding {C : ConcreteCat (X:= X)} {A B : C.C} (f : A ⟶ B) : Prop :=
  IsInitialHom f ∧ Mono (C.U.map f)


def IsInjectiveObj {C : ConcreteCat (X:= X)} (I : C.C) : Prop :=
  ∀ ⦃A B : C.C⦄ (m : A ⟶ B),
    IsEmbedding  m →
    ∀ (f : A ⟶ I), ∃ g : B ⟶ I, m ≫ g = f

end AHS

def S : TopCat.{u} :=
  letI : TopologicalSpace (Fin 3) := generateFrom {({0, 1} : Set (Fin 3))}
  TopCat.of (ULift.{u} (Fin 3))

def TopCatConcrete : AHS.ConcreteCat (X := Type u) :=
{ C := TopCat.{u}
  U := forget TopCat}

theorem Inj_in_TopCat {Y : TopCat.{u}} :
    AHS.IsInjectiveObj (C:= TopCatConcrete) Y ↔∃ (I : Type u), Nonempty (Retract Y (piObj (fun (_ : I) => S))) := by
    sorry

end CAT_statement_S_0019
