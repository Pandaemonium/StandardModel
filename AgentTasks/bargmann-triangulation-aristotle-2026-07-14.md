# Aristotle task: Bargmann triangulation

## Objective

Prove every target in `BargmannTriangulation.lean` without changing any
statement.  The central result is the exact quadrilateral-to-two-triangles
identity, with the diagonal correction proved real and nonnegative.

## Review constraints

- Keep `overlap` conjugate-linear in its first spinor.
- Preserve the ordered products in `triangle` and `quadrilateral`.
- Do not add normalization assumptions.
- The division theorem may use only its displayed nonzero-diagonal hypothesis.
- Do not replace the algebraic result with an unformalized `arg` statement.
- Run `lake env lean BargmannTriangulation.lean` first.

## Semantic context

- Context pack:
  `AgentTasks/context-packs/bargmann-triangulation-20260714-20260714-201014.md`
- Precursors: `PhysicsSM/Draft/NullEdge/BargmannCP.lean` and
  `PhysicsSM/Draft/NullEdge/SpinCornerBargmannAristotle.lean`.

## Submission metadata

```yaml
aristotle:
  project_id: 5549d6a9-b355-481d-8cb1-4f833f30115a
  task_id: 76298ab5-bc8b-4be2-aaf5-7acd6746b2f2
  target_file: AgentTasks/aristotle-standalone/bargmann-triangulation-20260714/BargmannTriangulation.lean
  expected_module: BargmannTriangulation
  submission_project: AgentTasks/aristotle-submit/bargmann-triangulation-20260714-project
  output_dir: AgentTasks/aristotle-output/5549d6a9-b355-481d-8cb1-4f833f30115a
  status: submitted
```
