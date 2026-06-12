# Aristotle task: quunit/qubit/qutrit representation and Z6 triviality

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Ambitious
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `07fbbf77-d73c-4295-a973-17b52ad22df5`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave11-20260601-project`
**Output**:
**Integrated**:
**Type**: Baez quunit/qubit/qutrit representation bridge

## Goal

Upgrade the current quunit/qubit/qutrit dictionary from type aliases and block
predicate equivalences to an actual representation-level theorem: the central
`Z6` kernel acts trivially on the qubit-plus-qutrit block representation.

The current trusted module `QunitQubitQutritDictionary` defines:

- `Qunit := Fin 1 -> Complex`;
- `Qubit := Fin 2 -> Complex`;
- `Qutrit := Fin 3 -> Complex`;
- `QubitPlusQutrit := (Fin 2 Sum Fin 3) -> Complex`;
- the split equivalence `QubitPlusQutrit ~= Qubit x Qutrit`;
- the block predicate bridge for `S(U(2) x U(3))`.

The next paper-useful step is to formalize the action itself and show why the
six central phases are invisible on the combined block representation.

## Requested file

Create:

```text
PhysicsSM/Gauge/QunitQubitQutritRepresentation.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.QunitQubitQutritDictionary
import PhysicsSM.Gauge.StandardModelUnitZ6Kernel
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.QunitQubitQutritDictionary
```

Do not edit `PhysicsSM.lean`.

## Target declarations

Define the action of a unit covering triple on the qubit-plus-qutrit space:

```lean
noncomputable def UnitCoveringTriple.actQubitPlusQutrit
    (x : UnitCoveringTriple) :
    QubitPlusQutrit -> QubitPlusQutrit := ...
```

The intended action is block diagonal through `x.image`:

```text
left/qubit component:  x.image.1.val.mulVec
right/qutrit component: x.image.2.val.mulVec
```

Prove:

```lean
theorem UnitCoveringTriple.actQubitPlusQutrit_one :
    (1 : UnitCoveringTriple).actQubitPlusQutrit = id := ...

theorem UnitCoveringTriple.actQubitPlusQutrit_mul
    (x y : UnitCoveringTriple) :
    (x * y).actQubitPlusQutrit =
      x.actQubitPlusQutrit ∘ y.actQubitPlusQutrit := ...
```

Package it as a monoid representation:

```lean
noncomputable def unitCoveringTripleQubitPlusQutritRepresentation :
    UnitCoveringTriple ->* (QubitPlusQutrit -> QubitPlusQutrit) := ...
```

Use an appropriate function monoid if Lean needs `Function.End`.

Then prove central kernel triviality:

```lean
theorem UnitCoveringKernelElt.actQubitPlusQutrit_eq_id
    (k : UnitCoveringKernelElt) :
    k.toUnitCoveringTriple.actQubitPlusQutrit = id := ...

theorem sixUnitCoveringKernelElts_actQubitPlusQutrit_eq_id
    (i : Fin 6) :
    (sixUnitCoveringKernelElts i).toUnitCoveringTriple.actQubitPlusQutrit =
      id := ...
```

If possible, show the action descends to the existing quotient:

```lean
noncomputable def standardModelUnitCoveringQuotientRepresentation :
    StandardModelUnitCoveringQuotient ->*
      (QubitPlusQutrit -> QubitPlusQutrit) := ...
```

## Fallback

If the quotient representation is too hard, prioritize:

- the block action on `QubitPlusQutrit`;
- one and multiplication laws;
- kernel-element triviality;
- a package collecting these facts.

Draft `sorry` is allowed only in:

```text
PhysicsSM/Draft/QunitQubitQutritRepresentationHandoff.lean
```

No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted files.

## Claim boundary

This is a finite-dimensional linear representation theorem for the algebraic
covering scaffold. It does not claim that the Standard Model is quantum
computing, nor does it prove dynamics or Hilbert-space physics.

## Verification

Run:

```bash
lake build PhysicsSM.Gauge.QunitQubitQutritRepresentation
```
