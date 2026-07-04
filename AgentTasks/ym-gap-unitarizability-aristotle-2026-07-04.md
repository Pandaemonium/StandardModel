# Aristotle job: finite-group unitarizability - unitary matrix model for every FDRep (2026-07-04)

```yaml
aristotle:
  project_id: d4a9bd1f-f54b-404b-91ac-701721b81f8d
  target_file: YmGapUnitarizability/UnitaryModel.lean
  expected_module: YmGapUnitarizability
  submission_project: AgentTasks/aristotle-submit/ym-gap-unitarizability-20260704-project
  source_root: AgentTasks/aristotle-standalone/ym-gap-unitarizability-20260704
  prompt: AgentTasks/aristotle-prompts/ym-gap-unitarizability.prompt.md
  status: SUBMITTED
```

## Target

`fdRep_exists_unitary_matrix_model`: every `R : FDRep C G` for a finite
group `G` admits a unitary matrix model - multiplicative, unital, unitary
`rho : G -> Matrix (Fin n) (Fin n) C` with
`R.character g = Matrix.trace (rho g)` for all `g`. Weyl unitarian trick,
packaged at the matrix level. Suggested route in the file docstring:
`LinearMap.toMatrix` basis matrices, Weyl-averaged Gram
`P = sum_g (M g)^H (M g)` with the `g -> g*h` reindexing intertwining
identity, conjugation by `CFC.sqrt P`, trace cyclicity.

## Why

Discharges the explicit matrix-model hypothesis in
`GateYM/WilsonVacuumDominance.lean`, making `|wilsonNormalizedGamma| <= 1`
and `wilsonStringTension >= 0` UNCONDITIONAL for every simple complex
`FDRep` observable. This is item Q4 of the program document work queue
(section 14) and the analysis-graph node "finite-group
unitarizability/eigenvalue ordering".

## Harvest checklist (on completion)

1. `aristotle show d4a9bd1f-f54b-404b-91ac-701721b81f8d`, download, diff
   against the submitted skeleton (only additions + the sorry replaced).
2. Semantic review: statement unchanged (same existential shape, literal
   `(rho g)^H * rho g = 1`, `Matrix.trace` conclusion, no `[Simple R]`
   added); axiom audit at most `[propext, Classical.choice, Quot.sound]`.
3. Integrate as `PhysicsSM/Draft/NullEdge/GateYM/FDRepUnitarizable.lean`;
   add corollaries to `WilsonVacuumDominance`:
   `norm_wilsonNormalizedGamma_le_one'` and `wilsonStringTension_nonneg'`
   with the matrix-model hypothesis REMOVED (obtained from this theorem).
4. Then the gap lane's next target is eigenvalue reality/ordering for the
   fusion transfer operator (work-queue item Q5).
