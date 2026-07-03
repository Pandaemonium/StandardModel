import Mathlib
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexWindingWitness
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate

/-!
# Gate C2: a NON-diagonal (hopping) certified-sign operator

This Draft module strengthens the C2a->C2b join from a diagonal mass-defect
operator (`OverlapWindingSignJoin`) to a genuinely **non-diagonal** (hopping)
gapped Hermitian operator whose certified sign is still the winding involution
`epsW`.  It answers "does the sign certificate only work for diagonal operators?"
- no: the certificate machinery handles hopping operators.

## Construction

Take an explicit invertible `C` that is block-diagonal with respect to the
`epsW`-eigenspaces (a `3x3` upper-triangular hopping block on the negative-mass
sites `{0,1,2}` plus a `1x1` block on the positive-mass site `{3}`):

    C = !![2,1,0,0; 0,2,1,0; 0,0,2,0; 0,0,0,3].

Set `HU2 = epsW * (Cᴴ * C)`.  Then `epsW * HU2 = Cᴴ * C` (since `epsW^2 = 1`),
which is positive semidefinite for free (`Matrix.posSemidef_conjTranspose_mul_self`)
and commutes with `epsW` (because `C` does), so `epsW` is a sign certificate for
`HU2`.  We also prove that `HU2` is invertible and Hermitian, so
`certifiedSign_unique` applies: `epsW` is the unique certified sign of this
non-diagonal operator.  `HU2` is genuinely non-diagonal (`HU2_offDiagonal`: its
`(0,1)` entry is nonzero), unlike the diagonal domain wall of
`OverlapWindingSignJoin`.

## Scope honesty

`C` (hence the hopping) is REAL: this is a hopping operator with a FLAT connection
(no complex link phase, so no gauge holonomy / flux).  It shows the certificate is
not special to diagonal operators, but a genuine nonzero-flux operator (complex
links, nontrivial holonomy around a loop) remains the open C2 target.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **finite identity / consistency witness** (non-diagonal certified
sign, flat connection).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapHoppingSignWitness

open Matrix
open scoped ComplexOrder
open PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexWindingWitness
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate

/-- An explicit invertible matrix, block-diagonal w.r.t. the `epsW`-eigenspaces,
with a hopping (upper-triangular) block on the negative-mass sites. -/
def Cmat : Matrix (Fin 4) (Fin 4) ℂ := !![2, 1, 0, 0; 0, 2, 1, 0; 0, 0, 2, 0; 0, 0, 0, 3]

/-- Explicit inverse of `Cmat`. -/
noncomputable def CmatInv : Matrix (Fin 4) (Fin 4) ℂ :=
  !![(1 / 2 : ℂ), -(1 / 4 : ℂ), (1 / 8 : ℂ), 0;
     0, (1 / 2 : ℂ), -(1 / 4 : ℂ), 0;
     0, 0, (1 / 2 : ℂ), 0;
     0, 0, 0, (1 / 3 : ℂ)]

/-- The hopping change-of-basis matrix is invertible. -/
noncomputable instance Cmat_invertible : Invertible Cmat where
  invOf := CmatInv
  invOf_mul_self := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [CmatInv, Cmat, Matrix.mul_apply, Fin.sum_univ_four,
        Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two] <;> norm_num
  mul_invOf_self := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [CmatInv, Cmat, Matrix.mul_apply, Fin.sum_univ_four,
        Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two] <;> norm_num

/-- The non-diagonal hopping operator `HU2 = epsW . (Cᴴ C)`. -/
def HU2 : Matrix (Fin 4) (Fin 4) ℂ := epsW * (Cmatᴴ * Cmat)

/-- `Cᴴ C` is invertible because `C` is invertible. -/
noncomputable instance CHC_invertible : Invertible (Cmatᴴ * Cmat) :=
  invertibleMul Cmatᴴ Cmat

/-- The winding sign involution is invertible, with inverse itself. -/
noncomputable instance epsW_invertible : Invertible epsW where
  invOf := epsW
  invOf_mul_self := epsW_sq
  mul_invOf_self := epsW_sq

/-- The non-diagonal hopping operator is invertible, hence gapped in the finite
algebraic sense used by `certifiedSign_unique`. -/
noncomputable instance HU2_invertible : Invertible HU2 := by
  rw [HU2]
  exact invertibleMul epsW (Cmatᴴ * Cmat)

