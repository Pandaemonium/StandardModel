# Claude review packet: cycle 16 C108d statement/package

Date: 2026-06-27

## Project context

We are working on the null-edge Gate C1 controlled non-ultralocal branch. The
finite origin-observable stack now has recovered standalone artifacts:

```text
C108:
  balance-commuting branch observables give zero chiral trace for all
  polynomial selectors.

C108b:
  nonzero selector chiral trace forces a nonzero J-odd branch-observable
  component.

C108c:
  chiral trace sees only the J-odd part:
  ChiralTrace Gamma P = ChiralTrace Gamma (OddPart J P).
```

C108d is a newly submitted independent finite-algebra successor. It is currently
running in Aristotle as project:

```text
00918b10-3d0f-415e-a012-1059581f1f48
```

## Artifact under review

Submitted skeleton source:

```text
AgentTasks/aristotle-standalone/c108d-oddmoment-witness-20260627/C108dOddMomentWitness/OddMomentWitness.lean
```

Prompt:

```text
AgentTasks/null-edge-c108d-oddmoment-witness-aristotle-2026-06-27.md
```

This file contains proof placeholders because it is an Aristotle target, not a
completed artifact.

## Intended theorem target

C108d should prove:

```text
1. Nonzero version of C108c:
   ChiralTrace Gamma P != 0 iff
   ChiralTrace Gamma (OddPart J P) != 0.

2. Concrete 2 by 2 finite witness:
   Gamma2 = diag(1,-1)
   Jswap2 = [[0,1],[1,0]]
   B = Gamma2
   p = X

   Jswap2^2 = 1,
   Jswap2 * Gamma2 = -(Gamma2 * Jswap2),
   OddPart Jswap2 Gamma2 = Gamma2,
   ChiralTrace Gamma2 (aeval Gamma2 X) = 2,
   ChiralTrace Gamma2 (aeval Gamma2 X) != 0.
```

Claim boundary:

```text
This is only finite non-vacuity for the origin criterion.
It does not construct a null-edge-native B(U).
It does not prove spectral islands, gauge covariance, locality, Krein
positivity, anomaly accounting, bad-sector gap, or Gate C1 release.
```

## Review request

Please review the embedded source and target adversarially.

Focus on:

```text
1. Is the C108d target the right next theorem after C108/C108b/C108c?
2. Are the 2 by 2 witness matrices chosen correctly?
3. Is `B = Gamma2`, `p = X` a good nonvacuity witness for the origin criterion?
4. Are there hidden Lean issues in the statement shape that are likely to waste
   Aristotle effort?
5. What theorem should follow C108d if it succeeds?
```

Requested output format:

```text
Verdict: accept / accept with caveats / reject
Findings:
- ...
Statement risks:
- ...
Recommended edits or follow-up:
- ...
```
