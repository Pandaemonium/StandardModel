import Mathlib
import PhysicsSM.Algebra.Octonion.G2SU3Bridge

/-!
# Algebra.Octonion.G2C3Matrix

Matrix-coordinate package for the complex-linear action of the `G₂` stabilizer
on the `ℂ³` complement.

## Mathematical context

The file `G2SU3Bridge` provides a complex-linear map
`g.onComplexVecLinear : (Fin 3 → ℂ) →ₗ[ℂ] (Fin 3 → ℂ)` for each element
`g : FixingE111MulLinear` of the `G₂` stabilizer of the chosen imaginary unit.

This file packages that linear map as a concrete `3 × 3` complex matrix and
proves that matrix–vector multiplication (`mulVec`) recovers the linear map.
It also restates the Hermitian-preservation predicate in matrix language.

## Matrix convention

The matrix `g.onComplexVecMatrix` is defined so that
`g.onComplexVecMatrix.mulVec v = g.onComplexVecLinear v`.

Concretely,
`g.onComplexVecMatrix i j = g.onComplexVecLinear (Pi.single j 1) i`,
i.e. column `j` of the matrix is the image of the `j`-th standard basis
vector.

## Claim boundary

This file does **not** claim `Stab_{G₂}(e111) ≅ SU(3)` or prove determinant
conditions. It only packages the already-defined complex-linear action as a
matrix and restates preservation predicates in matrix coordinates.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Convention: project XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Matrix of the coordinate linear map -/

/-- The `3 × 3` complex matrix representing the action of `g` on `ℂ³`.

    Column `j` is the image of the `j`-th standard basis vector under
    `g.onComplexVecLinear`. The matrix acts by left multiplication
    (`mulVec`):
    `g.onComplexVecMatrix.mulVec v = g.onComplexVecLinear v`. -/
noncomputable def FixingE111MulLinear.onComplexVecMatrix
    (g : FixingE111MulLinear) : Matrix (Fin 3) (Fin 3) ℂ :=
  fun i j => g.onComplexVecLinear (Pi.single j 1) i

/-! ## Apply theorem: `mulVec` recovers the linear map -/

/-- Matrix–vector multiplication by `g.onComplexVecMatrix` recovers the
    complex-linear map `g.onComplexVecLinear`.

    **Proof.** By linearity,
    `g.onComplexVecLinear v = ∑ j, v j • g.onComplexVecLinear e_j`,
    which is exactly `mulVec M v` where
    `M i j = g.onComplexVecLinear e_j i`. -/
theorem FixingE111MulLinear.onComplexVecMatrix_mulVec
    (g : FixingE111MulLinear) (v : Fin 3 → ℂ) :
    g.onComplexVecMatrix.mulVec v = g.onComplexVecLinear v := by
  ext i
  have h_expand :
      g.onComplexVecLinear v =
        ∑ j, v j • g.onComplexVecLinear (Pi.single j 1) := by
    convert g.onComplexVecLinear.pi_apply_eq_sum_univ v using 1
  simp_all +decide [Matrix.mulVec, dotProduct, mul_comm]
  rfl

/-! ## Hermitian preservation in matrix coordinates -/

/-- If `g` preserves the Hermitian inner product, then the matrix form
    of the action also preserves the Hermitian inner product.

    This is a direct consequence of
    `PreservesComplexTripleHermitian.coord` and the `mulVec` apply
    theorem. -/
theorem PreservesComplexTripleHermitian.matrix_preserves_dot
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g)
    (u v : Fin 3 → ℂ) :
    ComplexTriple.hermitian
      (ComplexTriple.ofComplexVec (g.onComplexVecMatrix.mulVec u))
      (ComplexTriple.ofComplexVec (g.onComplexVecMatrix.mulVec v)) =
    ComplexTriple.hermitian
      (ComplexTriple.ofComplexVec u)
      (ComplexTriple.ofComplexVec v) := by
  convert PreservesComplexTripleHermitian.coord hg u v using 1
  rw [FixingE111MulLinear.onComplexVecMatrix_mulVec,
    FixingE111MulLinear.onComplexVecMatrix_mulVec]

/-! ## Unitary predicate in matrix coordinates -/

/-- A `3 × 3` complex matrix acts unitarily on `ℂ³` if it preserves the
    standard Hermitian inner product under `mulVec`.

    This is the coordinate-level analogue of
    `PreservesComplexTripleHermitian`. A matrix satisfying this predicate
    lies in `U(3)`. -/
def MatrixActsUnitaryOnC3 (M : Matrix (Fin 3) (Fin 3) ℂ) : Prop :=
  ∀ u v : Fin 3 → ℂ,
    ComplexTriple.hermitian
      (ComplexTriple.ofComplexVec (M.mulVec u))
      (ComplexTriple.ofComplexVec (M.mulVec v)) =
    ComplexTriple.hermitian
      (ComplexTriple.ofComplexVec u)
      (ComplexTriple.ofComplexVec v)

/-- If `g` preserves the Hermitian inner product, then its matrix acts
    unitarily on `ℂ³`. -/
theorem PreservesComplexTripleHermitian.matrixActsUnitary
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g) :
    MatrixActsUnitaryOnC3 g.onComplexVecMatrix :=
  hg.matrix_preserves_dot

end PhysicsSM.Algebra.Octonion.G2ComplexLine
