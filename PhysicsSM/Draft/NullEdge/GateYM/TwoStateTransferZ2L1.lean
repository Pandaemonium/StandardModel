import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferWitness

/-!
# Gate YM: one-link Z2 slab bridge to the two-state payload

This module formalizes the smallest exact Wilson-slab transfer kernel used by
the executable Z2 oracle: one spatial Z2 link (`L = 1`) and one gauge-summed
temporal link.  In this case the slab kernel is exactly the two-state matrix

`!![2 * exp beta, 2 * exp (-beta);
    2 * exp (-beta), 2 * exp beta]`.

The result is a Lean/oracle bridge for the smallest descriptor shape.  It does
not construct the full Wilson slab transfer operator, Gauss projection,
OS/GNS Hilbert space, Hamiltonian, infinite-volume state, or physical mass-gap
theorem.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: finite identity / one-link descriptor bridge.
-/

noncomputable section

open scoped BigOperators Matrix

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TwoStateTransferZ2L1

open TwoStateTransferSpectrum

/-- Z2 sign encoded by the two finite states: `0` is `+1`, `1` is `-1`. -/
def bitSign (s : Fin 2) : ℝ :=
  if s = 0 then 1 else -1

/-- The square of any encoded Z2 sign is one. -/
theorem bitSign_mul_self (s : Fin 2) :
    bitSign s * bitSign s = 1 := by
  fin_cases s <;> simp [bitSign]

/-- The one-link temporal plaquette sign
`a * v * a * u` from the Z2 oracle convention. -/
def plaquetteSign (a u v : Fin 2) : ℝ :=
  bitSign a * bitSign v * bitSign a * bitSign u

/-- Gauge-summed one-link Wilson slab weight. -/
def slabWeight (beta : ℝ) (u v : Fin 2) : ℝ :=
  ∑ a : Fin 2, Real.exp (beta * plaquetteSign a u v)

/-- The diagonal transfer weight in the one-link Z2 slab kernel. -/
def diagonalWeight (beta : ℝ) : ℝ :=
  2 * Real.exp beta

/-- The off-diagonal transfer weight in the one-link Z2 slab kernel. -/
def offDiagonalWeight (beta : ℝ) : ℝ :=
  2 * Real.exp (-beta)

/-- The explicit one-link Z2 slab transfer matrix. -/
def slabTransfer (beta : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.of fun u v => (slabWeight beta u v : ℂ)

/-- The one-link spatial-flux observable as a diagonal insertion matrix. -/
def fluxMatrix : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.of fun u v => if u = v then (bitSign u : ℂ) else 0

/-- The `L = 1` global-center flip matrix, sending each spatial state to its
opposite Z2 state. -/
def centerFlipMatrix : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(0 : ℂ), 1; 1, 0]

/-- The `+1` global-center-sector projector for the one-link state space. -/
def centerPlusProjector : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(1 / 2 : ℂ), 1 / 2; 1 / 2, 1 / 2]

/-- The `-1` global-center-sector projector for the one-link state space. -/
def centerMinusProjector : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(1 / 2 : ℂ), -1 / 2; -1 / 2, 1 / 2]

/-- On equal boundary states the one-link slab weight is `2 * exp beta`. -/
theorem slabWeight_same (beta : ℝ) (u : Fin 2) :
    slabWeight beta u u = diagonalWeight beta := by
  fin_cases u <;>
    simp [slabWeight, diagonalWeight, plaquetteSign, bitSign, Fin.sum_univ_two] <;>
    ring

/-- On distinct boundary states the one-link slab weight is `2 * exp (-beta)`. -/
theorem slabWeight_ne {beta : ℝ} {u v : Fin 2} (huv : u ≠ v) :
    slabWeight beta u v = offDiagonalWeight beta := by
  fin_cases u <;> fin_cases v <;>
    simp [slabWeight, offDiagonalWeight, plaquetteSign, bitSign,
      Fin.sum_univ_two] at huv ⊢ <;>
    ring

/-- The one-link Z2 Wilson slab transfer matrix is exactly the two-state
transfer payload with `a = 2 * exp beta` and `b = 2 * exp (-beta)`. -/
theorem slabTransfer_eq_transfer2 (beta : ℝ) :
    slabTransfer beta =
      transfer2 (diagonalWeight beta) (offDiagonalWeight beta) := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    simp [slabTransfer, slabWeight, diagonalWeight, offDiagonalWeight,
      plaquetteSign, bitSign, transfer2, Fin.sum_univ_two] <;>
    ring

/-- The concrete one-link Z2 slab transfer matrix is symmetric. -/
theorem slabTransfer_transpose (beta : ℝ) :
    (slabTransfer beta)ᵀ = slabTransfer beta := by
  rw [slabTransfer_eq_transfer2]
  exact transfer2_transpose (diagonalWeight beta) (offDiagonalWeight beta)

