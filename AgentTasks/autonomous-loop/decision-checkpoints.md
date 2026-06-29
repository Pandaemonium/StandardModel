# Decision checkpoints

Record durable strategic decisions and claim-boundary changes here.

Template:

```text
## YYYY-MM-DD - Decision title

Decision:
- ...

Why:
- ...

Evidence:
- ...

Consequences:
- ...

Revisit if:
- ...
```

## 2026-06-27 - Autonomous-loop harness adopted

Decision:

- Use a durable repo-native harness for long-running autonomous work.

Why:

- The project now spans Lean proof work, Aristotle batches, literature
  ingestion, Claude adversarial review, Pro hard-question packaging, and
  publication strategy.
- Chat history alone is too fragile for this workflow.

Consequences:

- Each loop should update durable state.
- Friction and questions become first-class artifacts.
- Claude is used once per Aristotle round as adversarial reviewer.
- Pro questions are packaged as standalone documents.

Revisit if:

- The harness becomes more overhead than help.
## 2026-06-27 - C95 is a planning guardrail, not a C1 substrate

Decision:

- Treat C95 `NullEdgeAntiVectorializationGuardrail` as an anti-fake-progress planning guardrail only.
- Do not use C95's `AntiVectorlikeWitness` as a C1 release predicate until it is hardened.
- Keep C96 regulator-removal stability held until C92 returns concrete ghost-safety structure and C89 or a successor exposes a regulator/removal handle.
- Keep the Aristotle queue dependency-aware rather than globally blocked by running jobs.

Why:

- Claude's C95 review found that `chiralitySign : Int` is currently unconstrained, `multiplicity : Nat` allows zero, and `AntiVectorlikeWitness := NetIndex != 0` is not data-carrying.
- C95 has no regulator axis and no connection to the actual null-edge operator spectrum.
- Launching C96 against C95 alone would fork a toy table model before C92 and C89 define the real dependencies.

Evidence:

- C95 integration note: `AgentTasks/null-edge-c95-anti-vectorialization-integration-note-2026-06-27.md`.
- Claude review: `AgentTasks/model-calls/claude/2026-06-27-105806-c95-integration-review.md`.

Consequences:

- Add a C95-hardening task before downstream C1 use: `Spectrum.WellFormed`, an integer-index vs plus/minus-count equivalence under well-formedness, and a data-carrying imbalance witness.
- Rename or namespace C95's `C0Healthy` as toy/planning-only to avoid collision with C92's real ghost-safety API.
- Continue launching independent jobs up to about 6-8 active jobs, but do not submit hard-dependent jobs early.

Revisit if:

- C92 returns a concrete ghost API and C89 returns a regulator/removal API.
- C95 is hardened enough to serve as a safe finite witness layer rather than only a planning guardrail.
## 2026-06-27 - C97/C98 naming hardening accepted; no extra job before returns

Decision:

- Keep the C97/C98 local naming hardening.
- Do not launch another Aristotle job in cycle 9.
- Wait for C99/C93/C92/C89 returns before further C97/C98 churn.

Why:

- Claude reviewed the actual sources after hardening and judged the renames adequate.
- The remaining issue is a stale C98 docstring reference, not a semantic hazard.
- Another Aristotle job would not change the evidentiary status of C97/C98.

Evidence:

- Claude log: `AgentTasks/model-calls/claude/2026-06-27-111238-cycle9-c97-c98-hardening-review.md`.

Consequences:

- C97/C98 remain planning-only guardrails with safer names.
- C99 remains the active independent path toward a less-forgeable index substrate.
- C94 and C96 remain hard-held on C93 and C92/C89 respectively.

Revisit if:

- C99 returns and supplies a concrete finite chiral-index substrate.
- C93 returns a real overlap/GW interface.
- C92/C89 return the concrete ghost/regulator handles needed for C96.
## 2026-06-27 - Cycle 10 no-submit decision confirmed

Decision:

- Do not launch a new Aristotle job in cycle 10.
- Add an explicit grading-involution criterion to the C99 acceptance checklist.

Why:

- C99/C93/C92/C89 already cover the independent C1-adjacent axes: chiral-index substrate, overlap/GW interface, ghost safety, and regulator/removal.
- C94 and C96 are hard-dependent on active returns.
- Claude found no independent high-value job left that would not risk API forking.
- Claude identified one checklist loophole: a real finite chiral-index substrate needs a grading involution distinct from `D`, not plus/minus sectors defined by fiat.

Evidence:

- Cycle-10 note: `AgentTasks/null-edge-cycle10-finite-chiral-index-substrate-note-2026-06-27.md`.
- Claude log: `AgentTasks/model-calls/claude/2026-06-27-111618-cycle10-no-submit-review.md`.

Consequences:

- C99 should be accepted only if its strong outcome includes an explicit grading operator or involution, with sectors derived from that grading.
- Next job submission trigger is a returned C99/C93/C92+C89 result or a failed running job needing resubmission.

Revisit if:

- C99 returns without a grading involution but with a useful fallback finite branch-table substrate.
- C93 returns a concrete overlap/GW interface that changes the shape of the index witness.
## 2026-06-27 - C99b benchmark job launched

Decision:

- Submit C99b as a narrow independent finite graded-operator index benchmark.
- Keep C99 as the main substrate job, and use C99b as a benchmark/fallback only.

Why:

- Claude's cycle-12 review accepted the C99 audit template with caveat and recommended exactly one small independent job.
- C99b does not depend on C99/C93/C92/C89 and does not make C1 release claims.
- It provides a concrete artifact for evaluating whether C99 is genuinely stronger than C98's arbitrary-count toy.

