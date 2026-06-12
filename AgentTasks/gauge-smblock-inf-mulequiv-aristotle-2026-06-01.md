# Aristotle task: SM block subgroup multiplicative equivalence with infimum subgroup

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `a33248c9-74cb-44a9-b081-dd74ac166daa`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave7-20260601-project`
**Output**: `AgentTasks/aristotle-output/gauge-smblock-inf-mulequiv-20260601`
**Integrated**: 2026-06-01
**Type**: Gauge subgroup API, intersection equivalence

## Goal

Use the newly integrated subgroup equality

```lean
SMBlockUnitsSubgroup = SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup
```

to build an explicit multiplicative equivalence between the two subgroup
types. This is a citation-friendly form of the concrete Baez-Huerta
intersection theorem.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelBlockSubgroupMulEquiv.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelBlockSubgroupInf
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `SMBlockUnitsSubgroup`
- `SU5PatiSalamUnitsSubgroup`
- `SU5UnitsSubgroup`
- `PatiSalamUnitsSubgroup`
- `SMBlockUnitsSubgroup_eq_SU5PatiSalamUnitsSubgroup`
- `SU5PatiSalamUnitsSubgroup_eq_inf`
- `SMBlockUnitsSubgroup_eq_inf`
- membership lemmas for the subgroups

## Target declarations

Build multiplicative equivalences:

```lean
noncomputable def smBlockUnitsMulEquivSU5PatiSalam :
    MulEquiv SMBlockUnitsSubgroup SU5PatiSalamUnitsSubgroup := ...

noncomputable def smBlockUnitsMulEquivInf :
    MulEquiv SMBlockUnitsSubgroup
      (SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup) := ...
```

Prefer `MulEquiv.subgroupCongr` or the local mathlib equivalent if available.

Add coercion lemmas:

```lean
@[simp] theorem smBlockUnitsMulEquivSU5PatiSalam_apply_val
    (U : SMBlockUnitsSubgroup) :
    (smBlockUnitsMulEquivSU5PatiSalam U : Units GUTMatrix) =
      (U : Units GUTMatrix) := ...

@[simp] theorem smBlockUnitsMulEquivInf_apply_val
    (U : SMBlockUnitsSubgroup) :
    (smBlockUnitsMulEquivInf U : Units GUTMatrix) =
      (U : Units GUTMatrix) := ...
```

Add a package:

```lean
structure SMBlockUnitsMulEquivPackage where
  equiv_intersection :
    MulEquiv SMBlockUnitsSubgroup SU5PatiSalamUnitsSubgroup
  equiv_inf :
    MulEquiv SMBlockUnitsSubgroup
      (SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup)
  equiv_inf_val :
    forall U : SMBlockUnitsSubgroup,
      (equiv_inf U : Units GUTMatrix) = (U : Units GUTMatrix)

noncomputable def smBlockUnitsMulEquivPackage :
    SMBlockUnitsMulEquivPackage := ...
```

## Claim boundary

This is a concrete multiplicative equivalence of subgroups of matrix units. It
does not prove a topological Lie subgroup theorem, a smooth quotient theorem,
connectedness, or an abstract compact Lie group isomorphism.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change any subgroup predicates or subgroup definitions.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelBlockSubgroupMulEquiv.lean
lake build PhysicsSM.Gauge.StandardModelBlockSubgroupMulEquiv
```
