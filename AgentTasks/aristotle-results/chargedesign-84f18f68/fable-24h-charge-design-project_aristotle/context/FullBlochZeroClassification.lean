import PhysicsSM.Draft.NullEdge.FullBlochSplitPlus
import PhysicsSM.Draft.NullEdge.FullBlochSplitMinus

/-!
# Complete massive-branch zero-set classification

The exact determinant formulas reduce the `+1` and `-1` Floquet crossing
conditions to real polynomials in the four cosines
`x = cos qx`, `y = cos qy`, `z = cos qz`, and `c = cos theta`.

This module proves that on the principal massive branch
`0 < |cos theta| < 1`, both determinant polynomials vanish exactly when all
three momentum cosines vanish. Thus the simultaneous body-center cosine locus
is the complete zero- and pi-quasienergy crossing set in that branch.

The result is a classification of this ordered split-walk symbol. It is not an
alias-free theorem: the classified crossing survives for every allowed mass
angle. The quarter-turn mass boundary `cos theta = 0` has additional zeros,
recorded explicitly below.

Provenance: proof returned by Aristotle project
`efc99053-8082-4063-9d33-c4cc4a68106f`, independently compiled under the
pinned toolchain, then clean-room ported onto the live determinant definitions.
-/

namespace PhysicsSM.Draft.NullEdge.FullBlochZeroClassification

open FullBlochSplitDeterminants

/-- Algebraic common part of the two live determinant polynomials. -/
def algebraBase (x y z c : Real) : Real :=
  4 * c^2 * x^2 * y^2 * z^2
    - 2 * c^2 * x^2 * y^2
    - 2 * c^2 * x^2 * z^2
    + c^2 * x^2
    - 2 * c^2 * y^2 * z^2
    + c^2 * y^2
    + c^2 * z^2
    - 2 * x^2 * y^2 * z^2
    + x^2 * y^2
    + x^2 * z^2
    + y^2 * z^2

def algebraZero (x y z c : Real) : Real :=
  algebraBase x y z c - 2 * c * x * y * z

def algebraPi (x y z c : Real) : Real :=
  algebraBase x y z c + 2 * c * x * y * z

/-- Sharp sum-of-squares/AM-GM decomposition of the zero-mode polynomial. -/
theorem algebraZero_factor (x y z c : Real) :
    algebraZero x y z c =
      (c * x - y * z) ^ 2 +
        (y ^ 2 + z ^ 2 - 2 * y ^ 2 * z ^ 2) *
          (c ^ 2 + x ^ 2 * (1 - 2 * c ^ 2)) := by
  unfold algebraZero algebraBase
  ring

/-- The pi-mode polynomial is the zero-mode polynomial with mass-cosine sign
flipped. -/
theorem algebraPi_eq_algebraZero_neg (x y z c : Real) :
    algebraPi x y z c = algebraZero x y z (-c) := by
  unfold algebraPi algebraZero algebraBase
  ring

theorem sfactor_nonneg (y z : Real) (hy2 : y ^ 2 <= 1) (hz2 : z ^ 2 <= 1) :
    0 <= y ^ 2 + z ^ 2 - 2 * y ^ 2 * z ^ 2 := by
  nlinarith [
    mul_nonneg (sq_nonneg y) (by linarith : (0 : Real) <= 1 - z ^ 2),
    mul_nonneg (sq_nonneg z) (by linarith : (0 : Real) <= 1 - y ^ 2)]

theorem kfactor_pos (x c : Real) (hx2 : x ^ 2 <= 1)
    (hcpos : 0 < c ^ 2) (hc2 : c ^ 2 < 1) :
    0 < c ^ 2 + x ^ 2 * (1 - 2 * c ^ 2) := by
  rcases eq_or_lt_of_le hx2 with h | h
  · nlinarith [h, hc2]
  · nlinarith [
      mul_pos hcpos (by linarith : (0 : Real) < 1 - x ^ 2),
      mul_nonneg (sq_nonneg x) (by linarith : (0 : Real) <= 1 - c ^ 2)]

