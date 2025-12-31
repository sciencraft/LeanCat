import Mathlib

open CategoryTheory Limits


theorem forget_Top_faithful_not_full :
    (forget TopCat).Faithful ∧ ¬ (forget TopCat).Full := by
  sorry


theorem forget_Grp_faithful_not_full :
    (forget Grp).Faithful ∧ ¬ (forget Grp).Full := by
  sorry


theorem forget_Ring_Ab_faithful_not_full :
    (forget₂ RingCat Ab).Faithful ∧ ¬ (forget₂ RingCat Ab).Full := by
  sorry


theorem forget_TopPointed_faithful_not_full :
    (Under.forget (terminal TopCat)).Faithful ∧ ¬ (Under.forget (terminal TopCat)).Full := by
  sorry