# Null-edge cycle 07 literature/tooling notes

Date: 2026-07-02

Focus: while the exponential-bridge Aristotle job is still running, check the
Lean-native norm APIs for the long-product stability step.

## Sources checked

1. Mathlib documentation/source,
   `Mathlib.Analysis.Matrix.Normed`.
   Source:
   https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Matrix/Normed.html

   Relevance: this file is decisive for the norm-selection question. It defines
   several non-instance matrix norms, including the scoped
   `Matrix.Norms.Operator` L-infinity operator norm. The source includes:
   `Matrix.linfty_opNorm_mul`, the scoped `NormOneClass`, and the scoped
   `Matrix.linftyOpNormedRing`.

2. Mathlib documentation/source,
   `Mathlib.LinearAlgebra.UnitaryGroup`.
   Source:
   https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/UnitaryGroup.html

   Relevance: potentially useful later if we package `momentumStepSymbolRaw` or
   `continuumStepSymbol` as unitary matrices. For the immediate stability lane,
   the operator-norm API is more directly useful.

3. Matrix norm background.
   Source: https://en.wikipedia.org/wiki/Matrix_norm

   Relevance: background only. It confirms the conceptual point that the long
   product wants a submultiplicative norm with identity size `1`, unlike the
   local entrywise L1 error norm.

## Cycle-07 conclusion

The correct local next step is not to normalize `matrixL1Norm`. Mathlib already
provides a scoped L-infinity operator norm with:

- identity size `1`;
- submultiplicativity;
- enough structure to be a scoped normed ring.

Codex added three bridge lemmas in `CheckerboardDiracScaling`:

- `linftyOpNorm_one`;
- `linftyOpNorm_mul_le`;
- `linftyOpNorm_le_matrixL1Norm`.

These let future work convert local entrywise L1 error estimates into stable
operator-norm estimates without changing the global norm policy of the
standalone package.
