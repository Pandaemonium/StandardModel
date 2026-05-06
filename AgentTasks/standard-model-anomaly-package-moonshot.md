# Task: Complete Standard Model anomaly package and Furey bridge

**Agent**: Aristotle
**Status**: In progress
**Priority**: Very high
**Job ID**: `8778de36-1c9d-4266-bc0f-b61055bddd07`
**Submitted**: 2026-05-06
**Output**: `AgentTasks/aristotle-output/standard-model-anomaly-package-moonshot`

---

## Big-picture goal

Turn the current exact-arithmetic anomaly checks into a complete, reviewable
Lean package for Standard Model anomaly cancellation, and push as far as
possible on the Furey minimal-left-ideal bridge.

This is intentionally a large moonshot job. It has two tracks:

1. A conventional Standard Model anomaly package, independent of Furey.
2. A Furey bridge showing which operator/state data realizes the conventional
   Standard Model multiplet table, or a precise kernel-checked explanation of
   where the candidate bridge fails.

The draft scaffolding is in:

```text
PhysicsSM/Draft/StandardModelAnomalyPackage.lean
```

That file typechecks as draft scaffolding and contains the intended target
statements, with `sorry` placeholders.

---

## Repository context

You are working in the Lean 4 project `PhysicsSM`, pinned to Lean 4.28.0.

Important existing files:

```text
PhysicsSM/StandardModel/AnomalyCancellation.lean
PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean
PhysicsSM/Algebra/Furey/OperatorRepresentations.lean
PhysicsSM/Algebra/Furey/OperatorAlgebra.lean
PhysicsSM/Draft/StandardModelAnomalyPackage.lean
```

Existing trusted facts include:

- The Furey minimal-left-ideal states `omega`, `v1`, ..., `v6`, `nu`.
- The complementary idempotent and candidate complementary states:
  `omega_bar`, `vbar1`, ..., `vbar6`, `nu_bar`.
- Number-operator and electric-charge facts on `J`.
- The complex-linear charge operator `Q_op`.
- The current exact-rational Standard Model anomaly checks in
  `PhysicsSM.StandardModel.AnomalyCancellation`.
- The draft generic anomaly-package definitions in
  `PhysicsSM.Draft.StandardModelAnomalyPackage`.

Project convention:

```text
Q = T3 + Y / 2
```

All Standard Model fermions in the conventional anomaly table are left-handed
Weyl fields. Right-handed physical fields should be represented as their
left-handed charge-conjugate fields.

---

## Track A: Conventional Standard Model anomaly package

Create or complete a trusted module, preferably:

```text
PhysicsSM/StandardModel/AnomalyPackage.lean
```

It should contain the generic framework currently drafted in
`PhysicsSM/Draft/StandardModelAnomalyPackage.lean`:

- `ColorRep`
- `WeakRep`
- `ChiralMultiplet`
- `gravitationalU1Anomaly`
- `u1CubedAnomaly`
- `su2SquaredU1Anomaly`
- `su3SquaredU1Anomaly`
- `su3CubedAnomaly`
- `weakDoubletCount`
- `LocalAnomalyFree`
- `WittenSU2AnomalyFree`
- `standardModelOneGeneration`

Please prove, with no `sorry`:

```lean
theorem standardModelOneGeneration_localAnomalyFree :
    LocalAnomalyFree standardModelOneGeneration

theorem standardModelOneGeneration_wittenAnomalyFree :
    WittenSU2AnomalyFree standardModelOneGeneration

theorem standardModelOneGeneration_anomalyFree :
    LocalAnomalyFree standardModelOneGeneration ∧
      WittenSU2AnomalyFree standardModelOneGeneration
```

If useful, also prove:

```lean
theorem nCopies_localAnomalyFree
theorem threeGenerations_anomalyFree
```

where anomaly coefficients scale by a natural number of identical generations.

Keep comments verbose and convention-heavy. The module should be trusted: no
`sorry`, `admit`, `axiom`, `opaque`, or `unsafe def`.

---

## Track B: Furey bridge

Create a downstream module, preferably:

```text
PhysicsSM/Algebra/Furey/AnomalyBridge.lean
```

This file may import:

```lean
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.Algebra.Furey.MinimalLeftIdeal
import PhysicsSM.Algebra.Furey.OperatorRepresentations
```

Avoid circular imports. Do not move `Q_op` back into
`MinimalLeftIdeal.lean`.

### B1. Jbar state table

Use the existing complementary states:

