# Aristotle task: SM block units subgroup and GUT-square characterization

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `3c5cb8c2-9a90-44c4-868e-5ec8f51df0ad`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave4-20260601-project`
**Output**: `AgentTasks/aristotle-output/gauge-smblock-units-gut-square-20260601`
**Integrated**: 2026-06-01
**Type**: Gauge subgroup API, GUT-square bridge

## Goal

Connect the new subgroup package for `SMBlockPredicate` on `Units GUTMatrix`
with the existing GUT-square theorem
`SMBlockPredicate M <-> SU5Predicate M /\ PatiSalamPredicate M`.

This gives the paper a citation-friendly theorem saying that membership in the
matrix-unit subgroup is exactly the intersection of the SU(5)-style and
Pati-Salam-style block predicates on the underlying matrix.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelBlockSubgroupGUTSquare.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelBlockSubgroup
import PhysicsSM.Gauge.GUTSquare
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

From `StandardModelBlockSubgroup`:

- `GUTMatrix`
- `SMBlockPredicate`
- `SMBlockUnitsSubgroup`
- `mem_SMBlockUnitsSubgroup`
- `SMBlockUnitsSubgroupPackage`

From `GUTSquare`:

- `SU5Predicate`
- `PatiSalamPredicate`
- `smBlock_iff_su5_and_patiSalam`

## Target declarations

Prove the unit-subgroup membership characterization:

```lean
theorem mem_SMBlockUnitsSubgroup_iff_su5_and_patiSalam
    (U : Units GUTMatrix) :
    U in SMBlockUnitsSubgroup <->
      SU5Predicate (U : GUTMatrix) /\
        PatiSalamPredicate (U : GUTMatrix) := ...
```

Use Lean's actual membership and iff syntax in the file.

Add convenient projection theorems:

```lean
theorem mem_SMBlockUnitsSubgroup_su5
    {U : Units GUTMatrix}
    (hU : U in SMBlockUnitsSubgroup) :
    SU5Predicate (U : GUTMatrix) := ...

theorem mem_SMBlockUnitsSubgroup_patiSalam
    {U : Units GUTMatrix}
    (hU : U in SMBlockUnitsSubgroup) :
    PatiSalamPredicate (U : GUTMatrix) := ...
```

Package the result:

```lean
structure SMBlockUnitsGUTSquarePackage where
  subgroup_package : SMBlockUnitsSubgroupPackage
  mem_iff_gut_square :
    forall U : Units GUTMatrix,
      U in SMBlockUnitsSubgroup <->
        SU5Predicate (U : GUTMatrix) /\
          PatiSalamPredicate (U : GUTMatrix)

def smBlockUnitsGUTSquarePackage :
    SMBlockUnitsGUTSquarePackage := ...
```

Again, use Lean's actual notation in the file.

## Claim boundary

This is only a predicate-intersection theorem for concrete matrix units. It
does not prove a Lie-group theorem, a quotient theorem, or a DVT stabilizer
intersection theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the definitions of `SMBlockPredicate`, `SU5Predicate`, or
  `PatiSalamPredicate`.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelBlockSubgroupGUTSquare.lean
lake build PhysicsSM.Gauge.StandardModelBlockSubgroupGUTSquare
```