/-- The concrete one-link Z2 slab transfer matrix is Hermitian. -/
theorem slabTransfer_conjTranspose (beta : ℝ) :
    (slabTransfer beta)ᴴ = slabTransfer beta := by
  rw [slabTransfer_eq_transfer2]
  exact transfer2_conjTranspose (diagonalWeight beta) (offDiagonalWeight beta)

/-- The one-link slab transfer has the vacuum vector with eigenvalue
`2 * (exp beta + exp (-beta))`. -/
theorem slabTransfer_mulVec_vacuum (beta : ℝ) :
    slabTransfer beta *ᵥ vacuumVec =
      ((2 * (Real.exp beta + Real.exp (-beta)) : ℝ) : ℂ) • vacuumVec := by
  funext u
  fin_cases u <;>
    simp [slabTransfer, slabWeight, plaquetteSign, bitSign, Matrix.mulVec,
      dotProduct, vacuumVec, Fin.sum_univ_two] <;>
    ring

/-- The one-link slab transfer has the local/flux vector with eigenvalue
`2 * (exp beta - exp (-beta))`. -/
theorem slabTransfer_mulVec_local (beta : ℝ) :
    slabTransfer beta *ᵥ localVec =
      ((2 * (Real.exp beta - Real.exp (-beta)) : ℝ) : ℂ) • localVec := by
  funext u
  fin_cases u <;>
    simp [slabTransfer, slabWeight, plaquetteSign, bitSign, Matrix.mulVec,
      dotProduct, localVec, Fin.sum_univ_two] <;>
    ring

/-- The one-link spatial-flux insertion is Hermitian. -/
theorem fluxMatrix_conjTranspose :
    fluxMatrixᴴ = fluxMatrix := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    simp [fluxMatrix, Matrix.conjTranspose, bitSign]

/-- The one-link spatial-flux insertion squares to the identity. -/
theorem fluxMatrix_sq :
    fluxMatrix * fluxMatrix = 1 := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    simp [fluxMatrix, Matrix.mul_apply, bitSign]

/-- The spatial-flux insertion sends the vacuum vector to the local/flux
eigenvector. -/
theorem fluxMatrix_mulVec_vacuum :
    fluxMatrix *ᵥ vacuumVec = localVec := by
  funext u
  fin_cases u <;>
    simp [fluxMatrix, Matrix.mulVec, dotProduct, vacuumVec, localVec, bitSign]

/-- The spatial-flux insertion sends the local/flux eigenvector back to the
vacuum vector. -/
theorem fluxMatrix_mulVec_local :
    fluxMatrix *ᵥ localVec = vacuumVec := by
  funext u
  fin_cases u <;>
    simp [fluxMatrix, Matrix.mulVec, dotProduct, vacuumVec, localVec, bitSign]

/-- The center flip fixes the vacuum vector. -/
theorem centerFlipMatrix_mulVec_vacuum :
    centerFlipMatrix *ᵥ vacuumVec = vacuumVec := by
  funext u
  fin_cases u <;>
    simp [centerFlipMatrix, Matrix.mulVec, dotProduct, vacuumVec,
      Fin.sum_univ_two]

/-- The center flip acts by `-1` on the local/flux vector. -/
theorem centerFlipMatrix_mulVec_local :
    centerFlipMatrix *ᵥ localVec = (-1 : ℂ) • localVec := by
  funext u
  fin_cases u <;>
    simp [centerFlipMatrix, Matrix.mulVec, dotProduct, localVec,
      Fin.sum_univ_two]

/-- The center flip is involutive on the one-link two-state sector. -/
theorem centerFlipMatrix_sq :
    centerFlipMatrix * centerFlipMatrix = 1 := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerFlipMatrix, Matrix.mul_apply, Fin.sum_univ_two]

/-- The center-sector projectors are complementary. -/
theorem centerPlus_add_centerMinus :
    centerPlusProjector + centerMinusProjector = 1 := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerPlusProjector, centerMinusProjector]

/-- The center-sector projectors are orthogonal. -/
theorem centerPlus_mul_centerMinus :
    centerPlusProjector * centerMinusProjector = 0 := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerPlusProjector, centerMinusProjector, Matrix.mul_apply,
      Fin.sum_univ_two]

/-- The plus-sector center projector is idempotent. -/
theorem centerPlusProjector_mul_self :
    centerPlusProjector * centerPlusProjector = centerPlusProjector := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerPlusProjector, Matrix.mul_apply, Fin.sum_univ_two]

/-- The minus-sector center projector is idempotent. -/
theorem centerMinusProjector_mul_self :
    centerMinusProjector * centerMinusProjector = centerMinusProjector := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerMinusProjector, Matrix.mul_apply, Fin.sum_univ_two]

/-- The center flip fixes the plus-sector projector on the left. -/
theorem centerFlip_mul_centerPlus :
    centerFlipMatrix * centerPlusProjector = centerPlusProjector := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerFlipMatrix, centerPlusProjector, Matrix.mul_apply,
      Fin.sum_univ_two]

