# Codex proof job: finite 3+1 D4 null-shift unitary walk

Close every proof in `D4Walk/Core.lean` without changing definitions,
statements, orientation, direction order, or controls. Prove that the six
future axial directions are Lorentz-null unit spatial steps; their periodic
position shifts preserve the finite complex inner product; a supplied unitary
six-state coin preserves that inner product; and shift-after-coin therefore
gives an exactly norm-preserving finite 3+1 walk. Preserve the nontrivial
`L=5`, x-plus movement control.

This is the next composition rung after the landed D4 shell, explicit spinor
factors, and generic unitary-history theorem. It should establish an actual
finite local 3+1 null-shift dynamics, not merely an internal Clifford symbol.

Do not claim that the six-state coin reproduces the four-component Dirac walk,
that the preferred time axis is derived, that D4 uniquely determines the
lattice, or that a Lorentz-covariant continuum limit follows. Those are later
intertwiner/symmetry/convergence gates.

Run `lake env lean D4Walk/Core.lean`; return the complete file and any index,
conjugation, or periodic-shift mismatch.

Context pack:
`AgentTasks/context-packs/d4-finite-unitary-walk-20260710-20260710-021300.md`.

```yaml
aristotle:
  project_id: 1253313b-b5be-41c7-8bf9-7a15786e1c46
  target_file: D4Walk/Core.lean
  expected_module: D4Walk.Core
  submission_project: AgentTasks/aristotle-submit/codex-d4-finite-unitary-walk-20260710-project
  output_dir: AgentTasks/aristotle-output/1253313b-b5be-41c7-8bf9-7a15786e1c46
  status: idle; harvested and integrated
```
