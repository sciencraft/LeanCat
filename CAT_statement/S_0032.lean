import Mathlib

open CategoryTheory Functor Limits

namespace CAT_statement_S_0032

def IsIsoClosed (P : Type u → Prop) : Prop :=
  ∀ {X Y : Type u}, Nonempty (X ≅ Y) → P X → P Y

def SubcategoryEquiv (P Q : Type u → Prop) : Prop :=
  ∀ X, P X ↔ Q X

def IsReflectiveSubcategory (P : Type u → Prop) : Prop :=
  Nonempty (Reflective (ObjectProperty.ι P))

theorem Set_has_precisely_three_reflective_subcategories :
    ∃ (P₁ P₂ P₃ : Type u → Prop),
      IsIsoClosed P₁ ∧ IsReflectiveSubcategory P₁ ∧
      IsIsoClosed P₂ ∧ IsReflectiveSubcategory P₂ ∧
      IsIsoClosed P₃ ∧ IsReflectiveSubcategory P₃ ∧
      ¬ SubcategoryEquiv P₁ P₂ ∧ ¬ SubcategoryEquiv P₂ P₃ ∧ ¬ SubcategoryEquiv P₁ P₃ ∧
      ∀ (Q : Type u → Prop), IsIsoClosed Q → IsReflectiveSubcategory Q →
        (SubcategoryEquiv Q P₁ ∨ SubcategoryEquiv Q P₂ ∨ SubcategoryEquiv Q P₃) := by
  sorry

end CAT_statement_S_0032
