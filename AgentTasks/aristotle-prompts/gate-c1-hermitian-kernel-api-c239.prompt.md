Gate C1 Hermitian kernel API and proof skeleton, C239

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

We now want to formalize the first serious Hermitian kernel for the
Null-Edge Overlap route:

```text
H_ne = gamma5 (D_ne^0 + W_ne + M_br - rho/a),

D_ne^0 = sum_A B_A (T_A - T_A^dagger) / (2a),

W_ne = (r / 2a) sum_A omega_A (2 - T_A - T_A^dagger).
```

Assumptions:

```text
(T_A - T_A^dagger)/(2a) is anti-Hermitian;
B_A is Hermitian;
{B_A, gamma5} = 0;
W_ne is Hermitian;
[W_ne, gamma5] = 0;
M_br is Hermitian;
[M_br, gamma5] = 0;
gamma5 is Hermitian and gamma5^2 = 1.
```

Then:

```text
(D_ne^0)^dagger = -D_ne^0,
(D_ne^0)^dagger = gamma5 D_ne^0 gamma5,
A_ne = D_ne^0 + W_ne + M_br - rho/a
satisfies A_ne^dagger = gamma5 A_ne gamma5,
H_ne = gamma5 A_ne is Hermitian.
```

Task:

Design the smallest useful Lean/API formalization for this result. If possible,
produce a standalone Lean file using Mathlib linear maps/matrices or a clean
abstract `Star`-algebra API that proves the core statement. If exact Lean code
is too costly, give precise theorem statements and the missing Mathlib APIs.

Important:

This is a kernel-validity theorem, not the full Gate C1 release. It should only
prove Hermiticity/gamma5-Hermiticity under explicit assumptions.

Requested targets:

1. An abstract theorem:

```text
If gamma is self-adjoint and involutive, D is gamma-odd and anti-self-adjoint,
E is gamma-even and self-adjoint, and m is real scalar identity, then
H = gamma (D + E - m I) is self-adjoint.
```

2. A version with `E = W + M_br`.

3. A short mapping from this abstract theorem to the null-edge notation
   `D_ne^0`, `W_ne`, `M_br`, `rho/a`.

4. A list of Lean import/module dependencies that would make this easiest in
   the live repo.

5. A warning if the scalar field should be `Complex`, if finite-dimensional
   matrices are easier than abstract Hilbert-space operators, or if Mathlib's
   star-algebra API should be avoided for now.

Constraints:

- Do not add new assumptions silently.
- Do not use fake placeholders as success.
- Do not weaken the mathematical claim.
- Do not claim local repo verification.

Requested output:

- Lean/API design;
- theorem statements;
- proof sketch or Lean code if feasible;
- exact assumptions list;
- integration advice for a Draft module named something like
  `NullEdgeOverlapKernel.lean`.
