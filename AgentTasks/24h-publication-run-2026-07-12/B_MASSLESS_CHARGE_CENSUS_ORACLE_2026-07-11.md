# Massless live Weyl-sector charge census: exact oracle

Status: exact SymPy algebra/oracle, not Lean proof.

For the positive Weyl restriction of the ordered massless step,

```text
U(q) = exp(-i qx sigma1) exp(-i qy sigma2) exp(-i qz sigma3)
     = u0(q) I - i u(q) dot sigma,
```

the exact Pauli coefficients are

```text
u0 = cx cy cz - sx sy sz
u1 = sx cy cz + cx sy sz
u2 = cx sy cz - sx cy sz
u3 = cx cy sz + sx sy cz.
```

The exact determinant of the real Jacobian of `(u1,u2,u3)` factors as

```text
det J(q) = u0(q) * (cos(qy)^2 - sin(qy)^2).
```

On a principal torus representative, the massless crossing census consists of:

- eight cube corners `qj in {0,pi}`;
- eight body-center points `qj in {+pi/2,-pi/2}`.

At cube corners, `det J = u0`, so the four `+I` corners have charge `+1`
and the four `-I` corners have charge `-1`. At body centers,
`det J = -u0`, so the four `+I` points have charge `-1` and the four `-I`
points have charge `+1`. Therefore the exact oracle sums are

```text
sum_{U=+I} sign(det J) = 4 - 4 = 0,
sum_{U=-I} sign(det J) = -4 + 4 = 0.
```

This is the concrete architecture-level discharge suggested by the abstract
finite charge-balance hinge. It is not landed until Lean proves:

1. the Pauli coefficient formulas from the actual restricted live step;
2. that the displayed matrix is the actual derivative/Jacobian;
3. the complete crossing set, supplied by the in-flight massless crossing
   classification;
4. the sixteen exact determinant signs and the two finite sums.

Negative controls required in the Lean target: one wrong-parity cube corner
is not a zero-mode crossing, and a rank-deficient supplied Jacobian has zero
charge.
