import Mathlib

open CategoryTheory Topology

universe u v w

variable {X : Type uX} [Category.{vX} X]

namespace CAT_statement_S_0039

structure ConcreteCat (X : Type v) [Category X] where
  C : Type u
  [cat : Category C]
  U : C ⥤ X
  [U_Faithful : U.Faithful]

attribute [instance] ConcreteCat.cat ConcreteCat.U_Faithful


def IsConcreteFunc {A B : ConcreteCat (X := X)} (F : A.C ⥤ B.C) : Prop :=
  Nonempty ((F ⋙ B.U) ≅ A.U)

def forgetFrm : Frm.{u} ⥤ Type u where
  obj X := X
  map {X Y} f := f


instance : forgetFrm.Faithful  where
  map_injective {X Y} f g h := by
    ext x
    simpa using congrArg (fun k => k x) h


structure T0TopCat where
  toTop : TopCat.{u}
  is_t0 : T0Space (↑toTop)

namespace T0TopCat

instance : CoeSort T0TopCat (Type u) := ⟨fun X => X.toTop⟩
instance (X : T0TopCat) : TopologicalSpace X := X.toTop.str
attribute [instance] T0TopCat.is_t0


instance : Category T0TopCat :=
  InducedCategory.category (fun X : T0TopCat => X.toTop)


def forget_0 : T0TopCat ⥤ TopCat :=
  inducedFunctor (fun X : T0TopCat => X.toTop)


instance : forget_0.Faithful  :=
{ map_injective := by
    intro X Y f g h
    simpa [forget_0] using h }


@[simp] def of (X : Type u) [TopologicalSpace X] [T0Space X] : T0TopCat :=
  ⟨TopCat.of X, inferInstance⟩


def L : T0TopCatᵒᵖ ⥤ Type u :=
{ obj := fun X => TopologicalSpace.Opens ((X.unop).toTop)
  map := by
    intro ⟨X⟩ ⟨Y⟩ ⟨f⟩
    obtain ⟨g⟩ : (Y.toTop ⟶ X.toTop) := forget_0.map f
    intro U
    exact TopologicalSpace.Opens.comap g U
  map_id := by
    intro X
    ext U x
    rfl
  map_comp := by
    intro X Y Z f g
    ext U x
    rfl }

instance : L.Faithful where
  map_injective {X Y} f g h := by
    apply Quiver.Hom.unop_inj
    apply Functor.map_injective T0TopCat.forget_0
    ext x
    haveI : T0Space (T0TopCat.forget_0.obj (Opposite.unop X)) := (Opposite.unop X).is_t0
    apply Inseparable.eq
    rw [inseparable_iff_forall_isOpen]
    intro U hU
    let U_op : TopologicalSpace.Opens (T0TopCat.forget_0.obj (Opposite.unop X)) := ⟨U, hU⟩
    have h_eq := congr_fun h U_op
    dsimp [L] at h_eq
    have h_set := congr_arg (SetLike.coe) h_eq
    rw [Set.ext_iff] at h_set
    exact h_set x

end T0TopCat


def FrmConcrete : ConcreteCat (X := Type u) :=
{ C := Frm.{u}
  U := (forgetFrm) }

def T0TopCatopConcrete : ConcreteCat (X := Type u) :=
{ C := T0TopCatᵒᵖ
  U := (T0TopCat.L) }

def ConcreteFuncsIso (A B : ConcreteCat (X := Type u)) : Type _ :=
  { F : A.C ⥤ B.C // IsConcreteFunc (A := A) (B := B) F }

theorem unique_concrete_functors_from_T0TopCatop_to_Frm_iso :
    Nat.card (ConcreteFuncsIso T0TopCatConcrete FrmConcrete) = 1 := by
  sorry

end CAT_statement_S_0039
