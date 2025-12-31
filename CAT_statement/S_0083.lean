import Mathlib

open CategoryTheory

variable (p : ℕ) [Fact p.Prime]

theorem ZMod_simple : CategoryTheory.Simple (ModuleCat.of ℤ (ZMod p)) := by
  sorry