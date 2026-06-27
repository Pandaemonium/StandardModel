# Aristotle queue

Track submitted, running, returned, integrated, and proposed Aristotle jobs.

Template:

```text
## JOB-ID - Short title

Status: proposed | submitted | running | returned | integrated | abandoned
Project ID: ...
Task ID: ...
Target: ...
Submitted: YYYY-MM-DD
Integrated: YYYY-MM-DD or n/a

Purpose:
- ...

Acceptance criteria:
- ...

Semantic review notes:
- ...
```

## Known active jobs from prior state

These should be checked at the start of the next loop:

```text
C85  project 1dfb54b3-030c-4bf4-a732-7b0356cc9e78  target PhysicsSM/Draft/NullEdgeRAWilsonGap.lean
C82  project 893fe869...                              status previously in progress
C76  project 13131a2b...                              status previously in progress
C72  project b34c82a7...                              status previously in progress
C70  project e3986d7f...                              status likely in progress
FUR-G1/G3 projects 2ccea9b0... and 6e18cb1e...        status running
FUR-H10 project 40b43a57...                           status running
```

## Proposed next jobs

- C89: instantiate Wilson positivity/API against the concrete RA-Wilson
  null-edge doubled symbol.
- C90: harden projected Gate C Wilson release naming, ghost-safety, and
  regulator-moduli predicates.
- C91: C1 route design after taste-only origin no-go, focused on
  Weyl/domain-wall/overlap/spinor-line options.
- H10/H11 follow-up: first forbidden-operator theorem for LegalFiniteDirac.

## C85 - RA-Wilson accretive gap

Status: integrated
Project ID: `1dfb54b3-030c-4bf4-a732-7b0356cc9e78`
Task ID: `0aa02112-c2ae-4c77-95a4-628bfc433fba`
Target: `PhysicsSM/Draft/NullEdgeRAWilsonGap.lean`
Submitted: 2026-06-27
Integrated: 2026-06-27

Purpose:

- Prove anti-Hermitian plus positive scalar Wilson mass gives a C0 gap/no-kernel
  statement.

Semantic review notes:

- Abstract C0 theorem only. Needs concrete instantiation before claiming
  concrete RA-Wilson species health.

## C72 - Projected Gate C Wilson release API

Status: integrated
Project ID: `b34c82a7-383c-4325-9eaa-62a0d3ef7f37`
Task ID: `3772d7e7-61c1-411e-aea0-5309f795a074`
Target: `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`
Submitted: 2026-06-27
Integrated: 2026-06-27

Purpose:

- Package projected/Wilson-regulated release predicates for `D_phys`.

Semantic review notes:

- Conditional API-level theorem. Does not release bare `D_+`.

## FUR-H10 - prior narrow Furey/Krein job

Status: out_of_budget
Project ID: `40b43a57-f6c6-4f66-ab48-54e377697bc9`
Task ID: `9d978e3d-edc1-4dc8-901a-50ca945a6aad`
Target: unknown from this loop
Submitted: 2026-06-26
Integrated: n/a

Semantic review notes:

- Aristotle reports `OUT_OF_BUDGET`; do not treat as a completed result.
- Needs narrower resubmission or explicit abandonment if still strategically
  important.

## H9 - Gate H legal finite Dirac forbidden-operator plan

Status: integrated
Project ID: `bb0f0b19-c217-4f4e-847b-1c21c519d81a`
Task ID: `df8dda5a-30f9-4c1f-b54f-cb64e4801f3b`
Target: `AgentTasks/null-edge-gate-h-legal-finite-dirac-forbidden-operator-plan.md`
Integrated: 2026-06-27

Semantic review notes:

- Report-only plan. It is useful for Gate H legal finite Dirac work, not Gate C
  external branch control.

## C88 - Taste-only origin polarization no-go

Status: integrated
Project ID: `24a82837-d7e3-4d2f-b95a-8e9b730d3332`
Task ID: `8c58bc20-558e-4997-87cf-51e7d01503ea`
Target: `PhysicsSM/Draft/NullEdgeTasteOnlyOriginNoGo.lean`
Integrated: 2026-06-27

Semantic review notes:

- Rules out taste-only scalar origin polarization. It points C1 toward
  spinor-line, Weyl, domain-wall, or overlap structure.

