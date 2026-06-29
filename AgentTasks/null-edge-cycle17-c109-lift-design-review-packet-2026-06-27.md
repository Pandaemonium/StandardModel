# Claude review packet: cycle 17 C109 lift design

Date: 2026-06-27

## Project context

We are working on the null-edge Gate C1 controlled non-ultralocal branch.

The finite origin-observable stack now has recovered standalone results:

```text
C108:
  if a candidate branch observable B commutes with the balance symmetry J,
  every polynomial selector p(B) has zero chiral trace.

C108b:
  if some polynomial selector p(B) has nonzero chiral trace, then B has a
  nonzero J-odd component.

C108c:
  ChiralTrace Gamma P = ChiralTrace Gamma (OddPart J P), so the chiral trace
  only sees the J-odd part.

C108d:
  currently running. Target: package the nonzero iff and exhibit a concrete
  2 by 2 witness with Gamma2 = diag(1,-1), Jswap2, B = Gamma2, p = X.
```

The larger Gate C1_NU target still requires:

```text
native branch observable B(U),
target spectral island,
nonzero origin chiral index,
true bad-sector inverse gap,
no propagator-zero mirror removal,
gauge covariance or precise gauge dressing,
Krein/spectral health,
anomaly accounting,
controlled non-ultralocal path-sum/resolvent/finite-volume certificate.
```

## Current problem

Once C108d returns, the tempting next step is to construct or assert a candidate
`B(U)`. That is probably too fast.

The safer next theorem may be a C109 lift/design API:

```text
Given null-edge-native origin data containing:
  Gamma0,
  J0,
  a finite origin fiber,
  an origin branch observable B0,
  a polynomial selector p,
  J0^2 = 1,
  J0 * Gamma0 = -(Gamma0 * J0),
  ChiralTrace Gamma0 (p(B0)) != 0,

prove only:
  B0 escapes the balance-even commutant,
  p(B0)'s odd part carries the trace,
  this data is a necessary origin-polarization certificate,
  but no release / spectral island / gauge / gap claim follows.
```

## Review request

Please adversarially review this next-step design.

Focus on:

```text
1. Is a C109 origin-data lift API the right next theorem after C108d, or should
   we first prove another finite algebra result?

2. What exact theorem statement would be safest and most useful?

3. What fields should an `OriginPolarizerCertificate` or
   `NativeOriginBranchData` structure contain?

4. What non-implication guardrails should be theorem fields or separate lemmas
   so nobody treats this as Gate C1 release?

5. What should be hard-dependent on C108d, and what can be prepared now as a
   soft-dependent packet?
```

Claim boundary:

```text
This is theorem-design review only.
Do not claim a physical release.
Do not assume an actual null-edge-native B(U) exists.
Do not assume spectral islands, gauge covariance, bad-sector gap, or anomaly
accounting.
```

Requested output format:

```text
Verdict: proceed / revise / wait for C108d
Proposed theorem/API:
- ...
Guardrails:
- ...
Dependency classification:
- ...
Recommended next action:
- ...
```
