# Aristotle task: exact rank-four Lagrange spectral selector

## Scientific question

Can the current abstract polynomial-projector interface be given a constructive,
exact rank-four selector whenever a finite self-adjoint/order-native operator
has four isolated target eigenvalues?

This is a clean algebraic predecessor to Priority 1's stable four-mode sector.
The causal-set work still owes the operator, simple/gapped spectrum, Lorentzian
inertia, and refinement persistence. This target proves that those spectral
inputs imply an exact basis-free polynomial filter rather than an arbitrary
choice of four vectors.

## Target

Close every proof hole in:

`RankFourSelector/LagrangeProjector.lean`

Preserve all theorem statements. Small interpolation, polynomial-evaluation,
coordinate-range, and finite-dimensional linear-algebra lemmas are welcome.
The hard targets are:

- exact Lagrange evaluation on a finite injective eigenvalue table;
- equality of polynomial functional calculus with the coordinate projector;
- exact range dimension `selected.card`;
- the rank-four idempotent capstone.

If a statement is false or malformed, return a concrete finite counterexample
and the minimal corrected theorem. Do not weaken it silently.

## Scope boundary

This is a finite diagonal-model theorem. It does not assert that the corrected
causal operator has a simple spectrum or that the selected sector is stable
under random refinement. Its role is to isolate the next genuinely physical
obligations: spectral gap, inertia, and persistence.

## Context

- `PhysicsSM/Draft/NullEdge/EquivariantPolynomialProbeProjector.lean`
- `PhysicsSM/Draft/NullEdge/RankFourCarrierProbeSector.lean`
- `Sources/Null_Edge_Reconstruction_Priorities_2026-07-19.md`, Priority 1
- `AgentTasks/context-packs/rank-four-lagrange-selector-20260719-095821.md`

## Verification

Run only:

```text
lake env lean RankFourSelector/LagrangeProjector.lean
```

No new assumptions, compiler-trusted decision procedures, or placeholder
definitions. Finish with an axiom report and a concise statement of which
additional hypotheses would be required for quantitative gap stability.

## Aristotle metadata

```yaml
aristotle:
  project_id: 695bcfb3-f956-4c37-8894-2713905d91d8
  task_id: 235b50d3-648c-4553-a2e2-d492b7cc3c6a
  target_file: RankFourSelector/LagrangeProjector.lean
  expected_module: RankFourSelector.LagrangeProjector
  submission_project: AgentTasks/aristotle-submit/rank-four-lagrange-selector-20260719-project
  output_dir: AgentTasks/aristotle-output/695bcfb3-f956-4c37-8894-2713905d91d8
  status: integrated
  integration_module: PhysicsSM/Draft/NullEdge/IntrinsicRankFourLagrangeSelector.lean
```

Submitted on 2026-07-19. Harvested, adapted into the project namespace,
axiom-guarded, and root-built on 2026-07-19.
