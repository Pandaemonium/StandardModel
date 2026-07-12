import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlgebraicOffAxisAlias

/-!
# Target: live stationary-Weyl matrix to tangent numerators

This target connects the imported live `weylStep` to the exact tangent-chart
polynomials used by the corrected elimination certificate.  It does not copy
the projector walk or its matrix fixture.

For `U = weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz)`, coefficients
use the oracle convention

`U = u0 * 1 + I * (wx * sigmaX + wy * sigmaY + wz * sigmaZ)`.

The common real chart denominator is
`D = (1 + tx^2) * (1 + ty^2) * (1 + tz^2)`.  The exact cleared formulas are

`3125 D u0 = F0`, `15625 D wx = -6 Fx`,
`3125 D wy = 6 Fy`, and `15625 D wz = -6 Fz`.

Source: `Scripts/oracle/analyze_stationary_amplitude_weyl.py`, checked against
`Scripts/oracle/certify_stationary_weyl_tangent_elimination.py`.  The phase,
Pauli-matrix, multiplication-order, and polynomial-sign conventions are those
of the imported live modules and the 2026-07-12 exact certificate sidecar.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylLiveMatrixNumeratorBridge

open StationaryAmplitudeWeylTangent
open StationaryAmplitudeWeylAlgebraicOffAxisAlias

abbrev LiveM2 := StationaryAmplitudeWeylTangent.M2

/-- Product of the three positive tangent-half-angle chart denominators. -/
def chartDenominator (tx ty tz : Real) : Real :=
  (1 + tx ^ 2) * (1 + ty ^ 2) * (1 + tz ^ 2)

/-- Scalar numerator in the Pauli decomposition of the live matrix. -/
def scalarNumerator (tx ty tz : Real) : Real :=
  875 * tx ^ 2 * ty ^ 2 * tz ^ 2 +
  3456 * tx ^ 2 * ty ^ 2 * tz +
  245 * tx ^ 2 * ty ^ 2 +
  3600 * tx ^ 2 * ty +
  3125 * tx ^ 2 * tz ^ 2 +
  875 * tx ^ 2 -
  1008 * tx * ty ^ 2 * tz ^ 2 -
  3600 * tx * ty ^ 2 +
  5400 * tx * ty * tz +
  245 * ty ^ 2 * tz ^ 2 +
  875 * ty ^ 2 -
  3600 * ty * tz ^ 2 +
  875 * tz ^ 2 + 3125

/-- Primitive integer numerator for the x Pauli coefficient. -/
def Fx (tx ty tz : Real) : Real :=
  2108 * tx ^ 2 * ty ^ 2 * tz ^ 2 -
  840 * tx ^ 2 * ty ^ 2 * tz -
  700 * tx ^ 2 * ty ^ 2 +
  1050 * tx ^ 2 * ty * tz -
  3000 * tx ^ 2 * tz -
  245 * tx * ty ^ 2 * tz ^ 2 -
  875 * tx * ty ^ 2 +
  3600 * tx * ty * tz ^ 2 -
  875 * tx * tz ^ 2 -
  3125 * tx -
  700 * ty ^ 2 * tz ^ 2 -
  2500 * ty ^ 2 +
  3750 * ty * tz

/-- Primitive integer numerator for the y Pauli coefficient. -/
def Fy (tx ty tz : Real) : Real :=
  168 * tx ^ 2 * ty ^ 2 * tz -
  140 * tx ^ 2 * ty ^ 2 +
  625 * tx ^ 2 * ty * tz ^ 2 +
  175 * tx ^ 2 * ty -
  500 * tx ^ 2 -
  576 * tx * ty ^ 2 * tz ^ 2 +
  210 * tx * ty ^ 2 * tz +
  750 * tx * tz +
  140 * ty ^ 2 * tz ^ 2 +
  600 * ty ^ 2 * tz +
  175 * ty * tz ^ 2 +
  625 * ty +
  500 * tz ^ 2

/-- Primitive integer numerator for the z Pauli coefficient. -/
def Fz (tx ty tz : Real) : Real :=
  1344 * tx ^ 2 * ty ^ 2 * tz ^ 2 -
  245 * tx ^ 2 * ty ^ 2 * tz +
  2400 * tx ^ 2 * ty ^ 2 -
  3600 * tx ^ 2 * ty * tz -
  875 * tx ^ 2 * tz +
  840 * tx * ty ^ 2 * tz ^ 2 +
  3600 * tx * ty ^ 2 * tz +
  1050 * tx * ty * tz ^ 2 +
  3750 * tx * ty +
  3000 * tx * tz ^ 2 +
  2400 * ty ^ 2 * tz ^ 2 -
  875 * ty ^ 2 * tz -
  3125 * tz