## C86 - Gate C0 species-health release API from RA-Wilson

Status: integrated
Project ID: `a1c44f87-c498-4223-b017-b6f7dbb9f13f`
Task ID: `ce8e876c-f76d-413b-aec9-dca2be8ad663`
Target: `PhysicsSM/Draft/NullEdgeGateC0SpeciesHealth.lean`
Integrated: 2026-06-27

Semantic review notes:

- C0-only. Explicitly does not imply `GateC1ChiralPhysicalRelease`.

## C87 - Gate C0/C1 split audit

Status: integrated
Project ID: `8c3edc7c-c72a-4c55-9192-39b5f242da0f`
Task ID: `8f513d28-d498-41fc-9c5e-a79cdefe83f2`
Target: `AgentTasks/null-edge-gate-c0-c1-split-audit-report.md`
Integrated: 2026-06-27

Semantic review notes:

- Verdict: split-valid-but-C1-needed-for-SM.

## C80 - Regulator legality API

Status: integrated
Project ID: `a59f4a9d-9480-47dd-9775-7dd990e8141d`
Task ID: `b3d08dbd-7eea-4b98-8c82-39dc58f8e359`
Target: `PhysicsSM/Draft/NullEdgeRegulatorLegalityAPI.lean`
Integrated: 2026-06-27

Semantic review notes:

- Abstract no-irrelevant-repair API. Useful guardrail against treating
  non-origin Wilson lifting as origin chirality repair.

## C83 - Taste involution origin polarization audit

Status: integrated
Project ID: `04ee30a0-0058-4b7f-b525-ee2a30e4836c`
Task ID: `469e0f4a-10c0-4b14-a19b-3d7ad06a3757`
Target: `AgentTasks/null-edge-taste-involution-origin-polarization-audit.md`
Integrated: 2026-06-27

Semantic review notes:

- Report-only audit. Verdict: likely-needs-auxiliary-layer. It supports the C88
  no-go and the move from taste-only branch dressing toward Weyl/domain-wall or
  overlap-style C1 mechanisms.

## C84 - Gate C v4 regulator-legal release contract

Status: integrated
Project ID: `10f74338-940c-4335-8a90-280a6b1b09e1`
Task ID: `217995da-fa39-4973-8bb5-4320fdd387d2`
Target: `PhysicsSM/Draft/NullEdgeRegulatorLegalGateCRelease.lean`
Integrated: 2026-06-27

Semantic review notes:

- Contract/API module. It records lift, origin purity, ghost, Krein, gauge, and
  counterterm clauses. It does not prove any concrete null-edge operator
  satisfies the contract.

## C83/C84 - download friction resolved

Status: integrated
Project IDs: `04ee30a0-0058-4b7f-b525-ee2a30e4836c`,
`10f74338-940c-4335-8a90-280a6b1b09e1`
Integrated: 2026-06-27

Semantic review notes:

- Initial download attempts hit Aristotle's service-side "too many projects in
  progress" error. Retry succeeded during the second autonomous-loop cycle.

## C76 - reviewed no-op full-repo package

Status: reviewed_no_changes
Project ID: `13131a2b-6428-440b-9372-decd7603a608`
Target: historical full-repo context package
Reviewed: 2026-06-27

Semantic review notes:

- Current `aristotle list --limit 40` showed C76 as `IDLE` rather than running.
- `Scripts/aristotle/integrate_completed.py 13131a2b-6428-440b-9372-decd7603a608`
  downloaded and inspected the package.
- The helper found many candidate files, but all reported `diff stats: +0 / -0
  lines` and unchanged theorem/lemma signatures.
- Apply was blocked because an unchanged draft context file contains a proof
  placeholder. No new repo files were copied.
- Treat this project as reviewed/no-op for the null-edge loop unless a later
  manual audit identifies a missing report not surfaced by the helper.

## C89 - Concrete RA-Wilson C0 instantiation

Status: submitted
Project ID: `f481d8f1-4995-4b05-bfbc-398ca9b6810b`
Task ID: n/a
Target: `PhysicsSM/Draft/NullEdgeRAWilsonConcrete.lean`
Prompt path:
`AgentTasks/null-edge-wave21-c89-rawilson-concrete-instantiation-aristotle-2026-06-27.md`

