Gate C1 C251: sin-zero to branch-angle reduction for C243

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

The active free Gate C1 model is the rank-4 tetrahedral null-edge overlap
kernel on the lattice `L_H = span_Z {h_A}`. C240 proved the branch table under
the independent-angle assumption. C244 has now integrated a Draft Lean theorem
showing that the four `k_A` are independent `2*pi`-periodic coordinates on the
active tetrahedral Brillouin torus.

The global free gap theorem C243 remains open. The previous C243 return showed
that the most useful split target is:

```text
sin_zero_to_branchAngles
```

in:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetrahedralGlobalGap.lean
```

Task:

Prove the smallest clean Lean lemma(s) needed to replace the handoff point
`sin_zero_to_branchAngles`.

Intended math:

```text
If each sin(k_A) = 0 and each k_A is treated as a fundamental 2*pi-period
angle, then each k_A is a branch angle, i.e. each coordinate is 0 or pi modulo
2*pi.
```

Please inspect the existing definitions in `TetrahedralGlobalGap.lean` and use
its local vocabulary. Do not weaken the statement silently. If the existing
statement is malformed, explain the exact semantic issue and return the
smallest corrected statement that the rest of C243 should use.

Constraints:

```text
Do not run a full lake build.
Prefer a narrow `lake env lean PhysicsSM/Draft/NullEdge/GateC1/TetrahedralGlobalGap.lean`
only if needed and affordable.
Do not touch C247/C249.
Do not claim GateC1_NU closure.
```

Requested output:

```text
1. Updated Lean code for the relevant lemma(s), or a focused replacement file.
2. Exact assumptions used for fundamental-period angles.
3. Whether the existing C243 scaffold should be changed.
4. Any remaining proof holes.
```
