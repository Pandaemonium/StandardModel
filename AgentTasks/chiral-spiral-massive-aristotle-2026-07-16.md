# Aristotle job: massive chiral spiral / 2E zitter rate (spiral wave 2, job B)

Date: 2026-07-16
Context: spiral-layer wave 2, continuing the 2026-07-14 thread; wave-1
companion ChiralSpiralCommutatorAristotle (massless ladders) is integrated.

```yaml
aristotle:
  project_id: 469070a8-55af-45b0-bf07-40372330c22b
  task_id: TBD
  target_file: ChiralSpiralMassive/ChiralSpiralMassive.lean
  expected_module: ChiralSpiralMassive.ChiralSpiralMassive
  submission_project: AgentTasks/aristotle-submit/chiral-spiral-massive-20260716-project
  source_root: AgentTasks/aristotle-standalone/chiral-spiral-massive-20260716
  output_dir: AgentTasks/aristotle-output/469070a8-55af-45b0-bf07-40372330c22b
  status: submitted
  integration_target: PhysicsSM/Draft/NullEdge/ChiralSpiralMassiveAristotle.lean
```

## Goal

The massive helix algebra at unit momentum: Dtot m = D0 + m*betaM satisfies
(Dtot)^2 = (1+m^2)*1 (on-shell Clifford square); the transverse ladders
anticommute with the FULL massive operator; the massive rotation decomposes
as wave-1 free rotation + m * (mass coupling between counter-rotating
sectors); and the double commutator gives exactly 4(1+m^2)*A_pm - the
massive zitterbewegung rate 2E as an exact finite identity.

## Statements (9, placeholder-proof targets, do not weaken)

`betaM_sq`, `D0_betaM_anticomm`, `Dtot_sq`, `anticomm_Dtot_APlus`,
`anticomm_Dtot_AMinus`, `comm_Dtot_APlus_decomp`,
`massive_zitter_double_comm_APlus`, `massive_zitter_double_comm_AMinus`,
`massless_reduction`.

## Preflight

- Statements typechecked 2026-07-16 (`lake env lean`, only placeholder
  warnings).
- Hand-verified: {D0, betaM} = 0 blockwise; the double-commutator constant
  follows from anticommutation ([H,[H,A]] = 4 A H^2 when {H,A} = 0) plus
  Dtot_sq; the m = 0 reduction reproduces the wave-1 law.

## Semantic review checklist (for integration)

- Block conventions identical to wave 1 (chirality +1 = indices 0,1;
  ladder normalization sigmaPlus = !![0,2;0,0]).
- `Dtot_sq` constant must remain (1 + m^2) with unit momentum implicit -
  document, do not generalize p.
- The decomposition theorem must keep BOTH terms verbatim (2*(g5*APlus) and
  m*comm betaM APlus); merging them hides the physics split.
- Axiom audit per theorem; no compiled-evaluator tactic.
