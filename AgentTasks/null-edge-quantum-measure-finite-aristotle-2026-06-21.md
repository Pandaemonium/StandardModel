# Aristotle task: finite quantum-measure bridge

Date: 2026-06-21

## Objective

Fill the proof holes in:

```text
PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean
```

This batch builds a finite quantum-measure/decoherence-functional bridge for
the null-edge causal graph program.  It is meant to connect the finite
Pluecker-mass program with Sorkin-style quantum measure theory using only
finite `Finset` algebra.

## Target file

```text
PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean
```

Expected module:

```text
PhysicsSM.Draft.NullEdgeQuantumMeasureFiniteAristotle
```

## Theorem targets

Finite amplitude and decoherence additivity:

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

Already proved locally:

```lean
decoherenceFunctional_diag_eq_qMeasure
decoherenceFunctional_hermitian
decoherenceFunctional_stronglyPositive_gram
```

The strong-positivity wrapper already closes once
`decoherenceQuadraticForm_eq_absSq` is proved.

## Proof guidance

For finite event additivity, use finite-set sum lemmas for disjoint unions.

For the grade-2 rule, reduce by additivity to amplitudes

```text
a = alpha(A), b = alpha(B), c = alpha(C)
```

and prove the scalar identity

```text
|a+b+c|^2 =
|a+b|^2 + |a+c|^2 + |b+c|^2 - |a|^2 - |b|^2 - |c|^2.
```

For strong positivity, show

```text
sum_i sum_j conj(c_i) D(E_i,E_j) c_j
  =
|sum_i conj(c_i) alpha(E_i)|^2.
```

For tensor products, prove rectangular factorization of amplitudes first:

```text
alpha_{A x B}(ampA tensor ampB) = alpha_A(ampA) * alpha_B(ampB).
```

Then the decoherence and quantum-measure product statements should follow by
commutative ring simplification.

## Constraints

- Keep this module draft-facing.
- Do not modify trusted definitions or conventions.
- No final `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, `u n s a f e`, or
  `n a t i v e _ d e c i d e` in the target file.
- Do not weaken theorem statements silently. If a theorem needs a sharper
  disjointness hypothesis or a different event normalization, report that
  clearly and prove the corrected form.
- This is finite `Finset` algebra only. Do not introduce continuum measure,
  Hilbert-space completion, or analytic path-integral assumptions.

## Local validation before submission

```text
lake env lean PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean
```

Result before submission: typechecks with exactly eight intended proof-hole
warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: f0f1d88b-d4e5-4d47-bb6d-d9c41598e790
  task_id: cdf79ea2-0ac7-47c0-acd8-e934c85fef01
  target_file: PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeQuantumMeasureFiniteAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-quantum-measure-finite-20260621-project
  output_dir: AgentTasks/aristotle-output/f0f1d88b-d4e5-4d47-bb6d-d9c41598e790
  status: submitted
```

Submitted 2026-06-21. `aristotle submit` created project
`f0f1d88b-d4e5-4d47-bb6d-d9c41598e790`. `aristotle tasks` reported task
`cdf79ea2-0ac7-47c0-acd8-e934c85fef01` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Submission note: the Aristotle CLI warned that the slim package contains Lean
files but no `.lake` folder. This is expected from
`Scripts/prepare_aristotle_submission.ps1`, which intentionally excludes local
build artifacts and dependency caches. If dependency resolution fails, retry
with an alternate package strategy.

## Cycle-1 status note

Checked 2026-06-21 after the first 15-minute goal-cycle wait. Aristotle still
reported task `cdf79ea2-0ac7-47c0-acd8-e934c85fef01` as `IN_PROGRESS`, but the
UI/log showed the same build-budget failure mode as the Gram-weighted job: a
full project build failed after a long timeout, followed by a long targeted
`lake build PhysicsSM.Draft.NullEdgeQuantumMeasureFiniteAristotle`.

Two client-side attempts to fetch or instruct the running task timed out:

```text
aristotle continue --mode instruct --wait f0f1d88b-d4e5-4d47-bb6d-d9c41598e790 ...
aristotle show f0f1d88b-d4e5-4d47-bb6d-d9c41598e790 --task cdf79ea2-0ac7-47c0-acd8-e934c85fef01 --limit 40
```

Do not assume this task is doing useful proof search unless a later status check
shows returned code. If it remains stuck, resubmit the finite event-additivity,
grade-2, positivity, and product lemmas as a focused standalone Mathlib package
that defines `complexAbsSq` locally instead of importing `PhysicsSM.Spinor`.

Canceled 2026-06-21 with:

```text
aristotle cancel --task-id cdf79ea2-0ac7-47c0-acd8-e934c85fef01
```

Focused replacement prepared:

```text
AgentTasks/null-edge-quantum-measure-core-aristotle-2026-06-21.md
AgentTasks/aristotle-submit/null-edge-quantum-measure-core-20260621-project
```

Focused replacement submitted as Aristotle project
`a58ec5b9-c5bf-4a28-bc3d-ccc8975661e3`, task
`218d7391-1f7d-4d58-b147-7731e428fb71`.
