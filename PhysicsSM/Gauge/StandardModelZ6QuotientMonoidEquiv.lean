import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientImageEquiv
import PhysicsSM.Gauge.StandardModelZ6QuotientMonoidLaws

/-!
# Gauge.StandardModelZ6QuotientMonoidEquiv

Constructs a `MulEquiv` (monoid equivalence) between the quotient-by-image-equivalence
type `StandardModelCoveringQuotient` and the image submonoid
`standardModelCoveringImageSubmonoid` of the covering map.

## Mathematical context

The quotient `StandardModelCoveringQuotient` carries a `Monoid` instance
(from `StandardModelZ6QuotientMonoidLaws`), and the covering-map image
function `standardModelCoveringQuotientImage` is a monoid homomorphism
whose range defines `standardModelCoveringImageSubmonoid`. Since the
image map is injective and surjective onto the range, the range-restricted
homomorphism `standardModelCoveringQuotientImageSubmonoidHom` is a
bijective monoid homomorphism, which we promote to a `MulEquiv`.

## Claim boundary

This proves a monoid equivalence between the current quotient scaffold and
its image submonoid. It does not prove inverses, a quotient group, a
topological quotient, a smooth quotient, or an isomorphism with
`S(U(2) × U(3))`.

Status: trusted theorem package; all proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix

/-! ## Coercion / apply lemmas for the submonoid hom -/

@[simp] theorem standardModelCoveringQuotientImageSubmonoidHom_val
    (q : StandardModelCoveringQuotient) :
    (standardModelCoveringQuotientImageSubmonoidHom q).val =
      standardModelCoveringQuotientImage q := by
  rfl

theorem standardModelCoveringQuotientImageSubmonoidHom_injective :
    Function.Injective standardModelCoveringQuotientImageSubmonoidHom := by
  intro q r h
  exact standardModelCoveringQuotientImage_injective (congr_arg Subtype.val h)

theorem standardModelCoveringQuotientImageSubmonoidHom_surjective :
    Function.Surjective standardModelCoveringQuotientImageSubmonoidHom := by
  intro ⟨x, hx⟩
  obtain ⟨q, hq⟩ := hx
  exact ⟨q, Subtype.ext hq⟩

/-! ## The monoid equivalence -/

noncomputable def standardModelCoveringQuotientMulEquivImageSubmonoid :
    MulEquiv StandardModelCoveringQuotient standardModelCoveringImageSubmonoid :=
  MulEquiv.ofBijective standardModelCoveringQuotientImageSubmonoidHom
    ⟨standardModelCoveringQuotientImageSubmonoidHom_injective,
     standardModelCoveringQuotientImageSubmonoidHom_surjective⟩

/-! ## Application lemmas -/

@[simp] theorem standardModelCoveringQuotientMulEquivImageSubmonoid_apply_val
    (q : StandardModelCoveringQuotient) :
    (standardModelCoveringQuotientMulEquivImageSubmonoid q).val =
      standardModelCoveringQuotientImage q := by
  convert standardModelCoveringQuotientImageSubmonoidHom_val q

theorem standardModelCoveringQuotientMulEquivImageSubmonoid_symm_image
    (y : standardModelCoveringImageSubmonoid) :
    standardModelCoveringQuotientImage
      (standardModelCoveringQuotientMulEquivImageSubmonoid.symm y) =
      y.val := by
  have h := standardModelCoveringQuotientMulEquivImageSubmonoid.apply_symm_apply y
  have hv := congr_arg Subtype.val h
  simp only [standardModelCoveringQuotientMulEquivImageSubmonoid_apply_val] at hv
  exact hv

/-! ## Bundled package -/

structure StandardModelZ6QuotientMonoidEquivPackage where
  quotient_mul_equiv_image :
    MulEquiv StandardModelCoveringQuotient standardModelCoveringImageSubmonoid
  apply_image :
    ∀ q : StandardModelCoveringQuotient,
      (quotient_mul_equiv_image q).val = standardModelCoveringQuotientImage q
  symm_image :
    ∀ y : standardModelCoveringImageSubmonoid,
      standardModelCoveringQuotientImage (quotient_mul_equiv_image.symm y) =
        y.val

noncomputable def standardModelZ6QuotientMonoidEquivPackage :
    StandardModelZ6QuotientMonoidEquivPackage :=
  { quotient_mul_equiv_image :=
      standardModelCoveringQuotientMulEquivImageSubmonoid
    apply_image :=
      standardModelCoveringQuotientMulEquivImageSubmonoid_apply_val
    symm_image :=
      standardModelCoveringQuotientMulEquivImageSubmonoid_symm_image }

end PhysicsSM.Gauge.StandardModelSubgroup
