# Aristotle semantic context pack

Generated: 2026-07-16T14:46:37
Query: `A retarded finite causal operator is scalar plus nilpotent; prove every idempotent real polynomial filter is zero or identity`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/model-calls/claude/2026-06-27-153906-cycle6-c107b-recovered-source-review.md` [C107b polynomial projector idempotence]

Score: `0.839`

```text
# C107b polynomial projector idempotence

This standalone Aristotle target is the immediate finite-algebra successor to
C107.

C107 proved that polynomial evaluation by `Polynomial.aeval` is compatible with
matrix conjugation by an inverse pair. Before claiming a physical or spectral
projector, we need the finite algebra fact that a polynomial which is
idempotent on a matrix under `aeval` produces an idempotent matrix.

This file does not construct a branch observable, does not prove gauge
covariance, and does not claim a physical C1 release.
-/

namespace C107bPolynomialProjector

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/--
If `p * p - p` evaluates to zero at `B`, then `p(B)` is an idempotent matrix.

This is the finite algebra form of the spectral-island condition:
`p` is equal to `0` or `1` on the finite spectral data seen by `B`.
-/
theorem polynomial_projector_idempotent
    (B : Matrix n n Complex) (p : Polynomial Complex)
    (h : Polynomial.aeval B (p * p - p) = 0) :
    (Polynomial.aeval B p) * (Polynomial.aeval B p) = Polynomial.aeval B p := by
  rw [map_sub, map_mul] at h
  exact sub_eq_zero.mp h

/--
Variant with the polynomial relation written as equality of evaluations.
-/
theorem polynomial_projector_idempotent_of_aeval_mul_eq
    (B : Matrix n n Complex) (p : Polynomial Complex)
    (h : Polynomial.aeval B (p * p) = Polynomial.aeval B p) :
    (Polynomial.aeval B p) * (Polynomial.aeval B p) = Polynomial.aeval B p := by
  rw [map_mul] at h
  exact h

end C107bPolynomialProjector

```
```

### 2. `AgentTasks/autonomous-loop/aristotle-queue.md` [C107b - Polynomial projector idempotence]

Score: `0.838`

```text
### C107b - Polynomial projector idempotence

Status: submitted_queued
Project ID: `96cce035-7b33-4df7-9b83-64e97bb67554`
Task ID: `1a01a781-2dc7-42e5-9c5e-42ce9eba65ba`

Purpose:

- Prove that `Polynomial.aeval B (p * p - p) = 0` implies
  `Polynomial.aeval B p` is an idempotent matrix.
```

### 3. `AgentTasks/null-edge-c107b-polynomial-projector-idempotence-aristotle-2026-06-27.md` [Context]

Score: `0.833`

```text
## Context

The controlled non-ultralocal Gate C1 route needs a finite spectral-projector
API before Riesz calculus:

```text
branch observable B
polynomial p selecting a finite target spectral island
Pi = p(B)
```

C107 established by report and recovered source that conjugation by an inverse
pair preserves matrix powers, idempotence, and polynomial evaluation via
`Polynomial.aeval`.

Claude's cycle-4 review recommended the next finite theorem:

```text
If p is idempotent on B, then p(B) is an idempotent matrix projector.
```
```

### 4. `AgentTasks/null-edge-c107c-polynomial-projector-covariance-aristotle-2026-06-27.md` [Context]

Score: `0.819`

```text
## Context

The controlled non-ultralocal Gate C1 route needs a finite polynomial projector
API before introducing analytic Riesz projectors or physical branch observables.

Already completed by Aristotle report and recovered sources:

```text
C107:
  Polynomial.aeval (S * B * T) p = S * (Polynomial.aeval B p) * T
  under S*T=1 and T*S=1.

C107b:
  Polynomial.aeval B (p * p - p) = 0
    => Polynomial.aeval B p is idempotent.
```

Claude's cycle-6 review recommended the next finite assembly theorem:

```text
the conjugated polynomial projector is idempotent and equals p(SBT).
```
```

