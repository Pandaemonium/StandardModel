# Aristotle C108: origin branch-observable certificate

Date: 2026-06-27

Dependency class: independent finite algebra / soft-dependent on C106a
motivation.

Project target:

```text
AgentTasks/aristotle-standalone/c108-origin-branch-observable-certificate-20260627/C108OriginBranchObservable/ZeroIndexCertificate.lean
```

## Context

The controlled non-ultralocal Gate C1 route needs a canonical branch observable
`B(U)`. A major failure mode is:

```text
B commutes with the origin balance symmetry J.
```

If `J` flips chirality and `B` commutes with `J`, then polynomial selectors
`p(B)` cannot polarize chirality at the origin. This is the finite algebra
version of the origin branch-observable rejection certificate.

## Task

Complete the three Lean theorems in:

```text
C108OriginBranchObservable/ZeroIndexCertificate.lean
```

The intended content:

1. If `J^2 = 1`, `J*Gamma = -Gamma*J`, and `J*P = P*J`, then
   `trace (Gamma*P) = 0`.
2. If `J*B = B*J`, then `J * p(B) = p(B) * J` for every polynomial `p`.
3. Therefore, if `B` commutes with `J`, then every polynomial selector `p(B)`
   has zero chiral trace.

## Acceptance criteria

- Keep the job Mathlib-only and finite-dimensional.
- Do not introduce physics structures, gauge fields, spectral islands, or C1
  release claims.
- Preserve the intended finite trace/no-go content. Minor Lean statement
  repairs are acceptable.
- Include the complete final contents of `ZeroIndexCertificate.lean` in the
  final response, because recent Aristotle archives have repeatedly missed
  candidate files.

## Claim boundary

This is a rejection certificate only. It does not construct a good `B(U)` and
does not prove that any candidate has nonzero origin chiral index.
