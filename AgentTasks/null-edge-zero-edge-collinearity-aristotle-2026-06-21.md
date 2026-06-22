# Aristotle task: zero-edge collinearity completion

Date: 2026-06-21

## Objective

Complete the total finite massless-collinearity wrapper over the trusted
Pluecker API. The existing trusted theorem requires a chosen nonzero base
spinor; this task should prove the base-free statement that the zero-edge locus
is either all-zero or a shared nonzero projective direction.

Target file:

```text
NullEdgeZeroEdgeCollinearity/Finite.lean
```

Expected module:

```text
NullEdgeZeroEdgeCollinearity.Finite
```

Context pack:

```text
AgentTasks/context-packs/null-edge-zero-edge-collinearity-20260621-manual.md
```

## Theorem targets

```lean
pairwise_wedge_zero_iff_all_zero_or_common_direction
fin_bundle_mass_zero_iff_all_zero_or_common_direction
```

## Why this matters

The null-edge program repeatedly uses zero determinant mass as the geometric
signal for a collapsed visible bundle. This theorem turns that signal into a
clean, base-free projective geometry statement, including the `Fin 0` and
all-zero edge cases.

## Constraints

- Keep this package focused: it may import the copied trusted
  `PhysicsSM.Spinor.PluckerMass` file, but no broader `PhysicsSM` tree.
- Use the canonical trusted Pluecker primitives.
- Do not weaken the common-direction branch by dropping nonzero-base data.
- Final target file should contain no proof holes or escape-hatch
  declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-zero-edge-collinearity-20260621/NullEdgeZeroEdgeCollinearity/Finite.lean
```

Result before submission: passed with exactly two intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 836515b3-39e8-47c7-bf4d-325f6fc3e9c1
  task_id: 7a31c327-d3f6-4ec3-8cae-7240f51c5859
  target_file: NullEdgeZeroEdgeCollinearity/Finite.lean
  expected_module: NullEdgeZeroEdgeCollinearity.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-zero-edge-collinearity-20260621-project
  output_dir: AgentTasks/aristotle-output/836515b3-39e8-47c7-bf4d-325f6fc3e9c1
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`836515b3-39e8-47c7-bf4d-325f6fc3e9c1`; `aristotle tasks` reported task
`7a31c327-d3f6-4ec3-8cae-7240f51c5859` as `QUEUED`.

## Result analysis

Fetched and integrated 2026-06-21. Aristotle proved both target wrappers:

- `pairwise_wedge_zero_iff_all_zero_or_common_direction`
- `fin_bundle_mass_zero_iff_all_zero_or_common_direction`

The integrated draft module is:

```text
PhysicsSM/Draft/NullEdgeZeroEdgeCollinearity.lean
```

The main mathematical gain is a base-free zero-edge criterion: vanishing finite
bundle determinant is equivalent to either the all-zero bundle or a common
nonzero projective spinor direction. This removes the need for downstream
theorems to provide a chosen nonzero base index by hand.

Local verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeZeroEdgeCollinearity.lean
lake build PhysicsSM.Draft.NullEdgeZeroEdgeCollinearity
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft PhysicsSM/Draft/NullEdgeZeroEdgeCollinearity.lean
```

All passed. A separate `rg` scan of the integrated file found no placeholder or
escape-hatch tokens.
