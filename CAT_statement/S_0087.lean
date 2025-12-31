import Mathlib

open CategoryTheory Limits

variable {A : Type u} [Category.{v} A] [Abelian A]

def IsSemisimple (A : Type u) [Category.{v} A] [Abelian A] : Prop :=
  ∀ (S : ShortComplex A), S.ShortExact → Nonempty S.Splitting

theorem isSemisimple_iff_injective_iff_projective :
    (IsSemisimple A ↔ ∀ (X : A), Injective X) ∧ 
    (IsSemisimple A ↔ ∀ (X : A), Projective X) := by
  sorry