/-- Pure algebraic zero-set classification on the physical cosine cube. -/
theorem algebraZero_eq_zero_iff
    (x y z c : Real)
    (hx : |x| <= 1) (hy : |y| <= 1) (hz : |z| <= 1)
    (hc0 : 0 < |c|) (hc1 : |c| < 1) :
    algebraZero x y z c = 0 <-> x = 0 ∧ y = 0 ∧ z = 0 := by
  have hx2 : x ^ 2 <= 1 := by nlinarith [sq_abs x, abs_nonneg x, hx]
  have hy2 : y ^ 2 <= 1 := by nlinarith [sq_abs y, abs_nonneg y, hy]
  have hz2 : z ^ 2 <= 1 := by nlinarith [sq_abs z, abs_nonneg z, hz]
  have hc2 : c ^ 2 < 1 := by nlinarith [sq_abs c, abs_nonneg c, hc1]
  have hcpos : 0 < c ^ 2 := by nlinarith [sq_abs c, mul_pos hc0 hc0]
  have hcne : c ≠ 0 := by
    intro h
    rw [h] at hcpos
    simp at hcpos
  constructor
  · intro h
    have hK : 0 < c ^ 2 + x ^ 2 * (1 - 2 * c ^ 2) :=
      kfactor_pos x c hx2 hcpos hc2
    have hS : 0 <= y ^ 2 + z ^ 2 - 2 * y ^ 2 * z ^ 2 :=
      sfactor_nonneg y z hy2 hz2
    rw [algebraZero_factor] at h
    have hsq : 0 <= (c * x - y * z) ^ 2 := sq_nonneg _
    have hSK : 0 <=
        (y ^ 2 + z ^ 2 - 2 * y ^ 2 * z ^ 2) *
          (c ^ 2 + x ^ 2 * (1 - 2 * c ^ 2)) := mul_nonneg hS hK.le
    have hsq0 : (c * x - y * z) ^ 2 = 0 := by linarith
    have hSK0 :
        (y ^ 2 + z ^ 2 - 2 * y ^ 2 * z ^ 2) *
          (c ^ 2 + x ^ 2 * (1 - 2 * c ^ 2)) = 0 := by
      linarith
    have hcxyz : c * x - y * z = 0 := by
      exact pow_eq_zero_iff (by norm_num : (2 : Nat) ≠ 0) |>.mp hsq0
    have hS0 : y ^ 2 + z ^ 2 - 2 * y ^ 2 * z ^ 2 = 0 := by
      rcases mul_eq_zero.mp hSK0 with h' | h'
      · exact h'
      · exact absurd h' (ne_of_gt hK)
    have hsum : y ^ 2 * (1 - z ^ 2) + z ^ 2 * (1 - y ^ 2) = 0 := by
      linear_combination hS0
    have t1 : 0 <= y ^ 2 * (1 - z ^ 2) :=
      mul_nonneg (sq_nonneg y) (by linarith)
    have t2 : 0 <= z ^ 2 * (1 - y ^ 2) :=
      mul_nonneg (sq_nonneg z) (by linarith)
    have e1 : y ^ 2 * (1 - z ^ 2) = 0 := by linarith
    have e2 : z ^ 2 * (1 - y ^ 2) = 0 := by linarith
    rcases mul_eq_zero.mp e1 with hy0 | hz1
    · rcases mul_eq_zero.mp e2 with hz0 | hy1
      · have hyy : y = 0 := by
          exact pow_eq_zero_iff (by norm_num : (2 : Nat) ≠ 0) |>.mp hy0
        have hzz : z = 0 := by
          exact pow_eq_zero_iff (by norm_num : (2 : Nat) ≠ 0) |>.mp hz0
        have hxx : x = 0 := by
          have hcx0 : c * x = 0 := by
            rw [hyy, hzz] at hcxyz
            linear_combination hcxyz
          rcases mul_eq_zero.mp hcx0 with h' | h'
          · exact absurd h' hcne
          · exact h'
        exact ⟨hxx, hyy, hzz⟩
      · have hy2eq : y ^ 2 = 1 := by linarith
        rw [hy2eq] at hy0
        norm_num at hy0
    · rcases mul_eq_zero.mp e2 with hz0 | hy1
      · have hz2eq : z ^ 2 = 1 := by linarith
        rw [hz2eq] at hz0
        norm_num at hz0
      · have hyy1 : y ^ 2 = 1 := by linarith
        have hzz1 : z ^ 2 = 1 := by linarith
        exfalso
        have hsqeq : (c * x) ^ 2 = (y * z) ^ 2 := by
          rw [sub_eq_zero] at hcxyz
          rw [hcxyz]
        have hcx : c ^ 2 * x ^ 2 = 1 := by
          nlinarith [hsqeq, hyy1, hzz1]
        nlinarith [
          mul_nonneg hcpos.le (by linarith : (0 : Real) <= 1 - x ^ 2), hc2]
  · rintro ⟨rfl, rfl, rfl⟩
    unfold algebraZero algebraBase
    ring

theorem algebraPi_eq_zero_iff
    (x y z c : Real)
    (hx : |x| <= 1) (hy : |y| <= 1) (hz : |z| <= 1)
    (hc0 : 0 < |c|) (hc1 : |c| < 1) :
    algebraPi x y z c = 0 <-> x = 0 ∧ y = 0 ∧ z = 0 := by
  rw [algebraPi_eq_algebraZero_neg]
  exact algebraZero_eq_zero_iff x y z (-c) hx hy hz
    (by rwa [abs_neg]) (by rwa [abs_neg])

