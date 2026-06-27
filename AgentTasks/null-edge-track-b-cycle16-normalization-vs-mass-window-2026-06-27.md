# Track B cycle 16: normalization window is not overlap mass window

Date: 2026-06-27

Purpose:

- Prevent a language collision between Track B observer normalization and Gate C
  overlap mass-window safety.

## Separation

Gate C mass-window condition:

```text
For fixed overlap symbol data (D, W, r, rho), a bare zero mode D(q)v = 0 must
avoid the Wilson shell r W(q) = rho, otherwise the shifted sign kernel is
singular.
```

Track B observer normalization:

```text
For visible density data P, rho = P / trace(P) requires trace(P) != 0, and then
det(rho) = det(P) / trace(P)^2.
```

These are different denominators and different failure modes.

## Named failure modes

Overlap shell-crossing failure:

```text
D(q)v = 0 and r W(q) = rho for v != 0, so the direct raw-overlap sign kernel is
singular.
```

Observer normalization failure:

```text
trace(P) = 0, or the observer channel does not preserve positive visible density
data, so rho = P / trace(P) is undefined even though det(P) remains an invariant
Pluecker obstruction.
```

## Finite theorem target refined

B15 should not use "mass window" language. Its theorem is purely determinant
scaling for normalized 2 by 2 visible density matrices:

```text
trace(P) != 0 -> det((trace P)^(-1) P) = det(P) / trace(P)^2.
```

This remains soft-dependent on P16/P17 only for API reuse. It does not depend on
C102/C104, and it must not be cited as evidence for Gate C overlap safety.