/-- The center flip acts by `-1` on the minus-sector projector on the left. -/
theorem centerFlip_mul_centerMinus :
    centerFlipMatrix * centerMinusProjector =
      (-1 : ℂ) • centerMinusProjector := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerFlipMatrix, centerMinusProjector, Matrix.mul_apply,
      Fin.sum_univ_two]

/-- The center flip fixes the plus-sector projector on the right. -/
theorem centerPlus_mul_centerFlip :
    centerPlusProjector * centerFlipMatrix = centerPlusProjector := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerFlipMatrix, centerPlusProjector, Matrix.mul_apply,
      Fin.sum_univ_two]

/-- The center flip acts by `-1` on the minus-sector projector on the right. -/
theorem centerMinus_mul_centerFlip :
    centerMinusProjector * centerFlipMatrix =
      (-1 : ℂ) • centerMinusProjector := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerFlipMatrix, centerMinusProjector, Matrix.mul_apply,
      Fin.sum_univ_two]

/-- The spatial-flux insertion anticommutes with the center flip. -/
theorem centerFlip_mul_fluxMatrix :
    centerFlipMatrix * fluxMatrix =
      (-1 : ℂ) • (fluxMatrix * centerFlipMatrix) := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerFlipMatrix, fluxMatrix, bitSign, Matrix.mul_apply,
      Fin.sum_univ_two]

/-- Multiplying by the spatial-flux insertion on the right sends the
plus-sector projector to the minus sector. -/
theorem centerPlus_mul_flux_eq_flux_mul_centerMinus :
    centerPlusProjector * fluxMatrix = fluxMatrix * centerMinusProjector := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerPlusProjector, centerMinusProjector, fluxMatrix, bitSign,
      Matrix.mul_apply, Fin.sum_univ_two]

/-- Multiplying by the spatial-flux insertion on the right sends the
minus-sector projector to the plus sector. -/
theorem centerMinus_mul_flux_eq_flux_mul_centerPlus :
    centerMinusProjector * fluxMatrix = fluxMatrix * centerPlusProjector := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerPlusProjector, centerMinusProjector, fluxMatrix, bitSign,
      Matrix.mul_apply, Fin.sum_univ_two]

/-- Multiplying by the spatial-flux insertion on the left sends the plus-sector
projector to the minus sector. -/
theorem flux_mul_centerPlus_eq_centerMinus_mul_flux :
    fluxMatrix * centerPlusProjector = centerMinusProjector * fluxMatrix := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerPlusProjector, centerMinusProjector, fluxMatrix, bitSign,
      Matrix.mul_apply, Fin.sum_univ_two]

/-- Multiplying by the spatial-flux insertion on the left sends the
minus-sector projector to the plus sector. -/
theorem flux_mul_centerMinus_eq_centerPlus_mul_flux :
    fluxMatrix * centerMinusProjector = centerPlusProjector * fluxMatrix := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    norm_num [centerPlusProjector, centerMinusProjector, fluxMatrix, bitSign,
      Matrix.mul_apply, Fin.sum_univ_two]

/-- The plus-sector projector fixes the vacuum vector. -/
theorem centerPlusProjector_mulVec_vacuum :
    centerPlusProjector *ᵥ vacuumVec = vacuumVec := by
  funext u
  fin_cases u <;>
    norm_num [centerPlusProjector, Matrix.mulVec, dotProduct, vacuumVec,
      Fin.sum_univ_two]

/-- The minus-sector projector kills the vacuum vector. -/
theorem centerMinusProjector_mulVec_vacuum :
    centerMinusProjector *ᵥ vacuumVec = 0 := by
  funext u
  fin_cases u <;>
    norm_num [centerMinusProjector, Matrix.mulVec, dotProduct, vacuumVec,
      Fin.sum_univ_two]

/-- The plus-sector projector kills the local/flux vector. -/
theorem centerPlusProjector_mulVec_local :
    centerPlusProjector *ᵥ localVec = 0 := by
  funext u
  fin_cases u <;>
    norm_num [centerPlusProjector, Matrix.mulVec, dotProduct, localVec,
      Fin.sum_univ_two]

/-- The minus-sector projector fixes the local/flux vector. -/
theorem centerMinusProjector_mulVec_local :
    centerMinusProjector *ᵥ localVec = localVec := by
  funext u
  fin_cases u <;>
    norm_num [centerMinusProjector, Matrix.mulVec, dotProduct, localVec,
      Fin.sum_univ_two]

/-- The concrete one-link transfer commutes with the center flip. -/
theorem slabTransfer_mul_centerFlip_eq_centerFlip_mul_slabTransfer (beta : ℝ) :
    slabTransfer beta * centerFlipMatrix =
      centerFlipMatrix * slabTransfer beta := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    simp [slabTransfer, slabWeight, centerFlipMatrix, Matrix.mul_apply,
      plaquetteSign, bitSign, Fin.sum_univ_two]

