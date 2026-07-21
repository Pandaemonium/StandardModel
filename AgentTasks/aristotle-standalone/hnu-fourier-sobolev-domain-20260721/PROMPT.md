# Proof job: Fourier-conjugate maximal Dirac operator and graph domain

Work in Lean 4.28 with Mathlib. Develop the missing analytic bridge between a
self-adjoint matrix-valued momentum multiplier and its position-space Dirac
operator.

The target setting is a finite-dimensional complex Hilbert fibre over
`L2(R^3)`. In momentum space the Hermitian symbol is affine,

```text
H(p) = sum_j p_j alpha_j + B,
```

with fixed Hermitian matrices satisfying the Dirac/Clifford square identities.
The maximal multiplication operator has domain `{f | H(.) f(.) is L2}` and is
self-adjoint by explicit imaginary resolvents.

Required outputs, in descending order of value:

1. Prove a reusable Mathlib theorem that unitary conjugation of a densely
   defined self-adjoint `LinearPMap` is self-adjoint, with the conjugated domain
   stated exactly and its graph closed.
2. Inspect Mathlib's Fourier transform API and prove on Schwartz functions that
   multiplication by momentum is Fourier-conjugate to the corresponding
   spatial derivative, with every `2*pi`, sign, and `i` convention explicit.
3. Define the position-space Dirac operator as the unitary Fourier conjugate of
   the maximal multiplier. Prove it is self-adjoint and closed and identify its
   domain as the inverse-Fourier image of the multiplier graph domain.
4. If the available Sobolev API permits, identify that domain with vector-valued
   `H^1` under a stated coercive Dirac-square hypothesis. Otherwise state and
   prove the strongest exact graph-norm equivalence available and report the
   precise missing library lemma.
5. Include a one-dimensional scalar control that fixes the Fourier convention
   and catches a wrong sign or missing `2*pi`.

Do not claim a position-space differential operator theorem from abstract
unitary conjugation alone: the Schwartz derivative/multiplier identity is a
separate required bridge. Do not weaken maximal-domain equality to mere core
inclusion without labeling it. Return complete Lean source, exact imports, and
a blocker report for any analytic rung that cannot be closed. No proof
placeholders, compiler-trusted evaluation, or hidden domain assumptions.

Relevant semantic context:
`AgentTasks/context-packs/hnu-fourier-sobolev-domain-20260721-024108.md`.
