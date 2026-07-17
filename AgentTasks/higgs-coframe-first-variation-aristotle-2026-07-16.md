# Aristotle job: signed Higgs coframe first variation

Date: 2026-07-16
Work item: `GRAV-ORDER-OPERATOR-001`
Status: integrated

Semantic context pack:
`AgentTasks/context-packs/higgs-coframe-first-variation-20260716-20260716-230148.md`
(SHA-256 `DF9C3D42B244A748C905106BF071228C2E7AD994D1A2631A17E67E6A547AF1F5`).

## Objective

Prove the exact finite response algebra for fixed complex transported samples
under a real affine perturbation of a supplied dual-frame matrix:

- exact complex norm-square expansion along a real parameter;
- exact affine change of extracted derivative components;
- exact signed kinetic expansion with displayed linear and quadratic terms;
- composition of the matrix and kinetic expansions;
- gauge invariance of the linear response under a common anchor phase.

## Exact target

`AgentTasks/aristotle-standalone/higgs-coframe-first-variation-20260716/HiggsCoframeFirstVariation/Core.lean`

Preserve every public definition and theorem statement. Small private helpers
are welcome. Keep the exact quadratic remainder; do not weaken the result to a
derivative limit or big-O statement.

## Scope boundary

The dual matrix, its variation, signs, and samples are supplied. The samples
are held fixed. This target does not derive a graph coframe, choose a metric
variation convention, vary holonomies or matter fields, construct a stress
tensor, prove conservation, or establish a continuum limit. The signed kinetic
form is not asserted nonnegative.

## Preflight

`lake env lean` accepts the focused source under the pinned toolchain with
exactly five intended proof-hole warnings and no errors. Source SHA-256:
`4BA1AFD8350D0B4147032DF909340799A44DCB85B13EF746B2870F5A38DCB73E`.

## Submission metadata

```yaml
aristotle:
  project_id: 15c10e3f-3352-4f2a-8879-489298a33e6c
  task_id: 5912c3ab-db11-49b3-9eea-abb70c18ad52
  target_file: HiggsCoframeFirstVariation/Core.lean
  expected_module: HiggsCoframeFirstVariation.Core
  source_root: AgentTasks/aristotle-standalone/higgs-coframe-first-variation-20260716
  submission_project: AgentTasks/aristotle-submit/higgs-coframe-first-variation-20260716-project
  integration_target: PhysicsSM/Draft/NullEdge/HiggsCoframeFirstVariation.lean
  status: integrated
```

Submitted as a focused Mathlib package. Aristotle reported the project as
created and the task as `QUEUED`; no wait loop was started.

## Integration review

Aristotle completed all five proof targets. The returned file changed only the
proof bodies; every public definition and theorem statement was preserved.
The candidate replayed under the pinned toolchain and was ported to
`PhysicsSM/Draft/NullEdge/HiggsCoframeFirstVariation.lean`, with its one
unused-section-variable warning removed and five build-enforced axiom guards
added. The production module passes targeted `lake env lean` and `lake build`;
Lean MCP reports no diagnostics, no suspicious source patterns, and only the
standard three axioms on every guarded theorem.

Output directory:
`AgentTasks/aristotle-output/15c10e3f-3352-4f2a-8879-489298a33e6c/`.
