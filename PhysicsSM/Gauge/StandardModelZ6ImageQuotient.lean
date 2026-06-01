import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientScaffold

/-!
# Gauge.StandardModelZ6ImageQuotient

Proves that the induced image map from the quotient-by-image-equivalence
construction is injective and has range exactly the image of the covering map.

## Mathematical context

The quotient `StandardModelCoveringQuotient` is `CoveringTriple / ~` where
`t₁ ~ t₂ ↔ t₁.image = t₂.image`. The induced map
`standardModelCoveringQuotientImage` sends each equivalence class to the
common image value.

- **Injectivity**: two quotient elements with the same image must come from
  equivalent triples, hence are equal in the quotient.
- **Range**: every element of `Set.range CoveringTriple.image` is the image
  of some triple, hence is in the range of the quotient map.

Claim boundary: this proves set-theoretic facts about the image-equivalence
quotient. It does not prove a group quotient, topological quotient, or Lie
group isomorphism.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix

/-! ## Injectivity -/

/--
The induced image map from the quotient is injective: distinct quotient
elements have distinct images.
-/
theorem standardModelCoveringQuotientImage_injective :
    Function.Injective standardModelCoveringQuotientImage := by
  intro q₁ q₂ h
  induction q₁ using Quotient.ind
  induction q₂ using Quotient.ind
  exact Quotient.sound h

/-! ## Range -/

/--
The range of the quotient image map equals the range of `CoveringTriple.image`.
-/
theorem standardModelCoveringQuotientImage_range :
    Set.range standardModelCoveringQuotientImage =
      Set.range CoveringTriple.image := by
  ext y
  constructor
  · rintro ⟨q, rfl⟩
    induction q using Quotient.ind with
    | _ t => exact ⟨t, rfl⟩
  · rintro ⟨t, rfl⟩
    exact ⟨Quotient.mk _ t, rfl⟩

/--
Every element in the range of `CoveringTriple.image` is attained by the
quotient image map.
-/
theorem standardModelCoveringQuotientImage_surjective_onto_image
    (y : Matrix (Fin 2) (Fin 2) ℂ × Matrix (Fin 3) (Fin 3) ℂ)
    (hy : y ∈ Set.range CoveringTriple.image) :
    ∃ q : StandardModelCoveringQuotient,
      standardModelCoveringQuotientImage q = y := by
  obtain ⟨t, rfl⟩ := hy
  exact ⟨Quotient.mk _ t, rfl⟩

/-! ## Package -/

/--
Package structure bundling injectivity and range characterization of the
quotient image map.
-/
structure StandardModelZ6ImageQuotientPackage where
  image_injective : Function.Injective standardModelCoveringQuotientImage
  image_range :
    Set.range standardModelCoveringQuotientImage =
      Set.range CoveringTriple.image

/--
The quotient image map is injective and has range equal to the range of the
covering map.
-/
theorem standardModelZ6ImageQuotientPackage :
    StandardModelZ6ImageQuotientPackage :=
  ⟨standardModelCoveringQuotientImage_injective,
   standardModelCoveringQuotientImage_range⟩

end PhysicsSM.Gauge.StandardModelSubgroup
