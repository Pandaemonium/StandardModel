# Claude review packet: cycle 7 C107c projector covariance statement

Date: 2026-06-27

## Context

We are running the active 30-cycle autonomous loop. The constructive Gate C1
branch is `C1_NU`: controlled non-ultralocal release. The current finite
projector ladder is:

```text
C107:
  polynomial evaluation is compatible with inverse-pair conjugation.

C107b:
  if p is idempotent on B under aeval, then p(B) is an idempotent matrix.

C107c:
  assemble these into a single finite polynomial-projector covariance theorem.
```

The goal is still only finite matrix algebra. No branch observable, spectral
island, gauge field, origin index, or C1 release is claimed.

## Current C107c target

Aristotle project:

```text
e5b6e8b5-3277-40fb-8cb8-c674d6d4994c
```

Task:

```text
fecc1b89-15bf-4b81-b685-b4038ac798b6
```

Target:

```text
AgentTasks/aristotle-standalone/c107c-polynomial-projector-covariance-20260627/C107cPolynomialProjector/ProjectorCovariance.lean
```

Intended theorem:

```text
S*T = 1, T*S = 1,
Polynomial.aeval B (p*p - p) = 0
  =>
  (S*p(B)*T)^2 = S*p(B)*T
  and
  p(S*B*T) = S*p(B)*T.
```

## Review questions

- Is this the right finite assembly theorem after C107 and C107b?
- Are there semantic traps in the stated assumptions or conclusion?
- Should the conclusion also assert idempotence of `Polynomial.aeval (S*B*T) p`
  explicitly, or is that redundant given the equality?
- Should this wait for a true gauge-action wrapper, or is the inverse-pair
  matrix theorem still useful standalone?
- What is the next theorem if C107c lands cleanly?

## Requested output

Please give:

```text
Findings:
- ordered by severity.

Verdict:
- accept / accept with caveats / reject.

Next theorem:
- one precise theorem target.
```