/-- The concrete one-link transfer commutes with the plus-sector projector. -/
theorem slabTransfer_mul_centerPlus_eq_centerPlus_mul_slabTransfer (beta : ℝ) :
    slabTransfer beta * centerPlusProjector =
      centerPlusProjector * slabTransfer beta := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    simp [slabTransfer, slabWeight, centerPlusProjector, Matrix.mul_apply,
      plaquetteSign, bitSign, Fin.sum_univ_two] <;>
    ring

/-- The concrete one-link transfer commutes with the minus-sector projector. -/
theorem slabTransfer_mul_centerMinus_eq_centerMinus_mul_slabTransfer (beta : ℝ) :
    slabTransfer beta * centerMinusProjector =
      centerMinusProjector * slabTransfer beta := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    simp [slabTransfer, slabWeight, centerMinusProjector, Matrix.mul_apply,
      plaquetteSign, bitSign, Fin.sum_univ_two] <;>
    ring

/-- Right multiplication by the one-link transfer scales the plus-center
projector by the vacuum branch eigenvalue. -/
theorem centerPlus_mul_slabTransfer_eq (beta : ℝ) :
    centerPlusProjector * slabTransfer beta =
      (((2 * (Real.exp beta + Real.exp (-beta)) : ℝ) : ℂ) •
        centerPlusProjector) := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    simp [centerPlusProjector, slabTransfer, slabWeight, plaquetteSign,
      bitSign, Matrix.mul_apply, Fin.sum_univ_two] <;>
    ring

/-- Right multiplication by the one-link transfer scales the minus-center
projector by the local/flux branch eigenvalue. -/
theorem centerMinus_mul_slabTransfer_eq (beta : ℝ) :
    centerMinusProjector * slabTransfer beta =
      (((2 * (Real.exp beta - Real.exp (-beta)) : ℝ) : ℂ) •
        centerMinusProjector) := by
  ext u v
  fin_cases u <;> fin_cases v <;>
    simp [centerMinusProjector, slabTransfer, slabWeight, plaquetteSign,
      bitSign, Matrix.mul_apply, Fin.sum_univ_two] <;>
    ring

/-- The plus-center projector followed by an arbitrary finite transfer power
is the plus-sector eigenvalue power times the projector. -/
theorem centerPlus_mul_slabTransfer_pow (beta : ℝ) (T : ℕ) :
    centerPlusProjector * (slabTransfer beta) ^ T =
      ((((2 * (Real.exp beta + Real.exp (-beta)) : ℝ) : ℂ) ^ T) •
        centerPlusProjector) := by
  induction T with
  | zero => simp
  | succ T ih =>
      rw [pow_succ]
      rw [← Matrix.mul_assoc, ih]
      rw [Matrix.smul_mul]
      rw [centerPlus_mul_slabTransfer_eq]
      rw [smul_smul]
      rw [pow_succ]

/-- The minus-center projector followed by an arbitrary finite transfer power
is the minus-sector eigenvalue power times the projector. -/
theorem centerMinus_mul_slabTransfer_pow (beta : ℝ) (T : ℕ) :
    centerMinusProjector * (slabTransfer beta) ^ T =
      ((((2 * (Real.exp beta - Real.exp (-beta)) : ℝ) : ℂ) ^ T) •
        centerMinusProjector) := by
  induction T with
  | zero => simp
  | succ T ih =>
      rw [pow_succ]
      rw [← Matrix.mul_assoc, ih]
      rw [Matrix.smul_mul]
      rw [centerMinus_mul_slabTransfer_eq]
      rw [smul_smul]
      rw [pow_succ]

/-- The one-step one-link transfer trace is the exact finite partition trace
`4 * exp beta`. -/
theorem slabTransfer_trace (beta : ℝ) :
    Matrix.trace (slabTransfer beta) = ((4 * Real.exp beta : ℝ) : ℂ) := by
  simp [Matrix.trace, slabTransfer, slabWeight, plaquetteSign, bitSign,
    Fin.sum_univ_two]
  ring

/-- The plus-center projected one-step transfer trace is the vacuum branch
`2 * (exp beta + exp (-beta))`. -/
theorem centerPlusProjector_mul_slabTransfer_trace (beta : ℝ) :
    Matrix.trace (centerPlusProjector * slabTransfer beta) =
      ((2 * (Real.exp beta + Real.exp (-beta)) : ℝ) : ℂ) := by
  rw [slabTransfer_eq_transfer2]
  simp [Matrix.trace, centerPlusProjector, transfer2, diagonalWeight,
    offDiagonalWeight, Fin.sum_univ_two]
  ring

/-- The minus-center projected one-step transfer trace is the local/flux branch
`2 * (exp beta - exp (-beta))`. -/
theorem centerMinusProjector_mul_slabTransfer_trace (beta : ℝ) :
    Matrix.trace (centerMinusProjector * slabTransfer beta) =
      ((2 * (Real.exp beta - Real.exp (-beta)) : ℝ) : ℂ) := by
  rw [slabTransfer_eq_transfer2]
  simp [Matrix.trace, centerMinusProjector, transfer2, diagonalWeight,
    offDiagonalWeight, Fin.sum_univ_two]
  ring

