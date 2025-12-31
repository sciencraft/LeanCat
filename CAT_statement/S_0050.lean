import Mathlib

open CategoryTheory Limits

lemma isCompactObject_iff_finite_type (X : Type u) :
    PreservesFilteredColimits (coyoneda.obj (Opposite.op X)) ↔ Finite X := by
  sorry