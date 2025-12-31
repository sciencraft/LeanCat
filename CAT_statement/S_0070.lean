import Mathlib

open CategoryTheory Limits

variable {C : Type u} [Category.{v} C]
variable {D : Type u'} [Category.{v'} D]
variable (U : C ⥤ D)


theorem reflects_limits_iff_reflects_isomorphisms_preserves_limits
    [HasLimitsOfSize.{v, v} C]
    [PreservesLimitsOfSize.{v, v} U]
    [CategoryTheory.Functor.Faithful U]
:
    ReflectsLimitsOfSize.{v, v} U ↔ U.ReflectsIsomorphisms := by
  sorry