/-- Complete zero-quasienergy crossing classification for the live symbol. -/
theorem zeroModePolynomial_eq_zero_iff
    (qx qy qz theta : Real)
    (hx : |Real.cos qx| <= 1) (hy : |Real.cos qy| <= 1)
    (hz : |Real.cos qz| <= 1)
    (hc0 : 0 < |Real.cos theta|) (hc1 : |Real.cos theta| < 1) :
    zeroModePolynomial qx qy qz theta = 0 <->
      Real.cos qx = 0 ∧ Real.cos qy = 0 ∧ Real.cos qz = 0 := by
  simpa [zeroModePolynomial, spectralBase, algebraZero, algebraBase] using
    algebraZero_eq_zero_iff (Real.cos qx) (Real.cos qy) (Real.cos qz)
      (Real.cos theta) hx hy hz hc0 hc1

/-- Complete pi-quasienergy crossing classification for the live symbol. -/
theorem piModePolynomial_eq_zero_iff
    (qx qy qz theta : Real)
    (hx : |Real.cos qx| <= 1) (hy : |Real.cos qy| <= 1)
    (hz : |Real.cos qz| <= 1)
    (hc0 : 0 < |Real.cos theta|) (hc1 : |Real.cos theta| < 1) :
    piModePolynomial qx qy qz theta = 0 <->
      Real.cos qx = 0 ∧ Real.cos qy = 0 ∧ Real.cos qz = 0 := by
  simpa [piModePolynomial, spectralBase, algebraPi, algebraBase] using
    algebraPi_eq_zero_iff (Real.cos qx) (Real.cos qy) (Real.cos qz)
      (Real.cos theta) hx hy hz hc0 hc1

/-- Direct live-walk zero-quasienergy classification, with the cosine-box
hypotheses discharged automatically. -/
theorem live_det_sub_one_eq_zero_iff
    (qx qy qz theta : Real)
    (hc0 : 0 < |Real.cos theta|) (hc1 : |Real.cos theta| < 1) :
    (Compact3Plus1DiracRate.splitStep qx qy qz theta 1 - 1).det = 0 <->
      Real.cos qx = 0 ∧ Real.cos qy = 0 ∧ Real.cos qz = 0 := by
  rw [← splitStep_eq_live, FullBlochSplitPlus.det_splitStep_sub_one]
  have hpoly := zeroModePolynomial_eq_zero_iff qx qy qz theta
    (Real.abs_cos_le_one qx) (Real.abs_cos_le_one qy)
    (Real.abs_cos_le_one qz) hc0 hc1
  constructor
  · intro h
    have hr : 4 * zeroModePolynomial qx qy qz theta = 0 := by
      exact_mod_cast h
    have hp : zeroModePolynomial qx qy qz theta = 0 := by
      nlinarith
    exact hpoly.mp hp
  · intro h
    simp [hpoly.mpr h]

/-- Direct live-walk pi-quasienergy classification on the principal massive
branch. -/
theorem live_det_add_one_eq_zero_iff
    (qx qy qz theta : Real)
    (hc0 : 0 < |Real.cos theta|) (hc1 : |Real.cos theta| < 1) :
    (Compact3Plus1DiracRate.splitStep qx qy qz theta 1 + 1).det = 0 <->
      Real.cos qx = 0 ∧ Real.cos qy = 0 ∧ Real.cos qz = 0 := by
  rw [← splitStep_eq_live, FullBlochSplitMinus.det_splitStep_add_one]
  have hpoly := piModePolynomial_eq_zero_iff qx qy qz theta
    (Real.abs_cos_le_one qx) (Real.abs_cos_le_one qy)
    (Real.abs_cos_le_one qz) hc0 hc1
  constructor
  · intro h
    have hr : 4 * piModePolynomial qx qy qz theta = 0 := by
      exact_mod_cast h
    have hp : piModePolynomial qx qy qz theta = 0 := by
      nlinarith
    exact hpoly.mp hp
  · intro h
    simp [hpoly.mpr h]

/-- Exact boundary control: at `cos theta = 0`, additional non-body-center
cosine zeros occur, so the massive-branch hypothesis is load-bearing. -/
theorem quarter_turn_mass_extra_zero :
    zeroModePolynomial 0 (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) = 0 ∧
    piModePolynomial 0 (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) = 0 ∧
    Real.cos 0 ≠ 0 := by
  norm_num [zeroModePolynomial, piModePolynomial, spectralBase]

/-- info: 'PhysicsSM.Draft.NullEdge.FullBlochZeroClassification.zeroModePolynomial_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zeroModePolynomial_eq_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.FullBlochZeroClassification.piModePolynomial_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms piModePolynomial_eq_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.FullBlochZeroClassification.live_det_sub_one_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms live_det_sub_one_eq_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.FullBlochZeroClassification.live_det_add_one_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms live_det_add_one_eq_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.FullBlochZeroClassification.quarter_turn_mass_extra_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quarter_turn_mass_extra_zero

end PhysicsSM.Draft.NullEdge.FullBlochZeroClassification
