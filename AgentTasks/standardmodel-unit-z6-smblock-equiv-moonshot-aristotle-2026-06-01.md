# Aristotle task: unit Z6 quotient equivalence with SM block subgroup

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Moonshot
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `850e7947-64e4-4895-bf53-17dc82a450f7`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave11-20260601-project`
**Output**:
**Integrated**:
**Type**: Standard Model gauge group quotient frontier

## Goal

Upgrade the current unit-level `Z6` quotient scaffold to an explicit
multiplicative equivalence with the concrete Standard Model block subgroup
`SMBlockUnitsSubgroup`, i.e. the algebraic version of:

```text
(U(1) x SU(2) x SU(3)) / Z6 ~= S(U(2) x U(3)).
```

The current trusted chain proves:

- `UnitCoveringTriple` is a group;
- its image quotient is multiplicatively equivalent to the image subgroup;
- explicit six unit-level kernel elements map to identity;
- `SMBlockPredicate` is a subgroup of `Units GUTMatrix`;
- the SM block subgroup is equivalent to the SU5/Pati-Salam intersection;
- an `SMCoveringTriple` maps into `SMBlockPredicate`.

The missing hard direction is the full image theorem: every matrix unit
satisfying `SMBlockPredicate` should come from a unit covering triple modulo
the six central kernel phases.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelUnitZ6SMBlockEquiv.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelCoverageImageSMBlock
import PhysicsSM.Gauge.StandardModelBlockSubgroupMulEquiv
import PhysicsSM.Gauge.StandardModelUnitZ6Kernel
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`.

## Target declarations

Construct a group hom from the existing unit quotient into the concrete block
unit subgroup:

```lean
noncomputable def standardModelUnitCoveringQuotientToSMBlockUnits :
    StandardModelUnitCoveringQuotient ->* SMBlockUnitsSubgroup := ...
```

Prove it is injective using the image quotient equivalence:

```lean
theorem standardModelUnitCoveringQuotientToSMBlockUnits_injective :
    Function.Injective standardModelUnitCoveringQuotientToSMBlockUnits := ...
```

Then prove the hard image theorem:

```lean
theorem standardModelUnitCoveringQuotientToSMBlockUnits_surjective :
    Function.Surjective standardModelUnitCoveringQuotientToSMBlockUnits := ...
```

If successful, package the equivalence:

```lean
noncomputable def standardModelUnitZ6QuotientMulEquivSMBlockUnits :
    MulEquiv StandardModelUnitCoveringQuotient SMBlockUnitsSubgroup := ...

structure StandardModelUnitZ6SMBlockEquivPackage where
  quotient_equiv_sm_block :
    MulEquiv StandardModelUnitCoveringQuotient SMBlockUnitsSubgroup
  quotient_equiv_su5_pati_salam_inf :
    MulEquiv StandardModelUnitCoveringQuotient
      (SU5UnitsSubgroup inf PatiSalamUnitsSubgroup)
```

Use Lean's exact infimum subtype notation if needed.

## Mathematical route

Given an SM block element with blocks `A : U(2)` and `B : U(3)` satisfying
`det A * det B = 1`, choose a unit phase `alpha` with:

```text
alpha ^ 6 = det A
```

Then set:

```text
g = alpha ^ (-3) * A
h = alpha ^ 2 * B
```

and prove `det g = 1`, `det h = 1`, so that `(alpha, g, h)` is a covering
triple whose image is the original block. The hard Lean step is likely the
existence of sixth roots in `Complex` together with unit/norm control.

If the current `UnitCoveringTriple` is too broad or too weak, introduce a
trusted `SMUnitCoveringTriple` refinement with unitary and determinant-one
fields, plus a quotient by image equivalence, and prove the equivalence at that
level.

## Fallback

If full surjectivity is too hard, prioritize a trusted prefix:

- the hom from quotient to `SMBlockUnitsSubgroup`;
- injectivity;
- a sixth-root existence lemma for unit complex numbers;
- construction of a preimage for a block element assuming an explicit sixth
  root hypothesis;
- a draft handoff file for the unconditional surjectivity theorem.

Draft `sorry` is allowed only in:

```text
PhysicsSM/Draft/StandardModelUnitZ6SMBlockEquivHandoff.lean
```

No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted files.

## Claim boundary

This is still a purely algebraic group equivalence. It does not ask for a
topological quotient, a smooth Lie group quotient, compactness, or physical
gauge-field dynamics.

## Verification

Run:

```bash
lake build PhysicsSM.Gauge.StandardModelUnitZ6SMBlockEquiv
```
