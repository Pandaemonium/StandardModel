# Claude review packet: cycle 6 recovered C107b source

Date: 2026-06-27

## Context

We are running the active 30-cycle autonomous loop. The constructive Gate C1
branch is `C1_NU`: controlled non-ultralocal release through finite polynomial,
Riesz, sign, or path-sum projectors, with true bad-sector gap and full
ghost/anomaly/Krein/gauge audits.

C107 established the finite matrix algebra seed:

```text
aeval (S * B * T) p = S * (aeval B p) * T
```

C107b is the next finite algebra step:

```text
if p is idempotent on B under aeval, then p(B) is an idempotent matrix.
```

This is still not a physical release theorem and does not construct `B(U)`.

## Current situation

Aristotle project:

```text
96cce035-7b33-4df7-9b83-64e97bb67554
```

The archive had no candidate files, but the transcript returned complete source
and it has been preserved here:

```text
AgentTasks/aristotle-standalone/c107b-polynomial-projector-idempotence-20260627/C107bPolynomialProjector/PolynomialProjector.lean
```

No local Lean check has been run after preservation.

## Review questions

- Does the recovered C107b Lean source correctly prove the intended finite
  polynomial projector idempotence theorem?
- Are there semantic traps in using `Polynomial.aeval B (p * p - p) = 0` as the
  finite spectral/idempotence hypothesis?
- Does this pair correctly with C107's polynomial covariance seed?
- What is the next theorem: combine C107+C107b into projector covariance, or
  move to the origin branch-observable zero-index certificate?

## Requested output

Please give:

```text
Findings:
- ordered by severity with theorem names.

Verdict:
- accept as C107b seed / accept with caveats / reject.

Next theorem:
- one precise theorem target and why it is next.
```
