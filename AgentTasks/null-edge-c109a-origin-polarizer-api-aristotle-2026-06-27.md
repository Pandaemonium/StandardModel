# Aristotle C109a: passive origin polarizer API

Date: 2026-06-27

Dependency class: soft-dependent follow-up after C108/C108b/C108c/C108d.

Project target:

```text
AgentTasks/aristotle-standalone/c109a-origin-polarizer-api-20260627/C109aOriginPolarizerAPI/OriginPolarizerAPI.lean
```

## Context

The controlled non-ultralocal Gate C1 route now has the finite origin-observable
stack:

```text
C108:
  balance-commuting branch observables give zero chiral trace.

C108b:
  nonzero selector chiral trace forces a nonzero J-odd component.

C108c:
  chiral trace sees only the J-odd part.

C108d:
  finite non-vacuity: a nonzero chiral-trace criterion and concrete 2 by 2
  witness.
```

C109a is not a release theorem. It should package passive finite origin data so
later C109b consequence lemmas can refer to a named origin certificate without
smuggling in spectral-island, gap, gauge, Krein, anomaly, or path-sum claims.

## Task

Complete / repair:

```text
C109aOriginPolarizerAPI/OriginPolarizerAPI.lean
```

The intended content:

```text
ChiralTrace Gamma P = trace (Gamma * P)
OddPart J P = (1/2 : Complex) • (P - J * P * J)
NativeOriginBranchData:
  finite origin fiber,
  Gamma0,
  J0,
  B0,
  p,
  J0^2 = 1,
  J0 anti-commutes with Gamma0,
  Gamma0^2 = 1.

Selector D = Polynomial.aeval D.B0 D.p
IsOriginPolarizerCertificate D =
  ChiralTrace D.Gamma0 (Selector D) ≠ (0 : Complex)
```

Only one theorem is requested:

```text
isOriginPolarizerCertificate_chiralTrace_ne_zero
```

This theorem may be an unfold-only restatement. Do not add content-free theorems
such as `... -> True`.

## Acceptance criteria

- Keep the API finite and matrix-based.
- Mention real mathematical objects: `Matrix`, `Polynomial`, `trace`, and
  `Polynomial.aeval`.
- Do not add gauge fields, `U`, spectral islands, bad-sector gaps, Krein fields,
  anomaly fields, path-sum fields, released operators, or Gate C1 release
  fields.
- Do not add Boolean release flags.
- Do not add global `instance` declarations.
- Do not add simp attributes that silently rewrite origin-polarization facts
  into stronger claims.
- Keep `B0` and `p` intentionally unconstrained.
- Include the complete final contents of `OriginPolarizerAPI.lean` in the final
  response because recent Aristotle archives have repeatedly missed candidate
  files.

## Claim boundary

C109a is passive packaging only. It makes downstream language safer; it does not
construct a null-edge-native branch observable and does not prove Gate C1
release.

## Integration status

System.Collections.Hashtable.Label

Project: $(System.Collections.Hashtable.Id)

Integrated into:

- Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md section 22.
- AgentTasks/null-edge-aristotle-gate-c1-completed-integration-2026-06-27.md.

Note: Aristotle reported standalone clean builds where applicable, but this pass did not promote returned Lean files into trusted PhysicsSM modules and did not run local Lean verification.
