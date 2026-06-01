import Mathlib
import PhysicsSM.Algebra.Octonion.G2C3GUTSU5Bridge

/-!
# Algebra.Octonion.G2C3GUTPaperPackage

Bundles the G₂–C₃ block-embedding results into a single paper-facing
package for the Baez GUT-square paper.

## Main results

Given `g : FixingE111MulLinear` that preserves the complex triple
Hermitian form:

1. **Pati-Salam**: `diag(1₂, g.onComplexVecMatrix)` satisfies the
   Pati-Salam block predicate — no determinant hypothesis needed.

2. **SM block** (with `det = 1`): with an explicit `det g.onComplexVecMatrix = 1`
   hypothesis, the block embedding satisfies the SM block predicate.

3. **SU(5)** (with `det = 1`): same hypothesis gives the SU(5) predicate.

4. **SM ↔ SU(5) equivalence**: for a Hermitian-preserving `g`, the SM block
   and SU(5) predicates for the block embedding are equivalent.

## Claim boundary

This package does **not** prove that every Hermitian-preserving map has
determinant one. It also does not prove a full `G₂` stabilizer theorem
or a Lie group identification. The determinant-one hypothesis remains
explicit where required.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Gauge.GUTSquare
open Matrix Complex

/-! ## Determinant-explicit consequences for Hermitian-preserving maps -/

/-- If `g` preserves the complex triple Hermitian form and
    `det g.onComplexVecMatrix = 1`, then `diag(1₂, g.onComplexVecMatrix)`
    satisfies the SM block predicate. -/
theorem preservesComplexTripleHermitian_gutBlock_smBlock_of_det
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g)
    (hdet : g.onComplexVecMatrix.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) :=
  matrixActsUnitaryOnC3_gutBlock_smBlock_of_det hg.matrixActsUnitary hdet

/-- If `g` preserves the complex triple Hermitian form and
    `det g.onComplexVecMatrix = 1`, then `diag(1₂, g.onComplexVecMatrix)`
    satisfies the SU(5) predicate. -/
theorem preservesComplexTripleHermitian_gutBlock_su5_of_det
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g)
    (hdet : g.onComplexVecMatrix.det = 1) :
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock g.onComplexVecMatrix) :=
  matrixActsUnitaryOnC3_gutBlock_su5_of_det hg.matrixActsUnitary hdet

/-! ## Paper-facing package -/

/-- Bundles the three paper-facing facts relating the G₂–C₃ block embedding
    to the GUT-square predicates. The determinant-one hypothesis is explicit
    in `sm_block_of_det` and `su5_of_det`. -/
structure G2C3GUTPaperPackage where
  pati_salam :
    ∀ {g : FixingE111MulLinear},
      PreservesComplexTripleHermitian g →
        PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate
          (c3MatrixAsGUTBlock g.onComplexVecMatrix)
  sm_block_of_det :
    ∀ {g : FixingE111MulLinear},
      PreservesComplexTripleHermitian g →
        g.onComplexVecMatrix.det = 1 →
          PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
            (c3MatrixAsGUTBlock g.onComplexVecMatrix)
  su5_of_det :
    ∀ {g : FixingE111MulLinear},
      PreservesComplexTripleHermitian g →
        g.onComplexVecMatrix.det = 1 →
          PhysicsSM.Gauge.GUTSquare.SU5Predicate
            (c3MatrixAsGUTBlock g.onComplexVecMatrix)
  smBlock_iff_su5 :
    ∀ {g : FixingE111MulLinear},
      PreservesComplexTripleHermitian g →
        (PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
          (c3MatrixAsGUTBlock g.onComplexVecMatrix) ↔
         PhysicsSM.Gauge.GUTSquare.SU5Predicate
          (c3MatrixAsGUTBlock g.onComplexVecMatrix))

/-- The paper package is inhabited: all four facts follow from previously
    established theorems. -/
theorem g2C3GUTPaperPackage : G2C3GUTPaperPackage where
  pati_salam := fun hg => preservesComplexTripleHermitian_gutBlock_patiSalam hg
  sm_block_of_det := fun hg hdet =>
    preservesComplexTripleHermitian_gutBlock_smBlock_of_det hg hdet
  su5_of_det := fun hg hdet =>
    preservesComplexTripleHermitian_gutBlock_su5_of_det hg hdet
  smBlock_iff_su5 := fun hg =>
    preservesComplexTripleHermitian_gutBlock_smBlock_iff_su5 hg

end PhysicsSM.Algebra.Octonion.G2ComplexLine
