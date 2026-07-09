import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 400000

/-!
# Rank-2 ceiling of the determinant reading of `mass^2`

This file formalizes, on explicit finite rational witnesses, the honest boundary
of the `mass^2 = det P` reading:

* At **rank 2**, the determinant reading is exact: for the `2×2` spinor matrix
  `P = !![p, x; x, q]`, `det P = p*q - x^2` is a genuine `2×2` determinant and
  equals the physical `mass^2`.
* At **rank 3**, the naive extension `mass^2 = det P3` FAILS: the physical
  rest-mass-squared of a three-null-edge state is the sum of pairwise products
  `2*(a+b+c)`, whereas the `3×3` Gram determinant equals `2*a*b*c` for the
  zero-diagonal (null) pattern.  These are DIFFERENT functions: on `a=b=c=1`
  the pairwise mass is `6` but the determinant is `2`; on `a=b=1, c=0` the
  pairwise mass is `4` while the determinant VANISHES (linear dependence) even
  though the mass is nonzero.

Dimensional note (informal): an `r×r` Gram determinant scales as `mass^{2r}`,
so a determinant can only read off `mass^2` directly at `r = 2`.  The honest
statement below is the explicit numeric disagreement at `r = 3`; this is a
NEGATIVE / boundary result marking where the mechanism stops, not an extension
of it.
-/

namespace RankCeiling

open Matrix

/-- The `3×3` zero-diagonal (null) rational Gram with off-diagonal entries
`a, b, c` encoding pairwise inner products `p_i · p_j`. -/
def G (a b c : ℚ) : Matrix (Fin 3) (Fin 3) ℚ :=
  !![0, a, b; a, 0, c; b, c, 0]

/-- Physical rest-mass-squared of the three-edge sum `p = p1+p2+p3`:
`p·p = Σ_i p_i·p_i + 2 Σ_{i<j} p_i·p_j = 0 + 2(a+b+c)`. -/
def massPair (a b c : ℚ) : ℚ := 2 * (a + b + c)

/-- Naive determinant reading: the `3×3` Gram determinant. -/
def detG (a b c : ℚ) : ℚ := (G a b c).det

/-- Closed form of the physical pairwise mass. -/
theorem massPair_closed (a b c : ℚ) : massPair a b c = 2 * (a + b + c) := rfl

/-- Closed form of the `3×3` Gram determinant for the zero-diagonal pattern:
`det G = 2*a*b*c`. -/
theorem detG_closed (a b c : ℚ) : detG a b c = 2 * a * b * c := by
  simp only [detG, G, Matrix.det_fin_three]
  simp
  ring

/-- **Rank-2 sanity anchor.** For the `2×2` spinor matrix `P = !![p, x; x, q]`,
`det P = p*q - x^2` is a genuine `2×2` determinant — at rank 2 the determinant
reading of `mass^2` is exact. -/
theorem rank2_ok (p q x : ℚ) :
    (!![p, x; x, q] : Matrix (Fin 2) (Fin 2) ℚ).det = p * q - x ^ 2 := by
  simp only [Matrix.det_fin_two]
  simp
  ring

/-- Explicit massive rank-2 witness: `p = q = 1, x = 0` gives `mass^2 = 1 ≠ 0`. -/
theorem rank2_massive_witness :
    (!![(1 : ℚ), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℚ).det = 1 := by
  rw [rank2_ok]; norm_num

/-- **Payload.** The two readings DISAGREE at rank 3.

* Witness 1 (`a=b=c=1`): pairwise mass `= 6` but determinant `= 2`, so `6 ≠ 2`.
* Witness 2 (`a=b=1, c=0`): pairwise mass `= 4` but determinant `= 0`
  (the Gram is degenerate) — the determinant vanishes on a nonzero-mass
  configuration, so `det P3` cannot be the mass at rank 3. -/
theorem rank3_det_ne_pairwise :
    (massPair 1 1 1 ≠ detG 1 1 1) ∧
      (massPair 1 1 0 ≠ detG 1 1 0) ∧
      (massPair 1 1 0 ≠ 0 ∧ detG 1 1 0 = 0) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [massPair, detG_closed]; norm_num
  · rw [massPair, detG_closed]; norm_num
  · rw [massPair]; norm_num
  · rw [detG_closed]; norm_num

/-- **Verdict package.** Rank 2: the determinant IS `mass^2`
(`det !![p,x;x,q] = p*q - x^2`, exact, with an explicit massive witness).
Rank 3: the naive `det P3` is a DIFFERENT function from the physical pairwise
mass (they disagree on explicit witnesses, and `detG` even vanishes on a
nonzero-mass configuration).  Hence the det-`P` reading is intrinsically
two-edge; universality across higher spin is NOT claimed. -/
theorem rank_ceiling_verdict :
    (∀ p q x : ℚ,
        (!![p, x; x, q] : Matrix (Fin 2) (Fin 2) ℚ).det = p * q - x ^ 2) ∧
      ((!![(1 : ℚ), 0; 0, 1] : Matrix (Fin 2) (Fin 2) ℚ).det = 1) ∧
      (massPair 1 1 1 ≠ detG 1 1 1) ∧
      (massPair 1 1 0 ≠ 0 ∧ detG 1 1 0 = 0) := by
  refine ⟨rank2_ok, rank2_massive_witness, ?_, ?_, ?_⟩
  · rw [massPair, detG_closed]; norm_num
  · rw [massPair]; norm_num
  · rw [detG_closed]; norm_num

/-- info: 'RankCeiling.massPair_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massPair_closed

/-- info: 'RankCeiling.detG_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms detG_closed

/-- info: 'RankCeiling.rank2_ok' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rank2_ok

/-- info: 'RankCeiling.rank2_massive_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rank2_massive_witness

/-- info: 'RankCeiling.rank3_det_ne_pairwise' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rank3_det_ne_pairwise

/-- info: 'RankCeiling.rank_ceiling_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rank_ceiling_verdict

end RankCeiling
