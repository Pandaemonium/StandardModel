# Aristotle: positive-Weyl branch completeness

Prove the two exact global biconditionals classifying when the actual live
positive `2 x 2` Weyl step equals `+I` or `-I`.  The branch sign must be carried
by the exact `u0` coefficient; do not infer it from the full `4 x 4` determinant,
whose body centers contain both quasienergies.  Close the disjointness,
nondegenerate-Jacobian, and rank-deficient negative-control successors without
weakening any statement.

The target typechecks with six isolated proof holes.  Neo4j was unavailable
when the semantic context pack was attempted; the target imports the exact
live Pauli decomposition, full determinant classification, and live census
bridge directly.

Harvest verdict: every statement landed unchanged. The two matrix equations
reduce to `u0 = +1` and `u0 = -1` through the exact unit-quaternion identity;
the global trigonometric case split then proves the corner/body-center branch
classification. Both branches are disjoint and every crossing has nonzero
actual Frechet-Jacobian determinant. The independent hostile branch audit
`0eefb107` had already confirmed the same case census.

```yaml
aristotle:
  project_id: ae7aec57-4900-4422-b2f2-d5a0d702993f
  task_id: eca64a29-4a84-4418-97c6-a0f05c3a60cb
  target_file: AgentTasks/aristotle-targets/codex_24h_b_positive_weyl_branch_completeness.lean
  expected_module: PhysicsSM.Draft.NullEdge.PositiveWeylBranchCompleteness
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-positive-weyl-branch-completeness-20260711-project
  output_dir: AgentTasks/aristotle-output/ae7aec57-4900-4422-b2f2-d5a0d702993f
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
