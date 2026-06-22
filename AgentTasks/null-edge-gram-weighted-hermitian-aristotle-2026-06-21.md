# Aristotle task: Gram-weighted operator Hermiticity

Date: 2026-06-21

## Objective

Prove the finite Hermiticity wrapper for Gram-weighted visible momentum:
Hermitian hidden Gram data induces a Hermitian visible momentum operator, and
therefore its diagonal entries are real.

Target file:

```text
NullEdgeGramWeightedHermitian/Finite.lean
```

Expected module:

```text
NullEdgeGramWeightedHermitian.Finite
```

Context pack:

```text
AgentTasks/context-packs/null-edge-gram-weighted-hermitian-20260621-manual.md
```

## Theorem targets

```lean
operatorGramWeightedVisibleMomentum_hermitian_of_gramHermitian
matrixHermitian_diag_im_eq_zero
operatorGramWeightedVisibleMomentum_diag_im_eq_zero
```

## Why this matters

This is an operator-level consistency theorem for the hidden-channel physics
line: the visible reduced momentum must be Hermitian when the hidden Gram data
is Hermitian. It complements the Gram-weighted positivity job.

## Constraints

- Preserve conjugation order in the visible momentum definition.
- Do not replace Hermiticity with ordinary symmetry.
- Final target file should contain no proof holes or escape-hatch
  declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-gram-weighted-hermitian-20260621/NullEdgeGramWeightedHermitian/Finite.lean
```

Result before submission: passed with exactly three intended proof-hole
warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 94f1c326-0559-475b-a2d8-743d6af2fdc0
  task_id: e93b68b8-5fe6-41e1-9125-594e989f1659
  target_file: NullEdgeGramWeightedHermitian/Finite.lean
  expected_module: NullEdgeGramWeightedHermitian.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-gram-weighted-hermitian-20260621-project
  output_dir: AgentTasks/aristotle-output/94f1c326-0559-475b-a2d8-743d6af2fdc0
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`94f1c326-0559-475b-a2d8-743d6af2fdc0`; `aristotle tasks` reported task
`e93b68b8-5fe6-41e1-9125-594e989f1659` as `QUEUED`.

## Result analysis

Fetched and integrated 2026-06-21. Aristotle proved all three targets:

- `operatorGramWeightedVisibleMomentum_hermitian_of_gramHermitian`
- `matrixHermitian_diag_im_eq_zero`
- `operatorGramWeightedVisibleMomentum_diag_im_eq_zero`

The integrated draft module is:

```text
PhysicsSM/Draft/NullEdgeGramWeightedHermitian.lean
```

The main mathematical gain is an operator sanity theorem: Hermitian hidden Gram
data induces a Hermitian visible momentum operator, so the diagonal visible
momentum entries are real.

Local verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeGramWeightedHermitian.lean
lake build PhysicsSM.Draft.NullEdgeGramWeightedHermitian
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft PhysicsSM/Draft/NullEdgeGramWeightedHermitian.lean
```

All passed. A separate `rg` scan of the integrated file found no placeholder or
escape-hatch tokens.
