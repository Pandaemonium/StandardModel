# Aristotle: operator-level corrected Furey/Fock intertwiner

Run lane: Jordan-Clifford JC2 successor. Owner: Codex.

Close every declaration in
`AgentTasks/aristotle-targets/codex_24h_jc2_operator_intertwiner.lean` without
changing statements. The landed predecessor proves all 48 basis action-table
entries and the basis linear equivalence separately. This target must prove
that actual left multiplication by each concrete ladder element preserves the
whole corrected `Jbar'` span, define its restricted linear map, and show the
linear equivalence intertwines it with standard signed exterior
creation/contraction on every vector.

Use `alpha_mul_JbarBasisState'_eq_action` and span/basis induction for
preservation. Do not define `jbarLadderLinear` by conjugating the Fock map; its
`toFun` is fixed as concrete left multiplication. Do not assert
`Lmul (a*b) = Lmul a * Lmul b`: raw octonion multiplication is
nonassociative. Kernel proofs only, with no compiled evaluation.

Witness: creation on the empty occupancy. Control: repeated creation on an
occupied mode is zero. Kill condition: if the matrix orientation in
`fockActionMatrix` is reversed, report and correct only that definition before
proof search; do not weaken the intertwining theorem.

```yaml
aristotle:
  project_id: 40a38072-7634-4708-9721-4123cdd253e7
  task_id: pending
  target_file: AgentTasks/aristotle-targets/codex_24h_jc2_operator_intertwiner.lean
  expected_module: none-handoff
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc2-operator-intertwiner-20260711-project
  output_dir: AgentTasks/aristotle-output/40a38072-7634-4708-9721-4123cdd253e7
  status: submitted
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
