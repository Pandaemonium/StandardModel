# Aristotle manual context pack

Generated: 2026-06-21

Query:

```text
Hermitian hidden Gram matrix induces Hermitian visible momentum operator
```

## Target idea

The null-edge hidden-channel program should prove operator-level sanity
conditions before leaning on determinant interpretations. This focused theorem
says that if the hidden Gram matrix is Hermitian, then the visible reduced
momentum obtained by tracing hidden labels is Hermitian, and hence has real
diagonal entries.

## Included copied dependency

The package includes:

```text
PhysicsSM/Spinor/PluckerMass.lean
```

It supplies `CSpinor = Fin 2 -> Complex`.

## Proof sketch

For

```text
P_ab = sum_ij G_ij psi_i,a conj(psi_j,b),
```

we need

```text
P_ba = conj(P_ab).
```

Expand both sides, use `map_sum` and `map_mul`, swap the finite `i,j` sums, and
use Hermiticity of `G`:

```lean
hG i j : G j i = starRingEnd Complex (G i j)
```

The diagonal-imaginary theorem follows from `z = conj z`.

## Statement risks

- Preserve conjugation order in `P_ab`.
- Do not replace Hermiticity with symmetry.
- Keep the theorem finite; no analytic operator assumptions are needed.
