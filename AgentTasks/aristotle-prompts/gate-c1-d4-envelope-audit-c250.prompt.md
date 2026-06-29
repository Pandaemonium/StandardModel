Gate C1 D4 envelope audit, C250

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

The current mainline free Gate C1 model uses the rank-4 tetrahedral null-edge
translation lattice:

```text
Lambda_tet = span_Z { e_A : A = 1..4 }
e_A = a n_A
n_A = (1, v_A)
```

where:

```text
v_1 = ( 1,  1,  1) / sqrt(3)
v_2 = ( 1, -1, -1) / sqrt(3)
v_3 = (-1,  1, -1) / sqrt(3)
v_4 = (-1, -1,  1) / sqrt(3)
```

After rescaling the spatial coordinates by `sqrt(3)`, the homogeneous
tetrahedral generators look like the Hadamard rows:

```text
h_1 = (1,  1,  1,  1)
h_2 = (1,  1, -1, -1)
h_3 = (1, -1,  1, -1)
h_4 = (1, -1, -1,  1)
```

These generate a rank-4 integer lattice `Lambda_H`.  The nearby D4 root lattice
is:

```text
D4 = { x in Z^4 : sum_i x_i is even }.
```

Codex's informal claim is:

```text
Lambda_H is a sublattice of D4, likely of index 8.
```

This D4 lane is exploratory and must not be silently substituted for the
mainline tetrahedral lattice.  If full D4 is used as the translation lattice,
the Brillouin torus, branch theorem, Wilson term, and branch count must be
redone.

Task:

Audit the D4 relationship as a parallel/envelope lattice problem.

Please address:

1. Prove or refute:

```text
Lambda_H <= D4.
```

2. Compute the index:

```text
[D4 : Lambda_H]
```

and give a Lean-friendly proof if feasible.

3. Compare dual lattices:

```text
Lambda_H^*
D4^*
```

and explain the induced Brillouin-torus/folding relation.

4. Identify what translation steps full D4 adds beyond `Lambda_H`.

5. Interpret those added steps relative to the physical null-edge coordinates:

```text
Are they additional null steps?
Are they spacelike/timelike/mixed after undoing the spatial sqrt(3) rescaling?
Are they natural composites of the tetrahedral null steps?
```

6. Analyze symmetry:

```text
tetrahedral point symmetry;
D4 Weyl group;
triality / Spin(8) relevance;
possible connection to octonions/Furey/Baez internal algebra.
```

7. State what would have to be redone if we switched the actual free lattice
from `Lambda_tet` to full `D4`:

```text
branch-zero theorem;
scalar Wilson branch window;
global gap theorem;
overlap no-mirror-pole theorem.
```

8. Recommend whether D4 should be:

```text
a later envelope/symmetry completion;
a replacement lattice;
a finite-volume refinement;
or only a useful comparison object.
```

Constraints:

- Do not claim GateC1_NU.
- Do not change the current mainline lattice.
- Do not assume the C240 16-branch theorem survives on full D4.
- Separate finite lattice arithmetic from physics interpretation.
- If formal Lean is feasible, produce a small standalone theorem set; otherwise
  return a precise proof plan and theorem statements.

Requested output:

- Inclusion and index result;
- dual-lattice / Brillouin folding comparison;
- added-step classification;
- implications for Gate C1;
- recommended next Lean file or docs note.