Evidence:

- C99b prompt: `AgentTasks/null-edge-wave24-c99b-finite-graded-operator-index-template-aristotle-2026-06-27.md`.
- Claude log: `AgentTasks/model-calls/claude/2026-06-27-112545-cycle12-c99-audit-template-review.md`.
- Aristotle project: `309944d6-800a-4399-a2fc-3d294883ce28`.

Consequences:

- If C99 returns weakly, C99b may become the fallback finite substrate.
- If C99 returns strongly, C99b remains a benchmark/template and need not steer C1 release.

Revisit if:

- C99b duplicates C99 or returns too toy-like to be a useful benchmark.

## 2026-06-27 - Autonomous-loop cadence policy clarified

Decision:

- A future autonomous cycle should include a Claude call every cycle/round on the highest-value available subject.
- Aristotle concurrency target is now up to 15 active jobs.
- Queue saturation policy: at or above 15 active jobs with no returns, wait 10 minutes and poll again before falling back to local work.
- Stale-job policy: any Aristotle job running longer than 2 hours should be stopped/canceled if possible and continued as a no-build/prompt-only job.

Rationale:

- The prior loop interpretation counted poll/local-work cycles as complete even without new Aristotle submissions or Claude calls. The clarified policy makes cycles more external-review-heavy and keeps Aristotle throughput higher while bounding long-running build waste.
## 2026-06-27 - Gate C1 non-ultralocal branch checkpoint

Decision:

```text
Do not keep treating ultralocality as mandatory for every C1 attempt.
Introduce Gate C1_NU as a controlled non-ultralocal release target, and reserve
Gate C1_NL for explicit declared nonlocal fallback.
```

Claim boundary:

```text
C1_NU may claim one retained Weyl branch, true bad-sector inverse gap,
ghost-zero exclusion, gauge covariance/dressing, Krein-positive physical
residue, anomaly accounting at the appropriate level, regulator stability, and
path-sum/resolvent/spectral/finite-volume non-ultralocal control.

C1_NL may additionally allow declared nonlocal fallback, but must not claim
controlled non-ultralocality unless a control certificate is actually supplied.

Neither C1_NU nor C1_NL may claim finite-range locality, exponential locality,
cluster decomposition, ordinary local continuum QFT, or a gauge-invariant
quantum gauge theory unless those are separately proved.
```

Native control principle:

```text
Use combinatorial path-sum control as the primitive nonlocality certificate.
Exponential decay is only a sufficient corollary when path-count growth and
per-path damping are subcritical.
```

Immediate loop consequence:

```text
When the loop wants constructive C1 progress, prefer:
  C106_NonultralocalGateC1_API,
  C107_FiniteSpectralProjectorGaugeCovariance,
  C108_OriginBranchObservableCertificate,
  C109_NonultralocalBlockGapRelease,
  C110_PathSumControl,
  C112_DeterminantLineAnomalyContract.

When the loop wants local/no-go clarification, continue C106a/C106b origin
polarization and native-commutant work.
```

## 2026-06-27 - C1 origin-polarizer decision checkpoint

Decision:

```text
Treat Gate C1 as a native origin-polarization decision before treating it as a
release-audit assembly.
```

Concrete fork:

```text
Can the native gauge-safe origin algebra produce a Hermitian involution T0 with
nonzero chiral-index projector (1 + T0)/2?
```

If yes:

```text
Build T0 -> T_br(q,U), then prove branch-germ separation, locality or
controlled quasi-locality, gauge safety, true bad-sector inverse gap,
ghost-zero exclusion, Krein positivity, anomaly accounting, and regulator
stability.
```

If no:

```text
Native finite/local T_br and non-scalar Wilson C1 release are ruled out under
the stated assumptions. Pivot to certified projected-overlap or domain-wall
escape contracts.
```

Immediate theorem/job consequence:

```text
Submit C106a_OriginPolarizationEscapeHatch as the next independent Aristotle
job unless a completed active job is ready to integrate first.
```

## 2026-06-27 - Gemini nonlocal research integrated as audit obligations

Decision:

- Treat Gemini's nonlocal Gate C1 memo as support for the controlled
  non-ultralocal branch, not as a replacement for the repo's `C1_NU` /
  `C1_NL` distinction.
- Map external umbrella `GateC1_NL` wording to `C1_NU` when the construction
  has path-sum, resolvent, spectral-island, finite-volume, or tail-control
  data.
- Reserve `C1_NL` for explicitly declared nonlocal fallback where no controlled
  non-ultralocality certificate is claimed.

Why:

- The Gemini research reinforces that dropping ultralocality attacks a real
  Nielsen-Ninomiya assumption.
- It also reinforces that long-range kernels have historical pathologies:
  SLAC-type interacting scaling issues, Stacey/tangent zone-edge and
  normalization issues, domain-wall residual/bulk issues, and SMG
  propagator-zero ghost issues.

Consequences:

- Add SLAC/Mermin-Wagner-style tail audits, Stacey finite-volume normalization
  audits, and domain-wall bulk-to-boundary bridge requirements to the C1_NU
  plan.
- Do not claim ordinary local QFT, cluster decomposition, or quantum gauge
  consistency from a nonlocal projector without separate proofs.

Revisit if:

- A native branch observable `B(U)` passes the origin chiral-index test and the
  remaining question becomes whether its tails qualify as controlled
  `C1_NU` or only declared `C1_NL`.
