import Mathlib
import PhysicsSM.Algebra.Octonion.G2AutomorphismSU3ActionPackage

/-!
# Algebra.Octonion.G2AutomorphismSU3Exactness

Exactness statements for the action of octonion automorphisms fixing `e111`
on the complementary `ℂ³`: the group homomorphism to SU(3) is bijective,
has trivial kernel, is surjective, and determines the automorphism.

## Main results

1. **`toSU3Hom`**: the monoid homomorphism
   `OctonionMulAutFixingE111 →* su3Submonoid` derived from the
   multiplicative equivalence `octonionMulAutFixingE111MulEquivSU3`.

2. **Bijectivity / kernel / surjectivity**: the homomorphism is bijective,
   has trivial kernel, and is surjective.

3. **Matrix action extensionality**: two automorphisms with the same
   complement matrix are equal.

4. **Inverse compatibility**: the complement matrix of `f⁻¹` equals the
   matrix inverse of the complement matrix of `f`.

5. **`G2AutomorphismSU3ExactnessPackage`**: a bundled record collecting
   all exactness statements.

## Claim boundary

This file uses the project's algebraic automorphism/fixing structures.
It does **not** claim the full topological Lie group `G₂`, connectedness,
or smooth isomorphism. The XOR/Fano octonion convention is preserved.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Status: trusted theorem package; no `sorry`.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Part 1: The monoid homomorphism -/

/-- The monoid homomorphism `OctonionMulAutFixingE111 →* su3Submonoid`,
    derived from the multiplicative equivalence
    `octonionMulAutFixingE111MulEquivSU3`. -/
noncomputable def toSU3Hom : OctonionMulAutFixingE111 →* su3Submonoid :=
  octonionMulAutFixingE111MulEquivSU3.toMonoidHom

/-! ## Part 2: Bijectivity -/

/-- `toSU3Hom` is bijective. -/
theorem toSU3Hom_bijective : Function.Bijective toSU3Hom :=
  octonionMulAutFixingE111MulEquivSU3.bijective

/-! ## Part 3: Trivial kernel -/

/-- `toSU3Hom` has trivial kernel: if `toSU3Hom f = 1` then `f = 1`. -/
theorem toSU3Hom_kernel_trivial
    (f : OctonionMulAutFixingE111)
    (hf : toSU3Hom f = 1) : f = 1 := by
  have hinj := toSU3Hom_bijective.1
  apply hinj
  rw [hf, map_one]

/-! ## Part 4: Surjectivity -/

/-- `toSU3Hom` is surjective. -/
theorem toSU3Hom_surjective :
    ∀ M : su3Submonoid,
      ∃ f : OctonionMulAutFixingE111, toSU3Hom f = M :=
  toSU3Hom_bijective.2

/-! ## Part 5: Matrix action extensionality -/

/-- Two automorphisms with the same complement matrix are equal. -/
theorem matrix_action_ext
    (f g : OctonionMulAutFixingE111)
    (h : f.onComplexVecMatrix = g.onComplexVecMatrix) : f = g := by
  have hinj := toSU3Hom_bijective.1
  apply hinj
  change octonionMulAutFixingE111MulEquivSU3 f =
       octonionMulAutFixingE111MulEquivSU3 g
  ext1
  simp only [OctonionMulAutFixingE111.onComplexVecMatrix_eq_su3] at h
  exact h

/-! ## Part 6: Inverse compatibility -/

/-- The complement matrix of `f⁻¹` equals the matrix inverse of the
    complement matrix of `f`, i.e. the `onComplexVecMatrix` assignment
    is compatible with the group inverse. -/
theorem inv_onComplexVecMatrix
    (f : OctonionMulAutFixingE111) :
    (f⁻¹).onComplexVecMatrix = f.onComplexVecMatrix⁻¹ := by
  unfold OctonionMulAutFixingE111.onComplexVecMatrix
  rw [show (f⁻¹).toFixingE111MulLinear =
    (octonionMulAutFixingE111MulEquivFixingE111 f⁻¹ :
      FixingE111MulLinear) from rfl]
  rw [show f.toFixingE111MulLinear =
    (octonionMulAutFixingE111MulEquivFixingE111 f :
      FixingE111MulLinear) from rfl]
  rw [map_inv]
  exact fixingE111MulLinearEquivSU3_map_inv
    (octonionMulAutFixingE111MulEquivFixingE111 f)

/-- Inverse compatibility stated via `toSU3Hom`: `toSU3Hom f⁻¹` is the
    group inverse of `toSU3Hom f` in `su3Submonoid`. -/
theorem toSU3Hom_inv (f : OctonionMulAutFixingE111) :
    toSU3Hom f⁻¹ = (toSU3Hom f)⁻¹ :=
  map_inv toSU3Hom f

/-! ## Part 7: Bundled exactness package -/

/-- Bundled package collecting exactness statements for the
    `OctonionMulAutFixingE111 →* su3Submonoid` homomorphism. -/
structure G2AutomorphismSU3ExactnessPackage where
  /-- The monoid homomorphism. -/
  toSU3Hom : OctonionMulAutFixingE111 →* su3Submonoid
  /-- Bijectivity. -/
  toSU3Hom_bijective : Function.Bijective toSU3Hom
  /-- Trivial kernel. -/
  toSU3Hom_kernel_trivial :
    ∀ f : OctonionMulAutFixingE111,
      toSU3Hom f = 1 → f = 1
  /-- Surjectivity. -/
  toSU3Hom_surjective :
    ∀ M : su3Submonoid,
      ∃ f : OctonionMulAutFixingE111, toSU3Hom f = M
  /-- Matrix action extensionality. -/
  matrix_action_ext :
    ∀ f g : OctonionMulAutFixingE111,
      f.onComplexVecMatrix = g.onComplexVecMatrix → f = g
  /-- Inverse compatibility via `toSU3Hom`. -/
  toSU3Hom_inv :
    ∀ f : OctonionMulAutFixingE111,
      toSU3Hom f⁻¹ = (toSU3Hom f)⁻¹
  /-- Inverse compatibility on the complement matrix. -/
  inv_onComplexVecMatrix :
    ∀ f : OctonionMulAutFixingE111,
      (f⁻¹).onComplexVecMatrix = f.onComplexVecMatrix⁻¹

/-- The canonical `G2AutomorphismSU3ExactnessPackage`, built from the
    previously verified project declarations. -/
noncomputable def g2AutomorphismSU3ExactnessPackage :
    G2AutomorphismSU3ExactnessPackage where
  toSU3Hom := G2ComplexLine.toSU3Hom
  toSU3Hom_bijective := G2ComplexLine.toSU3Hom_bijective
  toSU3Hom_kernel_trivial := G2ComplexLine.toSU3Hom_kernel_trivial
  toSU3Hom_surjective := G2ComplexLine.toSU3Hom_surjective
  matrix_action_ext := G2ComplexLine.matrix_action_ext
  toSU3Hom_inv := G2ComplexLine.toSU3Hom_inv
  inv_onComplexVecMatrix := G2ComplexLine.inv_onComplexVecMatrix

end PhysicsSM.Algebra.Octonion.G2ComplexLine
