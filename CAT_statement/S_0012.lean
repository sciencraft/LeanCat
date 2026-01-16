import Mathlib

open CategoryTheory Functor


theorem mono_iff_exists_embedding_section
  {C : Type u} [Category.{v} C] {X Y : C} (f : X ⟶ Y) :
    Mono f ↔ ∃ (D : Type (max u v)) (_ : Category.{v} D) (I : C ⥤ D) (_ : FullyFaithful I),
    IsSplitMono (I.map f) := by
  sorry
