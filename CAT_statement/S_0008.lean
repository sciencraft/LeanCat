import Mathlib

open CategoryTheory


theorem coproduct_is_free_product (G₁ G₂ : Grp) :
  ∀ (H : Grp) (f₁ : G₁ ⟶ H) (f₂ : G₂ ⟶ H),
   ∃! φ: (FreeGroup (G₁ ⊕ G₂)) ⟶ H,
    φ.comp (fun x ↦ FreeGroup.of (Sum.inl x)) = f₁
    ∧ φ.comp (fun x ↦ FreeGroup.of (Sum.inr x)) = f₂ :=
sorry
