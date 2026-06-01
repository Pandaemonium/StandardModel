import Mathlib
import PhysicsSM.Gauge.StandardModelZ6ImageQuotient

/-!
# Gauge.StandardModelZ6IdentityFiber

Identity-fiber facts for the Standard Model covering-map quotient.

## Mathematical context

The quotient `StandardModelCoveringQuotient` is `CoveringTriple / ~` where
`t₁ ~ t₂ ↔ t₁.image = t₂.image`. This file proves:

1. Every kernel element becomes the identity class in the quotient.
2. A quotient element equals the identity class if and only if its image
   equals the identity image.

These are set-theoretic facts about the image-equivalence quotient. No
group quotient, topological quotient, or Lie group isomorphism is claimed.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix

/-! ## Kernel elements map to the identity class -/

/--
Every kernel element, when embedded as a covering triple and passed to
the quotient, equals the identity class.
-/
theorem kernelElt_quotient_eq_identity (k : CoveringKernelElt) :
    (Quotient.mk CoveringTriple.imageSetoid
        (CoveringTriple.ofKernelElt k) : StandardModelCoveringQuotient) =
      Quotient.mk CoveringTriple.imageSetoid CoveringTriple.identity :=
  Quotient.sound (kernelElt_imageEquivalent_identity k)

/-! ## Identity-fiber characterization -/

/--
A quotient element equals the identity class if and only if the induced
image map sends it to the identity image.
-/
theorem quotient_eq_identity_iff_image_eq_identity
    (q : StandardModelCoveringQuotient) :
    q = Quotient.mk CoveringTriple.imageSetoid CoveringTriple.identity ↔
      standardModelCoveringQuotientImage q =
        CoveringTriple.identity.image := by
  constructor
  · rintro rfl; rfl
  · intro h
    exact standardModelCoveringQuotientImage_injective h

/-! ## Pointwise image version -/

/--
The quotient image of a kernel element equals the quotient image of the
identity triple.
-/
theorem kernelElt_quotientImage_eq_identityImage (k : CoveringKernelElt) :
    standardModelCoveringQuotientImage
        (Quotient.mk CoveringTriple.imageSetoid
          (CoveringTriple.ofKernelElt k)) =
      standardModelCoveringQuotientImage
        (Quotient.mk CoveringTriple.imageSetoid CoveringTriple.identity) :=
  congrArg standardModelCoveringQuotientImage
    (kernelElt_quotient_eq_identity k)

/-! ## Bundled package -/

/--
Package structure bundling the identity-fiber results.
-/
structure StandardModelZ6IdentityFiberPackage where
  kernel_quotient_identity :
    ∀ k : CoveringKernelElt,
      (Quotient.mk CoveringTriple.imageSetoid
          (CoveringTriple.ofKernelElt k) : StandardModelCoveringQuotient) =
        Quotient.mk CoveringTriple.imageSetoid CoveringTriple.identity
  identity_fiber :
    ∀ q : StandardModelCoveringQuotient,
      q = Quotient.mk CoveringTriple.imageSetoid CoveringTriple.identity ↔
        standardModelCoveringQuotientImage q =
          CoveringTriple.identity.image

/--
The identity-fiber package, instantiated from the proved theorems.
-/
theorem standardModelZ6IdentityFiberPackage :
    StandardModelZ6IdentityFiberPackage :=
  { kernel_quotient_identity := kernelElt_quotient_eq_identity
    identity_fiber := quotient_eq_identity_iff_image_eq_identity }

end PhysicsSM.Gauge.StandardModelSubgroup
