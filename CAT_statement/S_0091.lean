import Mathlib

open CategoryTheory

variable {C : Type u₁} [Category.{v₁} C]


theorem monad_forget_has_left_adjoint (T : Monad C) :
    T.forget.IsRightAdjoint := by
  sorry