Gate C1 tetrahedral free symbol and branch-mass window, C240

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

We have a proposed first concrete 3+1-dimensional Null-Edge Overlap kernel.
Use four future-directed null vectors:

```text
n_A = (1, v_A),  A = 1,...,4,
```

where `v_A` are regular tetrahedron vertices satisfying:

```text
sum_A v_A = 0,
sum_A v_A^i v_A^j = (4/3) delta^{ij},
v_A . v_B = 1 if A=B, and -1/3 if A != B.
```

Use:

```text
B_A = (1/4) gamma4 + (3/4) v_A^i gamma_i.
```

Claimed coframe identities:

```text
sum_A B_A = gamma4,
sum_A B_A v_A^i = gamma_i.
```

The free symbol is:

```text
D_ne^0(p) = (i/a) sum_A B_A sin(k_A),
W_ne(p) = (r/a) sum_A (1 - cos(k_A)),
H_ne(p) = gamma5 [D_ne^0(p) + W_ne(p) - rho/a].
```

At branch points `k_A in {0, pi}`, if `n` of the four `k_A` equal `pi`, then:

```text
m_n = (2 r n - rho) / a.
```

The proposed branch-mass window is:

```text
0 < rho < 2 r.
```

Then:

```text
m_0 < 0,
m_n > 0 for n = 1,...,4.
```

Task:

Audit and formalize the free-symbol/branch-window claim. We need to know
whether the tetrahedral model really gives the expected 16 naive branches and
the usual Wilson-overlap sign pattern.

Please answer:

1. Are the stated `B_A` coframe identities correct from the tetrahedral moment
   identities?
2. Are the `B_A` linearly independent as a Clifford coframe in the needed
   sense?
3. Is the inference

```text
sum_A B_A sin(k_A) = 0  ->  sin(k_A) = 0 for all A
```

   valid under the intended assumptions?
4. Does this produce exactly `2^4 = 16` free naive branches on the oblique
   null-edge Brillouin torus?
5. Is the branch mass formula `m_n = (2rn - rho)/a` correct for the scalar
   Wilson term?
6. Does `0 < rho < 2r` give the desired overlap sign pattern?
7. What hidden convention risks exist: Euclidean gamma convention, null-edge
   lattice periodicity, independence of the `k_A`, or time/Wick rotation?

If possible, produce Lean-friendly finite statements for:

```text
tetrahedral_B_sum;
tetrahedral_B_weighted_sum;
branch_mass_negative_origin;
branch_mass_positive_doublers;
```

and describe how to represent the branch count without importing the full
physics repo.

Constraints:

- Do not claim the interacting/gauge theorem.
- Do not claim anomaly or determinant-line closure.
- Do not claim GateC1_NU.
- Report if the 16-branch claim needs additional lattice-duality assumptions.

Requested output:

- audit verdict;
- exact theorem statements;
- proof sketch or Lean code if feasible;
- convention risks;
- next local formalization target.
