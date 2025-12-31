import Mathlib

open CategoryTheory Limits

variable {C : Type u} [SmallCategory C]
variable {D : Type u} [SmallCategory D]
variable (F G : C ⥤ D)

def homIntegrandBifunctor : Cᵒᵖ × C ⥤ Type u :=
  (Functor.prod F.op G) ⋙ (Functor.hom D)


theorem natTransIsoEnd :
    Nonempty (NatTrans F G ≅ end_ (curryObj (homIntegrandBifunctor F G))) := by
  sorry
