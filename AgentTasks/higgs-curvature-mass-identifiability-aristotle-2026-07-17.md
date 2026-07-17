# Aristotle job: Higgs curvature-mass identifiability

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: integrated

Semantic context pack:
`AgentTasks/context-packs/higgs-curvature-mass-identifiability-20260717-20260717-031510.md`.

## Objective

Prove the exact finite identifiability boundary for the scalar insertion
profile `bareMassSq + xi * R(x)`:

- constant curvature admits a nontrivial affine trade between bare mass and
  curvature coupling that preserves the insertion matrix and every finite
  retarded series;
- two distinct curvature values force both parameters to agree.

The sign convention corresponds to the equation
`(Box - bareMassSq - xi * R) h = source` and must remain explicit.

## Scope boundary

Curvature, vertex measure, primitive kernel, and equation convention are
supplied. The result does not derive a graph curvature, choose the physical
curvature coupling, identify a continuum operator, or predict a Higgs mass.

## Target

`AgentTasks/aristotle-standalone/higgs-curvature-mass-identifiability-20260717/HiggsCurvatureMassIdentifiability/Core.lean`

Preserve every public definition and theorem statement. Small private helper
lemmas are welcome. The returned source must contain no proof holes or new
assumptions.

Preflight: `lake env lean` accepts the focused source with exactly six
intended proof-hole warnings and no errors. Source SHA-256:
`D402DFCABC17B61A149C6AD978E64979FAC2BDE97D3CB254421583B8DFB96809`.

## Provenance

Project-internal identifiability algebra motivated by the curved-space scalar
equation and by Benincasa and Dowker, "The Scalar Curvature of a Causal Set,"
arXiv `1001.2725`, whose causal-set scalar operator has curved-spacetime
continuum expectation `Box - R/2`. No source implementation or proof text was
copied, and the paper does not establish the present null-edge operator.

## Submission metadata

```yaml
aristotle:
  project_id: 313f3487-2592-43c4-838d-f4e7defc5ccb
  task_id: d32bbee3-bcd2-4155-8937-8225b5d4602d
  target_file: HiggsCurvatureMassIdentifiability/Core.lean
  expected_module: HiggsCurvatureMassIdentifiability.Core
  source_root: AgentTasks/aristotle-standalone/higgs-curvature-mass-identifiability-20260717
  submission_project: AgentTasks/aristotle-submit/higgs-curvature-mass-identifiability-20260717-project
  integration_target: PhysicsSM/Draft/NullEdge/HiggsCurvatureMassIdentifiability.lean
  output_dir: AgentTasks/aristotle-output/313f3487-2592-43c4-838d-f4e7defc5ccb
  status: integrated
```

The first focused submission, project
`e6f1b425-69a7-4b47-9fba-1a6a91c543f1`, task
`16f9ad09-b2b4-4072-9749-4af0379722ce`, was cancelled before proof search at
2026-07-17 03:20 PDT. Semantic audit found that four intended proposition-level
inequalities had been written with ASCII Boolean `!=`. They were corrected to
proposition-level `Ne` notation and the corrected source passed the pinned
preflight with the same six intended proof-hole warnings and no errors.

The corrected focused package was resubmitted at 2026-07-17 03:21 PDT as
project `313f3487-2592-43c4-838d-f4e7defc5ccb`, task
`d32bbee3-bcd2-4155-8937-8225b5d4602d`. Aristotle again reported the missing
local dependency-cache efficiency warning. The task initially reported
`QUEUED`; no wait loop was started.

## Integration result

Aristotle completed all six proofs. Semantic review confirmed that every
corrected inequality remained proposition-level `Ne` and that no theorem was
weakened. The result was placed in the project namespace at
`PhysicsSM/Draft/NullEdge/HiggsCurvatureMassIdentifiability.lean`, with claim
grade `M [orig/comp]` and build-enforced axiom guards. Production SHA-256:
`066B9C8289D23B2AEE615F1CAE170B66F2780A512BE59CC2270C2546A5275659`.

The finite result establishes an identifiability boundary only. It does not
derive curvature, choose `xi`, prove equivalence with the Benincasa--Dowker
operator, or predict a Higgs mass.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/HiggsCurvatureMassIdentifiability.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsCurvatureMassIdentifiability`
  (8,026 jobs)
- Lean LSP error diagnostics: empty
- `lean_verify` on
  `constantCurvature_nontrivial_propagator_degeneracy` and
  `twoVertices_identify_parameters`: standard three axioms, no source warnings

There are no proof holes or linter warnings in the production module.
