import Mathlib

open CategoryTheory

namespace CAT_statement_S_0040

universe u v w

variable {X : Type uX} [Category.{vX} X]

structure ConcreteCat (X : Type v) [Category X] where
  C : Type u
  [cat : Category C]
  U : C ⥤ X
  [U_Faithful : U.Faithful]

attribute [instance] ConcreteCat.cat ConcreteCat.U_Faithful


abbrev StructuredArrowOver (x : X) (C : ConcreteCat (X := X)): Type _ :=
  StructuredArrow x C.U


def IsUniversalArrowOver (x : X) {C : ConcreteCat (X := X)}  (u : StructuredArrowOver x C) : Prop :=
  ∀ (v : StructuredArrowOver x C),
    ∃! (g : u.right ⟶ v.right), u.hom ≫ C.U.map g = v.hom


def IsFreeObjectOver (x : X) {C : ConcreteCat (X := X)} (z : C.C) : Prop :=
  ∃ (f : StructuredArrowOver x C), f.right = z ∧ IsUniversalArrowOver (x := x) (C := C) f

def HasFreeObject (C : ConcreteCat (X := X)) : Prop :=
  ∀ (x : X), ∃ (z : C.C), IsFreeObjectOver (x := x) (z := z)


structure SupLatCat where
  carrier : Type u
  [inst : CompleteSemilatticeSup carrier]

attribute [instance] SupLatCat.inst

instance : CoeSort SupLatCat (Type u) := ⟨SupLatCat.carrier⟩


def of (α : Type u) [CompleteSemilatticeSup α] : SupLatCat := ⟨α⟩


structure Hom (A B : SupLatCat.{u}) where
  toFun : A → B
  map_sSup' : ∀ s : Set A, toFun (sSup s) = sSup (toFun '' s)

instance (A B : SupLatCat) : CoeFun (Hom A B) (fun _ => A → B) := ⟨Hom.toFun⟩

@[simp] lemma Hom.map_sSup {A B : SupLatCat} (f : Hom A B) (s : Set A) :
    f (sSup s) = sSup (f '' s) :=
  f.map_sSup' s

@[ext] lemma Hom.ext {A B : SupLatCat} {f g : Hom A B}
    (h : ∀ a, f a = g a) : f = g := by
  cases f with
  | mk fto fmap =>
    cases g with
    | mk gto gmap =>
      have hto : fto = gto := funext (by intro a; exact h a)
      cases hto
      have : fmap = gmap := by
        apply Subsingleton.elim
      cases this
      rfl


def id (A : SupLatCat) : Hom A A :=
{ toFun := (_root_.id : A → A)
  map_sSup' := by
    intro s
    simp }


def comp {A B C : SupLatCat} (f : Hom A B) (g : Hom B C) : Hom A C :=
  { toFun := fun a => g (f a)
    map_sSup' := by
      intro s
      calc
        g (f (sSup s)) = g (sSup (f '' s)) := by
          simp
        _ = sSup (g '' (f '' s)) := by
          simp
        _ = sSup ((fun x => g (f x)) '' s) := by
          simp [Set.image_image] }


instance : Category SupLatCat where
  Hom A B := Hom A B
  id A := id A
  comp f g := comp f g
  id_comp := by intro A B f; ext a; rfl
  comp_id := by intro A B f; ext a; rfl
  assoc := by intro A B C D f g h; ext a; rfl


def forget : SupLatCat ⥤ Type u :=
{ obj := fun A => A.carrier
  map := fun {X Y} (f : X ⟶ Y) => f.toFun
  map_id := by intro A; rfl
  map_comp := by intro A B C f g; rfl }


instance : forget.Faithful  where
  map_injective := by
    intro X Y f g h
    apply Hom.ext
    intro x
    simpa using congrArg (fun k => k x) h

def SupLatCatConcrete : ConcreteCat (X := Type u) :=
{ C := SupLatCat.{u}
  U := (forget) }


theorem SupLat_Has_Free_Object :
    HasFreeObject SupLatCatConcrete:= by
  sorry


end CAT_statement_S_0040
