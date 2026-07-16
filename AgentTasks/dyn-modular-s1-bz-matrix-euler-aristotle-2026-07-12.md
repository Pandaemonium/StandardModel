# Aristotle task: S1 — the 2x2 matrix Euler formula for `B_z`

DYN-MODULAR-001 successor S1. Closes the phase-witness -> selected-flow gap:
once `bz_matrix_euler` lands, `Uop`'s closed form matches `exp(-i a Kop)` on the
pair sector (via the `kop_highPair`/`kop_lowPair` bridge + `Bz_sq`), upgrading
`pair_evolution_phase_sensitive` from "the supplied evolution reads phase" to
"the selected modular flow reads phase".

## Target

`S1BzMatrixEuler.bz_matrix_euler` (single `s o r r y`):

```text
exp((-(a) i) • Bz z) = cos(a‖z‖) • 1 - (i sin(a‖z‖)/‖z‖) • Bz z
```

with `Bz z = !![0, z; conj z, 0]`, `a : ℝ`, `z ≠ 0`. The key input
`Bz_sq : Bz z * Bz z = (z * conj z) • 1` is PROVED in the file.

## Route

`M := (-(a) i) • Bz z` has `M^2 = (-(a) i)^2 ‖z‖^2 • 1` (scalar multiple of `1`,
from `Bz_sq`), so split the `NormedSpace.exp` power series into even/odd terms:
even -> `cosh((-(a) i)‖z‖) • 1 = cos(a‖z‖) • 1`, odd ->
`(sinh((-(a) i)‖z‖)/‖z‖) • Bz z = -(i sin(a‖z‖)/‖z‖) • Bz z`. Alternatively
diagonalize `Bz z` (eigenvalues `+-‖z‖`) and push `exp` through conjugation.

## Verification

`lake env lean S1BzMatrixEuler.lean`. Keep `Bz` and `Bz_sq` byte-identical; close
only the `bz_matrix_euler` hole. Standard axiom footprint expected
(`propext`, `Classical.choice`, `Quot.sound`).

```yaml
aristotle:
  project_id: 0bf55f18-27fe-4c74-8643-5ab8f8cd5d6e
  task_id: PENDING
  target_file: AgentTasks/aristotle-standalone/s1-bz-matrix-euler-20260712/S1BzMatrixEuler.lean
  expected_module: S1BzMatrixEuler
  submission_project: AgentTasks/aristotle-submit/s1-bz-matrix-euler-20260712
  status: submitted
```
