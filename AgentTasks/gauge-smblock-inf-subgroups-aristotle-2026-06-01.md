# Aristotle task: SM block subgroup as infimum of SU5 and Pati-Salam subgroups

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `5d8f3fb1-b9b1-4f87-a2dd-97b5b7329f74`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave6-20260601-project`
**Output**: `AgentTasks/aristotle-output/gauge-smblock-inf-subgroups-20260601`
**Integrated**: 2026-06-01
**Type**: Gauge subgroup API, explicit subgroup intersection

## Goal

Sharpen the integrated GUT-square intersection theorem from a conjunction
subgroup to an actual infimum of two separately named subgroups:

```text
SMBlockUnitsSubgroup = SU5UnitsSubgroup inf PatiSalamUnitsSubgroup
```

This gives the paper a cleaner Lean statement of the Baez-Huerta intersection
picture at the concrete matrix-unit subgroup level.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelBlockSubgroupInf.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelBlockSubgroupIntersection
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `GUTMatrix`
- `IsUnitary`
- `SU5Predicate`
- `PatiSalamPredicate`
- `SMBlockPredicate`
- `SMBlockUnitsSubgroup`
- `SU5PatiSalamUnitsSubgroup`
- `mem_SMBlockUnitsSubgroup`
- `mem_SU5PatiSalamUnitsSubgroup`
- `SMBlockUnitsSubgroup_eq_SU5PatiSalamUnitsSubgroup`
- `smBlock_iff_su5_and_patiSalam`
- `isUnitary_mul`
- `isUnitary_inv`
- `fromBlocks_mul_zero_off_diag`
- `fromBlocks_inv_zero_off_diag`

## Target declarations

Define separate unit-level predicates:

```lean
def SU5UnitPredicate (U : Units GUTMatrix) : Prop :=
  SU5Predicate (U : GUTMatrix)

def PatiSalamUnitPredicate (U : Units GUTMatrix) : Prop :=
  PatiSalamPredicate (U : GUTMatrix)
```

Define the two subgroups:

```lean
def SU5UnitsSubgroup : Subgroup (Units GUTMatrix) := ...

def PatiSalamUnitsSubgroup : Subgroup (Units GUTMatrix) := ...
```

Add membership lemmas:

```lean
@[simp] theorem mem_SU5UnitsSubgroup
    (U : Units GUTMatrix) :
    U in SU5UnitsSubgroup <-> SU5Predicate (U : GUTMatrix) := ...

@[simp] theorem mem_PatiSalamUnitsSubgroup
    (U : Units GUTMatrix) :
    U in PatiSalamUnitsSubgroup <-> PatiSalamPredicate (U : GUTMatrix) := ...
```

Then prove the infimum/intersection statements:

```lean
theorem SU5PatiSalamUnitsSubgroup_eq_inf :
    SU5PatiSalamUnitsSubgroup =
      SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup := ...

theorem SMBlockUnitsSubgroup_eq_inf :
    SMBlockUnitsSubgroup =
      SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup := ...
```

If Unicode infimum notation causes parsing issues in the generated file, use
the accepted Lean equivalent for subgroup infimum.

Add a package:

```lean
structure SMBlockUnitsInfPackage where
  su5_units : Subgroup (Units GUTMatrix)
  pati_salam_units : Subgroup (Units GUTMatrix)
  smBlock_eq_inf :
    SMBlockUnitsSubgroup = su5_units ⊓ pati_salam_units

def smBlockUnitsInfPackage : SMBlockUnitsInfPackage := ...
```

## Claim boundary

This is still a concrete matrix-unit subgroup theorem. It does not prove a
topological Lie subgroup theorem, a smooth quotient theorem, connectedness, or
an isomorphism with an abstract compact Lie group.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change `SMBlockPredicate`, `SU5Predicate`, or `PatiSalamPredicate`.
- Do not weaken the existing intersection theorem.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelBlockSubgroupInf.lean
lake build PhysicsSM.Gauge.StandardModelBlockSubgroupInf
```
