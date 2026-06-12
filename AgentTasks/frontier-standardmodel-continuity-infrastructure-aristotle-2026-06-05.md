# Aristotle task: Standard Model quotient continuity infrastructure

Date: 2026-06-05

## Goal

Prove the continuity and topology scaffolding needed for the Standard Model
topological quotient theorem. This is a support job for
`StandardModelTopologicalQuotient`.

Primary target file:

```text
PhysicsSM/Gauge/StandardModelCoveringContinuity.lean
```

Useful existing files:

```text
PhysicsSM/Gauge/BlockEmbeddings.lean
PhysicsSM/Gauge/StandardModelProductCoveringTriple.lean
PhysicsSM/Gauge/StandardModelProductCoveringTrueQuotientSMBlock.lean
PhysicsSM/Gauge/StandardModelBlockSubgroupMulEquiv.lean
```

## Preferred theorem shape

Establish topology instances and continuity lemmas for the concrete matrix
maps already used algebraically:

```lean
instance : TopologicalSpace (SUUnitMatrix n) := ...
instance : TopologicalSpace SMProductCoveringTriple := ...

theorem continuous_su4Block :
    Continuous (fun p : ... => su4Block p.1 p.2) := ...

theorem continuous_smTrueProductCoveringTripleToSMBlockUnits :
    Continuous smTrueProductCoveringTripleToSMBlockUnits := ...
```

If the exact theorem statements need different argument packaging, choose the
cleanest mathlib-compatible versions. Prefer reusing subtype topologies from
`Units`, matrices, and proof-carrying subtypes.

Bundle the result:

```lean
structure StandardModelCoveringContinuityPackage where
  domain_topology : TopologicalSpace SMProductCoveringTriple
  codomain_topology : TopologicalSpace SMBlockUnitsSubgroup
  covering_continuous : Continuous smTrueProductCoveringTripleToSMBlockUnits
```

## Mathematical intent

This job should create the topological API needed before one can honestly
state the quotient as a homeomorphism or smooth Lie-group isomorphism.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not use artificial discrete topology to make continuity trivial.
- Do not alter existing algebraic definitions.
- If mathlib lacks a needed instance for matrix units or quotient topology,
  prove whatever smaller continuity lemmas are available and document the
  missing API in a trusted boundary package.

## Verification

Run:

```bash
lake build PhysicsSM.Gauge.StandardModelCoveringContinuity
```

## Submission

Status: submitted.

Submission project:

```text
AgentTasks/aristotle-submit/frontier-20260605
```

Job ID:

```text
e614d33c-ff6f-459c-8bce-1f5e0da4bf70
```
