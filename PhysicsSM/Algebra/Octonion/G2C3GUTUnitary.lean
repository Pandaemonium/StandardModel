import Mathlib
import PhysicsSM.Algebra.Octonion.G2C3Unitary
import PhysicsSM.Gauge.GUTSquare

/-!
# Algebra.Octonion.G2C3GUTUnitary

Connects the octonion-side `MatrixActsUnitaryOnC3` predicate to the shared
`PhysicsSM.Gauge.GUTSquare.IsUnitary` predicate, giving downstream GUT-square
and Standard Model files a unified matrix unitarity language.

## Claim boundary

This file does **not** claim `Stab_{G₂}(e111) ≅ SU(3)` or prove that the
determinant is one. It only unifies the predicate language and carries over
already-proved unitary consequences.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Equivalence between MatrixActsUnitaryOnC3 and GUTSquare.IsUnitary -/

/-- `MatrixActsUnitaryOnC3 M` is equivalent to `GUTSquare.IsUnitary M`. Both
    reduce to `M.conjTranspose * M = 1`. -/
theorem matrixActsUnitaryOnC3_iff_gutSquare_isUnitary
    (M : Matrix (Fin 3) (Fin 3) ℂ) :
    MatrixActsUnitaryOnC3 M ↔
      PhysicsSM.Gauge.GUTSquare.IsUnitary M := by
  rw [matrixActsUnitaryOnC3_iff_conjTranspose_mul]
  rfl

/-! ## One-way wrappers -/

/-- If `M` acts unitarily on `ℂ³`, then it satisfies the GUT-square
    unitarity predicate. -/
theorem MatrixActsUnitaryOnC3.gutSquare_isUnitary
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M) :
    PhysicsSM.Gauge.GUTSquare.IsUnitary M :=
  (matrixActsUnitaryOnC3_iff_gutSquare_isUnitary M).mp hM

/-- If `g` preserves the Hermitian inner product, then the matrix
    `g.onComplexVecMatrix` satisfies the GUT-square unitarity predicate. -/
theorem PreservesComplexTripleHermitian.onComplexVecMatrix_gutSquare_isUnitary
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g) :
    PhysicsSM.Gauge.GUTSquare.IsUnitary g.onComplexVecMatrix :=
  hg.matrixActsUnitary.gutSquare_isUnitary

/-! ## Determinant wrappers -/

/-- If `M` acts unitarily on `ℂ³`, then `|det M|² = 1`. -/
theorem MatrixActsUnitaryOnC3.det_normSq_eq_one_gutSquare
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M) :
    Complex.normSq M.det = 1 :=
  hM.det_normSq_eq_one

/-- If `M` acts unitarily on `ℂ³`, then `det M ≠ 0`. -/
theorem MatrixActsUnitaryOnC3.det_ne_zero
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M) :
    M.det ≠ 0 := by
  intro h
  have := hM.det_normSq_eq_one
  simp [h] at this

end PhysicsSM.Algebra.Octonion.G2ComplexLine
