# Aristotle task: SMBlockPredicate as a units subgroup

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `4ca3b2f6-cbcf-4266-80b0-6ad9f1861d76`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave3-20260601-project`
**Output**: `AgentTasks/aristotle-output/gauge-smblock-units-subgroup-20260601`
**Integrated**: 2026-06-01
**Type**: Gauge group structure, subgroup packaging

## Goal

Build the next algebraic layer on top of
`PhysicsSM.Gauge.StandardModelGroupStructure`: package matrices satisfying
`SMBlockPredicate` as a subgroup of the unit group of the matrix ring.

This advances the paper's claim that the formalization has an actual algebraic
subgroup scaffold for `S(U(2) x U(3))`, while still avoiding any topological
Lie-group or quotient-group claim.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelBlockSubgroup.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelGroupStructure
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

From `StandardModelGroupStructure`:

- `GUTMatrix`
- `SMBlockPredicate_one`
- `SMBlockPredicate_mul`
- `SMBlockPredicate_inv`

You will likely need helper lemmas connecting the inverse of a unit with the
matrix inverse:

```lean
theorem SMBlockPredicate_unit_inv
    {U : Units GUTMatrix}
    (hU : SMBlockPredicate (U : GUTMatrix)) :
    SMBlockPredicate ((U⁻¹ : Units GUTMatrix) : GUTMatrix) := ...
```

Use existing Mathlib lemmas for `Units` coercions if available. If necessary,
prove a small matrix inverse uniqueness lemma from `U.val * (U⁻¹).val = 1` and
`(U⁻¹).val * U.val = 1`.

## Target declarations

Define a predicate on units:

```lean
def SMBlockUnitPredicate (U : Units GUTMatrix) : Prop :=
  SMBlockPredicate (U : GUTMatrix)
```

Prove closure:

```lean
theorem SMBlockUnitPredicate_one :
    SMBlockUnitPredicate (1 : Units GUTMatrix) := ...

theorem SMBlockUnitPredicate_mul
    {U V : Units GUTMatrix}
    (hU : SMBlockUnitPredicate U)
    (hV : SMBlockUnitPredicate V) :
    SMBlockUnitPredicate (U * V) := ...

theorem SMBlockUnitPredicate_inv
    {U : Units GUTMatrix}
    (hU : SMBlockUnitPredicate U) :
    SMBlockUnitPredicate U⁻¹ := ...
```

Package the subgroup:

```lean
def SMBlockUnitsSubgroup : Subgroup (Units GUTMatrix) where
  carrier := {U | SMBlockUnitPredicate U}
  one_mem' := ...
  mul_mem' := ...
  inv_mem' := ...
```

Add membership simp lemmas:

```lean
theorem mem_SMBlockUnitsSubgroup
    (U : Units GUTMatrix) :
    U ∈ SMBlockUnitsSubgroup ↔ SMBlockPredicate (U : GUTMatrix) := ...
```

Package:

```lean
structure SMBlockUnitsSubgroupPackage where
  subgroup : Subgroup (Units GUTMatrix)
  mem_iff :
    forall U : Units GUTMatrix,
      U ∈ subgroup ↔ SMBlockPredicate (U : GUTMatrix)

theorem smBlockUnitsSubgroupPackage :
    SMBlockUnitsSubgroupPackage := ...
```

## Claim boundary

This proves subgroup structure for the concrete matrix predicate inside
`Units GUTMatrix`. It does not prove a Lie-group isomorphism, quotient by the
Z6 kernel, smooth/topological structure, or DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not weaken `SMBlockPredicate`.
- Keep all proofs inside the requested namespace.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelBlockSubgroup.lean
lake build PhysicsSM.Gauge.StandardModelBlockSubgroup
```
