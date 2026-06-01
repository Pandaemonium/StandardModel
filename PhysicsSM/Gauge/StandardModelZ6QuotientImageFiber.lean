import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientImageEquiv

/-!
# Gauge.StandardModelZ6QuotientImageFiber

Proves that every image-subtype fiber of `standardModelCoveringQuotientEquivImage`
is subsingleton, and exposes plain uniqueness/injectivity theorems for both the
equivalence and the underlying quotient image map.

## Claim boundary

This proves uniqueness/fiber API for the existing quotient-by-image-equality
scaffold. It does **not** prove a quotient-group theorem.

Status: trusted theorem package; all proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix

/-! ## Injectivity and equality-iff for the equivalence -/

/--
The equivalence `standardModelCoveringQuotientEquivImage` is injective
(immediate from being an `Equiv`).
-/
theorem standardModelCoveringQuotientEquivImage_injective :
    Function.Injective standardModelCoveringQuotientEquivImage :=
  standardModelCoveringQuotientEquivImage.injective

/--
Two quotient elements have the same image under the equivalence
if and only if they are equal.
-/
theorem standardModelCoveringQuotientEquivImage_eq_iff
    (q1 q2 : StandardModelCoveringQuotient) :
    standardModelCoveringQuotientEquivImage q1 =
      standardModelCoveringQuotientEquivImage q2 <-> q1 = q2 :=
  standardModelCoveringQuotientEquivImage.apply_eq_iff_eq

/-! ## Equality-iff and fiber uniqueness for the underlying image map -/

/--
Two quotient elements have the same covering-map image if and only if
they are equal.
-/
theorem standardModelCoveringQuotientImage_eq_iff
    (q1 q2 : StandardModelCoveringQuotient) :
    standardModelCoveringQuotientImage q1 =
      standardModelCoveringQuotientImage q2 <-> q1 = q2 :=
  Iff.intro
    (fun h => standardModelCoveringQuotientImage_injective h)
    (fun h => by rw [h])

/--
If two quotient elements have equal covering-map images, they are equal.
-/
theorem standardModelCoveringQuotientImage_fiber_unique
    {q1 q2 : StandardModelCoveringQuotient}
    (h : standardModelCoveringQuotientImage q1 =
      standardModelCoveringQuotientImage q2) :
    q1 = q2 :=
  standardModelCoveringQuotientImage_injective h

/-! ## Fiber subsingletonness -/

/--
The fiber of `standardModelCoveringQuotientEquivImage` over any point
in the image subtype is a subsingleton (has at most one element).
-/
theorem standardModelCoveringQuotientEquivImage_fiber_subsingleton
    (y : Set.range CoveringTriple.image) :
    Subsingleton {q : StandardModelCoveringQuotient //
      standardModelCoveringQuotientEquivImage q = y} :=
  { allEq := by
      intro x z
      cases x with
      | mk a ha =>
        cases z with
        | mk b hb =>
          apply Subtype.ext
          exact standardModelCoveringQuotientEquivImage_injective (ha.trans hb.symm) }

/-! ## Bundled package -/

/--
Package structure bundling the injectivity, fiber uniqueness, and
fiber subsingletonness results.
-/
structure StandardModelZ6QuotientImageFiberPackage where
  equiv_injective : Function.Injective standardModelCoveringQuotientEquivImage
  image_fiber_unique :
    forall {q1 q2 : StandardModelCoveringQuotient},
      standardModelCoveringQuotientImage q1 =
        standardModelCoveringQuotientImage q2 -> q1 = q2
  equiv_fiber_subsingleton :
    forall y : Set.range CoveringTriple.image,
      Subsingleton {q : StandardModelCoveringQuotient //
        standardModelCoveringQuotientEquivImage q = y}

/--
The quotient-image fiber package, instantiated from the proved theorems.
-/
noncomputable def standardModelZ6QuotientImageFiberPackage :
    StandardModelZ6QuotientImageFiberPackage :=
  { equiv_injective := standardModelCoveringQuotientEquivImage_injective
    image_fiber_unique := standardModelCoveringQuotientImage_fiber_unique
    equiv_fiber_subsingleton :=
      standardModelCoveringQuotientEquivImage_fiber_subsingleton }

end PhysicsSM.Gauge.StandardModelSubgroup
