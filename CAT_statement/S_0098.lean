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
  comm_left : X.F ⋙ K ≅ Y.F
  comm_right : K ⋙ Y.U ≅ X.U

@[ext]
lemma Hom.ext {X Y : AdjCat T} {f g : Hom X Y}
    (hK : f.K = g.K)
    (hcomm_left : HEq f.comm_left g.comm_left)
    (hcomm_right : HEq f.comm_right g.comm_right) : f = g := by
  cases f
  cases g
  cases hK
  cases hcomm_left
  cases hcomm_right
  rfl

def Hom.id (X : AdjCat T) : Hom X X :=
  { K := Functor.id X.D
    comm_left := Functor.rightUnitor X.F
    comm_right := Functor.leftUnitor X.U }

def Hom.comp {X Y Z : AdjCat T} (f : Hom X Y) (g : Hom Y Z) : Hom X Z :=
  { K := f.K ⋙ g.K
    comm_left :=
      (Functor.associator X.F f.K g.K).symm ≪≫
        isoWhiskerRight f.comm_left g.K ≪≫
        g.comm_left
    comm_right :=
      Functor.associator f.K g.K Z.U ≪≫
        isoWhiskerLeft f.K g.comm_right ≪≫
        f.comm_right }

instance : Category (AdjCat T) where
  Hom X Y := Hom X Y

  id := Hom.id
  comp := Hom.comp
  id_comp := by
    intro X Y f
    refine Hom.ext (f := Hom.comp (Hom.id X) f) (g := f) (Functor.id_comp f.K) ?_ ?_
    · cases Functor.id_comp f.K
      simpa using
        (show
          (Functor.associator X.F (Functor.id X.D) f.K).symm ≪≫
              isoWhiskerRight (Functor.rightUnitor X.F) f.K ≪≫
                f.comm_left = f.comm_left from by
            ext Z
            simp)
    · cases Functor.id_comp f.K
      simpa using
        (show
          Functor.associator (Functor.id X.D) f.K Y.U ≪≫
              isoWhiskerLeft (Functor.id X.D) f.comm_right ≪≫
                Functor.leftUnitor X.U = f.comm_right from by
            ext Z
            simp)
  comp_id := by
    intro X Y f
    refine Hom.ext (f := Hom.comp f (Hom.id Y)) (g := f) (Functor.comp_id f.K) ?_ ?_
    · cases Functor.comp_id f.K
      simpa using
        (show
          (Functor.associator X.F f.K (Functor.id Y.D)).symm ≪≫
              isoWhiskerRight f.comm_left (Functor.id Y.D) ≪≫
                Functor.rightUnitor Y.F = f.comm_left from by
            ext Z
            simp)
    · cases Functor.comp_id f.K
      simpa using
        (show
          Functor.associator f.K (Functor.id Y.D) Y.U ≪≫
              isoWhiskerLeft f.K (Functor.leftUnitor Y.U) ≪≫
                f.comm_right = f.comm_right from by
            ext Z
            simp)
  assoc := by
    intro W X Y Z f g h
    refine Hom.ext (f := Hom.comp (Hom.comp f g) h) (g := Hom.comp f (Hom.comp g h))
      (Functor.assoc f.K g.K h.K) ?_ ?_
    · cases Functor.assoc f.K g.K h.K
      simpa [Hom.comp, Category.assoc] using
        (show
          (Functor.associator W.F (f.K ⋙ g.K) h.K).symm ≪≫
              isoWhiskerRight
                  ((Functor.associator W.F f.K g.K).symm ≪≫
                    isoWhiskerRight f.comm_left g.K ≪≫
                      g.comm_left)
                  h.K ≪≫
                h.comm_left =
            (Functor.associator W.F f.K (g.K ⋙ h.K)).symm ≪≫
              isoWhiskerRight f.comm_left (g.K ⋙ h.K) ≪≫
                (Functor.associator X.F g.K h.K).symm ≪≫
                  isoWhiskerRight g.comm_left h.K ≪≫
                    h.comm_left from by
            ext A
            simp [Category.assoc])
    · cases Functor.assoc f.K g.K h.K
      simpa [Hom.comp, Category.assoc] using
        (show
          Functor.associator (f.K ⋙ g.K) h.K Z.U ≪≫
              isoWhiskerLeft (f.K ⋙ g.K) h.comm_right ≪≫
                Functor.associator f.K g.K Y.U ≪≫
                  isoWhiskerLeft f.K g.comm_right ≪≫
                    f.comm_right =
            Functor.associator f.K (g.K ⋙ h.K) Z.U ≪≫
              isoWhiskerLeft f.K
                  (Functor.associator g.K h.K Z.U ≪≫
                    isoWhiskerLeft g.K h.comm_right ≪≫
                      g.comm_right) ≪≫
                f.comm_right from by
            ext A
            simp [Category.assoc])

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
