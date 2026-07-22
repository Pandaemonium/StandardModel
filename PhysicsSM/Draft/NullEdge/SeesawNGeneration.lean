import Mathlib

/-!

WAVE-3 AUDIT CORRECTION (2026-07-21, job `6ea8b5f0`, witnesses in
`MassLandingsAuditWave3`). General invertibility of `M_R` suffices for the Schur-complement
formula under two-sided elimination, but **NOT** for a symmetry-preserving Majorana
interpretation: the explicit invertible nonsymmetric `M_R = [[1,1],[0,1]]` yields a
NONSYMMETRIC light block
(`AuditWitnesses.general_invertible_MR_can_give_nonsymmetric_light_block`). What repairs
the shape is symmetry of the INVERSE
(`AuditWitnesses.light_block_symmetric_of_inverse_symmetric`), and that is what a Majorana
reading actually requires. State the symmetry hypothesis explicitly wherever the light
block is called Majorana.
# n-generation seesaw Schur complement (Opus, verified Aristotle 0f389c1d)

Arbitrary-n extension of the A5 one-generation seesaw: lightEffectiveMass mD MR
= -(mD MR^-1 mD^T), block matrix [[0,mD],[mD^T,MR]] diagonalized to
diag(lightEffectiveMass, MR) via explicit unitriangular LDL^T (IsUnit MR.det),
symmetry when MR^T=MR, and a controlled induced-norm estimate. Namespace kept as
prover's Seesaw. Provenance: verified at pin from task f2feb470. Standard three.
Claim grade M, [comp]. -/

open scoped Matrix

namespace Seesaw

noncomputable section

variable {n : ℕ}

abbrev Square (n : ℕ) := Matrix (Fin n) (Fin n) ℂ

/-- The light-neutrino effective mass, i.e. the Schur complement of the
heavy block in the seesaw mass matrix. -/
def lightEffectiveMass (mD MR : Square n) : Square n :=
  -(mD * MR⁻¹ * mD.transpose)

/-- The full `n`-generation seesaw mass matrix. -/
def massMatrix (mD MR : Square n) : Matrix (Fin n ⊕ Fin n) (Fin n ⊕ Fin n) ℂ :=
  Matrix.fromBlocks 0 mD mD.transpose MR

/-- The lower unitriangular factor used in seesaw block diagonalization. -/
def lowerFactor (mD MR : Square n) :
    Matrix (Fin n ⊕ Fin n) (Fin n ⊕ Fin n) ℂ :=
  Matrix.fromBlocks 1 0 (-(MR⁻¹ * mD.transpose)) 1

/-- The corresponding upper unitriangular factor. -/
def upperFactor (mD MR : Square n) :
    Matrix (Fin n ⊕ Fin n) (Fin n ⊕ Fin n) ℂ :=
  Matrix.fromBlocks 1 (-(mD * MR⁻¹)) 0 1

/-
The light mass is exactly the Schur complement of the lower-right block.
-/
theorem lightEffectiveMass_eq_schurComplement (mD MR : Square n) :
    lightEffectiveMass mD MR = 0 - mD * MR⁻¹ * mD.transpose := by
  -- By definition, `lightEffectiveMass mD MR = -(mD * MR⁻¹ * mD.transpose)`.
  -- This equality can be shown by simplifying `zero - mD * MR⁻¹ * mD.transpose` to `- (mD * MR⁻¹ * mD.transpose)`.
  simp [lightEffectiveMass]

/-
Explicit block Gaussian/LDLᵀ diagonalization of the seesaw matrix.
The two triangular factors are displayed separately, so this identity does not
need symmetry of `MR`; under symmetry they are transposes of one another.
-/
theorem triangular_block_diagonalization (mD MR : Square n)
    (hMR : IsUnit MR.det) :
    upperFactor mD MR * massMatrix mD MR * lowerFactor mD MR =
      Matrix.fromBlocks (lightEffectiveMass mD MR) 0 0 MR := by
  simp_all [Matrix.mul_assoc, upperFactor, lowerFactor, lightEffectiveMass]
  simp_all [massMatrix, ← Matrix.mul_assoc, Matrix.fromBlocks_multiply]

/-
For a symmetric Majorana block, the displayed left triangular factor is
precisely the transpose of the right triangular factor.
-/
theorem triangular_factors_transpose (mD MR : Square n)
    (hMRsymm : MR.transpose = MR) :
    (lowerFactor mD MR).transpose = upperFactor mD MR := by
  simp [lowerFactor, upperFactor, Matrix.fromBlocks_transpose]
  rw [Matrix.transpose_nonsing_inv, hMRsymm]

/-
Congruence form of the block LDLᵀ diagonalization.
-/
theorem triangular_congruence_block_diagonalization (mD MR : Square n)
    (hMR : IsUnit MR.det) (hMRsymm : MR.transpose = MR) :
    (lowerFactor mD MR).transpose * massMatrix mD MR * lowerFactor mD MR =
      Matrix.fromBlocks (lightEffectiveMass mD MR) 0 0 MR := by
  rw [ ← triangular_block_diagonalization mD MR hMR, triangular_factors_transpose mD MR hMRsymm ]

/-
The full seesaw mass matrix is symmetric when the Majorana block is symmetric.
-/
theorem massMatrix_transpose (mD MR : Square n) (hMRsymm : MR.transpose = MR) :
    (massMatrix mD MR).transpose = massMatrix mD MR := by
  simp [massMatrix, Matrix.fromBlocks_transpose, hMRsymm]

/-
The Schur-complement light mass is symmetric when the heavy Majorana mass is symmetric.
-/
theorem lightEffectiveMass_transpose (mD MR : Square n)
    (hMRsymm : MR.transpose = MR) :
    (lightEffectiveMass mD MR).transpose = lightEffectiveMass mD MR := by
  simp [lightEffectiveMass, Matrix.mul_assoc, Matrix.transpose_nonsing_inv, hMRsymm]

section OperatorNorm

/-- We use Mathlib's induced `ℓ∞` operator norm on square matrices (maximum row sum). -/
local instance : NormedRing (Square n) := Matrix.linftyOpNormedRing

/-
The seesaw light mass obeys the expected submultiplicative operator-norm bound.
-/
theorem norm_lightEffectiveMass_le (mD MR : Square n) (b : ℝ)
    (hsmall : ‖mD‖ * ‖MR⁻¹‖ * ‖mD.transpose‖ ≤ b) :
    ‖lightEffectiveMass mD MR‖ ≤ b := by
  rw [lightEffectiveMass, norm_neg]
  calc
    ‖mD * MR⁻¹ * mD.transpose‖ ≤ ‖mD * MR⁻¹‖ * ‖mD.transpose‖ := norm_mul_le _ _
    _ ≤ (‖mD‖ * ‖MR⁻¹‖) * ‖mD.transpose‖ :=
      mul_le_mul_of_nonneg_right (norm_mul_le _ _) (norm_nonneg _)
    _ ≤ b := hsmall

end OperatorNorm

end

end Seesaw
