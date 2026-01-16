import Mathlib

open CategoryTheory Limits

universe u v w u₁ v₁

namespace CAT_statement_S_0074

noncomputable section


abbrev Pro (C : Type u) [Category.{v} C] : Type (max u (v + 1)) := (Ind (Cᵒᵖ))ᵒᵖ


abbrev proYoneda (C : Type u) [SmallCategory C] : C ⥤ Pro C :=
  CategoryTheory.opOp C ⋙ (CategoryTheory.Ind.yoneda (C := Cᵒᵖ)).op


def HasCofilteredColimits (L : Type u₁) [Category.{v₁} L] : Prop :=
  ∀ (J : Type w) [SmallCategory J] [IsCofiltered J], HasColimitsOfShape J L


def IsFinitelyCopresentable {L : Type u₁} [Category.{v₁} L] (X : L) : Prop :=
  CategoryTheory.IsFinitelyPresentable.{w} (C := Lᵒᵖ) (Opposite.op X)


def IsCofilteredColimitOf
    {C : Type u} [SmallCategory C] {L : Type u₁} [Category.{v₁} L]
    (ι : C ⥤ L) (X : L) : Prop :=
  ∃ (J : Type w) (hJ : SmallCategory J) (hC : IsCofiltered J), by

    let _ := hJ
    let _ := hC
    exact ∃ (F : J ⥤ C) (t : Cocone (F ⋙ ι)),
      Nonempty (IsColimit t) ∧ Nonempty (t.pt ≅ X)


def IsProCompletion
    {C : Type u} [SmallCategory C] {L : Type u₁} [Category.{v₁} L]
    (ι : C ⥤ L) : Prop :=
  ∃ (e : L ≌ Pro C), Nonempty (ι ⋙ e.functor ≅ proYoneda C)


def ProCompletionConditions
    {C : Type u} [SmallCategory C] {L : Type u₁} [Category.{v₁} L]
    (ι : C ⥤ L) : Prop :=
  HasCofilteredColimits.{w} L ∧
    (∀ X : L, IsCofilteredColimitOf.{u, w} ι X) ∧
      (∀ c : C, IsFinitelyCopresentable.{w} (ι.obj c))


theorem isProCompletion_iff_intrinsic_conditions
    {C : Type u} [SmallCategory C] {L : Type u₁} [Category.{v₁} L]
    (ι : C ⥤ L) [CategoryTheory.Functor.Full ι] [CategoryTheory.Functor.Faithful ι] :
    IsProCompletion (ι := ι) ↔ ProCompletionConditions (ι := ι) := by
  sorry

end

end CAT_statement_S_0074
