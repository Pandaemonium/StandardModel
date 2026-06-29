# Claude review packet: cycle 9 C108 origin branch-observable certificate

Date: 2026-06-27

## Context

We are running the active 30-cycle autonomous loop. The constructive branch is
`C1_NU`: controlled non-ultralocal release through a canonical branch observable
`B(U)` and polynomial/Riesz/path-sum projectors.

A crucial origin test is:

```text
If B commutes with the origin balance symmetry J, then polynomial selectors p(B)
cannot polarize chirality.
```

C108 is a finite algebra rejection certificate for that failure mode.

## Current C108 target

Aristotle project:

```text
efd86260-78ff-4278-888d-03eff60216eb
```

Task:

```text
ced781b1-832c-4e7e-9732-625aa4047223
```

Target:

```text
AgentTasks/aristotle-standalone/c108-origin-branch-observable-certificate-20260627/C108OriginBranchObservable/ZeroIndexCertificate.lean
```

Intended content:

```text
J^2 = 1,
J*Gamma = -Gamma*J,
J*P = P*J
  => trace(Gamma*P) = 0.

J*B = B*J
  => J*p(B) = p(B)*J.

Therefore, if B commutes with J, every polynomial selector p(B) has zero
chiral trace.
```

## Review questions

- Is this the right finite origin branch-observable rejection certificate?
- Are the trace/no-go assumptions sufficient and correctly oriented?
- Is `trace (Gamma * P)` the right finite proxy for the chiral index at this
  stage?
- Should `P` be assumed idempotent, or is the stronger "any commuting P has zero
  chiral trace" theorem preferable?
- What should be the immediate successor after C108 if it lands?

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
