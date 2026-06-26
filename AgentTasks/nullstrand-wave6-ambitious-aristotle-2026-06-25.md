# NullStrand wave 6 ambitious Aristotle jobs - 2026-06-25

Purpose: submit a large, high-impact follow-up wave after integrating the
completed wave-5 Lean outputs. This wave targets capstone-level finite
NullStrand structure rather than isolated helper lemmas.

Source of truth:

- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Sources/NullStrand_Open_Questions_For_Frontier_Models.md`
- `Sources/Plucker_Sorkin_Exterior_History_Theorem.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- Integrated wave-5 modules under `PhysicsSM/NullStrand/`

Submission package:

```text
AgentTasks/aristotle-submit/nullstrand-wave6-ambitious-20260625-project
```

## Planned jobs

| job | lane | target |
|---|---|---|
| nullstrand-wave6-superdirac-square-20260625 | Graph / super-Dirac | Trusted finite `Graph.SuperDirac` API with grading, odd support, square support, block projections, and a nontrivial square theorem |
| nullstrand-wave6-exterior-cauchy-binet-20260625 | Histories / exterior mass | Strengthen general exterior-rank capacity toward finite Cauchy-Binet/minor expansion and bridge it to grade-2 Plucker/Sorkin mass |
| nullstrand-wave6-selected-step-invariance-20260625 | Selected dynamics | Build a discrete-time least-action step from the generator and prove row-stochasticity plus invariant uniform law under a precise step-size hypothesis |
| nullstrand-wave6-checkerboard-history-law-20260625 | Checkerboard master | Connect strengthened null checkerboard shifts to the trajectory measure layer and produce a stronger non-vacuity/history-law theorem |
| nullstrand-wave6-fock-bell-capstone-20260625 | Fock/Bell | Assemble direction-marginal preservation, block support, and minimal jump rates into a reusable Bell/Fock capstone theorem |
| nullstrand-wave6-audit-automation-recovery-20260625 | G0/G1 audit | Recover the missing script-layer audit automation as patchable files, with manifest reconciliation and capstone assumption reporting |

## Submitted projects

| project_id | job | status |
|---|---|---|
| 1f88edab-474b-47b8-93da-511f2a8cdba9 | nullstrand-wave6-superdirac-square-20260625 | submitted |
| 3c35a56d-176e-4668-8c1d-b01727ce82af | nullstrand-wave6-exterior-cauchy-binet-20260625 | submitted |
| 82df0d52-4e55-4053-b2a7-5bff7d5bcd92 | nullstrand-wave6-selected-step-invariance-20260625 | integrated |
| 4958845e-a476-4872-9924-1ed03eae16e9 | nullstrand-wave6-checkerboard-history-law-20260625 | submitted |
| ec7619d7-652f-4416-89e4-61fdb2d573cc | nullstrand-wave6-fock-bell-capstone-20260625 | submitted |
| 6912a0f0-f134-4b42-b4d6-b00e36bfeb48 | nullstrand-wave6-audit-automation-recovery-20260625 | submitted |

## Aristotle metadata

```yaml
aristotle:
  wave: nullstrand-wave6-ambitious-20260625
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave6-ambitious-20260625-project
  output_dir_pattern: AgentTasks/aristotle-output/<project-id>
  projects:
    - project_id: 1f88edab-474b-47b8-93da-511f2a8cdba9
      job: nullstrand-wave6-superdirac-square-20260625
      target_file: PhysicsSM/NullStrand/Graph/SuperDirac.lean
      expected_module: PhysicsSM.NullStrand.Graph.SuperDirac
      status: submitted
    - project_id: 3c35a56d-176e-4668-8c1d-b01727ce82af
      job: nullstrand-wave6-exterior-cauchy-binet-20260625
      target_file: PhysicsSM/NullStrand/Histories/ExteriorRankMeasure.lean
      expected_module: PhysicsSM.NullStrand.Histories.ExteriorRankMeasure
      status: submitted
    - project_id: 82df0d52-4e55-4053-b2a7-5bff7d5bcd92
      job: nullstrand-wave6-selected-step-invariance-20260625
      target_file: PhysicsSM/NullStrand/NullLift/FiniteLeastAction.lean
      expected_module: PhysicsSM.NullStrand.NullLift.FiniteLeastAction
      status: integrated
    - project_id: 4958845e-a476-4872-9924-1ed03eae16e9
      job: nullstrand-wave6-checkerboard-history-law-20260625
      target_file: PhysicsSM/NullStrand/Master/Checkerboard.lean
      expected_module: PhysicsSM.NullStrand.Master.Checkerboard
      status: submitted
    - project_id: ec7619d7-652f-4416-89e4-61fdb2d573cc
      job: nullstrand-wave6-fock-bell-capstone-20260625
      target_file: PhysicsSM/NullStrand/BellQFT/Capstone.lean
      expected_module: PhysicsSM.NullStrand.BellQFT.Capstone
      status: submitted
    - project_id: 6912a0f0-f134-4b42-b4d6-b00e36bfeb48
      job: nullstrand-wave6-audit-automation-recovery-20260625
      target_file: Scripts/check_nullstrand_manifest.py
      expected_module: nullstrand_audit_scripts
      status: submitted
```

