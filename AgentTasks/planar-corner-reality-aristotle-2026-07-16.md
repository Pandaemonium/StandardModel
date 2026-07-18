# Aristotle job: all-orders planar CP-inertness (spiral wave 2, job C)

Date: 2026-07-16
Context: spiral-layer wave 2; wave-1 companion SpinCornerBargmannAristotle
proved the n = 3 case (planar three-cycles are real).

```yaml
aristotle:
  project_id: 058a9901-a302-4726-8962-588fa33eb1cc
  task_id: TBD
  target_file: PlanarCornerReality/PlanarCornerReality.lean
  expected_module: PlanarCornerReality.PlanarCornerReality
  submission_project: AgentTasks/aristotle-submit/planar-corner-reality-20260716-project
  source_root: AgentTasks/aristotle-standalone/planar-corner-reality-20260716
  output_dir: AgentTasks/aristotle-output/058a9901-a302-4726-8962-588fa33eb1cc
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/PlanarCornerRealityAristotle.lean
```

## Goal

The all-orders zigzag-CP-inertness theorem: the real span of
{1, sX, sY, sX*sY} is a multiplicatively closed subalgebra containing every
planar corner matrix, its members have real trace, hence the ordered product
of ANY finite planar corner history has real trace
(`planar_history_trace_real`, by list induction). Nonplanar control: the
handed x -> y -> z triple has imaginary part 1/4 (nonzero escape witness).
Physics reading: CP-odd phases in the corner calculus REQUIRE leaving the
plane (spiraling), at every order - the zigzag cannot CP-violate.

## Statements (8, placeholder-proof targets, do not weaken)

`realForm_one`, `realForm_mul`, `realForm_projP`, `realForm_trace_im`,
`planar_history_trace_real`, `nonplanar_escape_witness`,
`nonplanar_escape_ne_zero` (plus the `RealForm`/`projP`/`proj3` definitions,
which must stay verbatim).

## Preflight

- Statements typechecked 2026-07-16 (`lake env lean`, only placeholder
  warnings).
- Closure table hand-verified: sX*sY = i sZ; sX*(sX*sY) = sY;
  (sX*sY)*sX = -sY; sY*(sX*sY) = -sX; (sX*sY)*sY = sX; (sX*sY)^2 = -1 - all
  real-coefficient, so span_R{1, sX, sY, sX*sY} is closed (a copy of
  M_2(R)).
- Witness: wave-1 three-cycle value (1+i)/4 gives im = 1/4.

## Semantic review checklist (for integration)

- `RealForm` must remain REAL-span (x y u v : R); complex coefficients
  would make the theorem vacuous.
- The history product must remain the ordered list product (no
  commutativity assumptions).
- The escape witness must stay in the SAME file to keep the dichotomy
  non-vacuous.
- Axiom audit per theorem; no compiled-evaluator tactic.
