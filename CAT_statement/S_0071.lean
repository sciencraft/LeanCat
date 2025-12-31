import Mathlib

open CategoryTheory

universe u v u' v'

variable {C : Type u} [Category.{v} C]
variable {D : Type u'} [Category.{v'} D]
variable (F : C ⥤ D)

theorem functor_faithful_iff_reflectsEpimorphisms_of_liftsEqualizers
    [CreatesLimitsOfShape Limits.WalkingParallelPair F] :
    F.Faithful ↔ F.ReflectsEpimorphisms := by
  sorry