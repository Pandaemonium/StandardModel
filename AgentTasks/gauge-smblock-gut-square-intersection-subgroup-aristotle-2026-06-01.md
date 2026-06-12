# Aristotle task: SM block units equal the GUT-square intersection subgroup

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `e149b803-26f2-4f4a-9433-af733c0a0371`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave5-20260601-project`
**Output**: `AgentTasks/aristotle-output/gauge-smblock-intersection-20260601`
**Integrated**: 2026-06-01
**Type**: Gauge subgroup API, GUT-square intersection

## Goal

Promote the newly integrated membership theorem

```lean
U in SMBlockUnitsSubgroup <-> SU5Predicate (U : GUTMatrix) /\
  PatiSalamPredicate (U : GUTMatrix)
```

to an actual subgroup equality. Define the subgroup of matrix units satisfying
both GUT-square predicates and prove it is equal to `SMBlockUnitsSubgroup`.

This gives the paper a clean formal statement of the Baez-Huerta intersection
picture at the concrete matrix-unit subgroup level.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelBlockSubgroupIntersection.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelBlockSubgroupGUTSquare
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `GUTMatrix`
- `SMBlockPredicate`
- `SU5Predicate`
- `PatiSalamPredicate`
- `smBlock_iff_su5_and_patiSalam`
- `SMBlockUnitsSubgroup`
- `mem_SMBlockUnitsSubgroup`
- `mem_SMBlockUnitsSubgroup_iff_su5_and_patiSalam`
- `SMBlockPredicate_one`
- `SMBlockPredicate_mul`
- `SMBlockPredicate_unit_inv`

## Target declarations

Define the unit-level intersection predicate:

```lean
def SU5PatiSalamUnitPredicate (U : Units GUTMatrix) : Prop :=
  SU5Predicate (U : GUTMatrix) /\ PatiSalamPredicate (U : GUTMatrix)
```

Define the subgroup:

```lean
def SU5PatiSalamUnitsSubgroup : Subgroup (Units GUTMatrix) := ...
```

Suggestion: for closure, convert the conjunction to `SMBlockPredicate` using
`smBlock_iff_su5_and_patiSalam`, use the already proved `SMBlockPredicate`
closure theorem, and convert back.

Add the membership theorem:

```lean
theorem mem_SU5PatiSalamUnitsSubgroup
    (U : Units GUTMatrix) :
    U in SU5PatiSalamUnitsSubgroup <->
      SU5Predicate (U : GUTMatrix) /\
        PatiSalamPredicate (U : GUTMatrix) := ...
```

Prove subgroup equality:

```lean
theorem SMBlockUnitsSubgroup_eq_SU5PatiSalamUnitsSubgroup :
    SMBlockUnitsSubgroup = SU5PatiSalamUnitsSubgroup := ...
```

Add a bundled package:

```lean
structure SMBlockUnitsIntersectionPackage where
  intersection_subgroup : Subgroup (Units GUTMatrix)
  mem_iff :
    forall U : Units GUTMatrix,
      U in intersection_subgroup <->
        SU5Predicate (U : GUTMatrix) /\
          PatiSalamPredicate (U : GUTMatrix)
  smBlock_eq_intersection :
    SMBlockUnitsSubgroup = intersection_subgroup

def smBlockUnitsIntersectionPackage :
    SMBlockUnitsIntersectionPackage := ...
```

Use Lean's actual membership and iff syntax in the file.

## Claim boundary

This is a concrete matrix-unit subgroup theorem. It does not prove a
topological Lie subgroup theorem, a smooth quotient theorem, or an isomorphism
with the abstract Standard Model gauge group.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change `SMBlockPredicate`, `SU5Predicate`, or `PatiSalamPredicate`.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelBlockSubgroupIntersection.lean
lake build PhysicsSM.Gauge.StandardModelBlockSubgroupIntersection
```
