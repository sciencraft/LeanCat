import Mathlib

open CategoryTheory

theorem not_reflective_and_coreflective (P : ObjectProperty (Type u))
    (h : P.IsClosedUnderIsomorphisms) (hproper : ∃ X : Type u, ¬ P X) :
    IsEmpty (Reflective P.ι) ∨ IsEmpty (Coreflective P.ι) := by
  sorry