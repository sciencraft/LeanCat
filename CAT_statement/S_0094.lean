import Mathlib

open CategoryTheory Functor

namespace CAT_statement_S_0094

variable {C : Type*} [Category C]
variable {B : Type*} [Category B]

noncomputable def monadOfRightAdjoint (U : Functor C B) [IsRightAdjoint U] : Monad B :=
  (Adjunction.ofIsRightAdjoint U).toMonad

def IsIsoClosed (U : Functor C B) := ∀ (x : C) (y : B) (f : U.obj x ⟶ y) [IsIso f], ∃ (z : C), y = U.obj z

variable {U : Functor C B} [Full U] [Faithful U] [IsRightAdjoint U]
  {h_inj : Function.Injective U.obj}
  {h_iso_closed : IsIsoClosed U}


theorem monad_idempotent_of_full_reflective_embedding :
    let T : Monad B := monadOfRightAdjoint U
    IsIso T.μ := by
  sorry

end CAT_statement_S_0094
