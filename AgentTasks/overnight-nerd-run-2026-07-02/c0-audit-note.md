# C0 Convention Audit Note

Date: 2026-07-03
Owner: Codex
Task: T6, three-J and claim-scope terminology audit

## Scope

Audited the live Gate C1 Lean layer, the current C1 release/setup notes, and
the live super-Dirac/Krein surfaces against `docs/CONVENTIONS.md`.

Included:

- `PhysicsSM/Draft/NullEdge/GateC1/`
- `PhysicsSM/Draft/NullEdgeSuperDirac*.lean`
- `PhysicsSM/NullStrand/DualSolder/*.lean`
- `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md`
- `AgentTasks/nerd-gate-c1-gw-release-setup-2026-07-03.md`

Excluded old Aristotle extraction/submission trees, because they are historical
packets and would swamp the live audit with stale copies.

## Convention Anchors

- `J_K`: Krein fundamental symmetry. Linear. Kinematic. May define
  Krein self-adjointness, but does not by itself imply stability, positivity,
  real spectrum, or healthy sign calculus.
- `J_C`: charge conjugation / real structure. Antiunitary. Kinematic.
- `J_mod`: Tomita modular conjugation. Antiunitary and state-dependent. Must
  not appear in kinematic theorems.
- Gate C1 is regulator-level finite operator algebra, not a Lorentz-invariant
  ontology claim.
- `Gamma_s`, `chi_E`, and `epsilon_form` must stay distinct.

## Findings

| Severity | Location | Finding | Status |
|---|---|---|---|
| Medium | `PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperatorGapEqualN.lean:6`, `:31`, `:37` | The module docstring still described the coercive inverse-propagator theorem as a "spectral gap" and as a Hermitian seed before the Hermitian/anticommutation hypotheses enter. | Fixed. Wording now says coercive inverse-propagator gap / coercive square gap and reserves spectral-gap language for the self-adjoint successor rung. |
| Low | `PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean:52` | Guardrail said physical classification needs the Krein `J`-sign. Under C0 this should name `J_K`. | Fixed. |
| Medium | `PhysicsSM/Draft/NullEdge/GateC1/TetraFlavoredOverlapCandidate.lean:47`, `PhysicsSM/Draft/NullEdge/GateC1/SpectralIslandIndexPredicates.lean:116` | C1 branch/balance involution was documented as bare `J`, which can be confused with `J_K`, `J_C`, or `J_mod`. | Fixed locally: docstring now names `Jbalance`; zero-index lemma uses local variable `Jb` and "balance involution" prose. |
| Medium | `PhysicsSM/NullStrand/DualSolder/FiniteKreinDoubled.lean:31`, `:63`, `:95`, `:120` | The finite Krein API consistently uses bare `J` for the Krein fundamental symmetry (`IsJSelfAdjoint J A`, `Jdouble J`, etc.). Semantically it is clearly Krein-only and already has non-overclaim guardrails, but it predates the C0 naming lock. | Residual. Do not churn the public API overnight. Recommended follow-up: introduce `JK`-named wrappers or a planned rename (`kreinAdjointJK`, `IsJKSelfAdjoint`, `JKdouble`) with compatibility aliases. |
| Medium | `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md:365`, `:1164`, `:2309`, `:2336`, and many nearby `Odd_J`/`J-odd` references | The release plan uses `J` for a branch/balance involution, not for any of the three C0 operators. This is mathematically meaningful but notation-collides with the locked three-J convention. | Residual documentation debt. Recommended follow-up: add a naming convention such as `J_bal` or `B_bal` for branch balance, then gradually rewrite the release plan headings and predicates (`Odd_J` -> `Odd_Jbal` or `Odd_balance`). |

## Non-Findings

- `PhysicsSM/NullStrand/DualSolder/GradedSuperDiracSquare.lean` already
  separates `Gamma_s` from internal/form gradings and explicitly lists the
  load-bearing grading hypotheses.
- `PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean` already documents the
  wrong-grading companion and warns against using `chi_E` or form degree to
  repair a spacetime chirality sign.
- `AgentTasks/nerd-gate-c1-gw-release-setup-2026-07-03.md` correctly labels
  the GW rung as regulator-level and explicitly excludes Gate C2 and
  Lorentz-invariant continuum claims.
- Fresh Gate C1 gap/self-adjointness files now carry the right distinction:
  coercive inverse-propagator gap first; self-adjoint spectral gap only after
  the Hermitian/anticommutation hypotheses are combined.

## Verification

Commands run after the Lean edits:

```text
lake build PhysicsSM.Draft.NullEdge.GateC1.TetraFreeOperatorGapEqualN
lake build PhysicsSM.Draft.TetrahedralHighMomentumNullBranch
lake build PhysicsSM.Draft.NullEdge.GateC1.TetraFlavoredOverlapCandidate
lake build PhysicsSM.Draft.NullEdge.GateC1.SpectralIslandIndexPredicates
lake build PhysicsSM.Draft.NullEdge.GateC1.SpectralIslandIndexPredicates
rg -n "\b(sorry|admit|axiom|opaque|unsafe|native_decide)\b" <touched Lean files>
rg -n "[ \t]+$" <touched Lean files>
```

All four targeted builds passed. The final placeholder-token scan and trailing
whitespace scan over the touched Lean files returned no hits.
