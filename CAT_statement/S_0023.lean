import Mathlib

open CategoryTheory

theorem ring_hom_induced_functor_has_adjoints
    {A B : RingCat} (φ : A ⟶ B) :
    ∃ (φ_pull : ModuleCat B ⥤ ModuleCat A)
      (φ_push : ModuleCat A ⥤ ModuleCat B)
      (φ_coind : ModuleCat A ⥤ ModuleCat B),
      Nonempty (Adjunction φ_push φ_pull) ∧ Nonempty (Adjunction φ_pull φ_coind) := by
  sorry