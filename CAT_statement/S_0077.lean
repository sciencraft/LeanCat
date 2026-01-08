import Mathlib

namespace CAT_statement_S_0077

open CategoryTheory Limits

universe u v

namespace CategoryTheory.Limits

open Limits Functor
variable {C : Type u} [Category.{v} C]

abbrev Psh (C : Type u) [Category.{v} C] : Type (max u (v + 1)) :=
  Cᵒᵖ ⥤ Type v


inductive RecObjectPresentation : Psh C → Type (max u (v + 1))
  | ofYoneda (X : C) :
      RecObjectPresentation ((yoneda : C ⥤ Psh C).obj X)
  | iso {A B : Psh C} (P : RecObjectPresentation A) (i : A ≅ B) :
      RecObjectPresentation B
  | reflexiveCoeq {A B : Psh C}
      (PA : RecObjectPresentation A) (PB : RecObjectPresentation B)
      (f g : A ⟶ B) [IsReflexivePair f g] [HasCoequalizer f g] :
      RecObjectPresentation (coequalizer f g)



structure IsRecObject (A : Psh C) : Prop where
  mk' :: nonempty_presentation : Nonempty (RecObjectPresentation  A)

theorem IsRecObject.mk (A : Psh C) (P : RecObjectPresentation A) :
    IsRecObject  A :=
  ⟨⟨P⟩⟩


theorem isRecObject_yoneda (X : C) :
    IsRecObject (C := C) ((yoneda : C ⥤ Psh C).obj X) :=
  ⟨⟨RecObjectPresentation.ofYoneda (C := C) X⟩⟩


theorem isRecObject_coequalizer
    {A B : Psh C} (hA : IsRecObject (C := C) A) (hB : IsRecObject (C := C) B)
    (f g : A ⟶ B) [IsReflexivePair f g] :
    IsRecObject (C := C) (coequalizer f g) := by
  classical
  rcases hA.nonempty_presentation with ⟨PA⟩
  rcases hB.nonempty_presentation with ⟨PB⟩
  letI : HasCoequalizer f g := by infer_instance
  exact ⟨⟨RecObjectPresentation.reflexiveCoeq (C := C) PA PB f g⟩⟩

end CategoryTheory.Limits

namespace CategoryTheory

open Limits

variable {C : Type u} [Category.{v} C]

variable (C) in

def Rec : Type (max u (v + 1)) :=
  ShrinkHoms (ObjectProperty.FullSubcategory (IsRecObject (C := C)))

noncomputable instance : Category.{max u v} (Rec C) :=
  inferInstanceAs <| Category.{max u v}
    (ShrinkHoms (ObjectProperty.FullSubcategory (IsRecObject (C := C))))


noncomputable def Rec.equivalence :
    Rec C ≌ ObjectProperty.FullSubcategory (IsRecObject (C := C)) :=
  (ShrinkHoms.equivalence _).symm

end CategoryTheory


namespace CategoryTheory.Limits
open Limits Functor
variable {C : Type u} [Category.{v} C]


structure SindObjectPresentation (A : Cᵒᵖ ⥤ Type v) where

  I : Type v

  [ℐ : SmallCategory I]
  [hI : IsSifted I]

  F : I ⥤ C

  ι : F ⋙ yoneda ⟶ (Functor.const I).obj A

  isColimit : IsColimit (Cocone.mk A ι)

namespace SindObjectPresentation


@[simps]
def yoneda (X : C) : SindObjectPresentation (yoneda.obj X) where
  I := Discrete PUnit.{v + 1}
  F := Functor.fromPUnit X
  ι := { app := fun _ => 𝟙 _ }
  isColimit :=
    { desc := fun s => s.ι.app ⟨PUnit.unit⟩
      uniq := fun _ _ h => h ⟨PUnit.unit⟩ }

end SindObjectPresentation


structure IsSindObject (A : Cᵒᵖ ⥤ Type v) : Prop where
  mk' :: nonempty_presentation : Nonempty (SindObjectPresentation A)

theorem IsSindObject.mk {A : Cᵒᵖ ⥤ Type v} (P : SindObjectPresentation A) : IsSindObject A :=
  ⟨⟨P⟩⟩


theorem isSindObject_yoneda (X : C) : IsSindObject (yoneda.obj X) :=
  .mk <| SindObjectPresentation.yoneda X

end CategoryTheory.Limits


namespace CategoryTheory

open Limits

variable {C : Type u} [Category.{v} C]

variable (C)  in

def Sind : Type (max u (v + 1)) :=
  ShrinkHoms (ObjectProperty.FullSubcategory (IsSindObject (C := C)))

noncomputable instance : Category.{max u v} (Sind C) :=
  inferInstanceAs <| Category.{max u v}
    (ShrinkHoms (ObjectProperty.FullSubcategory (IsSindObject (C := C))))

variable (C) in

noncomputable def Sind.equivalence :
    Sind C ≌ ObjectProperty.FullSubcategory (IsSindObject (C := C)) :=
  (ShrinkHoms.equivalence _).symm

end CategoryTheory


open CategoryTheory

theorem SindC_is_Ind_of_RecC {C : Type u} [SmallCategory C]  :
    Nonempty (Sind C ≌ Ind (Rec C)) := by
  sorry


end CAT_statement_S_0077
