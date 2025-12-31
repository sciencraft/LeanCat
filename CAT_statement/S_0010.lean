import Mathlib

open CategoryTheory

def functor_involution : Grp.{u} ⥤ Type u where
  obj := fun G => { g : G.carrier |  g * g = 1 }
  map := fun {G H} f x => ⟨f.hom x.val, by
    refine Set.mem_setOf.mpr ?_
    rcases x with ⟨g, hg⟩
    simp only [Set.mem_setOf_eq] at hg
    rw [← f.hom.map_mul, hg]
    simp only [map_one]
    ⟩


theorem involution_functor_representable :
    CategoryTheory.Functor.IsCorepresentable functor_involution := by
  sorry