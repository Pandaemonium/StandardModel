# Aristotle task: Krasnov centralizer theorem

Date: 2026-06-04

## Goal

Advance the Krasnov complex-structure track from coordinate/Hermitian
bookkeeping toward a centralizer theorem.

Target module:

```text
PhysicsSM/Spinor/KrasnovCentralizerUnitary.lean
```

## Context

Relevant modules:

- `PhysicsSM.Spinor.OctonionicQubit`
- `PhysicsSM.Spinor.KrasnovComplexStructure`
- `PhysicsSM.Spinor.KrasnovComplexModule`
- `PhysicsSM.Spinor.KrasnovComplexModuleInstance`
- `PhysicsSM.Spinor.KrasnovComplexCentralizer`
- `PhysicsSM.Spinor.KrasnovHermitianSesquilinear`
- `PhysicsSM.Spinor.KrasnovQubitCoordinateFlattening`

Existing facts include:

- `rightMulE111 (rightMulE111 q) = -q`
- the complex module instance on `OctonionicQubit`
- coordinate flattening to complex coordinates,
- Hermitian preservation for the right-multiplication complex structure.

## Preferred outcome

Prove a clean centralizer theorem for real-linear maps:

```lean
theorem realLinearMap_commutes_rightMulE111_iff_complexLinear
    (T : OctonionicQubit ->_R[Real] OctonionicQubit) :
    (forall q, T (rightMulE111 q) = rightMulE111 (T q)) <->
      IsComplexLinearForKrasnovStructure T
```

Use whatever predicate or structure already exists in
`KrasnovComplexCentralizer`. If no predicate exists, define a small local one.

## Stretch target

If the centralizer theorem is already present or easy, add the unitary version:
maps preserving the Krasnov Hermitian form and commuting with `rightMulE111`
are exactly the complex-unitary endomorphisms of the flattened complex vector
space.

## Fallback

If the unitary theorem is too large, prove the centralizer equivalence for the
existing coordinate flattening map and bundle it with the Hermitian preservation
facts already proved.

## Verification

Run:

```bash
lake env lean PhysicsSM/Spinor/KrasnovCentralizerUnitary.lean
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave8-20260604`

Job ID: `74a6e260-864e-49f3-8e8f-2853e37b6ac4`
