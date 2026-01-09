import Mathlib

open CategoryTheory Limits

universe u
variable {G H : Grp.{u}}

def M : Bool → Type u
  | true  => G
  | false => H

instance : (b : Bool) → Group (M (G := G) (H := H) b) := by
  intro b
  cases b <;> dsimp [M] <;> infer_instance

abbrev FreeProdGrp : Grp.{u} :=
  Grp.of (Monoid.CoprodI (ι := Bool) (M := M (G := G) (H := H)))


theorem freeProdGrp_iso_coprod [HasBinaryCoproduct G H] :
     Nonempty (FreeProdGrp (G := G) (H := H) ≅ coprod G H):= by
  sorry
