import Mathlib

open CategoryTheory Monad

namespace CAT_statement_S_0098

variable {C : Type*} [Category C]

structure AdjCat (T : Monad C) where
  D : Type*
  [category : Category D]
  F : Functor C D
  U : Functor D C
  adj : F ⊣ U
  monad_eq : T ≅ Adjunction.toMonad adj

namespace AdjCat

variable {T : Monad C}

instance (X : AdjCat T) : Category X.D := X.category

structure Hom (X Y : AdjCat T) where
  K : Functor (X.D) (Y.D)
  comm_left : X.F ⋙ K = Y.F
  comm_right : K ⋙ Y.U = X.U

instance : Category (AdjCat T) where
  Hom X Y := Hom X Y
  id X :=
    { K := Functor.id X.D
      comm_left := Functor.comp_id X.F
      comm_right := Functor.id_comp X.U }
  comp f g :=
    { K := f.K ⋙ g.K
      comm_left := by
        rewrite [<-Functor.assoc, f.comm_left]
        exact g.comm_left
      comm_right := by
        rewrite [Functor.assoc, g.comm_right]
        exact f.comm_right }

end AdjCat

variable (T : Monad C)

def kleisli_adj_obj : AdjCat T :=
  { D := Kleisli T
    F := Kleisli.Adjunction.toKleisli T
    U := Kleisli.Adjunction.fromKleisli T
    adj := Kleisli.Adjunction.adj T
    monad_eq :=
      { hom :=
          { app := fun X => 𝟙 (T.obj X)
            app_μ (X : C) := by
              simp
              rewrite [Kleisli.Adjunction.adj]
              simp
              rewrite [Equiv.refl]
              simp }
        inv :=
          { app := fun X => 𝟙 (T.obj X)
            app_μ (X : C) := by
              simp
              rewrite [Kleisli.Adjunction.adj]
              simp
              rewrite [Equiv.refl]
              simp } } }

theorem kleisli_initial : Nonempty (Limits.IsInitial (kleisli_adj_obj T)) := by
  sorry

def eilenberg_moore_adj_obj : AdjCat T :=
  { D := T.Algebra
    F := Monad.free T
    U := Monad.forget T
    adj := Monad.adj T
    monad_eq :=
      { hom := { app := fun X => 𝟙 (T.obj X) }
        inv := { app := fun X => 𝟙 (T.obj X) } } }

theorem eilenberg_moore_terminal : Nonempty (Limits.IsTerminal (eilenberg_moore_adj_obj T)) := by
  sorry

end CAT_statement_S_0098
