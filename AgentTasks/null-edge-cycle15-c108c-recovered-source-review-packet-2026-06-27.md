# Claude review packet: cycle 15 C108c recovered source

Date: 2026-06-27

## Project context

We are working on the null-edge Gate C1 controlled non-ultralocal branch. The
finite origin-observable stack now has:

```text
C108:
  if B commutes with balance symmetry J, then all polynomial selectors p(B)
  have zero chiral trace.

C108b:
  if a polynomial selector has nonzero chiral trace, then B has a nonzero
  J-odd component.
```

C108c should provide the quantitative identity behind this stack:

```text
ChiralTrace Gamma P = ChiralTrace Gamma (OddPart J P)
```

when `J * J = 1` and `J * Gamma = -(Gamma * J)`.

## Artifact under review

Standalone recovered Aristotle source:

```text
AgentTasks/aristotle-standalone/c108c-oddpart-chiraltrace-20260627/C108cOddPartChiralTrace/OddPartTrace.lean
```

This is not yet promoted to trusted project modules.

## Intended reading

C108c defines:

```text
EvenPart J P = (1/2) * (P + J P J)
OddPart  J P = (1/2) * (P - J P J)
```

It should prove:

```text
1. EvenPart + OddPart = P.
2. ChiralTrace Gamma (EvenPart J P) = 0.
3. ChiralTrace Gamma P = ChiralTrace Gamma (OddPart J P).
4. The polynomial-selector corollary with P := Polynomial.aeval B p.
```

Claim boundary:

```text
This is only a finite origin-fiber chiral-trace identity.
It does not construct B(U).
It does not prove a spectral island.
It does not prove Gate C1 release.
It does not prove gauge covariance, locality, Krein positivity, anomaly
accounting, or bad-sector gap.
```

## Review request

Please review the embedded Lean source adversarially.

Focus on:

```text
1. Semantic alignment:
   Does the Lean theorem prove exactly that chiral trace sees only the J-odd
   part?

2. Algebra:
   Are the even/odd definitions normalized correctly?
   Is the even-part trace cancellation valid under only J * J = 1 and
   J * Gamma = -(Gamma * J)?

3. Polynomial corollary:
   Does the corollary correctly specialize to P := Polynomial.aeval B p?

4. Proof-style risk:
   Is the proof acceptable as a standalone recovered artifact?
   What should be cleaned before trusted promotion?

5. Next theorem:
   What is the most valuable theorem after C108/C108b/C108c before attempting a
   concrete null-edge-native B(U)?
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
