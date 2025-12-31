import Mathlib

open CategoryTheory

namespace CAT_statement_S_0035

structure Construct where
  C : Type u
  [str : Category.{v} C]
  U : C ⥤ Type u
  [faithful : Functor.Faithful U]

attribute [instance] Construct.str Construct.faithful

def IsRealization (S T : Construct.{u, v}) (F : S.C ⥤ T.C) : Prop :=
  F ⋙ T.U = S.U ∧ Functor.Full F ∧ Function.Injective F.obj

theorem exists_universal_construct :
    ∃ (T : Construct.{u, v}), ∀ (S : Construct.{u, v}), ∃ (F : S.C ⥤ T.C), IsRealization S T F := by
  sorry

end CAT_statement_S_0035
