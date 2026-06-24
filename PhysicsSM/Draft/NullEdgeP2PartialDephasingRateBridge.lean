import Mathlib.Tactic

/-!
# P2 partial dephasing rate bridge

This draft module gives a finite one-step scaffold for the proposed
proper-time / purity rate law.

In the two-level real chiral proxy `[[q,c],[c,1-q]]`, an observer/dephasing
channel that contracts the off-diagonal coherence `c |-> a*c` changes the
determinant, purity, and normalized mass-ratio-square by exact algebraic
amounts. This is not a continuous-time dynamics theorem; it is the finite
one-step identity a rate law should approximate when `a` is close to `1`.
-/

namespace PhysicsSM.Draft.NullEdgeP2PartialDephasingRateBridge

/-- Determinant of the two-level real chiral proxy after coherence value `c`. -/
def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

/-- Purity of the two-level real chiral proxy. -/
def chiralPurity (q c : Real) : Real :=
  q ^ 2 + (1 - q) ^ 2 + 2 * c ^ 2

/-- Normalized mass-ratio-square proxy `4 det rho` for a trace-one `2 x 2`
block. -/
def massRatioSq (q c : Real) : Real :=
  4 * chiralDet q c

/--
Partial dephasing `c |-> a*c` increases determinant by exactly
`(1 - a^2)c^2`.
-/
theorem partialDephasing_det_gap
    (q c a : Real) :
    chiralDet q (a * c) - chiralDet q c =
      (1 - a ^ 2) * c ^ 2 := by
  unfold chiralDet
  ring

/--
Partial dephasing `c |-> a*c` lowers purity by exactly
`2(1 - a^2)c^2`.
-/
theorem partialDephasing_purity_loss
    (q c a : Real) :
    chiralPurity q c - chiralPurity q (a * c) =
      2 * (1 - a ^ 2) * c ^ 2 := by
  unfold chiralPurity
  ring

/--
Partial dephasing increases the normalized mass-ratio-square proxy by exactly
`4(1 - a^2)c^2`.
-/
theorem partialDephasing_massRatioSq_gap
    (q c a : Real) :
    massRatioSq q (a * c) - massRatioSq q c =
      4 * (1 - a ^ 2) * c ^ 2 := by
  unfold massRatioSq chiralDet
  ring

/-- If `0 <= a <= 1`, partial dephasing cannot decrease determinant. -/
theorem partialDephasing_det_monotone
    (q c a : Real) (ha0 : 0 <= a) (ha1 : a <= 1) :
    chiralDet q c <= chiralDet q (a * c) := by
  have hgap := partialDephasing_det_gap q c a
  have hfac : 0 <= 1 - a ^ 2 := by
    nlinarith [sq_nonneg a, sq_nonneg (1 - a)]
  have hc : 0 <= c ^ 2 := sq_nonneg c
  have hprod : 0 <= (1 - a ^ 2) * c ^ 2 := mul_nonneg hfac hc
  nlinarith

/-- If `0 <= a <= 1`, partial dephasing cannot increase purity. -/
theorem partialDephasing_purity_antitone
    (q c a : Real) (ha0 : 0 <= a) (ha1 : a <= 1) :
    chiralPurity q (a * c) <= chiralPurity q c := by
  have hgap := partialDephasing_purity_loss q c a
  have hfac : 0 <= 1 - a ^ 2 := by
    nlinarith [sq_nonneg a, sq_nonneg (1 - a)]
  have hc : 0 <= c ^ 2 := sq_nonneg c
  have hprod : 0 <= 2 * (1 - a ^ 2) * c ^ 2 := by
    nlinarith [mul_nonneg hfac hc]
  nlinarith

/--
If `0 <= a <= 1`, partial dephasing cannot decrease the normalized
mass-ratio-square proxy.
-/
theorem partialDephasing_massRatioSq_monotone
    (q c a : Real) (ha0 : 0 <= a) (ha1 : a <= 1) :
    massRatioSq q c <= massRatioSq q (a * c) := by
  have hgap := partialDephasing_massRatioSq_gap q c a
  have hfac : 0 <= 1 - a ^ 2 := by
    nlinarith [sq_nonneg a, sq_nonneg (1 - a)]
  have hc : 0 <= c ^ 2 := sq_nonneg c
  have hprod : 0 <= 4 * (1 - a ^ 2) * c ^ 2 := by
    nlinarith [mul_nonneg hfac hc]
  nlinarith

