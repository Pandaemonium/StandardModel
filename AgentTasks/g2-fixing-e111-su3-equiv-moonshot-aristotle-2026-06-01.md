# Aristotle task: full SU3 equivalence for maps fixing e111

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Moonshot
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `28da52e1-6a57-4a37-9a46-9498d56977d3`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave11-20260601-project`
**Output**:
**Integrated**:
**Type**: Baez octonion stabilizer frontier

## Goal

Push the current Baez bridge from an injective homomorphism

```lean
fixingE111MulLinearToSU3Hom : FixingE111MulLinear ->* su3Submonoid
```

toward the full algebraic theorem that the action on the `C^3` complement is
exactly `SU(3)`.

The current trusted chain proves:

- every `FixingE111MulLinear` induces a complex-linear action on `ComplexTriple`;
- the induced matrix is unitary;
- the induced matrix has determinant one;
- the matrix hom is multiplicative;
- the matrix hom is injective.

The missing hard direction is surjectivity: every `3 x 3` complex matrix that
acts as `SU(3)` on `C^3` should extend uniquely to an octonion multiplication
preserving real-linear map fixing `1` and `e111`.

## Requested file

Create:

```text
PhysicsSM/Algebra/Octonion/G2FixingE111SU3Equiv.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111Faithful
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

Do not edit `PhysicsSM.lean`.

## Target declarations

First define the candidate extension of a complex matrix to all octonions:

```lean
noncomputable def su3MatrixExtension
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    Octonion -> Octonion := ...
```

The intended formula is:

```text
x |-> x.toChosenComplex.toOctonion
      + ComplexTriple.ofComplexVec (M.mulVec x.toComplexTriple.toComplexVec).toOctonion
```

Then, if possible, prove that an `SU(3)` matrix gives a `FixingE111MulLinear`:

```lean
noncomputable def matrixActsAsSU3OnC3.toFixingE111MulLinear
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M) :
    FixingE111MulLinear := ...
```

Prove that this construction is a right inverse to the current matrix map:

```lean
theorem matrixActsAsSU3OnC3.extension_onComplexVecMatrix
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M) :
    (matrixActsAsSU3OnC3.toFixingE111MulLinear M hM).onComplexVecMatrix = M := ...

theorem fixingE111MulLinearToSU3Hom_surjective :
    Function.Surjective fixingE111MulLinearToSU3Hom := ...
```

If the target works, package the full equivalence:

```lean
noncomputable def fixingE111MulLinearEquivSU3 :
    MulEquiv FixingE111MulLinear su3Submonoid := ...
```

Adjust the exact equivalence type if Lean wants a `MulEquiv` with coercions.

## Mathematical route

A good proof should use the classical fact that a unitary determinant-one
matrix on `C^3` preserves the Hermitian form and the complex volume form, hence
the complex cross product on the complement. In the octonion splitting
`O = C + C^3`, multiplication is determined by:

1. multiplication on the chosen complex line;
2. scalar multiplication of the complement by the chosen complex line;
3. the Hermitian form and cross-product/volume-form terms on `C^3`.

An explicit finite-coordinate proof is acceptable if that is easier for Lean:
expand the project multiplication table in the chosen complement basis and
show the determinant-one/unitary hypotheses preserve all coordinate products.

## Fallback

This is deliberately hard. If the full extension proof is too large, return the
strongest trusted prefix, such as:

- the extension map and its line/complement action lemmas;
- real-linearity of the extension;
- preservation of `1`, `e111`, and conjugation;
- preservation of the Hermitian form or volume form;
- a draft handoff file with the exact remaining multiplication goal.

Draft `sorry` is allowed only in:

```text
PhysicsSM/Draft/G2FixingE111SU3EquivHandoff.lean
```

No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted files.

## Claim boundary

This target is algebraic. It does not ask for compact Lie group topology,
smooth structure, connectedness, or a manifold-level stabilizer theorem.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Octonion.G2FixingE111SU3Equiv
```
