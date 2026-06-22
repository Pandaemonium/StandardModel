# Aristotle task: Gram-weighted operator positivity

Date: 2026-06-21

## Objective

Prove the finite operator-positivity bridge for Gram-weighted visible momentum.
The target theorem says that the visible quadratic form of the traced hidden
operator is the hidden Gram quadratic form evaluated on the projected visible
test spinor, and therefore hidden positive-semidefiniteness descends to visible
positive-semidefiniteness.

Target file:

```text
NullEdgeGramWeightedOperator/Finite.lean
```

Expected module:

```text
NullEdgeGramWeightedOperator.Finite
```

Context pack:

```text
AgentTasks/context-packs/null-edge-gram-weighted-operator-20260621-manual.md
```

## Theorem targets

```lean
visibleQuadraticForm_gramWeighted_eq_gramQuadraticForm
gramPositiveSemidefinite_implies_visiblePositiveSemidefinite
```

## Why this matters

This is the finite operator statement behind the hidden-channel physics: a
positive hidden Gram sector remains positive after taking the visible reduced
operator. It complements the existing determinant/Cauchy-Binet mass theorem.

## Constraints

- Keep the Hermitian projection convention explicit.
- Do not replace positive-semidefiniteness with only a determinant statement.
- This is a finite theorem only; do not add analytic Hilbert-space assumptions.
- Final target file should contain no proof holes or escape-hatch
  declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-gram-weighted-operator-20260621/NullEdgeGramWeightedOperator/Finite.lean
```

Result before submission: passed with exactly two intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 0ecb5bc4-7e1d-4854-9ca0-5bfd66fd5a49
  task_id: 2ba1fa47-afc8-4a59-b415-5b87274f8bd3
  target_file: NullEdgeGramWeightedOperator/Finite.lean
  expected_module: NullEdgeGramWeightedOperator.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-gram-weighted-operator-20260621-project
  output_dir: AgentTasks/aristotle-output/0ecb5bc4-7e1d-4854-9ca0-5bfd66fd5a49
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`0ecb5bc4-7e1d-4854-9ca0-5bfd66fd5a49`; `aristotle tasks` reported task
`2ba1fa47-afc8-4a59-b415-5b87274f8bd3` as `QUEUED`.

## Result analysis

Fetched and integrated 2026-06-21. Aristotle proved both targets:

- `visibleQuadraticForm_gramWeighted_eq_gramQuadraticForm`
- `gramPositiveSemidefinite_implies_visiblePositiveSemidefinite`

The integrated draft module is:

```text
PhysicsSM/Draft/NullEdgeGramWeightedOperator.lean
```

The main mathematical gain is an operator-level hidden-channel theorem:
`v^dagger P_vis v` for the Gram-weighted visible momentum is exactly the
hidden Gram quadratic form evaluated on the projected visible test spinor.
Thus hidden positive-semidefiniteness descends to visible
positive-semidefiniteness.

Local verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeGramWeightedOperator.lean
lake build PhysicsSM.Draft.NullEdgeGramWeightedOperator
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft PhysicsSM/Draft/NullEdgeGramWeightedOperator.lean
```

All passed. A separate `rg` scan of the integrated file found no placeholder or
escape-hatch tokens.