/-- The plus/minus center-projected one-step traces reconstruct the full
one-link transfer trace. -/
theorem centerProjected_traces_sum_eq_slabTransfer_trace (beta : ℝ) :
    Matrix.trace (centerPlusProjector * slabTransfer beta) +
        Matrix.trace (centerMinusProjector * slabTransfer beta) =
      Matrix.trace (slabTransfer beta) := by
  rw [centerPlusProjector_mul_slabTransfer_trace,
    centerMinusProjector_mul_slabTransfer_trace, slabTransfer_trace]
  norm_num
  ring

/-- The ratio of the minus-sector and plus-sector one-step transfer traces is
the same one-link contraction factor `tanh beta`. -/
theorem centerMinus_trace_div_centerPlus_trace_eq_tanh (beta : ℝ) :
    Matrix.trace (centerMinusProjector * slabTransfer beta) /
        Matrix.trace (centerPlusProjector * slabTransfer beta) =
      ((Real.tanh beta : ℝ) : ℂ) := by
  rw [centerMinusProjector_mul_slabTransfer_trace,
    centerPlusProjector_mul_slabTransfer_trace]
  rw [Real.tanh_eq]
  norm_cast
  have hden :
      Real.exp beta + Real.exp (-beta) ≠ 0 := by
    positivity
  field_simp [hden]

/-- A single time-zero spatial-flux insertion has zero one-step trace in the
one-link slab model. -/
theorem fluxMatrix_mul_slabTransfer_trace (beta : ℝ) :
    Matrix.trace (fluxMatrix * slabTransfer beta) = 0 := by
  simp [Matrix.trace, Matrix.mul_apply, fluxMatrix, slabTransfer, slabWeight,
    plaquetteSign, bitSign, Fin.sum_univ_two]
  ring

/-- The normalized `L = 1`, `T = 1` spatial-flux expectation is zero. -/
theorem fluxExpectation_T1_eq_zero (beta : ℝ) :
    Matrix.trace (fluxMatrix * slabTransfer beta) /
        Matrix.trace (slabTransfer beta) = 0 := by
  rw [fluxMatrix_mul_slabTransfer_trace]
  simp

/-- The two-step one-link transfer trace, matching the `T = 2` partition
trace at `L = 1`. -/
theorem slabTransfer_sq_trace (beta : ℝ) :
    Matrix.trace (slabTransfer beta * slabTransfer beta) =
      ((8 * (Real.exp beta * Real.exp beta
        + Real.exp (-beta) * Real.exp (-beta)) : ℝ) : ℂ) := by
  simp [Matrix.trace, Matrix.mul_apply, slabTransfer, slabWeight,
    plaquetteSign, bitSign, Fin.sum_univ_two]
  ring

/-- The plus-center projected two-step transfer trace is the square of the
vacuum branch eigenvalue. -/
theorem centerPlusProjector_mul_slabTransfer_sq_trace (beta : ℝ) :
    Matrix.trace
        (centerPlusProjector * (slabTransfer beta * slabTransfer beta)) =
      ((4 * (Real.exp beta + Real.exp (-beta)) ^ 2 : ℝ) : ℂ) := by
  rw [slabTransfer_eq_transfer2]
  simp [Matrix.trace, centerPlusProjector, transfer2, diagonalWeight,
    offDiagonalWeight, Fin.sum_univ_two]
  ring

/-- The minus-center projected two-step transfer trace is the square of the
local/flux branch eigenvalue. -/
theorem centerMinusProjector_mul_slabTransfer_sq_trace (beta : ℝ) :
    Matrix.trace
        (centerMinusProjector * (slabTransfer beta * slabTransfer beta)) =
      ((4 * (Real.exp beta - Real.exp (-beta)) ^ 2 : ℝ) : ℂ) := by
  rw [slabTransfer_eq_transfer2]
  simp [Matrix.trace, centerMinusProjector, transfer2, diagonalWeight,
    offDiagonalWeight, Fin.sum_univ_two]
  ring

/-- The plus/minus center-projected two-step traces reconstruct the full
two-step transfer trace. -/
theorem centerProjected_sq_traces_sum_eq_slabTransfer_sq_trace (beta : ℝ) :
    Matrix.trace
        (centerPlusProjector * (slabTransfer beta * slabTransfer beta)) +
        Matrix.trace
          (centerMinusProjector * (slabTransfer beta * slabTransfer beta)) =
      Matrix.trace (slabTransfer beta * slabTransfer beta) := by
  rw [centerPlusProjector_mul_slabTransfer_sq_trace,
    centerMinusProjector_mul_slabTransfer_sq_trace, slabTransfer_sq_trace]
  norm_num
  ring

