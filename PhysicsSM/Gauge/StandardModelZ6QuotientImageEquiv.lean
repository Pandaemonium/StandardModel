import Mathlib
import PhysicsSM.Gauge.StandardModelZ6IdentityFiber

/-!
# Gauge.StandardModelZ6QuotientImageEquiv

Constructs a canonical type equivalence between the quotient-by-image-equivalence
type `StandardModelCoveringQuotient` and the image subtype
`Set.range CoveringTriple.image` of the covering map.

## Mathematical context

The quotient `StandardModelCoveringQuotient` is `CoveringTriple / ~` where
`t₁ ~ t₂ ↔ t₁.image = t₂.image`. The induced map
`standardModelCoveringQuotientImage` is injective (proved in
`StandardModelZ6ImageQuotient`) and has range equal to
`Set.range CoveringTriple.image`. Together these give a bijection, which
we promote to a type equivalence.

## Claim boundary

This proves a canonical equivalence between a quotient type and an image
subtype for the current quotient-by-image-equality scaffold. It does **not**
prove a group isomorphism, topological quotient, smooth quotient, or
Lie-group theorem.

Status: trusted theorem package; all proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix

/-! ## Quotient-to-image function -/

/--
The function from the quotient to the image subtype, sending each
equivalence class to its common covering-map image (with a proof
that the value lies in `Set.range CoveringTriple.image`).
-/
noncomputable def standardModelCoveringQuotientToImage
    (q : StandardModelCoveringQuotient) :
    Set.range CoveringTriple.image :=
  ⟨standardModelCoveringQuotientImage q, by
    rw [← standardModelCoveringQuotientImage_range]
    exact Set.mem_range_self q⟩

/--
The function `standardModelCoveringQuotientToImage` is injective.
-/
theorem standardModelCoveringQuotientToImage_injective :
    Function.Injective standardModelCoveringQuotientToImage := by
  intro q₁ q₂ h
  have := congr_arg Subtype.val h
  exact standardModelCoveringQuotientImage_injective this

/--
The function `standardModelCoveringQuotientToImage` is surjective.
-/
theorem standardModelCoveringQuotientToImage_surjective :
    Function.Surjective standardModelCoveringQuotientToImage := by
  intro ⟨y, hy⟩
  rw [← standardModelCoveringQuotientImage_range] at hy
  obtain ⟨q, rfl⟩ := hy
  exact ⟨q, rfl⟩

/--
The function `standardModelCoveringQuotientToImage` is bijective.
-/
theorem standardModelCoveringQuotientToImage_bijective :
    Function.Bijective standardModelCoveringQuotientToImage :=
  ⟨standardModelCoveringQuotientToImage_injective,
   standardModelCoveringQuotientToImage_surjective⟩

/-! ## The equivalence -/

/--
The canonical type equivalence between the quotient-by-image-equivalence
type and the image subtype of the covering map.
-/
noncomputable def standardModelCoveringQuotientEquivImage :
    Equiv StandardModelCoveringQuotient (Set.range CoveringTriple.image) :=
  Equiv.ofBijective standardModelCoveringQuotientToImage
    standardModelCoveringQuotientToImage_bijective

/-! ## Coercion / apply lemmas -/

/--
The equivalence sends a quotient element `q` to the subtype whose
underlying value is `standardModelCoveringQuotientImage q`.
-/
theorem standardModelCoveringQuotientEquivImage_apply
    (q : StandardModelCoveringQuotient) :
    (standardModelCoveringQuotientEquivImage q).val =
      standardModelCoveringQuotientImage q := by
  simp [standardModelCoveringQuotientEquivImage,
        Equiv.ofBijective, standardModelCoveringQuotientToImage]

/--
Applying the quotient image map to the inverse of the equivalence
recovers the underlying value.
-/
theorem standardModelCoveringQuotientEquivImage_symm_apply
    (y : Set.range CoveringTriple.image) :
    standardModelCoveringQuotientImage
      (standardModelCoveringQuotientEquivImage.symm y) = y.val := by
  have h := standardModelCoveringQuotientEquivImage.apply_symm_apply y
  have hv := congr_arg Subtype.val h
  simp only [standardModelCoveringQuotientEquivImage,
        Equiv.ofBijective_apply, standardModelCoveringQuotientToImage] at hv
  exact hv

/-! ## Bundled package -/

/--
Package structure bundling the equivalence and its coercion properties.
-/
structure StandardModelZ6QuotientImageEquivPackage where
  quotient_equiv_image :
    Equiv StandardModelCoveringQuotient (Set.range CoveringTriple.image)
  apply_image :
    ∀ q : StandardModelCoveringQuotient,
      (quotient_equiv_image q).val = standardModelCoveringQuotientImage q
  symm_image :
    ∀ y : Set.range CoveringTriple.image,
      standardModelCoveringQuotientImage (quotient_equiv_image.symm y) = y.val

/--
The quotient-image equivalence package, instantiated from the proved
theorems.
-/
noncomputable def standardModelZ6QuotientImageEquivPackage :
    StandardModelZ6QuotientImageEquivPackage :=
  { quotient_equiv_image := standardModelCoveringQuotientEquivImage
    apply_image := standardModelCoveringQuotientEquivImage_apply
    symm_image := standardModelCoveringQuotientEquivImage_symm_apply }

end PhysicsSM.Gauge.StandardModelSubgroup
