# Aristotle task: fixed-momentum determinant-phase realizability

## Scientific question

Exactly which complex Pluecker determinant values can arise from a factor of a
fixed positive `2 x 2` momentum matrix, and what is the residual factorization
fiber after both momentum and determinant phase are fixed?

This is Priority 3's first image-and-fiber theorem. The existing project result
proves that the fiber of `M M^H` is `U(2)` and that fixing `det M` reduces it to
`SU(2)`. The missing result is the image classification:

```text
exists M, M M^H = M0 M0^H and det M = z
iff
normSq z = normSq (det M0).
```

If proved, it gives an honest restriction from common null data: momentum fixes
the magnitude of the complex area but leaves its phase free, and the joint
`(momentum, phase)` datum retains an `SU(2)` spin fiber.

## Target

Close every proof hole in:

`FactorizationRealizability/PhaseFiber.lean`

Preserve all statements. Small helper lemmas are welcome. In particular:

- prove the determinant-of-Gram identity without floating-point computation;
- construct the phase-realizing right unitary explicitly;
- prove the iff in both directions;
- retain the nondegenerate quarter-turn witness;
- return a counterexample and minimal corrected statement if any target is
  false as written rather than weakening it silently.

## Scope boundary

This is finite complex matrix algebra. It does not derive a spacetime gauge
connection, non-Abelian curvature, Wigner rotation, or spin-statistics. Those
are successor gates after the exact image and fiber are known.

## Context

- `PhysicsSM/Draft/NullEdge/NullFactorizationSpinFiber.lean`
- `Sources/Null_Edge_Reconstruction_Priorities_2026-07-19.md`, Priority 3
- `AgentTasks/context-packs/factorization-phase-realizability-20260719-094601.md`

## Verification

Run only:

```text
lake env lean FactorizationRealizability/PhaseFiber.lean
```

No new assumptions, compiler-trusted decision procedures, placeholder
definitions, or hidden analyticity assumptions. Finish with the solved targets,
any statement correction, remaining holes, and an axiom report.

## Aristotle metadata

```yaml
aristotle:
  project_id: bdfa33fa-1eb5-4697-9858-7e1c1776a09f
  task_id: a27c568e-f192-40e3-ada0-e6beb1e3ec8f
  target_file: FactorizationRealizability/PhaseFiber.lean
  expected_module: FactorizationRealizability.PhaseFiber
  submission_project: AgentTasks/aristotle-submit/factorization-phase-realizability-20260719-project
  output_dir: AgentTasks/aristotle-output/bdfa33fa-1eb5-4697-9858-7e1c1776a09f
  status: integrated
  integration_module: PhysicsSM/Draft/NullEdge/NullFactorizationSpinFiber.lean
```

Submitted on 2026-07-19. Harvested into the existing factorization-fiber
module, axiom-guarded, and root-built on 2026-07-19.
