# Claude review packet: cycle 4 recovered C107 source

Date: 2026-06-27

## Context

We are running the active 30-cycle autonomous loop for the null-edge program.
The active constructive Gate C1 target is `C1_NU`: controlled non-ultralocal
physical chiral release through a canonical branch observable `B(U)`, finite
polynomial / Riesz / sign / path-sum projectors, nonzero origin chiral-index
test, true bad-sector inverse gap, and full ghost/anomaly/Krein/gauge audits.

C107 is a finite algebra seed for the branch-observable route. The intended
mathematical claim is:

```text
If B' = S * B * T with S*T = 1 and T*S = 1, then powers and polynomial
evaluations of B transform by the same conjugation:

  (B')^k = S * B^k * T
  p(B') = S * p(B) * T
```

This is not a spectral projector theorem by itself. It is only the finite
matrix algebra needed before polynomial spectral projector covariance.

## Current situation

Aristotle project:

```text
0ab24ab1-3f6a-465f-9d47-678856fc1a77
```

Aristotle reported completion, but the downloaded archive had no candidate
files. A recovery ask returned the full source, which has now been preserved in
the standalone task area:

```text
AgentTasks/aristotle-standalone/c107-finite-spectral-projector-20260627/C107FiniteSpectralProjector/ConjugationPowers.lean
```

No local Lean verification has been run after preservation.

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

## Requested output

Please give:

```text
Findings:
- ordered by severity with theorem names.

Verdict:
- accept as C107 seed / accept with caveats / reject.

Next theorem:
- one precise theorem target and why it is next.
```
