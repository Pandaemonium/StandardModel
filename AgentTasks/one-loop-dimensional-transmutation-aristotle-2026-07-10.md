# Aristotle target: exact one-loop dimensional transmutation

Prove every theorem in `DimensionalTransmutation/Core.lean` without changing
definitions or statements. Run:

```text
lake env lean DimensionalTransmutation/Core.lean
```

The target starts from the supplied asymptotically-free one-loop running law,
proves positivity on its physical branch, proves the exact inverse-coupling RG
cocycle, and proves that

```text
mu * exp(-1 / (2*b*g(mu)^2)) = Lambda
```

is scale independent. Close the explicit `b=1/2`, `Lambda=1`, `mu=e` witness.

Boundary: this is the exact algebraic bridge from a dimensionless running
coupling to an invariant scale. It does not derive the beta function, identify
the closure coupling with QCD, or predict a MeV/GeV value.

Context pack:
`AgentTasks/context-packs/one-loop-dimensional-transmutation-20260710-20260709-221452.md`.

```yaml
aristotle:
  project_id: 3ea09edf-0206-4b6c-94b5-d3e618ba8ec2
  target_file: DimensionalTransmutation/Core.lean
  expected_module: PhysicsSM.Draft.NullEdge.OneLoopDimensionalTransmutation
  submission_project: AgentTasks/aristotle-submit/codex-one-loop-dimensional-transmutation-20260710-project
  output_dir: AgentTasks/aristotle-output/3ea09edf-0206-4b6c-94b5-d3e618ba8ec2
  status: submitted
```
