import Mathlib

open CategoryTheory Limits

theorem isCompactObject_iff_finite_type (X : Type u) :
    PreservesFilteredColimits (coyoneda.obj (Opposite.op X)) ↔ Finite X := by
  sorry
