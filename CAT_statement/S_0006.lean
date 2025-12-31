import Mathlib

open CategoryTheory


theorem funtor_has_quasi_inverse_iff {C D : Type*} [Category C] [Category D] (F : C ⥤ D):
    (∃ G : D ⥤ C, (Nonempty (Functor.id C ≅ F.comp G)) ∧ (Nonempty (G.comp F ≅ Functor.id D)))
    ↔ F.IsEquivalence := by
 sorry