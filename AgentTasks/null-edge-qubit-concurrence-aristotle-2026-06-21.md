# Aristotle task: qubit concurrence wrapper

Date: 2026-06-21

## Objective

Prove the finite qubit determinant/concurrence algebra behind the updated
proper-time-as-concurrence program direction.

Target file:

```text
NullEdgeQubitConcurrence/Finite.lean
```

Expected module:

```text
NullEdgeQubitConcurrence.Finite
```

Context pack:

```text
AgentTasks/context-packs/null-edge-qubit-concurrence-20260621-manual.md
```

## Theorem targets

```lean
trace2_mul_self_eq_trace_sq_sub_two_det
linearEntropyComplex_eq_concurrenceSq_of_trace_one
normalized_mass_ratio_eq_concurrence
normalized_mass_ratio_sq_eq_four_det
qubitConcurrence_sq_eq_four_det
```

## Why this matters

The updated program says the normalized visible mass ratio
`m / E = 2 * sqrt(det rho_vis)` is the qubit concurrence of the
visible/internal bipartition for a pure global state. This job banks the finite
matrix identity connecting determinant, linear entropy, and concurrence squared.

## Constraints

- Keep the job finite and algebraic.
- Do not claim LOCC monotonicity or continuum time dynamics.
- Final target file should contain no proof holes or escape-hatch
  declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-qubit-concurrence-20260621/NullEdgeQubitConcurrence/Finite.lean
```

Result before submission: passed with exactly four intended proof-hole
warnings. The target `normalized_mass_ratio_eq_concurrence` is definitional.

## Aristotle metadata

```yaml
aristotle:
  project_id: 097cc326-5ae4-46b2-8786-de2975ac8103
  task_id: 95d8c563-8e6a-46f4-932a-881410a09d63
  target_file: NullEdgeQubitConcurrence/Finite.lean
  expected_module: NullEdgeQubitConcurrence.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-qubit-concurrence-20260621-project
  output_dir: AgentTasks/aristotle-output/097cc326-5ae4-46b2-8786-de2975ac8103
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`097cc326-5ae4-46b2-8786-de2975ac8103`; `aristotle tasks` reported task
`95d8c563-8e6a-46f4-932a-881410a09d63` as `QUEUED`.

## Integration

Integrated 2026-06-21 into:

```text
PhysicsSM/Draft/NullEdgeQubitConcurrence.lean
```

Aristotle returned a clean finite algebra proof for all requested targets:

```lean
trace2_mul_self_eq_trace_sq_sub_two_det
linearEntropyComplex_eq_concurrenceSq_of_trace_one
normalized_mass_ratio_eq_concurrence
normalized_mass_ratio_sq_eq_four_det
qubitConcurrence_sq_eq_four_det
```

The source result was inspected at:

```text
AgentTasks/aristotle-output/097cc326-5ae4-46b2-8786-de2975ac8103/extracted/project-files.tar/null-edge-qubit-concurrence-20260621-project_aristotle/NullEdgeQubitConcurrence/Finite.lean
```

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeQubitConcurrence.lean
lake build PhysicsSM.Draft.NullEdgeQubitConcurrence
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft PhysicsSM/Draft/NullEdgeQubitConcurrence.lean PhysicsSM/Draft/NullEdgePathPairInterchange.lean
```

Semantic review:

- finite algebra only;
- no positivity, Hermiticity, density-matrix, LOCC, or dynamics claim added;
- module docstring records the claim boundary and identifies the result as the
  determinant/concurrence wrapper for the reduced-celestial-density program.
