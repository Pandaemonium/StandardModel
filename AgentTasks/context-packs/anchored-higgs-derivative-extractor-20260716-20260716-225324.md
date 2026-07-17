# Aristotle semantic context pack

Generated: 2026-07-16T22:53:32
Query: `anchored fan of null-edge Higgs covariant differences dual-frame derivative components mostly-minus kinetic gauge invariance`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.834`

```text
ansion |

The Abelian prototype proves the exact gauge invariance of

\[
  S_H(H,U)=\sum_e
  \left|U_e H(t(e))-H(s(e))\right|^2.
\]

A covariantly constant vacuum section \(H_0\) therefore does not "travel". It
supplies an internal reference preserved by the unbroken holonomy directions.
A Higgs excitation \(h\), in \(H=H_0+h\), is a vertex field whose kinetic
variation is assembled from these edge differences. Its coarse massive
propagator may be reconstructed from causal edge histories, but it is not one
null worldline.

The same distinction appears in the super-Dirac algebra. With

\[
  D=iD_N+\Gamma_s\Phi,
\]

the null-edge operator \(D_N\) carries spacetime propagation and the
Higgs/Yukawa zero-form \(\Phi\) couples internal chiral sectors. The checked
square contains both

\[
  +\Phi^2
  \qquad\text{and}\qquad
  -i\Gamma_s\sum_a C_a[\nabla_a,\Phi].
\]

The first is the finite mass-gap block; the second is the covariant Higgs
variation. A constant vacuum can therefore leave a mass gap while its kinetic
cross term vanishes. Separately, the finite Yukawa bridge proves that the odd
left-right flip operator squares to the scalar mass block. These are
**`M [orig/comp]`** operator identities, not yet a curved-spacetime Higgs action
or a Standard Model stress tensor.

The exact finite anchors are
`PhysicsSM/Draft/NullEdgeAbelianHiggsLink.lean` for edge stiffness,
`PhysicsSM/Draft/NullEdgeFureyPhiH.lean` for the internal chirality-flip map,
`PhysicsSM/Draft/NullEdgeYukawaCheckerboard.lean` for its squared mass blocks,
`PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean` for the combined
null-kinetic, curvature-channel, Higgs-square, and Higgs-gradient decomposition,
and `PhysicsSM/Draft/NullEdge/GeometryWeightedHiggsFunctional.lean` for the
weighted finite action and it
```

### 2. `PhysicsSM/Draft/NullEdgeScalarGaugeNullQuadrature.lean`

Score: `0.802`

```text
import Mathlib
import PhysicsSM.Draft.NullEdgeScalarKineticReconstruction

/-!
# Scalar/gauge null-quadrature and the covariant Higgs-gradient reconstruction (D17)

This file realises task **D17** of the null-edge program (Working Plan §24-25,
Theorem D in §17.x, and the dual-solder conventions of `docs/NULLSTRAND.md`).  It
takes the finite scalar inverse-Gram quadrature identity already proven in
`PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean` and lifts it to the
**gauge-covariant Higgs-gradient** setting, in the purely finite/algebraic form
available now.

## Target identities (Working Plan §17.4 / §25.2)

Scalar null-quadrature (already available, re-exported here as
`scalar_null_quadrature`):

```text
g^{-1}(ξ, η) = ∑_{a,b} G^{ab} ξ(ℓ_a) η(ℓ_b).
```

Covariant Higgs-gradient reconstruction (the new content):

```text
g^{-1}(D H, D H)  =  ∑_{a,b} G^{ab} ⟪∇_a^A H, ∇_b^A H⟫.
```

Here `H` is a Higgs/scalar field valued in a real gauge representation `E`
equipped with a (gauge-invariant) bilinear inner product `q = ⟪·,·⟫`.  The
covariant differential is modelled by a linear map `DH : V →ₗ[ℝ] E`, and the
null-edge covariant derivative is `∇_a^A H := DH(ℓ_a) ∈ E`.

## Clean inner-product abstraction

We take the gauge inner product abstractly as a bilinear form
`q : E →ₗ[ℝ] E →ₗ[ℝ] ℝ`.  This is the minimal data needed: no positivity,
completeness, or smoothness is used.  The left-hand "intrinsic" object
`g^{-1}(DH, DH')` is the tensor metric `g^{-1} ⊗ q` evaluated on the
`E`-valued one-forms; in this finite setting we *characterise* it by its
frame-independent component expansion (`gauge_null_quadrature`), which is the
mathematically honest way to package `g^{-1} ⊗ q` without tensor-product
machinery.

## Main results

* `gaugeNullKinetic` : the null-frame inve
```

### 3. `AgentTasks/context-packs/equal-magnitude-phase-interferometer-20260713-20260713-051135.md` [15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass]

Score: `0.801`

```text
### 15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass

Let `G = U(1)`. Put a complex scalar `phi_x` on vertices and gauge holonomies
`U_e in U(1)` on null edges `e : s(e) -> t(e)`. Define:

