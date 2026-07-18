# Aristotle target: coframe-derived Lorentz-Hodge Palatini face

Work only in `CoframeHodge/Target.lean`. Run this narrow command first:

```text
lake env lean CoframeHodge/Target.lean
```

## Context

This is a focused finite real-matrix target for a null-edge gravity program.
The four-vector metric is mostly-minus `diag(1,-1,-1,-1)`. The six-component
two-form basis is ordered

```text
(12, 13, 23, 01, 02, 03),
```

so spatial rotation planes have positive induced norm and time-space boost
planes have negative induced norm. The displayed Hodge-star matrix uses
orientation `0123`; the completed control theorem proves that it squares to
minus identity.

The physical Palatini face field is preregistered as

```text
star (e_a wedge e_b).
```

This matches the Lorentzian first-order tetrad action convention in which the
curvature bivector is paired with the internal Hodge dual of `e wedge e`.

## Targets

1. Prove `coframeWedge_mul`: the explicit minor coordinates transform by the
   exterior-square matrix.
2. Prove `wedgeTwoTransport_commutes_lorentzHodgeStar`: proper eta-Lorentz
   transport commutes with the orientation-dependent Hodge star.
3. Prove `palatiniFaceWeight_mul` from the first two targets.

You may add small helper lemmas. Do not change any definition, basis order,
matrix entry, theorem statement, metric signature, or determinant hypothesis.
Do not weaken the proper-Lorentz hypotheses. If Target 2 is false under these
exact conventions, stop and provide a concrete counterexample and corrected
sign diagnosis rather than altering the statement silently.

## Success criteria

- all three targets compile under the pinned Lean toolchain;
- no added assumptions or executable trust shortcuts;
- preserve the already completed antisymmetry and Hodge-square controls;
- report any orientation, covariant-versus-contravariant, or transpose
  convention issue explicitly.
