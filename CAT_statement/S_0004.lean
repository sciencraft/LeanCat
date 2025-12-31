import Mathlib

open CategoryTheory

universe u

def fromTerminalFunctor : Type u ⥤ Type u where
  obj α := PUnit.{u} → α
  map {α β} (f : α → β) := fun g => f ∘ g
  map_id := by
    intro α
    funext g x
    rfl
  map_comp := by
    intro α β γ f g
    funext h x
    rfl


theorem fromTerminalEquivalence : fromTerminalFunctor.IsEquivalence := sorry