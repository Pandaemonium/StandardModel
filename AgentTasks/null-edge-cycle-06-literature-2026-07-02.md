# Null-edge cycle 06 literature/tooling notes

Date: 2026-07-02

Focus: after integrating the per-step BigO theorem and the matrix-power
stability toolkit, identify the next proof bottleneck for the pointwise
checkerboard-to-Dirac theorem.

## Sources checked

1. P. Arrighi, M. Forets, and V. Nesme,
   "The Dirac equation as a quantum walk: higher dimensions, observational
   convergence," arXiv:1307.3524.
   Source: https://arxiv.org/abs/1307.3524

   Relevance: remains the main conceptual anchor. Its convergence statement is
   operator-splitting/Trotter flavored and reports an `O(eps^2)` observational
   discrepancy. The Lean path now mirrors this: per-step error is proved, and
   the next missing item is stable accumulation plus the exponential bridge.

2. Mathlib documentation,
   `Mathlib.Analysis.Normed.Algebra.MatrixExponential`.
   Source:
   https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Normed/Algebra/MatrixExponential.html

   Relevance: this is the first place to search for Lean-native matrix
   exponential lemmas. The current project uses `NormedSpace.exp`; the next
   theorem should reuse Mathlib's existing matrix exponential API rather than
   building a bespoke exponential theory.

3. Mathlib documentation,
   `Mathlib.Analysis.Normed.Algebra.Exponential`.
   Source:
   https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Normed/Algebra/Exponential.html

   Relevance: documents the Banach/topological algebra exponential API behind
   `NormedSpace.exp`. It is the likely source of continuity, differentiability,
   and first-order expansion lemmas.

4. General matrix-exponential norm bounds.
   Source: https://en.wikipedia.org/wiki/Matrix_exponential

   Relevance: only background orientation, not formal provenance. It highlights
   the standard role of submultiplicative norms with `||I|| = 1`. This is
   exactly why the current `matrixL1Norm_one = 2` guardrail matters.

## Cycle-06 conclusion

Aristotle's `matrixL1Norm_pow_sub_pow_le` is useful, but not sufficient by
itself for the final `N ~ 1 / eps` stability argument because the local
entrywise L1 norm gives the identity size `2`. The next job should either:

1. move the long-product stability step to a Lean-native matrix norm with
   identity size `1` and exponential estimates already in Mathlib; or
2. prove a custom stability bound for the specific near-identity matrices that
   avoids a naive `M ^ N` blowup.

The best next Aristotle job is therefore a norm-selection/exponential-bridge
job, not another path-count job.
