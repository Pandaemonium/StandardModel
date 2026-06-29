# Claude review packet: cycle 13 C108 recovered source

Date: 2026-06-27

## Project context

We are working on the null-edge Gate C1 controlled non-ultralocal branch.
The current strategy is:

```text
GateC1_local:
  keep as a local/quasi-local no-go and escape-hatch audit.

GateC1_NU:
  controlled non-ultralocal release using a canonical branch observable B(U),
  finite polynomial/Riesz/sign/path-sum projectors, true bad-sector inverse
  gap, and explicit ghost/anomaly/Krein/gauge/regulator audits.

GateC1_NL:
  declared nonlocal fallback only if controlled non-ultralocal certificates fail.
```

The decisive object is a native branch observable `B(U)`. A key rejection test is
whether the origin observable commutes with the chirality-flipping balance
symmetry `J`. If it does, polynomial selectors `p(B)` should not have nonzero
chiral trace at the origin.

## Artifact under review

Standalone recovered Aristotle source:

```text
AgentTasks/aristotle-standalone/c108-origin-branch-observable-certificate-20260627/C108OriginBranchObservable/ZeroIndexCertificate.lean
```

This is not yet promoted to trusted project modules. It is a standalone
Mathlib-only artifact, preserved for review.

## Intended reading

The C108 artifact should prove three finite matrix facts:

```text
1. If J * J = 1, J * Gamma = -(Gamma * J), and J * P = P * J,
   then trace (Gamma * P) = 0.

2. If J * B = B * J, then J * Polynomial.aeval B p =
   Polynomial.aeval B p * J for every polynomial p.

3. Therefore, if B commutes with J, every polynomial selector p(B)
   has zero chiral trace.
```

Claim boundary:

```text
This is only an origin branch-observable rejection certificate.
It does not construct a good B(U).
It does not prove any spectral island exists.
It does not prove any Gate C1 release.
It does not prove gauge covariance, locality, Krein positivity, anomaly
accounting, or bad-sector gap.
```

## Review request

Please review the embedded Lean source adversarially.

Focus on:

```text
1. Semantic alignment:
   Does the Lean statement actually prove the finite origin rejection
   certificate described above?

2. Trace algebra:
   Are the hypotheses sufficient for the zero trace result, or is there a
   hidden finite-dimensional/commutativity/parenthesization issue?

3. Polynomial selector step:
   Does `Polynomial.aeval B p` really represent the intended finite polynomial
   selector, and does the commutation theorem have the right orientation?

4. Proof-style risk:
   The returned proof uses `simp +decide` and `grind` in places. Is that only
   a maintainability caveat, or is there a plausible semantic/proof fragility
   problem that should block downstream use?

5. Next theorem:
   If C108 is accepted, what is the most valuable immediate successor theorem
   before trying to build a concrete branch observable B(U)?
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
