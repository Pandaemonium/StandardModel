# Aristotle semantic context pack

Generated: 2026-07-15T03:08:37
Query: `ADM shift variation scalar field momentum density orthonormal stress-energy flux coframe plus-minus signature null edge general relativity`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean`

Score: `0.793`

```text
import Mathlib

/-!
# Stress-energy boundary and weak-field/cosmological controls

This module isolates three G6-G8 facts.

First, neither of the two displayed scalar summaries determines a spacetime
stress tensor. Explicit pairs of distinct symmetric four-dimensional tensors
have either the same rest-frame energy density or the same ordinary matrix
trace. These witnesses do not rule out an artificial scalar encoding of every
component. A physical matter construction must instead specify a metric or
coframe convention and provide the corresponding full variation of the actual
matter action, including its index and measure normalization, stresses, and
fluxes, rather than identify a single channel sum with `T_mu_nu`. The symmetric
matrix argument below applies to metric variations; a coframe variation has a
different index interface.

Second, with the convention

```text
G_mu_nu = (8 pi G / c^4) T_mu_nu,
```

the standard weak-field identifications

```text
G_00 = (2 / c^2) Laplacian(Phi),   T_00 = rho c^2
```

are exactly equivalent to `Laplacian(Phi) = 4 pi G rho`. This checks the
physical constant normalization; it does not derive either weak-field
identification from null edges.

Third, for a homogeneous perfect fluid in the natural-unit continuity
convention

```text
a * d rho/da + 3 * (rho + pressure) = 0,
```

the standard dust and radiation density laws satisfy the equation exactly.
This is a cosmological conservation control, not a derivation of FLRW geometry
or the Friedmann equations.
-/

open Matrix
```

### 2. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean`

Score: `0.784`

```text
namespace PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls

/-! ## Scalar source budgets do not determine stress-energy -/

/-- Real covariant stress-tensor components in a fixed four-frame. -/
```

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.771`

```text
invertible matrix witness with noncommuting source/coupling | Construct the Einstein operator, contracted Bianchi theorem, variational stress tensor, and universal coupling |
| Scalar matter budgets do not determine stress-energy | M [orig] | Explicit distinct symmetric four-tensors with equal rest energy density or equal ordinary matrix trace | Construct the full metric/coframe variation, including pressures and fluxes |
| A full symmetric component response determines its symmetric coefficient tensor uniquely | M [orig] | Equality of finite Frobenius response on every symmetric probe forces matrix equality | Prove the null-edge matter action has the corresponding localized, measure-normalized derivative and satisfies the Noether identity |
| A homogeneous scalar one-cell action yields density and pressure from distinct diagonal responses | M [comp] | The action includes the oriented diagonal coframe determinant and inverse lapse; lapse variation gives minus the oriented spatial-volume factor times `rho`, each spatial-scale variation gives lapse times an oriented opposite-face factor times `p`, and a nonzero covariant orthonormal perfect-fluid component matrix is assembled | Positive-orientation and nondegeneracy hypotheses for the geometric reading; spatial gradients and fluxes; arbitrary coframe variations; graph localization; the scalar equation of motion; Lorentz/Noether identities; covariant conservation |
| Flat-FLRW lapse stationarity is equivalent to the first Friedmann equation | T\|H [comp/import] | Assuming the standard boundary-reduced Einstein-Hilbert minisuperspace action, adding the constructed homogeneous scalar action and varying the lapse gives exactly (H^2=(8\pi G/3)\rho+\Lambda/3), with a nondegenerate positive-matter witness | Derive the FLRW reduc
```

### 4. `PhysicsSM/Draft/NullEdge/MassNullDecomposition.lean`

Score: `0.765`

```text
namespace PhysicsSM.Draft.NullEdge.MassNullDecomposition

