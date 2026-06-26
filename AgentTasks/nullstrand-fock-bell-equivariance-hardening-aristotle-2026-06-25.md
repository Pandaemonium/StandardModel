# Aristotle task: Fock/Bell equivariance hardening

Date: 2026-06-25

## Objective

Repair the BELL-005 scope issue. Either rename/scope the existing
`fockNullLift_equivariant` theorem as total-mass preservation, or strengthen the
API to prove a genuine direction-marginal/Born-equivariance theorem.

## Requested output

- Patchable Lean for `PhysicsSM/NullStrand/BellQFT/FockCutoff.lean` and nearby
  finite Bell modules.
- A theorem name whose claim matches the statement.
- If strengthening is possible, a true direction-marginal preservation theorem
  and the hypotheses needed for it.
- If strengthening is not possible from current API, a clean rename/docs patch
  plus the exact missing structure.

## Files to inspect first

- `PhysicsSM/NullStrand/BellQFT/FockCutoff.lean`
- `PhysicsSM/NullStrand/BellQFT/FiniteCore.lean`
- `PhysicsSM/NullStrand/BellQFT/MinimalRates.lean`
- `PhysicsSM/NullStrand/BellQFT/BornSafety.lean`
- `PhysicsSM/NullStrand/NullLift/FiniteResidualCurrent.lean`
- `AgentTasks/null-strand-roadmap-hardening-report-aristotle-2026-06-25.md`

## Constraints

- Do not label total mass conservation as equivariance.
- Do not weaken BELL finite-current or minimal-rate theorem statements.
- Keep all sums finite and explicit.

## Aristotle metadata

```yaml
aristotle:
  project_id: f91e1900-6076-4ffb-a44b-74c667db404f
  task_id: cf735321-2d51-4785-8aec-a652194b70c1
  target_file: PhysicsSM/NullStrand/BellQFT/FockCutoff.lean
  expected_module: PhysicsSM.NullStrand.BellQFT.FockCutoff
  submission_project: AgentTasks/aristotle-submit/nullstrand-fock-bell-equivariance-hardening-20260625-project
  output_dir: AgentTasks/aristotle-output/f91e1900-6076-4ffb-a44b-74c667db404f
  status: failed_after_nudge_no_output
```

## 2026-06-25 nudge

Sent `aristotle continue --mode instruct` to project
`f91e1900-6076-4ffb-a44b-74c667db404f`: skip full `lake build` and dependency
rebuilds; return patchable Lean or precise blockers.

## 2026-06-25 triage

The original task was canceled by the nudge path and its replacement failed
without patchable Lean output. No live integration was performed. This lane is
being resubmitted with an explicit instruction not to run full `lake build`.
