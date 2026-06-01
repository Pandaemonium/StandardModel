import Mathlib
import PhysicsSM.Algebra.Octonion.G2C3GUTUnitary
import PhysicsSM.Gauge.GUTSquare

/-!
# Algebra.Octonion.G2C3GUTBlockBridge

Bridges the Baez-style `G₂` action on the chosen `ℂ³` complement to the
Baez–Huerta GUT-square block predicates by placing the resulting unitary
3×3 matrix into the lower-right block with a trivial 2×2 identity block.

## Mathematical context

Given a unitary `3 × 3` complex matrix `M` (e.g. arising from the `G₂`
stabilizer action on the `ℂ³` complement), we embed it as the block-diagonal
`5 × 5` matrix `diag(1₂, M)`. This matrix satisfies:

- **Pati-Salam predicate**: it is block-diagonal with unitary blocks.
- **SM block predicate** (with `det M = 1` as an extra hypothesis): it is
  block-diagonal with unitary blocks and combined determinant 1.

## Claim boundary

This proves only block-predicate membership from unitarity. It does not prove
determinant one for the `G₂` action, does not identify the full stabilizer
with `SU(3)`, and does not prove a compact Lie group theorem.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Gauge.GUTSquare
open Matrix Complex

/-! ## Block embedding -/

/-- Embed a `3 × 3` matrix into the `(Fin 2 ⊕ Fin 3)`-indexed block-diagonal
    matrix `diag(1₂, M)` with a trivial `2 × 2` identity upper-left block. -/
noncomputable def c3MatrixAsGUTBlock
    (M : Matrix (Fin 3) (Fin 3) ℂ) :
    Matrix (Fin 2 ⊕ Fin 3) (Fin 2 ⊕ Fin 3) ℂ :=
  Matrix.fromBlocks (1 : Matrix (Fin 2) (Fin 2) ℂ) 0 0 M

/-! ## Pati-Salam predicate from unitarity -/

/--
If `M` acts unitarily on `ℂ³`, then `diag(1₂, M)` satisfies the
    Pati-Salam (block-diagonal unitary) predicate.
-/
theorem matrixActsUnitaryOnC3_gutBlock_patiSalam
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M) :
    PatiSalamPredicate (c3MatrixAsGUTBlock M) := by
  use 1, M;
  exact ⟨ rfl, by simp +decide [ IsUnitary ], hM.gutSquare_isUnitary ⟩

/-! ## SM block predicate with det = 1 hypothesis -/

/--
If `M` acts unitarily on `ℂ³` and `det M = 1`, then `diag(1₂, M)`
    satisfies the Standard Model block predicate.
-/
theorem matrixActsUnitaryOnC3_gutBlock_smBlock_of_det
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M)
    (hdet : M.det = 1) :
    SMBlockPredicate (c3MatrixAsGUTBlock M) := by
  use 1, M;
  exact ⟨ rfl, by simp +decide [ IsUnitary ], hM.gutSquare_isUnitary, by simp +decide [ hdet ] ⟩

/-! ## Specialization to the octonion-side action -/

/--
If `g` preserves the complex triple Hermitian form, then the block
    embedding `diag(1₂, g.onComplexVecMatrix)` satisfies the Pati-Salam
    predicate.
-/
theorem preservesComplexTripleHermitian_gutBlock_patiSalam
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g) :
    PatiSalamPredicate (c3MatrixAsGUTBlock g.onComplexVecMatrix) := by
  exact matrixActsUnitaryOnC3_gutBlock_patiSalam hg.matrixActsUnitary

end PhysicsSM.Algebra.Octonion.G2ComplexLine
