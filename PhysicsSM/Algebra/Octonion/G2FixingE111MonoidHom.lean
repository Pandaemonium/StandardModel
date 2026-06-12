import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111SU3Package

/-!
# Algebra.Octonion.G2FixingE111MonoidHom

Packages the assignment `g ↦ g.onComplexVecMatrix` as a `MonoidHom` from the
monoid of `FixingE111MulLinear` maps (under composition) to 3×3 complex
matrices.

## Mathematical context

The `G2FixingE111SU3Package` proves that every `FixingE111MulLinear` map
induces a matrix in SU(3). The `G2FixingE111Composition` proves that
`onComplexVecMatrix` is compatible with composition (matrix multiplication)
and sends the identity to the identity matrix.

This file packages these facts as a `MonoidHom`, together with a variant
landing in the SU(3) subtype and a bundled record.

## Claim boundary

This file packages the G₂-stabilizer-to-SU(3) assignment as a monoid
homomorphism. It does **not** prove surjectivity, injectivity, or the full
isomorphism `Stab_{G₂}(e111) ≅ SU(3)`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## MonoidHom to 3×3 complex matrices -/

/-- The assignment `g ↦ g.onComplexVecMatrix` is a monoid homomorphism
    from `FixingE111MulLinear` to `Matrix (Fin 3) (Fin 3) ℂ`. -/
noncomputable def fixingE111MulLinearToMatrixHom :
    FixingE111MulLinear →* Matrix (Fin 3) (Fin 3) ℂ where
  toFun g := g.onComplexVecMatrix
  map_one' := FixingE111MulLinear.one_onComplexVecMatrix
  map_mul' g h := FixingE111MulLinear.mul_onComplexVecMatrix g h

/-! ## Image lands in SU(3) predicate -/

/-- The image of `fixingE111MulLinearToMatrixHom` lands in the SU(3)
    predicate: every image matrix is unitary with determinant 1. -/
theorem fixingE111MulLinearToMatrixHom_image_actsAsSU3
    (g : FixingE111MulLinear) :
    MatrixActsAsSU3OnC3 (fixingE111MulLinearToMatrixHom g) :=
  FixingE111MulLinear.onComplexVecMatrix_actsAsSU3 g

/-! ## SU(3) subtype monoid structure -/

/-- The identity matrix acts as SU(3). -/
theorem matrixActsAsSU3OnC3_one :
    MatrixActsAsSU3OnC3 (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  rw [← FixingE111MulLinear.one_onComplexVecMatrix]
  exact FixingE111MulLinear.onComplexVecMatrix_actsAsSU3 1

/-- The product of two unitary matrices is unitary. -/
theorem matrixActsUnitaryOnC3_mul {M N : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsUnitaryOnC3 M) (hN : MatrixActsUnitaryOnC3 N) :
    MatrixActsUnitaryOnC3 (M * N) := by
  intro u v
  simp only [← Matrix.mulVec_mulVec]
  rw [hM, hN]

/-- The product of two SU(3) matrices is SU(3). -/
theorem matrixActsAsSU3OnC3_mul {M N : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsAsSU3OnC3 M) (hN : MatrixActsAsSU3OnC3 N) :
    MatrixActsAsSU3OnC3 (M * N) := by
  constructor
  · exact matrixActsUnitaryOnC3_mul hM.unitary hN.unitary
  · rw [Matrix.det_mul, hM.det_one, hN.det_one, one_mul]

/-- The SU(3) subtype as a submonoid of 3×3 complex matrices. -/
noncomputable def su3Submonoid : Submonoid (Matrix (Fin 3) (Fin 3) ℂ) where
  carrier := {M | MatrixActsAsSU3OnC3 M}
  mul_mem' ha hb := matrixActsAsSU3OnC3_mul ha hb
  one_mem' := matrixActsAsSU3OnC3_one

/-! ## Restriction to SU(3) subtype -/

/-- The `FixingE111MulLinear → SU(3)` map as a monoid hom into the
    SU(3) submonoid. -/
noncomputable def fixingE111MulLinearToSU3Hom :
    FixingE111MulLinear →* su3Submonoid where
  toFun g := ⟨g.onComplexVecMatrix,
              FixingE111MulLinear.onComplexVecMatrix_actsAsSU3 g⟩
  map_one' := by
    ext1
    exact FixingE111MulLinear.one_onComplexVecMatrix
  map_mul' g h := by
    ext1
    exact FixingE111MulLinear.mul_onComplexVecMatrix g h

/-! ## Bundled package -/

/-- Bundled record collecting the G₂ → SU(3) monoid homomorphism results. -/
structure G2FixingE111MonoidHomPackage where
  /-- The monoid hom to matrices. -/
  toMatrixHom : FixingE111MulLinear →* Matrix (Fin 3) (Fin 3) ℂ
  /-- Every image lies in SU(3). -/
  image_actsAsSU3 :
    ∀ g : FixingE111MulLinear,
      MatrixActsAsSU3OnC3 (toMatrixHom g)

/-- The canonical G₂-to-SU(3) monoid hom package. -/
noncomputable def g2FixingE111MonoidHomPackage :
    G2FixingE111MonoidHomPackage where
  toMatrixHom := fixingE111MulLinearToMatrixHom
  image_actsAsSU3 := fixingE111MulLinearToMatrixHom_image_actsAsSU3

end PhysicsSM.Algebra.Octonion.G2ComplexLine
