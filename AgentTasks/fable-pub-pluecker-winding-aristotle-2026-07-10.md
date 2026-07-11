# Aristotle proof task: derived Pluecker link winding (Paper C pillar 1)

Overnight publication run 2026-07-11, Fable lane F2. Focused standalone
package (Mathlib-only; self-contained seed).

## Target

`PlueckerWinding/Main.lean`: six holes.

- T1 `totalTurning_int_multiple`: the cycle sum of principal arguments of
  neighbor ratios of a nowhere-zero field is an exact `2 * pi * Int`
  multiple. Suggested route: telescoping cyclic product equals one, then
  additivity of `Complex.arg` in `Real.Angle`.
- T2 `totalTurning_const`: constant field control (zero turning).
- T3 `linkIncrement_global_phase`: global unit factor leaves every derived
  increment unchanged (chiral covariance of derived data).
- T4 `windingOneField_totalTurning`: `z p = I ^ p.val` on `ZMod 4` has total
  turning exactly `2 * pi` (each ratio is `I`, `arg I = pi / 2`).
- T5 `totalTurning_eq_zero_of_global_lift`: derived increments matching a
  global real lift force zero turning (derived-data version of the project
  no-go).
- T6 `windingOneSpinors_pluecker`: the winding-one field is the Pluecker
  coordinate of explicit primitive spinors.

## Why it matters (manuscript consequence)

Upgrades Paper A open problem 5 and starts Paper C: the patched link data
previously *supplied* by hand (`threeLinkUnitWinding`) is now *derived* from
a local null-spinor field with kernel-checked integrality, covariance, a
winding-one witness, and the no-go bridge. Remaining Paper C gate after this:
index-to-localized-mode.

## Kill condition

If T1 is false as stated (e.g. branch pathology at negative reals), report
the exact counterexample; do not weaken to constant-modulus fields.

```yaml
aristotle:
  project_id: e64d0d5d-cf00-481e-b548-017d9769e318
  target_file: PlueckerWinding/Main.lean
  expected_module: PlueckerWinding.Main
  submission_project: AgentTasks/aristotle-submit/fable-pub-pluecker-winding-20260710-project
  output_dir: AgentTasks/aristotle-output/e64d0d5d-cf00-481e-b548-017d9769e318
  status: landed
  run: overnight-publication-run-2026-07-11
  owner: Fable
```
