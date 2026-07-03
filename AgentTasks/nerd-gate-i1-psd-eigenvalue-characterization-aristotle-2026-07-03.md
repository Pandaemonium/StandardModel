# Gate I1.2 PSD/eigenvalue characterization Aristotle task

Task: focused Mathlib-only proof job for the Gate I1.2 positive-semidefinite
and eigenvalue characterization of the soldered Hermitian momentum block.

Current local file:

```text
AgentTasks/aristotle-standalone/gate-i1-kinematic-core-20260702/GateI1KinematicCore/Core.lean
```

Local verification before submission:

```text
lake env lean AgentTasks/aristotle-standalone/gate-i1-kinematic-core-20260702/GateI1KinematicCore/Core.lean
```

Current green local results include:

- `i1_1_soldering_det`
- `i1_2_det_minkHerm_sub_smul_one`
- `i1_2_spectralPlus_det_zero`
- `i1_2_spectralMinus_det_zero`
- `i1_2_spectralMinus_nonneg_iff_futureCone`
- `i1_2_spectralRoots_nonneg_of_futureCone`
- `rankOne_posSemidef`
- `finBundleMomentum_posSemidef`
- `rankOne_rank_eq_zero_iff`
- `rankOne_rank_eq_one`
- `i1_3_rank_one_rank_dichotomy`
- `i1_4_rank_one_factorization`
- `i1_5_cauchy_binet_mass_identity`
- `i1_6_kinematic_cross_check`

Requested target theorem names:

```lean
theorem minkHerm_isHermitian (p : Momentum4) :
    (minkHerm p).IsHermitian := by
  ...

theorem i1_2_minkHerm_posSemidef_iff_futureCone (p : Momentum4) :
    (minkHerm p).PosSemidef
      ↔ 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2 := by
  ...

theorem i1_2_minkHerm_eigenvalues_nonneg_iff_futureCone (p : Momentum4) :
    0 <= (minkHerm_isHermitian p).eigenvalues
      ↔ 0 <= p 0 ∧ spatialNormSq p <= (p 0) ^ 2 := by
  ...
```

Semantic guardrail: this is the mostly-minus future-cone characterization of
the `2 x 2` Hermitian Pauli-soldered block. Do not weaken it to only one
direction or silently replace the future-cone condition.

Prompt:

```text
AgentTasks/aristotle-prompts/gate-i1-psd-eigenvalue-characterization-20260703.prompt.md
```

Submission package:

```text
AgentTasks/aristotle-submit/gate-i1-psd-eigenvalue-characterization-20260703-project
```

Aristotle metadata:

```yaml
aristotle:
  project_id: 6434c938-66c9-4025-a376-ae5ca9c106d4
  task_id: 2950bce3-5438-45bc-bc82-0b89de78879d
  target_file: GateI1KinematicCore/Core.lean
  expected_module: GateI1KinematicCore.Core
  submission_project: AgentTasks/aristotle-submit/gate-i1-psd-eigenvalue-characterization-20260703-project
  output_dir: AgentTasks/aristotle-output/6434c938-66c9-4025-a376-ae5ca9c106d4
  status: complete-merged
```

## Submission log

- 2026-07-03 00:26 local: submitted focused package with
  `aristotle submit --project-dir AgentTasks/aristotle-submit/gate-i1-psd-eigenvalue-characterization-20260703-project <prompt>`.
  Project `6434c938-66c9-4025-a376-ae5ca9c106d4`, task
  `2950bce3-5438-45bc-bc82-0b89de78879d`.
- `aristotle list --limit 8` immediately after submission reported project
  status `RUNNING`; `aristotle tasks ... --limit 10` reported task status
  `QUEUED`.
- 2026-07-03 00:38 local: the live source file advanced after submission with
  independent I1.9 block-square lemmas:
  `i1_9_minkHerm_mul_bar_eq_minkowskiSq` and
  `i1_9_bar_mul_minkHerm_eq_minkowskiSq`. When integrating Aristotle output,
  do not replace the live file wholesale; merge only the I1.2
  PosSemidef/eigenvalue proof changes.
- 2026-07-03 00:45 local: the live source file advanced again with I1.8
  normalized-determinant lemmas `trace_normalizedMinkHerm` and
  `det_normalizedMinkHerm`, then
  `det_normalizedMinkHerm_eq_one_sub_velocityNormSq`,
  `trace_normalizedMinkHerm_sq`, and `linearEntropy_normalizedMinkHerm`.
  The merge warning above applies to these too.
- 2026-07-03 00:49 local: Aristotle project returned COMPLETE. The helper
  fetched output under
  `AgentTasks/aristotle-output/6434c938-66c9-4025-a376-ae5ca9c106d4`, but did
  not auto-discover a candidate because the archive nested the standalone
  project path. I manually merged only the returned I1.2 theorem block into the
  live staging file, preserving the local I1.8/I1.9 additions.
- 2026-07-03 00:51 local: verification after merge:

  ```text
  lake env lean AgentTasks\aristotle-standalone\gate-i1-kinematic-core-20260702\GateI1KinematicCore\Core.lean
  rg -n "\b(sorry|admit|axiom|opaque|unsafe|native_decide)\b" AgentTasks\aristotle-standalone\gate-i1-kinematic-core-20260702\GateI1KinematicCore\Core.lean
  ```

  The Lean check passed. The placeholder scan returned no hits.
  Axiom audit for `minkHerm_isHermitian`,
  `i1_2_minkHerm_posSemidef_iff_futureCone`, and
  `i1_2_minkHerm_eigenvalues_nonneg_iff_futureCone` reports only
  `[propext, Classical.choice, Quot.sound]`.
