Project name: gate-c1-c193-project-draft-port-c200

You are Aristotle, working on the StandardModel Lean/null-edge research project.

C193 returned a standalone Lean theorem package proving the free
CKM-decorated Wilson/Neuberger mass-window theorem.

Returned declarations:

```text
w;
w_zero;
w_pos_of_pos;
mu;
gamma_free;
gamma_free_pos;
mu_phys_neg;
mu_doubler_pos;
mu_heavy_pos;
mu_neg_iff;
mu_phys_le_neg_margin;
mu_heavy_ge_margin;
light_sector_count;
gateC1_free_mass_window.
```

Task:

1. Produce a project-ready draft module plan for porting the standalone C193
   theorem package into `PhysicsSM/Draft/NullEdge/GateC1/CKMWilsonWindow.lean`
   or the closest appropriate project path.
2. Keep the theorem semantics unchanged.
3. Suggest namespace, imports, docstring provenance, and naming conventions.
4. Identify any theorem statements that should be split, renamed, or wrapped
   before promotion into trusted code.
5. If possible, return the full Lean source adjusted for the project namespace
   and style.

Do not weaken the mass-window theorem.
Do not claim full `GateC1_NU`.

Success criteria:

```text
The result should be ready for a later local targeted Lean check.
The port should preserve the C193 content and its claim boundary.
```

Please finish with:

```text
Recommended path:
Imports:
Namespace:
Declarations to copy:
Declarations to adapt:
Promotion checklist:
Full adjusted Lean source if feasible:
```
