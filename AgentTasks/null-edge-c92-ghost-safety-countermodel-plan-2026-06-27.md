# C92 ghost-safety countermodel plan

Purpose: prevent `GoltermanShamirSafe` from becoming empty packaging.

Claude review log:

```text
AgentTasks/model-calls/claude/2026-06-27-102042-c92-ghost-safety-review.md
```

## Review rule

Do not integrate a C92 return as strategically successful if it only defines
abstract predicates. The value of C92 is in explicit non-implication witnesses.

## Required countermodel slots

| Slot | Intended theorem | Minimal witness idea |
| --- | --- | --- |
| M0 | `scalarResiduePositive_not_ghostSafety` | A toy model with positive scalar residue at a pole but at least one gauge-coupled propagator zero. |
| M1 | `kreinPositive_not_ghostSafety` | A toy Krein-positive physical subspace plus a gauge-coupled propagator zero outside that subspace. |
| M2 | `c0SpeciesHealth_not_ghostSafety` | A C0/species-health witness whose elementary interpolating field basis is incomplete. |
| M3 | `exactChiral_not_ghostSafety` | A Ginsparg-Wilson/exact-chirality witness with a remaining gauge-coupled ghost zero. |

## Required positive implication

`GoltermanShamirSafe` may imply:

```text
noGaugeCoupledGhostZeros
```

by field projection/destructuring. That implication is safe. The reverse
direction, and any implication from scalar residue, Krein positivity, exact
chirality, or C0 species health alone, is not safe.

## Integration checklist for returned C92

Accept as useful if the return includes:

- a structure whose fields are destructible and not all `True`;
- explicit distinction between elementary and composite interpolating fields;
- a BRST/cohomology or physical-sector field that is not merely a positivity
  assertion;
- at least one concrete non-implication witness;
- names that avoid `ghostSafe` for residue-only or Krein-only facts.

Reject or resubmit if the return includes:

- pure opaque `Prop`s with no destructors;
- tautological non-implications between unrelated predicates;
- a theorem implying ghost safety from scalar residue positivity;
- a theorem implying ghost safety from Krein positivity;
- a theorem implying ghost safety from exact Ginsparg-Wilson chirality alone;
- a theorem implying ghost safety from C0 species health.

## Follow-up job if C92 is weak

Submit a focused job:

```text
NullEdgeGhostSafetyCounterModels.lean
```

with four explicit toy models `M0`, `M1`, `M2`, `M3` and the four
non-implication theorems above.