```text
S_H = sum_e |U_e phi_t(e) - phi_s(e)|^2 + sum_x V(|phi_x|^2).
```

This is gauge-invariant under:

```text
phi_x -> g_x phi_x,
U_e   -> g_s(e) U_e g_t(e)^(-1).
```

If the scalar sits in a vacuum section:

```text
phi_x = v sigma_x,
|sigma_x| = 1,
```

then the edge term becomes:

```text
v^2 |U_e sigma_t(e) - sigma_s(e)|^2.
```

Define the gauge-invariant mismatch phase:

```text
w_e = sigma_s(e)^(-1) U_e sigma_t(e).
```

Then:

```text
S_e = v^2 |w_e - 1|^2.
```

For `w_e = exp(i epsilon A_e)`,

```text
S_e = 2 v^2 (1 - cos(epsilon A_e))
    = v^2 epsilon^2 A_e^2 + O(epsilon^4).
```

The theorem should establish:

```text
a null-edge Higgs covariant difference plus a nonzero condensate produces a
quadratic gauge-holonomy mass term.
```

This is not merely unitary gauge. The gauge-invariant object is the mismatch
between edge holonomy and condensate section.
```
```

### 4. `AgentTasks/context-packs/equal-magnitude-phase-interferometer-20260713-20260713-051135.md` [15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass]

Score: `0.801`

```text
### 15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass

Let `G = U(1)`. Put a complex scalar `phi_x` on vertices and gauge holonomies
`U_e in U(1)` on null edges `e : s(e) -> t(e)`. Define:

```text
S_H = sum_e |U_e phi_t(e) - phi_s(e)|^2 + sum_x V(|phi_x|^2).
```

This is gauge-invariant under:

```text
phi_x -> g_x phi_x,
U_e   -> g_s(e) U_e g_t(e)^(-1).
```

If the scalar sits in a vacuum section:

```text
phi_x = v sigma_x,
|sigma_x| = 1,
```

then the edge term becomes:

```text
v^2 |U_e sigma_t(e) - sigma_s(e)|^2.
```

Define the gauge-invariant mismatch phase:

```text
w_e = sigma_s(e)^(-1) U_e sigma_t(e).
```

Then:

```text
S_e = v^2 |w_e - 1|^2.
```

For `w_e = exp(i epsilon A_e)`,

```text
S_e = 2 v^2 (1 - cos(epsilon A_e))
    = v^2 epsilon^2 A_e^2 + O(epsilon^4).
```

The theorem should establish:

```text
a null-edge Higgs covariant difference plus a nonzero condensate produces a
quadratic gauge-holonomy mass term.
```

This is not merely unitary gauge. The gauge-invariant object is the mismatch
between edge holonomy and condensate section.
```
```

### 5. `AgentTasks/context-packs/equal-magnitude-phase-interferometer-20260713-20260713-051135.md` [15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass]

Score: `0.801`

```text
### 15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass

Let `G = U(1)`. Put a complex scalar `phi_x` on vertices and gauge holonomies
`U_e in U(1)` on null edges `e : s(e) -> t(e)`. Define:

```text
S_H = sum_e |U_e phi_t(e) - phi_s(e)|^2 + sum_x V(|phi_x|^2).
```

This is gauge-invariant under:

```text
phi_x -> g_x phi_x,
U_e   -> g_s(e) U_e g_t(e)^(-1).
```

If the scalar sits in a vacuum section:

```text
phi_x = v sigma_x,
|sigma_x| = 1,
```

then the edge term becomes:

```text
v^2 |U_e sigma_t(e) - sigma_s(e)|^2.
```

Define the gauge-invariant mismatch phase:

```text
w_e = sigma_s(e)^(-1) U_e sigma_t(e).
```

Then:

```text
S_e = v^2 |w_e - 1|^2.
```

For `w_e = exp(i epsilon A_e)`,

```text
S_e = 2 v^2 (1 - cos(epsilon A_e))
    = v^2 epsilon^2 A_e^2 + O(epsilon^4).
```

The theorem should establish:

```text
a null-edge Higgs covariant difference plus a nonzero condensate produces a
quadratic gauge-holonomy mass term.
```

This is not merely unitary gauge. The gauge-invariant object is the mismatch
between edge holonomy and condensate section.
```
```

### 6. `AgentTasks/context-packs/equal-magnitude-phase-interferometer-20260713-20260713-051135.md` [15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass]

Score: `0.801`

