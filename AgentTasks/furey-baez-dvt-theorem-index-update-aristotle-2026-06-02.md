# Aristotle task: FureyBaezDVT theorem index update

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `9c861ec2-0c71-4107-87aa-458735f09b04`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave4-20260602`
**Output**: `AgentTasks/aristotle-output/furey-baez-dvt-index-update-20260602`
**Type**: Editorial — update the paper-facing theorem index

## Goal

Update `PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean` to include all
the major new theorem islands completed since the last index update.

## Current state of the index

The file at `PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean` currently
imports and bundles results from:
- `OctonionFoundationIndex` — complex-line and splitting foundations
- `JordanAlgebraIndex` — Jordan identity, DVT central-kernel
- `FureyIndex` — Furey electroweak package
- `GaugeIndex` — Z6 kernel, image-quotient packages
- `BlockBridgeIndex` — C3-to-GUT-square bridge
- `AnomalyNaturalityIndex` — family anomaly naturality

## New results to add

### 1. G₂ ≅ SU(3) (the moonshot)

Import and bundle:
```lean
import PhysicsSM.Algebra.Octonion.G2FixingE111SU3Equiv
import PhysicsSM.Algebra.Octonion.G2FixingE111Faithful
```

New index bundle:

```lean
/-- Bundled index of the G₂ stabilizer ≅ SU(3) results. -/
structure G2SU3Index where
  /-- Every FixingE111MulLinear acts as SU(3) on ℂ³. -/
  fixing_acts_as_su3 :
    ∀ g : FixingE111MulLinear, MatrixActsAsSU3OnC3 g.onComplexVecMatrix
  /-- The assignment g ↦ onComplexVecMatrix is injective. -/
  faithful : Function.Injective fixingE111MulLinearToMatrixHom
  /-- The SU(3) monoid hom is surjective. -/
  surjective : Function.Surjective fixingE111MulLinearToSU3Hom
  /-- The full MulEquiv FixingE111MulLinear ≃* su3Submonoid. -/
  mul_equiv : MulEquiv FixingE111MulLinear su3Submonoid

noncomputable def g2SU3Index : G2SU3Index where
  fixing_acts_as_su3 := FixingE111MulLinear.onComplexVecMatrix_actsAsSU3
  faithful := fixingE111MulLinearToMatrixHom_injective
  surjective := fixingE111MulLinearToSU3Hom_surjective
  mul_equiv := fixingE111MulLinearEquivSU3
```

### 2. Inner derivations of h₃(O)

Import:
```lean
import PhysicsSM.Algebra.Jordan.InnerDerivation
```

New index bundle:

```lean
/-- Bundled index of inner derivation results. -/
structure InnerDerivationIndex where
  /-- The inner derivation D_{a,b} is an H3ODerivation. -/
  inner_deriv_is_derivation :
    ∀ a b : H3O, (innerDerivation a b).leibniz' = innerDerivation_leibniz a b
  /-- Antisymmetry. -/
  antisymm : ∀ a b : H3O, innerDerivation a b = -(innerDerivation b a)
  /-- Linearity in first argument. -/
  linear :
    ∀ a₁ a₂ b : H3O,
      innerDerivation (a₁ + a₂) b = innerDerivation a₁ b + innerDerivation a₂ b
```

### 3. Krasnov complex module

Import:
```lean
import PhysicsSM.Spinor.KrasnovComplexModuleInstance
```

New index bundle:

```lean
/-- Bundled index of the Krasnov complex module structure. -/
structure KrasnovModuleIndex where
  /-- OctonionicQubit is a module over ℂ. -/
  complex_module : Module ℂ OctonionicQubit
  /-- The complex structure J equals multiplication by Complex.I. -/
  J_eq_I : ∀ q : OctonionicQubit, rightMulE111 q = Complex.I • q
  /-- J² = -id. -/
  J_sq_neg : ∀ q : OctonionicQubit, rightMulE111 (rightMulE111 q) = -q
```

### 4. DVT Z₃ two-sided kernel iff

Import:
```lean
import PhysicsSM.Algebra.Jordan.DVTTwoSidedActionKernelZ3Iff
```

Add to `JordanAlgebraIndex`:

```lean
/-- The iff characterization: the det-1 two-sided kernel is exactly the
    cube-root scalar pairs. -/
dvt_z3_kernel_iff :
  ∀ A B : Units (Matrix (Fin 3) (Fin 3) ℂ),
    DVTTwoSidedKernelDetOne A.val B.val ↔
      ∃ z : DVTZ3CentralScalar,
        A.val = (z : ℂ) • 1 ∧ B.val = (z : ℂ)⁻¹ • 1
```

### 5. SMBlock covering surjectivity (if available)

If `PhysicsSM.Gauge.StandardModelCoveringMapSurjective` exists, add:

```lean
/-- Every SMBlock element is covered by an SMCoveringTriple. -/
sm_block_surjective :
  ∀ M : GUTMatrix, SMBlockPredicate M →
    ∃ x : SMCoveringTriple, fromBlocks x.image.1.val 0 0 x.image.2.val = M
```

## Updated `PaperTheoremIndex`

Extend the existing `PaperTheoremIndex` structure with new fields:

```lean
structure PaperTheoremIndex where
  -- existing fields ...
  octonion : OctonionFoundationIndex
  jordan : JordanAlgebraIndex       -- add dvt_z3_kernel_iff here
  furey : FureyIndex
  gauge : GaugeIndex
  block_bridge : BlockBridgeIndex
  anomaly : AnomalyNaturalityIndex
  -- new fields:
  g2_su3 : G2SU3Index
  inner_deriv : InnerDerivationIndex
  krasnov_module : KrasnovModuleIndex
```

## Important constraints

- Do **not** remove any existing fields from any structure.
- Do **not** change the `ClaimBoundary` structure.
- Prefer adding new fields to existing structures over splitting them.
- If a theorem referenced in the new bundles does not exist, use a `True` placeholder
  rather than `sorry`, and add a comment noting the target.
- The file must stay sorry-free.
- Do **not** add `import PhysicsSM.Gauge.StandardModelCoveringMapSurjective` unless
  that file exists in the project (check first).

## Verification

```bash
lake env lean PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
lake build PhysicsSM.Publication.FureyBaezDVTTheoremIndex
```