Purpose:

- Convert C85/C86 from abstract C0 schema to concrete null-edge RA-Wilson C0
  evidence.

Acceptance criteria:

- Instantiate the anti-Hermitian doubled block, identify the Wilson mass
  function, address C64 off-branch zeros, and preserve C0-not-C1 language.

## FUR-G1 - octonion Q_op to occupation-spectrum bridge

Status: canceled
Project ID: `2ccea9b0-9781-4994-9a96-8a258303efed`
Original task ID: `aff5c1a0-e708-4c45-bebf-3449cd2fbcc1`
Replacement task ID: `485db072-d371-457a-a1e5-0f5d36d8eb4e`
Canceled: 2026-06-27
Target: `PhysicsSM/Draft/NullEdgeFureyOctonionBridge.lean`

Semantic review notes:

- Original task was already `CANCELED`; the replacement "return partial/no-build"
  task was still `IN_PROGRESS`.
- Canceled because it was not on the Gate C0/C1 critical path and had become
  long-running friction.
- Can be resubmitted later as a narrower Gate H bridge if needed.

## FUR-G3 - null-edge/Furey involution distinctness

Status: canceled
Project ID: `6e18cb1e-59ce-4150-83ca-1943c667287c`
Task ID: `193cb6d9-18e2-4c35-89c6-a736408bf47d`
Canceled: 2026-06-27
Target: `PhysicsSM/Draft/NullEdgeInvolutionDistinctness.lean`

Semantic review notes:

- Canceled after roughly 11 hours running.
- Useful guardrail idea, but not decisive for current C89/C90 Gate C path.
- Can be recreated later as a small local/docs module or a narrower Aristotle
  job if involution-confusion friction recurs.

## C90 - Projected Gate C Wilson release hardening

Status: submitted
Project ID: `d53724a6-a0aa-4f8a-9c85-5285177fd16b`
Task ID: n/a
Target: `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`
Prompt path:
`AgentTasks/null-edge-wave21-c90-projected-gate-c-wilson-hardening-aristotle-2026-06-27.md`

Purpose:

- Reduce C72 overclaim risk by hardening names, ghost-safety predicates, and
  regulator-moduli audit structure.

Acceptance criteria:

- Avoid bare `GateCReleased` ambiguity, separate BRST/Krein/ghost-zero clauses,
  and add explicit not-bare-release guardrails.

## Wave 21 next C1-facing jobs after C89/C90

Status: proposed
Recorded: 2026-06-27

Purpose:

- Keep the queue from drifting into a third C0-polish wave after C89/C90.

Proposed jobs:

- C92: Golterman-Shamir ghost predicate API separating scalar residue positivity
  from gauge-coupled ghost-zero safety.
- C93: overlap / Ginsparg-Wilson interface for a genuine C1 route.
- C94: domain-wall null-edge interface and boundary-mode anti-vectorialization
  obligations.
- C95: anti-vectorialization check inspired by the single-curved-surface Weyl
  warning.

Preferred first C1 job:

- C93 `PhysicsSM/Draft/NullEdgeOverlapC1Interface.lean`.

Semantic review notes:

- These jobs should be explicitly C1-facing.
- C89 and C90 remain useful, but C90 is hygiene and should not consume the next
  wave by itself.
## C93 - Overlap / Ginsparg-Wilson C1 interface

Status: submitted
Project ID: `6ff32d74-0779-424b-b8a2-9d767251c3ea`
Target: `PhysicsSM/Draft/NullEdgeOverlapC1Interface.lean`
Prompt path:
`AgentTasks/null-edge-wave22-c93-overlap-ginsparg-wilson-interface-aristotle-2026-06-27.md`
Submitted: 2026-06-27

Purpose:

- Define a Lean-level C1 interface for an overlap/Ginsparg-Wilson route without
  claiming release.

Semantic review notes:

- Claude says C93 is correct only if it includes non-release, index-slot,
  kernel-gap-hypothesis, anti-vectorialization, and C0-not-C1 guardrails.
- Audit returned output against
  `AgentTasks/null-edge-c93-overlap-interface-audit-template-2026-06-27.md`.

## C92 - Golterman-Shamir ghost-safety API

