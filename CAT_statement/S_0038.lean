import Mathlib

namespace CAT_statement_S_0038

open CategoryTheory Limits

universe u v w

variable {C : Type u} [Category C] [HasFiniteLimits C]

def IsConcretizable (X : Type v) [Category X] (D: Type u) [Category D] : Prop :=
  ∃ (U : D ⥤ X), U.Faithful

variable (C)

class RegularWellPowered : Prop where
  regularSubobject_small : ∀ (X : C), Small.{v} { P : Subobject X //  Nonempty (RegularMono P.arrow) }

theorem concretizable_iff_regular_wellpowered :
    IsConcretizable (Type u) C ↔ RegularWellPowered C := by
  sorry

end CAT_statement_S_0038
