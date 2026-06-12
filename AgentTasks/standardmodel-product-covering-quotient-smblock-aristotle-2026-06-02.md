# Aristotle task: quotient of true product cover equals SM block subgroup

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Paper-critical moonshot
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `9fee849f-c960-44c0-b4aa-502261bcab44`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave5-20260602`
**Output**:
**Integrated**:
**Type**: Standard Model quotient theorem

## Goal

Prove the algebraic quotient theorem for the corrected Standard Model product
covering domain:

```text
(U(1) x SU(2) x SU(3)) / Z6 ~= S(U(2) x U(3)).
```

This should use:

- `StandardModelProductCoveringTriple`, if available from the companion task;
- `StandardModelCoveringMapSurjective`, which proves every `SMBlockPredicate`
  element is covered by an `SMCoveringTriple`;
- `StandardModelUnitZ6Kernel`, which packages the explicit six central phases.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelProductCoveringQuotientSMBlock.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelProductCoveringTriple
import PhysicsSM.Gauge.StandardModelCoveringMapSurjective
import PhysicsSM.Gauge.StandardModelBlockSubgroupMulEquiv
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`.

## Target declarations

Define image equivalence on the corrected product covering domain:

```lean
def SMProductCoveringTriple.ImageEquivalent
    (x y : SMProductCoveringTriple) : Prop :=
  smProductCoveringTripleToSMBlockUnits x =
    smProductCoveringTripleToSMBlockUnits y

instance SMProductCoveringTriple.imageSetoid :
    Setoid SMProductCoveringTriple := ...

abbrev SMProductCoveringQuotient :=
  Quotient SMProductCoveringTriple.imageSetoid
```

Prove this quotient carries a group structure:

```lean
noncomputable instance : Group SMProductCoveringQuotient := ...
```

Descend the image map:

```lean
noncomputable def smProductCoveringQuotientToSMBlockUnits :
    SMProductCoveringQuotient ->* SMBlockUnitsSubgroup := ...
```

Prove injectivity by quotient construction:

```lean
theorem smProductCoveringQuotientToSMBlockUnits_injective :
    Function.Injective smProductCoveringQuotientToSMBlockUnits := ...
```

Prove surjectivity. This is the hard part. The key math is: given
`A in U(2)` and `B in U(3)` with `det A * det B = 1`, choose a unit complex
number `alpha` satisfying:

```text
alpha ^ 6 = det A
```

Then set:

```text
g = alpha^(-3) A
h = alpha^2 B
```

so `det g = 1`, `det h = 1`, and the covering image is `(A, B)`.

Target theorem:

```lean
theorem smProductCoveringQuotientToSMBlockUnits_surjective :
    Function.Surjective smProductCoveringQuotientToSMBlockUnits := ...
```

Then package the equivalence:

```lean
noncomputable def smProductCoveringQuotientMulEquivSMBlockUnits :
    MulEquiv SMProductCoveringQuotient SMBlockUnitsSubgroup := ...

structure StandardModelProductCoveringQuotientSMBlockPackage where
  quotient_equiv_sm_block :
    MulEquiv SMProductCoveringQuotient SMBlockUnitsSubgroup
```

## Fallback

This is a hard theorem because of sixth roots of unit complex numbers. If the
full theorem is too difficult, return the strongest trusted prefix:

- image setoid;
- quotient group;
- quotient-to-image subgroup equivalence;
- sixth-root existence lemma for unit complex numbers;
- construction of a preimage assuming an explicit sixth root;
- draft handoff for unconditional surjectivity.

Draft `sorry` is allowed only in:

```text
PhysicsSM/Draft/StandardModelProductCoveringQuotientSMBlockHandoff.lean
```

No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted files.

## Claim boundary

This is an algebraic quotient theorem. It does not prove a topological
quotient, smooth Lie group isomorphism, compactness, or physical dynamics.

## Verification

Run:

```bash
lake build PhysicsSM.Gauge.StandardModelProductCoveringQuotientSMBlock
```
