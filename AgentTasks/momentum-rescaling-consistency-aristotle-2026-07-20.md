# Momentum-rescaling consistency

## Purpose

Audit the proposed repair of Mathlib's explicit Fourier factor by rescaling
momentum. The job had to track the linear generator, norm-dependent error
constant, exponential, and compact momentum box together. A theorem that
changed only the displayed differential coefficient would not count.

## Aristotle record

```yaml
aristotle:
  project_id: 8c48fafa-3cc9-4f5a-bca4-2439be39bc04
  task_id: 2c68dcd9-9b43-442a-9f71-0576381d9272
  target_file: PhysicsSM/Draft/NullEdge/MomentumRescalingConsistency.lean
  expected_module: PhysicsSM.Draft.NullEdge.MomentumRescalingConsistency
  submission_project: momentum-rescaling-consistency-20260720
  output_dir: AgentTasks/aristotle-output/8c48fafa-3cc9-4f5a-bca4-2439be39bc04
  status: integrated
```

## Result

The returned source proves:

- linear generator scaling;
- exact positive norm scaling;
- exact momentum/step compensation in the matrix exponential;
- transformation of a one-step error profile;
- the compact-box law `K -> K / lam`;
- a combined consistency theorem coupling the constant and domain changes.

The strict-noninvariance control in the return correctly uses a strictly
monotone profile. Ordinary monotonicity would permit a constant profile and
would not prove inequality after rescaling.

## Semantic audit

This is a convention-lock theorem. It does not prove convergence, identify a
physical momentum normalization, or allow a Fourier factor to be discarded.
It proves that if momentum is rescaled, the compact window and every
momentum-dependent bound must be rescaled with it.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/MomentumRescalingConsistency.lean`
- `lake build PhysicsSM.Draft.NullEdge.MomentumRescalingConsistency`
- placeholder scan of the integrated production source
- `git diff --check` on the source and root import

All passed on July 20, 2026. The headline declarations carry build-enforced
standard-three assumption-footprint guards.
