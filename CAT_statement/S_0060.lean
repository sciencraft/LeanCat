import Mathlib

open CategoryTheory Limits

theorem has_initial_of_locally_small_complete_coseparating {ℬ : Type u} [Category.{v} ℬ] 
    [LocallySmall.{w} ℬ] [HasLimitsOfSize.{w, w} ℬ] {S : Set ℬ} [Small.{w} S] 
    (hS : IsCoseparating S) (h : ∀ (A : ℬ), ∀ (s : Set (Subobject A)), ∃ (f : Subobject A), 
    IsGLB s f) : HasInitial ℬ := by
  sorry