# Aristotle task: Mathlib CFC bridge for finite quantum Klein

- Work item: `DYN-MODULAR-001`
- Role: Builder / Maintainer
- Priority: reusable matrix-information infrastructure
- Target: `QuantumKleinCFCBridge.lean`
- Source root:
  `AgentTasks/aristotle-standalone/quantum-klein-cfc-bridge-20260713/`
- Submission status: ready when an Aristotle fleet slot opens

## Objective

Complete `cross_trace_eq_overlap_sum` without changing its statement and
without adding a raised heartbeat limit.  Preserve the two already completed
CFC bridge theorems and the self-trace identity.

The preferred proof should extract small reusable lemmas for the trace of a
diagonal matrix conjugated by a change-of-basis unitary.  The result should be
suitable for replacing the monolithic high-heartbeat proof in
`PhysicsSM/Draft/NullEdge/GeneralQuantumKlein.lean` after independent review.

## Mathematical route

Let `U` and `V` be the Hermitian eigenvector unitaries and `W = U^H V`.
Using the two spectral decompositions and trace cyclicity, reduce the left side
to

```text
Tr(diag(lambda) * W * diag(log mu) * W^H).
```

Evaluate the diagonal entries and use
`normSq z = conj z * z` to obtain

```text
sum_i sum_j lambda_i * |W_ij|^2 * log(mu_j).
```

## Semantic constraints

- Keep `Real.log 0 = 0`; this is the entropy-compatible singular extension,
  not an invertible matrix logarithm.
- Do not assume `rho` and `sigma` commute or have simple spectra.
- Do not add positivity hypotheses; this identity is purely spectral.
- Do not change basis order, transpose/conjugate conventions, or the overlap
  orientation `U^H V`.
- Do not introduce trust-expanding declarations or evaluator shortcuts.
- Do not claim or attempt an external Mathlib submission.  Human decision
  `DQ-008` remains open.

## Verification

Run the focused file first:

```text
lake env lean QuantumKleinCFCBridge.lean
```

Return the completed file and identify every helper lemma that may be reusable
in Mathlib or the project-local Klein/equality/Gibbs modules.

## Submission metadata

```yaml
aristotle:
  project_id: null
  task_id: null
  target_file: QuantumKleinCFCBridge.lean
  expected_module: QuantumKleinCFCBridge
  submission_project: null
  output_dir: null
  status: ready
```
