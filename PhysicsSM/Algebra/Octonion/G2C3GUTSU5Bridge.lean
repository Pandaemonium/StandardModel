import Mathlib
import PhysicsSM.Algebra.Octonion.G2C3GUTBlockBridge

/-!
# Algebra.Octonion.G2C3GUTSU5Bridge

Strengthens `G2C3GUTBlockBridge` by adding explicit SU(5) and SM-block
consequences for the block-diagonal embedding of a unitary `C₃` matrix.

## Mathematical context

Given a unitary `3 × 3` complex matrix `M`, we embed it as the
block-diagonal `5 × 5` matrix `diag(1₂, M)`. This module proves:

- **SU(5) wrapper**: with an explicit `det M = 1` hypothesis, the block
  embedding satisfies the `SU5Predicate`.
- **SM ↔ SU(5) equivalence**: once `M` is known unitary, the SM block
  predicate for `diag(1₂, M)` is equivalent to the SU(5) predicate.
  This is because the upper-left identity block contributes trivially
  to the overall determinant.
- **Octonion specialization**: the equivalence applied to the matrix
  arising from the `G₂` stabilizer action.

## Claim boundary

This proves only block-predicate consequences from unitarity and an
explicit determinant-one hypothesis. It does not prove determinant one
for the `G₂` action, the full `G₂` stabilizer theorem, or a compact
Lie group theorem.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Gauge.GUTSquare
open Matrix Complex

/-! ## SU(5) wrapper under determinant-one hypothesis -/

/-- If `M` acts unitarily on `ℂ³` and `det M = 1`, then `diag(1₂, M)`
    satisfies the SU(5) predicate (`IsUnitary` and `det = 1`). -/
theorem matrixActsUnitaryOnC3_gutBlock_su5_of_det
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M)
    (hdet : M.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock M) :=
  smBlock_implies_su5 _ (matrixActsUnitaryOnC3_gutBlock_smBlock_of_det hM hdet)

/-! ## SM block ↔ SU(5) equivalence for the C₃ block embedding -/

/-- Once `M` is known unitary, the SM block predicate for `diag(1₂, M)` is
    equivalent to the SU(5) predicate. This holds because the upper-left
    `2 × 2` identity block has determinant 1, so the combined determinant
    condition `det(1₂) · det(M) = 1` reduces to `det(M) = 1`, which is
    exactly the SU(5) determinant condition for the full `5 × 5` matrix. -/
theorem matrixActsUnitaryOnC3_gutBlock_smBlock_iff_su5
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
      (c3MatrixAsGUTBlock M) ↔
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock M) := by
  constructor
  · exact fun a => smBlock_implies_su5 (c3MatrixAsGUTBlock M) a
  · intro h
    convert matrixActsUnitaryOnC3_gutBlock_smBlock_of_det hM _
    have := h.2
    simp_all +decide [c3MatrixAsGUTBlock, Matrix.det_fromBlocks_zero₂₁]

/-! ## Specialization to the octonion-side action matrix -/

/-- If `g` preserves the complex triple Hermitian form, then for the block
    embedding `diag(1₂, g.onComplexVecMatrix)`, the SM block predicate is
    equivalent to the SU(5) predicate. -/
theorem preservesComplexTripleHermitian_gutBlock_smBlock_iff_su5
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) ↔
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) :=
  matrixActsUnitaryOnC3_gutBlock_smBlock_iff_su5 hg.matrixActsUnitary

/-! ## Bridge package -/

/-- Packages the SM ↔ SU(5) equivalence for the `C₃` block embedding. -/
structure G2C3GUTSU5BridgePackage where
  smBlock_iff_su5 :
    ∀ {M : Matrix (Fin 3) (Fin 3) ℂ},
      MatrixActsUnitaryOnC3 M →
        (PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
          (c3MatrixAsGUTBlock M) ↔
         PhysicsSM.Gauge.GUTSquare.SU5Predicate
          (c3MatrixAsGUTBlock M))

/-- The bridge package is inhabited: the equivalence holds for every
    unitary `M`. -/
theorem g2C3GUTSU5BridgePackage :
    G2C3GUTSU5BridgePackage :=
  ⟨fun hM => matrixActsUnitaryOnC3_gutBlock_smBlock_iff_su5 hM⟩

end PhysicsSM.Algebra.Octonion.G2ComplexLine
