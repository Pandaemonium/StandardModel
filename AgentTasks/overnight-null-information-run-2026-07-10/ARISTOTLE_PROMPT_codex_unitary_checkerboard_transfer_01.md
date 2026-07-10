# Codex proof job: exact unitary checkerboard transfer

Close every proof in `UnitaryTransfer/Core.lean` without changing definitions,
statements, matrix orientation, phases, coefficients, or controls. Prove that
the checkerboard transfer with imaginary turn amplitude, unit-modulus outgoing
phases, and `c^2+s^2=1` is exactly two-sided unitary; identify it with the
turn/phase transfer using `mu=i*s/c`; lift unitarity through every finite
replicated history; and preserve the rational `3/5,4/5` massive witness plus the
real-turn nonunitary control.

This closes the finite quantum-evolution input for the physical normalized
transfer family. It does not derive `c,s,uL,uR` from primitive data, establish a
continuum limit, or identify `s` with an observed mass without calibration.

Run `lake env lean UnitaryTransfer/Core.lean`; return the complete file and any
row/column or phase-conjugation mismatch.

Context pack:
`AgentTasks/context-packs/unitary-checkerboard-transfer-20260710-20260710-015011.md`.

```yaml
aristotle:
  project_id: 2df7fa8b-86d2-41bf-95c1-f35dede4807c
  target_file: UnitaryTransfer/Core.lean
  expected_module: UnitaryTransfer.Core
  submission_project: AgentTasks/aristotle-submit/codex-unitary-checkerboard-transfer-20260710-project
  output_dir: AgentTasks/aristotle-output/2df7fa8b-86d2-41bf-95c1-f35dede4807c
  status: idle; harvested and integrated
```
