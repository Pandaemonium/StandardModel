# Codex Aristotle target: fixed-momentum many-step tail

Close the four remaining proof holes in `ManyStep/Continuum.lean` without
changing definitions, theorem statements, or constants. Run:

```text
lake env lean ManyStep/Continuum.lean
```

The preceding snapshot already proves the analytic scaffold. Reuse it; do not
rebuild or replace it. Remaining targets:

1. `walk_sub_firstOrder_bound`: combine
   `l2_opNorm_le_two_entryMax` with the four-entry theorem.
2. `one_step_to_exact_flow_bound`: use the norm triangle inequality and the two
   local bounds; `Dkm` is deliberately generous.
3. `fixed_time_many_step_bound`: apply the unitary telescope, exact-flow power
   identity, and substitute `eps=t/n` with exact field arithmetic.
4. `fixed_time_many_step_tendsto`: derive convergence from the displayed
   `Dkm*t^2/n` bound, handling the eventual small-step condition explicitly.

Do not weaken the L2 operator norm, introduce an exponential growth factor, or
claim uniform-in-momentum/PDE/spacetime/3+1 convergence.

Provenance: narrowed resubmission of Aristotle
`8984157c-93a5-4cc2-98f5-56aa0ae16d6b` after its two-hour snapshot closed six
of ten targets.

Context pack:
`AgentTasks/context-packs/fixed-momentum-many-step-20260709-20260709-184652.md`.

```yaml
aristotle:
  project_id: 3906ed40-adf5-4d47-a46b-bd979c70cfba
  target_file: ManyStep/Continuum.lean
  expected_module: PhysicsSM.Draft.NullEdge.FixedMomentumManyStepContinuum
  submission_project: AgentTasks/aristotle-submit/codex-fixed-momentum-many-step-tail-20260709-2100-project
  output_dir: AgentTasks/aristotle-output/3906ed40-adf5-4d47-a46b-bd979c70cfba
  status: submitted
```