/-- The ratio of the two-step minus-sector and plus-sector transfer traces is
the square of the one-link contraction factor. -/
theorem centerMinus_sq_trace_div_centerPlus_sq_trace_eq_tanh_sq (beta : ℝ) :
    Matrix.trace
        (centerMinusProjector * (slabTransfer beta * slabTransfer beta)) /
        Matrix.trace
          (centerPlusProjector * (slabTransfer beta * slabTransfer beta)) =
      ((Real.tanh beta ^ 2 : ℝ) : ℂ) := by
  rw [centerMinusProjector_mul_slabTransfer_sq_trace,
    centerPlusProjector_mul_slabTransfer_sq_trace]
  rw [Real.tanh_eq]
  norm_cast
  have hden :
      Real.exp beta + Real.exp (-beta) ≠ 0 := by
    positivity
  field_simp [hden]

/-- The plus-center projected arbitrary-time transfer trace is the vacuum
branch eigenvalue raised to the time extent. -/
theorem centerPlusProjector_mul_slabTransfer_pow_trace
    (beta : ℝ) (T : ℕ) :
    Matrix.trace (centerPlusProjector * (slabTransfer beta) ^ T) =
      (((2 * (Real.exp beta + Real.exp (-beta)) : ℝ) : ℂ) ^ T) := by
  rw [centerPlus_mul_slabTransfer_pow]
  simp [Matrix.trace, centerPlusProjector]
  ring

/-- The minus-center projected arbitrary-time transfer trace is the local/flux
branch eigenvalue raised to the time extent. -/
theorem centerMinusProjector_mul_slabTransfer_pow_trace
    (beta : ℝ) (T : ℕ) :
    Matrix.trace (centerMinusProjector * (slabTransfer beta) ^ T) =
      (((2 * (Real.exp beta - Real.exp (-beta)) : ℝ) : ℂ) ^ T) := by
  rw [centerMinus_mul_slabTransfer_pow]
  simp [Matrix.trace, centerMinusProjector]
  ring

/-- The full arbitrary-time one-link transfer trace splits into the plus and
minus center-sector eigenvalue powers. -/
theorem slabTransfer_pow_trace (beta : ℝ) (T : ℕ) :
    Matrix.trace ((slabTransfer beta) ^ T) =
      (((2 * (Real.exp beta + Real.exp (-beta)) : ℝ) : ℂ) ^ T) +
        (((2 * (Real.exp beta - Real.exp (-beta)) : ℝ) : ℂ) ^ T) := by
  calc
    Matrix.trace ((slabTransfer beta) ^ T)
        = Matrix.trace ((centerPlusProjector + centerMinusProjector) *
            (slabTransfer beta) ^ T) := by
          rw [centerPlus_add_centerMinus, one_mul]
    _ = Matrix.trace (centerPlusProjector * (slabTransfer beta) ^ T +
            centerMinusProjector * (slabTransfer beta) ^ T) := by
          rw [add_mul]
    _ = Matrix.trace (centerPlusProjector * (slabTransfer beta) ^ T) +
          Matrix.trace (centerMinusProjector * (slabTransfer beta) ^ T) := by
          simp [Matrix.trace, Fin.sum_univ_two]
          ring
    _ = _ := by
          rw [centerPlusProjector_mul_slabTransfer_pow_trace,
            centerMinusProjector_mul_slabTransfer_pow_trace]

/-- The plus/minus center-projected arbitrary-time traces reconstruct the full
one-link transfer trace at that time extent. -/
theorem centerProjected_pow_traces_sum_eq_slabTransfer_pow_trace
    (beta : ℝ) (T : ℕ) :
    Matrix.trace (centerPlusProjector * (slabTransfer beta) ^ T) +
        Matrix.trace (centerMinusProjector * (slabTransfer beta) ^ T) =
      Matrix.trace ((slabTransfer beta) ^ T) := by
  rw [slabTransfer_pow_trace,
    centerPlusProjector_mul_slabTransfer_pow_trace,
    centerMinusProjector_mul_slabTransfer_pow_trace]

/-- The ratio of arbitrary-time minus-sector and plus-sector transfer traces
is the corresponding power of the one-link contraction factor. -/
theorem centerMinus_pow_trace_div_centerPlus_pow_trace_eq_tanh_pow
    (beta : ℝ) (T : ℕ) :
    Matrix.trace (centerMinusProjector * (slabTransfer beta) ^ T) /
        Matrix.trace (centerPlusProjector * (slabTransfer beta) ^ T) =
      ((Real.tanh beta : ℝ) : ℂ) ^ T := by
  rw [centerMinusProjector_mul_slabTransfer_pow_trace,
    centerPlusProjector_mul_slabTransfer_pow_trace]
  rw [Real.tanh_eq]
  norm_cast
  have hden :
      Real.exp beta + Real.exp (-beta) ≠ 0 := by
    positivity
  rw [div_pow]
  field_simp [hden]
  rw [mul_pow, mul_pow]
  ring

