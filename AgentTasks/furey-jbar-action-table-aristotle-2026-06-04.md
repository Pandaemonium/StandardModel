# Aristotle task: corrected Jbar ladder action table

Date: 2026-06-04

## Goal

Create a trusted module:

```text
PhysicsSM/Algebra/Furey/JbarActionTable.lean
```

This is a prerequisite for deriving the weak-isospin ladder operators from the
Furey octonionic operator algebra rather than treating them as an explicit
matrix table on `JbarWavefunction`.

## Context

Relevant modules:

- `PhysicsSM.Algebra.Furey.LadderOperators`
- `PhysicsSM.Algebra.Furey.MinimalLeftIdeal`
- `PhysicsSM.Algebra.Furey.JbarLinearIndependence`
- `PhysicsSM.Algebra.Furey.WeakIsospinLadder`
- `PhysicsSM.Algebra.Furey.WeakIsospinLadderDerived`

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey
namespace MinimalLeftIdeal
```

Important convention issue:

- The original `AnomalyBridge.JbarBasisState` used annihilation operators on
  `omega_bar` and is degenerate.
- The corrected basis is `JbarBasisState'` in
  `PhysicsSM.Algebra.Furey.JbarLinearIndependence`.
- Use the corrected basis only.

## Target

Prove a complete action table for the existing ladder operators on
`JbarBasisState'`.

At minimum, prove named lemmas of the following shape for each `k : Fin 3` and
each `s : Fin 8`, specializing to zero or another basis vector as appropriate:

```lean
theorem alpha1_mul_JbarBasisState'_zero_or_basis (s : Fin 8) :
    alpha1 * JbarBasisState' s = ...

theorem alpha1_dag_mul_JbarBasisState'_zero_or_basis (s : Fin 8) :
    alpha1_dag * JbarBasisState' s = ...
```

Repeat for `alpha2`, `alpha2_dag`, `alpha3`, and `alpha3_dag`.

If a uniformly indexed theorem is feasible, prefer a small function describing
the occupancy-bit transition:

```lean
def jbarAlphaAction (dagger : Bool) (k : Fin 3) (s : Fin 8) :
    Option (Complex × Fin 8) := ...
```

and prove:

```lean
theorem alpha_mul_JbarBasisState'_eq_action
    (k : Fin 3) (s : Fin 8) :
    ...
```

but do not spend the entire budget on abstraction. Concrete eight-case tables
are acceptable and useful.

## Package

Add a package record collecting the table lemmas, or at least the most useful
ones for constructing creation and annihilation operators on the corrected
Jbar basis.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/JbarActionTable.lean
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave9-20260604`

Job ID: `4bc7053b-c3e3-4e1f-ae44-fffebbe649a6`
