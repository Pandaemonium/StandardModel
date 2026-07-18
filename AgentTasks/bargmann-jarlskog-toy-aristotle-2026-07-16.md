# Aristotle job: two-family Jarlskog toy (spiral wave 6, C2 gate second half)

Date: 2026-07-16
Context: spiral-layer wave 6; completes the C2 gate ("CP-odd = handedness")
at the toy level. Wave 2C landed all-orders planar CP-inertness
(PlanarCornerRealityAristotle); C2's gate also demanded "a two-family toy
with a relative phase (CKM-shaped)". This package is that toy: the CP-odd
interference observable of two three-corner families, its exact Jarlskog
decomposition into oriented volumes against CP-even dot sums, the CP and
swap sign laws, common-frame (SO(3)) invariance, both-planar protection,
and a one-planar nonvanishing witness.

```yaml
aristotle:
  project_id: 958c6429-bbbc-4bc6-b289-954222616673
  task_id: TBD
  target_file: BargmannJarlskogToy/BargmannJarlskogToy.lean
  expected_module: BargmannJarlskogToy.BargmannJarlskogToy
  submission_project: AgentTasks/aristotle-submit/bargmann-jarlskog-toy-20260716-project
  source_root: AgentTasks/aristotle-standalone/bargmann-jarlskog-toy-20260716
  output_dir: AgentTasks/aristotle-output/<project_id>
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/BargmannJarlskogToyAristotle.lean
```

## Statements (7, placeholder-proof targets, do not weaken)

1. `jarlskog_decomposition` - jarlskogObs = [triple_A(1+dots_B)
   - triple_B(1+dots_A)]/16, fully polynomial, no unit hypotheses.
2. `jarlskog_antisymm` - family swap is odd.
3. `jarlskog_cp_odd` - reversing both corner orders (CP) is odd.
4. `jarlskog_rotation_invariant` - common proper rotation (R^T R = 1,
   det R = 1) preserves the observable.
5. `jarlskog_both_planar` - both triples zero => observable zero.
6. `jarlskog_equal_families` - self-interference vanishes.
7. `jarlskog_witness` - octant vs planar (ex, (3/5,4/5,0), ey): exactly
   3/20 (one planar family is NOT CP-protection).

## Preflight

- Statements typechecked 2026-07-16: `lake env lean` EXIT=0 (seven
  placeholder warnings only).
- Witness 3/20 and the decomposition law verified numerically (numpy,
  residuals < 1e-12; decomposition on three random-vector trials).
- An earlier draft docstring had two wrong witness values (11/80, 13/100)
  from slipped arithmetic (exy.ey mis-multiplied); caught in preflight by
  the numeric check before submission; the file now consistently states
  3/20 = Im((1+i)/4 * 3/5).

## Semantic review checklist (for integration)

- jarlskogObs uses star (conjugate) on the SECOND family: the CKM
  analogy is path A against path B-bar. The decomposition's sign
  convention follows from that choice; do not let the conjugation
  migrate.
- Statement 4's hypotheses are R^T R = 1 AND det R = 1 (proper
  rotations). Improper R flips the triples, so invariance would be
  false; a strengthening recording the det = -1 sign flip is optional,
  not requested.
- The witness family B is genuinely planar (all z-components zero) and
  the observable still nonzero - the physics point (relative phase) the
  program note will cite; keep the exact rational 3/20.
- Axiom audit per theorem; no compiled-evaluator tactic in anything
  intended for promotion.
