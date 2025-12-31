import Mathlib

namespace CAT_statement_S_0078

open CategoryTheory Limits Functor

universe u v

namespace CategoryTheory

namespace Limits

variable {C : Type u} [Category.{v} C]


structure SindObjectPresentation (A : Cᵒᵖ ⥤ Type v) where
  I : Type v
  [ℐ : SmallCategory I]
  [hI : IsSifted I]
  F : I ⥤ C
  ι : F ⋙ yoneda ⟶ (Functor.const I).obj A
  isColimit : IsColimit (Cocone.mk A ι)


structure IsSindObject (A : Cᵒᵖ ⥤ Type v) : Prop where
  mk' :: nonempty_presentation : Nonempty (SindObjectPresentation A)

theorem IsSindObject.mk {A : Cᵒᵖ ⥤ Type v} (P : SindObjectPresentation A) : IsSindObject A :=
  ⟨⟨P⟩⟩

end Limits

namespace Functor

def weightedColimitFunctor {J : Type v} [SmallCategory J] {E : Type u} [Category.{v} E]
    (W : Jᵒᵖ ⥤ Type v) (G : J ⥤ E) : E ⥤ Type v where
      obj X := W ⟶ G.op ⋙ (yoneda.obj X)
      map f h := h ≫ (NatTrans.id G.op ◫ yoneda.map f)


abbrev WeightedColimitData {J : Type v} [SmallCategory J] {E : Type u} [Category.{v} E]
    (W : Jᵒᵖ ⥤ Type v) (G : J ⥤ E) (colim : E) :=
  (weightedColimitFunctor W G).CorepresentableBy colim


abbrev HasWeightedColimit {J : Type v} [SmallCategory J] {E : Type u} [Category.{v} E]
    (W : Jᵒᵖ ⥤ Type v) (G : J ⥤ E) :=
  (weightedColimitFunctor W G).IsCorepresentable


noncomputable def weightedColimit {J : Type v} [SmallCategory J] {E : Type u} [Category.{v} E]
    (W : Jᵒᵖ ⥤ Type v) (G : J ⥤ E) [h : HasWeightedColimit W G] : E :=
  h.has_corepresentation.choose

noncomputable def weightedColimitData {J : Type v} [SmallCategory J] {E : Type u} [Category.{v} E]
    (W : Jᵒᵖ ⥤ Type v) (G : J ⥤ E) [h : HasWeightedColimit W G] :
    WeightedColimitData W G (weightedColimit W G) :=
  h.has_corepresentation.choose_spec.some

end Functor

end CategoryTheory

open CategoryTheory Limits Functor

variable {C D : Type u} [SmallCategory C] [SmallCategory D]

def lanDiagram (F : C ⥤ D) : C ⥤ (Dᵒᵖ ⥤ Type u) := F ⋙ yoneda


noncomputable def lanPresheaf (F : C ⥤ D) (φ : Cᵒᵖ ⥤ Type u)
    [HasWeightedColimit φ (lanDiagram F)] : Dᵒᵖ ⥤ Type u :=
  weightedColimit φ (lanDiagram F)


theorem isSindObject_iff_isSindObject_lanPresheaf
    (I : C ⥤ D) [Full I] [Faithful I] (φ : Cᵒᵖ ⥤ Type u)
    [HasWeightedColimit φ (lanDiagram I)] :
    IsSindObject φ ↔ IsSindObject (lanPresheaf I φ) := by
  sorry

end CAT_statement_S_0078
