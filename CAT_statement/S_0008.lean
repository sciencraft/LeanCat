import Mathlib

open CategoryTheory Limits

universe u
variable {G H : Grp.{u}}


theorem freeProdGrp_iso_coprod [HasBinaryCoproduct G H] :
     Nonempty (Monoid.Coprod G H ≅ coprod G H) := by
  sorry
