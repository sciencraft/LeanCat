import Mathlib

open CategoryTheory

universe v u

abbrev Pro (C : Type u) [Category.{v, u} C] : Type (max u (v + 1)) := (Ind (Cᵒᵖ))ᵒᵖ

theorem pro_fintypecat_equiv_profinite : Nonempty ((Pro (FintypeCat)) ≌ Profinite) := sorry
