Project name: gate-c1-reference-is-gapped-c205

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Goal:

Prove or sharply specify `ReferenceIsGapped` for the CKM-decorated
Wilson/Neuberger reference, using C193's mass window.

Reference shifted masses:

```text
mu(n, ell) = 2 r_W n + w(ell) - m0
w(0) = 0
w(ell > 0) = 16 r_b
gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0)
```

Window:

```text
r_W > 0
0 < m0 < min(2 r_W, 16 r_b)
```

Task:

1. State the cleanest `ReferenceIsGapped` theorem for the free
   Wilson+CKM reference.
2. Separate the scalar sector-mass gap from the spinor/Clifford kinetic norm
   computation.
3. Identify the exact missing Clifford/gamma matrix lemma needed to convert the
   sector mass sign table into a uniform operator gap.
4. If possible, provide a Lean-style theorem skeleton:

```text
C193 scalar mass margin
+ Clifford anticommutation/norm identity
-> ReferenceIsGapped gamma_free H_ref.
```

5. State failure modes if the Wilson+CKM reference is not diagonalized in the
   assumed sector basis.

Success criteria:

```text
Use C193 as input.
Do not hide the Clifford norm calculation.
Keep CKM as internal texture, not kinetic doubler resolver.
```

Please finish with:

```text
Theorem statement:
Required inputs:
Missing lemmas:
Proof plan:
Failure modes:
```