/-- Sextic branch left after lexicographic elimination. -/
def excludedPoly (tz : Real) : Real :=
  16384 * tz ^ 6 + 11040 * tz ^ 5 + 56375 * tz ^ 4 +
    48000 * tz ^ 3 + 44050 * tz ^ 2 + 19680 * tz + 5175

/-- Scalar coefficient `trace(U) / 2`. -/
def scalarCoefficient (U : LiveM2) : Complex :=
  Matrix.trace U / 2

/-- Pauli coefficient `trace(sigma * U) / (2 I)`. -/
def pauliCoefficient (sigma U : LiveM2) : Complex :=
  Matrix.trace (sigma * U) / (2 * I)

def xCoefficient (U : LiveM2) : Complex :=
  pauliCoefficient sigmaX U

def yCoefficient (U : LiveM2) : Complex :=
  pauliCoefficient sigmaY U

def zCoefficient (U : LiveM2) : Complex :=
  pauliCoefficient sigmaZ U

/-- The scalar and three Pauli traces are exact coordinates on `2 x 2`
complex matrices. -/
theorem matrix_eq_one_iff_coefficients (U : LiveM2) :
    U = 1 ↔
      scalarCoefficient U = 1 ∧
      xCoefficient U = 0 ∧ yCoefficient U = 0 ∧ zCoefficient U = 0 := by
  constructor
  · rintro rfl
    simp [scalarCoefficient, xCoefficient, yCoefficient, zCoefficient,
      pauliCoefficient, sigmaX, sigmaY, sigmaZ, Matrix.trace, Fin.sum_univ_two]
  · rintro ⟨hs, hx, hy, hz⟩
    simp [scalarCoefficient, xCoefficient, yCoefficient, zCoefficient,
      pauliCoefficient, sigmaX, sigmaY, sigmaZ, Matrix.trace,
      Matrix.vecMul, dotProduct, Fin.sum_univ_two] at hs hx hy hz
    have hy' : U 0 1 - U 1 0 = 0 := by
      calc
        U 0 1 - U 1 0 =
            (-I) * (-(I * U 1 0) + I * U 0 1) := by
              simp [mul_add, mul_neg, ← mul_assoc, Complex.I_mul_I]
              ring
        _ = 0 := by rw [hy]; simp
    apply Matrix.ext
    intro i j
    fin_cases i <;> fin_cases j
    · simp
      linear_combination hs + hz / 2
    · simp
      linear_combination hx / 2 + hy' / 2
    · simp
      linear_combination hx / 2 - hy' / 2
    · simp
      linear_combination hs - hz / 2

theorem chartDenominator_pos (tx ty tz : Real) :
    0 < chartDenominator tx ty tz := by
  unfold chartDenominator
  positivity

theorem chartDenominator_ne_zero (tx ty tz : Real) :
    chartDenominator tx ty tz ≠ 0 :=
  ne_of_gt (chartDenominator_pos tx ty tz)

/-- Explicit inverse of the unit-modulus tangent phase as a cleared numerator
times the positive real denominator inverse. -/
theorem unitPhase_inv_num (s : ℝ) : (unitPhase s)⁻¹
    = ((1 - s ^ 2 : ℝ) : ℂ) / ((1 + s ^ 2 : ℝ) : ℂ)
      - I * (((2 * s) : ℝ) : ℂ) / ((1 + s ^ 2 : ℝ) : ℂ) := by
  have h : (unitPhase s)⁻¹ = starRingEnd ℂ (unitPhase s) :=
    (inv_eq_of_mul_eq_one_left (unitPhase_on_circle s)).symm ▸ rfl
  rw [h]; unfold unitPhase
  rw [Complex.ofReal_div, Complex.ofReal_div]
  simp [map_add, map_mul, Complex.conj_I, Complex.conj_ofReal, map_ofNat]; ring

/-- Factored form of the phase inverse: a cleared complex numerator times the
real denominator inverse. -/
theorem unitPhase_inv_factored (s : ℝ) : (unitPhase s)⁻¹
    = (((1 - s ^ 2 : ℝ) : ℂ) - I * (((2 * s) : ℝ) : ℂ)) * ((1 + s ^ 2 : ℝ) : ℂ)⁻¹ := by
  rw [unitPhase_inv_num, div_eq_mul_inv, div_eq_mul_inv]; ring

