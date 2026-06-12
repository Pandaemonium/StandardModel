# Aristotle task: Krasnov complex-structure centralizer

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Paper-support
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `e3eaabab-7b9d-43f4-a036-e3d4534192e8`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave9-20260601-project`
**Output**:
**Integrated**:
**Type**: Krasnov spinor/qubit comparison theorem

## Goal

Prove the clean linear-algebra bridge behind the Krasnov comparison layer: a
real-linear endomorphism commuting with the chosen complex structure
`rightMulE111` is complex-linear in the `Complex` coordinate model.

This supports the paper's "related formalized structures" section by showing
that the same chosen octonionic imaginary unit gives a genuine complex
structure in the spinor/qubit layer.

## Requested file

Create:

```text
PhysicsSM/Spinor/KrasnovComplexCentralizer.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Spinor.KrasnovComplexStructure
import PhysicsSM.Spinor.KrasnovQubitComplexCoordinates
```

Use the existing Krasnov namespace used by those files.

Do not edit `PhysicsSM.lean`; Codex will add imports during integration.

## Target declarations

Find the existing type used for the Krasnov real vector space and its complex
coordinates. Then prove a statement of the following form, adapted to the
actual declarations:

```lean
def CommutesWithKrasnovJ (T : V ->+ V) : Prop :=
  forall q, T (rightMulE111 q) = rightMulE111 (T q)
```

For the appropriate linear-map type, prove:

```lean
theorem commutesWithRightMulE111_iff_complexLinear
    (T : V ->L[Real] V) :
    CommutesWithKrasnovJ T <->
      forall z : Complex, forall q : V,
        T (complexScalarAction z q) =
          complexScalarAction z (T q) := ...
```

If a full iff is too broad, prove the useful direction:

```lean
theorem commutesWithRightMulE111.complexLinear
    (T : V ->L[Real] V)
    (hT : CommutesWithKrasnovJ T) :
    forall z : Complex, forall q : V,
      T (complexScalarAction z q) =
        complexScalarAction z (T q) := ...
```

Also add a package:

```lean
structure KrasnovComplexCentralizerPackage where
  complex_linear_of_commutes :
    forall T, CommutesWithKrasnovJ T ->
      forall z q, T (complexScalarAction z q) =
        complexScalarAction z (T q)
```

## Suggested proof strategy

Use the existing `rightMulE111 (rightMulE111 q) = -q` theorem and the complex
coordinate lemmas. Expand `z = a + b * I`; real-linearity handles the `a` part
and commutation with `rightMulE111` handles the imaginary part.

## Claim boundary

This is a linear-algebra theorem about the Krasnov complex structure. It does
not prove a Clifford algebra representation theorem, a Standard Model
representation theorem, or a physical chirality statement.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not change the definition of `rightMulE111`.
- Do not edit `PhysicsSM.lean`.
- If the existing coordinate API is too thin, add small helper lemmas with
  clear names rather than weakening the theorem.

## Verification

Run:

```bash
lake build PhysicsSM.Spinor.KrasnovComplexCentralizer
```