/-- The arbitrary finite power of the one-link transfer splits into the
plus/minus center-sector projectors with the corresponding eigenvalue powers. -/
theorem slabTransfer_pow_eq_center_decomposition (beta : ℝ) (T : ℕ) :
    (slabTransfer beta) ^ T =
      ((((2 * (Real.exp beta + Real.exp (-beta)) : ℝ) : ℂ) ^ T) •
        centerPlusProjector) +
      ((((2 * (Real.exp beta - Real.exp (-beta)) : ℝ) : ℂ) ^ T) •
        centerMinusProjector) := by
  calc
    (slabTransfer beta) ^ T
        = (centerPlusProjector + centerMinusProjector) *
            (slabTransfer beta) ^ T := by
          rw [centerPlus_add_centerMinus, one_mul]
    _ = centerPlusProjector * (slabTransfer beta) ^ T +
          centerMinusProjector * (slabTransfer beta) ^ T := by
          rw [add_mul]
    _ = _ := by
          rw [centerPlus_mul_slabTransfer_pow, centerMinus_mul_slabTransfer_pow]

/-- The raw two-interval spatial-flux numerator for the one-link slab trace.

The spatial-flux insertion toggles the two center sectors, so the numerator
contains the two mixed eigenvalue-power products. -/
theorem fluxMatrix_slabTransfer_pow_fluxMatrix_slabTransfer_pow_trace
    (beta : ℝ) (tau sigma : ℕ) :
    Matrix.trace (fluxMatrix * (slabTransfer beta) ^ tau * fluxMatrix *
        (slabTransfer beta) ^ sigma) =
      ((((2 * (Real.exp beta - Real.exp (-beta)) : ℝ) : ℂ) ^ tau) *
          (((2 * (Real.exp beta + Real.exp (-beta)) : ℝ) : ℂ) ^ sigma) +
        (((2 * (Real.exp beta + Real.exp (-beta)) : ℝ) : ℂ) ^ tau) *
          (((2 * (Real.exp beta - Real.exp (-beta)) : ℝ) : ℂ) ^ sigma)) := by
  rw [slabTransfer_pow_eq_center_decomposition beta tau,
    slabTransfer_pow_eq_center_decomposition beta sigma]
  simp [Matrix.trace, Matrix.mul_apply, fluxMatrix, centerPlusProjector,
    centerMinusProjector, bitSign, Fin.sum_univ_two]
  ring

/-- The normalized two-interval spatial-flux autocorrelation ratio in the
one-link slab, written in the two center-sector eigenvalue branches. -/
theorem fluxCorrelation_pow_ratio_eq_eigenvalue_branches
    (beta : ℝ) (tau sigma : ℕ) :
    let lambdaPlus : ℂ :=
      ((2 * (Real.exp beta + Real.exp (-beta)) : ℝ) : ℂ)
    let lambdaMinus : ℂ :=
      ((2 * (Real.exp beta - Real.exp (-beta)) : ℝ) : ℂ)
    Matrix.trace (fluxMatrix * (slabTransfer beta) ^ tau * fluxMatrix *
        (slabTransfer beta) ^ sigma) /
        Matrix.trace ((slabTransfer beta) ^ (tau + sigma)) =
      (lambdaMinus ^ tau * lambdaPlus ^ sigma +
        lambdaPlus ^ tau * lambdaMinus ^ sigma) /
        (lambdaPlus ^ (tau + sigma) + lambdaMinus ^ (tau + sigma)) := by
  dsimp
  rw [fluxMatrix_slabTransfer_pow_fluxMatrix_slabTransfer_pow_trace,
    slabTransfer_pow_trace]

/-- The raw two-time spatial-flux numerator for the one-link, two-step slab
trace. -/
theorem fluxMatrix_slabTransfer_fluxMatrix_slabTransfer_trace (beta : ℝ) :
    Matrix.trace (fluxMatrix * slabTransfer beta * fluxMatrix * slabTransfer beta) =
      ((8 * (Real.exp beta * Real.exp beta
        - Real.exp (-beta) * Real.exp (-beta)) : ℝ) : ℂ) := by
  simp [Matrix.trace, Matrix.mul_apply, fluxMatrix, slabTransfer, slabWeight,
    plaquetteSign, bitSign, Fin.sum_univ_two]
  ring

/-- The normalized `L = 1`, `T = 2`, `tau = 1` spatial-flux autocorrelation
ratio is `tanh (2 * beta)`. -/
theorem fluxCorrelation_T2_eq_tanh_two_mul (beta : ℝ) :
    Matrix.trace (fluxMatrix * slabTransfer beta * fluxMatrix * slabTransfer beta) /
        Matrix.trace (slabTransfer beta * slabTransfer beta) =
      ((Real.tanh (2 * beta) : ℝ) : ℂ) := by
  rw [fluxMatrix_slabTransfer_fluxMatrix_slabTransfer_trace,
    slabTransfer_sq_trace]
  rw [Real.tanh_eq]
  norm_cast
  rw [show 2 * beta = beta + beta by ring, Real.exp_add,
    show -(beta + beta) = -beta + -beta by ring, Real.exp_add]
  have hden :
      Real.exp beta ^ 2 + Real.exp (-beta) ^ 2 ≠ 0 := by
    positivity
  have hden8 :
      Real.exp beta ^ 2 * 8 + Real.exp (-beta) ^ 2 * 8 ≠ 0 := by
    positivity
  field_simp [hden, hden8]

