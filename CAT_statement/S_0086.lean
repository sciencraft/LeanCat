import Mathlib

open CategoryTheory Limits Opposite

variable {A : Type u} [Category.{v} A] [Abelian A]

theorem hom_rightExact_iff_preserves_epi (P : A) :
    PreservesFiniteColimits (preadditiveCoyoneda.obj (op P)) ↔ 
    Functor.PreservesEpimorphisms (preadditiveCoyoneda.obj (op P)) := by
  sorry