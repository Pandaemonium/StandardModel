import Mathlib
import PhysicsSM.Gauge.StandardModelUnitZ6SMBlockEquiv
import PhysicsSM.Gauge.StandardModelUnitZ6Kernel
import PhysicsSM.Gauge.StandardModelZ6KernelPackage
import PhysicsSM.Gauge.StandardModelProductCoveringTrueZ6Kernel

/-!
# Gauge.StandardModelUnitZ6ExactKernelPackage

Trusted package connecting the unit-level Standard Model quotient theorem
(`SMCoveringQuotient ≃* SMBlockUnitsSubgroup`) to the exact six-element
kernel family.

## Mathematical context

The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`
sends `(α, g, h)` to `(α³ · g, α⁻² · h)`. Its kernel consists of
triples `(α, α⁻³ · I₂, α² · I₃)` where `α⁶ = 1`.

This module collects:

1. **Forward**: each of the six explicit `UnitCoveringKernelElt`s maps to
   identity under `unitCoveringTripleImageGroupHom`.
2. **Cardinality**: `Fintype.card CoveringKernelElt = 6`.
3. **Quotient equivalence**: `SMCoveringQuotient ≃* SMBlockUnitsSubgroup`.
4. **Kernel form**: if `x.smImage = 1` for `x : SMCoveringTriple`, then
   `x.toUnitCoveringTriple` has kernel form
   `(α, α⁻³ · I₂, α² · I₃)`.

### Note on the exact identity fiber

The `SMProductCoveringTriple` setting (where SU(2) and SU(3) parts have
individual determinant-one constraints) allows an exact iff: the identity
fiber is precisely the six kernel elements (see
`StandardModelProductCoveringTrueZ6Kernel`).

At the `SMCoveringTriple` level (which only constrains the *product* of
determinants), the identity fiber contains all triples of the form
`(α, α⁻³ · I₂, α² · I₃)` for any unit-norm `α`, not just sixth roots of
unity. This package therefore provides the kernel-form structural lemma
rather than a finite iff.

## Claim boundary

This is algebraic unit-level exactness only, not a topological quotient
theorem.

Status: trusted - s o r r y-free.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.GUTSquare PhysicsSM.Gauge.BlockEmbeddings

/-! ## Forward: kernel elements map to one -/

/--
Each of the six unit-level kernel elements maps to identity under the
unit covering image homomorphism.
-/
theorem unitKernelFamily_maps_to_one (i : Fin 6) :
    unitCoveringTripleImageGroupHom
      ((sixUnitCoveringKernelElts i).toUnitCoveringTriple) = 1 :=
  sixUnitCoveringKernelElts_image_eq_one i

/-! ## Kernel form for SMCoveringTriple -/

/-
If the image of an `SMCoveringTriple` is the identity, then the SU(2) part
is `matrixScalarUnit (phase⁻¹ ^ 3)`.
-/
theorem smCoveringTriple_smImage_one_su2Part
    (x : SMCoveringTriple)
    (h : x.smImage = 1) :
    x.su2Part = matrixScalarUnit (x.phase⁻¹ ^ 3) := by
  injection h with h₁ h₂ ; simp_all +decide [ Matrix.mul_assoc, Units.ext_iff ];
  rw [ ← h₁, inv_smul_smul₀ ] ; aesop

/-
If the image of an `SMCoveringTriple` is the identity, then the SU(3) part
is `matrixScalarUnit (phase ^ 2)`.
-/
theorem smCoveringTriple_smImage_one_su3Part
    (x : SMCoveringTriple)
    (h : x.smImage = 1) :
    x.su3Part = matrixScalarUnit (x.phase ^ 2) := by
  have h_eq : x.smImage = (matrixScalarUnit (x.phase ^ 3) * x.su2Part, matrixScalarUnit (x.phase⁻¹ ^ 2) * x.su3Part) := by
    exact Prod.ext rfl rfl
  unfold matrixScalarUnit at *; simp_all +decide [ mul_eq_one_iff_eq_inv ] ;

/--
If the image of an `SMCoveringTriple` is the identity, then the underlying
`UnitCoveringTriple` has kernel form: it equals
`⟨α, α⁻³ · I₂, α² · I₃⟩`.

This is the structural kernel-form lemma: the SU(2) and SU(3) parts are
determined by the phase.
-/
theorem smCoveringTriple_smImage_one_kernelForm
    (x : SMCoveringTriple)
    (h : x.smImage = 1) :
    x.toUnitCoveringTriple =
      ⟨x.phase,
        matrixScalarUnit (x.phase⁻¹ ^ 3),
        matrixScalarUnit (x.phase ^ 2)⟩ := by
  have h2 := smCoveringTriple_smImage_one_su2Part x h
  have h3 := smCoveringTriple_smImage_one_su3Part x h
  exact UnitCoveringTriple.ext rfl h2 h3

/--
Any `SMCoveringTriple` whose image is the identity is image-equivalent
to `SMCoveringTriple.one` (and hence represents the identity class in
`SMCoveringQuotient`).
-/
theorem smCoveringTriple_smImage_one_quotient_eq
    (x : SMCoveringTriple)
    (h : x.smImage = 1) :
    (⟦x⟧ : SMCoveringQuotient) = ⟦SMCoveringTriple.one⟧ := by
  apply Quotient.sound
  change SMCoveringTriple.ImageEquiv x SMCoveringTriple.one
  unfold SMCoveringTriple.ImageEquiv
  rw [h, SMCoveringTriple.smImage_one]

/-! ## Bundled package -/

/--
Trusted package connecting the unit-level Z₆ quotient equivalence to
the exact six-element kernel family.
-/
structure StandardModelUnitZ6ExactKernelPackage where
  /-- Each of the six kernel elements maps to identity. -/
  unit_kernel_family_maps_to_one :
    ∀ i : Fin 6,
      unitCoveringTripleImageGroupHom
        ((sixUnitCoveringKernelElts i).toUnitCoveringTriple) = 1
  /-- The covering kernel type has exactly six elements. -/
  quotient_kernel_card_six :
    Fintype.card CoveringKernelElt = 6
  /-- The Z₆ quotient is isomorphic to the SM block subgroup. -/
  quotient_equiv_smblock :
    SMCoveringQuotient ≃* SMBlockUnitsSubgroup
  /-- If `x.smImage = 1`, the SU(2) part is determined by the phase. -/
  kernel_form_su2 :
    ∀ x : SMCoveringTriple, x.smImage = 1 →
      x.su2Part = matrixScalarUnit (x.phase⁻¹ ^ 3)
  /-- If `x.smImage = 1`, the SU(3) part is determined by the phase. -/
  kernel_form_su3 :
    ∀ x : SMCoveringTriple, x.smImage = 1 →
      x.su3Part = matrixScalarUnit (x.phase ^ 2)
  /-- If `x.smImage = 1`, the triple has kernel form. -/
  kernel_form_triple :
    ∀ x : SMCoveringTriple, x.smImage = 1 →
      x.toUnitCoveringTriple =
        ⟨x.phase,
          matrixScalarUnit (x.phase⁻¹ ^ 3),
          matrixScalarUnit (x.phase ^ 2)⟩

/--
The unit-level Z₆ exact kernel package, instantiated from the proved
declarations.
-/
noncomputable def standardModelUnitZ6ExactKernelPackage :
    StandardModelUnitZ6ExactKernelPackage where
  unit_kernel_family_maps_to_one := unitKernelFamily_maps_to_one
  quotient_kernel_card_six := coveringKernelElt_card
  quotient_equiv_smblock := smCoveringQuotientMulEquivSMBlockUnits
  kernel_form_su2 := smCoveringTriple_smImage_one_su2Part
  kernel_form_su3 := smCoveringTriple_smImage_one_su3Part
  kernel_form_triple := smCoveringTriple_smImage_one_kernelForm

end PhysicsSM.Gauge.StandardModelSubgroup
