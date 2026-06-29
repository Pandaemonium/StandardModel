# Claude review packet: cycle 22 C108d recovered source

Date: 2026-06-27

## Project context

We are working on the null-edge Gate C1 controlled non-ultralocal branch. The
finite origin-observable stack is:

```text
C108:
  balance-commuting branch observables give zero chiral trace.

C108b:
  nonzero selector chiral trace forces a nonzero J-odd component.

C108c:
  chiral trace sees only the J-odd part.

C108d:
  should prove finite non-vacuity and a positive nonzero-trace search criterion.
```

The larger Gate C1_NU target still requires native `B(U)`, spectral island, true
bad-sector inverse gap, ghost-zero exclusion, gauge covariance/dressing, Krein
health, anomaly accounting, and path-sum/resolvent/finite-volume control.

## Artifact under review

Recovered Aristotle source:

```text
AgentTasks/aristotle-standalone/c108d-oddmoment-witness-20260627/C108dOddMomentWitness/OddMomentWitness.lean
```

This is not promoted to trusted project modules.

## Intended reading

C108d should prove:

```text
1. ChiralTrace Gamma P != 0 iff
   ChiralTrace Gamma (OddPart J P) != 0,
   assuming J^2 = 1 and J anti-commutes with Gamma.

2. A concrete 2 by 2 witness:
   Gamma2 = diag(1,-1)
   Jswap2 = [[0,1],[1,0]]
   B = Gamma2
   p = X

   Jswap2^2 = 1,
   Jswap2 * Gamma2 = -(Gamma2 * Jswap2),
   OddPart Jswap2 Gamma2 = Gamma2,
   ChiralTrace Gamma2 (aeval Gamma2 X) = 2,
   ChiralTrace Gamma2 (aeval Gamma2 X) != 0.

3. Optional hardening:
   p = X^2 + X also has nonzero chiral trace in the same witness.
```

Claim boundary:

```text
Finite non-vacuity only.
No null-edge-native B(U).
No Gate C1 release.
No spectral island, gauge covariance, bad-sector gap, Krein positivity,
anomaly accounting, or path-sum control.
```

## Review request

Please review the embedded Lean source adversarially.

Focus on:

```text
1. Semantic alignment:
   Does the Lean prove the intended nonzero criterion and concrete witness?

2. Witness:
   Is the witness nonvacuous but correctly limited?

3. Proof-style risk:
   Are `simp +decide`, `ring`, and `fin_cases` acceptable for this standalone
   recovered artifact, or should anything block downstream use?

4. Theorem debt:
   What remains after C108d before C109a/C109b or native B(U) work?
```

Requested output format:

```text
Verdict: accept / accept with caveats / reject
Findings:
- ...
Proof-style caveats:
- ...
Remaining theorem debt:
- ...
Recommended next action:
- ...
```
