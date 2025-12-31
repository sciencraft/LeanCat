import Mathlib

open CategoryTheory Monad

universe u₁ u₂ v₁

variable {C : Type u₁} [Category.{v₁} C] {D : Type u₂} [Category.{v₁} D]
variable (F : C ⥤ D) (G : D ⥤ C) (adj : F ⊣ G)

theorem comparison_adjunction
    [∀ (A : adj.toMonad.Algebra), Limits.HasCoequalizer (F.map A.a) (adj.counit.app (F.obj A.A))] :
    ∃ K : adj.toMonad.Algebra ⥤ D, Nonempty (K ⊣ comparison adj) := by
    sorry
