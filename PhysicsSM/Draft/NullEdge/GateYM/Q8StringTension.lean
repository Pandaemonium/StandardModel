import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FiniteNonabelianChar

/-!
# Gate YM: a concrete NONABELIAN (Q₈, dim-2) strong-coupling string tension

This file turns the dimension-weighted character dominance for the quaternion
group `Q₈ = QuaternionGroup 2` (its genuine 2-dimensional irrep `R2`, see
`FiniteNonabelianChar.lean`) into a concrete strong-coupling **string
tension / area-law** statement.  It is the FIRST genuinely-nonabelian (`Q₈`,
`dim = 2`) concrete string tension in the program.

## What is proved (no `sorry`, no new `axiom`, no `native_decide`)

* **Normalized fusion eigenvalue.**  `gamma2 β = c_R / (dim(R) · c_triv)` with
  `dim(R) = 2` the dimension of the 2-dim irrep, `c_R = charCoeff β MQ8 R2` and
  `c_triv = trivCoeff β MQ8` (`gamma2`).

* **Positivity of the trivial coefficient.**  `0 < trivCoeff β MQ8`
  (`trivCoeff_pos`): the denominator of `gamma2` is a genuine positive normalizer
  (a `(1/8)`-average of the strictly positive Wilson weights over `Q₈`).

* **Contraction `‖gamma2 β‖ ≤ 1`** (`gamma2_norm_le_one`), directly from the
  nonabelian dimension-weighted bound
  `FiniteNonabelianChar.q8_charCoeff_abs_le_dim_mul_trivCoeff`.

* **Nonnegative string tension.**  `sigma2 β = -log ‖gamma2 β‖ ≥ 0`
  (`sigma2_nonneg`), and, under an explicit strong-coupling hypothesis
  `0 < ‖gamma2 β‖ < 1`, a strictly positive tension `sigma2 β > 0`
  (`sigma2_pos`).

* **Area law.**  `‖gamma2 β‖ ^ A = exp(-sigma2 β · A)` (`gamma2_pow_eq_exp`) and,
  given a (modeled) factorization hypothesis `‖⟨W⟩‖ ≤ ‖gamma2 β‖ ^ A` for a
  Wilson loop of area `A`, the exponential area-law bound
  `‖⟨W⟩‖ ≤ exp(-sigma2 β · A)` (`area_law`).

## Honesty / scope

`Q₈` is a *finite* nonabelian group, a discrete stand-in for a nonabelian gauge
group; the loop factorization `‖⟨W⟩‖ ≤ ‖gamma2‖ ^ A` is a *modeled* hypothesis,
not derived from a continuum path integral.  This is NOT continuum `SU(N)`
Yang-Mills.  What is genuinely nonabelian and concrete is the input: the `dim = 2`
irrep of `Q₈` has `‖χ₂(-1)‖ = 2 > 1`, so the abelian `‖χ‖ ≤ 1` bound is
inapplicable and the honest dimension-weighted bound with its `dim = 2` factor is
what drives `‖gamma2‖ ≤ 1` and hence `sigma2 ≥ 0`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace Q8StringTension

open scoped ComplexConjugate BigOperators
open QuaternionGroup
open FiniteNonabelianChar

/-! ## Section A. Positivity of the normalizer `c_triv` -/

/-
**The trivial coefficient is strictly positive.**  `trivCoeff β MQ8` is the
`(1/8)`-average over `Q₈` of the strictly positive Wilson weights
`w(g) = exp(β · Re χ_ρ(g)) > 0`, hence positive.
-/
theorem trivCoeff_pos (beta : ℝ) : 0 < trivCoeff beta MQ8 := by
  refine' mul_pos ( inv_pos.mpr ( Nat.cast_pos.mpr ( Fintype.card_pos ) ) ) ( Finset.sum_pos _ _ );
  · exact fun _ _ => Real.exp_pos _;
  · exact ⟨ 1, Finset.mem_univ _ ⟩

/-! ## Section B. The normalized fusion eigenvalue and its contraction -/

