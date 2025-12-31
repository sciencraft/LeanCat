import Mathlib

open CategoryTheory

class IsSplitMonoCategory (A : Type*) [Category A] where
  splitMonoOfMono {X Y : A} (f : X ⟶ Y) [Mono f] : Nonempty (SplitMono f)

class IsSplitEpiCategory (A : Type*) [Category A] where
  splitEpiOfEpi {X Y : A} (f : X ⟶ Y) [Epi f] : Nonempty (SplitEpi f)

variable {A : Type*} [Category A] [Preadditive A] [IsSplitMonoCategory A] [IsSplitEpiCategory A]

theorem schur_simple_monosimple_and_episimple
    (x : A) [NoZeroDivisors (End x)] :
    (∀ (y : A) (f : y ⟶ x) [Mono f], f = 0 ∨ IsIso f) ∧
    (∀ (y : A) (g : x ⟶ y) [Epi g], g = 0 ∨ IsIso g) := by
  sorry
