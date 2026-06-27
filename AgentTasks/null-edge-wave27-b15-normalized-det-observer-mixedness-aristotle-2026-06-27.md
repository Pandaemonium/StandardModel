# Aristotle B15: normalized determinant / observer-channel mixedness

Status: held packet, not submitted.
Prepared: 2026-06-27.
Dependency class: Soft-dependent Track B theorem target.

Reason held:

- Current Aristotle concurrency is high.
- P16 and P17 are still running and may return adjacent finite Pluecker /
  hierarchy infrastructure.

## Background

Track B reframes the P1 Pluecker mass identity as the `d = 2` face of a finite
obstruction calculus. For visible two-spinor density data:

```text
P = sum_i psi_i psi_i^dagger
rho = P / trace(P)
det(P) = m^2
```

The observer-normalized mixedness claim should be the finite identity:

```text
det(rho) = det(P) / trace(P)^2
```

When `trace(P) = E_u`, this is the finite form of:

```text
det(rho) = (m / E_u)^2
```

This is a finite identity / finite reconstruction only. It is not a mass
spectrum prediction, not a continuum limit, and not Gate C.

## Requested target

Create:

```text
PhysicsSM/Draft/NullEdgeObserverMixednessDeterminant.lean
```

If the existing mixedness file already proves the exact theorem, return a report
identifying the theorem name and whether the statement uses determinant scaling
or an equivalent normalized-density definition.

## Desired theorem

Use the simplest Lean-friendly 2 by 2 matrix API compatible with the existing
mixedness work:

```text
rho = (trace P)^(-1) • P
det(rho) = (trace P)^(-2) * det(P)
```

or equivalently:

```text
det(rho) * trace(P)^2 = det(P)
```

with an explicit nonzero trace hypothesis.

## Named failure mode

Observer normalization failure:

```text
if trace(P) = 0, or if the proposed observer channel does not preserve positive
visible density data, the mixedness reading is undefined even though det(P)
remains an invariant Pluecker obstruction.
```

## Acceptance criteria

- Lean file compiles.
- No new proof placeholders, fake assumptions, or escape-hatch declarations.
- No `n a t i v e _ d e c i d e` for the determinant-scaling theorem.
- Claim label is finite identity / finite reconstruction.
- Module docstring explicitly says observer normalization does not change the
  invariant P1 statement `det(P) = m^2`.
- Do not claim entropy monotonicity, continuum measure convergence, Standard
  Model mass prediction, or Gate C release.

## Follow-up if successful

- Compare with P16/P17 returns.
- If P17 has a real higher Pluecker hierarchy, use this theorem as the `k = 2`
  normalized face and ask for the `k = 3` Cauchy-Binet obstruction next.
