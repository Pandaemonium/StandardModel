import Mathlib
import PhysicsSM.Algebra.Octonion.G2HermitianPreservation
import PhysicsSM.Algebra.Octonion.G2C3GUTPaperPackage

/-!
# Algebra.Octonion.G2FixingE111GUTSquare

Paper-facing GUT-square block consequences stated directly for
`FixingE111MulLinear` maps, with no separate Hermitian-preservation
hypothesis.

## Mathematical context

The file `G2HermitianPreservation` proves that every `FixingE111MulLinear`
map preserves the Hermitian inner product on `ComplexTriple`
(`fixingE111MulLinear_preservesHermitian`). The file `G2C3GUTPaperPackage`
proves GUT-square block consequences assuming Hermitian preservation.
This module combines these two results to expose the consequences
directly in terms of `g : FixingE111MulLinear`, removing the explicit
`PreservesComplexTripleHermitian g` hypothesis.

## Main results

- `fixingE111MulLinear_gutBlock_patiSalam`: the block embedding satisfies
  the Pati-Salam predicate for any `FixingE111MulLinear`.
- `fixingE111MulLinear_gutBlock_smBlock_of_det`: with `det = 1`, the block
  embedding satisfies the SM block predicate.
- `fixingE111MulLinear_gutBlock_su5_of_det`: with `det = 1`, the block
  embedding satisfies the SU(5) predicate.
- `fixingE111MulLinear_gutBlock_smBlock_iff_su5`: the SM block and SU(5)
  predicates are equivalent for the block embedding.
- `G2FixingE111GUTSquarePackage`: bundles all four results.

## Claim boundary

This removes the Hermitian-preservation hypothesis but keeps the
determinant-one hypothesis explicit for SM/SU(5). It does not prove
determinant one, `Stab_G₂(e₁₁₁) ≅ SU(3)`, or a Lie group isomorphism.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Gauge.GUTSquare

/-! ## GUT-square block consequences for `FixingE111MulLinear` -/

/-- The block embedding `diag(1₂, g.onComplexVecMatrix)` satisfies the
    Pati-Salam predicate for any `FixingE111MulLinear` map `g`.
    No separate Hermitian-preservation hypothesis is needed. -/
theorem fixingE111MulLinear_gutBlock_patiSalam
    (g : FixingE111MulLinear) :
    PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) :=
  preservesComplexTripleHermitian_gutBlock_patiSalam
    (fixingE111MulLinear_preservesHermitian g)

/-- With `det g.onComplexVecMatrix = 1`, the block embedding satisfies the
    SM block predicate. The Hermitian-preservation hypothesis is discharged
    automatically. -/
theorem fixingE111MulLinear_gutBlock_smBlock_of_det
    (g : FixingE111MulLinear)
    (hdet : g.onComplexVecMatrix.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) :=
  preservesComplexTripleHermitian_gutBlock_smBlock_of_det
    (fixingE111MulLinear_preservesHermitian g) hdet

/-- With `det g.onComplexVecMatrix = 1`, the block embedding satisfies the
    SU(5) predicate. The Hermitian-preservation hypothesis is discharged
    automatically. -/
theorem fixingE111MulLinear_gutBlock_su5_of_det
    (g : FixingE111MulLinear)
    (hdet : g.onComplexVecMatrix.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) :=
  preservesComplexTripleHermitian_gutBlock_su5_of_det
    (fixingE111MulLinear_preservesHermitian g) hdet

/-- For any `FixingE111MulLinear` map, the SM block and SU(5) predicates
    are equivalent for the block embedding `diag(1₂, g.onComplexVecMatrix)`.
    No separate Hermitian-preservation hypothesis is needed. -/
theorem fixingE111MulLinear_gutBlock_smBlock_iff_su5
    (g : FixingE111MulLinear) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
        (c3MatrixAsGUTBlock g.onComplexVecMatrix) ↔
      PhysicsSM.Gauge.GUTSquare.SU5Predicate
        (c3MatrixAsGUTBlock g.onComplexVecMatrix) :=
  preservesComplexTripleHermitian_gutBlock_smBlock_iff_su5
    (fixingE111MulLinear_preservesHermitian g)

/-! ## Bundled package -/

/-- Bundles the four paper-facing GUT-square block consequences for
    `FixingE111MulLinear` maps, with no separate Hermitian-preservation
    hypothesis. The determinant-one hypothesis remains explicit in
    `sm_block_of_det` and `su5_of_det`. -/
structure G2FixingE111GUTSquarePackage where
  /-- Pati-Salam predicate holds for any `FixingE111MulLinear`. -/
  pati_salam :
    ∀ g : FixingE111MulLinear,
      PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate
        (c3MatrixAsGUTBlock g.onComplexVecMatrix)
  /-- SM block predicate holds with `det = 1`. -/
  sm_block_of_det :
    ∀ g : FixingE111MulLinear,
      g.onComplexVecMatrix.det = 1 →
        PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
          (c3MatrixAsGUTBlock g.onComplexVecMatrix)
  /-- SU(5) predicate holds with `det = 1`. -/
  su5_of_det :
    ∀ g : FixingE111MulLinear,
      g.onComplexVecMatrix.det = 1 →
        PhysicsSM.Gauge.GUTSquare.SU5Predicate
          (c3MatrixAsGUTBlock g.onComplexVecMatrix)

/-- The `G2FixingE111GUTSquarePackage` is inhabited: all results follow
    from `fixingE111MulLinear_preservesHermitian` and the existing
    GUT-square bridge theorems. -/
theorem g2FixingE111GUTSquarePackage :
    G2FixingE111GUTSquarePackage where
  pati_salam := fixingE111MulLinear_gutBlock_patiSalam
  sm_block_of_det := fixingE111MulLinear_gutBlock_smBlock_of_det
  su5_of_det := fixingE111MulLinear_gutBlock_su5_of_det

end PhysicsSM.Algebra.Octonion.G2ComplexLine
