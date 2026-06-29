Gate C1 C256: D4 inclusion, index, and quotient side-lane theorem

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

The active Gate C1 release lattice remains the rank-4 tetrahedral null-edge
lattice:

```text
L_H = span_Z {h_A}
```

where the Hadamard/tetrahedral generators are the columns of:

```text
H =
  [ 1  1  1  1
    1  1 -1 -1
    1 -1  1 -1
    1 -1 -1  1 ].
```

The D4 root lattice is:

```text
D4 = {x in Z^4 : sum_i x_i is even}.
```

C250/Pro say:

```text
L_H subset D4,
[D4 : L_H] = 8,
Z^4/L_H ~= Z/4 x Z/2 x Z/2,
D4/L_H ~= (Z/2)^3.
```

Task:

Formalize as much of this as possible in a standalone Lean file or a clean Draft
file. Prefer small finite/integer lemmas over a large quotient-lattice API if
the latter is too expensive.

Priority targets:

```text
1. Define H over Int.
2. Prove H^2 = 4 I.
3. Prove |det H| = 16.
4. Define L_H as the integer span/image of H.
5. Define D4 as even coordinate-sum vectors.
6. Prove L_H subset D4.
7. If feasible, prove D4/L_H has exponent 2 and order 8.
8. If feasible, identify D4/L_H with (Z/2)^3.
```

If quotient-group formalization is too heavy, return the strongest finite
replacement:

```text
Every x in D4 satisfies 2x in L_H.
L_H has index 16 in Z^4.
D4 has index 2 in Z^4.
Therefore informally [D4 : L_H] = 8.
```

Constraints:

```text
This is a D4 side lane, not the active Gate C1 release theorem.
Do not replace L_H by D4.
Do not claim GateC1_NU.
Do not run a full lake build.
```

Requested output:

```text
1. Lean file(s), if produced.
2. Exact theorem names and assumptions.
3. What was fully proved versus left as a handoff.
4. Recommended integration target.
```
