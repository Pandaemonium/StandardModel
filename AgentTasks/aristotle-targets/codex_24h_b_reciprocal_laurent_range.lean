import PhysicsSM.Draft.NullEdge.ReciprocalConditionalShiftRegulator

/-!
# Aristotle target: exact Laurent range of the reciprocal regulator

Extract the five coefficient matrices of the landed reciprocal regulator.
Prove the Laurent expansion exactly, certify that both extreme coefficients are
nonzero (genuine range two), and recover the zeroth and first moment identities
that encode identity value and zero first jet at `z=1`.
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
  sorry

/-- The positive range-two coefficient is genuinely present. -/
theorem coeffPos2_ne_zero : coeffPos2 ≠ 0 := by
  sorry

/-- The negative range-two coefficient is genuinely present. -/
theorem coeffNeg2_ne_zero : coeffNeg2 ≠ 0 := by
  sorry

/-- Zeroth Laurent moment: the five coefficients sum to the identity. -/
theorem coefficient_sum_eq_one :
    coeffNeg2 + coeffNeg1 + coeffZero + coeffPos1 + coeffPos2 = 1 := by
  sorry

/-- First Laurent moment: the derivative coefficient at `z=1` vanishes. -/
theorem first_moment_eq_zero :
    (-2 : Complex) • coeffNeg2 + (-1 : Complex) • coeffNeg1 +
      coeffPos1 + (2 : Complex) • coeffPos2 = 0 := by
  sorry

/-- The coefficient expansion itself evaluates to identity at the origin. -/
theorem laurentEval_one : laurentEval 1 = 1 := by
  sorry

/-- Clearing the negative powers gives an ordinary degree-four matrix
polynomial, an exact strict finite-range certificate. -/
theorem cleared_laurent_polynomial (z : Complex) (hz : z ≠ 0) :
    z ^ 2 • reciprocalRegulator z =
      coeffNeg2 + z • coeffNeg1 + z ^ 2 • coeffZero +
        z ^ 3 • coeffPos1 + z ^ 4 • coeffPos2 := by
  sorry

/-- Negative control: deleting either extreme coefficient changes the Laurent
symbol at an exact rational point. -/
theorem extreme_coefficients_load_bearing :
    laurentEval 2 ≠
        (2 : Complex)⁻¹ • coeffNeg1 + coeffZero +
          (2 : Complex) • coeffPos1 + (2 : Complex) ^ 2 • coeffPos2 ∧
      laurentEval 2 ≠
        (2 : Complex)⁻¹ ^ 2 • coeffNeg2 + (2 : Complex)⁻¹ • coeffNeg1 +
          coeffZero + (2 : Complex) • coeffPos1 := by
  sorry

end

end PhysicsSM.Draft.NullEdge.ReciprocalLaurentRange
