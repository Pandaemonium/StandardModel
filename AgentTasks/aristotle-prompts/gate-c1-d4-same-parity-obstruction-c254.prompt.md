Gate C1 C254: D4 same-parity null obstruction side lane

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C250/Pro established that D4 is useful as an envelope/comparison lattice but
should not replace the active tetrahedral Gate C1 lattice `L_H`.

We want a side-lane formalization of the strongest simple obstruction:

```text
Null translations alone cannot connect full D4.
```

Mathematical setup:

Work with integer vectors `x : Fin 4 -> Int` or an equivalent Lean-friendly
representation.

Define:

```text
D4 = {x in Z^4 : sum_i x_i is even}.

L_same =
  {x in Z^4 : x_0, x_1, x_2, x_3 all have the same parity}.

q(x) = -x_0^2 + (1/3)(x_1^2 + x_2^2 + x_3^2).
```

Avoid rationals if convenient by using the equivalent integer null equation:

```text
3*x_0^2 = x_1^2 + x_2^2 + x_3^2.
```

Target theorem:

```text
If x is an integral null vector, i.e.
  3*x_0^2 = x_1^2 + x_2^2 + x_3^2,
then all four coordinates of x have the same parity.
```

Proof sketch:

```text
Squares are 0 or 1 mod 4.
If x_0 is even, the RHS is 0 mod 4, forcing all three spatial coordinates even.
If x_0 is odd, the RHS is 3 mod 4, forcing all three spatial coordinates odd.
```

Optional follow-up targets:

```text
L_H subset L_same subset D4;
[L_same : L_H] = 2;
[D4 : L_same] = 4;
```

Only attempt these if the parity theorem is complete.

Constraints:

```text
This is a D4 side lane, not a Gate C1 release theorem.
Do not modify the active L_H scalar-Wilson proof.
Do not claim D4 is the release lattice.
Do not run a full lake build.
```

Requested output:

```text
1. A standalone Lean file if possible.
2. Exact theorem names and assumptions.
3. Whether the optional inclusion/index facts were attempted.
4. Recommended integration path.
```
