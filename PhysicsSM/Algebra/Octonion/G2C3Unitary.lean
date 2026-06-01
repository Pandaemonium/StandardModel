import Mathlib
import PhysicsSM.Algebra.Octonion.G2C3Matrix

/-!
# Algebra.Octonion.G2C3Unitary

Bridges the Hermitian-preservation predicate `MatrixActsUnitaryOnC3` with the
standard matrix unitarity equation `M.conjTranspose * M = 1`.

## Mathematical context

The file `G2C3Matrix` packages the action of the `G₂` stabilizer on the `ℂ³`
complement as a `3 × 3` complex matrix and defines `MatrixActsUnitaryOnC3 M`
as the predicate "M preserves the standard Hermitian inner product under
`mulVec`".

This file shows that `MatrixActsUnitaryOnC3 M` is equivalent to the standard
matrix equation `M.conjTranspose * M = 1`, thus identifying the Hermitian-
preservation predicate with membership in `U(3)`.

## Claim boundary

This file does **not** claim `Stab_{G₂}(e111) ≅ SU(3)` or prove that the
determinant is one. It only identifies the Hermitian-preservation predicate
with the usual unitary matrix equation.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Convention: project XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Coordinate formula for the Hermitian form -/

/--
The Hermitian inner product on `ComplexTriple`, when applied to vectors
    obtained via `ofComplexVec`, equals the standard coordinate sum
    `∑ k, conj(u k) * v k`.
-/
theorem ComplexTriple.hermitian_ofComplexVec
    (u v : Fin 3 → ℂ) :
    ComplexTriple.hermitian
      (ComplexTriple.ofComplexVec u)
      (ComplexTriple.ofComplexVec v) =
    ∑ k : Fin 3, starRingEnd ℂ (u k) * v k := by
  congr! 1

/-! ## MatrixActsUnitaryOnC3 as a dotProduct identity -/

/--
`MatrixActsUnitaryOnC3 M` is equivalent to saying the standard
    `star`-dot-product is preserved by `M.mulVec`.
-/
theorem matrixActsUnitaryOnC3_iff_star_dotProduct
    (M : Matrix (Fin 3) (Fin 3) ℂ) :
    MatrixActsUnitaryOnC3 M ↔
    ∀ u v : Fin 3 → ℂ,
      dotProduct (star (M.mulVec u)) (M.mulVec v) =
      dotProduct (star u) v := by
  constructor <;> intro h u v <;> convert h u v using 1

/-! ## Key equivalence -/

/--
`dotProduct (star u) v` preservation for all `u v` is equivalent to
    `M.conjTranspose * M = 1`.
-/
theorem star_dotProduct_iff_conjTranspose_mul
    (M : Matrix (Fin 3) (Fin 3) ℂ) :
    (∀ u v : Fin 3 → ℂ,
      dotProduct (star (M.mulVec u)) (M.mulVec v) =
      dotProduct (star u) v) ↔
    M.conjTranspose * M = 1 := by
  constructor <;> intro h <;>
    simp_all +decide [Matrix.dotProduct_mulVec]
  · ext i j
    specialize h (Pi.single i 1) (Pi.single j 1)
    simp_all +decide [dotProduct]
    simp_all +decide [Matrix.vecMul, dotProduct, Matrix.mul_apply,
      Pi.single_apply]
    fin_cases i <;> fin_cases j <;> rfl
  · intro u v
    have h_dot : dotProduct (star (M.mulVec u)) (M.mulVec v) =
        star u ⬝ᵥ (M.conjTranspose * M).mulVec v := by
      simp +decide [Matrix.mulVec, dotProduct, Fin.sum_univ_three]
      simpa [Matrix.mul_apply, Fin.sum_univ_three] using by ring
    convert h_dot using 1
    · simp +decide [Matrix.dotProduct_mulVec]
    · rw [h, Matrix.one_mulVec]

/-- A `3 × 3` complex matrix acts unitarily on `ℂ³` if and only if
    `M.conjTranspose * M = 1`. -/
theorem matrixActsUnitaryOnC3_iff_conjTranspose_mul
    (M : Matrix (Fin 3) (Fin 3) ℂ) :
    MatrixActsUnitaryOnC3 M ↔ M.conjTranspose * M = 1 := by
  rw [matrixActsUnitaryOnC3_iff_star_dotProduct,
      star_dotProduct_iff_conjTranspose_mul]

/-! ## One-way wrappers -/

/-- If `M` acts unitarily on `ℂ³`, then `M.conjTranspose * M = 1`. -/
theorem MatrixActsUnitaryOnC3.conjTranspose_mul
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M) :
    M.conjTranspose * M = 1 :=
  (matrixActsUnitaryOnC3_iff_conjTranspose_mul M).mp hM

/-- If `g` preserves the Hermitian inner product, then the matrix
    `g.onComplexVecMatrix` satisfies `M.conjTranspose * M = 1`. -/
theorem PreservesComplexTripleHermitian.onComplexVecMatrix_conjTranspose_mul
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g) :
    g.onComplexVecMatrix.conjTranspose * g.onComplexVecMatrix = 1 :=
  hg.matrixActsUnitary.conjTranspose_mul

/-! ## Determinant consequence -/

/--
If `M` acts unitarily on `ℂ³`, then `|det M|² = 1`.
-/
theorem MatrixActsUnitaryOnC3.det_normSq_eq_one
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M) :
    Complex.normSq M.det = 1 := by
  have key : starRingEnd ℂ M.det * M.det = 1 := by
    have h := Matrix.det_mul M.conjTranspose M
    rw [Matrix.det_conjTranspose, hM.conjTranspose_mul, Matrix.det_one] at h
    exact h.symm
  exact Complex.ofReal_inj.mp (by
    simpa [Complex.normSq_eq_conj_mul_self] using key)

end PhysicsSM.Algebra.Octonion.G2ComplexLine
