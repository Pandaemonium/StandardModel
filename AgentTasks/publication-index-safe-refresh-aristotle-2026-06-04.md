# Aristotle task: safe publication theorem-index refresh

Date: 2026-06-04

## Goal

Safely update the paper-facing theorem index without dropping any live fields.

Target modules:

```text
PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean
```

## Context

Job `47d9b960-feda-4b14-84d3-fbc4bad7aa66` returned OUT_OF_BUDGET. Its output
contained useful index ideas, but the file snapshot was stale and would have
removed newer integrated work. This job is a safer retry.

## Required constraints

- Preserve every existing field in live `FureyBaezDVTTheoremIndex.lean`.
- Preserve every existing import that still compiles.
- Do not import `PhysicsSM.Gauge.StandardModelUnitZ6SMBlockEquiv` unless that
  module is repaired and `lake env lean` passes for it in this same job.
- Prefer indexing the newer true-product Z6 quotient module instead:
  `PhysicsSM.Gauge.StandardModelProductCoveringTrueQuotientSMBlock`.
- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.

## Results to index if available

Add compact package fields for:

- `PhysicsSM.Algebra.Furey.WeakIsospinLadderDerived`
  - `TPlusDerived_eq_TPlusEnd`
  - `TMinusDerived_eq_TMinusEnd`
  - `TPlusEnd_unique`
  - `TMinusEnd_unique`
- `PhysicsSM.Algebra.Furey.ElectroweakAnomalyBridge`
- `PhysicsSM.Algebra.Furey.ElectroweakCompletePackage`
- `PhysicsSM.Algebra.Jordan.ComplementJordanBimodule`
- `PhysicsSM.Algebra.Jordan.InnerDerivationStandardBLieSubalgebra`
- `PhysicsSM.Algebra.Jordan.InnerDerivationStandardBStabilizerSpan`
- `PhysicsSM.Algebra.Jordan.InnerDerivationStandardBSU3Bridge`
- `PhysicsSM.Algebra.Octonion.G2AutomorphismStabilizerBridge`
- `PhysicsSM.Spinor.KrasnovCentralizerUnitary`

If some names differ, inspect the corresponding modules and use the actual
declarations. Add short comments explaining any omitted result.

## Verification

Run:

```bash
lake env lean PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
lake env lean PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean
```

If both pass, also try:

```bash
lake build PhysicsSM.Publication.FureyBaezDVTTheoremIndex
lake build PhysicsSM.Publication.FureyBaezDVTMainTheorem
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave9-20260604`

Job ID: `45bf369e-cf54-4114-ad4e-fb30f06a19a8`
