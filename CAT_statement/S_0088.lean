import Mathlib

open CategoryTheory


variable {𝒜 : Type*} [Category 𝒜] [Abelian 𝒜]


theorem simple_objects_nonzero_morphisms_iso
    {x y : 𝒜} [Simple x] [Simple y] (f : x ⟶ y) (h : f ≠ 0) :
    IsIso f := by
  sorry


theorem simple_object_end_is_division_ring
    (x : 𝒜) [Simple x] :
    Nonempty (DivisionRing (CategoryTheory.End x)) := by
  sorry


theorem simple_objects_hom_zero_of_ne
    {x y : 𝒜} [Simple x] [Simple y] (hxy : IsEmpty (x ≅ y)) :
    ∀ f : x ⟶ y, f = 0 := by
  sorry
