import Mathlib
open CategoryTheory Polynomial Limits

universe u

namespace CAT_statement_S_0067

variable (k : Type u) [Field k]

noncomputable def F : Natᵒᵖ ⥤ RingCat :=
  {
    obj := fun ⟨n⟩ => RingCat.of ((k[X] ⧸ Ideal.span {(X ^ n : k[X])}))
    map := fun {A B} f => match A, B with
      | ⟨n⟩, ⟨m⟩ => match f with
        | ⟨⟨⟨(f : m ≤ n)⟩⟩⟩ =>
          RingCat.ofHom (Ideal.Quotient.factor (Ideal.span_singleton_le_span_singleton.mpr (pow_dvd_pow X f)))
  }

lemma quotCommTrunc {n : ℕ} (p : k[X]) : (PowerSeries.trunc n p : k[X]) = (p : k[X] ⧸ Ideal.span {(X ^ n : k[X])}) := by
  rw [Ideal.Quotient.eq, Ideal.mem_span_singleton, X_pow_dvd_iff]
  intro d hd
  simp [PowerSeries.coeff_trunc, hd]

noncomputable def truncQuot (n : ℕ) : PowerSeries k →+* RingCat.of ((k[X] ⧸ Ideal.span {(X ^ n : k[X])})) where
  toFun := fun x => PowerSeries.trunc n x
  map_zero' := by simp
  map_one' := by
    match n with
    | 0 => rw [show X^0 = 1 by simp, Ideal.span_singleton_one]
           simp [Ideal.Quotient.zero_eq_one_iff]
    | n + 1 => simp
  map_add' := by simp
  map_mul' := fun x y => by
    rw [← PowerSeries.trunc_trunc_mul_trunc, ← coe_mul, ← (Ideal.Quotient.mk _).map_mul, quotCommTrunc k _]

noncomputable def cone_F : Cone (F k) :=
  {
    pt := RingCat.of (PowerSeries k)
    π := {
      app := fun ⟨n⟩ => RingCat.ofHom (truncQuot k n)
      naturality := by
        rintro ⟨n⟩ ⟨m⟩ ⟨⟨⟨(l : m ≤ n)⟩⟩⟩
        ext (x : PowerSeries k)
        simp [F, truncQuot, ← PowerSeries.trunc_trunc_of_le x l, quotCommTrunc k]
    }
  }

theorem power_series_islimit : Nonempty (IsLimit (cone_F k)) := by
  sorry

end CAT_statement_S_0067
