import PhysicsSM.Draft.NullEdge.ReciprocalConditionalShiftRegulator

/-!
# Exact Laurent range of the reciprocal regulator

Extract the five coefficient matrices of the landed reciprocal regulator.
Prove the Laurent expansion exactly, certify that both extreme coefficients are
nonzero (genuine range two), and recover the zeroth and first moment identities
that encode identity value and zero first jet at `z=1`.

Provenance: internal exact coefficient extraction; all proof bodies were
completed without statement changes by Aristotle project
`ed4f1cf3-fae9-47b2-8641-1f6e99cf7942` on 2026-07-11. No compiled evaluator
is used.
-/

namespace PhysicsSM.Draft.NullEdge.ReciprocalLaurentRange

open Matrix Complex
open ReciprocalConditionalShiftRegulator

noncomputable section

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

def coeffNeg2 : M2 := !![0, 0; -192 / 625, -144 / 625]
def coeffNeg1 : M2 := !![144 / 625, 108 / 625; 276 / 625, 432 / 625]
def coeffZero : M2 := !![193 / 625, -24 / 625; 24 / 625, 193 / 625]
def coeffPos1 : M2 := !![432 / 625, -276 / 625; -108 / 625, 144 / 625]
def coeffPos2 : M2 := !![-144 / 625, 192 / 625; 0, 0]

def laurentEval (z : Complex) : M2 :=
  z⁻¹ ^ 2 • coeffNeg2 + z⁻¹ • coeffNeg1 + coeffZero +
    z • coeffPos1 + z ^ 2 • coeffPos2

/-- Exact five-term Laurent expansion of the reciprocal word. -/
theorem reciprocalRegulator_eq_laurentEval (z : Complex) (hz : z ≠ 0) :
    reciprocalRegulator z = laurentEval z := by
  have hzi : z⁻¹ ≠ 0 := inv_ne_zero hz
  rw [reciprocalRegulator, shiftCoinCommutator_eq z hz, shiftCoinCommutator_eq z⁻¹ hzi, inv_inv]
  ext i j
  fin_cases i <;> fin_cases j <;>
    · simp [laurentEval, coeffNeg2, coeffNeg1, coeffZero, coeffPos1, coeffPos2,
        Matrix.mul_apply, Fin.sum_univ_two]
      field_simp
      ring

/-- The positive range-two coefficient is genuinely present. -/
theorem coeffPos2_ne_zero : coeffPos2 ≠ 0 := by
  intro h
  have := congr_fun (congr_fun h 0) 0
  simp [coeffPos2] at this

/-- The negative range-two coefficient is genuinely present. -/
theorem coeffNeg2_ne_zero : coeffNeg2 ≠ 0 := by
  intro h
  have := congr_fun (congr_fun h 1) 0
  simp [coeffNeg2] at this

/-- Zeroth Laurent moment: the five coefficients sum to the identity. -/
theorem coefficient_sum_eq_one :
    coeffNeg2 + coeffNeg1 + coeffZero + coeffPos1 + coeffPos2 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [coeffNeg2, coeffNeg1, coeffZero, coeffPos1, coeffPos2] <;> norm_num

/-- First Laurent moment: the derivative coefficient at `z=1` vanishes. -/
theorem first_moment_eq_zero :
    (-2 : Complex) • coeffNeg2 + (-1 : Complex) • coeffNeg1 +
      coeffPos1 + (2 : Complex) • coeffPos2 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [coeffNeg2, coeffNeg1, coeffPos1, coeffPos2] <;> norm_num

/-- The coefficient expansion itself evaluates to identity at the origin. -/
theorem laurentEval_one : laurentEval 1 = 1 := by
  rw [laurentEval]
  simp only [inv_one, one_pow, one_smul]
  rw [← coefficient_sum_eq_one]

/-- Clearing the negative powers gives an ordinary degree-four matrix
polynomial, an exact strict finite-range certificate. -/
theorem cleared_laurent_polynomial (z : Complex) (hz : z ≠ 0) :
    z ^ 2 • reciprocalRegulator z =
      coeffNeg2 + z • coeffNeg1 + z ^ 2 • coeffZero +
        z ^ 3 • coeffPos1 + z ^ 4 • coeffPos2 := by
  rw [reciprocalRegulator_eq_laurentEval z hz]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [laurentEval, coeffNeg2, coeffNeg1, coeffZero, coeffPos1, coeffPos2] <;>
    field_simp

/-- Negative control: deleting either extreme coefficient changes the Laurent
symbol at an exact rational point. -/
theorem extreme_coefficients_load_bearing :
    laurentEval 2 ≠
        (2 : Complex)⁻¹ • coeffNeg1 + coeffZero +
          (2 : Complex) • coeffPos1 + (2 : Complex) ^ 2 • coeffPos2 ∧
      laurentEval 2 ≠
        (2 : Complex)⁻¹ ^ 2 • coeffNeg2 + (2 : Complex)⁻¹ • coeffNeg1 +
          coeffZero + (2 : Complex) • coeffPos1 := by
  constructor
  · intro h
    have := congr_fun (congr_fun h 1) 0
    simp [laurentEval, coeffNeg2, coeffNeg1, coeffZero, coeffPos1, coeffPos2] at this
  · intro h
    have := congr_fun (congr_fun h 0) 0
    simp [laurentEval, coeffNeg2, coeffNeg1, coeffZero, coeffPos1, coeffPos2] at this

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ReciprocalLaurentRange.reciprocalRegulator_eq_laurentEval' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms reciprocalRegulator_eq_laurentEval

/-- info: 'PhysicsSM.Draft.NullEdge.ReciprocalLaurentRange.cleared_laurent_polynomial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cleared_laurent_polynomial

/-- info: 'PhysicsSM.Draft.NullEdge.ReciprocalLaurentRange.extreme_coefficients_load_bearing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms extreme_coefficients_load_bearing

end

end PhysicsSM.Draft.NullEdge.ReciprocalLaurentRange
