import Mathlib

/-!
# Exact slice no-go for the chirality-coupled reciprocal walk

Complete every proof without changing any declaration signature. Do not add
assumptions and do not replace the unit-circle existential statements by
sampled or approximate claims.

The matrices use the repository convention
`alpha3 = sigma_x tensor sigma_z`, `Xi = sigma_x tensor I`. The coupled
generator anticommutes with `Xi`; the conditional shift acts on the second
tensor factor. The slice is `q_x = pi`, `q_y = 0`, with `z = exp(i q_z)`.

The two final theorems are the manuscript consequence: this exact-unitary,
quadratically-flat, chirality-coupled reciprocal architecture has additional
zero- and pi-quasienergy crossings and therefore is not alias-free.
-/

open Matrix Complex

noncomputable section

namespace CoupledReciprocalSliceNoGo

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

def alpha3 : M4 :=
  !![0, 0, 1, 0;
     0, 0, 0, -1;
     1, 0, 0, 0;
     0, -1, 0, 0]

def Xi : M4 :=
  !![0, 0, 1, 0;
     0, 0, 0, 1;
     1, 0, 0, 0;
     0, 1, 0, 0]

def coupledGenerator : M4 :=
  !![0, 1, 0, 0;
     1, 0, 0, 0;
     0, 0, 0, -1;
     0, 0, -1, 0]

def coupledCoin : M4 :=
  (3 / 5 : Complex) • 1 + (I * (4 / 5 : Complex)) • coupledGenerator

def coupledCoinInv : M4 :=
  (3 / 5 : Complex) • 1 - (I * (4 / 5 : Complex)) • coupledGenerator

def conditionalShift4 (z : Complex) : M4 :=
  !![z, 0, 0, 0;
     0, 1, 0, 0;
     0, 0, z, 0;
     0, 0, 0, 1]

def coupledCommutator (z : Complex) : M4 :=
  conditionalShift4 z * coupledCoin * conditionalShift4 z⁻¹ * coupledCoinInv

def coupledReciprocal (z : Complex) : M4 :=
  coupledCommutator z * coupledCommutator z⁻¹

def axis3LaurentFactor (z : Complex) : M4 :=
  ((z + z⁻¹) / 2) • 1 - ((z - z⁻¹) / 2) • alpha3

/-- The complete candidate restricted to `q_x=pi`, `q_y=0`. -/
def sliceWalk (z : Complex) : M4 :=
  -(coupledReciprocal (-1) * coupledReciprocal z * axis3LaurentFactor z)

def positiveQuartic (z : Complex) : Complex :=
  11376 * z ^ 4 + 143521 * z ^ 3 - 187294 * z ^ 2 + 143521 * z + 11376

def negativeQuartic (z : Complex) : Complex :=
  11376 * z ^ 4 - 637729 * z ^ 3 - 187294 * z ^ 2 - 637729 * z + 11376

def positiveReduced (x : Real) : Real :=
  11376 * x ^ 2 + 143521 * x - 210046

def negativeReduced (x : Real) : Real :=
  11376 * x ^ 2 - 637729 * x - 210046

theorem generator_anticommutes_Xi :
    Xi * coupledGenerator + coupledGenerator * Xi = 0 := by
  sorry

theorem coupledCoin_mul_inv : coupledCoin * coupledCoinInv = 1 := by
  sorry

theorem sliceWalk_det (z : Complex) (hz : z ≠ 0) :
    (sliceWalk z).det = 1 := by
  sorry

theorem slice_det_sub_one (z : Complex) (hz : z ≠ 0) :
    (sliceWalk z - 1).det =
      positiveQuartic z ^ 2 / (152587890625 * z ^ 4) := by
  sorry

theorem slice_det_add_one (z : Complex) (hz : z ≠ 0) :
    (sliceWalk z + 1).det =
      negativeQuartic z ^ 2 / (152587890625 * z ^ 4) := by
  sorry

theorem positive_reduced_signs :
    positiveReduced 1 = -55149 ∧ positiveReduced 2 = 122500 := by
  sorry

theorem negative_reduced_signs :
    negativeReduced (-1) = 439059 ∧ negativeReduced 0 = -210046 := by
  sorry

theorem exists_positive_reduced_root :
    ∃ x : Real, 1 < x ∧ x < 2 ∧ positiveReduced x = 0 := by
  sorry

theorem exists_negative_reduced_root :
    ∃ x : Real, -1 < x ∧ x < 0 ∧ negativeReduced x = 0 := by
  sorry

theorem positive_quartic_unit_circle_relation (q : Real) :
    positiveQuartic (Real.cos q + I * Real.sin q) =
      (Real.cos q + I * Real.sin q) ^ 2 •
        (positiveReduced (2 * Real.cos q) : Complex) := by
  sorry

theorem negative_quartic_unit_circle_relation (q : Real) :
    negativeQuartic (Real.cos q + I * Real.sin q) =
      (Real.cos q + I * Real.sin q) ^ 2 •
        (negativeReduced (2 * Real.cos q) : Complex) := by
  sorry

/-- Extra zero-quasienergy crossing on the exact physical unit circle. -/
theorem exists_additional_zero_crossing :
    ∃ q : Real, q ≠ 0 ∧
      (sliceWalk (Real.cos q + I * Real.sin q) - 1).det = 0 := by
  sorry

/-- Extra pi-quasienergy crossing on the exact physical unit circle. -/
theorem exists_additional_pi_crossing :
    ∃ q : Real, q ≠ 0 ∧
      (sliceWalk (Real.cos q + I * Real.sin q) + 1).det = 0 := by
  sorry

end CoupledReciprocalSliceNoGo
