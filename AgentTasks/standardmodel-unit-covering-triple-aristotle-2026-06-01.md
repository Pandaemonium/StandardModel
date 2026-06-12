# Aristotle task: Unit-level Standard Model covering triple scaffold

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `79473086-fe44-45a3-a446-1b5b1cfc84c4`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave7-20260601-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-unit-covering-triple-20260601`
**Integrated**: 2026-06-01
**Type**: Standard Model gauge quotient, unit-domain scaffold

## Goal

Start replacing the raw `CoveringTriple` quotient scaffold with a unit-level
domain scaffold. Define triples whose phase and matrix components are units,
give them a group/monoid structure, and prove that forgetting to raw
`CoveringTriple` is a monoid homomorphism.

This does not yet impose unitarity or determinant-one constraints; it is a
safe algebraic bridge toward the true `U(1) x SU(2) x SU(3)` domain.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelUnitCoveringTriple.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientMonoidLaws
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `CoveringTriple`
- `CoveringTriple.identity`
- `CoveringTriple.instMonoid`
- `CoveringTriple.mul_phase`
- `CoveringTriple.mul_su2Part`
- `CoveringTriple.mul_su3Part`
- `CoveringTriple.image`
- `CoveringTriple.image_mul`
- `standardModelCoveringQuotientImageMonoidHom`

## Target declarations

Define a unit-level triple:

```lean
structure UnitCoveringTriple where
  phase : Units Complex
  su2Part : Units (Matrix (Fin 2) (Fin 2) Complex)
  su3Part : Units (Matrix (Fin 3) (Fin 3) Complex)
```

Define `One`, `Mul`, `Inv`, and preferably `Group`:

```lean
instance : One UnitCoveringTriple := ...
instance : Mul UnitCoveringTriple := ...
instance : Inv UnitCoveringTriple := ...
instance UnitCoveringTriple.instGroup : Group UnitCoveringTriple := ...
```

Define the forgetful map:

```lean
noncomputable def UnitCoveringTriple.toCoveringTriple
    (x : UnitCoveringTriple) : CoveringTriple := ...
```

Add projection lemmas:

```lean
@[simp] theorem UnitCoveringTriple.toCoveringTriple_phase
    (x : UnitCoveringTriple) :
    x.toCoveringTriple.phase = (x.phase : Complex) := ...

@[simp] theorem UnitCoveringTriple.toCoveringTriple_one :
    (1 : UnitCoveringTriple).toCoveringTriple = 1 := ...

@[simp] theorem UnitCoveringTriple.toCoveringTriple_mul
    (x y : UnitCoveringTriple) :
    (x * y).toCoveringTriple =
      x.toCoveringTriple * y.toCoveringTriple := ...
```

Package the forgetful map as a monoid hom:

```lean
noncomputable def unitCoveringTripleToCoveringTripleMonoidHom :
    UnitCoveringTriple ->* CoveringTriple := ...

@[simp] theorem unitCoveringTripleToCoveringTripleMonoidHom_apply
    (x : UnitCoveringTriple) :
    unitCoveringTripleToCoveringTripleMonoidHom x =
      x.toCoveringTriple := ...
```

Add a package:

```lean
structure StandardModelUnitCoveringTriplePackage where
  unit_group : Group UnitCoveringTriple
  forget_hom : UnitCoveringTriple ->* CoveringTriple
  forget_mul :
    forall x y : UnitCoveringTriple,
      (x * y).toCoveringTriple =
        x.toCoveringTriple * y.toCoveringTriple

noncomputable def standardModelUnitCoveringTriplePackage :
    StandardModelUnitCoveringTriplePackage := ...
```

If a `Group` instance is unexpectedly hard, a `Monoid` instance is acceptable,
but leave a note in the module docstring explaining that inverse laws remain a
future task.

## Claim boundary

This is a unit-level algebraic scaffold. It does not impose unitarity,
determinant one, special-unitary constraints, quotient topology, or a Lie group
isomorphism with `S(U(2) x U(3))`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change `CoveringTriple`.
- Do not change the raw quotient relation.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelUnitCoveringTriple.lean
lake build PhysicsSM.Gauge.StandardModelUnitCoveringTriple
```
