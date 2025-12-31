import Mathlib

open CategoryTheory Limits

variable {C : Type u} [Category.{v} C]

theorem hasColimits_iff_hasCoprod_of_separator
    [HasLimits C]
    [WellPowered C]
    [WellPowered Cᵒᵖ]
    (S : C) (hS : IsSeparator S) :
    HasColimits C ↔ ∀ (I : Type v), HasColimit (Discrete.functor (fun (_ : I) => S)) := by
  sorry