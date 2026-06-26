# NullStrand next Aristotle wave 2 - 2026-06-25

Purpose: submit a non-duplicate follow-up wave after the first next-wave proof
jobs and the roadmap-review job completed. This wave targets capstone plumbing
and API-stable finite algebra that should be useful before attempting
`MASTER-001` or `MASTER-002` directly.

Source of truth:

- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Sources/NullStrand_Lean_Theorem_Manifest_Improved.csv`
- `AgentTasks/null-strand-next-wave-2026-06-25.md`
- `AgentTasks/nullstrand-roadmap-review-report-aristotle-2026-06-25.md`

Submission rule: focused standalone packages unless a target genuinely needs the
full `PhysicsSM` import graph.

## Planned jobs

| job | lane | target |
|---|---|---|
| nullstrand-rate-positivepart-20260625 | LA-004/Bell rates | Positive-part rates recover an antisymmetric current |
| nullstrand-ent-obstruction-logic-20260625 | ENT-004 | Entangled equals no product representation in the finite abstraction |
| nullstrand-sync-commuting-powers-20260625 | SYNC-003 core | Commuting kernels make repeated two-step updates path-independent |
| nullstrand-iid-telescope-20260625 | ERG-002 | Position recursion telescopes to empirical increment average |
| nullstrand-flux-reweight-normalize-20260625 | KIN-005 | Finite flux reweighting normalizes to total mass one |
| nullstrand-fock-iterate-20260625 | BELL/Fock | Iterated marginal-preserving Fock lifts preserve marginals |
| nullstrand-lap-zero-sum-unique-20260625 | LA-003 core | Zero-sum gauge gives uniqueness of Poisson potentials |
| nullstrand-graph-support-linear-20260625 | GRAPH support | Support constraints are stable under scalar multiplication and addition |
| nullstrand-joint-marginals-20260625 | ENT/probability | Product-law marginals of any finite probability joint law are probabilities |

## Submitted projects

| project_id | job | status |
|---|---|---|
| 0f75ba72-482b-433f-aa5a-f68f3b36e314 | nullstrand-rate-positivepart-20260625 | INTEGRATED_STANDALONE |
| 085986ef-93de-4171-82ab-377f8885f5b2 | nullstrand-ent-obstruction-logic-20260625 | INTEGRATED_STANDALONE |
| ef4f0782-b521-47e4-bbdc-ce50c7ef0e27 | nullstrand-sync-commuting-powers-20260625 | INTEGRATED_STANDALONE |
| c52874f0-a74b-4c4e-9a29-6371c11f1314 | nullstrand-iid-telescope-20260625 | INTEGRATED_STANDALONE |
| 228be216-2fca-4e22-91d0-165f4b1760af | nullstrand-flux-reweight-normalize-20260625 | INTEGRATED_STANDALONE |
| af7cc60f-3641-4fb7-8d14-a13a5afd0bab | nullstrand-fock-iterate-20260625 | INTEGRATED_STANDALONE |
| 7ea6658a-d942-4f82-965d-719aabad00f3 | nullstrand-lap-zero-sum-unique-20260625 | INTEGRATED_STANDALONE |
| 463b1839-9127-4b47-99fa-3ebb795c353a | nullstrand-graph-support-linear-20260625 | INTEGRATED_STANDALONE |
| 5312d114-ee1b-4c97-826b-b8abd3766004 | nullstrand-joint-marginals-20260625 | INTEGRATED_STANDALONE |

## Local checks before submission

- `lake env lean` was run on all nine standalone target files.
- All nine files typechecked. The only warnings were the intended proof holes in
  the standalone handoff files.

## Submission notes

- Submitted with `aristotle submit --project-dir ...` one project at a time.
- Aristotle warned that the focused packages do not bundle a local `.lake`
  directory. This is expected for the focused-package pattern; the target source
  files were checked in the repo's pinned Mathlib environment before submission.

Status check after submission:

- `aristotle list --limit 12` showed four projects already `IDLE`:
  `085986ef-93de-4171-82ab-377f8885f5b2`,
  `ef4f0782-b521-47e4-bbdc-ce50c7ef0e27`,
  `af7cc60f-3641-4fb7-8d14-a13a5afd0bab`, and
  `5312d114-ee1b-4c97-826b-b8abd3766004`.
- The remaining five projects were still `RUNNING`.

## Integration notes

2026-06-25 Claude integration pass:

- All nine projects had reached `IDLE` (none still `RUNNING`). Their Aristotle
  result archives had been fetched into `AgentTasks/aristotle-output/<id>/` but
  never harvested into the repo (output dirs held the `project-files.tar.gz`
  only; the standalone skeletons still carried the intended proof holes).
- Extracted each archive to `AgentTasks/aristotle-output/<id>/extracted-tar/`.
  Every archive contained the single target file plus `ARISTOTLE_SUMMARY.md`.
- Verified each returned file before copying: placeholder/escape-hatch scan
  (`sorry`/`admit`/`axiom`/`opaque`/`unsafe`/`native_decide`) found zero matches,
  and the declaration headers (defs, structures, theorem signatures and
  hypotheses) match the submitted skeletons exactly -- proof bodies only, no
  statement weakening.
- Copied the returned proofs over the nine standalone source files under
  `AgentTasks/aristotle-standalone/`.
- Typechecked all nine in place against the repo's pinned Mathlib:
  `lake env lean AgentTasks/aristotle-standalone/<dir>/<File>.lean` -> exit 0 for
  all nine, no warnings.
- These remain `INTEGRATED_STANDALONE`: the verified proofs now live in the
  standalone packages. Promotion into the live trusted `PhysicsSM/NullStrand`
  tree is a separate per-node semantic-review decision (same staging policy used
  for the first next-wave batch), not done in this pass.

Verified target files:

- `nullstrand-ent-obstruction-logic-20260625/NullStrandEntObstructionLogic.lean` (ENT-004)
- `nullstrand-sync-commuting-powers-20260625/NullStrandSyncCommutingPowers.lean` (SYNC-003 core)
- `nullstrand-fock-iterate-20260625/NullStrandFockIterate.lean` (BELL/Fock iterate)
- `nullstrand-joint-marginals-20260625/NullStrandJointMarginals.lean` (ENT/probability)
- `nullstrand-rate-positivepart-20260625/NullStrandRatePositivePart.lean` (LA-004/Bell rates)
- `nullstrand-iid-telescope-20260625/NullStrandIIDTelescope.lean` (ERG-002)
- `nullstrand-flux-reweight-normalize-20260625/NullStrandFluxReweightNormalize.lean` (KIN-005)
- `nullstrand-lap-zero-sum-unique-20260625/NullStrandLapZeroSumUnique.lean` (LA-003 core)
- `nullstrand-graph-support-linear-20260625/NullStrandGraphSupportLinear.lean` (GRAPH support)
