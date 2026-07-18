# Aristotle target: covariant link/face Palatini adjoint

Work only in `CovariantLinkPalatini/Target.lean`. Run this narrow command first:

```text
lake env lean CovariantLinkPalatini/Target.lean
```

Prove both target theorems without changing any definition or theorem
statement:

1. `sum_pair_covariantForwardDifference_periodic`
2. `covariantLinkFaceFirstVariation_eq_eulerPairing`

You may add small named helper lemmas for finite-sum commutation, transpose
pairing, componentwise subtraction, and periodic reindexing. Do not add new
assumptions, change the scalar field, impose orthogonality on the transport,
or weaken equality to a conditional statement. Do not use executable proof
shortcuts that expand the trust base.

Mathematical plan:

- Expand `fiberPair`, `transportApply`, and the forward difference.
- Commute the two finite fiber sums so
  `sum_i weight_i * sum_j U_ij field_j` becomes
  `sum_j (sum_i U_ij weight_i) * field_j`.
- Reindex the site sum by the periodic shift. The predecessor transport and
  predecessor weight should produce `covariantBackwardAdjoint` exactly.
- Expand the two curl branches, apply the first target to each fixed ordered
  face, commute the finite site/direction/fiber sums, and collect the local
  coefficient.

Semantic boundary: this target uses the Euclidean real fiber pairing, so the
adjoint is ordinary transpose. Do not claim that it is already the Lorentzian
Krein adjoint or a Levi-Civita selection theorem.
