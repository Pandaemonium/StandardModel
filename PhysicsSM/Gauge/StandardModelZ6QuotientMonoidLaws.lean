import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientMonoid

/-!
# Gauge.StandardModelZ6QuotientMonoidLaws

Upgrades the quotient-monoid scaffold from `One`/`Mul` plus image
compatibility to a genuine `Monoid` API. Packages the quotient-image map
as a monoid homomorphism and exposes the covering-map image as a submonoid
of the matrix-pair codomain.

## Claim boundary

This proves a monoid-level quotient/image scaffold for the current
quotient-by-image-equivalence type. It does not prove inverses, a quotient
group, a topological quotient, a smooth quotient, or an isomorphism with
`S(U(2) × U(3))`.

Status: trusted theorem package; all proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix

/-! ## Auxiliary ext / projection lemmas for CoveringTriple -/

@[ext]
theorem CoveringTriple.ext' {x y : CoveringTriple}
    (h1 : x.phase = y.phase)
    (h2 : x.su2Part = y.su2Part)
    (h3 : x.su3Part = y.su3Part) :
    x = y := by
  cases x; cases y; simp_all

theorem CoveringTriple.mul_phase (x y : CoveringTriple) :
    (x * y).phase = x.phase * y.phase := rfl

theorem CoveringTriple.mul_su2Part (x y : CoveringTriple) :
    (x * y).su2Part = x.su2Part * y.su2Part := rfl

theorem CoveringTriple.mul_su3Part (x y : CoveringTriple) :
    (x * y).su3Part = x.su3Part * y.su3Part := rfl

theorem CoveringTriple.one_phase :
    (1 : CoveringTriple).phase = 1 := rfl

theorem CoveringTriple.one_su2Part :
    (1 : CoveringTriple).su2Part = 1 := rfl

theorem CoveringTriple.one_su3Part :
    (1 : CoveringTriple).su3Part = 1 := rfl

/-! ## Monoid laws for CoveringTriple -/

theorem CoveringTriple.mul_assoc
    (x y z : CoveringTriple) : x * y * z = x * (y * z) := by
  apply CoveringTriple.ext'
  · simp [mul_phase, _root_.mul_assoc]
  · simp [mul_su2Part, _root_.mul_assoc]
  · simp [mul_su3Part, _root_.mul_assoc]

theorem CoveringTriple.one_mul
    (x : CoveringTriple) : 1 * x = x := by
  apply CoveringTriple.ext'
  · simp [mul_phase, one_phase]
  · simp [mul_su2Part, one_su2Part]
  · simp [mul_su3Part, one_su3Part]

theorem CoveringTriple.mul_one
    (x : CoveringTriple) : x * 1 = x := by
  apply CoveringTriple.ext'
  · simp [mul_phase, one_phase]
  · simp [mul_su2Part, one_su2Part]
  · simp [mul_su3Part, one_su3Part]

noncomputable instance CoveringTriple.instMonoid : Monoid CoveringTriple where
  mul_assoc := CoveringTriple.mul_assoc
  one_mul := CoveringTriple.one_mul
  mul_one := CoveringTriple.mul_one

/-! ## Monoid laws for StandardModelCoveringQuotient -/

theorem standardModelCoveringQuotient_mul_assoc
    (q r s : StandardModelCoveringQuotient) :
    q * r * s = q * (r * s) := by
  induction q using Quotient.ind
  induction r using Quotient.ind
  induction s using Quotient.ind
  simp only [standardModelCoveringQuotient_mul_mk]
  exact congrArg _ (CoveringTriple.mul_assoc _ _ _)

theorem standardModelCoveringQuotient_one_mul
    (q : StandardModelCoveringQuotient) : 1 * q = q := by
  induction q using Quotient.ind
  simp only [standardModelCoveringQuotient_one_mk,
    standardModelCoveringQuotient_mul_mk]
  exact congrArg _ (CoveringTriple.one_mul _)

theorem standardModelCoveringQuotient_mul_one
    (q : StandardModelCoveringQuotient) : q * 1 = q := by
  induction q using Quotient.ind
  simp only [standardModelCoveringQuotient_one_mk,
    standardModelCoveringQuotient_mul_mk]
  exact congrArg _ (CoveringTriple.mul_one _)

noncomputable instance StandardModelCoveringQuotient.instMonoid :
    Monoid StandardModelCoveringQuotient where
  mul_assoc := standardModelCoveringQuotient_mul_assoc
  one_mul := standardModelCoveringQuotient_one_mul
  mul_one := standardModelCoveringQuotient_mul_one

/-! ## Quotient image as a monoid homomorphism -/

abbrev StandardModelCoveringImageCodomain :=
  Prod (Matrix (Fin 2) (Fin 2) Complex) (Matrix (Fin 3) (Fin 3) Complex)

noncomputable def standardModelCoveringQuotientImageMonoidHom :
    StandardModelCoveringQuotient →* StandardModelCoveringImageCodomain :=
  { toFun := standardModelCoveringQuotientImage,
    map_one' := standardModelCoveringQuotientImage_one,
    map_mul' := standardModelCoveringQuotientImage_mul }

/-! ## Range as a submonoid -/

noncomputable def standardModelCoveringImageSubmonoid :
    Submonoid StandardModelCoveringImageCodomain :=
  MonoidHom.mrange standardModelCoveringQuotientImageMonoidHom

noncomputable def standardModelCoveringQuotientImageSubmonoidHom :
    StandardModelCoveringQuotient →*
      standardModelCoveringImageSubmonoid :=
  MonoidHom.mrangeRestrict standardModelCoveringQuotientImageMonoidHom

/-! ## Bundled package -/

structure StandardModelZ6QuotientMonoidLawsPackage where
  quotient_monoid : Monoid StandardModelCoveringQuotient
  image_monoid_hom :
    StandardModelCoveringQuotient →* StandardModelCoveringImageCodomain
  image_submonoid : Submonoid StandardModelCoveringImageCodomain

noncomputable def standardModelZ6QuotientMonoidLawsPackage :
    StandardModelZ6QuotientMonoidLawsPackage :=
  { quotient_monoid := StandardModelCoveringQuotient.instMonoid,
    image_monoid_hom := standardModelCoveringQuotientImageMonoidHom,
    image_submonoid := standardModelCoveringImageSubmonoid }

end PhysicsSM.Gauge.StandardModelSubgroup
