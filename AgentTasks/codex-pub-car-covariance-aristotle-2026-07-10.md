# Aristotle proof task: annihilation covariance from adjointness

Prove the single theorem in `CARCovariance/Main.lean` without changing its
statement or hypotheses.

Use the now-landed APIs imported by the target:

- `fockInner_create_left` and `fockInner_annihilate_left`;
- `gamma_create_covariance`;
- `fockInner_Gamma_left` and `Gamma_preserves_fockInner`;
- `Gamma_unitary_inverse`.

Requirements:

- preserve the covariance orientation
  `a_j Gamma(U) = sum_i U(j,i) Gamma(U) a_i`;
- retain arbitrary finite linearly ordered modes and both one-particle unitary
  identities;
- derive the theorem from adjointness rather than reopening ordered-minor
  cofactors;
- do not add assumptions or use a compiler-trusting shortcut;
- if the orientation is false, return an exact smallest counterexample rather
  than conjugating or transposing the coefficients silently.

Boundary: exact finite Fock covariance only, not interacting causal locality.

```yaml
aristotle:
  project_id: 816777bf-e973-4324-a6b0-ffcf07351845
  target_file: AgentTasks/aristotle-standalone/codex-pub-car-covariance-20260710/CARCovariance/Main.lean
  expected_module: direct-file target
  submission_project: AgentTasks/aristotle-submit/codex-pub-car-covariance-20260710-project
  output_dir: AgentTasks/aristotle-output/816777bf-e973-4324-a6b0-ffcf07351845
  status: canceled-after-local-landing
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## 2026-07-11 00:22 PDT instruction

Downloaded the live snapshot. The target still had three holes. Proved the two
generic inner-product helpers independently in
`AgentTasks/scratch/CARCovarianceHelpers.lean`, then sent their exact compiling
proofs with `aristotle continue --mode instruct`. The remaining task is only
`gamma_annihilate_covariance_target`; its statement and coefficient orientation
`U j i` remain fixed.

## Disposition

The complete covariance theorem was then proved independently in the live
module, in the stronger form requiring no unitarity hypotheses. The requested
unitary theorem shape is retained as a corollary, and the exact
relation-filtered annihilation-support theorem was composed immediately.
Direct Lean checking passed. The still-running Aristotle task was canceled at
00:36 PDT to release capacity; no returned proof was integrated.
