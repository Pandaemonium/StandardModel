# Aristotle task: counterexample to complement-complement closure into h3(C)

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High semantic audit
**Prepared**: 2026-06-03
**Submitted**: 2026-06-03
**Job ID**: `7e92a6f0-b20e-4cb3-abd8-a15d99e2b31d`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave7-20260603`
**Output**:
**Type**: DVT decomposition, negative theorem / convention audit

## Why this task matters

`ComplementJordanModule.lean` proves the useful positive theorem:

```lean
InStandardB a -> InComplementOfB X ->
  InComplementOfB (jordanProduct a X)
```

It explicitly does not prove the tempting stronger claim:

```text
complement o complement subset h3(C)
```

That stronger claim appears likely to be false for the current coordinate
complement. We should formalize a small trusted counterexample rather than
letting later paper planning accidentally rely on it.

## Goal

Create a trusted module:

```text
PhysicsSM/Algebra/Jordan/ComplementJordanProductCounterexample.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.ComplementJordanModule
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

## Target declarations

Define two explicit complement elements. The suggested example is:

```text
X has z = e001 and all other coordinates zero.
Y has y = e010 and all other coordinates zero.
```

In the Jordan product formula, the `x` coordinate contains:

```text
(1/2) * (conj X.z * conj Y.y)
```

This should be a nonzero multiple of a complement basis vector, not an element
of the chosen complex line. Therefore `X o Y` is not in `InStandardB`.

Targets:

```lean
def complementCounterexampleX : H3O
def complementCounterexampleY : H3O

theorem complementCounterexampleX_mem :
    InComplementOfB complementCounterexampleX

theorem complementCounterexampleY_mem :
    InComplementOfB complementCounterexampleY

theorem complementCounterexample_product_not_standardB :
    not (InStandardB
      (jordanProduct complementCounterexampleX complementCounterexampleY))

theorem not_forall_complement_complement_product_standardB :
    not (forall X Y : H3O,
      InComplementOfB X -> InComplementOfB Y ->
        InStandardB (jordanProduct X Y))
```

If the suggested basis choices hit a sign or coordinate convention snag, find
another explicit pair of complement basis elements whose product has a nonzero
`c1` through `c6` coordinate in one off-diagonal entry.

## Optional positive replacement

If easy, also prove a conservative projection theorem:

```lean
theorem complement_product_decomposes
    (X Y : H3O) :
    jordanProduct X Y =
      toH3CPart (jordanProduct X Y) +
      toComplementPart (jordanProduct X Y)
```

This is just `decomp_sum`, but it gives the paper a clean way to say that the
failed closure still has a canonical standard/complement decomposition.

## Claim boundary

This file should not claim anything about the full Dubois-Violette-Todorov
group theorem. It only records a coordinate-level negative result for the
project's chosen `InComplementOfB` predicate and octonion convention.

No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted files.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/ComplementJordanProductCounterexample.lean
lake build PhysicsSM.Algebra.Jordan.ComplementJordanProductCounterexample
```
