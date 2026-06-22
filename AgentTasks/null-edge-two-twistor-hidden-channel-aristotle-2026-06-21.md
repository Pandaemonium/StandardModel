# Aristotle task: null-edge two-twistor hidden-channel bridge

Date: 2026-06-21

## Objective

Fill the proof holes in:

```text
PhysicsSM/Draft/NullEdgeTwoTwistorHiddenChannelAristotle.lean
```

This batch connects the completed finite hidden-channel determinant theorems
to the trusted two-twistor Pluecker chart, then asks for a more general hidden
basis-invariance theorem.

## Target file

```text
PhysicsSM/Draft/NullEdgeTwoTwistorHiddenChannelAristotle.lean
```

Expected module:

```text
PhysicsSM.Draft.NullEdgeTwoTwistorHiddenChannelAristotle
```

## Main theorem target

```lean
visibleReducedDensity_hiddenMixFinite_eq
```

Informal statement:

If `U : Matrix (Fin m) (Fin n) Complex` has column-isometric hidden columns,
and

```text
chi_k = sum_i U_ki psi_i
```

then

```text
sum_k |chi_k><chi_k| = sum_i |psi_i><psi_i|.
```

This is the finite algebraic partial-trace invariance statement: changing an
orthogonal/decohered hidden basis does not change the reduced visible density.

## Dependent theorem targets

The file also contains corollaries that should close after the main theorem:

```lean
visibleReducedDensity_hiddenMixFinite_det_eq_plucker
visibleReducedDensity_hiddenMixFinite_mass_zero_iff_common_direction
visibleReducedDensity_hiddenMixMultiTwistorPi_det_eq_pairwiseMass
visibleReducedDensity_hiddenMixMultiTwistorPi_mass_zero_iff_common_pi_direction
```

The two-twistor local wrappers are already proved before submission:

```lean
twoTwistorDecoheredMomentum_eq_twoTwistorMomentum
twoTwistorCoherentMomentum_det_eq_zero
twoTwistorDecoheredMomentum_det_eq_massInvariant
twoTwistorHiddenCoherenceMassGap_eq_massInvariant
twoTwistorPartialCoherence_det_eq_factor_mul_massInvariant
twoTwistorPartialCoherence_one_det_eq_zero
```

## Proof guidance

For `visibleReducedDensity_hiddenMixFinite_eq`, expand both sides entrywise.
The left side has entries

```text
sum_k (sum_i U_ki psi_i a) * conj(sum_j U_kj psi_j b).
```

Rearrange finite sums to obtain

```text
sum_i sum_j (sum_k U_ki conj(U_kj)) * psi_i a * conj(psi_j b).
```

The column-isometry hypothesis collapses the middle factor to `1` when
`i = j` and `0` otherwise, leaving exactly the visible reduced density of
`psi`.

Useful imported definitions and theorems:

```lean
visibleReducedDensity
rankOneHermitian
finBundleMomentum
visibleReducedDensity_det_eq_plucker
visibleReducedDensity_mass_zero_iff_common_direction
multi_twistor_momentum_det_eq_pairwiseMass
```

## Constraints

- Keep this module draft-facing.
- Do not modify trusted definitions or conventions.
- No final `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, `u n s a f e`, or
  `n a t i v e _ d e c i d e` in the target file.
- Do not weaken theorem statements silently. If the statement needs a sharper
  hypothesis, report the issue and prove the corrected form with an explanatory
  comment.
- This is finite matrix algebra only. Do not add continuum, scattering, or
  analytic assumptions.

## Local validation before submission

```text
lake env lean PhysicsSM/Draft/NullEdgeTwoTwistorHiddenChannelAristotle.lean
```

Result before submission: typechecks with exactly one intended proof-hole
warning.

## Aristotle metadata

```yaml
aristotle:
  project_id: 7a9ae403-7a8c-44ee-8c65-570d71865a3c
  task_id: 201f5535-84f3-4d85-997f-4bd0a2d1dd69
  target_file: PhysicsSM/Draft/NullEdgeTwoTwistorHiddenChannelAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeTwoTwistorHiddenChannelAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-two-twistor-hidden-channel-20260621-project
  output_dir: AgentTasks/aristotle-output/7a9ae403-7a8c-44ee-8c65-570d71865a3c
  status: submitted
```

Submitted 2026-06-21. `aristotle submit` created project
`7a9ae403-7a8c-44ee-8c65-570d71865a3c`. `aristotle tasks` reported task
`201f5535-84f3-4d85-997f-4bd0a2d1dd69` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Submission note: the Aristotle CLI warned that the slim package contains Lean
files but no `.lake` folder. This is expected from
`Scripts/prepare_aristotle_submission.ps1`, which intentionally excludes local
build artifacts and dependency caches. If dependency resolution fails, retry
with an alternate package strategy.

## Cycle-1 status note

Checked 2026-06-21 after the first 15-minute goal-cycle wait. Aristotle still
reported task `201f5535-84f3-4d85-997f-4bd0a2d1dd69` as `IN_PROGRESS`, but the
UI/log showed the same build-budget failure mode as the Gram-weighted job: a
full project build failed after a long timeout, followed by a long targeted
`lake build PhysicsSM.Draft.NullEdgeTwoTwistorHiddenChannelAristotle`.

Two client-side attempts to fetch or instruct the running task timed out:

```text
aristotle continue --mode instruct --wait 7a9ae403-7a8c-44ee-8c65-570d71865a3c ...
aristotle show 7a9ae403-7a8c-44ee-8c65-570d71865a3c --task 201f5535-84f3-4d85-997f-4bd0a2d1dd69 --limit 40
```

Do not assume this task is doing useful proof search unless a later status check
shows returned code. If it remains stuck, resubmit the main finite
hidden-isometry theorem as a focused standalone Mathlib package, then port the
proof back into the PhysicsSM wrapper.

Canceled 2026-06-21 with:

```text
aristotle cancel --task-id 201f5535-84f3-4d85-997f-4bd0a2d1dd69
```

Focused replacement prepared:

```text
AgentTasks/null-edge-hidden-isometry-core-aristotle-2026-06-21.md
AgentTasks/aristotle-submit/null-edge-hidden-isometry-core-20260621-project
```

Focused replacement submitted as Aristotle project
`34463997-1e52-4f88-be99-0c96651d7ddb`, task
`a4870afc-c25c-4488-9a19-ee2088dc5fac`.
