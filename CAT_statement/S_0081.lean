import Mathlib

open CategoryTheory Limits Category

variable {C : Type*} [Category C] [Abelian C]

theorem mono_iff_isZero_kernel {X Y : C} (f : X ⟶ Y) :
    Mono f ↔ IsZero (kernel f) := by
  sorry