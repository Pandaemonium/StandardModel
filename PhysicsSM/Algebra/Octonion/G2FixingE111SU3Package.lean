import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111DetOne
import PhysicsSM.Algebra.Octonion.G2FixingE111Composition
import PhysicsSM.Algebra.Octonion.G2C3GUTUnitary

/-!
# Algebra.Octonion.G2FixingE111SU3Package

Packages the Baez bridge: every `FixingE111MulLinear` (an octonion automorphism
fixing the chosen imaginary unit `e111`) induces a `3 × 3` complex matrix on
the complement `ℂ³` that is **unitary** and has **determinant 1**, i.e. it
acts as an element of `SU(3)`.

The assignment is compatible with the identity and composition (matrix
multiplication).

## Ingredients

- **Hermitian preservation** (`G2HermitianPreservation`): every
  `FixingE111MulLinear` preserves the Hermitian inner product, hence its
  matrix is unitary.
- **Determinant one** (`G2FixingE111DetOne`): the octonion multiplication
  relation `e001 * e010 = e011` forces the determinant to be exactly 1.
- **Composition** (`G2FixingE111Composition`): `onComplexVecMatrix` is a
  monoid homomorphism from `FixingE111MulLinear` to `Matrix (Fin 3) (Fin 3) ℂ`.

## Claim boundary

This is the action-to-SU(3)-matrix side of Baez's stabilizer story. It does
**not** prove surjectivity onto all of `SU(3)`, connectedness of `G₂`, or an
isomorphism `Stab_{G₂}(e111) ≅ SU(3)`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## SU(3) predicate -/

/-- A `3 × 3` complex matrix acts as `SU(3)` on `ℂ³` if it is unitary
    (preserves the Hermitian inner product) and has determinant 1. -/
structure MatrixActsAsSU3OnC3 (M : Matrix (Fin 3) (Fin 3) ℂ) : Prop where
  unitary : MatrixActsUnitaryOnC3 M
  det_one : M.det = 1

/-! ## Main theorem -/

/-- Every `FixingE111MulLinear` map induces a matrix on `ℂ³` that is
    unitary with determinant 1, i.e. it acts as `SU(3)`. -/
theorem FixingE111MulLinear.onComplexVecMatrix_actsAsSU3
    (g : FixingE111MulLinear) :
    MatrixActsAsSU3OnC3 g.onComplexVecMatrix where
  unitary := (fixingE111MulLinear_preservesHermitian g).matrixActsUnitary
  det_one := fixingE111MulLinear_det_eq_one g

/-! ## Identity and composition compatibility -/

-- Re-export the identity theorem (already proved in G2FixingE111Composition)
-- `FixingE111MulLinear.one_onComplexVecMatrix` is already @[simp].

-- Re-export the multiplication theorem (already proved in G2FixingE111Composition)
-- `FixingE111MulLinear.mul_onComplexVecMatrix` is already available.

/-! ## Bundled SU(3) package -/

/-- A bundled record packaging the SU(3) action, identity, and composition
    results for the `FixingE111MulLinear` → matrix assignment. -/
structure G2FixingE111SU3Package where
  /-- Every `FixingE111MulLinear` acts as SU(3) on `ℂ³`. -/
  acts_as_su3 :
    ∀ g : FixingE111MulLinear,
      MatrixActsAsSU3OnC3 g.onComplexVecMatrix
  /-- The identity map has matrix `1`. -/
  matrix_one :
    (1 : FixingE111MulLinear).onComplexVecMatrix = 1
  /-- Composition corresponds to matrix multiplication. -/
  matrix_mul :
    ∀ g h : FixingE111MulLinear,
      (g * h).onComplexVecMatrix =
        g.onComplexVecMatrix * h.onComplexVecMatrix

/-- The canonical `G2FixingE111SU3Package`. -/
noncomputable def g2FixingE111SU3Package :
    G2FixingE111SU3Package where
  acts_as_su3 := FixingE111MulLinear.onComplexVecMatrix_actsAsSU3
  matrix_one := FixingE111MulLinear.one_onComplexVecMatrix
  matrix_mul := FixingE111MulLinear.mul_onComplexVecMatrix

end PhysicsSM.Algebra.Octonion.G2ComplexLine
