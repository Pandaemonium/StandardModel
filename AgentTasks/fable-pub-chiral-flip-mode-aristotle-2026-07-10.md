# Aristotle proof task: protected flip modes from chiral determinant sign (Paper C pillar 2 engine)

Overnight publication run 2026-07-11, Fable lane F2. Focused standalone
package (Mathlib-only; `ChiralInvolution` reproduced verbatim from
`Carrier/ChiralZeroModeParity.lean`).

## Target

`ChiralFlipMode/Main.lean`: six holes.

- T1 `chiral_unitary_charpoly_roots_conj`: root multiset conj-closed
  (similarity to the adjoint via the involution).
- T2 `unitary_charpoly_root_unimodular`: unitary roots are unimodular.
- T3 `chiral_unitary_det_eq_neg_one_pow`: `det W = (-1)^mult(-1)`.
- T4 `chiral_det_neg_one_forces_flip_mode`: `det = -1` forces an exact
  `-1` eigenvector (the protection statement: hypothesis is class data
  only).
- T4b `chiral_det_neg_one_forces_fixed_mode_of_even`: in even dimension a
  `+1` partner mode is also forced (walk registers are even-dimensional).
- T5 witness (`sigma_x`, det `-1`, explicit mode `(1,-1)`) and identity
  control (det `1`, no flip mode).

## Why it matters (manuscript consequence)

Upgrades the project's chiral determinant dichotomy from "multiplicity
reading in prose" to kernel-checked protected-mode existence. This is the
engine for Paper C's winding-to-mode gate: combined with the in-flight
derived-winding job (e64d0d5d), a chiral walk whose derived data forces
`det = -1` has a protected flip mode for the entire symmetry class.

## Kill condition

If T3's pairing argument fails as stated (e.g. multiset counting subtlety),
report the exact failing multiset identity; do not add diagonalizability
hypotheses.

```yaml
aristotle:
  project_id: ecbe0d8b-202c-4860-98ee-996ad37c4a68
  target_file: ChiralFlipMode/Main.lean
  expected_module: ChiralFlipMode.Main
  submission_project: AgentTasks/aristotle-submit/fable-pub-chiral-flip-mode-20260710-project
  output_dir: AgentTasks/aristotle-output/ecbe0d8b-202c-4860-98ee-996ad37c4a68
  status: landed
  run: overnight-publication-run-2026-07-11
  owner: Fable
```
