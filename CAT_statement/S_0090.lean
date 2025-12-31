import Mathlib

open CategoryTheory

variable {A : Type*} [Category A] [Limits.HasZeroMorphisms A]
  [IsNormalMonoCategory A]
  [IsNormalEpiCategory A]

  [Limits.HasKernels A]
  [Limits.HasCokernels A]

theorem binormal_mono_simple_iff_epi_simple (x : A) :
    (∀ (y : A) (f : y ⟶ x) [Mono f], f = 0 ∨ IsIso f) ↔
    (∀ (y : A) (g : x ⟶ y) [Epi g], g = 0 ∨ IsIso g) := by
    sorry
