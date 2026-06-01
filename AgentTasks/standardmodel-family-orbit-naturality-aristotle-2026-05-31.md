# Aristotle task: family-orbit naturality package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium-High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `a90a7e3d-52cd-4cb2-99df-17381215bdb1`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-paper-goals-20260531-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-family-orbit-naturality-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/standardmodel-family-orbit-naturality-20260531-extracted`
**Type**: generic family-symmetry theorem package

## Goal

Extend the generic family-symmetry naturality API with orbit-level helper
theorems: invariant functions and invariant charge tables have the same values
after one or two formal family transformations, and the GMN relation is stable
under these transformations.

This gives the paper a clean abstract theorem to cite before specializing to
triality or relabeled generation copies.

## Requested file

Create:

```text
PhysicsSM/StandardModel/FamilyOrbitNaturality.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.StandardModel.FamilySymmetry
```

Use namespace:

```lean
namespace PhysicsSM.StandardModel.FamilyOrbitNaturality
```

Useful open:

```lean
open PhysicsSM.StandardModel.FamilySymmetry
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations:

- `InvariantUnderFamilyAction`
- `table_value_transport`
- `ChargeTable`
- `ChargeTable.InvariantUnderFamilyAction`
- `ChargeTable.SatisfiesGMN`
- `ChargeTable.gmn_transport`
- `ChargeTable.gmn_transport_inv`

## Target declarations

Use `SMul.smul g i` if you want ASCII notation for scalar action in theorem
statements.

Prove one-action charge equality:

```lean
theorem ChargeTable.same_charges_of_related
    {G I : Type*} [SMul G I] (t : ChargeTable I)
    (hinv : t.InvariantUnderFamilyAction G) (g : G) (i : I) :
    t.electric (SMul.smul g i) = t.electric i /\
      t.weakT3 (SMul.smul g i) = t.weakT3 i /\
      t.hypercharge (SMul.smul g i) = t.hypercharge i := ...
```

Prove two-action transport for arbitrary invariant functions, without adding
group-action laws:

```lean
theorem table_value_transport_two
    {G I A : Type*} [SMul G I] (q : I -> A)
    (h : InvariantUnderFamilyAction G q)
    (g hG : G) (i : I) :
    q (SMul.smul g (SMul.smul hG i)) = q i := ...
```

Then prove two-action charge-table equality and GMN transport:

```lean
theorem ChargeTable.same_charges_after_two_actions
    {G I : Type*} [SMul G I] (t : ChargeTable I)
    (hinv : t.InvariantUnderFamilyAction G) (g hG : G) (i : I) :
    t.electric (SMul.smul g (SMul.smul hG i)) = t.electric i /\
      t.weakT3 (SMul.smul g (SMul.smul hG i)) = t.weakT3 i /\
      t.hypercharge (SMul.smul g (SMul.smul hG i)) = t.hypercharge i := ...

theorem ChargeTable.gmn_transport_two
    {G I : Type*} [SMul G I] (t : ChargeTable I)
    (hgmn : t.SatisfiesGMN) (g hG : G) (i : I) :
    t.electric (SMul.smul g (SMul.smul hG i)) =
      t.weakT3 (SMul.smul g (SMul.smul hG i)) +
        t.hypercharge (SMul.smul g (SMul.smul hG i)) / 2 := ...

theorem ChargeTable.gmn_transport_two_inv
    {G I : Type*} [SMul G I] (t : ChargeTable I)
    (hinv : t.InvariantUnderFamilyAction G)
    (hgmn : t.SatisfiesGMN) (g hG : G) (i : I) :
    t.electric (SMul.smul g (SMul.smul hG i)) =
      t.weakT3 i + t.hypercharge i / 2 := ...
```

Package the result:

```lean
structure FamilyOrbitNaturalityPackage where
  same_charges :
    forall {G I : Type*} [SMul G I] (t : ChargeTable I),
      t.InvariantUnderFamilyAction G ->
        forall (g : G) (i : I),
          t.electric (SMul.smul g i) = t.electric i /\
          t.weakT3 (SMul.smul g i) = t.weakT3 i /\
          t.hypercharge (SMul.smul g i) = t.hypercharge i
  same_charges_two :
    forall {G I : Type*} [SMul G I] (t : ChargeTable I),
      t.InvariantUnderFamilyAction G ->
        forall (g hG : G) (i : I),
          t.electric (SMul.smul g (SMul.smul hG i)) = t.electric i /\
          t.weakT3 (SMul.smul g (SMul.smul hG i)) = t.weakT3 i /\
          t.hypercharge (SMul.smul g (SMul.smul hG i)) = t.hypercharge i

theorem familyOrbitNaturalityPackage : FamilyOrbitNaturalityPackage := ...
```

## Claim boundary

This is an abstract invariance theorem for charge tables under formal family
actions. It does not assert that any particular physical family action exists.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not add unnecessary group assumptions; the two-step theorem only needs
  the existing `SMul` action and repeated use of invariance.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/StandardModel/FamilyOrbitNaturality.lean
lake build PhysicsSM.StandardModel.FamilyOrbitNaturality
```

## Integration result

Integrated on 2026-05-31 from Aristotle job
`a90a7e3d-52cd-4cb2-99df-17381215bdb1`.

Live file:

```text
PhysicsSM/StandardModel/FamilyOrbitNaturality.lean
```

Root import added to `PhysicsSM.lean`:

```lean
import PhysicsSM.StandardModel.FamilyOrbitNaturality
```

The result adds abstract orbit-level naturality lemmas for invariant charge
tables and a `FamilyOrbitNaturalityPackage`. It remains an abstract finite
family-action theorem and makes no physical existence claim.

Verification run during integration:

```bash
lake env lean PhysicsSM/StandardModel/FamilyOrbitNaturality.lean
```
