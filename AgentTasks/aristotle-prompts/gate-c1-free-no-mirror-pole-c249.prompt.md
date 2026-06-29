Gate C1 free no-mirror-pole theorem for tetrahedral overlap, C249

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

After the free global gap theorem, the overlap operator is:

```text
D_ov,tet(k) =
  (rho/a) [
    1 + K(k) / sqrt(K(k)^dagger K(k))
  ],
```

where:

```text
K(k) = i Q(k) + M(k),
Q(k) = sum_A B_A sin(k_A),
M(k) = r sum_A (1 - cos(k_A)) - rho.
```

In the Euclidean Clifford convention:

```text
Q(k)^2 = q(k)^2 * 1
K(k)^dagger K(k) = (q(k)^2 + M(k)^2) * 1.
```

Pro feedback says the key free no-mirror-pole theorem should be:

```text
D_ov,tet(k) = 0
iff
Q(k) = 0 and M(k) < 0.
```

Under `0 < rho < 2r`, this occurs only at the origin branch `k_A = 0`.

At every lifted doubler corner:

```text
D_ov,tet(k) = 2rho/a.
```

Task:

Design and, if feasible, prove the algebraic/free theorem that mirror branches
are removed by an inverse-propagator gap, not by propagator zeros.

Acceptable levels:

Level 1:
  scalar complex-number model of `K = M + i q`, proving the zero condition for
  `1 + K / |K|`.

Level 2:
  Clifford scalar-square model where `K^dagger K = F * 1`.

Level 3:
  direct tetrahedral branch-corner theorem using C240/C243 assumptions.

Constraints:

- Do not claim interacting gauge closure.
- Do not use propagator zeros as mirror removal.
- State explicitly that H_tet is gapped; the physical zero belongs to D_ov,tet.
- Keep finite/free theorem separate from determinant-line/anomaly work.

Requested output:

- Lean theorem statements and proofs if feasible;
- proof plan if the full operator model is too heavy;
- exact gap/no-mirror-pole interpretation;
- recommended integration target file.
