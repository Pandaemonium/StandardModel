# Codex proof job: unitarity under sequential and parallel histories

Close every proof in `UnitaryHistory/Core.lean` without changing definitions,
statements, list order, Kronecker convention, or Pauli fixture. Prove unitary
closure under multiplication and Kronecker product, then prove that a history
of unitary gates has unitary total evolution and that equal-length parallel
unitary histories remain unitary. Preserve the noncommuting Pauli control.

This closes the unitarity input for the landed operator-valued history functor.
It does not derive the local gates from primitive null data, choose the physical
Krein sector, or establish continuum locality.

Run `lake env lean UnitaryHistory/Core.lean`; return the complete file and any
orientation issue.

Context pack:
`AgentTasks/context-packs/unitary-history-composition-20260710-20260710-010158.md`.

```yaml
aristotle:
  project_id: 23a16501-66f5-4123-8e34-ac4909c555c6
  target_file: UnitaryHistory/Core.lean
  expected_module: UnitaryHistory.Core
  submission_project: AgentTasks/aristotle-submit/codex-unitary-history-composition-20260710-project
  output_dir: AgentTasks/aristotle-output/23a16501-66f5-4123-8e34-ac4909c555c6
  status: running
```