/-- `epsW` is Hermitian (real diagonal). -/
theorem epsW_conjTranspose : epsWᴴ = epsW := by
  rw [epsW, Matrix.diagonal_conjTranspose]
  congr 1
  funext i
  fin_cases i <;> simp

/-- `C` commutes with `epsW` (block-diagonal w.r.t. the eigenspaces). -/
theorem Cmat_comm_epsW : Cmat * epsW = epsW * Cmat := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Cmat, epsW, Matrix.mul_apply, Fin.sum_univ_four, Matrix.diagonal_apply] <;>
    ring

/-- `Cᴴ` commutes with `epsW` (conjugate-transpose of `Cmat_comm_epsW`). -/
theorem CmatH_comm_epsW : Cmatᴴ * epsW = epsW * Cmatᴴ := by
  have h := congrArg Matrix.conjTranspose Cmat_comm_epsW
  rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, epsW_conjTranspose] at h
  exact h.symm

/-- `Cᴴ C` commutes with `epsW`. -/
theorem CHC_comm_epsW : (Cmatᴴ * Cmat) * epsW = epsW * (Cmatᴴ * Cmat) := by
  calc (Cmatᴴ * Cmat) * epsW = Cmatᴴ * (Cmat * epsW) := by rw [Matrix.mul_assoc]
    _ = Cmatᴴ * (epsW * Cmat) := by rw [Cmat_comm_epsW]
    _ = (Cmatᴴ * epsW) * Cmat := by rw [← Matrix.mul_assoc]
    _ = (epsW * Cmatᴴ) * Cmat := by rw [CmatH_comm_epsW]
    _ = epsW * (Cmatᴴ * Cmat) := by rw [Matrix.mul_assoc]

/-- `Cᴴ C` is Hermitian. -/
theorem CHC_conjTranspose : (Cmatᴴ * Cmat)ᴴ = Cmatᴴ * Cmat := by
  rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose]

/-- The non-diagonal hopping operator is fixed by conjugate transpose. -/
theorem HU2_conjTranspose : HU2ᴴ = HU2 := by
  rw [HU2, Matrix.conjTranspose_mul, CHC_conjTranspose, epsW_conjTranspose]
  exact CHC_comm_epsW

/-- The non-diagonal hopping operator is Hermitian. -/
theorem HU2_isHermitian : HU2.IsHermitian := by
  rw [Matrix.IsHermitian]
  exact HU2_conjTranspose

/-- `epsW * HU2 = Cᴴ C` (from `epsW^2 = 1`). -/
theorem epsW_mul_HU2 : epsW * HU2 = Cmatᴴ * Cmat := by
  rw [HU2, ← Matrix.mul_assoc, epsW_sq, Matrix.one_mul]

/-- **The non-diagonal hopping operator `HU2` has certified sign `epsW`.**  So the
finite positivity certificate is not special to diagonal operators. -/
theorem signCertificate_HU2_epsW : SignCertificate HU2 epsW where
  involution := epsW_sq
  commute := by
    rw [epsW_mul_HU2, HU2, Matrix.mul_assoc, CHC_comm_epsW, ← Matrix.mul_assoc,
      epsW_sq, Matrix.one_mul]
  posSemidef := by
    rw [epsW_mul_HU2]
    exact Matrix.posSemidef_conjTranspose_mul_self Cmat

/-- Any certified sign of the non-diagonal hopping operator is the winding
witness sign `epsW`. -/
theorem signCertificate_HU2_unique
    (eps : Matrix (Fin 4) (Fin 4) ℂ) (hc : SignCertificate HU2 eps) :
    eps = epsW :=
  certifiedSign_unique HU2 eps epsW HU2_isHermitian hc signCertificate_HU2_epsW

/-- `HU2` is genuinely non-diagonal: its `(0,1)` entry is nonzero. -/
theorem HU2_offDiagonal : HU2 0 1 ≠ 0 := by
  simp [HU2, epsW, Cmat, Matrix.mul_apply, Fin.sum_univ_four, Matrix.diagonal_apply,
    Matrix.conjTranspose_apply]

end OverlapHoppingSignWitness
end GateC2
end NullEdge
end Draft
end PhysicsSM
