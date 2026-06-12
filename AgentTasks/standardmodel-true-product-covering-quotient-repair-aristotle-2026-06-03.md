# Aristotle task: repair the true product-covering quotient theorem

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Paper-critical semantic repair
**Prepared**: 2026-06-03
**Submitted**: 2026-06-03
**Job ID**: `a2b854c5-e935-41f2-8bf3-e82fd8bf7dc1`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave7-20260603`
**Output**:
**Type**: Standard Model quotient theorem, corrected domain

## Why this task matters

The current file
`PhysicsSM/Gauge/StandardModelProductCoveringQuotientSMBlock.lean` proves an
algebraic quotient theorem, but internally it defines

```lean
abbrev SMProductCoveringTriple := SMCoveringTriple
```

This is not the true product-covering domain. The true domain is already
defined in `PhysicsSM/Gauge/StandardModelProductCoveringTriple.lean` as the
structure `SMProductCoveringTriple`, with components:

- a unit-norm phase in `U(1)`,
- an individually determinant-one unitary `SU(2)` matrix,
- an individually determinant-one unitary `SU(3)` matrix.

The paper-level theorem must use this true restricted domain. Do not treat the
existing alias as semantically correct.

## Goal

Create a trusted corrected theorem module:

```text
PhysicsSM/Gauge/StandardModelProductCoveringTrueQuotientSMBlock.lean
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelProductCoveringTriple
import PhysicsSM.Gauge.StandardModelCoveringMapSurjective
import PhysicsSM.Gauge.StandardModelBlockSubgroupMulEquiv
```

Do not import `StandardModelProductCoveringQuotientSMBlock` unless you have to,
because that module uses the misleading alias.

## Required theorem surface

Use fresh names with `TrueProduct` or `trueProduct` in the declaration names,
so there is no collision with the older quotient module.

Define the map from the true product domain to the block subgroup:

```lean
noncomputable def smTrueProductCoveringTripleToSMBlockUnits
    (x : SMProductCoveringTriple) : SMBlockUnitsSubgroup
```

This should use `x.toSMCoveringTriple.image` and
`SMProductCoveringTriple.image_satisfiesSMBlock x`.

Define image equivalence:

```lean
def SMProductCoveringTriple.TrueImageEquivalent
    (x y : SMProductCoveringTriple) : Prop :=
  smTrueProductCoveringTripleToSMBlockUnits x =
    smTrueProductCoveringTripleToSMBlockUnits y

instance SMProductCoveringTriple.trueImageSetoid :
    Setoid SMProductCoveringTriple

abbrev SMTrueProductCoveringQuotient :=
  Quotient SMProductCoveringTriple.trueImageSetoid
```

Use the existing `Group SMProductCoveringTriple` instance from
`StandardModelProductCoveringTriple.lean` to define:

```lean
noncomputable instance : Group SMTrueProductCoveringQuotient
```

Descend the map:

```lean
noncomputable def smTrueProductCoveringQuotientToSMBlockUnits :
    SMTrueProductCoveringQuotient ->* SMBlockUnitsSubgroup
```

Prove:

```lean
theorem smTrueProductCoveringQuotientToSMBlockUnits_injective :
    Function.Injective smTrueProductCoveringQuotientToSMBlockUnits

theorem smTrueProductCoveringQuotientToSMBlockUnits_surjective :
    Function.Surjective smTrueProductCoveringQuotientToSMBlockUnits
```

Then package:

```lean
noncomputable def smTrueProductCoveringQuotientMulEquivSMBlockUnits :
    MulEquiv SMTrueProductCoveringQuotient SMBlockUnitsSubgroup

structure StandardModelTrueProductCoveringQuotientSMBlockPackage where
  quotient_equiv_sm_block :
    MulEquiv SMTrueProductCoveringQuotient SMBlockUnitsSubgroup

noncomputable def standardModelTrueProductCoveringQuotientSMBlockPackage :
    StandardModelTrueProductCoveringQuotientSMBlockPackage
```

## Main proof idea for surjectivity

Given an element represented as `(A, B)` with `A` unitary, `B` unitary, and
`det A * det B = 1`, choose `alpha` with:

```text
|alpha| = 1
alpha^6 = det A
```

Then set:

```text
g = alpha^(-3) * A
h = alpha^2 * B
```

For the true product domain, prove the separate determinant-one facts:

```text
det g = alpha^(-6) * det A = 1
det h = alpha^6 * det B = det A * det B = 1
```

The existing quotient module has useful helper lemmas:

- sixth-root existence for unit complex numbers,
- determinant norm of a unitary matrix,
- scalar multiplication preserves unitarity.

You may copy the mathematics clean-room into the new module, but avoid relying
on the old misleading domain alias.

## Fallback

If full surjectivity is too hard, return the strongest trusted prefix:

- map to `SMBlockUnitsSubgroup`,
- image setoid,
- quotient group,
- descended hom,
- injectivity,
- preimage construction assuming an explicit sixth root and determinant lemmas.

Put any unresolved proof handoff only in:

```text
PhysicsSM/Draft/StandardModelProductCoveringTrueQuotientHandoff.lean
```

No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted files.

## Claim boundary

This is an algebraic quotient theorem. It does not prove a topological quotient,
smooth Lie group isomorphism, compactness, connectedness, or physical dynamics.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelProductCoveringTrueQuotientSMBlock.lean
lake build PhysicsSM.Gauge.StandardModelProductCoveringTrueQuotientSMBlock
```
