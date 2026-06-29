# Claude review packet: cycle 14 C108b recovered source

Date: 2026-06-27

## Project context

We are working on the null-edge Gate C1 controlled non-ultralocal branch.
The decisive missing object is a native branch observable `B(U)` whose physical
spectral island has nonzero origin chiral index and whose complement has a true
bad-sector inverse gap.

C108 established the rejection certificate:

```text
If B commutes with the origin balance symmetry J, then every polynomial selector
p(B) has zero chiral trace.
```

Cycle 13 Claude review accepted C108 with proof-style caveats and recommended a
companion theorem:

```text
If some polynomial selector has nonzero chiral trace, then B must fail to be
purely J-even; equivalently B must contain a nonzero J-odd component.
```

## Artifact under review

Standalone recovered Aristotle source:

```text
AgentTasks/aristotle-standalone/c108b-nontrivial-branch-observable-20260627/C108bNontrivialBranchObservable/NontrivialBranchObservable.lean
```

This is not yet promoted to trusted project modules. It is a standalone
Mathlib-only artifact, preserved for review.

## Intended reading

C108b defines:

```text
EvenPart J B = (1/2) * (B + J B J)
OddPart  J B = (1/2) * (B - J B J)
```

The main theorem should prove:

```text
If J * J = 1, J * Gamma = -(Gamma * J), and
ChiralTrace Gamma (Polynomial.aeval B p) != 0, then:

1. B = EvenPart J B + OddPart J B;
2. EvenPart commutes with J;
3. OddPart anti-commutes with J;
4. OddPart J B != 0.
```

Claim boundary:

```text
This theorem says a successful finite branch observable must contain a nonzero
balance-odd component.
It does not construct such an observable.
It does not prove a spectral island.
It does not prove a Gate C1 release.
It does not prove gauge covariance, locality, Krein positivity, anomaly
accounting, or bad-sector gap.
```

## Review request

Please review the embedded Lean source adversarially.

Focus on:

```text
1. Semantic alignment:
   Does the Lean theorem actually prove the intended nonzero-odd-component
   companion to C108?

2. Decomposition algebra:
   Do `EvenPart` and `OddPart` have the intended normalization and transformation
   properties under J, given only J * J = 1?

3. Contrapositive step:
   Does `OddPart J B = 0` really imply `J * B = B * J` in the Lean proof?
   Are there hidden assumptions about invertibility of 2, scalar action, or
   matrix parenthesization?

4. Proof-style risk:
   The returned proof still uses `simp +decide`, `linear_combination'`, and an
   anonymous natural-number induction. Is this acceptable for a standalone
   recovered artifact, or should it block downstream use until rewritten?

5. Next theorem:
   If C108b is accepted, what is the most valuable immediate successor theorem
   before constructing candidate `B(U)`?
```

Requested output format:

```text
Verdict: accept / accept with caveats / reject
Findings:
- file/line-style references if possible
Semantic alignment:
- ...
Proof-style caveats:
- ...
Recommended next theorem:
- ...
```
