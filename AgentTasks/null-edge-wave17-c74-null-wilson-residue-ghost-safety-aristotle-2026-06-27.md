# Aristotle task C74: post-gauge residue and ghost-safety plan

```yaml
aristotle:
  project_id: ab8a2120-6957-447f-8020-3963c67ea39e
  task_id: b70f8e3d-c83f-4abb-a31a-78a022de3f2e
  target_file: AgentTasks/null-edge-null-wilson-residue-ghost-safety-plan.md
  expected_module: report-only
  submission_project: AgentTasks/aristotle-submit/null-edge-wave17-null-wilson-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/ab8a2120-6957-447f-8020-3963c67ea39e
  status: integrated
```

Context pack:

- `AgentTasks/context-packs/null-edge-gate-c-null-wilson-20260627-063900.md`

Goal: turn the Golterman-Shamir ghost warning into concrete finite theorem
obligations for the regulated/projected operator.

Required output:

```text
AgentTasks/null-edge-null-wilson-residue-ghost-safety-plan.md
```

Questions to answer:

```text
1. What finite data define a pole/sheet for D_phys?
2. What is the correct energy variable q_0 in the tetrahedral/null-edge setting?
3. How should left eigenvectors be defined: Hilbert adjoint, Krein adjoint, or
   retarded/advanced paired adjoint?
4. Can residue positivity be stated as
      Z_j^{-1} = w_j^dagger J (partial_{q_0} D_phys) v_j
   with Z_j > 0 on the physical quotient?
5. Which known C47/C48 ghost-zero predicates can be reused?
6. What is the smallest Lean API for PostGaugeResiduePositive?
```

Guardrail:

Do not claim ghost safety from flavored index, projected chirality, or gauge
covariance alone. The output should be an actionable theorem plan.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: ab8a2120-6957-447f-8020-3963c67ea39e
task_id: b70f8e3d-c83f-4abb-a31a-78a022de3f2e
submission_project: AgentTasks/aristotle-submit/null-edge-wave17-null-wilson-gate-c-20260627-project
target: AgentTasks/null-edge-null-wilson-residue-ghost-safety-plan.md
```

## Integration record, 2026-06-27

Integrated into the live repo by Codex.

```text
project_id: ab8a2120-6957-447f-8020-3963c67ea39e
task_id: b70f8e3d-c83f-4abb-a31a-78a022de3f2e
copied_files:
  - AgentTasks/null-edge-null-wilson-residue-ghost-safety-plan.md
summary: AgentTasks/aristotle-output/ab8a2120-6957-447f-8020-3963c67ea39e/ARISTOTLE_SUMMARY.md
```

No local Lean build or pre-commit was run during this integration pass.
