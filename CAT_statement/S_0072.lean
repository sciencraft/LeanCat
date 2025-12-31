import Mathlib

open CategoryTheory Limits Topology

universe u

variable {D : Type (u+1)} [Category.{u} D]
variable (i : D ⥤ CompHaus.{u})
variable [CategoryTheory.Functor.Full i] [CategoryTheory.Functor.Faithful i]

theorem reflective_iff_cocomplete_and_contains_nonempty_of_full_subcategory_CompHaus :
    Nonempty (CategoryTheory.Reflective i) ↔
      (Nonempty (HasColimits D) ∧ ∃ X : D, Nonempty (i.obj X)) := by
  sorry
