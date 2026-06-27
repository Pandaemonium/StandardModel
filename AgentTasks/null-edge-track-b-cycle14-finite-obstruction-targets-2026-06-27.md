# Track B cycle 14: finite obstruction targets after C103

Date: 2026-06-27

Purpose:

- Convert the qubit/information and obstruction-calculus framing into finite
  theorem targets with named failure modes.

## Target B14.1: normalized determinant / observer-channel mixedness

Finite theorem target:

```text
For a two-spinor visible density matrix P with positive nonzero visible trace,
rho = P / tr(P) satisfies det(rho) = det(P) / tr(P)^2.
```

Interpretation:

- This is the finite version of `det rho = (m / E_u)^2` when `det(P) = m^2`
  and the observer normalization is `E_u = tr(P)`.
- It must be stated as a finite identity / finite reconstruction only.

Named failure mode:

```text
Observer normalization failure:
  if tr(P) = 0, or if the proposed observer channel does not preserve positive
  visible density data, the mixedness reading is undefined even though det(P)
  remains an invariant Pluecker obstruction.
```

## Target B14.2: first higher Pluecker obstruction ladder

Finite theorem target:

```text
For a finite family of visible vectors in dimension d >= 3, the third elementary
obstruction is the sum of squared 3x3 minors by Cauchy-Binet.
```

Interpretation:

- This is the `k = 3` sibling of the current mass-as-`d = 2` Pluecker spread.
- It is a hierarchy theorem, not a particle-count prediction.

Named failure mode:

```text
Dimension-collapse failure:
  in a two-dimensional visible spinor space the k = 3 obstruction vanishes
  tautologically, so any nontrivial hierarchy claim must explicitly enlarge the
  visible dimension or move to an independent obstruction module.
```

## Dependency classification

- B14.1 is soft-dependent on P15/P16: it can be submitted as an independent
  finite determinant-scaling theorem if the existing mixedness file does not
  already contain it.
- B14.2 is soft-dependent on P17: wait for P17 if it returns soon; otherwise use
  this as the audit criterion for whether P17 is a real hierarchy theorem or
  only a prose analogy.

## Claim boundary

- Neither target changes the invariant P1 statement.
- Observer/mixedness language belongs only to normalized finite density data.
- The hierarchy language is an obstruction calculus proposal, not a Standard
  Model spectrum prediction.
