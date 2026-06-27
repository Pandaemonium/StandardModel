# Wave 22 / C92: Golterman-Shamir ghost-safety API

## Role

You are Aristotle, acting as a Lean proof specialist and adversarial theorem
reviewer for the null-edge / Furey / Standard Model formalization.

## Aristotle metadata

`yaml
aristotle:
  project_id: 03c6e63f-3a39-420e-81d3-173f2611b362
  target_file: PhysicsSM/Draft/NullEdgeGateCGhostSafetyAPI.lean
  status: submitted
`

## Target

Preferred target module:

```text
PhysicsSM/Draft/NullEdgeGateCGhostSafetyAPI.lean
```

If there is already a nearby module with this purpose, create an additive
hardening module instead:

```text
PhysicsSM/Draft/NullEdgeGateCGhostSafetyHardened.lean
```

## Context

The null-edge program separates:

```text
Gate C0 = external species health / regulator control.
Gate C1 = physical chiral release.
```

Recent C0/C1 work:

- C89 was submitted to instantiate concrete RA-Wilson C0 species health.
- C90 was submitted to harden projected Wilson release language.
- C93 was submitted as the first overlap/Ginsparg-Wilson C1 interface.

This C92 job should define the ghost-safety predicates needed by C90/C93 and by
any future Gate C release claim.

## Literature anchors

- Golterman-Shamir `2311.12790`: propagator zeros can become gauge-coupled ghost
  states.
- Golterman-Shamir `2505.20436`: propagator zeros may require enlarged
  elementary-plus-composite interpolating-field bases and remain subject to
  generalized no-go pressure.
- Luscher `hep-lat/9802011`: exact chiral symmetry is not the same as ghost
  safety.

## Main question

Can we define a Lean API that prevents future code from treating scalar residue
positivity, Krein positivity, or C0 species health as full ghost safety?

## Requested declarations

Please create small predicates or structures with explicit separation:

```lean
structure GhostZeroSafetyData where
  noGaugeCoupledGhostZeros : Prop
  brstOrCohomologicalSafe : Prop
  kreinPhysicalSectorPositive : Prop
  scalarResiduePositive : Prop
  interpolatingFieldBasisComplete : Prop

def ScalarResiduePositiveOnly : Prop := ...
def GoltermanShamirSafe : Prop := ...
```

The exact names may vary. The important point is that full safety must be
strictly stronger than scalar residue positivity alone.

## Requested guardrail theorems

Please aim for theorem names like:

```lean
scalarResiduePositive_not_ghostSafety
kreinPositive_not_ghostSafety
c0SpeciesHealth_not_ghostSafety
ghostSafety_requires_noGaugeCoupledGhostZeros
ghostSafety_requires_interpolatingBasis_or_noZeros
```

These can be abstract logical non-implication witnesses if needed. For example,
construct records where scalar residue positivity holds but
`noGaugeCoupledGhostZeros` is false.

## Acceptance criteria

- Do not claim any concrete null-edge operator is ghost-safe.
- Do not claim C0 implies ghost safety.
- Do not conflate Krein positivity with unitarity or ghost safety.
- Do not make `GoltermanShamirSafe` equivalent to scalar residue positivity.
- Prefer tiny finite/Prop-level witness theorems over a large analytic story.

## Semantic review checklist

When you return, include:

- exact predicates/structures introduced;
- exact non-implication guardrails proved;
- which fields are assumptions versus theorems;
- how downstream C90/C93 should import or refer to this API;
- any names that should be avoided because they overclaim.
