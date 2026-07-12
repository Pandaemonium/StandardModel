import Mathlib

/-!
# Reciprocal conditional-shift regulator

This exact two-band fixture escapes the pi-periodicity obstruction for pure
involutory phase commutators.  A conditional shift `diag(z,1)` is noncentral at
`z=-1`.  Pairing its shift-coin commutator at `z` with the reciprocal word at
`z^-1` gives determinant one and a quadratic zero at `z=1`, yet removes both
zero- and pi-quasienergy crossings at `z=-1`.

The theorem is a construction primitive, not yet a complete 3+1 walk.
-/

namespace PhysicsSM.Draft.NullEdge.ReciprocalConditionalShiftRegulator

open Matrix Complex

noncomputable section

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

def coin : M2 := !![3 / 5, 4 / 5; -4 / 5, 3 / 5]

def coinInv : M2 := !![3 / 5, -4 / 5; 4 / 5, 3 / 5]

def conditionalShift (z : Complex) : M2 := !![z, 0; 0, 1]

def shiftCoinCommutator (z : Complex) : M2 :=
  conditionalShift z * coin * conditionalShift z⁻¹ * coinInv

def reciprocalRegulator (z : Complex) : M2 :=
  shiftCoinCommutator z * shiftCoinCommutator z⁻¹

def quadraticCoefficient (z : Complex) : M2 :=
  !![-144 * (z - 1) / (625 * z),
      12 * (16 * z + 9) / (625 * z);
      -12 * (9 * z + 16) / (625 * z ^ 2),
      144 * (z - 1) / (625 * z ^ 2)]

def IsUnitary2 (U : M2) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

theorem isUnitary2_mul {U V : M2}
    (hU : IsUnitary2 U) (hV : IsUnitary2 V) : IsUnitary2 (U * V) := by
  sorry

theorem coin_mul_coinInv : coin * coinInv = 1 := by
  sorry

theorem coinInv_mul_coin : coinInv * coin = 1 := by
  sorry

theorem coin_conjTranspose : coin.conjTranspose = coinInv := by
  sorry

theorem coin_unitary : IsUnitary2 coin := by
  sorry

theorem conditionalShift_conjTranspose (z : Complex) :
    (conditionalShift z).conjTranspose = conditionalShift (starRingEnd Complex z) := by
  sorry

theorem conditionalShift_unitary (z : Complex) (hz : z ≠ 0)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary2 (conditionalShift z) := by
  sorry

theorem shiftCoinCommutator_unitary (z : Complex) (hz : z ≠ 0)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary2 (shiftCoinCommutator z) := by
  sorry

theorem reciprocalRegulator_unitary (z : Complex) (hz : z ≠ 0)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary2 (reciprocalRegulator z) := by
  sorry

theorem reciprocalRegulator_det (z : Complex) (hz : z ≠ 0) :
    (reciprocalRegulator z).det = 1 := by
  sorry

theorem reciprocalRegulator_one : reciprocalRegulator 1 = 1 := by
  sorry

/-- Exact quadratic flatness at the intended origin. -/
theorem reciprocalRegulator_sub_one_factor (z : Complex) (hz : z ≠ 0) :
    reciprocalRegulator z - 1 = (z - 1) ^ 2 • quadraticCoefficient z := by
  sorry

theorem reciprocalRegulator_neg_one :
    reciprocalRegulator (-1) =
      !![-527 / 625, 336 / 625; -336 / 625, -527 / 625] := by
  sorry

theorem neg_one_det_sub_one :
    (reciprocalRegulator (-1) - 1).det = 2304 / 625 := by
  sorry

theorem neg_one_det_add_one :
    (reciprocalRegulator (-1) + 1).det = 196 / 625 := by
  sorry

/-- The old corner is neither a zero- nor a pi-quasienergy crossing after this
regulator is applied to an identity baseline. -/
theorem neg_one_has_no_zero_or_pi_crossing :
    (reciprocalRegulator (-1) - 1).det ≠ 0 ∧
      (reciprocalRegulator (-1) + 1).det ≠ 0 := by
  sorry

/-- The primitive really uses a noncentral conditional shift at the corner. -/
theorem conditionalShift_neg_one_noncentral :
    ∀ w : Complex, conditionalShift (-1) ≠ w • 1 := by
  sorry

end

end PhysicsSM.Draft.NullEdge.ReciprocalConditionalShiftRegulator
