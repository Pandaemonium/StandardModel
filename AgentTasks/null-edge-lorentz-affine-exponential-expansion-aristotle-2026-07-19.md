# Aristotle task: affine Lorentz exponential second-order expansion

## Objective

Complete the two exact definitions in
`AffineExponentialExpansion/AffineExponentialExpansion.lean` without changing
their signatures. Small helper lemmas are welcome.

The first theorem must derive an explicit normalized quadratic expansion of

`exp(t A + (t^2 / 2) B)`

with coefficient `(1/2)(A*A+B)` and a remainder tending to zero. The second
must derive the corresponding inverse expansion with coefficients `-A` and
`(1/2)(A*A-B)`.

This is a focused Mathlib-only analytic task. Please run

```text
lake env lean AffineExponentialExpansion/AffineExponentialExpansion.lean
```

first. Do not build or inspect the larger PhysicsSM repository. Do not weaken
the statements or add assumptions. Finish with a concise report listing solved
targets, any statement changes, remaining proof holes, and nonstandard axioms.

## Intended downstream use

The result will instantiate primitive forward and inverse link expansions for
an actual proper-Lorentz curve in the null-edge Palatini-to-Einstein bridge.

## Aristotle metadata

```yaml
aristotle:
  project_id: 01004378-bb30-48a6-b503-10c5dbb0fd54
  task_id: 2bfdd4f0-50d6-496b-b5fa-fb425e52e327
  target_file: AffineExponentialExpansion/AffineExponentialExpansion.lean
  expected_module: AffineExponentialExpansion
  submission_project: AgentTasks/aristotle-submit/lorentz-affine-exponential-expansion-20260719-project
  output_dir: AgentTasks/aristotle-output/01004378-bb30-48a6-b503-10c5dbb0fd54
  status: complete-reviewed
```

Submitted on 2026-07-19. Initial task state: `QUEUED`.

## Review outcome

Aristotle completed both requested definitions. The harvested candidate had no
proof holes and compiled under the focused Mathlib project. Its derivative-based
Taylor proof was mathematically aligned but substantially longer than needed.

The project therefore landed an independently derived power-series proof in
`PhysicsSM/Draft/NullEdge/SecondOrderCurveExpansion.lean`, with the same forward
and inverse coefficients and exact standard-three assumption guards. The result
now drives the proper-Lorentz curve and concrete Einstein capstone in
`PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniConcreteAffineCurve.lean`.
No Aristotle proof text was copied into project source.
