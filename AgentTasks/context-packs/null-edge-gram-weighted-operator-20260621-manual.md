# Aristotle manual context pack

Generated: 2026-06-21

Query:

```text
operator positivity bridge for Gram-weighted visible momentum: hidden Gram
positive semidefinite implies visible momentum positive semidefinite
```

## Target idea

Earlier feedback pushed the null-edge program toward operator statements, not
only scalar determinant identities. This focused job proves the finite algebraic
core:

```text
v^dagger P_vis v = y(v)^dagger G y(v)
```

where

```text
P_vis_ab = sum_ij G_ij psi_i,a conj(psi_j,b)
y_i(v) = sum_a conj(psi_i,a) v_a
```

Thus if the hidden Gram form `G` is positive semidefinite, the visible momentum
operator is positive semidefinite.

## Included copied dependency

The package includes a copied trusted file:

```text
PhysicsSM/Spinor/PluckerMass.lean
```

It supplies `CSpinor = Fin 2 -> Complex` and the surrounding Pluecker API.

## Proof sketch

1. Expand the visible quadratic form:

```lean
visibleQuadraticForm (operatorGramWeightedVisibleMomentum G psi) v
```

2. Reassociate finite sums:

```text
sum_ab conj(v_a) (sum_ij G_ij psi_i,a conj(psi_j,b)) v_b
```

to

```text
sum_ij (sum_a conj(v_a) psi_i,a) G_ij
       (sum_b conj(psi_j,b) v_b)
```

3. Recognize the first parenthesis as the conjugate of `spinorProjection psi v i`.
4. The positive-semidefinite wrapper is immediate by applying the hidden Gram
   hypothesis to `spinorProjection psi v`.

## Statement risks

- Preserve the Hermitian convention: the projection is
  `sum_a conj(psi_i,a) v_a`.
- The positive-semidefinite property is deliberately encoded as a finite
  quadratic form with both nonnegative real part and zero imaginary part.
- This theorem is finite operator algebra; it does not assert an analytic
  Hilbert-space completion.
