# Aristotle C103: scalar-on-origin balanced-kernel no-go

aristotle:
  project_id: b2361c23-fde0-4d07-9a03-4c9e37f5cc6d
  task_id: 72769d93-323c-4ec7-a2b7-68db506a5f68
  target_file: PhysicsSM/Draft/NullEdgeScalarOriginBalancedKernelNoGo.lean
  expected_module: PhysicsSM.Draft.NullEdgeScalarOriginBalancedKernelNoGo
  submission_project: AgentTasks/aristotle-submit/null-edge-wave26-gate-c-branch-release-20260627-project
  output_dir: AgentTasks/aristotle-output/b2361c23-fde0-4d07-9a03-4c9e37f5cc6d
  status: submitted
  initial_project_status: RUNNING
  initial_task_status: QUEUED

Dependency class: Independent finite no-go theorem.

Context pack:

```text
AgentTasks/context-packs/null-edge-wave26-gate-c-branch-release-20260627-121710.md
AgentTasks/null-edge-gate-c-neo4j-lit-lateral-analysis-2026-06-27.md
```

## Background

The scalar Wilson no-go should be generalized. Any deformation that is scalar
on the balanced origin kernel and vanishes at the origin cannot turn that
kernel into one Weyl line. If it is nonzero at the origin, it removes or masses
the intended physical origin mode rather than releasing a Weyl branch.

## Requested target

Create:

```text
PhysicsSM/Draft/NullEdgeScalarOriginBalancedKernelNoGo.lean
```

## Desired finite model

A minimal finite model is fine:

```lean
structure BalancedOriginKernel where
  K : Type
  gamma : K -> Int
  left right : K
  left_in_kernel : ...
  right_in_kernel : ...
  gamma left = 1
  gamma right = -1
```

or a `Fin 2` vector-space model with basis lines `L` and `R`.

Main theorem ideas:

```text
origin_vanishing_scalar_preserves_kernel:
  D0 = 0 on K -> s = 0 -> ker(D0 + s I) on K = K

balanced_kernel_not_one_weyl_line_after_scalar_zero:
  scalar vanishing deformation cannot select only L or only R

nonzero_scalar_removes_origin_kernel:
  s != 0 -> ker(s I) = 0
```

The theorem should make the minimal escape hatch explicit:

```text
C1 needs a non-scalar spinor-line / branch-line mechanism or a physical
projection/domain-wall construction.
```

## Acceptance criteria

- Lean file compiles.
- No new proof placeholders or escape-hatch declarations.
- The no-go is finite and honest; it does not claim to classify all analytic
  deformations unless the hypotheses are stated.
