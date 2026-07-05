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
