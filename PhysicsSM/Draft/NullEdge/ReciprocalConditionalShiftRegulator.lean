import Mathlib

/-!
# Reciprocal conditional-shift regulator

This exact two-band fixture escapes the pi-periodicity obstruction for pure
involutory phase commutators.  A conditional shift `diag(z,1)` is noncentral at
`z=-1`.  Pairing its shift-coin commutator at `z` with the reciprocal word at
`z^-1` gives determinant one and a quadratic zero at `z=1`, yet removes both
zero- and pi-quasienergy crossings at `z=-1`.

The theorem is a construction primitive, not yet a complete 3+1 walk.

Provenance: internal exact fixture, independently checked by the run oracle;
all proof bodies were completed by Aristotle project
`eedbef62-106a-49c8-a722-1d1e046dffa0` on 2026-07-11.
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
  constructor <;> simp_all +decide [ Matrix.mul_assoc ]; all_goals simp_all +decide [ ← Matrix.mul_assoc, IsUnitary2 ]

theorem coin_mul_coinInv : coin * coinInv = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, coin, coinInv ] ;

theorem coinInv_mul_coin : coinInv * coin = 1 := by
  -- By definition of coin and coinInv, we can compute their product directly.
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [coin, coinInv]

theorem coin_conjTranspose : coin.conjTranspose = coinInv := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Matrix.mul_apply ] ;
  · unfold coin coinInv; norm_num;
  · unfold coin coinInv; norm_num;
  · unfold coin coinInv; norm_num;
  · unfold coin coinInv; norm_num;

theorem coin_unitary : IsUnitary2 coin := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Complex.ext_iff ];
  all_goals unfold coin; norm_num;

theorem conditionalShift_conjTranspose (z : Complex) :
    (conditionalShift z).conjTranspose = conditionalShift (starRingEnd Complex z) := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ conditionalShift ] ;

theorem conditionalShift_unitary (z : Complex) (hz : z ≠ 0)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary2 (conditionalShift z) := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply, Matrix.conjTranspose ];
  all_goals unfold conditionalShift; aesop;

theorem shiftCoinCommutator_unitary (z : Complex) (hz : z ≠ 0)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary2 (shiftCoinCommutator z) := by
  apply isUnitary2_mul (isUnitary2_mul (isUnitary2_mul (conditionalShift_unitary z hz hcircle) (coin_unitary)) (conditionalShift_unitary z⁻¹ (inv_ne_zero hz) (by
  aesop))) (by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Matrix.mul_apply ];
  all_goals unfold coinInv; norm_num;)

theorem reciprocalRegulator_unitary (z : Complex) (hz : z ≠ 0)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary2 (reciprocalRegulator z) := by
  apply isUnitary2_mul
  · exact shiftCoinCommutator_unitary z hz hcircle
  · convert shiftCoinCommutator_unitary z⁻¹ _ _ using 1 <;> aesop

theorem reciprocalRegulator_det (z : Complex) (hz : z ≠ 0) :
    (reciprocalRegulator z).det = 1 := by
  unfold reciprocalRegulator;
  unfold shiftCoinCommutator; norm_num [ hz ] ;
  unfold conditionalShift coin coinInv; norm_num [ hz, Matrix.det_fin_two ] ;

theorem reciprocalRegulator_one : reciprocalRegulator 1 = 1 := by
  convert coin_mul_coinInv using 1 ; unfold reciprocalRegulator ; unfold shiftCoinCommutator ; unfold conditionalShift ; unfold coin ; unfold coinInv ; norm_num [ Matrix.mul_apply ] ;

/-- Closed form of the shift-coin commutator away from `z = 0`. -/
theorem shiftCoinCommutator_eq (z : Complex) (hz : z ≠ 0) :
    shiftCoinCommutator z =
      !![9 / 25 + 16 / 25 * z, 12 / 25 * (z - 1);
          12 / 25 * (1 - z⁻¹), 9 / 25 + 16 / 25 * z⁻¹] := by
  unfold shiftCoinCommutator conditionalShift coin coinInv
  ext i j
  fin_cases i <;> fin_cases j <;>
    · simp [Matrix.mul_apply, Fin.sum_univ_two]
      field_simp
      ring

/-- Exact quadratic flatness at the intended origin. -/
theorem reciprocalRegulator_sub_one_factor (z : Complex) (hz : z ≠ 0) :
    reciprocalRegulator z - 1 = (z - 1) ^ 2 • quadraticCoefficient z := by
  have hzi : z⁻¹ ≠ 0 := inv_ne_zero hz
  rw [reciprocalRegulator, shiftCoinCommutator_eq z hz, shiftCoinCommutator_eq z⁻¹ hzi, inv_inv]
  ext i j
  fin_cases i <;> fin_cases j <;>
    · simp [quadraticCoefficient]
      field_simp
      ring

theorem reciprocalRegulator_neg_one :
    reciprocalRegulator (-1) =
      !![-527 / 625, 336 / 625; -336 / 625, -527 / 625] := by
  unfold reciprocalRegulator shiftCoinCommutator conditionalShift coin coinInv; norm_num [ ← List.ofFn_inj ] ;

theorem neg_one_det_sub_one :
    (reciprocalRegulator (-1) - 1).det = 2304 / 625 := by
  rw [ reciprocalRegulator_neg_one ] ; norm_num [ Matrix.det_fin_two ]

theorem neg_one_det_add_one :
    (reciprocalRegulator (-1) + 1).det = 196 / 625 := by
  rw [ reciprocalRegulator_neg_one ] ; norm_num [ Matrix.det_fin_two ] ;

/-
The old corner is neither a zero- nor a pi-quasienergy crossing after this
regulator is applied to an identity baseline.
-/
theorem neg_one_has_no_zero_or_pi_crossing :
    (reciprocalRegulator (-1) - 1).det ≠ 0 ∧
      (reciprocalRegulator (-1) + 1).det ≠ 0 := by
  norm_num [ neg_one_det_sub_one, neg_one_det_add_one ]

/-
The primitive really uses a noncentral conditional shift at the corner.
-/
theorem conditionalShift_neg_one_noncentral :
    ∀ w : Complex, conditionalShift (-1) ≠ w • 1 := by
  intro w hw; have := congr_fun ( congr_fun hw 0 ) 0; have := congr_fun ( congr_fun hw 1 ) 1; norm_num at *;
  norm_num [ ← this, conditionalShift ] at *

end

end PhysicsSM.Draft.NullEdge.ReciprocalConditionalShiftRegulator
