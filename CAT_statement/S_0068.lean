import Mathlib

open CategoryTheory Limits

universe u


theorem regular_epimorphism_not_product_regular_epimorphism : ∃ (C : Type (u+1)) (inst : Category C) (c d c' d' : C) (f : c ⟶ d) (g : c' ⟶ d') (inst₁ : RegularEpi f) (inst₂ : RegularEpi g) (hasProd₁ : HasBinaryProduct c c') (hasProd₂ : HasBinaryProduct d d'), IsEmpty (RegularEpi (prod.map f g)) := by
  sorry
