# Aristotle job: complex Higgs Hilbert stress

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: integrated and verified

Semantic context pack:
`AgentTasks/context-packs/higgs-hilbert-stress-20260717-20260717-010403.md`
(SHA-256 `EFDBC738AB03CE019D6A8FDBFB01742DAB8F3067B1DAC08976068A6CD46EAD38`).

## Objective

Close the finite algebraic bridge from recovered complex Higgs derivative
components to a symmetric Hilbert-stress coefficient:

- prove symmetry and unitary invariance of the real Hermitian derivative
  bilinear;
- prove the exact affine measure/inverse-metric action response;
- prove symmetry of the resulting complex-multiplet stress coefficient;
- under the displayed determinant-compatible measure response, identify the
  first variation with one half of the measure-weighted stress pairing;
- retain unitary gauge invariance of both the stress coefficient and response.

## Convention lock

The kinetic convention is

```text
L = gInv^{ab} Re((D_a H)^dagger D_b H) - V.
```

Therefore

```text
T_ab = 2 Re((D_a H)^dagger D_b H) - g_ab L.
```

The inverse-metric response convention is explicitly

```text
delta S = +(1/2) measure * T_ab * delta gInv^{ab}.
```

Equivalently, variation of the covariant metric carries the minus sign. This
matches the existing mostly-minus coframe modules. The returned tensor must
not be combined with the opposite-sign inverse-metric definition.

This is the complex-multiplet normalization; decomposing each complex
component into two canonically normalized real fields recovers the familiar
real-scalar one-half convention. Metric signature is not fixed by the algebra.

## Scope boundary

The covariant and inverse metric matrices, measure, determinant-compatible
measure response, derivative components, and potential density are supplied.
The target does not prove that the two metric matrices are inverse, reconstruct
them from a graph, derive a Higgs equation of motion, establish a Noether
identity or conservation law, or derive Einstein dynamics.

## Target

`AgentTasks/aristotle-standalone/higgs-hilbert-stress-20260717/HiggsHilbertStress/Core.lean`

Preserve all public definitions and theorem statements. The final source must
contain no proof holes or new assumptions.

Preflight: `lake env lean` accepts the focused source with exactly nine
intended proof-hole warnings and no errors. Source SHA-256:
`D34CFC41F99B9933D4FF5228C2BF3A0EF24032EDD7999A7F6123A3C0FEDE98D9`.

## Provenance

Clean-room finite formalization of the Hilbert metric-variation definition and
the standard complex-scalar tensor shape. Convention cross-checks: arXiv
`2211.03092` for metric/coframe variational stress and arXiv `2112.11168`,
Eq. (3), for the symmetric complex-scalar derivative bilinear (with its paper-
specific overall normalization and signature kept separate). In particular,
arXiv `2211.03092`, Eq. (2), differentiates with respect to the covariant
metric and uses its own sign convention; it is not the sign source for this
module's inverse-metric response.

## Submission metadata

```yaml
aristotle:
  project_id: b6945a0d-3d9c-41af-b693-e724761a3204
  task_id: 455ef650-659d-4955-80b4-6a7011cfed74
  target_file: HiggsHilbertStress/Core.lean
  expected_module: HiggsHilbertStress.Core
  source_root: AgentTasks/aristotle-standalone/higgs-hilbert-stress-20260717
  submission_project: AgentTasks/aristotle-submit/higgs-hilbert-stress-20260717-project
  integration_target: PhysicsSM/Draft/NullEdge/HiggsHilbertStress.lean
  output_dir: AgentTasks/aristotle-output/b6945a0d-3d9c-41af-b693-e724761a3204
  status: integrated
```

Submitted as a focused Mathlib package at 2026-07-17 01:08 PDT. The exact
submission directory passed `lake env lean HiggsHilbertStress/Core.lean` with
only the nine intended proof-hole warnings before upload. Aristotle reported
the task as `QUEUED`; no wait loop was started.

## Integration result

Aristotle completed all nine proofs without changing a public definition or
theorem statement. The returned source was reviewed and ported to
`PhysicsSM/Draft/NullEdge/HiggsHilbertStress.lean` under the project namespace,
with the inverse-metric sign convention preserved and build-enforced axiom
guards added.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/HiggsHilbertStress.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsHilbertStress` (8,026 jobs)
- Lean LSP diagnostics: empty.
- `lean_verify` on `volumeCompatible_response_eq_hilbert_pairing`: only
  `propext`, `Classical.choice`, and `Quot.sound`; no source-scan warnings.