Status: submitted
Project ID: `03c6e63f-3a39-420e-81d3-173f2611b362`
Target: `PhysicsSM/Draft/NullEdgeGateCGhostSafetyAPI.lean`
Prompt path:
`AgentTasks/null-edge-wave22-c92-golterman-shamir-ghost-safety-api-aristotle-2026-06-27.md`
Submitted: 2026-06-27

Purpose:

- Define a ghost-safety API that prevents scalar residue positivity, Krein
  positivity, exact chirality, or C0 species health from being cited as full
  Golterman-Shamir safety.

Semantic review notes:

- Claude says C92 is useful only if it returns concrete non-implication
  witnesses/countermodels, not merely opaque Prop fields.
- Audit against
  `AgentTasks/null-edge-c92-ghost-safety-countermodel-plan-2026-06-27.md`.
## 2026-06-27 cycle 4

- C90 `d53724a6-a0aa-4f8a-9c85-5285177fd16b`: returned `IDLE`; integration helper initially missed the payload. Raw `aristotle tasks` summary reports a hardening of `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`. The downloadable archive omitted that target file, so the C90 API hardening was reconstructed manually from the task summary.
- C95 `406dd6b0-7866-419b-8dbc-e29c758fe5e9`: submitted. Target: finite anti-vectorialization guardrail with an explicit C0-healthy vectorlike countermodel and a nonzero-index discriminator.
- C94 remains hard-dependent on C93 and is packetized locally only.
## 2026-06-27 cycle 5

- C96: drafted but held after Claude review. Regulator-removal stability is scientifically real, but the current abstract API risks a fake theorem reducible to modus ponens. Hold until C92/C95 provide concrete finite table APIs.
- C97 `789e2eab-7432-4558-af5a-c757cf43512b`: submitted prompt-only. Target: repair/validate the reconstructed C90 hardening of `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`. A full `--project-dir .` submission failed because Aristotle rejects the local `SpherePacking` dependency.
## 2026-06-27 cycle 6

- No new active returned jobs were ready for integration.
- C98 `c2133e78-9c1a-4336-b3b3-d1a8330c34c6`: submitted. Target: finite guardrail showing interface shape alone does not imply a chiral index witness; should return a concrete interface-shaped zero-index countermodel and a concrete interface-shaped nonzero-index witness.
## C95 - Anti-vectorialization planning guardrail

Status: integrated manually from Aristotle archive
Project ID: `406dd6b0-7866-419b-8dbc-e29c758fe5e9`
Target: `PhysicsSM/Draft/NullEdgeAntiVectorializationGuardrail.lean`
Integrated: 2026-06-27

Result:

- Added a finite `Spectrum` bookkeeping API with `VectorlikeSpectrum`, `C0Healthy`, `AntiVectorlikeWitness`, and concrete C0-healthy vectorlike / anti-vectorlike examples.
- Proved the planning guardrail that nonzero index forbids the finite vectorlike involution.

Adversarial review:

- Claude says C95 is useful as a planning guardrail, not as a C1 release substrate.
- Required hardening before downstream C1 use: well-formed chirality signs, nonzero multiplicity discipline or explicit convention, integer-vs-Nat witness equivalence, data-carrying imbalance witness, and toy naming for `C0Healthy`.

Follow-up status:

- C96 remains held pending C92 and C89.
- A C95-hardening micro-task is a good independent follow-up if the queue has room.
## C97 - C90 Wilson-release hardening repair/validation

Status: integrated
Project ID: `789e2eab-7432-4558-af5a-c757cf43512b`
Target: `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`
Integrated: 2026-06-27

Result:

- Returned a self-contained finite `GaugeData` implementation of the C90 Wilson-release predicate shape.
- Integrated as planning-only / predicate-shape infrastructure.
- Claude flagged `PostGaugeResiduePositive.toGoltermanShamirSafe_trivialBRST` as a naming hazard because it produces `BRST := True`.

## C98 - Interface shape vs chiral index witness guardrail

Status: integrated
Project ID: `c2133e78-9c1a-4336-b3b3-d1a8330c34c6`
Target: `PhysicsSM/Draft/NullEdgeChiralIndexWitnessGuardrail.lean`
Integrated: 2026-06-27

Result:

