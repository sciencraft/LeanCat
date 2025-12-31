import Mathlib

open CategoryTheory Limits

universe v u u'

namespace CAT_statement_S0100

variable {C : Type u} [Category.{v} C]
variable {D : Type u'} [Category.{v} D]

variable (F : C ⥤ D) (G : D ⥤ C)
variable (adj : F ⊣ G)

abbrev FG : D ⥤ D := G ⋙ F

abbrev K : D ⥤ (adj.toMonad).Algebra :=
  Monad.comparison adj

abbrev epsFG (d : D) :
    (FG (F := F) (G := G)).obj ((FG (F := F) (G := G)).obj d)
      ⟶ (FG (F := F) (G := G)).obj d :=
  adj.counit.app ((FG (F := F) (G := G)).obj d)

abbrev FGeps (d : D) :
    (FG (F := F) (G := G)).obj ((FG (F := F) (G := G)).obj d)
      ⟶ (FG (F := F) (G := G)).obj d :=
  (FG (F := F) (G := G)).map (adj.counit.app d)

def counitCofork (d : D) :
    Cofork (epsFG (F := F) (G := G) adj d) (FGeps (F := F) (G := G) adj d) :=
  Cofork.ofπ (adj.counit.app d) (by

    simp [epsFG, FGeps]
  )


def cond1 : Prop :=
  (K (F := F) (G := G) adj).Full ∧ (K (F := F) (G := G) adj).Faithful


def cond2 : Prop :=
  ∀ d : D, Nonempty (IsColimit (counitCofork (F := F) (G := G) adj d))


def IsRegularEpi' {X Y : D} (f : X ⟶ Y) : Prop :=
  Nonempty (RegularEpi f)


def ReflectsSplitEpiToRegularEpi' (G : D ⥤ C) : Prop :=
  ∀ {X Y : D} (f : X ⟶ Y), IsSplitEpi (G.map f) → IsRegularEpi' (D := D) f

def cond3 : Prop :=
  ReflectsSplitEpiToRegularEpi' (G := G)


theorem K_fullyFaithful_tfae :
    List.TFAE
      [cond1 (F := F) (G := G) adj,
       cond2 (F := F) (G := G) adj,
       cond3 (G := G)] := by
  sorry

end CAT_statement_S0100
