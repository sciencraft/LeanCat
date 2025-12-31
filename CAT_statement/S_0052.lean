import Mathlib

open CategoryTheory Limits Functor Types Function Pullback

theorem Function.isPullback_pulllback {X Y Z : Type u} (f : X → Z) (g : Y → Z) :
    IsPullback (C := Type u) (fst (f := f) (g := g)) snd f g := by
  sorry