- Added an `InterfaceToy` countermodel showing interface shape alone does not imply nonzero chiral index.
- Claude accepted it as planning-only and recommended an operator-theoretic substrate next.

## C99 - Finite operator-theoretic chiral index substrate

Status: submitted
Project ID: `4fd2e530-eb89-4e94-83c1-dc97b254e0c4`
Target: `PhysicsSM/Draft/NullEdgeFiniteChiralIndexSubstrate.lean`
Prompt path: `AgentTasks/null-edge-wave24-c99-finite-chiral-index-substrate-aristotle-2026-06-27.md`
Submitted: 2026-06-27

Dependency class:

- Independent.

Purpose:

- Replace C98's forgeable `InterfaceToy` with a finite substrate where index values are computed from actual finite state/operator data rather than arbitrary plus/minus count fields.
## C99b - Finite graded-operator chiral-index benchmark

Status: returned_payload_missing
Project ID: `309944d6-800a-4399-a2fc-3d294883ce28`
Task ID: `35587dfb-4bc1-4ac6-b5f6-83ebbdc1cf2b`
Target: `PhysicsSM/Draft/NullEdgeFiniteGradedOperatorIndexTemplate.lean`
Prompt path: `AgentTasks/null-edge-wave24-c99b-finite-graded-operator-index-template-aristotle-2026-06-27.md`
Submitted: 2026-06-27
Reviewed: 2026-06-27

Dependency class:

- Independent.

Purpose:

- Provide a small finite graded-operator benchmark/fallback for C99.
- Counts/index must be derived from finite states and a grading/operator relation, not arbitrary count fields.

Non-goals:

- No C1 release, ghost-zero safety, regulator-removal stability, overlap/GW release, domain-wall release, anomaly cancellation, or physical anti-vectorialization.

Integration notes:

- Aristotle reported completion and summarized a candidate module.
- The local output contained no project-files archive or candidate Lean file, so
  nothing was faithfully integrated.
## C99 - Finite chiral-index substrate

Status: integrated as fallback/planning substrate
Project ID: `4fd2e530-eb89-4e94-83c1-dc97b254e0c4`
Target: `PhysicsSM/Draft/NullEdgeFiniteChiralIndexSubstrate.lean`
Integrated: 2026-06-27

Review status:

- Useful improvement over C98 because counts are derived from `(D, chirality)` rather than arbitrary fields.
- Not strong C99: no explicit grading involution, no D/Gamma compatibility, basis-label sectors only, coordinate-basis kernel only, and n a t i v e _ d e c i d e in headline examples.

## C99-v2 - Grading-involution chiral-index substrate

Status: returned_payload_missing
Project ID: `b97de9d7-3661-4feb-a8b6-0e138bb597b5`
Task ID: `60506b55-ad7a-4690-8336-6db840c04440`
Target: `PhysicsSM/Draft/NullEdgeFiniteGradingInvolutionIndex.lean`
Prompt path: `AgentTasks/null-edge-wave24-c99-v2-grading-involution-substrate-aristotle-2026-06-27.md`
Submitted: 2026-06-27
Reviewed: 2026-06-27

Dependency class:

- Independent.

Purpose:

- Upgrade C99 with explicit Gamma, Gamma^2, D/Gamma compatibility, eigenspace-derived sectors, and non-native trusted index examples if feasible.

Integration notes:

- Aristotle reported completion and summarized a candidate module.
- The local output contained no project-files archive or candidate Lean file, so
  nothing was faithfully integrated.

## Wave 25 - Lateral-analysis Aristotle round

Status: submitted
Submitted: 2026-06-27
Submission project: `AgentTasks/aristotle-submit/null-edge-wave25-lateral-analysis-20260627-project`
Context pack: `AgentTasks/context-packs/null-edge-wave25-lateral-analysis-20260627-114614.md`

Purpose:

- Convert the new lateral analysis into focused Aristotle jobs around finite
  mixedness, finite weighted-measure Pluecker identities, a higher Pluecker
  obstruction ladder, Gate C branch-locus/physical-sector alternatives, and
  Gate H forbidden-operator/neutrino stress tests.

## P15 - Pluecker mass as finite density-matrix mixedness

