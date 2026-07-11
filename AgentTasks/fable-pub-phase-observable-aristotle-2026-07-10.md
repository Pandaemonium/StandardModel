# Aristotle proof task: operational Pluecker-phase discriminator (Paper E)

Overnight publication run 2026-07-11, Fable lane F3. Focused standalone
package (Mathlib-only; all project definitions reproduced verbatim in the
seed).

## Target

`PhaseObservable/Main.lean`: seven holes.

- T1 `witness_equal_modulus`: `z1 = 3+4i` and `z2 = 5` have equal modulus
  squared.
- T2 `witness_conjugate_restOperators`: explicit chiral unitary conjugates
  `massOperator z1` to `massOperator z2` (one-particle physics identical).
- T3 `chiralPhase_u12_unitary`.
- T4 `doubleKick_return_amplitude`: two-kick loop returns the low pair with
  amplitude `u2 * conj u1` (reads the relative Pluecker phase).
- T5 `pairKick_fixes_vacuum`: vacuum is an untouched interferometric
  reference.
- T6 `doubleKick_interference_amplitude`: overlap of the vacuum+pair
  superposition after the loop is `(1 + u2 * conj u1)/2`.
- T7 `witness_survival_probability`: survival probability exactly `4/5` at
  the equal-modulus witnesses versus exactly `1` for the equal-field
  control.

## Why it matters (manuscript consequence)

Closes referee objection R1 operationally for Paper A/E: two walks with
provably identical one-particle physics (T1-T3) are distinguished by an
exact finite two-particle interference probability (T4-T7). This is the
reparametrization-test escape stated as a measurement, not a labeling.

## Kill condition

If T4/T6/T7 fail as stated (e.g. a sign error in the kick composition),
report the exact computed amplitude; do not modify the kick definition.

```yaml
aristotle:
  project_id: a4420507-98f4-4e55-88af-1b8e940c1e93
  target_file: PhaseObservable/Main.lean
  expected_module: PhaseObservable.Main
  submission_project: AgentTasks/aristotle-submit/fable-pub-phase-observable-20260710-project
  output_dir: AgentTasks/aristotle-output/a4420507-98f4-4e55-88af-1b8e940c1e93
  status: submitted
  run: overnight-publication-run-2026-07-11
  owner: Fable
```
