# Aristotle task: G2 fixing-e111 determinant-one moonshot

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Moonshot
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `67889d89-5732-4d17-8422-829c567c5a6e`
**Submission project**: `AgentTasks/aristotle-submit/paper-stretch-wave8-20260601-project`
**Output**: `AgentTasks/aristotle-output/g2-fixing-e111-det-one-moonshot-20260601`
**Integrated**: 2026-06-01
**Type**: Baez G2-to-SU3 determinant frontier

## Goal

Try to prove the missing algebraic step from "acts unitarily on C^3" to
"acts with determinant one" for the local record `FixingE111MulLinear`.

This is deliberately at the edge of the current formalization. If successful,
it gives the paper a much stronger Baez bridge: fixing the chosen imaginary
octonion acts as an `SU(3)` matrix on the complement, not only as a `U(3)`
matrix with determinant of norm one.

## Requested file

Create:

```text
PhysicsSM/Algebra/Octonion/G2FixingE111DetOne.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111Determinant
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Stretch target

Prove:

```lean
theorem fixingE111MulLinear_det_eq_one
    (g : FixingE111MulLinear) :
    g.onComplexVecMatrix.det = 1 := ...
```

Then package:

```lean
structure G2FixingE111DetOnePackage where
  det_eq_one :
    forall g : FixingE111MulLinear, g.onComplexVecMatrix.det = 1
  det_unit_eq_one :
    forall g : FixingE111MulLinear, g.detUnit = 1

noncomputable def g2FixingE111DetOnePackage :
    G2FixingE111DetOnePackage := ...
```

## Suggested approach

The current API already proves:

- `fixingE111MulLinear_preservesHermitian`
- `fixingE111MulLinear_det_normSq_eq_one`
- `FixingE111MulLinear.detUnit`
- complex-linearity of `g.onComplexTriple`

The missing information is orientation / complex volume preservation. A
possible route is:

1. Define an explicit complex volume form on `ComplexTriple`.
2. Relate octonion multiplication on the complement to that volume form or to
   the `Complex` cross product.
3. Use `g.map_mul`, `g.fixes_e111`, and the known coordinate decomposition to
   prove the volume form is preserved.
4. Conclude `det(g.onComplexVecMatrix) = 1` from volume preservation.

An explicit finite-coordinate route is acceptable: expand the multiplication
relations among the three complement basis vectors and use them to solve for
the determinant.

## Fallback if the full theorem is too hard

Do not put a `sorry` in trusted code. Instead:

1. Create a trusted partial file with any sorry-free lemmas you can prove, such
   as volume-form definitions, determinant action on volume, or multiplication
   relations in the complement basis.
2. Create a draft handoff file:

```text
PhysicsSM/Draft/G2FixingE111DetOneHandoff.lean
```

with the exact final theorem statement and documented proof blockers. Draft
`sorry` is acceptable only there.

## Claim boundary

Even if this succeeds, it proves a determinant-one theorem for the local
`FixingE111MulLinear` record. It still does not prove the full Lie group
isomorphism `Stab_G2(e111) = SU(3)`, connectedness, smoothness, or compact
Lie group structure.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not weaken `FixingE111MulLinear`.
- Do not change the octonion multiplication convention.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Octonion.G2FixingE111DetOne
```
