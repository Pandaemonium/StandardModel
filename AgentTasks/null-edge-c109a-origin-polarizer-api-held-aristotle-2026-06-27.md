# Held Aristotle packet: C109a origin polarizer API

Date: 2026-06-27

Status: held packet, soft-dependent on C108/C108b/C108c, not submitted while
C108d is still running.

## Dependency class

Soft-dependent preparation:

```text
Can be drafted now as passive API/guardrail design.
Do not submit C109b consequence lemmas until C108d returns.
```

## Purpose

Create a passive finite origin-data API for the controlled non-ultralocal Gate
C1 branch without claiming release.

This packet is the design successor to:

```text
C108:
  balance-commuting branch observables give zero chiral trace.

C108b:
  nonzero selector chiral trace forces a nonzero J-odd component.

C108c:
  chiral trace sees only the J-odd part.

C108d:
  running; intended to provide finite non-vacuity and a concrete 2 by 2 witness.
```

## Target file

Proposed target:

```text
PhysicsSM/Draft/NullEdgeOriginPolarizerAPI.lean
```

Do not create or submit this until C108d either returns or the user explicitly
asks for a local draft module. The packet is being prepared first to avoid
checklist-as-Lean and release-language drift.

## Intended API

Define a finite matrix origin-data structure, not a release structure:

```text
NativeOriginBranchData
```

Required mathematical fields should be finite origin algebra only:

```text
n              : Type*
finite_n        : Fintype n
decidable_n     : DecidableEq n
Gamma0          : Matrix n n Complex
J0              : Matrix n n Complex
B0              : Matrix n n Complex
p               : Polynomial Complex
hJ0_sq          : J0 * J0 = (1 : Matrix n n Complex)
hJ0_anti        : J0 * Gamma0 = -(Gamma0 * J0)
hGamma0_sq      : Gamma0 * Gamma0 = (1 : Matrix n n Complex)
```

`B0` is intentionally unconstrained in C109a. Do not add commutation,
spectral-island, gauge, gap, or normalization properties here. Balance
commutation and odd-component consequences belong to C109b.

`p` is intentionally unconstrained in C109a. Do not add degree bounds,
normalization constraints, or gauge-flavored selector conditions to this passive
packet.

Optional field only if useful:

```text
none. Do not add content-free `True` fields.
```

Do not add:

```text
U
GaugeField
SpectralIsland
Gap
KreinPositive
Anomaly
PathSumControl
ReleasedOperator
```

Define:

```text
ChiralTrace Gamma P = trace (Gamma * P)
OddPart J P = (1/2 : Complex) • (P - J * P * J)
Selector D = Polynomial.aeval D.B0 D.p
IsOriginPolarizerCertificate D :=
  ChiralTrace D.Gamma0 (Selector D) ≠ (0 : Complex)
```

## Theorems allowed in C109a

Avoid theorem content in C109a unless it is a direct unfold/restatement needed
for API ergonomics. If included, name it as an unfold-only fact:

```text
IsOriginPolarizerCertificate.chiralTrace_ne_zero :
  IsOriginPolarizerCertificate D ->
  ChiralTrace D.Gamma0 (Selector D) ≠ (0 : Complex)
```

Do not add content-free guardrail theorems such as
`IsOriginPolarizerCertificate D -> True`. Prefer a module docstring and namespace
discipline over fake theorem content. It is also acceptable to drop the
unfold-only theorem entirely and rely on unfolding the predicate.

## Theorems blocked until C108d / C109b

Do not submit yet:

```text
originPolarizer_escapes_balanced_commutant
originPolarizer_oddPart_carries_trace
witness2x2 : NativeOriginBranchData
originPolarizer_iff_nonzero_chiralTrace
```

These should wait for C108d or directly import the recovered C108/C108b/C108c
results after they are promoted/cleaned.

## Non-release guardrails

The module docstring must explicitly say:

```text
An origin polarizer certificate is not:
  a spectral island,
  a bad-sector gap,
  a gauge-covariant branch observable,
  a Krein positivity proof,
  an anomaly calculation,
  a path-sum or resolvent control certificate,
  a Gate C1 release.
```

If a `NotRelease` namespace is used, it should contain no `theorem`, `lemma`, or
`def` declarations. Prefer the module docstring alone.

## Acceptance criteria

- Keep the API finite and matrix-based.
- Mention real mathematical objects (`Matrix`, `Polynomial`, `trace`), not only
  self-defined checklist flags.
- No proof placeholders in trusted code.
- No `U`, gauge, spectral-island, gap, Krein, anomaly, path-sum, or release
  fields.
- Do not add simp attributes to the involution, anti-commutation, or certificate
  facts in ways that silently rewrite origin polarization into stronger claims.
- Do not export a Boolean or decidable release flag. The certificate is a
  proposition over a concrete complex trace inequality, not a `Bool`.
- Do not add `instance` declarations on `NativeOriginBranchData`; this avoids
  accidental checklist-style automation or decidable-release backdoors.
- In the module docstring, state that `Polynomial.aeval D.B0 D.p` uses the
  standard `Algebra Complex (Matrix n n Complex)` instance and that empty finite
  fibers are not excluded by this passive API; non-vacuity is C108d/C109b's job.

## Claim boundary

C109a is passive packaging only. It should make downstream language safer, not
claim that the null-edge program has constructed a branch observable or solved
Gate C1.
