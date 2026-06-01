# Aristotle task: family anomaly naturality

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `e6dc0755-0ebe-4268-b968-24a223e71566`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-family-z6-next-20260531-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-family-anomaly-naturality-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/standardmodel-family-anomaly-naturality-20260531-extracted`
**Type**: anomaly invariance under family relabeling

## Integration

Integrated on 2026-05-31 from Aristotle job
`e6dc0755-0ebe-4268-b968-24a223e71566`.

Live file:

```text
PhysicsSM/StandardModel/FamilyAnomalyNaturality.lean
```

Root import added to `PhysicsSM.lean`.

## Goal

Create a trusted theorem package showing that the Standard Model anomaly
coefficients in `AnomalyPackage.lean` depend only on gauge data, not on family
labels.

This is the anomaly-facing half of the family-symmetry naturality track:
family copies may have different labels, but if their color representation,
weak representation, and hypercharge agree, then all anomaly coefficients and
anomaly-freedom predicates are unchanged.

## Requested file

Create a trusted file:

```text
PhysicsSM/StandardModel/FamilyAnomalyNaturality.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.StandardModel.AnomalyPackage
```

Use namespace:

```lean
namespace PhysicsSM.StandardModel.FamilyAnomalyNaturality
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target declarations

Open or alias the namespace:

```lean
open PhysicsSM.StandardModel.AnomalyPackage
```

### Gauge-data equivalence

Define a predicate for two chiral multiplets having identical gauge data:

```lean
def SameGaugeData (m n : ChiralMultiplet) : Prop :=
  n.color = m.color /\ n.weak = m.weak /\ n.hypercharge = m.hypercharge
```

Prove that `SameGaugeData` preserves:

- `ChiralMultiplet.colorMultiplicity`
- `ChiralMultiplet.weakMultiplicity`
- `ChiralMultiplet.totalMultiplicity`
- the per-multiplet contributions used in:
  - `gravitationalU1Anomaly`
  - `u1CubedAnomaly`
  - `su2SquaredU1Anomaly`
  - `su3SquaredU1Anomaly`
  - `su3CubedAnomaly`
  - `weakDoubletCount`

### Label relabeling

Define a relabeling operation that changes only `label`:

```lean
def relabelMultiplet (newLabel : ChiralMultiplet -> String)
    (m : ChiralMultiplet) : ChiralMultiplet :=
  { m with label := newLabel m }

def relabelMultiplets (newLabel : ChiralMultiplet -> String)
    (ms : List ChiralMultiplet) : List ChiralMultiplet :=
  ms.map (relabelMultiplet newLabel)
```

Prove exact invariance under relabeling:

```lean
theorem gravitationalU1Anomaly_relabel ...
theorem u1CubedAnomaly_relabel ...
theorem su2SquaredU1Anomaly_relabel ...
theorem su3SquaredU1Anomaly_relabel ...
theorem su3CubedAnomaly_relabel ...
theorem weakDoubletCount_relabel ...
```

Then prove predicate-level naturality:

```lean
theorem LocalAnomalyFree.relabel
    (newLabel : ChiralMultiplet -> String) (ms : List ChiralMultiplet)
    (h : LocalAnomalyFree ms) :
    LocalAnomalyFree (relabelMultiplets newLabel ms) := ...

theorem WittenSU2AnomalyFree_relabel
    (newLabel : ChiralMultiplet -> String) (ms : List ChiralMultiplet)
    (h : WittenSU2AnomalyFree ms) :
    WittenSU2AnomalyFree (relabelMultiplets newLabel ms) := ...
```

Finally add a named theorem for the Standard Model table:

```lean
theorem standardModelOneGeneration_relabel_anomalyFree
    (newLabel : ChiralMultiplet -> String) :
    LocalAnomalyFree
      (relabelMultiplets newLabel standardModelOneGeneration) /\
    WittenSU2AnomalyFree
      (relabelMultiplets newLabel standardModelOneGeneration) := ...
```

## Claim boundary

This file proves anomaly naturality under label changes and gauge-data
preserving family copies. It does not assert that a particular triality or
`S3` model supplies the physical family symmetry.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change `AnomalyPackage.lean` unless a tiny, obviously useful simp
  theorem is absolutely necessary.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/StandardModel/FamilyAnomalyNaturality.lean
lake build PhysicsSM.StandardModel.FamilyAnomalyNaturality
```
