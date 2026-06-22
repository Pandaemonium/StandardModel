# Aristotle manual context pack

Generated: 2026-06-21

Query:

```text
normalized visible mass ratio as qubit concurrence for a trace-one visible
two-state density matrix
```

## Target idea

The updated null-edge plan identifies the reduced visible density theorem as a
cheap high-value physics-facing result. For a pure global state on
`visible qubit tensor internal labels`, the entanglement concurrence of the
visible/internal cut is

```text
C = 2 * sqrt(det rho_vis).
```

The finite algebra that should be banked first is the trace-one `2 x 2` identity:

```text
2 * (1 - Tr(rho^2)) = 4 * det(rho).
```

This is the usual qubit relation between determinant, linear entropy, and
concurrence squared.

## Scope

This job is finite matrix algebra only. It does not prove LOCC monotonicity,
does not assert a continuum time theorem, and does not choose a physical
normalization beyond the determinant expression.

## Proof sketch

For a `2 x 2` matrix

```text
rho = [[a,b],[c,d]],
```

expand:

```text
Tr(rho^2) = a^2 + 2bc + d^2
Tr(rho)^2 = a^2 + 2ad + d^2
det(rho) = ad - bc.
```

Thus:

```text
Tr(rho^2) = Tr(rho)^2 - 2 det(rho).
```

Under `Tr(rho) = 1`, this gives:

```text
2 * (1 - Tr(rho^2)) = 4 * det(rho).
```

The real square-root wrapper is:

```text
(2 * sqrt d)^2 = 4 d
```

for `0 <= d`.

## Theorem targets

```lean
trace2_mul_self_eq_trace_sq_sub_two_det
linearEntropyComplex_eq_concurrenceSq_of_trace_one
normalized_mass_ratio_eq_concurrence
normalized_mass_ratio_sq_eq_four_det
qubitConcurrence_sq_eq_four_det
```
