# Aristotle C108b: nontrivial branch-observable component

Date: 2026-06-27

Dependency class: independent / soft-dependent complement to C108.

Project target:

```text
AgentTasks/aristotle-standalone/c108b-nontrivial-branch-observable-20260627/C108bNontrivialBranchObservable/NontrivialBranchObservable.lean
```

## Context

C108 is the origin branch-observable rejection certificate:

```text
If B commutes with the balance symmetry J, then every polynomial selector p(B)
has zero chiral trace.
```

Claude recommended the constructive complement:

```text
If p(B) has nonzero chiral trace, then B must have a nonzero component that is
odd under J.
```

This is exactly the finite algebra obligation a future native branch observable
must satisfy at the origin: it cannot be purely balance-even.

## Task

Complete the theorems in:

```text
C108bNontrivialBranchObservable/NontrivialBranchObservable.lean
```

The main target is:

```text
nonzero_chiralTrace_requires_nonzero_odd_component
```

where:

```text
EvenPart J B = (1/2) * (B + J B J)
OddPart  J B = (1/2) * (B - J B J)
```

and the conclusion proves:

```text
B = EvenPart J B + OddPart J B,
EvenPart commutes with J,
OddPart anti-commutes with J,
OddPart is nonzero if some p(B) has nonzero chiral trace.
```

## Acceptance criteria

- Keep the job Mathlib-only and finite-dimensional.
- Preserve the finite algebra content. Minor Lean statement repairs are
  acceptable.
- Do not introduce gauge fields, spectral islands, branch-observable physics, or
  C1 release claims.
- Include the complete final contents of `NontrivialBranchObservable.lean` in
  the final response because recent Aristotle archives have repeatedly missed
  candidate files.

## Claim boundary

This theorem says a successful branch observable must contain a nonzero
balance-odd component. It does not construct such an observable and does not
prove release.
