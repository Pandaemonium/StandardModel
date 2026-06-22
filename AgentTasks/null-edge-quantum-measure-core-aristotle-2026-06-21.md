# Aristotle task: finite quantum-measure core

Date: 2026-06-21

## Objective

Replace the stalled full-PhysicsSM quantum-measure job with a tiny standalone
Mathlib package proving the finite event-algebra core.

Target file:

```text
NullEdgeQuantumMeasureCore/Finite.lean
```

Expected module:

```text
NullEdgeQuantumMeasureCore.Finite
```

## Theorem targets

Finite amplitude/decoherence additivity:

```lean
eventAmplitude_union_of_disjoint
decoherenceFunctional_union_left_of_disjoint
decoherenceFunctional_union_right_of_disjoint
```

Quantum-measure grade-2 rule:

```lean
qMeasure_grade2_sum_rule_of_pairwise_disjoint
```

Strong positivity:

```lean
decoherenceQuadraticForm_eq_absSq
decoherenceFunctional_stronglyPositive_gram
```

Tensor-product closure:

```lean
eventAmplitude_product
decoherenceFunctional_product_rectangle
qMeasure_product_rectangle
```

## Proof guidance

This is finite `Finset` algebra only.

For grade-2, reduce to the scalar identity:

```text
|a+b+c|^2 =
|a+b|^2 + |a+c|^2 + |b+c|^2 - |a|^2 - |b|^2 - |c|^2
```

For strong positivity, show:

```text
sum_i sum_j conj(c_i) D(E_i,E_j) c_j
  =
|sum_i conj(c_i) alpha(E_i)|^2
```

For product events, prove rectangular amplitude factorization first; the
decoherence and quantum-measure product statements should follow from that.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not introduce continuum measure, Hilbert-space completion, or analytic
  path-integral assumptions.
- Do not weaken theorem statements silently.
- Fully proved helper lemmas in the same file are welcome.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean NullEdgeQuantumMeasureCore/Finite.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: a58ec5b9-c5bf-4a28-bc3d-ccc8975661e3
  task_id: 218d7391-1f7d-4d58-b147-7731e428fb71
  target_file: NullEdgeQuantumMeasureCore/Finite.lean
  expected_module: NullEdgeQuantumMeasureCore.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-quantum-measure-core-20260621-project
  output_dir: AgentTasks/aristotle-output/a58ec5b9-c5bf-4a28-bc3d-ccc8975661e3
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`a58ec5b9-c5bf-4a28-bc3d-ccc8975661e3`; `aristotle tasks` reported task
`218d7391-1f7d-4d58-b147-7731e428fb71` as `QUEUED`.

Local validation before submission:

```text
lake env lean AgentTasks/aristotle-submit/null-edge-quantum-measure-core-20260621-project/NullEdgeQuantumMeasureCore/Finite.lean
```

Result: passed with exactly eight intended proof-hole warnings.

Integrated 2026-06-21 after `aristotle tasks` reported task
`218d7391-1f7d-4d58-b147-7731e428fb71` as `COMPLETE`.
Fetched output to
`AgentTasks/aristotle-output/a58ec5b9-c5bf-4a28-bc3d-ccc8975661e3`.

Aristotle proved the standalone finite quantum-measure core:

```lean
eventAmplitude_union_of_disjoint
decoherenceFunctional_union_left_of_disjoint
decoherenceFunctional_union_right_of_disjoint
qMeasure_grade2_sum_rule_of_pairwise_disjoint
decoherenceQuadraticForm_eq_absSq
decoherenceFunctional_stronglyPositive_gram
eventAmplitude_product
decoherenceFunctional_product_rectangle
qMeasure_product_rectangle
```

The proof was ported into:

```text
PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean
```

Post-integration checks:

```text
lake env lean PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean
```
