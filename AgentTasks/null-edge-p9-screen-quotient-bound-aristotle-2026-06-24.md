# Aristotle task: P9 screen quotient response bound

Submitted: 2026-06-24.

## Scientific role

This task targets the next finite source-visibility theorem for `P9-F`. Recent
jobs established:

- exact local bookkeeping is invisible to closed screen tests;
- nonzero closed-test response is therefore non-exact;
- screen-supported residual noise is bounded by screen cell count;
- scalar additive diamond curvature matches the multiplicative holonomy defect.

The next useful theorem should package this into a finite observer-channel
statement: closed-test source responses descend to the quotient by exact
bookkeeping, are stable under exact perturbations, and have an explicit finite
screen-cardinality response bound.

## Guardrails

- Do not claim that screen projection equals harmonic/Hodge projection.
- Treat any harmonic projection as a later metric-dependent layer.
- Keep this job finite and standalone: Mathlib plus the definitions in the
  target file.
- Do not weaken the theorem statements unless a statement is false; if a theorem
  is false, explain the counterexample and propose the corrected statement.

## Aristotle instructions

Please work on:

```text
NullEdgeP9ScreenQuotientBound/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP9ScreenQuotientBound/Core.lean
```

Primary targets:

```lean
exactSource_pairing_closedTest_zero
closedResponse_eq_of_sameModuloExact
closedResponse_stable_under_exact_perturbation
abs_pairing_le_screen_card_mul
```

Please also end with a concise next-steps note:

- which targets were solved;
- whether any statement had to change;
- any remaining proof holes or hidden assumptions;
- the next one or two finite theorems you recommend for `P9-F`.

## Metadata

```yaml
aristotle:
  project_id: 8763fcb1-96ff-4f2d-8c1a-599a3b052c11
  task_id: b4ef1004-1f41-4b0e-b457-0a62b925300f
  target_file: NullEdgeP9ScreenQuotientBound/Core.lean
  expected_module: NullEdgeP9ScreenQuotientBound.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-screen-quotient-bound-20260624-project
  output_dir: AgentTasks/aristotle-output/8763fcb1-96ff-4f2d-8c1a-599a3b052c11
  status: integrated
```

## Integration note

Integrated as:

```text
PhysicsSM.Draft.NullEdgeP9ScreenQuotientBound
```

The standalone source under `AgentTasks/aristotle-standalone/` was also updated
with the completed proofs. Aristotle removed the unnecessary `htau : 0 <= tau`
hypothesis from `abs_pairing_le_screen_card_mul`; this strengthens the theorem
and does not weaken the physics claim. The module does not identify screen
projection with harmonic/Hodge projection.
