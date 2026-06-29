---
project_id: 0bb1d7de-5236-430c-9b1a-0968ed7b2dc7
task_id: 3c9cb6c5-e90b-4e10-bb79-8cd5a2ec2de9
status: integrated
created: 2026-06-27
round: gate-c1-reference-match
output_dir: AgentTasks/aristotle-output/0bb1d7de-5236-430c-9b1a-0968ed7b2dc7
---

# Aristotle C158: C145 promotion package for repo Lean

Goal: Prepare the C145 kernel-only finite seed for safe integration into the repo's draft/trusted Lean hierarchy.

Context: C145 reports a kernel-only exact symbolic proof package for the branch x flavor x qutrit finite seed. We need a project-facing integration package that respects repo conventions and does not accidentally promote physics claims.

Requested deliverables:

1. Identify the smallest subset of C145 declarations to import into a repo draft module first.
2. Provide a module design: namespace, imports, docstring, theorem names, and provenance.
3. Separate trusted finite algebra facts from draft physical interpretation.
4. Identify any Mathlib/project dependency risks before integration.
5. If feasible, provide a clean self-contained Lean file suitable for `PhysicsSM/Draft/NullEdgeGateC1FiniteSeed...`.

Success criterion: a concrete integration plan or ready-to-promote Lean artifact for the finite seed.

## Submission status

Submitted on 2026-06-27. Project: 0bb1d7de-5236-430c-9b1a-0968ed7b2dc7. Task: 3c9cb6c5-e90b-4e10-bb79-8cd5a2ec2de9.

## Completion summary

Integrated on 2026-06-27.

Aristotle delivered a ready-to-promote draft Lean module:

```text
RequestProject/PhysicsSM/Draft/NullEdgeGateC1FiniteSeed.lean
```

The module was copied into the live draft tree as:

```text
PhysicsSM/Draft/NullEdgeGateC1FiniteSeed.lean
```

The accompanying integration note was copied into:

```text
AgentTasks/null-edge-c158-c145-promotion-package-integration-2026-06-27.md
```

Aristotle reported that the artifact builds cleanly with no proof
placeholders. The promoted file has not been locally checked in this integration
pass.

Key content:

- `Trusted.overlapOp`: overlap operator at `rho = 1`.
- `Trusted.ginsparg_wilson`: pure ring-algebra GW relation from two
  involutions.
- `ginsparg_wilson_scaled`: scalar-scaled GW form.
- `Trusted.kronecker_involution`: Kronecker product preserves involutions.
- `Seed`: exact rational branch x qutrit seed with `Gamma_K`, `T_br`, and
  `D_ov_ne`.
- `Seed.seed_ginsparg_wilson`: exact GW relation on the finite seed.
- `Draft.null_edge_seed_has_exact_chiral_symmetry`: physics-facing re-export
  of the finite algebra theorem.

Claim boundary:

The module proves finite overlap/GW algebra for a symbolic seed. It does not
prove the physical mass window, `T_br = sign(H_ne)` analytically, SM embedding,
branch-line lift, anomaly/index import, bad-sector physical gap, or
non-ultralocal control.
