# Exact discrete-walk mass covariance

## Objective

Lift the landed generator-family classification to the actual ordered finite
propagator `transportStep * PluckerMassDynamics.massCoin`.

## Required result

- The diagonal chiral-phase branch is covariant at the same momentum and sends
  `z` to `u*z`.
- The antidiagonal branch is covariant only with parity `k -> -k` and sends `z`
  to `u*conj z`.
- Global unit phases cancel from conjugation.

## Boundaries

This is the exact two-channel finite walk step. It is not a classification of
every symmetry of the ordered `3+1` split regulator.

## Aristotle metadata

```yaml
aristotle:
  project_id: 47f71b37-fb7a-4727-a297-255f6d603af2
  task_id: f2e86c88-9d0e-4679-aba8-eceace5efcf4
  target_file: AgentTasks/aristotle-targets/codex_24h_discrete_walk_mass_covariance.lean
  expected_module: PhysicsSM.Draft.NullEdge.DiscreteWalkMassCovariance
  submission_project: AgentTasks/aristotle-submit/codex-24h-discrete-walk-mass-covariance-20260712-project
  output_dir: AgentTasks/aristotle-output/47f71b37-fb7a-4727-a297-255f6d603af2
  status: landed-and-guarded
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Harvest

Aristotle preserved both requested branch statements and discharged the
remaining mass-coin conjugation lemma without weakening the ordered product.
The integrated module is
`PhysicsSM/Draft/NullEdge/DiscreteWalkMassCovariance.lean`. Direct Lean and
the targeted build pass under the pinned toolchain, and the two headline
theorems are pinned in `OvernightTheoryAxiomGuard.lean` with only `propext`,
`Classical.choice`, and `Quot.sound`.

This closes branch action on the exact two-channel step. It does not classify
all possible symmetries of that step and does not establish covariance of the
full live `3+1` split regulator.
