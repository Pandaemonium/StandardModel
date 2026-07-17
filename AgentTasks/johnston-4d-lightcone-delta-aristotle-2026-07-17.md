# Johnston four-dimensional light-cone delta Aristotle task

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: integrated

## Target

Prove the exact one-variable continuum calibration of Johnston's expected
four-dimensional causal-set link kernel.  In squared timelike separation
`s = tau^2`, use

```text
k_rho(s) = sqrt(rho) / (2*pi*sqrt(6))
           * exp (-(rho*pi/24) * s^2).
```

The public statements are in:

`AgentTasks/aristotle-standalone/johnston-4d-lightcone-delta-20260717/JohnstonLightconeDelta/GaussianKernel.lean`

The semantic context pack is:

`AgentTasks/context-packs/johnston-4d-lightcone-delta-20260717-065708.md`

## Statement lock

Aristotle may add local helper lemmas but must not weaken or change the public
definitions or theorem statements.  In particular:

- the Alexandrov-volume coefficient remains `pi / 24`;
- the Johnston prefactor remains `sqrt(rho) / (2*pi*sqrt(6))`;
- the one-sided integral remains exactly `1 / (2*pi)`;
- the pairing theorem must cover every bounded continuous real test function;
- no compact-support, differentiability, or analyticity assumption may be
  added;
- the result must not be described as a full four-dimensional distributional
  theorem, a random-sprinkling concentration theorem, or a Higgs propagator.

## Mathematical sketch

Mathlib provides `integral_gaussian_Ioi`:

```text
integral_gaussian_Ioi b:
  integral over s > 0 of exp (-b*s^2) = sqrt(pi/b)/2.
```

Set `b = rho*pi/24` and simplify positive square roots to obtain

```text
integral over s > 0 of k_rho(s) = 1/(2*pi).
```

For `s != 0`, exponential decay in `rho*s^2` dominates the `sqrt(rho)`
prefactor.  For bounded continuous `f`, split the pairing into a small
neighborhood of zero and its complement, or rescale `u = sqrt(rho)*s` and use
dominated convergence.  The total mass is fixed, continuity controls the near
part, and Gaussian decay controls the tail.

## Physical scope

For Poisson sprinkling into four-dimensional Minkowski spacetime, the expected
link indicator between fixed causally related endpoints is `exp (-rho V)` and
`V = pi*tau^4/24`.  Thus this theorem calibrates concentration in the scalar
normal variable `s = tau^2`.  It does not supply the missing Lorentzian
coarea/disintegration theorem, the retarded time-orientation factor, or
concentration of individual finite sprinklings around the expectation.

## Literature context

- S. Johnston, *Particle propagators on discrete spacetime*, arXiv:0806.3083.
- N. X, F. Dowker, and S. Surya, *Scalar field Green functions on causal sets*,
  arXiv:1701.07212.

## Verification contract

Run first:

```text
lake env lean JohnstonLightconeDelta/GaussianKernel.lean
```

Return the completed target file and a short report listing solved targets,
any statement changes, remaining proof holes, and assumptions used.

## Aristotle metadata

```yaml
aristotle:
  project_id: 60ff4409-badc-44a5-9b52-78a82eac751c
  task_id: c712b62d-6237-4cf4-bedc-54dd19549f62
  target_file: JohnstonLightconeDelta/GaussianKernel.lean
  expected_module: JohnstonLightconeDelta.GaussianKernel
  submission_project: AgentTasks/aristotle-submit/johnston-4d-lightcone-delta-20260717-project
  output_dir: AgentTasks/aristotle-output/60ff4409-badc-44a5-9b52-78a82eac751c
  status: integrated
```

## Integration record

Aristotle proved all five locked targets without changing any public
definition, theorem statement, or hypothesis. The returned source contains no
proof holes or added assumption declarations and replays locally under the
pinned repository toolchain. The production port is:

`PhysicsSM/Draft/NullEdge/Johnston4DLightconeDelta.lean`

The production module adds build-enforced axiom guards. They report only
`propext`, `Classical.choice`, and `Quot.sound`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/Johnston4DLightconeDelta.lean
lake build PhysicsSM.Draft.NullEdge.Johnston4DLightconeDelta
```

Both commands pass. The theorem remains explicitly scoped to the one-sided
normal coordinate and the ensemble-expected link kernel; the coarea and random
concentration gates remain open.
