import Mathlib

open CategoryTheory

variable {C : Type u₁} [Category.{v₁} C] {D : Type u₂} [Category.{v₂} D]

theorem right_adjoint_isEquivalence_iff_left_full_faithful_and_right_conservative 
    (F : C ⥤ D) (G : D ⥤ C) (adj : F ⊣ G) :
    G.IsEquivalence ↔ (F.Full ∧ F.Faithful) ∧ G.ReflectsIsomorphisms := by
  sorry