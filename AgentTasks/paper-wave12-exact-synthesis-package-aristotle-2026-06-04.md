# Aristotle task: exact Furey/Baez/DVT synthesis package

Date: 2026-06-04

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

## Preferred theorem shape

Create a trusted package such as:

```lean
structure FureyBaezDVTExactSynthesisPackage where
  dvt_quotient_image : DVTTwoSidedImageEquivPackage
  baez_g2_su3_exact : G2AutomorphismSU3ExactnessPackage
  furey_anomaly_decomposition : FureyAnomalyDecompositionPackage
  main_theorem : FureyBaezDVTMainTheorem
  no_full_standard_model_derivation : True
  no_topological_quotient_isomorphism : True
```

Instantiate it as:

```lean
noncomputable def fureyBaezDVTExactSynthesisPackage :
  FureyBaezDVTExactSynthesisPackage := ...
```

## Useful projection theorems

Add theorem statements that make the paper's narrative easy to cite:

```lean
theorem exactSynthesis_has_dvt_quotient_image :
  fureyBaezDVTExactSynthesisPackage.dvt_quotient_image =
    dvtTwoSidedImageEquivPackage := rfl

theorem exactSynthesis_has_baez_g2_su3_exact :
  fureyBaezDVTExactSynthesisPackage.baez_g2_su3_exact =
    g2AutomorphismSU3ExactnessPackage := rfl

theorem exactSynthesis_has_furey_anomaly_decomposition :
  fureyBaezDVTExactSynthesisPackage.furey_anomaly_decomposition =
    fureyAnomalyDecompositionPackage := rfl
```

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- This is a synthesis/indexing theorem, not a new physics derivation.
- Preserve all current claim boundaries.
- Do not depend on the still-running quunit/Z6 jobs from wave 11.

## Verification

Run:

```bash
lake env lean PhysicsSM/Publication/FureyBaezDVTExactSynthesis.lean
lake build PhysicsSM.Publication.FureyBaezDVTExactSynthesis
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave12-20260604
```

Job ID:

```text
8575d517-25bb-4267-8dfe-e117f7221874
```

## Integration

Integrated on 2026-06-04 into:

```text
PhysicsSM/Publication/FureyBaezDVTExactSynthesis.lean
PhysicsSM.lean
```

Result: added the trusted `FureyBaezDVTExactSynthesisPackage` bundling the
DVT two-sided image equivalence, the G2/SU(3) exactness package, the Furey
anomaly decomposition package, and the paper-facing main theorem package.
