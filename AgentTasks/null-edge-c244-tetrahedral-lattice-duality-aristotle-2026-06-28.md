# Aristotle task C244: tetrahedral lattice-duality / Brillouin torus

Date: 2026-06-28

Purpose:

```text
Upgrade the C240 independent-angle assumption into a precise rank-4 oblique
lattice / character-torus theorem, or isolate the exact quotient-lattice
contract needed.
```

Prompt:

```text
AgentTasks/aristotle-prompts/gate-c1-tetrahedral-c240-integration-cleanup-c244.prompt.md
```

Status:

```text
integrated.
```

Aristotle metadata:

```yaml
aristotle:
  project_id: cc52bd95-c796-47a0-a485-bd9436316345
  task_id: 53dab64c-2125-4940-80eb-0e3c4f0f767b
  target_file: PhysicsSM/Draft/NullEdge/GateC1/TetrahedralLatticeDuality.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateC1.TetrahedralLatticeDuality
  submission_project: AgentTasks/aristotle-submit/gate-c1-post-c240-pro-wave-20260628-project
  output_dir: AgentTasks/aristotle-output/cc52bd95-c796-47a0-a485-bd9436316345
  status: integrated
```

Submission note:

```text
Submitted as part of the post-C240 Pro-feedback wave.
Initial task status: IN_PROGRESS.
```

Integration note:

```text
Integrated Aristotle's completed file:
  PhysicsSM/Draft/NullEdge/GateC1/TetrahedralLatticeDuality.lean

Aristotle reports:
  homogeneousTetraMap_eq_zero_imp proved;
  homogeneousTetraMap_injective proved;
  NtetMat_det = -16 proved;
  NtetMatZ_det_natAbs = 16 proved;
  toTorusHom_surjective proved;
  mem_nullEdgeDualLattice proved;
  tetraTorusEquiv proves the dual torus is (R / 2*pi Z)^4.

This discharges the C240 load-bearing caveat that the four k_A are independent
2*pi-periodic angle coordinates on the rank-4 tetrahedral translation lattice,
subject to the explicit modeling choice that L_H/span_Z{n_A} is the active
translation lattice.
```

Status boundary:

```text
The live repo copy is Draft-only and was not locally checked during integration.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```