/-- The live matrix as a single scalar multiple of the cleared numerator
product `WaE * WbE * WcE`. -/
theorem weylStep_smul_num (tx ty tz : ℝ) :
    weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz)
    = ((unitPhase tx)⁻¹ * (unitPhase ty)⁻¹ * (unitPhase tz)⁻¹ *
       (((1 + tx ^ 2 : ℝ) : ℂ)⁻¹ * ((1 + tx ^ 2 : ℝ) : ℂ)⁻¹ *
        ((1 + ty ^ 2 : ℝ) : ℂ)⁻¹ * ((1 + ty ^ 2 : ℝ) : ℂ)⁻¹ *
        ((1 + tz ^ 2 : ℝ) : ℂ)⁻¹ * ((1 + tz ^ 2 : ℝ) : ℂ)⁻¹))
      • (WaE tx * WbE ty * WcE tz) := by
  unfold weylStep
  rw [walkN, walkN, walkN, hWa, hWb, hWc]
  simp only [Matrix.smul_mul, Matrix.mul_smul, smul_smul]
  congr 1; ring

set_option maxHeartbeats 8000000 in
set_option maxRecDepth 100000 in
/-- Exact cleared scalar and Pauli coefficients of the imported live matrix.

Proof handoff:
Expand `weylStep` through the imported `walkN`, `hWa`, `hWb`, and `hWc`
lemmas, then apply `Complex.ext` and `ring`.  The constants and signs are fixed
by the trace convention above; changing either `sigma * U` to `U * sigma` or
the displayed primitive normalization changes this statement.
-/
theorem live_coefficients_cleared (tx ty tz : Real) :
    let U := weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz)
    ((((3125 : Real) * chartDenominator tx ty tz : Real) : Complex) *
        scalarCoefficient U = ((scalarNumerator tx ty tz : Real) : Complex)) ∧
    ((((15625 : Real) * chartDenominator tx ty tz : Real) : Complex) *
        xCoefficient U = (((-6 : Real) * Fx tx ty tz : Real) : Complex)) ∧
    ((((3125 : Real) * chartDenominator tx ty tz : Real) : Complex) *
        yCoefficient U = (((6 : Real) * Fy tx ty tz : Real) : Complex)) ∧
    ((((15625 : Real) * chartDenominator tx ty tz : Real) : Complex) *
        zCoefficient U = (((-6 : Real) * Fz tx ty tz : Real) : Complex)) := by
  have hx : (1 : ℝ) + tx ^ 2 ≠ 0 := by positivity
  have hy : (1 : ℝ) + ty ^ 2 ≠ 0 := by positivity
  have hz : (1 : ℝ) + tz ^ 2 ≠ 0 := by positivity
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [weylStep_smul_num]
    unfold scalarCoefficient
    rw [Matrix.trace_smul]
    simp only [WaE, WbE, WcE, Matrix.trace_fin_two, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, smul_eq_mul, Matrix.of_apply,
      Matrix.cons_val']
    rw [unitPhase_inv_factored, unitPhase_inv_factored, unitPhase_inv_factored]
    simp only [← Complex.ofReal_inv]
    apply Complex.ext <;>
      (simp only [Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im, Complex.sub_re,
          Complex.sub_im, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im,
          Complex.one_re, Complex.one_im, Complex.div_re, Complex.div_im,
          Complex.re_ofNat, Complex.im_ofNat, Complex.normSq_ofNat, Complex.normSq_apply,
          Complex.neg_re, Complex.neg_im,
          mul_zero, zero_mul, mul_one, one_mul, sub_zero, zero_sub, add_zero, zero_add,
          neg_zero] ;
        simp only [chartDenominator, scalarNumerator] ; field_simp ; ring)
  · rw [weylStep_smul_num]
    unfold xCoefficient pauliCoefficient
    rw [Matrix.mul_smul, Matrix.trace_smul]
    simp only [sigmaX, WaE, WbE, WcE, Matrix.trace_fin_two, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, smul_eq_mul, Matrix.of_apply,
      Matrix.cons_val']
    rw [unitPhase_inv_factored, unitPhase_inv_factored, unitPhase_inv_factored]
    simp only [← Complex.ofReal_inv]
    apply Complex.ext <;>
      (simp only [Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im, Complex.sub_re,
          Complex.sub_im, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im,
          Complex.one_re, Complex.one_im, Complex.div_re, Complex.div_im,
          Complex.re_ofNat, Complex.im_ofNat, Complex.normSq_ofNat, Complex.normSq_apply,
          Complex.neg_re, Complex.neg_im,
          mul_zero, zero_mul, mul_one, one_mul, sub_zero, zero_sub, add_zero, zero_add,
          neg_zero] ;
        simp only [chartDenominator, Fx] ; field_simp ; ring)
  · rw [weylStep_smul_num]
    unfold yCoefficient pauliCoefficient
    rw [Matrix.mul_smul, Matrix.trace_smul]
    simp only [sigmaY, WaE, WbE, WcE, Matrix.trace_fin_two, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, smul_eq_mul, Matrix.of_apply,
      Matrix.cons_val']
    rw [unitPhase_inv_factored, unitPhase_inv_factored, unitPhase_inv_factored]
    simp only [← Complex.ofReal_inv]
    apply Complex.ext <;>
      (simp only [Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im, Complex.sub_re,
          Complex.sub_im, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im,
          Complex.one_re, Complex.one_im, Complex.div_re, Complex.div_im,
          Complex.re_ofNat, Complex.im_ofNat, Complex.normSq_ofNat, Complex.normSq_apply,
          Complex.neg_re, Complex.neg_im,
          mul_zero, zero_mul, mul_one, one_mul, sub_zero, zero_sub, add_zero, zero_add,
          neg_zero] ;
        simp only [chartDenominator, Fy] ; field_simp ; ring)
  · rw [weylStep_smul_num]
    unfold zCoefficient pauliCoefficient
    rw [Matrix.mul_smul, Matrix.trace_smul]
    simp only [sigmaZ, WaE, WbE, WcE, Matrix.trace_fin_two, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, smul_eq_mul, Matrix.of_apply,
      Matrix.cons_val']
    rw [unitPhase_inv_factored, unitPhase_inv_factored, unitPhase_inv_factored]
    simp only [← Complex.ofReal_inv]
    apply Complex.ext <;>
      (simp only [Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im, Complex.sub_re,
          Complex.sub_im, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im,
          Complex.one_re, Complex.one_im, Complex.div_re, Complex.div_im,
          Complex.re_ofNat, Complex.im_ofNat, Complex.normSq_ofNat, Complex.normSq_apply,
          Complex.neg_re, Complex.neg_im,
          mul_zero, zero_mul, mul_one, one_mul, sub_zero, zero_sub, add_zero, zero_add,
          neg_zero] ;
        simp only [chartDenominator, Fz] ; field_simp ; ring)

/-- Strong live-matrix bridge: identity is equivalent to the scalar equation
and the three exact primitive numerator equations on the finite real chart. -/
theorem live_eq_one_iff_numerators (tx ty tz : Real) :
    weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz) = 1 ↔
      scalarNumerator tx ty tz = 3125 * chartDenominator tx ty tz ∧
      Fx tx ty tz = 0 ∧ Fy tx ty tz = 0 ∧ Fz tx ty tz = 0 := by
  let U := weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz)
  have hCxReal : (15625 : Real) * chartDenominator tx ty tz ≠ 0 :=
    mul_ne_zero (by norm_num) (chartDenominator_ne_zero tx ty tz)
  have hCyReal : (3125 : Real) * chartDenominator tx ty tz ≠ 0 :=
    mul_ne_zero (by norm_num) (chartDenominator_ne_zero tx ty tz)
  have hCx : ((((15625 : Real) * chartDenominator tx ty tz : Real) : Complex)) ≠ 0 := by
    exact_mod_cast hCxReal
  have hCy : ((((3125 : Real) * chartDenominator tx ty tz : Real) : Complex)) ≠ 0 := by
    exact_mod_cast hCyReal
  rcases live_coefficients_cleared tx ty tz with ⟨hsClear, hxClear, hyClear, hzClear⟩
  constructor
  · intro hLive
    rcases (matrix_eq_one_iff_coefficients U).mp hLive with ⟨hs, hx, hy, hz⟩
    refine ⟨?_, ?_, ?_, ?_⟩
    · rw [hs, mul_one] at hsClear
      exact_mod_cast hsClear.symm
    · rw [hx, mul_zero] at hxClear
      have hxReal : (-6 : Real) * Fx tx ty tz = 0 := by
        exact_mod_cast hxClear.symm
      rcases mul_eq_zero.mp hxReal with hfalse | hFx
      · norm_num at hfalse
      · exact hFx
    · rw [hy, mul_zero] at hyClear
      have hyReal : (6 : Real) * Fy tx ty tz = 0 := by
        exact_mod_cast hyClear.symm
      rcases mul_eq_zero.mp hyReal with hfalse | hFy
      · norm_num at hfalse
      · exact hFy
    · rw [hz, mul_zero] at hzClear
      have hzReal : (-6 : Real) * Fz tx ty tz = 0 := by
        exact_mod_cast hzClear.symm
      rcases mul_eq_zero.mp hzReal with hfalse | hFz
      · norm_num at hfalse
      · exact hFz
  · rintro ⟨hs, hx, hy, hz⟩
    apply (matrix_eq_one_iff_coefficients U).mpr
    refine ⟨?_, ?_, ?_, ?_⟩
    · rw [hs] at hsClear
      apply mul_left_cancel₀ hCy
      simpa using hsClear
    · have hprod :
          ((((15625 : Real) * chartDenominator tx ty tz : Real) : Complex)) *
              xCoefficient U = 0 := by
        simpa [hx] using hxClear
      rcases mul_eq_zero.mp hprod with hfalse | hzero
      · exact (hCx hfalse).elim
      · exact hzero
    · have hprod :
          ((((3125 : Real) * chartDenominator tx ty tz : Real) : Complex)) *
              yCoefficient U = 0 := by
        simpa [hy] using hyClear
      rcases mul_eq_zero.mp hprod with hfalse | hzero
      · exact (hCy hfalse).elim
      · exact hzero
    · have hprod :
          ((((15625 : Real) * chartDenominator tx ty tz : Real) : Complex)) *
              zCoefficient U = 0 := by
        simpa [hz] using hzClear
      rcases mul_eq_zero.mp hprod with hfalse | hzero
      · exact (hCx hfalse).elim
      · exact hzero

/-- Converse bridge needed by the alias census.  No off-axis hypothesis is
needed for this implication: every finite real tangent chart has positive
denominator. -/
theorem live_eq_one_implies_numerators_zero {tx ty tz : Real}
    (hLive : weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz) = 1) :
    Fx tx ty tz = 0 ∧ Fy tx ty tz = 0 ∧ Fz tx ty tz = 0 :=
  (live_eq_one_iff_numerators tx ty tz).mp hLive |>.2

/-- The fully off-axis scope used after the live bridge. -/
def NondegenerateTangent (tx ty tz : Real) : Prop :=
  tx ≠ 0 ∧ ty ≠ 0 ∧ tz ≠ 0

/-- Pointwise composition with the corrected exact ideal certificate.

The hypothesis deliberately retains `(1 + tz^2)^2`.  It can be instantiated
with the three quotient-polynomial values from the corrected certificate.
-/
theorem corrected_eliminant_of_live_alias {tx ty tz qx qy qz : Real}
    (hCertificate :
      (1 + tz ^ 2) ^ 2 * tz * rootPoly tz * excludedPoly tz =
        qx * Fx tx ty tz + qy * Fy tx ty tz + qz * Fz tx ty tz)
    (hLive : weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz) = 1) :
    tz = 0 ∨ rootPoly tz = 0 ∨ excludedPoly tz = 0 := by
  rcases live_eq_one_implies_numerators_zero hLive with ⟨hx, hy, hz⟩
  have hzero :
      (1 + tz ^ 2) ^ 2 * tz * rootPoly tz * excludedPoly tz = 0 := by
    rw [hCertificate, hx, hy, hz]
    ring
  have hchart : (1 + tz ^ 2) ^ 2 ≠ 0 := by positivity
  rcases mul_eq_zero.mp hzero with hleft | hexcluded
  · rcases mul_eq_zero.mp hleft with hleft | hroot
    · rcases mul_eq_zero.mp hleft with hchartZero | htz
      · exact (hchart hchartZero).elim
      · exact Or.inl htz
    · exact Or.inr (Or.inl hroot)
  · exact Or.inr (Or.inr hexcluded)

/-- In the nondegenerate tangent scope, the corrected certificate removes the
coordinate-axis branch and leaves exactly the quintic-or-sextic alternative. -/
theorem corrected_eliminant_of_nondegenerate_live_alias {tx ty tz qx qy qz : Real}
    (hNondegenerate : NondegenerateTangent tx ty tz)
    (hCertificate :
      (1 + tz ^ 2) ^ 2 * tz * rootPoly tz * excludedPoly tz =
        qx * Fx tx ty tz + qy * Fy tx ty tz + qz * Fz tx ty tz)
    (hLive : weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz) = 1) :
    rootPoly tz = 0 ∨ excludedPoly tz = 0 := by
  rcases corrected_eliminant_of_live_alias hCertificate hLive with htz | hroot | hexcluded
  · exact (hNondegenerate.2.2 htz).elim
  · exact Or.inl hroot
  · exact Or.inr hexcluded

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylLiveMatrixNumeratorBridge
