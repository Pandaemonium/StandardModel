# Aristotle wave 2: checkerboard structure + projector calculus + d=6 helicity

Date: 2026-06-12

Second wave of the luminal-motion checkerboard program
(`Sources/Luminal_Motion_Checkerboard_Research_Program.md`), built on the
integrated wave-1 results (recursion package, spin coherent projectors,
complex spinor-helicity; the wave-1 corner-count job `edfab07a` is still
running and is NOT superseded by this wave).

All statements oracle-validated:
`Scripts/oracle/validate_checkerboard.py` (ALL OK, 2026-06-12, including the
new wave-2 section: general collapse with arbitrary non-Hermitian `M`,
antipodal completeness/orthogonality, quaternionic rank-one and the chart
construction).

Submission package created with
`Scripts/prepare_aristotle_submission.ps1 -JobName checkerboard-wave2-20260612`
(package checks: no `.lake`/`.git`/output state, no compiled artifacts,
proof-sorry counts as expected).

## Job A: support, parity, symmetry, massless limit

Targets (5): `pathSum_eq_zero_of_lt_natAbs`, `pathSum_eq_zero_of_odd`,
`pathSum_translate`, `pathSum_reflect`, `pathSum_massless`.
The causal-kernel package: discrete light cone, parity, translation and
reflection symmetry, and the `mu = 0` straight-null-line indicator.

```yaml
aristotle:
  job_id: 41db474b-a5e0-40dc-9bc1-0f98cf3b6073
  target_file: PhysicsSM/Draft/CheckerboardSupportSymmetryAristotle.lean
  expected_module: PhysicsSM.Draft.CheckerboardSupportSymmetryAristotle
  submission_project: AgentTasks/aristotle-submit/checkerboard-wave2-20260612-project
  output_dir: AgentTasks/aristotle-output/41db474b-a5e0-40dc-9bc1-0f98cf3b6073
  status: integrated
```

## Job B: general rank-one collapse and projector calculus

Targets (5): `spinProjector_conj_collapse`
(`P(a) M P(a) = tr(P(a) M) . P(a)` for arbitrary `M`),
`exists_rankOne_spinProjector`, `trace_spinProjector_pair`,
`spinProjector_add_antipodal`, `spinProjector_mul_antipodal`.
The algebraic engine reducing arbitrary projector chains along null
polygons to products of Bargmann scalars (WP3 stage 2).

```yaml
aristotle:
  job_id: b4a9796f-0df6-4b25-87a1-7f9d84b6ca57
  target_file: PhysicsSM/Draft/SpinCoherentCollapseAristotle.lean
  expected_module: PhysicsSM.Draft.SpinCoherentCollapseAristotle
  submission_project: AgentTasks/aristotle-submit/checkerboard-wave2-20260612-project
  output_dir: AgentTasks/aristotle-output/b4a9796f-0df6-4b25-87a1-7f9d84b6ca57
  status: integrated
```

## Job C: Weyl Clifford bridge

Targets (6): the dictionary lemmas `minkHerm_eq_smul_one_add_pauliVec` /
`minkHermBar_eq_smul_one_sub_pauliVec`, the Clifford relations
`minkHerm_mul_minkHermBar` / `minkHermBar_mul_minkHerm`, the trace pairing
`trace_minkHerm_mul_minkHermBar`, and the null-step factorization
`minkHerm_null_step` (`sigma.(r, r a) = 2r P(a)`).
Bridges the two wave-1 layers; the single-step form of "spin transport
along a null polygon is a product of coherent projectors" (WP2b).

```yaml
aristotle:
  job_id: 4eee0cd2-6e11-4565-8e93-55e8d448e221
  target_file: PhysicsSM/Draft/WeylCliffordBridgeAristotle.lean
  expected_module: PhysicsSM.Draft.WeylCliffordBridgeAristotle
  submission_project: AgentTasks/aristotle-submit/checkerboard-wave2-20260612-project
  output_dir: AgentTasks/aristotle-output/4eee0cd2-6e11-4565-8e93-55e8d448e221
  status: integrated
```

## Job D: quaternionic spinor-helicity (`K = H`, `d = 6`)

Targets (7): `minkHermQ_conjTranspose`, `trace_minkHermQ`,
`minkHermQ_injective`, `minkHermQ_momentumOfQ`, `momentumOfQ_null`,
`momentumOfQ_nonneg`, capstone `minkHermQ_rankOne_iff`.
Second rung of the division-algebra ladder (WP6); the noncommutative
stress test before the octonionic `d = 10` bridge.

```yaml
aristotle:
  job_id: ab6bdbe0-fb95-438b-a39c-c5a9c6d57177
  target_file: PhysicsSM/Draft/SpinorHelicityQuaternionAristotle.lean
  expected_module: PhysicsSM.Draft.SpinorHelicityQuaternionAristotle
  submission_project: AgentTasks/aristotle-submit/checkerboard-wave2-20260612-project
  output_dir: AgentTasks/aristotle-output/ab6bdbe0-fb95-438b-a39c-c5a9c6d57177
  status: integrated
```

## Constraints (all jobs)

- No placeholder proof commands, no new assumptions, no `native_decide`.
- No definition or statement changes; helper lemmas welcome.
- Verification per job: `lake env lean <target_file>`, then
  `#print axioms` expecting only `[propext, Classical.choice, Quot.sound]`.

## Integration

Fetch and inspect with the (bug-fixed) helper:

```powershell
python Scripts/aristotle/integrate_completed.py `
  --task-note AgentTasks/checkerboard-wave2-aristotle-2026-06-12.md `
  <job-id>
```

Note: the helper's placeholder scan is whole-file and will flag handoff
docstrings that mention the forbidden tokens; the wave-2 module docstrings
were worded to avoid them.
