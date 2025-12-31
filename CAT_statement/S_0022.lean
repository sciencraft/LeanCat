import Mathlib

open CategoryTheory

variable {C : Type u₁} [Category.{v} C] {D : Type u₂} [Category.{v} D]

theorem isLeftAdjoint_iff_yoneda_comp_op_isRepresentable (F : C ⥤ D) :
    F.IsLeftAdjoint ↔ ∀ (d : D), (F.op ⋙ yoneda.obj d).IsRepresentable := by
  sorry