/-- **Normalized `Q₈` fusion eigenvalue** for the 2-dim irrep:
`gamma2 β = c_R / (dim(R) · c_triv)` with `dim(R) = 2`,
`c_R = charCoeff β MQ8 R2`, `c_triv = trivCoeff β MQ8`. -/
noncomputable def gamma2 (beta : ℝ) : ℂ :=
  charCoeff beta MQ8 R2 / (2 * (trivCoeff beta MQ8 : ℂ))

/-
**Contraction of the fusion eigenvalue.**  `‖gamma2 β‖ ≤ 1`, directly from
the nonabelian dimension-weighted bound
`q8_charCoeff_abs_le_dim_mul_trivCoeff`: `‖c_R‖ ≤ 2 · c_triv` and `c_triv > 0`.
-/
theorem gamma2_norm_le_one (beta : ℝ) : ‖gamma2 beta‖ ≤ 1 := by
  convert div_le_one_of_le₀ ( FiniteNonabelianChar.q8_charCoeff_abs_le_dim_mul_trivCoeff beta ) ( mul_nonneg zero_le_two ( le_of_lt ( trivCoeff_pos beta ) ) ) using 1;
  unfold gamma2;
  norm_num [ abs_of_pos ( trivCoeff_pos beta ) ]

/-! ## Section C. The string tension -/

/-- **Q₈ string tension** for the 2-dim irrep: `sigma2 β = -log ‖gamma2 β‖`. -/
noncomputable def sigma2 (beta : ℝ) : ℝ := - Real.log ‖gamma2 beta‖

/-
**Nonnegative string tension.**  `sigma2 β ≥ 0`, since `0 ≤ ‖gamma2 β‖ ≤ 1`
gives `log ‖gamma2 β‖ ≤ 0`.
-/
theorem sigma2_nonneg (beta : ℝ) : 0 ≤ sigma2 beta := by
  apply neg_nonneg_of_nonpos; exact Real.log_nonpos (norm_nonneg _) (gamma2_norm_le_one beta)

/-
**Strictly positive string tension under strong coupling.**  If the fusion
eigenvalue is strictly contracting (`0 < ‖gamma2 β‖ < 1`, the explicit
strong-coupling hypothesis), then `sigma2 β > 0`.
-/
theorem sigma2_pos (beta : ℝ) (hpos : 0 < ‖gamma2 beta‖)
    (hstrong : ‖gamma2 beta‖ < 1) : 0 < sigma2 beta := by
      exact neg_pos_of_neg ( Real.log_neg hpos hstrong )

/-! ## Section D. The area law -/

/-
**Exponential repackaging.**  For a strictly contracting eigenvalue
(`0 < ‖gamma2 β‖`), `‖gamma2 β‖ ^ A = exp(-sigma2 β · A)`.
-/
theorem gamma2_pow_eq_exp (beta : ℝ) (A : ℕ) (hpos : 0 < ‖gamma2 beta‖) :
    ‖gamma2 beta‖ ^ A = Real.exp (- sigma2 beta * A) := by
  have h : - sigma2 beta * (A : ℝ) = (A : ℝ) * Real.log ‖gamma2 beta‖ := by
    unfold sigma2; ring
  rw [h, Real.exp_nat_mul, Real.exp_log hpos]

/-
**Area law for the Q₈ 2-dim Wilson loop.**  Given the (modeled)
factorization hypothesis `‖⟨W⟩‖ ≤ ‖gamma2 β‖ ^ A` for a Wilson loop `W` enclosing
area `A`, together with a strictly contracting eigenvalue `0 < ‖gamma2 β‖`, the
expectation obeys the exponential area law
`‖⟨W⟩‖ ≤ ‖gamma2 β‖ ^ A = exp(-sigma2 β · A)`.
-/
theorem area_law (beta : ℝ) (A : ℕ) (hpos : 0 < ‖gamma2 beta‖)
    (W : ℂ) (hfact : ‖W‖ ≤ ‖gamma2 beta‖ ^ A) :
    ‖W‖ ≤ Real.exp (- sigma2 beta * A) := by
      exact hfact.trans_eq ( gamma2_pow_eq_exp beta A hpos )

end Q8StringTension
end GateYM
end NullEdge
end Draft
end PhysicsSM
