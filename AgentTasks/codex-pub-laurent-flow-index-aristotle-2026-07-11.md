# Aristotle proof job: additive Laurent determinant flow index

## Objective

Close every proof hole in `AgentTasks/aristotle-targets/LaurentFlowIndex.lean`
without changing definitions or theorem statements. Run only:

```text
lake env lean AgentTasks/aristotle-targets/LaurentFlowIndex.lean
```

Use the landed `LaurentUnitResource` theorem to package the unique determinant
exponent of an invertible finite Laurent matrix as an additive invariant. Prove:

- existence/uniqueness and selected-exponent specification;
- addition under matrix multiplication;
- identity exponent zero;
- exact pure-shift normalization; and
- the one-channel two-shift noninvertibility control.

Preserve all theorem statements and the exact control. Do not use a compiled
evaluator, introduce assumptions, or identify the result with a physical GNVW
index. If a dependent proof argument such as `hM.mul hN` causes proof-irrelevance
friction, solve it with proposition proof irrelevance rather than changing the
public statement.

Semantic boundary: one Laurent variable over a field and invertibility over the
Laurent ring only. No three-dimensional no-doubling or physical index theorem.

```yaml
aristotle:
  project_id: de5baafe-fb03-4e3a-aab6-dd33a73d80eb
  task_id: bbad6bbe-8372-431c-ab96-f99b5758d4d7
  target_file: AgentTasks/aristotle-targets/LaurentFlowIndex.lean
  expected_module: AgentTasks.aristotle-targets.LaurentFlowIndex
  submission_project: AgentTasks/aristotle-submit/codex-pub-laurent-flow-index-20260711-project
  output_dir: AgentTasks/aristotle-output/de5baafe-fb03-4e3a-aab6-dd33a73d80eb
  status: integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

At 08:14 PDT Codex observed the project idle. Codex downloaded the final source,
confirmed that every frozen statement was unchanged, found no proof holes or
escape-hatch tokens, and compiled it directly against the pinned live
toolchain. It was integrated as
`PhysicsSM/Draft/NullEdge/LaurentFlowIndex.lean` with standard-three guards.
