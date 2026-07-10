# Codex proof job: D4 null-shell 3+1 lattice

Close every proof in `D4NullShell/Core.lean` without changing the explicit root
list, metric signature, definitions, statements, or counts. Prove that the 24
D4 roots all have Euclidean norm-squared two; exactly twelve roots become
Minkowski-null after coordinate zero is distinguished as time; every selected
root has unit time magnitude and unit spatial displacement; the null shell is
antipodal; and a purely spatial D4 root supplies the required spacelike control.

This establishes a concrete axial 3+1 luminal step alphabet. It does not derive
the Lorentzian time-coordinate selection from the bare D4 lattice, construct a
BCC/tetrahedral walk, assign spinor projectors, prove unitarity, or take a
continuum limit.

Run `lake env lean D4NullShell/Core.lean`. Prefer kernel-reducible `decide` or
explicit finite proofs; do not use `native_decide`. Return the complete file.

Context pack:
`AgentTasks/context-packs/d4-null-shell-lattice-20260710-20260710-010158.md`.

```yaml
aristotle:
  project_id: 1b9a9cad-67b2-46ef-a56c-c6f46b4c6ea0
  target_file: D4NullShell/Core.lean
  expected_module: D4NullShell.Core
  submission_project: AgentTasks/aristotle-submit/codex-d4-null-shell-lattice-20260710-project
  output_dir: AgentTasks/aristotle-output/1b9a9cad-67b2-46ef-a56c-c6f46b4c6ea0
  status: running
```
