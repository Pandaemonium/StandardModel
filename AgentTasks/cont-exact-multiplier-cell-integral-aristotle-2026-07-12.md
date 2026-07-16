# Aristotle task: actual intra-cell exact-multiplier L2 integral

## Objective

Close the remaining analytic gate of `CONT-MULT-001`. The sharp pointwise
Dirac multiplier bound and the global arbitrary-sample coefficient theorem are
already kernel-checked. This task must prove the continuously varying
piecewise-cell field is measurable/integrable, decompose its global L2 energy
over the disjoint cells, and squeeze that actual integral to zero.

## Exact target

`AgentTasks/aristotle-targets/codex_afpl_exact_multiplier_cell_integral.lean`

Run the narrow file first:

```text
lake env lean AgentTasks/aristotle-targets/codex_afpl_exact_multiplier_cell_integral.lean
```

Close all four proof holes without changing definitions, statements, or
hypotheses. Small helper lemmas may be added. Do not return a finite-sample
theorem: that result is already available through the imported
`ExactFlowCellSampleEnergy` module.

## Expected proof architecture

1. Prove `exactCellVariationAt_continuous` from the linear Dirac symbol,
   `NormedSpace.exp_continuous`, finite `mulVec`, and fixed cell coefficient.
2. Use measurable half-open cells, finite pairwise disjointness, and
   `MeasureTheory.integral_biUnion_finset` to prove the exact energy
   decomposition.
3. On each cell, combine
   `exactFlow_cellCenter_norm_le`, `Matrix.l2_opNorm_mulVec`,
   `spinor_norm_sq_eq_sum`, exact cell volume, and `cellScale` normalization.
4. Sum the cell estimates, use
   `spinorCellCoefficient_energy_le`, and squeeze with
   `exactCellSampleRate_tendsto_zero`.

## Semantic gates

- The result quantifies the actual continuum point `x` inside each cell, not a
  chosen representative.
- No additional integrability hypothesis may be imposed on the multiplier
  error; it must be derived from finite-cell continuity/boundedness.
- The input-field assumptions remain only componentwise `MemLp ... 2 volume`.
- This proves momentum-space L2 multiplier convergence only. Inverse Fourier,
  position-space PDE identification, and Lorentz restoration remain open.

## Context preflight

The Neo4j semantic context-pack command was attempted earlier in this session
and failed because the local service refused `127.0.0.1:7687`. The target is a
fully typechecked in-repository composition with exact imports, so this task
records the degraded preflight rather than inventing a context pack.

## Local status

The exact target initially typechecked with four intended proof holes. After
submission, Codex closed `exactCellVariationAt_continuous` locally by installing
the restricted-scalar `NormedAlgebra Rat Mat4` instance, composing
`NormedSpace.exp_continuous`, and using the continuous Euclidean equivalence.
The strengthened target now typechecks with exactly three intended integral
proof holes; the proof was sent to the running task with
`continue --mode instruct` so its budget stays on the measure bridge.

```yaml
aristotle:
  project_id: 5f03e432-fd1e-422f-8270-bc518e868672
  task_id: 6ae29e93-86dd-4ac6-99ce-4b03115035b6
  target_file: AgentTasks/aristotle-targets/codex_afpl_exact_multiplier_cell_integral.lean
  expected_module: PhysicsSM.Draft.NullEdge.ExactFlowCellIntegral
  submission_project: AgentTasks/aristotle-submit/cont-exact-multiplier-cell-integral-20260712-project
  output_dir: AgentTasks/aristotle-output/5f03e432-fd1e-422f-8270-bc518e868672
  status: submitted
```
