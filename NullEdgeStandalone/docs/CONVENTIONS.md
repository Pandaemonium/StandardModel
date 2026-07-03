# Conventions

## Core Operator

The active finite operator architecture is dual-soldered:

```text
D_+^h = sum_a c(alpha^a) (T_a - I) / h
```

The null edge direction is `ell_a`; the Clifford soldering covector is
`alpha^a`. These are distinct.

The diagonal ansatz

```text
sum_a c(ell_a^flat) nabla_ell_a
```

is not used as the continuum Dirac-symbol operator. The trace obstruction is a
known guardrail.

## Tetrahedral Frame

In four dimensions the observer-normalized tetrahedral convention is:

```text
ell_A = (1, n_A)
alpha^A = 1/4 dt + 3/4 n_A . dx
```

with spatial tetrahedron vertices:

```text
(1, 1, 1), (1, -1, -1), (-1, 1, -1), (-1, -1, 1)
```

normalized by `sqrt 3`. The metric signature is mostly minus, `(+---)`.

The null-edge Gram matrix has diagonal `0` and off-diagonal `4/3`; the inverse
Gram has diagonal `-1/2` and off-diagonal `1/4`.

## Gradings

Keep these separate:

- `Gamma_s`: spacetime chirality.
- `chi_E`: internal finite grading.
- form or cochain degree.
- Krein fundamental symmetry `J`.

The super-Dirac square uses `Phi` commuting with `Gamma_s` to obtain the
`+ Phi^2` sign. If `Phi` anticommutes with `Gamma_s`, the sign flips.

## Claim Labels

Use these labels in docs and reviews:

- finite identity
- structural theorem
- reconstruction
- consistency check
- prediction

The current package contains finite identities, structural guardrails, and
conditional APIs. It contains no prediction-grade mass value.
