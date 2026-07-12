# Aristotle semantic context pack

Generated: 2026-07-12T06:23:36
Query: `stationary Weyl exact Groebner fibre uniqueness tangent reconstruction quintic live numerator census`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/standardmodel-z6-quotient-image-fiber-aristotle-2026-05-31.md` [Aristotle task: Standard Model Z6 quotient-image fiber uniqueness]

Score: `0.778`

```text
# Aristotle task: Standard Model Z6 quotient-image fiber uniqueness

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium-High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `c8351305-cf22-432d-88a6-332784c3e1c8`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-paper-goals-20260531-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-z6-quotient-image-fiber-20260601-result`
**Extracted output**: `AgentTasks/aristotle-output/standardmodel-z6-quotient-image-fiber-20260601-extracted`
**Type**: quotient-image equivalence API polish for the paper
```

### 2. `AgentTasks/baez-sm-z6-exact-kernel-aristotle-2026-05-30.md` [Aristotle task: exact Z6 kernel for the SM covering map]

Score: `0.743`

```text
# Aristotle task: exact Z6 kernel for the SM covering map

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `11e2d903-cc36-4961-8de6-64650f43a30d`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-big-targets-20260530-min-project`
**Output**: `AgentTasks/aristotle-output/baez-sm-z6-exact-kernel-20260530`
**Type**: Standard Model group quotient scaffold
```

### 3. `PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean` [fureyBaezDVTMainTheorem]

Score: `0.742`

```text
ionPackage
  unit_z6_exact_kernel := standardModelUnitZ6ExactKernelPackage
  quunit_quotient_representation :=
    qunitQubitQutritQuotientRepresentationPackage
  claim_boundary := claimBoundary

/-! ## Projection theorems -/

/-- The G₂ stabilizer matrix action is injective (faithful). -/
```

### 4. `PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean` [FureyBaezDVTMainTheorem]

Score: `0.740`

```text
VT quotient-to-image equivalence package. -/
  dvt_image_equiv : DVTTwoSidedImageEquivPackage
  /-- The DVT quotient-to-block-action bridge package. -/
  dvt_block_action_bridge : DVTQuotientBlockActionBridgePackage
  /-- The DVT algebraic stabilizer characterization package. -/
  dvt_full_stabilizer_characterization : DVTFullStabilizerCharacterizationPackage
  /-- The exactness package for the G₂ → Aut(O) → SU(3) sequence. -/
  g2_automorphism_su3_exactness : G2AutomorphismSU3ExactnessPackage
  /-- The Furey anomaly decomposition package. -/
  furey_anomaly_decomposition : FureyAnomalyDecompositionPackage
  /-- The unit-level Z₆ exact kernel package: six kernel elements,
      cardinality, quotient equivalence, and kernel-form structural lemma. -/
  unit_z6_exact_kernel : StandardModelUnitZ6ExactKernelPackage
  /-- The quunit/qubit/qutrit quotient representation package: the block
      action factors through the Standard Model quotient. -/
  quunit_quotient_representation :
    QunitQubitQutritQuotientRepresentationPackage
  /-- Machine-readable non-claims for the manuscript audit trail. -/
  claim_boundary : ClaimBoundary

/-- The canonical instantiation of the main theorem, built entirely from
previously verified project declarations. -/
```

### 5. `PhysicsSM/Publication/FureyBaezDVTExactSynthesis.lean` [exactSynthesis_has_dvt_full_stabilizer_characterization]

Score: `0.740`

```text
theorem exactSynthesis_has_dvt_full_stabilizer_characterization :
    fureyBaezDVTExactSynthesisPackage.dvt_full_stabilizer_characterization =
      dvtFullStabilizerCharacterizationPackage := rfl

/-- The synthesis package contains the Baez G₂/SU(3) exactness result. -/
```

### 6. `AgentTasks/dvt-two-sided-su3-quotient-stabilizer-moonshot-aristotle-2026-06-01.md` [Aristotle task: DVT two-sided SU3 quotient/stabilizer moonshot]

Score: `0.739`

```text
# Aristotle task: DVT two-sided SU3 quotient/stabilizer moonshot

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Moonshot
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `074cdea5-eaf8-492e-9207-ef91d45ca799`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave11-20260601-project`
**Output**:
**Integrated**:
**Type**: DVT exceptional-Jordan stabilizer frontier
```

### 7. `AgentTasks/paper-wave12-exact-synthesis-package-aristotle-2026-06-04.md` [Goal]

Score: `0.739`

```text
## Goal

Create a compact synthesis module that packages the three new exact theorem
islands from wave 11 into one citation-friendly result for the manuscript.

Primary target file:

```text
PhysicsSM/Publication/FureyBaezDVTExactSynthesis.lean
```

Useful imports:

```text
PhysicsSM.Algebra.Jordan.DVTTwoSidedImageEquiv
PhysicsSM.Algebra.Octonion.G2AutomorphismSU3Exactness
PhysicsSM.Algebra.Furey.FureyAnomalyDecomposition
PhysicsSM.Publication.FureyBaezDVTMainTheorem
```
```

### 8. `AgentTasks/null-edge-p9-hodge-conservation-erasure-design-20260624.md` [Suggested Next Steps]

Score: `0.739`

```text
# Suggested Next Steps
Please recommend whether this condition is sufficiently strong, or if it reduces trivially to exact recovery. Recommend any additional algebraic assumptions needed for the P9 Hodge projector.
```

## Scoped paper hits

No paper hits returned.
