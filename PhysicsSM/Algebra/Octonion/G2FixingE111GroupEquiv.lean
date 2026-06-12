import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111SU3Equiv
import PhysicsSM.Algebra.Jordan.DVTTwoSidedSU3QuotientStabilizer

/-!
# Algebra.Octonion.G2FixingE111GroupEquiv

Upgrades the monoid equivalence `FixingE111MulLinear ≃* su3Submonoid` to a
**group** isomorphism by endowing both sides with inverse operations and
proving the group axioms.

## Mathematical context

The moonshot `G2FixingE111SU3Equiv` proved:
```
fixingE111MulLinearEquivSU3 : MulEquiv FixingE111MulLinear su3Submonoid
```
This is a monoid equivalence. However, `su3Submonoid` consists of unitary
matrices with determinant 1 — these are invertible, so `su3Submonoid` is
actually a **group**. Similarly, `FixingE111MulLinear` maps bijectively to an
invertible group, so it also carries an inverse operation.

This file establishes the group structure on both sides and upgrades the
`MulEquiv` to a proper group isomorphism.

## Claim boundary

This proves the algebraic group isomorphism between `FixingE111MulLinear` and
`SU(3)` as submonoid of matrices. It does **not** prove:
- Lie group structure or smooth isomorphism.
- That `FixingE111MulLinear` is exactly `Stab_{G₂}(e111)`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Part A: SU(3) matrices are closed under inverse -/

/-- The inverse of an SU(3) matrix is again an SU(3) matrix. -/
theorem matrixActsAsSU3OnC3_inv
    {M : Matrix (Fin 3) (Fin 3) ℂ}
    (hM : MatrixActsAsSU3OnC3 M) :
    MatrixActsAsSU3OnC3 M⁻¹ := by
  have := hM.mul_conjTranspose_self
  rw [Matrix.inv_eq_right_inv this]
  constructor
  · intro u v
    have := hM.unitary (M.conjTranspose.mulVec u)
      (M.conjTranspose.mulVec v)
    simp_all +decide [Matrix.mulVec_mulVec]
  · convert congr_arg Matrix.det this using 1
    · norm_num [hM.det_one]
    · norm_num [Matrix.det_fin_three]

/-- `su3Submonoid` has an inverse operation: the matrix inverse of an
    SU(3) matrix is again SU(3). -/
noncomputable instance su3Submonoid.instInv :
    Inv su3Submonoid where
  inv M := ⟨(M : Matrix (Fin 3) (Fin 3) ℂ)⁻¹,
    matrixActsAsSU3OnC3_inv M.property⟩

/-- `su3Submonoid` forms a group under matrix multiplication and
    inversion. -/
noncomputable instance su3Submonoid.instGroup :
    Group su3Submonoid :=
  { su3Submonoid.toMonoid with
    inv := su3Submonoid.instInv.inv
    inv_mul_cancel := fun ⟨M, hM⟩ => by
      ext1
      simp only [Submonoid.coe_mul, Submonoid.coe_one]
      change M⁻¹ * M = 1
      exact Matrix.nonsing_inv_mul M
        (by rw [hM.det_one]; exact isUnit_one) }

/-! ## Part B: FixingE111MulLinear has inverses -/

/-- The inverse of a `FixingE111MulLinear` map, defined via the SU(3)
    equivalence: transport the matrix inverse back. -/
noncomputable def FixingE111MulLinear.inv
    (g : FixingE111MulLinear) : FixingE111MulLinear :=
  fixingE111MulLinearEquivSU3.symm
    ⟨(fixingE111MulLinearEquivSU3 g :
        Matrix (Fin 3) (Fin 3) ℂ)⁻¹,
     matrixActsAsSU3OnC3_inv
       (fixingE111MulLinearEquivSU3 g).property⟩

/-- `FixingE111MulLinear` has an inverse operation. -/
noncomputable instance FixingE111MulLinear.instInv :
    Inv FixingE111MulLinear where
  inv := FixingE111MulLinear.inv

set_option maxHeartbeats 400000 in
/-- `FixingE111MulLinear` forms a group under composition. -/
noncomputable instance FixingE111MulLinear.instGroup' :
    Group FixingE111MulLinear :=
  { FixingE111MulLinear.instMonoid with
    inv := FixingE111MulLinear.inv
    inv_mul_cancel := fun g => by
      apply fixingE111MulLinearEquivSU3.injective
      simp +decide [FixingE111MulLinear.inv]
      exact Subtype.ext (Matrix.nonsing_inv_mul _ <| by
        rw [(fixingE111MulLinearEquivSU3 g).2.det_one]
        exact isUnit_one) }

/-! ## Part C: Group isomorphism -/

set_option maxHeartbeats 400000 in
/-- The `MulEquiv` between `FixingE111MulLinear` and `su3Submonoid`
    respects the group (inverse) structure: it maps the inverse in
    `FixingE111MulLinear` to the matrix inverse in `su3Submonoid`. -/
theorem fixingE111MulLinearEquivSU3_map_inv
    (g : FixingE111MulLinear) :
    (fixingE111MulLinearEquivSU3 g⁻¹ :
        Matrix (Fin 3) (Fin 3) ℂ) =
    (fixingE111MulLinearEquivSU3 g :
        Matrix (Fin 3) (Fin 3) ℂ)⁻¹ := by
  convert congr_arg Subtype.val
    (MulEquiv.apply_symm_apply fixingE111MulLinearEquivSU3
      ⟨(fixingE111MulLinearEquivSU3 g :
          Matrix (Fin 3) (Fin 3) ℂ)⁻¹,
       matrixActsAsSU3OnC3_inv
         (fixingE111MulLinearEquivSU3 g).2⟩) using 1

/-- The full G₂ stabilizer ≅ SU(3) isomorphism as a `MulEquiv` of
    groups. Since both sides are now groups and the underlying
    `MulEquiv` is unchanged, this is the same equivalence viewed as a
    group isomorphism. -/
noncomputable def fixingE111MulLinearGroupEquivSU3 :
    FixingE111MulLinear ≃* su3Submonoid :=
  fixingE111MulLinearEquivSU3

/-! ## Bundled package -/

/-- Package documenting G₂ stabilizer ≅ SU(3) as a group
    isomorphism. -/
structure G2FixingE111GroupEquivPackage where
  /-- The group isomorphism. -/
  group_equiv : FixingE111MulLinear ≃* su3Submonoid
  /-- The underlying MulEquiv agrees with the monoid hom. -/
  agrees_with_hom :
    ∀ g, (group_equiv g : Matrix (Fin 3) (Fin 3) ℂ) =
      g.onComplexVecMatrix

/-- The canonical G₂-to-SU(3) group equivalence package. -/
noncomputable def g2FixingE111GroupEquivPackage :
    G2FixingE111GroupEquivPackage where
  group_equiv := fixingE111MulLinearGroupEquivSU3
  agrees_with_hom := fun g => by rfl

end PhysicsSM.Algebra.Octonion.G2ComplexLine
