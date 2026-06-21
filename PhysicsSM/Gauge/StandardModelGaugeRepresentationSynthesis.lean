import Mathlib
import PhysicsSM.Gauge.StandardModelUnitZ6ExactKernelPackage
import PhysicsSM.Gauge.QunitQubitQutritQuotientRepresentation

/-!
# Gauge.StandardModelGaugeRepresentationSynthesis

Trusted gauge-facing synthesis module connecting the unit-level Z₆ exact
kernel package (`StandardModelUnitZ6ExactKernelPackage`) with the
quunit/qubit/qutrit quotient representation package
(`QunitQubitQutritQuotientRepresentationPackage`).

## Mathematical context

This module bundles two independently verified algebraic facts about the
Standard Model covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`:

1. **Exact kernel**: the kernel is the six-element Z₆ family, and the quotient
   is isomorphic to the SM block subgroup.
2. **Quotient representation**: the block-diagonal action on `QubitPlusQutrit`
   factors through the quotient, and is compatible with the block subgroup
   equivalence.

The synthesis package adds two cross-cutting properties:
- Identity-fiber triviality: if `x.smImage = 1`, the quotient action is `id`.
- Block-equivalence compatibility: the quotient action agrees with `mulVec`
  through the SM block subgroup equivalence.

## Claim boundary

This is an algebraic quotient/representation synthesis theorem only, not a
topological quotient theorem or a physical Hilbert-space claim.

Status: trusted - s o r r y-free.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Gauge.QunitQubitQutritDictionary

open Complex Matrix PhysicsSM.Gauge.StandardModelSubgroup
open PhysicsSM.Gauge.GUTSquare PhysicsSM.Gauge.BlockEmbeddings

/-! ## Bundled synthesis package -/

/--
Bundled synthesis package connecting the unit-level Z₆ exact kernel
package to the quotient representation package, with cross-cutting
identity-fiber and block-equivalence compatibility properties.
-/
structure StandardModelGaugeRepresentationSynthesisPackage where
  /-- The unit-level Z₆ exact kernel package. -/
  unit_z6_exact_kernel : StandardModelUnitZ6ExactKernelPackage
  /-- The quotient representation package. -/
  quunit_quotient_representation :
    QunitQubitQutritQuotientRepresentationPackage
  /-- If the image of `x` is the identity, the quotient action is `id`. -/
  identity_fiber_acts_trivially :
    ∀ x : SMCoveringTriple,
      x.smImage = 1 →
        quotientActQubitPlusQutrit (Quotient.mk _ x) = id
  /-- The quotient action agrees with `mulVec` through the block equiv. -/
  quotient_action_compatible_block_equiv :
    ∀ q : SMCoveringQuotient,
      ∀ v : QubitPlusQutrit,
        quotientActQubitPlusQutrit q v =
          (smCoveringQuotientMulEquivSMBlockUnits q :
            Units GUTMatrix).val.mulVec v

/-! ## Identity fiber triviality -/

/--
If the SM image of a covering triple is the identity, the quotient action
on `QubitPlusQutrit` is the identity function.
-/
theorem identity_fiber_acts_trivially
    (x : SMCoveringTriple)
    (h : x.smImage = 1) :
    quotientActQubitPlusQutrit (Quotient.mk _ x) = id := by
  rw [smCoveringTriple_smImage_one_quotient_eq x h]
  rw [quotientActQubitPlusQutrit_mk]
  exact actQubitPlusQutrit_one

/-! ## Canonical instance -/

/--
The canonical gauge representation synthesis package, instantiated from
the proved declarations.
-/
noncomputable def standardModelGaugeRepresentationSynthesisPackage :
    StandardModelGaugeRepresentationSynthesisPackage where
  unit_z6_exact_kernel := standardModelUnitZ6ExactKernelPackage
  quunit_quotient_representation := qunitQubitQutritQuotientRepresentationPackage
  identity_fiber_acts_trivially := identity_fiber_acts_trivially
  quotient_action_compatible_block_equiv := quotientAction_compatible_blockEquiv

/-! ## Projection theorems -/

theorem gaugeRepresentationSynthesis_has_unit_z6_exact_kernel :
    standardModelGaugeRepresentationSynthesisPackage.unit_z6_exact_kernel =
      standardModelUnitZ6ExactKernelPackage := rfl

theorem gaugeRepresentationSynthesis_has_quunit_quotient_representation :
    standardModelGaugeRepresentationSynthesisPackage.quunit_quotient_representation =
      qunitQubitQutritQuotientRepresentationPackage := rfl

end PhysicsSM.Gauge.QunitQubitQutritDictionary
