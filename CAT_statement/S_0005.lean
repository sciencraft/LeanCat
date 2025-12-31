import Mathlib

open CategoryTheory Idempotents

variable {C : Type*} [Category.{v} C]

theorem idempotent_splitting_from_epi_mono_factorization 
    (h : ∀ (X : C) (p : X ⟶ X) (hpp : p ≫ p = p), 
      ∃ (Y : C) (e : X ⟶ Y) (he : Epi e) (m : Y ⟶ X) (hm : Mono m), p = e ≫ m) : 
    IsIdempotentComplete C := by
  sorry