# Aristotle: coordinate h2(C)-block stabilizer inside SU(3)

Run lane: Jordan-Clifford JC1, second wave. Owner: Codex.

Close every declaration in
`JCH2BlockStabilizer/Main.lean`. This is the missing small coordinate rung in
the first `SU(3)` factor of Baez--Schwahn Theorem 1: unitary conjugation
preserves the upper `2 x 2` block exactly when the matrix is block diagonal,
and determinant one gives the `S(U(2) x U(1))` relation.

The theorem is intentionally coordinate and must stay so. Do not claim an
intrinsic `F4` stabilizer, transitivity, the full `S(U(2) x U(3))`
intersection, or removal of the identity-component hypothesis. Those remain
external/source-verified or open.

Witness: the nonidentity diagonal phase matrix. Negative control: the unitary
swap mixing axis 1 with axis 2. All proofs must be kernel checked; no compiled
evaluation.

```yaml
aristotle:
  project_id: b73917ae-a947-4e50-b8d8-dbd6448518b5
  task_id: pending
  target_file: JCH2BlockStabilizer/Main.lean
  expected_module: JCH2BlockStabilizer.Main
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc-h2-block-stabilizer-20260711-project
  output_dir: AgentTasks/aristotle-output/b73917ae-a947-4e50-b8d8-dbd6448518b5
  status: submitted
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
