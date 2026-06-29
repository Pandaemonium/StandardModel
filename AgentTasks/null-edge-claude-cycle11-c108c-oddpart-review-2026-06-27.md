# Claude review packet: cycle 11 C108c odd-part chiral trace identity

Date: 2026-06-27

## Context

We are running the active 30-cycle autonomous loop. The constructive branch is
`C1_NU`: controlled non-ultralocal release through a native branch observable
and controlled projectors.

C108/C108b build the origin-observable obstruction:

```text
balance-even selectors have zero chiral trace;
nonzero chiral trace requires a nonzero balance-odd component.
```

C108c asks for the quantitative identity:

```text
ChiralTrace Gamma P = ChiralTrace Gamma (OddPart J P).
```

## Current C108c target

Aristotle project:

```text
addf8b0a-c702-48d9-b66d-b20f121568d4
```

Task:

```text
14009121-10d1-46d7-85a2-a309bb668d6e
```

Target:

```text
AgentTasks/aristotle-standalone/c108c-oddpart-chiraltrace-20260627/C108cOddPartChiralTrace/OddPartTrace.lean
```

## Review questions

- Is the theorem true as stated?
- Are the even/odd part definitions correct under `J^2 = 1`?
- Does the trace identity need extra hypotheses, such as `Gamma^2=1`,
  idempotence of `P`, or Hermiticity?
- Is this a useful finite theorem before looking for actual branch observables?
- What should the next theorem be after C108c?

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
