# Aristotle task C240: tetrahedral free symbol and branch-mass window

Date: 2026-06-28

Purpose:

```text
Audit and formalize the tetrahedral coframe identities, free branch count, and
scalar Wilson branch-mass window 0 < rho < 2r for the proposed H_C1 kernel.
```

Prompt:

```text
AgentTasks/aristotle-prompts/gate-c1-tetrahedral-branch-window-c240.prompt.md
```

Submission project:

```text
AgentTasks/aristotle-submit/gate-c1-tetrahedral-branch-window-c240
```

Status:

```text
integrated.
```

Aristotle metadata:

```yaml
aristotle:
  project_id: aeccfd80-4bf2-4f09-94e0-eddc3b38cda5
  task_id: 13a76456-860c-4c7a-8d34-9b1b152a426d
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/gate-c1-tetrahedral-branch-window-c240
  output_dir: AgentTasks/aristotle-output/aeccfd80-4bf2-4f09-94e0-eddc3b38cda5
  status: integrated
```

Submission note:

```text
Prompt/project-dir submission only. This job is intended to catch convention
or branch-torus assumptions before we promote the tetrahedral kernel.
```

Integration note:

```text
Aristotle completed C240 under project
aeccfd80-4bf2-4f09-94e0-eddc3b38cda5 / task
13a76456-860c-4c7a-8d34-9b1b152a426d.

Returned artifacts:
  AgentTasks/aristotle-output/aeccfd80-4bf2-4f09-94e0-eddc3b38cda5/extracted/project-files.tar/gate-c1-tetrahedral-branch-window-c240_aristotle/

Integrated Draft Lean file:
  PhysicsSM/Draft/NullEdge/GateC1/TetrahedralBranchWindow.lean
```

Key results:

```text
1. The tetrahedral B_A coframe identities are finite linear consequences of
   the tetrahedral moment identities.

2. The concrete normalized tetrahedron vertices realize the required first and
   second moments.

3. The homogeneous vectors (1, v_A) are linearly independent, giving the
   combinatorial branch inference:
     sum_A B_A sin(k_A) = 0 => sin(k_A) = 0 for every A
   in the finite Dirac-vector coefficient model.

4. The branch table has 16 points only under the explicit lattice-duality
   assumption that the four k_A are independent 2*pi-periodic angle
   coordinates on the null-edge Brillouin torus.

5. At those branch points, scalar Wilson gives branch mass
     m_n = (2 r n - rho) / a.

6. For a > 0 and 0 < rho < 2r:
     m_0 < 0,
     m_n > 0 for n = 1, ..., 4.
```

Program impact:

```text
The scalar Wilson term is no longer ruled out for the free branch table.
The earlier scalar-Wilson no-go still rules out scalar Wilson as a direct
chirality selector on the balanced origin kernel. In the overlap architecture,
scalar Wilson is instead a branch-mass input to the Hermitian sign kernel, so
the old no-go does not apply in the same way.

The next proof pressure is:
  1. make the lattice-duality / Brillouin-torus assumption into a theorem;
  2. prove a global free no-zero/gap theorem away from exact branch points;
  3. assemble sign(H_ne), Ginsparg-Wilson algebra, and the no-ghost bad-sector
     inverse-gap clauses.
```

Status boundary:

```text
Aristotle reported the focused C240 package built without proof placeholders
and with only standard axioms.
The live repo copy is Draft-only and has not been locally checked.
No trusted code was promoted.
No GateC1_NU theorem is claimed.
```