```text
### 15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass

Let `G = U(1)`. Put a complex scalar `phi_x` on vertices and gauge holonomies
`U_e in U(1)` on null edges `e : s(e) -> t(e)`. Define:

```text
S_H = sum_e |U_e phi_t(e) - phi_s(e)|^2 + sum_x V(|phi_x|^2).
```

This is gauge-invariant under:

```text
phi_x -> g_x phi_x,
U_e   -> g_s(e) U_e g_t(e)^(-1).
```

If the scalar sits in a vacuum section:

```text
phi_x = v sigma_x,
|sigma_x| = 1,
```

then the edge term becomes:

```text
v^2 |U_e sigma_t(e) - sigma_s(e)|^2.
```

Define the gauge-invariant mismatch phase:

```text
w_e = sigma_s(e)^(-1) U_e sigma_t(e).
```

Then:

```text
S_e = v^2 |w_e - 1|^2.
```

For `w_e = exp(i epsilon A_e)`,

```text
S_e = 2 v^2 (1 - cos(epsilon A_e))
    = v^2 epsilon^2 A_e^2 + O(epsilon^4).
```

The theorem should establish:

```text
a null-edge Higgs covariant difference plus a nonzero condensate produces a
quadratic gauge-holonomy mass term.
```

This is not merely unitary gauge. The gauge-invariant object is the mismatch
between edge holonomy and condensate section.
```
```

### 7. `AgentTasks/context-packs/equal-magnitude-phase-interferometer-20260713-20260713-051135.md` [15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass]

Score: `0.801`

```text
### 15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass

Let `G = U(1)`. Put a complex scalar `phi_x` on vertices and gauge holonomies
`U_e in U(1)` on null edges `e : s(e) -> t(e)`. Define:

```text
S_H = sum_e |U_e phi_t(e) - phi_s(e)|^2 + sum_x V(|phi_x|^2).
```

This is gauge-invariant under:

```text
phi_x -> g_x phi_x,
U_e   -> g_s(e) U_e g_t(e)^(-1).
```

If the scalar sits in a vacuum section:

```text
phi_x = v sigma_x,
|sigma_x| = 1,
```

then the edge term becomes:

```text
v^2 |U_e sigma_t(e) - sigma_s(e)|^2.
```

Define the gauge-invariant mismatch phase:

```text
w_e = sigma_s(e)^(-1) U_e sigma_t(e).
```

Then:

```text
S_e = v^2 |w_e - 1|^2.
```

For `w_e = exp(i epsilon A_e)`,

```text
S_e = 2 v^2 (1 - cos(epsilon A_e))
    = v^2 epsilon^2 A_e^2 + O(epsilon^4).
```

The theorem should establish:

```text
a null-edge Higgs covariant difference plus a nonzero condensate produces a
quadratic gauge-holonomy mass term.
```

This is not merely unitary gauge. The gauge-invariant object is the mismatch
between edge holonomy and condensate section.
```
```

### 8. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h3-conjugate-ideal-right-handed-sector/fur-h3-conjugate-ideal-right-handed-sector_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [18.7 Null-edge versus lattice-gauge-theory gate]

Score: `0.800`

```text
### 18.7 Null-edge versus lattice-gauge-theory gate

Aristotle agrees that the Abelian Higgs link theorem is close to ordinary lattice gauge-Higgs theory by itself. The null-edge content only becomes substantive if the surrounding package succeeds:

- Null-supported kinetic terms.
- Dual-covector soldering `c(alpha^a)` rather than diagonal `c(ell_a^flat)`.
- Fermions, holonomies, and Higgs differences living on the same null substrate.
- A recovered continuum Dirac symbol.
- A determinant-level no-doubling test.
- A super-Dirac square with the correct kinetic, curvature, frame, and `Phi^2` terms.

Absent these, P1.5 should be described honestly as a graph discretization with null labels plus useful reconstruction theorems.
```

## Scoped paper hits

### 1. Comment on 'Gauge networks in noncommutative geometry'

Score: `0.739`
Zotero key: `Q55ZUJSZ`
arXiv: `2508.17338`
DOI: `10.48550/arXiv.2508.17338`
URL: https://arxiv.org/abs/2508.17338

Abstract:

A critique of the gauge-network spectral-action construction arguing that the continuum limit is pure Yang-Mills without a Higgs scalar.

### 2. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.731`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 3. An invitation to higher gauge theory

Score: `0.727`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 4. Modular Hamiltonians for Deformed Half-Spaces and the Averaged Null Energy Condition

Score: `0.724`
Zotero key: `B68T629C`
arXiv: `1605.08072`
DOI: `10.1007/JHEP09(2016)038`
URL: http://arxiv.org/abs/1605.08072

Abstract:

Derives a modular Hamiltonian term for deformed half-spaces and uses relative-entropy monotonicity to prove ANEC.

### 5. Lattice regularization of reduced Kähler-Dirac fermions and connections to chiral fermions

Score: `0.724`
Zotero key: `8RSBSW7Z`
DOI: `10.21468/scipostphys.16.4.108`
URL: https://doi.org/10.21468/scipostphys.16.4.108

Abstract:

Reduced Kähler-Dirac fermions, mirror sectors, measure phase, and a doubler-free lattice action; source guardrail for the null-edge order-complex fermion branch and no-doubling claims.
