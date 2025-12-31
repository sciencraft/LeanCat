import Mathlib

open CategoryTheory

theorem exists_sequence_of_distinct_adjoints_nat :
    ∃ G : ℕ → (ℕ ⥤ ℕ),
      Function.Injective G ∧
      (∀ x, (G 0).obj x = x + 1) ∧
      (∀ n, Nonempty (G (n + 1) ⊣ G n)) := by
  sorry