# Track B cycle 2: polynomial covariance is not a branch observable

Date: 2026-06-27

Track: B, obstruction-geometry / non-ultralocal control

## Named failure mode

```text
Covariance-seed-as-branch-observable fallacy
```

## Statement

The C107 finite matrix target proves the algebraic seed:

```text
(S B T)^k = S B^k T
```

and idempotence preservation under conjugation. This is useful for later
polynomial spectral-projector covariance, but it does not construct:

```text
a native branch observable B(U);
a target spectral island;
a polynomial p that is 1 on the target and 0 on the complement;
a nonzero origin chiral index;
a bad-sector inverse gap;
or gauge covariance of the actual null-edge B(U).
```

## Why this matters

The non-ultralocal program's decisive object is:

```text
B(U)
```

not merely the algebraic identity that conjugation respects powers. A theorem
about powers becomes physically meaningful only after the branch observable is
constructed or certified.

## Next finite theorem target

```text
PolynomialConjugationCovariance:
  p(S B T) = S p(B) T.
```

Then:

```text
SpectralProjectorPolynomialCertificate:
  p is idempotent on spectrum(B),
  p = 1 on the target island,
  p = 0 on the bad spectrum,
  therefore p(B) is the intended branch projector.
```

And separately:

```text
OriginBranchObservableCertificate:
  ChiralIndex Gamma0 (p(B0)) = targetIndex != 0.
```