```lean
omega_bar
vbar1
vbar2
vbar3
vbar4
vbar5
vbar6
nu_bar
```

Define:

```lean
noncomputable def JbarBasisState : Fin 8 -> ComplexOctonion
noncomputable def Jbar : Submodule Complex ComplexOctonion
```

Try to prove:

```lean
theorem JbarBasisState_linearIndependent :
    LinearIndependent Complex JbarBasisState
```

If this is too hard, leave it in a draft file with a detailed proof handoff,
not in trusted code.

### B2. Electric charge on Jbar

The current arithmetic certificate assumes that the complementary table is
charge-reversed. This must be checked, not assumed.

Try to prove the exact eigenvalue statements:

```lean
Q_op omega_bar = (1 : Complex) • omega_bar
Q_op vbar1 = (2 / 3 : Complex) • vbar1
Q_op vbar2 = (2 / 3 : Complex) • vbar2
Q_op vbar3 = (2 / 3 : Complex) • vbar3
Q_op vbar4 = (1 / 3 : Complex) • vbar4
Q_op vbar5 = (1 / 3 : Complex) • vbar5
Q_op vbar6 = (1 / 3 : Complex) • vbar6
Q_op nu_bar = (0 : Complex) • nu_bar
```

Very important: if any of these are false for the existing `Q_op`, do not
weaken or fake them. Instead:

1. Prove the actual eigenvalue equation that holds.
2. Add a comment explaining the convention mismatch.
3. Propose a corrected charge-conjugated operator or corrected state mapping,
   but keep unproved or speculative content in `PhysicsSM/Draft`.

### B3. Weak isospin and hypercharge

We need a formal bridge from electric charge to hypercharge:

```text
Y = 2 * (Q - T3)
```

There are two acceptable levels of success:

1. A basis-diagonal bridge operator `T3_op` with explicit documentation saying
   it is a formal target operator.
2. A genuine Furey-derived weak-isospin operator, if the existing code already
   gives enough infrastructure.

In either case, make the status explicit.

Try to prove eigenvalue statements sufficient to recover the conventional SM
hypercharge table.

### B4. Furey-to-SM multiplet matching

This is the core semantic bridge. Do not prove it by definitional trick.

The conventional table is:

```text
Q_L   : color triplet, weak doublet, Y = 1/3
L_L   : color singlet, weak doublet, Y = -1
u_R^c : color antitriplet, weak singlet, Y = -4/3
d_R^c : color antitriplet, weak singlet, Y = 2/3
e_R^c : color singlet, weak singlet, Y = 2
```

The existing `J` table alone appears not to obviously contain all of these
multiplets with the required left-handed convention. This is the key issue to
audit. Please determine whether the bridge uses:

- `J` only,
- `Jbar` only,
- a selected chiral subset of `J + Jbar`,
- or a different convention for identifying particles and antiparticles.

If a complete match is currently impossible, produce a precise Lean-level
partial theorem and a written handoff explaining the missing representation
or chirality input.

### B5. Final theorem

If the bridge is successful, prove a final theorem like:

```lean
theorem furey_realizes_anomalyFreeStandardModelGeneration :
    FureyRealizesStandardModelOneGeneration ∧
    LocalAnomalyFree standardModelOneGeneration ∧
    WittenSU2AnomalyFree standardModelOneGeneration
```

The exact statement can be adjusted if the definitions demand it, but do not
hide the bridge as mere arithmetic. It should be clear which theorem says:

```text
Furey operator/state data realizes the conventional SM multiplet table.
```

---

## Constraints

- No `sorry` in trusted files.
- No new axioms.
- No `opaque`.
- No `unsafe def`.
- Do not weaken mathematically meaningful statements just to pass.
- Keep proof holes only in `PhysicsSM/Draft`, with detailed handoff comments.
- Use verbose comments and descriptive names.
- Preserve the project convention `Q = T3 + Y / 2`.
- Be careful with nonassociativity. Operator composition is not raw
  octonion multiplication.
- Do not silently reinterpret particle/antiparticle labels.
- Do not import all of Mathlib unless absolutely necessary.

---

## Suggested verification

Run targeted checks:

```bash
lake env lean PhysicsSM/StandardModel/AnomalyPackage.lean
lake env lean PhysicsSM/Algebra/Furey/AnomalyBridge.lean
lake env lean PhysicsSM/Draft/StandardModelAnomalyPackage.lean
```

If a trusted file cannot be completed, leave partial work in draft form and
explain exactly what remains.
