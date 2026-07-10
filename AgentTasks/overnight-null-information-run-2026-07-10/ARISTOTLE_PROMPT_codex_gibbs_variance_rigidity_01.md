# Codex proof job: Gibbs variance rigidity

The generic response and variance proofs in `FiniteGibbsVariance/Core.lean` are
already complete. Close only the four remaining handoff proofs without changing
their statements:

- every finite Gibbs probability is strictly positive;
- variance is zero exactly when the energy spectrum is constant;
- variance is strictly positive exactly when two energy levels differ;
- the `4/25` two-level spectrum is an explicit nonconstant positive-variance
  witness.

Use the centered-square identity and strict positivity of every normalized
weight. Preserve `[NeZero n]`; do not weaken the equivalence to one direction.
This is finite thermodynamic rigidity, not a thermodynamic limit or
irreversibility theorem. Run `lake env lean FiniteGibbsVariance/Core.lean`.

```yaml
aristotle:
  project_id: 07f73e42-0ca2-4cc1-bce1-40ee1daa45be
  target_file: FiniteGibbsVariance/Core.lean
  expected_module: FiniteGibbsVariance.Core
  submission_project: AgentTasks/aristotle-submit/codex-gibbs-variance-rigidity-20260710-project
  output_dir: AgentTasks/aristotle-output/07f73e42-0ca2-4cc1-bce1-40ee1daa45be
  status: idle; harvested and integrated
```
