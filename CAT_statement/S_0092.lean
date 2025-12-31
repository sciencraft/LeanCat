import Mathlib

open CategoryTheory Limits

variable {R : Type u} [CommRing R]


theorem ModuleCat.forgetReflectsColimits :
    Nonempty (ReflectsColimits (forget₂ (ModuleCat R) AddCommGrp)) :=
    sorry