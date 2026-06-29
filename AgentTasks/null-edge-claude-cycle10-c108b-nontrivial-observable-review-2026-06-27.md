# Claude review packet: cycle 10 C108b nontrivial branch observable

Date: 2026-06-27

## Context

We are running the active 30-cycle autonomous loop. The constructive branch is
`C1_NU`: controlled non-ultralocal release through a native branch observable
and controlled projectors.

C108 is the rejection certificate:

```text
If B commutes with balance symmetry J, polynomial selectors p(B) have zero
chiral trace.
```

C108b is intended as the constructive complement:

```text
If some p(B) has nonzero chiral trace, then B must have a nonzero J-odd
component.
```

## Current C108b target

Aristotle project:

```text
9686beef-8138-4c7d-9e11-03792420c27f
```

Task:

```text
e9f9f04d-1875-4028-93f0-f773a2ba88c1
```

Target:

```text
AgentTasks/aristotle-standalone/c108b-nontrivial-branch-observable-20260627/C108bNontrivialBranchObservable/NontrivialBranchObservable.lean
```

## Review questions

- Is the theorem true as stated?
- Are `EvenPart = (B + J B J)/2` and `OddPart = (B - J B J)/2` the right
  decomposition under `J^2 = 1`?
- Does nonzero chiral trace really imply `OddPart J B ≠ 0`, using the C108
  zero-trace theorem?
- Are there missing hypotheses, for example `J` invertibility beyond `J^2=1`,
  characteristic not two, or a chirality square condition?
- Is this a useful next theorem for C1_NU, or should we wait for C108 to return?

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
