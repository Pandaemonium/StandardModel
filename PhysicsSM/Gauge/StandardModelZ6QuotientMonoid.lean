import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientImageFiber
import PhysicsSM.Gauge.StandardModelBlockHom

/-!
# Gauge.StandardModelZ6QuotientMonoid

Pointwise multiplication on `CoveringTriple`, multiplicativity of the
covering-map image, and induced multiplication on the quotient
`StandardModelCoveringQuotient`.

## Claim boundary

This is a monoid/image scaffold for the current quotient-by-image-equivalence
type. It does not prove a quotient group, a topological quotient, a smooth
quotient, or an isomorphism with `S(U(2) x U(3))`.

Status: trusted theorem package; all proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix

/-! ## Pointwise algebra on CoveringTriple -/

noncomputable instance : One CoveringTriple := ⟨CoveringTriple.identity⟩

noncomputable instance : Mul CoveringTriple := ⟨fun x y =>
  { phase := x.phase * y.phase
    su2Part := x.su2Part * y.su2Part
    su3Part := x.su3Part * y.su3Part }⟩

/-! ## Image is multiplicative -/

/-- The image of the identity triple is the identity pair. -/
theorem CoveringTriple.image_one :
    (1 : CoveringTriple).image = 1 := by
  change coveringMap 1 1 1 = (1, 1)
  exact coveringMap_one

/-- The image map is multiplicative. -/
theorem CoveringTriple.image_mul
    (x y : CoveringTriple) :
    (x * y).image = x.image * y.image := by
  change coveringMap (x.phase * y.phase) (x.su2Part * y.su2Part)
    (x.su3Part * y.su3Part) =
    (fun p q => (p.1 * q.1, p.2 * q.2))
      (coveringMap x.phase x.su2Part x.su3Part)
      (coveringMap y.phase y.su2Part y.su3Part)
  rw [coveringMap_mul]

/-! ## Image equivalence respects multiplication -/

/-- Image equivalence is a congruence for multiplication. -/
theorem CoveringTriple.imageEquivalent_mul
    {x x' y y' : CoveringTriple}
    (hx : CoveringTriple.ImageEquivalent x x')
    (hy : CoveringTriple.ImageEquivalent y y') :
    CoveringTriple.ImageEquivalent (x * y) (x' * y') := by
  unfold ImageEquivalent at *
  rw [image_mul, image_mul, hx, hy]

/-! ## Quotient multiplication -/

noncomputable instance : One StandardModelCoveringQuotient :=
  ⟨Quotient.mk CoveringTriple.imageSetoid (1 : CoveringTriple)⟩

noncomputable instance : Mul StandardModelCoveringQuotient :=
  ⟨Quotient.lift₂
    (fun x y => Quotient.mk CoveringTriple.imageSetoid (x * y))
    (fun _ _ _ _ hx hy => Quotient.sound (CoveringTriple.imageEquivalent_mul hx hy))⟩

/-! ## Representative lemmas -/

theorem standardModelCoveringQuotient_one_mk :
    (1 : StandardModelCoveringQuotient) =
      Quotient.mk CoveringTriple.imageSetoid (1 : CoveringTriple) :=
  rfl

theorem standardModelCoveringQuotient_mul_mk
    (x y : CoveringTriple) :
    (Quotient.mk CoveringTriple.imageSetoid x *
      Quotient.mk CoveringTriple.imageSetoid y :
        StandardModelCoveringQuotient) =
      Quotient.mk CoveringTriple.imageSetoid (x * y) :=
  rfl

/-! ## Quotient image multiplicativity -/

/-- The quotient image map is multiplicative. -/
theorem standardModelCoveringQuotientImage_mul
    (q r : StandardModelCoveringQuotient) :
    standardModelCoveringQuotientImage (q * r) =
      standardModelCoveringQuotientImage q *
        standardModelCoveringQuotientImage r := by
  induction q using Quotient.ind with | _ x => ?_
  induction r using Quotient.ind with | _ y => ?_
  · change standardModelCoveringQuotientImage
        (Quotient.mk _ x * Quotient.mk _ y) =
      standardModelCoveringQuotientImage (Quotient.mk _ x) *
        standardModelCoveringQuotientImage (Quotient.mk _ y)
    rw [standardModelCoveringQuotient_mul_mk]
    simp only [standardModelCoveringQuotientImage_mk]
    exact CoveringTriple.image_mul x y

/-- The quotient image map sends one to one. -/
theorem standardModelCoveringQuotientImage_one :
    standardModelCoveringQuotientImage (1 : StandardModelCoveringQuotient) = 1 := by
  rw [standardModelCoveringQuotient_one_mk, standardModelCoveringQuotientImage_mk]
  exact CoveringTriple.image_one

/-! ## Bundled package -/

/--
Package structure bundling the image multiplicativity and image-one results.
-/
structure StandardModelZ6QuotientMonoidPackage where
  image_mul :
    forall q r : StandardModelCoveringQuotient,
      standardModelCoveringQuotientImage (q * r) =
        standardModelCoveringQuotientImage q *
          standardModelCoveringQuotientImage r
  image_one :
    standardModelCoveringQuotientImage (1 : StandardModelCoveringQuotient) = 1

/--
The quotient-monoid package, instantiated from the proved theorems.
-/
theorem standardModelZ6QuotientMonoidPackage :
    StandardModelZ6QuotientMonoidPackage :=
  { image_mul := standardModelCoveringQuotientImage_mul
    image_one := standardModelCoveringQuotientImage_one }

end PhysicsSM.Gauge.StandardModelSubgroup
