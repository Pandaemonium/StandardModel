# Aristotle task: generic family-symmetry naturality

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `62c4f643-c4d8-45b3-ac37-4ab4ffdf275a`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-family-z6-next-20260531-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-family-symmetry-naturality-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/standardmodel-family-symmetry-naturality-20260531-extracted`
**Type**: generic finite family-symmetry theorem package

## Integration

Integrated on 2026-05-31 from Aristotle job
`62c4f643-c4d8-45b3-ac37-4ab4ffdf275a`.

Live file:

```text
PhysicsSM/StandardModel/FamilySymmetry.lean
```

Root import added to `PhysicsSM.lean`.

## Goal

Create the first reusable theorem layer for the "family-symmetry naturality"
track in `EXECUTION_PLAN.md`.

The result should be a generic mathematical theorem package: if a family
symmetry commutes with a charge or gauge operator, then eigenvectors and
charge-table identities transport across the family orbit.

This is intentionally abstract. It should not mention Furey-Hughes, `S3`,
triality, or a physical three-generation claim except in comments.

## Requested file

Create a trusted file:

```text
PhysicsSM/StandardModel/FamilySymmetry.lean
```

Suggested imports:

```lean
import Mathlib
```

Use namespace:

```lean
namespace PhysicsSM.StandardModel.FamilySymmetry
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target declarations

Please choose exact Lean names close to these if the snippets need adjustment.

### Linear operator naturality

Define a predicate saying a linear operator commutes with a family linear
equivalence:

```lean
def CommutesWithLinearEquiv
    {K M : Type*} [Semiring K] [AddCommMonoid M] [Module K M]
    (A : M ->L[K] M) (e : M ≃L[K] M) : Prop :=
  forall x, A (e x) = e (A x)
```

Prove:

```lean
theorem eigenvector_transport
    {K M : Type*} [Semiring K] [AddCommMonoid M] [Module K M]
    (A : M ->L[K] M) (e : M ≃L[K] M) (lambda : K) (x : M)
    (hcomm : CommutesWithLinearEquiv A e)
    (heig : A x = lambda • x) :
    A (e x) = lambda • e x := ...
```

Also prove the symmetric/inverse version if convenient:

```lean
theorem eigenvector_transport_symm ...
```

### Finite table naturality

For a family action on an index type, define:

```lean
def InvariantUnderFamilyAction
    {G I A : Type*} [SMul G I] (q : I -> A) : Prop :=
  forall g i, q (g • i) = q i
```

Prove:

```lean
theorem table_value_transport
    {G I A : Type*} [SMul G I] (q : I -> A)
    (h : InvariantUnderFamilyAction q) (g : G) (i : I) :
    q (g • i) = q i := ...
```

For rational charge tables, define a small bundled table:

```lean
structure ChargeTable (I : Type*) where
  electric : I -> Rat
  weakT3 : I -> Rat
  hypercharge : I -> Rat
```

Define invariance for all three fields and prove that the
Gell-Mann-Nishijima relation `Q = T3 + Y / 2` transports along the family
action.

Possible statement:

```lean
def ChargeTable.InvariantUnderFamilyAction
    {G I : Type*} [SMul G I] (t : ChargeTable I) : Prop := ...

def ChargeTable.SatisfiesGMN (t : ChargeTable I) : Prop :=
  forall i, t.electric i = t.weakT3 i + t.hypercharge i / 2

theorem ChargeTable.gmn_transport
    {G I : Type*} [SMul G I] (t : ChargeTable I)
    (hinv : t.InvariantUnderFamilyAction)
    (hgmn : t.SatisfiesGMN)
    (g : G) (i : I) :
    t.electric (g • i) =
      t.weakT3 (g • i) + t.hypercharge (g • i) / 2 := ...
```

## Claim boundary

This file proves an abstract naturality theorem. It does not assert that any
particular family action is realized physically, and it does not claim a full
three-generation Standard Model derivation.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Prefer small theorem statements and readable proofs.
- Keep imports modest if possible; `Mathlib` is acceptable for this first
  theorem package.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/StandardModel/FamilySymmetry.lean
lake build PhysicsSM.StandardModel.FamilySymmetry
```
