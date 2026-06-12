# Aristotle task: wave 11 publication theorem index refresh

Date: 2026-06-04

## Goal

Refresh the publication theorem index so the newly integrated wave 11 theorem
packages are first-class citation targets.

Primary target file:

```text
PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
```

New trusted modules to include:

```text
PhysicsSM.Algebra.Jordan.DVTTwoSidedImageEquiv
PhysicsSM.Algebra.Octonion.G2AutomorphismSU3Exactness
PhysicsSM.Algebra.Furey.FureyAnomalyDecomposition
```

## Preferred theorem-index upgrades

Please update the existing index structures rather than creating a parallel
index file, if that is straightforward:

1. Add `DVTTwoSidedImageEquivPackage` to `JordanAlgebraIndex`.
2. Add `FureyAnomalyDecompositionPackage` to `FureyIndex` or the most suitable
   Furey/anomaly-facing index structure.
3. Add `G2AutomorphismSU3ExactnessPackage` to `BlockBridgeIndex` or
   `G2SU3Index`, whichever is semantically cleaner.
4. Instantiate all new fields from:

```lean
dvtTwoSidedImageEquivPackage
fureyAnomalyDecompositionPackage
g2AutomorphismSU3ExactnessPackage
```

## Projection theorems

Add small citation-friendly projection theorems, for example:

```lean
theorem paperIndex_has_dvt_image_equiv :
  paperTheoremIndex.jordan.dvt_image_equiv =
    dvtTwoSidedImageEquivPackage := rfl

theorem paperIndex_has_furey_anomaly_decomposition :
  paperTheoremIndex.furey.anomaly_decomposition =
    fureyAnomalyDecompositionPackage := rfl

theorem paperIndex_has_g2_automorphism_su3_exactness :
  paperTheoremIndex.g2_su3.automorphism_exactness =
    g2AutomorphismSU3ExactnessPackage := rfl
```

Use the actual field names you choose.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the existing claim boundaries.
- Do not introduce new mathematical claims beyond indexing these trusted
  packages.
- Keep edits scoped to the publication index unless a tiny import-only root
  change is necessary.

## Verification

Run:

```bash
lake build PhysicsSM.Publication.FureyBaezDVTTheoremIndex
```

## Submission

Status: integrated from useful `OUT_OF_BUDGET` partial result.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave12-20260604
```

Job ID:

```text
0e73b3e5-ecc1-40f1-bebe-57a33fe1cfee
```

## Integration

Result status: `OUT_OF_BUDGET` at 14%, but the returned source contained a
complete-looking theorem-index refresh. It was integrated only after local Lean
verification.

Integrated output from:

```text
AgentTasks/aristotle-output/0e73b3e5-extracted/paper-wave12-20260604_aristotle
```

Files integrated:

```text
PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
```

Local verification target:

```bash
lake build PhysicsSM.Publication.FureyBaezDVTTheoremIndex
```
