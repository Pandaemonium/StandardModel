# Johnston four-dimensional radial lift Aristotle task

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: submitted

## Target

Complete the self-contained Gaussian delta-sequence source and prove its
radial lift for an abstract bounded continuous angular average `F(r,s)`.

Public targets:

- `JohnstonLightconeDelta/GaussianKernel.lean`
- `JohnstonLightconeDelta/RadialLift.lean`

Conceptual specification:

`AgentTasks/johnston-4d-lightcone-coarea-successor-2026-07-17.md`

## Statement lock

- Preserve every definition and theorem statement exactly.
- Do not add support away from `r=0`, compact support for `F`, differentiability,
  or analyticity assumptions.
- Keep `F` an arbitrary bounded continuous function on `Real x Real`.
- Keep the outer radial domain `Ioc 0 R` and the limit coefficient exactly
  `r * F(r,0)`.
- Do not describe the result as a spherical-coordinate identity, a full
  Minkowski distribution theorem, or random-sprinkling concentration.

## Proof sketch

The Gaussian file is identical in statement to Aristotle project
`60ff4409-badc-44a5-9b52-78a82eac751c`. For the radial lift:

1. use `sqrt(r^2+s) >= r` for `r,s >= 0` to bound the Jacobian by `2*pi*r`;
2. at fixed `r>0`, extend the positive-half-line test function continuously to
   all real `s`, for example by composing with `max s 0`, and apply the Gaussian
   pairing theorem;
3. kernel positivity, exact mass `1/(2*pi)`, and the Jacobian bound dominate the
   inner integral by `r * ||F||_infinity`;
4. apply dominated convergence over the finite interval `Ioc 0 R`.

## Verification

```text
lake env lean JohnstonLightconeDelta/GaussianKernel.lean
lake env lean JohnstonLightconeDelta/RadialLift.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 4abdba8f-8ff2-4ca4-a9b9-a96742b6e484
  task_id: 260fa93c-3870-41d6-a1c5-fe2fa93ae42a
  target_file: JohnstonLightconeDelta/RadialLift.lean
  expected_module: JohnstonLightconeDelta.RadialLift
  submission_project: AgentTasks/aristotle-submit/johnston-4d-radial-lift-20260717-project
  output_dir: AgentTasks/aristotle-output/4abdba8f-8ff2-4ca4-a9b9-a96742b6e484
  status: submitted
```
