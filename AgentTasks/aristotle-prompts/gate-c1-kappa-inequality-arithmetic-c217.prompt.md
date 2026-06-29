Project name: gate-c1-kappa-inequality-arithmetic-c217

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Goal:

Design the exact or interval arithmetic proof for:

```text
kappaBranch + kappaKin + kappaWil < gamma_free.
```

Context:

C210 proves this is the relevant inequality when CKM and R transport exactly.
C193 defines:

```text
gamma_free = min(m0, 2 r_W - m0, 16 r_b - m0).
```

Task:

1. Propose a parameter choice or parameter window that maximizes gamma_free.
2. Decide whether the proof should use exact rationals, algebraic numbers, or
   interval arithmetic.
3. State Lean theorem forms for symbolic and numeric versions.
4. Define acceptance criteria for non-vacuity.
5. Identify which kappa pieces can be proven zero and which need numeric bounds.

Success criteria:

```text
No floating-point evidence as proof.
The inequality must be falsifiable and checkable.
Avoid overfitting a trivial parameter choice unless documented.
```

Please finish with:

```text
Parameter recommendation:
Arithmetic domain:
Symbolic theorem:
Numeric theorem:
Non-vacuity checks:
Kappa-piece status:
```
