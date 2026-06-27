# Track B cycle 22: geometric localization is not the whole release audit

Date: 2026-06-27
Cycle: 22
Track: B - information/generalization guardrail

## Trigger

The cycle 22 literature search surfaced domain-wall and single-curved-surface Weyl fermion material. This is relevant to the null-edge C1 fork, because geometric localization can plausibly help select a physical line.

## Named failure mode

**Localization-as-audit fallacy.** A boundary, wall, curved surface, or geometric localization mechanism produces a candidate Weyl mode, and that localization is then treated as if it automatically supplied mirror-sector gap, anomaly, ghost-zero, Krein, and locality certificates.

## Finite theorem target

Represent localization and release audits as separate fields:

```lean
structure LocalizedBranchToy where
  localized : Bool
  oneWeylLine : Bool
  mirrorGapped : Bool
  anomalyAudited : Bool
  ghostAudited : Bool
  kreinPositive : Bool
```

Target counterexample:

```lean
theorem localization_not_releaseAudit :
    exists d,
      d.localized = true /\ d.oneWeylLine = true /\
      not (d.mirrorGapped = true /\ d.anomalyAudited = true /\
           d.ghostAudited = true /\ d.kreinPositive = true)
```

## Claim boundary

A domain-wall or boundary route can be a serious C1 candidate. It becomes a null-edge release only when the full audit record is constructed, not when a localized mode is named.