### 5. `AgentTasks/null-edge-c107b-polynomial-projector-idempotence-aristotle-2026-06-27.md` [Aristotle C107b: polynomial projector idempotence]

Score: `0.813`

```text
# Aristotle C107b: polynomial projector idempotence

Date: 2026-06-27

Dependency class: independent finite-algebra successor to C107.

Project target:

```text
AgentTasks/aristotle-standalone/c107b-polynomial-projector-idempotence-20260627/C107bPolynomialProjector/PolynomialProjector.lean
```
```

### 6. `AgentTasks/null-edge-cycle4-c107-c110a-c107b-integration-2026-06-27.md` [C107b submitted]

Score: `0.808`

```text
## C107b submitted

Project:

```text
96cce035-7b33-4df7-9b83-64e97bb67554
```

Task:

```text
1a01a781-2dc7-42e5-9c5e-42ce9eba65ba
```

Target:

```text
AgentTasks/aristotle-standalone/c107b-polynomial-projector-idempotence-20260627/C107bPolynomialProjector/PolynomialProjector.lean
```

Purpose:

- Prove that if `Polynomial.aeval B (p * p - p) = 0`, then
  `Polynomial.aeval B p` is an idempotent matrix.

Why next:

- This is the finite algebra step from C107 polynomial covariance to actual
  polynomial projectors, before introducing gauge fields, spectral islands, or
  origin-index tests.
```

### 7. `AgentTasks/null-edge-claude-cycle4-c107-recovered-source-review-2026-06-27.md` [Review questions]

Score: `0.797`

```text
## Review questions

- Does the recovered Lean source match the intended finite algebra claim?
- Are there statement/semantic traps in `conjugate_pow`,
  `conjugate_preserves_idempotent`, or `conjugate_aeval`?
- Is the use of `Polynomial.aeval` over `Matrix n n Complex` the right
  formalization of polynomial covariance for the finite spectral-projector
  route?
- Is this safe to treat as the C107 seed for later polynomial projectors, with
  the stated claim boundary?
- What is the most useful immediate successor theorem: idempotence of
  polynomial projectors from finite spectral-value hypotheses, gauge covariance
  of `p(B(U))`, or the origin branch-observable zero-index certificate?
```

### 8. `AgentTasks/model-calls/claude/2026-06-27-152854-cycle4-c107-recovered-source-review.md` [Review questions]

Score: `0.797`

```text
## Review questions

- Does the recovered Lean source match the intended finite algebra claim?
- Are there statement/semantic traps in `conjugate_pow`,
  `conjugate_preserves_idempotent`, or `conjugate_aeval`?
- Is the use of `Polynomial.aeval` over `Matrix n n Complex` the right
  formalization of polynomial covariance for the finite spectral-projector
  route?
- Is this safe to treat as the C107 seed for later polynomial projectors, with
  the stated claim boundary?
- What is the most useful immediate successor theorem: idempotence of
  polynomial projectors from finite spectral-value hypotheses, gauge covariance
  of `p(B(U))`, or the origin branch-observable zero-index certificate?
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.717`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. Correction terms for propagators and d'Alembertians due to spacetime discreteness

Score: `0.701`
Zotero key: `arxiv:1411.2614`
arXiv: `1411.2614`
DOI: `10.1088/0264-9381/32/19/195020`
URL: http://arxiv.org/abs/1411.2614

Abstract:

Finite-sprinkling correction terms for causal-set retarded propagators and d'Alembertian operators compared with continuum limits.

### 3. Feynman Propagator for a Free Scalar Field on a Causal Set

Score: `0.698`
Zotero key: `T389PSF5`
arXiv: `0909.0944`
DOI: `10.1103/PhysRevLett.103.180401`
URL: https://www.zotero.org/19894138/items/T389PSF5

Abstract:

The Feynman propagator for a free bosonic scalar field on the discrete spacetime of a causal set is presented. The formalism includes scalar field operators and a vacuum state which are first steps towards scalar quantum field theory on a causal set. This work can be viewed as a novel regularisation of quantum field theory based on a Lorentz invariant discretisation of spacetime.
