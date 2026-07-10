# Aristotle job: finite self-consistent decoder (backreaction fixed point)

Date: 2026-07-09.  Origin: Pro "positive Hodge theory of finite null
information" synthesis (sec 6, the boxed self-consistent pair
`D = D[omega]`, `omega = omega_D`: the state determines the geometry, the
geometry determines the state, a universe is a fixed point of the mutual
decoding relation).  Currently graded `[spec]` in
`Sources/Null_Edge_Future_Directions.md` ("self-decoding cosmology"); this
job converts its smallest honest core into an M-target.

## Statement package

Standalone Mathlib-only package.  Model: two-level decoder with excited
energy `E0 + g*theta`, Gibbs occupation `gibbsWeight`, and feedback
`theta' = c * gibbsWeight (E0 + g*theta)`.  Targets: Gibbs weight strictly in
`(0,1)`; continuity; invariant window `[0,c]`; EXISTENCE of a fixed point
(1-D Brouwer via IVT); the logistic `1/4`-Lipschitz bound; weak-coupling
UNIQUENESS (`|c*g| < 4` contraction); and an explicit unique witness at
`c = 1, E0 = 0, g = 1` strictly inside `(0,1)`.

Honest scope (stated in-file): one scalar feedback loop with a Gibbs state;
not the full decoder-geometry map, no continuum.  Statements handed off with
documented `s o r r y` markers; all typecheck.

## Metadata

```yaml
aristotle:
  project_id: 0311ff6c-25ea-4909-8c08-5865dad19d02
  target_file: AgentTasks/aristotle-standalone/backreaction-fixed-point-20260709/DecoderFixedPoint/SelfConsistentDecoder.lean
  expected_module: DecoderFixedPoint.SelfConsistentDecoder
  submission_project: AgentTasks/aristotle-submit/backreaction-fixed-point-20260709-project
  output_dir: AgentTasks/aristotle-output/0311ff6c-25ea-4909-8c08-5865dad19d02
  status: integrated
```

## Integration notes

On completion: dry-run integrate helper, review, port to
`PhysicsSM/Draft/NullEdge/` with guard blocks; upgrade the "self-decoding
cosmology" rung in `Sources/Null_Edge_Future_Directions.md` from `[spec]` to
a first landed `[M]` seed (existence + weak-coupling uniqueness only — do not
let the docstring outrun the kernel).

## Integration result

All seven targets returned placeholder-free and passed the pinned local Lean
check. They landed as
`PhysicsSM/Draft/NullEdge/SelfConsistentDecoder.lean` with the project
namespace, scope boundary, and axiom guards. The theorem is a scalar two-level
Gibbs feedback result, not a decoder-valued geometry or cosmology.
