# Aristotle task C70: null-Wilson regulator facts

```yaml
aristotle:
  project_id: e3986d7f-4928-4296-a7c8-cb4fb87eefae
  task_id: 14f3be5e-cae4-47ee-a617-ccbc072a598c
  target_file: PhysicsSM/Draft/NullEdgeNullWilsonRegulator.lean
  expected_module: PhysicsSM.Draft.NullEdgeNullWilsonRegulator
  submission_project: AgentTasks/aristotle-submit/null-edge-wave17-null-wilson-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/e3986d7f-4928-4296-a7c8-cb4fb87eefae
  status: submitted
```

Context pack:

- `AgentTasks/context-packs/null-edge-gate-c-null-wilson-20260627-063900.md`

Goal: prove the concrete null-Wilson regulator facts for Gate C v3.

Target module:

```text
PhysicsSM/Draft/NullEdgeNullWilsonRegulator.lean
```

Requested theorem package:

```text
W(q) = sum_a (1 - cos q_a)

wilson_zero_iff_origin:
  on the real torus, W(q) = 0 iff all q_a = 0 mod 2*pi.

wilson_positive_away_origin:
  on the real torus, q != 0 mod 2*pi implies W(q) > 0.

wilson_lifts_known_highBranches:
  W(q^(a)) = 6 for the four high three-pi branches, up to the existing indexing
  convention.

wilson_lifts_cubeRootWitness:
  W(2*pi/3, 0, 0, 4*pi/3) = 3.

wilson_lifts_cyclotomic_orbit:
  where existing C66 definitions expose the orbit, show the regulator is
  positive on every non-origin cyclotomic witness.
```

Scope guardrail:

Do not claim full Gate C release. This module only proves that the Wilson shape
is positive away from the physical origin on the real torus and hence can serve
as a branch regulator.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: e3986d7f-4928-4296-a7c8-cb4fb87eefae
task_id: 14f3be5e-cae4-47ee-a617-ccbc072a598c
submission_project: AgentTasks/aristotle-submit/null-edge-wave17-null-wilson-gate-c-20260627-project
target: PhysicsSM/Draft/NullEdgeNullWilsonRegulator.lean
```
