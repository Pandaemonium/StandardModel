# codex-suiteD-modular-entropy-consistency-20260709

You are Aristotle working in the `PhysicsSM` Lean project.

## Goal

Create and prove a new module:

```text
PhysicsSM/Draft/NullEdge/MassResourceConsistency.lean
```

Compose these landed Suite D pieces:

- `PhysicsSM.Draft.NullEdge.ModularSelection`
- `PhysicsSM.Draft.NullEdge.MassResourceModularAudit`
- `PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone`
- `PhysicsSM.Draft.NullEdge.SuiteCDNextRungs`

Run the narrow check first:

```text
lake env lean PhysicsSM/Draft/NullEdge/MassResourceConsistency.lean
```

## Intended theorem pieces

The goal is to turn the Suite D guardrails into a small consistency theorem
suite:

1. The modular generator is invariant under central shifts as a commutator
generator, but the raw operator equality with `B` is false for nonzero shifts.
Package this as a paired theorem using:

- `MassResourceModularAudit.modular_generator_eq_adB`
- `MassResourceModularAudit.modular_shift_operator_ne`

2. The four Suite D channel charges are a genuine noncollapsed torus:

- use `SuiteCDNextRungs.channel_charges_traceless`
- use `SuiteCDNextRungs.channel_charges_independent`

3. If easy, define a small `structure` or theorem bundling:

```lean
structure MassResourceConsistency where
  traceless : ...
  independent : ...
  centralShiftGeneratorInvariant : ...
  centralShiftOperatorNotEqual : ...
```

or use a theorem returning a conjunction instead of a structure. Prefer the
theorem/conjunction if it is easier and more robust.

## Claim discipline

This is a finite consistency/guardrail theorem suite. It should not claim the
KMS generator is physically derived or that a full thermodynamic limit exists.
If any target is merely a coordinate-basis fact, say so in the docstring and do
not dress it as geometry.

Add guard pins for headline theorem(s). Do not introduce new global assumptions.