## Local checks before submission

- `lake build PhysicsSM.NullStrand.ZigZag.LatticeBeable`
- `lake build PhysicsSM.NullStrand.Master.Checkerboard`
- `lake build PhysicsSM.NullStrand.Master.FiniteModel`
- `lake build PhysicsSM.NullStrand.BellQFT.FiniteCurrent`
- `lake build PhysicsSM.NullStrand.BellQFT.MinimalJumpRates`
- `lake build PhysicsSM.NullStrand.BellQFT.FockCutoff`
- `lake build PhysicsSM.NullStrand.ZigZag.TransferCurrent`
- `lake build PhysicsSM.NullStrand.ZigZag.MinimalRates`
- `lake build PhysicsSM.NullStrand.Histories.ExteriorMassMeasure`
- `lake build PhysicsSM.NullStrand.Histories.ExteriorRankMeasure`
- `lake build PhysicsSM.NullStrand.NullLift.FiniteLeastAction`
- `lake env lean PhysicsSM/NullStrand/Audit/DuplicateNames.lean`
- `lake env lean PhysicsSM/NullStrand.lean`

## Submission instructions common to all jobs

- Preserve semantic boundaries: finite algebra in trusted modules, speculative
  interpretation in comments or task reports.
- Do not weaken existing public theorem statements.
- If a requested capstone is not yet well posed, return the smallest corrected
  theorem statement and exact missing API rather than proving a weaker claim
  under the same name.
- Return patchable files and a compact completion report listing solved
  statements, changed public names, remaining blockers, and any assumptions.

## Integration notes

2026-06-26 Claude integration pass:

- `82df0d52` (nullstrand-wave6-selected-step-invariance, LA-006) **integrated and
  verified** into the live trusted module
  `PhysicsSM/NullStrand/NullLift/FiniteLeastAction.lean`.
- The returned full-repo archive's diff against the current working tree was
  **purely additive** (`+197 / -0`, a single hunk appended after
  `leastActionGenerator_rate_equivariant`), so the returned file was a clean
  superset of the existing local state; no existing public statement changed.
- New section "Selected discrete-time step: least-action transition matrix
  (LA-006)": `leastActionStep` (`= I - t • L`), `leastActionPush`, plus
  `weightedLaplacian_diag`, `leastActionGenerator_rate_diag`, entrywise/Laplacian
  forms, row-sum and column-sum (doubly-stochastic) lemmas, off-diagonal and full
  nonnegativity under the exact step-size hypothesis (`0 ≤ t` and
  `∀ i, t * G.degree i ≤ 1`), constant/uniform invariance (single step + every
  finite iterate), total-mass conservation, and graph-automorphism equivariance.
  All finite matrix algebra, no analytic assumptions.
- Placeholder scan: no `sorry`/`admit`/`axiom`/`opaque`/`unsafe`/`native_decide`
  in the added code.
- Verification: `lake env lean PhysicsSM/NullStrand/NullLift/FiniteLeastAction.lean`
  exit 0; `lake build PhysicsSM.NullStrand.NullLift.FiniteLeastAction` exit 0;
  full `lake build PhysicsSM.NullStrand` exit 0 (8080 jobs). `lean_verify` on
  `leastActionStep_nonneg` and `leastActionPush_uniform_invariant` reports only
  `propext, Classical.choice, Quot.sound` with no source-scan warnings.
- Follow-up (from Aristotle's report, not blocking): the `RefreshChain` invariance
  API is specialized to the rank-one lazy-redraw kernel `(1-r)I + rΠ`, so the
  doubly-stochastic `I - tL` is not an instance of it; a generic
  `RowStochastic`/`DoublyStochastic` finite-kernel structure with
  `push`/`push_total_mass`/`push_uniform_invariant` would unify them.
- Other five wave-6 projects (`1f88edab`, `3c35a56d`, `4958845e`, `ec7619d7`,
  `6912a0f0`) remain to be harvested separately.
