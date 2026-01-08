import Mathlib

open CategoryTheory Limits

namespace CAT_statement_S_0066

universe u v
variable {C : Type u} [Category.{v} C]

def IsIntersectionOf {B : C} (A : Subobject B) (S : Set (Subobject B)) : Prop :=
   (∀ Ai, Ai ∈ S → A ≤ Ai) ∧
  (∀ A' : Subobject B, (∀ Ai, Ai ∈ S → A' ≤ Ai) → A' ≤ A)

def HasIntersections (C : Type u) [Category.{v} C]: Prop :=
  ∀ (B : C) (S : Set (Subobject B)),
    ∃ A : Subobject B, IsIntersectionOf (C := C) (B := B) A S

class StronglyComplete (C : Type u) [Category.{v} C] : Prop where
  complete: HasLimits C
  hasinter: HasIntersections C

class StronglyCocomplete (C : Type u) [Category.{v} C] : Prop where
  dual: StronglyComplete (C:=Cᵒᵖ)


theorem exists_cocomplete_separator_not_wellPowered_not_coWellPowered :
    ∃ (C : Type u) (_ : Category.{v} C),
    StronglyCocomplete C ∧ HasSeparator C ∧
    ¬ WellPowered.{v} C ∧ ¬ WellPowered.{v} Cᵒᵖ := by
  sorry

end CAT_statement_S_0066
