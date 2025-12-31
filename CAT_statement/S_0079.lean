import Mathlib

open CategoryTheory

variable {C : Type u} [Category.{v} C] [Preadditive C]

structure IsBilinear {X Y Z : C} (f : (Y ⟶ Z) → ((X ⟶ Y) → (X ⟶ Z))) : Prop where
  map_add_left : ∀ (a b : Y ⟶ Z) (g : X ⟶ Y),
    f (a + b) g = f a g + f b g

  map_add_right : ∀ (a : Y ⟶ Z) (g h : X ⟶ Y), f a (g + h) = f a g + f a h

  map_zero_left : ∀ (g : X ⟶ Y), f 0 g = 0

  map_zero_right : ∀ (a : Y ⟶ Z), f a 0 = 0


theorem compIsBilinear {X Y Z : C} :
    IsBilinear (fun (g : Y ⟶ Z) => (fun (f : (X ⟶ Y)) => f ≫ g)) := sorry
