import Mathlib

namespace CAT_statement_S_0075

open CategoryTheory Limits

universe u v

namespace CategoryTheory.Limits
open Limits Functor
variable {C : Type u} [Category.{v} C]

variable (C)  in

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

variable (C) [LocallySmall C] in

def Rec : Type (max u (v + 1)) :=
  ShrinkHoms (ObjectProperty.FullSubcategory (IsRecObject (C := C)))

noncomputable instance : Category.{max u v} (Rec C) :=
  inferInstanceAs <| Category.{max u v}
    (ShrinkHoms (ObjectProperty.FullSubcategory (IsRecObject (C := C))))


noncomputable def Rec.equivalence :
    Rec C ≌ ObjectProperty.FullSubcategory (IsRecObject (C := C)) :=
  (ShrinkHoms.equivalence _).symm

theorem sifted_with_pullbacks_Rec_is_filtered {C : Type u} [Category.{v} C]
    [IsSifted C] [HasPullbacks C] :
    IsFiltered (Rec C) := by
  sorry

end CategoryTheory

end CAT_statement_S_0075