/-! ## Level A — 4-momentum conventions (matching `NullEdgeTwoNullMassive`) -/
```

### 5. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G6. Source and conservation]

Score: `0.764`

```text
riation are equal. The diagonal probes carry a harmless factor of two over
\(\mathbb R\). This proves coefficient uniqueness if an actual first variation
has already been represented by that pairing. The theorem contains no spacetime
integral, volume density, localization, or covariance theorem. The open problem
is to construct the localized measure-normalized derivative from the null-edge
matter action and derive its on-shell Noether conservation law.

One restricted construction now goes beyond uniqueness. On a single
homogeneous diagonal `(+---)` cell, the scalar matter action includes both the
oriented determinant `N a_1 a_2 a_3` and inverse metric component
`g^{00}=N^{-2}`.
Its reduced form is

\[
  S_m=a_1a_2a_3\left(\frac{\dot\phi^2}{2N}-NV\right).
\]

Varying the lapse gives `-a_1a_2a_3 rho`, while varying `a_i` gives `N` times
the oriented opposite-face factor times `p`, with

\[
  \rho=\frac{\dot\phi^2}{2N^2}+V,
  \qquad
  p=\frac{\dot\phi^2}{2N^2}-V.
\]

All four derivatives come from the same checked action. The usual
`sqrt(-g)` reading additionally requires the positive-orientation sector
`N a_1a_2a_3>0`, and a nondegenerate Lorentzian metric requires every diagonal
coframe scale to be nonzero. The assembled matrix `diag(rho,p,p,p)` records
covariant orthonormal components; the normalized coframe responses instead
couple to the mixed components `diag(rho,-p,-p,-p)`. Zero displayed flux is a
fact about the assembled definition, not a result of an off-diagonal
variation. This is a genuine measure-aware diagonal response, but only in the
homogeneous sector. It does not yet supply spatial gradients, off-diagonal
responses, graph localization, the scalar equation of motion, a Lorentz or
diffeomorphism Noether identity, or covariant conservation. Thus G6 has a
co
```

### 6. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G6. Source and conservation]

Score: `0.760`

```text
s not yet supply spatial gradients, off-diagonal
responses, graph localization, the scalar equation of motion, a Lorentz or
diffeomorphism Noether identity, or covariant conservation. Thus G6 has a
constructed perfect-fluid slice, not a general null-edge stress tensor.
```

### 7. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [spatialTraceWitness]

Score: `0.759`

```text
def spatialTraceWitness : Stress4 :=
  Matrix.diagonal ![0, 1, 0, 0]

/-- Rest-frame `00` energy-density component. -/
```

### 8. `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean` [einsteinCoupling]

Score: `0.753`

```text
def einsteinCoupling (G c : ℝ) : ℝ :=
  8 * Real.pi * G / c ^ 4

/-- Standard weak-field `00` component equation after inserting
`G_00 = 2 Laplacian(Phi) / c^2` and `T_00 = rho c^2`. It assumes a
mostly-minus-compatible reduction, a mass-density source, and zero
cosmological term; it does not derive or encode a metric. -/
```

## Scoped paper hits

### 1. Noise kernel in stochastic gravity and stress energy bitensor of quantum fields in curved spacetimes

Score: `0.770`
Zotero key: `5T5BQ6PT`
DOI: `10.1103/physrevd.63.104001`

### 2. Gravitational Thermodynamics of Causal Diamonds in (A)dS

Score: `0.740`
Zotero key: `2ZZTQS43`
arXiv: `1812.01596`
URL: http://arxiv.org/abs/1812.01596v3

### 3. Stochastic Gravity: Theory and Applications

Score: `0.739`
Zotero key: `TXN5JSZ5`
DOI: `10.12942/lrr-2008-3`
URL: https://doi.org/10.12942/lrr-2008-3

### 4. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.730`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 5. Single twistor description of massless, massive, AdS, and other interacting particles

Score: `0.728`
Zotero key: `zotero:NFHRVF2Q`
arXiv: `hep-th/0512091`
DOI: `10.1103/PhysRevD.73.064002`
URL: https://doi.org/10.1103/PhysRevD.73.064002