/-- A genuine partial dephasing of nonzero coherence strictly increases the
normalized mass-ratio-square proxy. -/
theorem partialDephasing_massRatioSq_strict
    (q c a : Real) (ha0 : 0 <= a) (ha1 : a < 1)
    (hc : c = 0 -> False) :
    massRatioSq q c < massRatioSq q (a * c) := by
  have hgap := partialDephasing_massRatioSq_gap q c a
  have hfac : 0 < 1 - a ^ 2 := by
    nlinarith [sq_nonneg a, sq_nonneg (1 - a)]
  have hcpos : 0 < c ^ 2 := by
    simpa [sq] using (mul_self_pos.mpr hc)
  have hprod : 0 < 4 * (1 - a ^ 2) * c ^ 2 := by
    nlinarith [mul_pos hfac hcpos]
  nlinarith

/--
The `n`-step partial-dephasing scaffold. After `n` identical contractions of
coherence by `a`, the normalized mass-ratio-square proxy has increased by the
exact lost squared coherence `4(1 - (a^n)^2)c^2`.
-/
theorem iteratedPartialDephasing_massRatioSq_gap
    (q c a : Real) (n : Nat) :
    massRatioSq q ((a ^ n) * c) - massRatioSq q c =
      4 * (1 - (a ^ n) ^ 2) * c ^ 2 := by
  unfold massRatioSq chiralDet
  ring

/--
For `0 <= a <= 1`, the `n`-step partial-dephasing scaffold cannot decrease the
normalized mass-ratio-square proxy.
-/
theorem iteratedPartialDephasing_massRatioSq_monotone
    (q c a : Real) (n : Nat) (ha0 : 0 <= a) (ha1 : a <= 1) :
    massRatioSq q c <= massRatioSq q ((a ^ n) * c) := by
  have hpow1 : a ^ n <= 1 := by
    induction n with
    | zero =>
        norm_num
    | succ n ih =>
        rw [pow_succ]
        calc
          a ^ n * a <= 1 * 1 := mul_le_mul ih ha1 ha0 zero_le_one
          _ = 1 := by norm_num
  have hgap := iteratedPartialDephasing_massRatioSq_gap q c a n
  have hpow0 : 0 <= a ^ n := pow_nonneg ha0 n
  have hfac : 0 <= 1 - (a ^ n) ^ 2 := by
    nlinarith [sq_nonneg (a ^ n), sq_nonneg (1 - a ^ n)]
  have hc : 0 <= c ^ 2 := sq_nonneg c
  have hprod : 0 <= 4 * (1 - (a ^ n) ^ 2) * c ^ 2 := by
    nlinarith [mul_nonneg hfac hc]
  nlinarith

/--
If at least one genuine contraction step is applied to nonzero coherence, the
`n`-step partial-dephasing scaffold strictly increases the normalized
mass-ratio-square proxy.
-/
theorem iteratedPartialDephasing_massRatioSq_strict
    (q c a : Real) (n : Nat) (hn : 0 < n)
    (ha0 : 0 <= a) (ha1 : a < 1) (hc : c = 0 -> False) :
    massRatioSq q c < massRatioSq q ((a ^ n) * c) := by
  have hpow_le_one : forall k : Nat, a ^ k <= 1 := by
    intro k
    induction k with
    | zero =>
        norm_num
    | succ k ih =>
        rw [pow_succ]
        calc
          a ^ k * a <= 1 * 1 := mul_le_mul ih (le_of_lt ha1) ha0 zero_le_one
          _ = 1 := by norm_num
  have hpowlt : a ^ n < 1 := by
    cases n with
    | zero =>
        cases hn
    | succ k =>
        have hle : a ^ k <= 1 := hpow_le_one k
        rw [pow_succ]
        calc
          a ^ k * a <= 1 * a := mul_le_mul_of_nonneg_right hle ha0
          _ = a := by norm_num
          _ < 1 := ha1
  have hpow0 : 0 <= a ^ n := pow_nonneg ha0 n
  have hgap := iteratedPartialDephasing_massRatioSq_gap q c a n
  have hfac : 0 < 1 - (a ^ n) ^ 2 := by
    nlinarith [sq_nonneg (a ^ n), sq_nonneg (1 - a ^ n)]
  have hcpos : 0 < c ^ 2 := by
    simpa [sq] using (mul_self_pos.mpr hc)
  have hprod : 0 < 4 * (1 - (a ^ n) ^ 2) * c ^ 2 := by
    nlinarith [mul_pos hfac hcpos]
  nlinarith

end PhysicsSM.Draft.NullEdgeP2PartialDephasingRateBridge
