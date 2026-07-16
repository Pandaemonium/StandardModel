# Aristotle task: arbitrary-density qubit modular selection

## Intent

Prove the single unchanged theorem in
`AgentTasks/aristotle-targets/codex_afpl_dyn_universal_rho.lean`. This is the
explicit arbitrary-`rho` wrapper left open by the accepted operator-S2
capstone. It must quantify over all Hermitian positive-semidefinite trace-one
qubit matrices with the displayed `sigmaX` expectation; do not replace that
family with commuting matrices or a preselected Bloch coordinate.

## Proof route

1. Obtain `e'`, `u`, and `v` from `pairBloch_surjective rho hrho htrace`.
2. Substitute the representation of `rho`.
3. Use `pairBloch_sigmaX_expectation` and `henergy` to prove `e' = e`.
4. Convert `hpsd` to `e^2 + u^2 + v^2 <= 1` with
   `pairBloch_posSemidef_iff`.
5. Apply the entropy inequality and equality conjuncts of
   `DYNModularMaxEntCapstone.dyn_modular_operator_S2_capstone e u v he hball`.
6. For equality, rewrite `u = 0` and `v = 0` to obtain matrix equality; in the
   reverse direction, matrix equality gives entropy equality. Use proof
   irrelevance if the Hermitian proof parameters do not rewrite definitionally.

## Semantic locks

- Do not change the theorem statement or add assumptions.
- Do not weaken equality uniqueness to Bloch-coordinate uniqueness.
- Keep positivity, trace one, and fixed energy as independent displayed
  hypotheses.
- The target is finite `Fin 2`; do not claim general finite dimension.
- Expected axiom footprint after landing: `propext`, `Classical.choice`, and
  `Quot.sound` only.
- No compiler-trust shortcut or new assumption.

## Context

- `AgentTasks/context-packs/dyn-universal-rho-20260712-225904.md`
- `PhysicsSM/Draft/NullEdge/QubitFixedEnergyMaxEntropy.lean`
- `PhysicsSM/Draft/NullEdge/DYNModularMaxEntCapstone.lean`

## Verification

```powershell
lake env lean AgentTasks/aristotle-targets/codex_afpl_dyn_universal_rho.lean
```

## Status

Submitted.

```yaml
aristotle:
  project_id: 46a2e213-1e0b-45c5-a398-e3b54772e0cc
  task_id: pending
  target_file: AgentTasks/aristotle-targets/codex_afpl_dyn_universal_rho.lean
  expected_module: PhysicsSM.Draft.NullEdge.DYNUniversalRho
  submission_project: AgentTasks/aristotle-submit/dyn-universal-rho-20260712-project
  output_dir: AgentTasks/aristotle-output/46a2e213-1e0b-45c5-a398-e3b54772e0cc
  status: submitted
```
