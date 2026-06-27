# Null-edge Gate Matrix - 2026-06-27

Purpose: keep kernel-checked and Aristotle-returned results attached to the
right gate, sector, and claim strength. This is a guardrail against accidental
C0-to-C1 slippage.

## Legend

```text
C0 = external species health / regulator control
C1 = physical chiral release
H  = internal spectrum, anomaly, and legal finite Dirac structure
F  = prediction/codimension
```

Claim strength:

```text
API         = conditional interface or predicate package
negative    = no-go or failure theorem
concrete    = theorem about a named construction
strategy    = report or plan, not kernel proof
```

## Current matrix

| Result | Gate | Strength | What it actually says | What it must not be cited as |
| --- | --- | --- | --- | --- |
| `NullEdgeRAWilsonGap.lean` / C85 | C0 | API | Anti-Hermitian plus positive scalar Wilson mass gives Hilbert norm lower bound / no-kernel schema. | Concrete null-edge C0 until instantiated; C1 release. |
| `NullEdgeGateC0SpeciesHealth.lean` / C86 | C0 | API | Packages species-health release and separates C0 from C1. | Standard Model chirality or full Gate C release. |
| C89 submitted: `NullEdgeRAWilsonConcrete.lean` | C0 | pending concrete | Intended to instantiate C85/C86 for the actual RA-Wilson null-edge construction. | C1 release, unless it proves a separate chiral mechanism, which it is not asked to do. |
| `NullEdgeProjectedGateCWilsonRelease.lean` / C72/C90 | C0 + projected release API | API | Conditional projected/Wilson release predicates; C90 hardens naming and ghost/regulator clauses. | Bare `D_+` release; unqualified Gate C release; C1. |
| `NullEdgeRegulatorLegalityAPI.lean` / C80 | C0/C1 boundary | API/negative | A regulator irrelevant at the origin cannot repair origin-balanced chirality. | Proof that a regulator supplies physical chirality. |
| `NullEdgeTasteOnlyOriginNoGo.lean` / C88 | C1 boundary | negative | Taste-only scalar origin polarization fails. | A reason to abandon C1; it only kills one shortcut. |
| `NullEdgeRegulatorLegalGateCRelease.lean` / C84 | C0/C1 boundary | API | Contract with lift, origin-purity, ghost, Krein, gauge, and counterterm clauses. | Evidence any concrete operator satisfies the contract. |
| C82 running: `NullEdgeInternalGradingNoKineticFix.lean` | C1/H boundary | pending negative | Intended to show internal grading alone cannot polarize an external balanced kinetic kernel. | A hard prerequisite for C89/C90. |
| C70 running: `NullEdgeNullWilsonRegulator.lean` | C0 | pending concrete | Intended to prove Wilson regulator positivity away from the origin and lifting of known witnesses. | C1; full ghost safety. |
| H9 legal finite Dirac report | H | strategy | Gate H route for forbidden finite-Dirac/operator constraints. | External branch control or Gate C solution. |

## Immediate interpretation

C89 and C90 are worthwhile only if they remain explicitly C0/projected/API work.
They do not count as C1 progress unless they unexpectedly produce an exact
chirality mechanism, an index theorem, a domain-wall/overlap construction, or a
gauge-stable spinor-line projector.

## Next C1-oriented rows to add

| Proposed result | Gate | Desired strength | Success criterion |
| --- | --- | --- | --- |
| C93 overlap / Ginsparg-Wilson interface | C1 | API/concrete interface | Defines exact modified chirality relation needed for null-edge operator and exposes missing hypotheses. |
| C94 domain-wall null-edge interface | C1 | API/concrete interface | Defines 5D/boundary-mode route and anti-vectorialization obligations. |
| C95 anti-vectorialization check | C1 | negative/guardrail | Encodes the warning that free single-Weyl localization can become vectorlike after gauging. |
| C92 Golterman-Shamir ghost predicate | C0/C1 safety | API/concrete | Separates scalar residue positivity from gauge-coupled ghost-zero safety. |
