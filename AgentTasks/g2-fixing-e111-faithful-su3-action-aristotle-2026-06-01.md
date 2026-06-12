# Aristotle task: faithful SU(3) action for FixingE111MulLinear

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Paper-critical
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `28e29c93-8734-4f3e-94e4-bc2b20a525ab`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave10-20260601-project`
**Output**: `AgentTasks/aristotle-output/28e29c93-output`
**Integrated**: `PhysicsSM/Algebra/Octonion/G2FixingE111Faithful.lean`
**Type**: Baez octonion SU(3) bridge faithfulness

## Goal

Strengthen the Baez `FixingE111MulLinear -> SU(3)` bridge by proving that the
matrix action on the `C^3` complement is faithful.

The current package proves that every `FixingE111MulLinear` induces a unitary
determinant-one `3 x 3` complex matrix. The next missing theorem is that the
matrix determines the whole map: if two maps agree on the `C^3` complement,
then they agree on all octonions because they also fix the chosen complex line
`C = span_R {1, e111}` pointwise.

## Requested file

Create:

```text
PhysicsSM/Algebra/Octonion/G2FixingE111Faithful.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111MonoidHom
import PhysicsSM.Algebra.Octonion.ComplexSplitting
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

Do not edit `PhysicsSM.lean`; Codex will add imports during integration.

## Target declarations

Prove that the induced action on the complement determines the action on any
complement vector:

```lean
theorem FixingE111MulLinear.eq_onComplexTriple_of_matrix_eq
    {g h : FixingE111MulLinear}
    (hm : g.onComplexVecMatrix = h.onComplexVecMatrix)
    (w : ComplexTriple) :
    g.onComplexTriple w = h.onComplexTriple w := ...
```

Then prove the main faithfulness theorem:

```lean
theorem FixingE111MulLinear.ext_of_onComplexVecMatrix_eq
    {g h : FixingE111MulLinear}
    (hm : g.onComplexVecMatrix = h.onComplexVecMatrix) :
    g = h := ...
```

Suggested proof:

1. Use `FixingE111MulLinear.ext` from `G2FixingE111Composition`.
2. For any octonion `x`, use the splitting:

```lean
x = x.toChosenComplex.toOctonion + x.toComplexTriple.toOctonion
```

3. Show `g` and `h` agree on the chosen complex line because both are
   real-linear, send `1` to `1`, and fix `e111`.
4. Show they agree on the complement using `hm` and the coordinate/matrix
   action theorem.
5. Recombine with `map_add`.

Also prove the monoid-hom injectivity statement:

```lean
theorem fixingE111MulLinearToMatrixHom_injective :
    Function.Injective fixingE111MulLinearToMatrixHom := ...
```

If the `SU3` subtype hom from `G2FixingE111MonoidHom` is convenient, prove:

```lean
theorem fixingE111MulLinearToSU3Hom_injective :
    Function.Injective fixingE111MulLinearToSU3Hom := ...
```

## Package

Add:

```lean
structure G2FixingE111FaithfulPackage where
  matrix_ext :
    forall g h : FixingE111MulLinear,
      g.onComplexVecMatrix = h.onComplexVecMatrix -> g = h
  matrix_hom_injective :
    Function.Injective fixingE111MulLinearToMatrixHom

noncomputable def g2FixingE111FaithfulPackage :
    G2FixingE111FaithfulPackage := ...
```

## Documentation cleanup

If editing nearby docstrings, be careful with the claim boundary:
`FixingE111MulLinear` is a multiplicative real-linear, unit-preserving,
conjugation-preserving map fixing `e111`. Do not call it a `G2` element or
automorphism unless the theorem being proved justifies that exact claim.

## Claim boundary

This proves faithfulness of the current matrix representation of
`FixingE111MulLinear`. It does not prove surjectivity onto all of `SU(3)`,
connectedness of `G2`, or the full isomorphism `Stab_G2(e111) ~= SU(3)`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not change octonion multiplication or splitting definitions.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Octonion.G2FixingE111Faithful
```
