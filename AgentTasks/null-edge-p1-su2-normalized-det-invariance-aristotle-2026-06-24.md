# Aristotle task: P1 SU(2) normalized determinant invariance

Submitted: 2026-06-24.

## Scientific role

This task advances `P1-F`. The last two P1 integrations proved:

- a fixed observer/rest block leaves residual `SU(2)` spin-frame freedom;
- the two-null trace-normalized determinant gives the scalar readout
  `2 sqrt(det rho) = m/E`.

The next finite bridge is to show the scalar readout is independent of the
residual spin-frame choice. In matrix terms, a unitary determinant-one
congruence preserves the trace-normalized determinant.

## Aristotle instructions

Please work on:

```text
NullEdgeP1SU2NormalizedDetInvariance/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP1SU2NormalizedDetInvariance/Core.lean
```

Primary targets:

```lean
trace_observerConjugate_eq
det_observerConjugate_eq
traceNormalizedDet_observerConjugate_eq
```

Guardrails:

- Keep this finite and matrix-level.
- Do not introduce continuum dynamics or a new observer ontology.
- If Mathlib has a cleaner unitary API, it is fine to add helper lemmas, but do
  not weaken the final scalar-invariance conclusion.

Please finish with a concise next-steps note:

- which targets were solved;
- whether any statement/API change was needed;
- the next finite P1-F or P4/P7 theorem you recommend.

## Metadata

```yaml
aristotle:
  project_id: cecaf26c-ab7d-4484-b901-01e12c077659
  task_id: 275f0354-b046-4867-8bfa-9a13b01fd67c
  target_file: NullEdgeP1SU2NormalizedDetInvariance/Core.lean
  expected_module: NullEdgeP1SU2NormalizedDetInvariance.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p1-su2-normalized-det-invariance-20260624-project
  output_dir: AgentTasks/aristotle-output/cecaf26c-ab7d-4484-b901-01e12c077659
  status: integrated
```

## Integration note

Integrated as:

```text
PhysicsSM.Draft.NullEdgeP1SU2NormalizedDetInvariance
```

The standalone source under `AgentTasks/aristotle-standalone/` was also updated
with the completed proofs. The theorem statements were unchanged: trace,
determinant, and trace-normalized determinant are invariant under the stated
unitary/determinant-one residual spin-frame congruence hypotheses.
