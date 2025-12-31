import Mathlib
open CategoryTheory
universe u

theorem forget_CommGrp_to_Grp_admits_left_adjoint :
    (forget₂ CommGrp.{u} Grp.{u}).IsRightAdjoint := by
  sorry