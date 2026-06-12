# Aristotle task: coordinate equivalence from corrected Jbar ideal to wavefunctions

Date: 2026-06-04

## Goal

Create a trusted module:

```text
PhysicsSM/Algebra/Furey/JbarCoordinateEquiv.lean
```

This bridges the corrected octonionic Jbar minimal-left-ideal basis to the
finite coordinate space used by the electroweak operator formalization:

```text
JbarSubmodule  <->  JbarWavefunction = Fin 8 -> Complex
```

## Context

Relevant modules:

- `PhysicsSM.Algebra.Furey.JbarLinearIndependence`
- `PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity`
- `PhysicsSM.Algebra.Furey.T3OpJbar`
- `PhysicsSM.Algebra.Furey.WeakIsospinLadderDerived`

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey
namespace MinimalLeftIdeal
```

The corrected basis and span are already available:

```lean
JbarBasisState' : Fin 8 -> ComplexOctonion
JbarSubmodule : Submodule Complex ComplexOctonion
JbarBasisState'_basis : Basis (Fin 8) Complex JbarSubmodule
```

The wavefunction side uses:

```lean
OperatorElectroweakIdentity.JbarWavefunction
T3OpJbar.JbarBasisState
```

## Target definitions

Define a linear equivalence:

```lean
noncomputable def JbarSubmoduleLinearEquivWavefunction :
    JbarSubmodule ≃ₗ[Complex] OperatorElectroweakIdentity.JbarWavefunction := ...
```

The preferred orientation is:

- `JbarBasisState'_basis` coordinate vector maps to the corresponding standard
  basis vector `T3OpJbar.JbarBasisState s`.
- The inverse sends `T3OpJbar.JbarBasisState s` to the subtype element
  containing `JbarBasisState' s` and its membership proof in `JbarSubmodule`.

## Target theorems

Prove:

```lean
theorem JbarSubmoduleLinearEquivWavefunction_basis
    (s : Fin 8) :
    JbarSubmoduleLinearEquivWavefunction
      ⟨JbarBasisState' s, by
        exact Submodule.subset_span (Set.mem_range_self s)⟩ =
      T3OpJbar.JbarBasisState s

theorem JbarSubmoduleLinearEquivWavefunction_symm_basis
    (s : Fin 8) :
    JbarSubmoduleLinearEquivWavefunction.symm
      (T3OpJbar.JbarBasisState s) =
      ⟨JbarBasisState' s, by
        exact Submodule.subset_span (Set.mem_range_self s)⟩
```

If exact theorem statements need minor namespace or coercion changes, adapt
them while preserving the intended basis-on-basis meaning.

## Package

Add:

```lean
structure JbarCoordinateEquivPackage where
  equiv :
    JbarSubmodule ≃ₗ[Complex] OperatorElectroweakIdentity.JbarWavefunction
  basis_forward : ...
  basis_backward : ...

noncomputable def jbarCoordinateEquivPackage :
    JbarCoordinateEquivPackage
```

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/JbarCoordinateEquiv.lean
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave9-20260604`

Job ID: `9da6d927-8ff5-4dc1-a35b-fb6832272643`

## Result

Status: COMPLETE, integrated 2026-06-04.

Output archive:
`AgentTasks/aristotle-output/9da6d927-output`

Extracted output:
`AgentTasks/aristotle-output/9da6d927-output-extracted/paper-wave9-20260604_aristotle`

Integrated module:

```text
PhysicsSM/Algebra/Furey/JbarCoordinateEquiv.lean
```

Top-level import added to `PhysicsSM.lean`.

Verification run after integration:

```bash
lake env lean PhysicsSM/Algebra/Furey/JbarCoordinateEquiv.lean
```
