# Null-edge Gate C1 after C240: Codex analysis note

Date: 2026-06-28

## Executive read

C240 is real progress. It does not close Gate C1, but it changes the problem
from "does the tetrahedral scalar Wilson idea even have the right branch
table?" to a much sharper finite/free checklist:

```text
1. prove the k_A are genuinely independent Brillouin-torus angle coordinates;
2. prove the scalar Wilson free gap globally, not only at exact branch points;
3. feed that gap into the overlap sign/Ginsparg-Wilson assembly;
4. keep gauge/anomaly/Krein/no-ghost audits separate.
```

## What changed

Before C240, scalar Wilson was only a plausible analogy to the standard Wilson
kernel. After C240, the finite branch-point algebra is formalized:

```text
sum_A B_A sin(k_A) = 0
  implies
sin(k_A) = 0 for every A,
```

provided the tetrahedral coframe is interpreted in the four-dimensional
Dirac-vector coefficient space.

At a branch point, the scalar Wilson term gives:

```text
m_n = (2 r n - rho) / a.
```

The standard overlap sign window:

```text
a > 0,
0 < rho < 2r
```

then gives:

```text
m_0 < 0,
m_n > 0 for n = 1, ..., 4.
```

This is exactly the free branch-mass sign pattern we wanted for the first
Null-Edge Overlap model.

## What did not change

The old scalar-Wilson no-go is not refuted. Its scope is different.

The no-go says a scalar term cannot directly polarize the balanced origin
kernel into a physical Weyl line. C240 uses scalar Wilson in the standard
overlap role:

```text
not as a direct chirality selector,
but as a branch-mass term inside a Hermitian sign kernel.
```

That route can work because the physical chirality is supplied by the overlap
sign/Ginsparg-Wilson construction, not by the raw finite branch kernel.

## The current theorem stack

Recent completed Draft layers now line up as follows:

```text
C235:
  bare branch-kernel projector obstruction.

C239:
  H_ne = gamma5(D + E - m) is Hermitian under explicit algebraic assumptions.

C240:
  tetrahedral coframe, branch table, and scalar Wilson branch-mass window.

C241:
  fallback M_br interpolation if scalar Wilson has a degeneracy that must be
  split.

C242:
  reference-import API: below-margin perturbation preserves a gapped homotopy.
```

The missing bridge is no longer conceptual. It is technical:

```text
Torus-duality theorem + global free gap + sign/GW assembly.
```

## Best next Lean targets

### 1. Tetrahedral lattice-duality theorem

Formalize the claim:

```text
Lambda = span_Z {n_A}
k_A(p) = n_A dot p
```

and prove that the induced Brillouin torus coordinates are equivalent to:

```text
(R / 2*pi Z)^4.
```

This turns the independent-angle caveat in C240 into a theorem.

### 2. Global free gap theorem

Use the scalar lower-bound shape:

```text
F(k) =
  |sum_A B_A sin(k_A)|^2
  + [r sum_A (1 - cos(k_A)) - rho]^2.
```

The proof strategy should split:

```text
If any sin(k_A) is nonzero:
  the kinetic norm term is positive.

If all sin(k_A) vanish:
  k_A is 0 or pi, and C240's branch-mass theorem handles the Wilson term.
```

This may avoid compactness and give a direct no-zero theorem.

### 3. Overlap sign/GW assembly

Once a global gap exists, prove the algebraic release:

```text
epsilon = sign(H_ne),
epsilon^2 = 1,
D_ov = rho * (1 + gamma5 epsilon),
```

then derive the Ginsparg-Wilson relation and the physical projector API.

### 4. Safety audits

Only after the free sign operator is assembled should we upgrade claims:

```text
bad-sector inverse gap;
no propagator-zero mirror removal;
gauge covariance/admissibility;
Krein/Hilbert positivity;
determinant-line and anomaly accounting.
```

## Recommendation

The next Aristotle wave should prioritize:

```text
C244:
  lattice-duality / Brillouin-torus theorem.

C243:
  global free no-zero/gap theorem.

C246:
  strategy audit after C240, assuming scalar Wilson succeeds in the free table.

C245:
  covariant M_br realization, now lower priority and treated as fallback.
```

The most important sentence for claim discipline is:

```text
C240 makes scalar Wilson viable as an overlap branch-mass input; it does not
make scalar Wilson a direct chiral projector.
```