Status: integrated
Project ID: `56e5e922-f4bb-43b0-9a3d-6df24099661a`
Task ID: `b52ad67c-be91-4377-9d85-6d227bffe6a9`
Target: `PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean`
Prompt path: `AgentTasks/null-edge-wave25-p15-mixedness-density-theorem-aristotle-2026-06-27.md`
Initial status: project `RUNNING`, task `QUEUED`.
Integrated: 2026-06-27

Purpose:

- Harden the finite density-matrix/mixedness reading of the Pluecker mass
  theorem and record exact theorem names or missing next theorem targets.

Integration notes:

- Added `normalizedVisibleDensity_trace` and clarified the finite
  density-matrix claim boundary.

## P16 - Finite weighted-measure Pluecker theorem

Status: submitted
Project ID: `8dbe5125-d0e9-4c8f-a7c4-ab2ca98550da`
Task ID: `749797a7-a2f5-4d93-86ee-6e46b20e7d08`
Target: `PhysicsSM/Draft/NullEdgeMeasurePluckerApproximation.lean`
Prompt path: `AgentTasks/null-edge-wave25-p16-weighted-measure-plucker-aristotle-2026-06-27.md`
Initial status: project `RUNNING`, task `QUEUED`.

Purpose:

- Prove a finite positive-weight proxy for the proposed measure-valued null-dust
  Pluecker theorem.

## P17 - Pluecker hierarchy / higher obstruction ladder

Status: submitted
Project ID: `3c535234-4b61-414c-b004-f7202be553d6`
Task ID: `be7cfcbd-843e-4a14-bde8-2470fff7af34`
Target: `PhysicsSM/Draft/NullEdgePluckerHierarchyAristotle.lean`
Prompt path: `AgentTasks/null-edge-wave25-p17-plucker-hierarchy-aristotle-2026-06-27.md`
Initial status: project `RUNNING`, task `IN_PROGRESS`.

Purpose:

- Build a finite hierarchy API for higher Cauchy-Binet/Pluecker obstruction
  diagnostics without claiming particle-count predictions.

## C100 - Gate C branch locus and release alternatives

Status: integrated
Project ID: `fe79fdc5-e44f-420d-bdda-8e509ea66819`
Task ID: `e7c5f428-3b83-4e56-a0b9-1cb14c5e4fd0`
Target: `PhysicsSM/Draft/NullEdgeBranchLocusPhysicalSectorAPI.lean`
Prompt path: `AgentTasks/null-edge-wave25-c100-branch-locus-sheaf-alternatives-aristotle-2026-06-27.md`
Initial status: project `RUNNING`, task `QUEUED`.
Integrated: 2026-06-27

Purpose:

- Recast Gate C as branch-locus/kernel-sheaf/physical-sector data and separate
  scalar C0 lifting from C1 branch-line release alternatives.

Integration notes:

- Added a C1-facing branch-locus/physical-sector API with explicit
  non-implication guardrails and matrix-valued spinor-line Wilson design slots.

## H11 - Forbidden finite operators and neutrino stress-test audit

Status: lean_skeleton_integrated_report_missing
Project ID: `29b72890-a3d1-4474-a39f-bafa4e07c0f2`
Task ID: `ff3b3c1c-ef80-45f6-b88c-47449c60744a`
Target: `AgentTasks/null-edge-gate-h-forbidden-operator-neutrino-audit.md`
Prompt path: `AgentTasks/null-edge-wave25-h11-forbidden-operator-neutrino-audit-aristotle-2026-06-27.md`
Initial status: project `RUNNING`, task `IN_PROGRESS`.
Integrated: 2026-06-27

Purpose:

- Separate gauge-only, `J_F`/order-one, and ideal-compatibility reasons for
  forbidden blocks, with neutrinos treated as a branchable stress test.

Integration notes:

- Integrated the returned Lean skeleton
  `PhysicsSM/Draft/NullEdgeLegalFiniteDiracNeutrinoAudit.lean`.
- The requested Markdown audit report was not present in the downloaded project
  files, so it remains missing rather than reconstructed.

## Wave 26 - Gate C branch-release literature round

Status: submitted
Submitted: 2026-06-27
Submission project: `AgentTasks/aristotle-submit/null-edge-wave26-gate-c-branch-release-20260627-project`
Context pack: `AgentTasks/context-packs/null-edge-wave26-gate-c-branch-release-20260627-121710.md`
Literature memo: `AgentTasks/null-edge-gate-c-neo4j-lit-lateral-analysis-2026-06-27.md`

