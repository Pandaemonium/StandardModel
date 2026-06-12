# Aristotle task: DVT Z3 central roots-of-unity multiplicative equivalence

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `8a07a06b-aa33-4edb-a1ef-22838a8de750`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave6-20260601-project`
**Output**: `AgentTasks/aristotle-output/dvt-z3-central-root-mulequiv-cyclic-20260601`
**Integrated**: 2026-06-01
**Type**: DVT/Yokota central-kernel finite cyclic group API

## Goal

Promote the newly integrated equivalence between bundled DVT central units and
Mathlib's `rootsOfUnity 3 Complex` from a plain equivalence to a multiplicative
equivalence, then transfer cyclicity to the scalar central group if
straightforward.

This makes the central-kernel statement more publication-ready: the central
subgroup is not just a three-element type, but the expected multiplicative
cube-root group.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTZ3CentralRootsMulEquiv.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralActionHom
import PhysicsSM.Algebra.Jordan.DVTZ3CentralScalarFinite
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `DVTZ3CentralUnit`
- `DVTZ3CentralScalar`
- `DVTZ3CentralUnit.instGroup`
- `DVTZ3CentralScalar.instGroup`
- `dvtZ3CentralUnitEquivRootsOfUnity`
- `dvtZ3CentralUnitEquivScalar`
- `dvtZ3CentralUnitToScalarMonoidHom`
- `dvtZ3CentralUnit_card`
- `dvtZ3CentralScalar_card`
- Mathlib `rootsOfUnity 3 Complex`
- Mathlib `rootsOfUnity.isCyclic`

## Target declarations

Define multiplicative equivalences:

```lean
noncomputable def dvtZ3CentralUnitMulEquivRootsOfUnity :
    MulEquiv DVTZ3CentralUnit (rootsOfUnity 3 Complex) := ...

noncomputable def dvtZ3CentralScalarMulEquivRootsOfUnity :
    MulEquiv DVTZ3CentralScalar (rootsOfUnity 3 Complex) := ...
```

Add coercion/application lemmas:

```lean
@[simp] theorem dvtZ3CentralUnitMulEquivRootsOfUnity_apply_val
    (u : DVTZ3CentralUnit) :
    ((dvtZ3CentralUnitMulEquivRootsOfUnity u : Complexˣ) : Complex) =
      (u : Complexˣ) := ...

@[simp] theorem dvtZ3CentralScalarMulEquivRootsOfUnity_apply_val
    (z : DVTZ3CentralScalar) :
    ((dvtZ3CentralScalarMulEquivRootsOfUnity z : Complexˣ) : Complex) =
      (z : Complex) := ...
```

If the exact coercion target for `rootsOfUnity 3 Complex` differs in Lean, use
the corresponding accepted coercion. Keep the lemma names and meaning.

Transfer cyclicity if it is accessible:

```lean
noncomputable instance DVTZ3CentralUnit.instIsCyclic :
    IsCyclic DVTZ3CentralUnit := ...

noncomputable instance DVTZ3CentralScalar.instIsCyclic :
    IsCyclic DVTZ3CentralScalar := ...
```

If the `IsCyclic` instances cause unexpected typeclass trouble, replace them
with explicit theorems:

```lean
theorem dvtZ3CentralUnit_isCyclic : IsCyclic DVTZ3CentralUnit := ...
theorem dvtZ3CentralScalar_isCyclic : IsCyclic DVTZ3CentralScalar := ...
```

Bundle the result:

```lean
structure DVTZ3CentralRootsMulEquivPackage where
  unit_mul_equiv_roots :
    MulEquiv DVTZ3CentralUnit (rootsOfUnity 3 Complex)
  scalar_mul_equiv_roots :
    MulEquiv DVTZ3CentralScalar (rootsOfUnity 3 Complex)
  scalar_card_three : Fintype.card DVTZ3CentralScalar = 3
  unit_card_three : Fintype.card DVTZ3CentralUnit = 3
  scalar_is_cyclic : IsCyclic DVTZ3CentralScalar

noncomputable def dvtZ3CentralRootsMulEquivPackage :
    DVTZ3CentralRootsMulEquivPackage := ...
```

## Claim boundary

This proves the finite central cube-root group API for the current DVT
central-kernel scaffold. It does not prove the full DVT stabilizer theorem,
the full `(SU(3) x SU(3)) / Z3` action, or faithfulness of a noncentral action.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not redefine `DVTZ3CentralScalar`, `DVTZ3CentralUnit`, or their group
  instances.
- Do not change the trivial-action theorem statements.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTZ3CentralRootsMulEquiv.lean
lake build PhysicsSM.Algebra.Jordan.DVTZ3CentralRootsMulEquiv
```
