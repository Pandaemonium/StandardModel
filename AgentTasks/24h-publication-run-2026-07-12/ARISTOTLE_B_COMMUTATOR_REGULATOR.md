# Aristotle target: exact commutator regulator

Prove every theorem in the focused package without changing statements. This is
the first construction primitive for the corrected strict-3+1 route: exact
unitarity, identity on either coordinate axis, the anticommuting central-collapse
control, and a genuinely noncentral mixed fixture. Keep the scope at finite
complex matrices. Do not claim that the trigonometric factors have already been
packaged as Laurent matrices or that chirality-oddness is proved here.

```yaml
aristotle:
  project_id: 1b5d1015-a2a1-4f4a-b0da-5ab23a328c94
  task_id: d231e2c6-855d-4671-ab3e-13284c72a398
  target_file: CommutatorRegulator.lean
  expected_module: CommutatorRegulator
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-commutator-regulator-20260711-project
  output_dir: AgentTasks/aristotle-output/1b5d1015-a2a1-4f4a-b0da-5ab23a328c94
  status: landed-with-explicit-statement-correction
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Aristotle closed the target but correctly found the original
`anticommuting_quarterTurn_eq_neg_one` false: it omitted `G * G = 1`. The
intended theorem concerns two involutions, so the promoted module adds that
load-bearing hypothesis and includes a kernel-checked counterexample to the
omitted version. No result is claimed statement-preserving. Direct Lean PASS;
targeted build PASS (8,026 jobs); Lean LSP axiom/source audit PASS for all four
headline declarations with only the standard footprint.