/-- For positive coupling, the one-link Z2 slab data forms a positive
two-state descriptor. -/
def descriptor (beta : ℝ) (hbeta : 0 < beta) : Descriptor where
  a := diagonalWeight beta
  b := offDiagonalWeight beta
  b_pos := by
    unfold offDiagonalWeight
    exact mul_pos (by norm_num) (Real.exp_pos _)
  b_lt_a := by
    unfold diagonalWeight offDiagonalWeight
    have hExp : Real.exp (-beta) < Real.exp beta := by
      exact Real.exp_lt_exp.mpr (by linarith)
    exact mul_lt_mul_of_pos_left hExp (by norm_num)

/-- The positive one-link descriptor matrix is the explicit slab transfer
matrix. -/
theorem descriptor_matrix_eq_slabTransfer (beta : ℝ) (hbeta : 0 < beta) :
    (descriptor beta hbeta).matrix = slabTransfer beta := by
  simpa [descriptor, Descriptor.matrix, diagonalWeight, offDiagonalWeight]
    using (slabTransfer_eq_transfer2 beta).symm

/-- The one-link descriptor's vacuum eigenvalue is
`2 * (exp beta + exp (-beta))`. -/
theorem descriptor_vacuumEigenvalue_eq
    (beta : ℝ) (hbeta : 0 < beta) :
    (descriptor beta hbeta).vacuumEigenvalue =
      2 * (Real.exp beta + Real.exp (-beta)) := by
  unfold descriptor Descriptor.vacuumEigenvalue lambda0 diagonalWeight
    offDiagonalWeight
  ring

/-- The one-link descriptor's local/flux eigenvalue is
`2 * (exp beta - exp (-beta))`. -/
theorem descriptor_localEigenvalue_eq
    (beta : ℝ) (hbeta : 0 < beta) :
    (descriptor beta hbeta).localEigenvalue =
      2 * (Real.exp beta - Real.exp (-beta)) := by
  unfold descriptor Descriptor.localEigenvalue lambdaLocal diagonalWeight
    offDiagonalWeight
  ring

/-- The one-link descriptor's local/vacuum contraction factor is exactly
`tanh beta`. -/
theorem descriptor_contractionFactor_eq_tanh
    (beta : ℝ) (hbeta : 0 < beta) :
    (descriptor beta hbeta).contractionFactor = Real.tanh beta := by
  rw [Real.tanh_eq]
  unfold descriptor Descriptor.contractionFactor localSpectralRatio lambdaLocal
    lambda0 diagonalWeight offDiagonalWeight
  have hsum : Real.exp beta + Real.exp (-beta) ≠ 0 := by
    exact ne_of_gt (add_pos (Real.exp_pos beta) (Real.exp_pos (-beta)))
  field_simp [hsum]

/-- The one-link Z2 slab descriptor inherits the positive finite-gap witness
from the two-state adapter. -/
def spectralWitness (beta : ℝ) (hbeta : 0 < beta) :
    FiniteGapAssembly.FiniteGapSpectralWitness TwoStateTransferSpectrum.State :=
  (descriptor beta hbeta).spectralWitness

/-- The one-link Z2 slab witness has a positive finite spectral-ratio gap. -/
theorem spectralWitness_gap_pos (beta : ℝ) (hbeta : 0 < beta) :
    0 < (spectralWitness beta hbeta).localGap := by
  exact (descriptor beta hbeta).spectralWitness_gap_pos

/-- The one-link Z2 slab contraction factor is recovered by exponentiating the
negative witness gap. -/
theorem spectralWitness_exp_neg_gap_eq_contractionFactor
    (beta : ℝ) (hbeta : 0 < beta) :
    Real.exp (-(spectralWitness beta hbeta).localGap) =
      (descriptor beta hbeta).contractionFactor := by
  exact (descriptor beta hbeta).spectralWitness_exp_neg_gap_eq_contractionFactor

/-- The one-link Z2 slab witness contraction factor is `tanh beta`. -/
theorem spectralWitness_exp_neg_gap_eq_tanh
    (beta : ℝ) (hbeta : 0 < beta) :
    Real.exp (-(spectralWitness beta hbeta).localGap) = Real.tanh beta := by
  rw [spectralWitness_exp_neg_gap_eq_contractionFactor beta hbeta,
    descriptor_contractionFactor_eq_tanh beta hbeta]

end TwoStateTransferZ2L1
end GateYM
end NullEdge
end Draft
end PhysicsSM