Search/tooling note:

- Neo4j MCP is reachable.
- `SHOW FULLTEXT INDEXES` returned no native full-text indexes.
- Vector indexes `paper_embedding`, `paper_chunk_embedding`, and
  `ne_chunk_embedding` are online.
- Semantic paper full-text search is available via
  `Scripts/lit/neo4j_paper_search.py --chunks`.

Purpose:

- Use the literature pass to push Gate C from broad branch-topology framing into
  concrete theorem obligations: C0 closeout, direct-overlap singular crossing,
  scalar origin no-go, branch classifier data, and release-datum/domain-wall
  audit.

## C101 - C0 scalar-Wilson gap closeout

Status: submitted
Project ID: `cfaa6a95-5c5c-4a10-8363-c191163a7d0b`
Task ID: `ad8f8170-89cf-4aa9-a56d-0416819b45e6`
Target: `PhysicsSM/Draft/NullEdgeC0ScalarWilsonGapCloseout.lean`
Prompt path: `AgentTasks/null-edge-wave26-c101-c0-scalar-wilson-gap-closeout-aristotle-2026-06-27.md`
Initial status: project `RUNNING`, task `QUEUED`.

Purpose:

- Bank the anti-Hermitian plus positive scalar Wilson gap theorem as C0 only.

## C102 - Direct-overlap singular-crossing theorem

Status: submitted
Project ID: `1af1a6a5-d795-4321-9153-e16b88a2ff69`
Task ID: `f6d9c1f1-a160-4545-a551-706a5b18855a`
Target: `PhysicsSM/Draft/NullEdgeDirectOverlapSingularCrossing.lean`
Prompt path: `AgentTasks/null-edge-wave26-c102-direct-overlap-singular-crossing-aristotle-2026-06-27.md`
Initial status: project `RUNNING`, task `QUEUED`.

Purpose:

- Formalize the conditional hazard that an unwanted zero branch crossing the
  shifted Wilson mass shell makes direct unprojected overlap singular.

## C103 - Scalar-origin balanced-kernel no-go

Status: submitted
Project ID: `b2361c23-fde0-4d07-9a03-4c9e37f5cc6d`
Task ID: `72769d93-323c-4ec7-a2b7-68db506a5f68`
Target: `PhysicsSM/Draft/NullEdgeScalarOriginBalancedKernelNoGo.lean`
Prompt path: `AgentTasks/null-edge-wave26-c103-scalar-origin-balanced-kernel-no-go-aristotle-2026-06-27.md`
Initial status: project `RUNNING`, task `QUEUED`.

Purpose:

- Generalize the scalar Wilson no-go: origin-vanishing scalar deformations
  preserve a balanced origin kernel, while nonzero scalars remove the origin
  mode rather than selecting one Weyl line.

## C104 - Branch classifier API

Status: submitted
Project ID: `054ff61b-1271-432f-ae14-bde0a03b77e4`
Task ID: `722c441f-cc78-49ba-b066-b58a1b973f1a`
Target: `PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean`
Prompt path: `AgentTasks/null-edge-wave26-c104-tbr-branch-classifier-api-aristotle-2026-06-27.md`
Initial status: project `RUNNING`, task `QUEUED`.

Purpose:

- Define the `T_br` / `Pi_br` branch classifier fork and guard against
  taste-only or scalar-on-origin substitutes.

## C105 - Release datum and domain-wall/projected-overlap audit

Status: submitted
Project ID: `c633c689-2dd4-4748-97fd-869802a471eb`
Task ID: `bcf75a14-3044-4f9a-851c-bec41c1d21ec`
Target: `AgentTasks/null-edge-gate-c-release-datum-domain-wall-audit.md`
Prompt path: `AgentTasks/null-edge-wave26-c105-release-datum-domain-wall-audit-aristotle-2026-06-27.md`
Initial status: project `RUNNING`, task `QUEUED`.

Purpose:

- Produce a route audit comparing raw overlap, projected overlap, spinor-line
  Wilson, domain-wall/boundary, and controlled quasi-local projector releases.
