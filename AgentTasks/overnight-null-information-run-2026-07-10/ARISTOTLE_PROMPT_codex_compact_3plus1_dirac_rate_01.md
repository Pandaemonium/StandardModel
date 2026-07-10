# Codex proof job: compact-momentum 3+1 Dirac product rate

Close as many proofs as possible in `Compact3Plus1DiracRate/Core.lean`, with
priority in this order:

1. `one_step_to_exact_flow_bound`;
2. `fixed_time_many_step_bound`;
3. `D4_le_Dbox` and `fixed_time_many_step_bound_on_box`;
4. exact unitarity, flow-power, and convergence lemmas;
5. the noncommutator and `k=(1,2,2),m=3` controls.

Do not change the Clifford matrices, x/y/z/mass factor order, exact flow,
operator norm, theorem quantifiers, or `O(1/n)` rate. The constant `D4` is
deliberately generous and may be increased only if you prove and document why
the displayed one is insufficient. Do not weaken the compact-box theorem to
pointwise convergence.

This is a finite `4x4` symbol theorem, not a position-space, PDE, or
infinite-volume result. Preserve `spatial_generators_noncommute`: the naive
unsymmetrized product is first order, and the manuscript must not claim
`O(1/n^2)`. Run:

`lake env lean Compact3Plus1DiracRate/Core.lean`

Reference shapes: the landed `FixedMomentumManyStepContinuum` and
`BoundedMomentumManyStepContinuum`; Childs et al., arXiv:1912.08854; Mathlib
`NormedSpace.exp_nsmul`, matrix exponential, unitary-group, and L2 operator-norm
APIs. Clean-room proof only.

```yaml
aristotle:
  project_id: ce6e18d6-8633-4f14-af66-56b6517e4f16
  target_file: AgentTasks/aristotle-standalone/compact-3plus1-dirac-rate-20260710/Compact3Plus1DiracRate/Core.lean
  expected_module: Compact3Plus1DiracRate.Core
  submission_project: AgentTasks/aristotle-submit/codex-compact-3plus1-dirac-rate-20260710-project
  output_dir: AgentTasks/aristotle-output/ce6e18d6-8633-4f14-af66-56b6517e4f16
  status: complete; harvested, independently checked, integrated, and guarded
```

2026-07-10 06:41 PDT snapshot: all target theorems except
`one_step_to_exact_flow_bound` are closed. The snapshot proves exact unitarity,
the power telescope, exact-flow power law, fixed-time and box bounds conditional
on the local estimate, convergence, noncommutation, and the `1223` control.
Sent an instruction to focus exclusively on the one remaining local bound and
return immediately after it closes.

2026-07-10 follow-up: Aristotle closed `one_step_to_exact_flow_bound` without
changing the statement or displayed constant. The complete module is now
`PhysicsSM/Draft/NullEdge/Compact3Plus1DiracRate.lean`; it is composed with the
finite position walk in `Local3Plus1RateBridge.lean` and with finite Fourier
synthesis in `FiniteWalkPositionConvergence.lean`.
