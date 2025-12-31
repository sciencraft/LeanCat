import Mathlib

open CategoryTheory Topology

namespace CAT_statement_S_0033

structure FullReflectiveSubcategory (C : Type u) [Category.{v} C] where
  obj : C → Prop
  iso_closed : ∀ {X Y : C}, obj X → (X ≅ Y) → obj Y
  reflective : Nonempty (Reflective (inducedFunctor (Subtype.val : Subtype obj → C)))

@[ext]
lemma FullReflectiveSubcategory.ext {C : Type u} [Category.{v} C]
    (A B : FullReflectiveSubcategory C) (h : A.obj = B.obj) : A = B := by
  cases A
  cases B
  congr

theorem CompHaus_has_precisely_two_reflective_subcategories :
    Nat.card (FullReflectiveSubcategory CompHaus) = 2 := by
  sorry

end CAT_statement_S_0033
