# Aristotle task C76: C64 off-branch witness regulator-lift theorem

```yaml
aristotle:
  project_id: 13131a2b-6428-440b-9372-decd7603a608
  task_id: 545cb058-0bef-4b9a-8a4a-b69f2c10d22e
  target_file: PhysicsSM/Draft/NullEdgeC64WitnessRegulatorLift.lean
  expected_module: PhysicsSM.Draft.NullEdgeC64WitnessRegulatorLift
  submission_project: AgentTasks/aristotle-submit/null-edge-wave18-flavored-mass-overlap-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/13131a2b-6428-440b-9372-decd7603a608
  status: submitted
```

Context pack:

- `AgentTasks/context-packs/gate-c-flavored-mass-overlap-20260627-065620.md`

Wave context:

- `AgentTasks/null-edge-wave18-flavored-mass-overlap-analysis-2026-06-27.md`
- `AgentTasks/null-edge-wave17-submissions-2026-06-27.md`

Kind: proof/strategy.

Goal:

Create a small kernel-checked module proving that the C64 off-branch determinant-zero witness is lifted by any regulator with the scalar Wilson lower-bound shape.

The target witness is:

```text
q_star = (2*pi/3, 0, 0, 4*pi/3)
```

The useful finite calculation is:

```text
cos(2*pi/3) = -1/2,
cos(0) = 1,
cos(4*pi/3) = -1/2,
W(q_star) = sum_a (1 - cos q_a) = 3.
```

Then package a general nonzero theorem for a regulator symbol such as `R(q) = r * W(q)` under `r != 0`, or an abstract regulator whose norm is bounded below by a positive multiple of `W(q_star)`.


Requested deliverable:

Write `PhysicsSM/Draft/NullEdgeC64WitnessRegulatorLift.lean`.

Requested theorem names can be adjusted for Lean style, but aim for:

```text
wilsonScalar_c64Witness_eq_three
regulator_lifts_c64Witness_of_nonzero_coeff
c64Witness_not_missed_by_wilsonLowerBound
```

If exact real trigonometric constants become too expensive, use a finite algebraic model of the cosine values and clearly document that this is the branch-symbol arithmetic model, not an analytic trig theorem.


Scope guardrails:

Do not duplicate Wave 17's global `W(q)=0 iff origin` target except as a local witness calculation. Do not claim this is a chiral release theorem. This is only the first positive control result against the specific C64 failure of `T_lin`.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: 13131a2b-6428-440b-9372-decd7603a608
task_id: 545cb058-0bef-4b9a-8a4a-b69f2c10d22e
submission_project: AgentTasks/aristotle-submit/null-edge-wave18-flavored-mass-overlap-gate-c-20260627-project
target: PhysicsSM/Draft/NullEdgeC64WitnessRegulatorLift.lean
```
