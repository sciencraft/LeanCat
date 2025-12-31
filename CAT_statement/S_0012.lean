import Mathlib

open CategoryTheory


theorem mono_iff_exists_embedding_section
  {C : Type u} [Category C]
  {X Y : C} (f : X ⟶ Y) :
  Mono f ↔
    ∃ (D : Type v),
      ∃ (_ : Category D)
        (I : C ⥤ D)
        (g : I.obj Y ⟶ I.obj X),
          (I.map f) ≫ g = 𝟙 (I.obj X)
          ∧
          (∀ {A B : C}, Function.Injective (fun h : A ⟶ B ↦ I.map h)) :=
by
  sorry
