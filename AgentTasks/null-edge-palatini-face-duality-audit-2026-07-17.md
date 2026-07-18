# Null-edge Palatini face-duality audit

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-006D`
Status: corrected and kernel-checked

## Question

In the periodic link action, do the ordered labels `(a,b)` on
`star(e_a wedge e_b)` denote the coframe face or the curvature plaquette?

## Finding

They cannot denote both. The continuum tetradic Palatini density is

```text
epsilon_ABCD e^A wedge e^B wedge F^CD.
```

Therefore the coefficient of the actual curvature component `F_ab` is

```text
(1/2) sum_cd epsilon^(cdab) star_internal(e_c wedge e_d).
```

The same-label expression `star_internal(e_a wedge e_b)` is the internal
bivector building block for the coframe pair. It becomes the coefficient of a
curvature holonomy only when that holonomy is explicitly assigned to the dual
face. The current periodic module instead constructs the plaquette directly
from links in directions `(a,b)`, so the complementary contraction is required.

## Lean correction

`LorentzCoframePalatiniFace.lean` now defines an exact normalized
Vandermonde alternating symbol on `Fin 4` and the complementary Palatini face
weight. It proves ordered antisymmetry, repeated-direction vanishing, and all
six canonical complements:

```text
01 ->  23    02 -> -13    03 ->  12
12 ->  03    13 -> -02    23 ->  01
```

`FinitePeriodicCoframeKreinPalatiniVariation.lean` now inserts this corrected
field into the exact Krein link Euler/divergence theorem.

The same module chain now proves the exact pairing convention
`[star(B), C]_J = -(1/4) epsilon_IJKL B^IJ C^KL`. Thus there is one global
minus relative to the displayed internal-epsilon contraction. It is invisible
to the source-free connection stationarity equation, but remains an explicit
normalization gate for the coupled Einstein-matter endpoint.

## Primary provenance

- E. Kur and A. S. Glasser, *Discrete Gravity with Local Lorentz Invariance*,
  arXiv:2202.02486, especially Eqs. (15), (16), and (25). Their cell
  permutation assigns two directions to coframe edges and the complementary
  two directions to curvature holonomy.
- J. W. Barrett, *First order Regge calculus*, arXiv:hep-th/9404124. Triangle
  areas are conjugate to first-order curvature data.
- S. Gionti, *Discrete Gravity as a Local Theory of the Poincare Group in the
  First Order Formalism*, arXiv:gr-qc/0501082. The first-order theory is built
  on a metric-dual Voronoi complex.

## Remaining boundary

This fixes the local orientation and face-label algebra. It does not derive a
metric dual-cell volume from the null-edge carrier, prove the nonlinear
plaquette tangent, or select the Levi-Civita link connection.
