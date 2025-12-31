import Mathlib

open CategoryTheory

universe u v w

namespace CAT_statement_S_0041

structure FreeObject {C : Type u} [Category.{v} C] [HasForget.{w} C] (x : Type w) where
  (obj : C)
  (emb : x ⟶ (forget C).obj obj)
  (uniq : ∀ (Y : C) (f : x ⟶ (forget C).obj Y), ∃! (g : obj ⟶ Y), emb ≫ (forget C).map g = f)


lemma complete_lattice_category (X : Type u) :
    Nonempty (FreeObject (C := CompleteLat) X) ↔ Cardinal.mk X ≤ 2 := by
    sorry

end CAT_statement_S_0041
