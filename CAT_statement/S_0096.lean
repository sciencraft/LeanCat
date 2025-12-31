import Mathlib

open CategoryTheory

namespace CAT_statement_S_0096

universe u v


variable (R : Type u) [CommRing R]


abbrev intToR : ℤ →+* R := Int.castRingHom R

noncomputable abbrev U : ModuleCat.{max u v} R ⥤ ModuleCat.{max u v} ℤ :=
  ModuleCat.restrictScalars (intToR R)

noncomputable abbrev F : ModuleCat.{max u v} ℤ ⥤ ModuleCat.{max u v} R :=
  ModuleCat.extendScalars (intToR R)


noncomputable abbrev adj : F (R := R) ⊣ U (R := R) :=
  ModuleCat.extendRestrictScalarsAdj (intToR R)


noncomputable abbrev T : Monad (ModuleCat.{max u v} ℤ) :=
  (adj (R := R)).toMonad

theorem t_algebra_equiv_modulecat :
    Nonempty (Monad.Algebra (T (R := R)) ≌ ModuleCat.{max u v} R) := by
  sorry

end CAT_statement_S_0096
