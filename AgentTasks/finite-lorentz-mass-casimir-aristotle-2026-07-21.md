# Finite Lorentz mass-Casimir Aristotle task

## Objective

Prove a finite, nonvacuous uniqueness anchor for the kinematic origin-of-mass
claim. A symmetric real quadratic form on four-momentum that is invariant under
two displayed spatial half-turns, two displayed quarter-turns, and one exact
3-4-5 Lorentz boost must be a scalar multiple of the Minkowski metric.

This is deliberately narrower than the full Wigner/Poincare representation
classification. It establishes uniqueness only among quadratic momentum
scalars passing the explicit finite symmetry audit. That is exactly the scope
needed to justify the determinant/Minkowski invariant as the unique normalized
quadratic mass datum in the kinematic capstone.

## Nondegeneracy and boundaries

- The target proves all five displayed matrices preserve `eta`.
- `Q = eta` is an explicit witness, so the hypotheses are inhabited.
- Do not weaken or replace the rational boost.
- Do not claim classification of spin, continuous-spin sectors, tachyonic
  representations, interacting pole masses, or mass-generation mechanisms.

## Aristotle metadata

```yaml
aristotle:
  project_id: b4554e39-c04c-471d-8c3d-617547c18325
  task_id: bae860dc-dd5c-45e2-9e64-2dc993e30b11
  target_file: AgentTasks/aristotle-full/finite-lorentz-mass-casimir-20260721/Main.lean
  expected_module: Main
  submission_project: AgentTasks/aristotle-submit/finite-lorentz-mass-casimir-20260721-project
  output_dir: AgentTasks/aristotle-output/b4554e39-c04c-471d-8c3d-617547c18325
  status: integrated
```

## Integration status

The 17:12 PDT in-progress snapshot was hole-free and passed `lake env lean`
locally. The final artifact was byte-identical and also passed the same direct
check. It was integrated as
`PhysicsSM/Draft/NullEdge/FiniteLorentzMassCasimir.lean` with build-enforced
standard-three axiom guards. Aristotle's project-level status was
`COMPLETE_WITH_ERRORS`, but its own summary reports the source check succeeded;
the delivered source and the integrated module both pass independently in the
repository. The wrapper status is retained here rather than hidden.
