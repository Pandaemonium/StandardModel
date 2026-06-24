# Aristotle focused job: one-diamond curvature gate for super-Dirac

```yaml
aristotle:
  project_id: e2d46570-f294-4cbc-b4aa-9a172ec283b1
  task_id: 7a6fe11f-ec2f-473e-8227-d4df4ae39435
  target_file: NullEdgeSuperDiracDiamondCurvature/Core.lean
  expected_module: NullEdgeSuperDiracDiamondCurvature.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-super-dirac-diamond-curvature-20260624-project
  source_staged_from: AgentTasks/aristotle-standalone/null-edge-super-dirac-diamond-curvature-20260624
  status: submitted
```

## Physics context

This is the smallest super-Dirac gate that touches real physics. The
super-Dirac square should produce the same finite curvature object that the
causal-diamond holonomy layer measures. On a scalar one-diamond model, the
covariant differential square sees an additive path-comparison defect, while
the gauge layer sees a multiplicative holonomy defect. These are exactly related
by multiplying the shifted holonomy defect by the reference path transport.

This target deliberately avoids logarithms or continuum approximations. It is a
finite identity that should later be connected to
`PhysicsSM.Gauge.CausalDiamondHolonomy` and
`PhysicsSM.Draft.NullEdgeCovariantDifferentialCore`.

## Target

Fill the proof holes in:

```text
NullEdgeSuperDiracDiamondCurvature/Core.lean
```

The central targets are:

```lean
additiveDiamondDefect_eq_triangleCurvature_sub
additiveDiamondDefect_eq_multiplicative_minus_one_mul
multiplicative_trivial_iff_additive_zero
```

## Constraints

- Do not weaken theorem statements.
- Do not add fake constants or hidden assumptions.
- Small helper lemmas are welcome if useful.
- Keep imports minimal.
- Run:

```bash
lake env lean NullEdgeSuperDiracDiamondCurvature/Core.lean
```

## Completion report requested

Please end with:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- assumptions or nonstandard constructs used;
- suggested next theorem targets connecting this scalar identity to the
  non-Abelian causal-diamond and super-Dirac square layers.
