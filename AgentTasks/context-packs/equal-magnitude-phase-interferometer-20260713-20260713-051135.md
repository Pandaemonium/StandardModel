# Aristotle semantic context pack

Generated: 2026-07-13T05:11:40
Query: `equal magnitude U1 edge phase profiles gauge invariant loop holonomy interference operational discriminator`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h6-dvt-jordan-yukawa-constraint-audit/fur-h6-dvt-jordan-yukawa-constraint-audit_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass]

Score: `0.779`

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

### 2. `PhysicsSM/Draft/NullEdge/GaugeClassification.lean`

Score: `0.779`

```text
e. `arg (z₁ x * conj (z₂ x))`) is
  invariant, edge-by-edge and without any winding subtlety
  (`common_gauge_rel_invariant`, `arg_rel_common_gauge_invariant`).  The
  landed interference amplitude reads exactly this datum: `witness_rel_arg_ne`
  shows the `(3+4i)/5`-vs-`1` relative phase is nonzero, while the
  equal-field control is zero.
* **Q4 (Lean-ready set).** Everything below, with the oracle configurations
  as explicit witnesses and the constant field as the control, is ready for
  a proof job to discharge the remaining `classification_complete_*` holes.

Provenance: Sol strategy memo section 3 (gauge classification), designed
and FULLY PROVED by Aristotle project `ae6393d3-1ef3-4d93-af50-6d93662be1cc`
(run `d32e73e9`) with my oracle constraints as hard data; integrated with
local kernel re-check.  Headline results: complete gauge-orbit invariant
(holR, holL, current) with the single relation sum(current) = -(holR+holL);
gauge-triviality iff constant phase; wall witness not gauge-trivial
(matching the 821/3125 vs 49/625 oracle); common-gauge relative invariant
arg(z1 * conj z2) - exactly the datum the landed 4/5 interference
probability reads.  Lean 4.28.0.
-/
```

### 3. `AgentTasks/aristotle-wave11-20260626/d19-d0-symbol-contract-implementation-plan/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass]

Score: `0.779`

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

### 4. `AgentTasks/aristotle-wave13-20260626/fur-e1-electroweak-stabilizer-comparison/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass]

Score: `0.779`

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

### 5. `AgentTasks/aristotle-wave12-20260626/c61-gauge-covariant-link-dressed-projectors/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass]

Score: `0.779`

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

### 6. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h3-conjugate-ideal-right-handed-sector/fur-h3-conjugate-ideal-right-handed-sector_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [15.6 P1.5 toy theorem 2: Abelian Higgs null-edge holonomy mass]

Score: `0.779`

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

## Scoped paper hits

### 1. An invitation to higher gauge theory

Score: `0.733`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 2. Mass Without Mass from a Berry--Shifted SU(3) Holonomy Rotor

Score: `0.722`
Zotero key: `QJGUEHG6`
arXiv: `2603.06770`
DOI: `10.1016/j.physletb.2026.140340`
URL: http://arxiv.org/abs/2603.06770

Abstract:

We identify a local, gauge-invariant mechanism that generates a finite spectral scale in pure SU(3) Yang--Mills theory on a punctured three-ball. Fixing a $\mathbb{Z}_3$ center sector isolates a single gauge-invariant holonomy angle whose Berry shift produces a quantum rotor with strictly nonzero level spacing. Gauss law is enforced by a covariant Dirichlet Helmholtz projector built from the Dirichlet inverse of the covariant scalar Laplacian with relative boundary conditions. The slow holonomy mode is chosen variationally as the minimizer of transverse electric energy under the holonomy constraint, yielding an inertia \emph{independent of the gauge representative} with linear domain-size scaling and a controlled commutator-dominated regime. We prove projector stability and derive an adiabatic variational upper bound on the first positive Yang--Mills eigenvalue, with error controlled by the transverse vector gap of the covariant Laplacian on divergence-free one-forms. A femtometer-scale benchmark at realistic coupling gives an upper bound at a hadronic ($\sim 1\,$GeV) scale. In Wilczek's sense this realizes ``mass without mass'': no explicit mass term or Higgs field is introduced, and the nonzero level spacing is fixed by gauge invariance, topology, and the chosen center sector. The present results are derived on a finite domain; interpreting the length $R$ in Minkowski space requires an additional physical input (e.g.\ as a local confinement length), which we make explicit.

### 3. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.719`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 4. Electromagnetic lattice gauge invariance in two-dimensional discrete-time quantum walks

Score: `0.718`
Zotero key: `9E6PRB46`
DOI: `10.1103/physreva.98.032333`
URL: https://www.zotero.org/19894138/items/9E6PRB46

Abstract:

Gauge invariance is one of the more important concepts in physics. We discuss this concept in connection with the unitary evolution of discrete-time quantum walks in one and two spatial dimensions, when they include the interaction with synthetic, external electromagnetic fields. One introduces this interaction as additional phases that play the role of gauge fields. Here, we present a way to incorporate those phases, which differs from previous works. Our proposal allows the discrete derivatives, that appear under a gauge transformation, to treat time and space on the same footing, in a way which is similar to standard lattice gauge theories. By considering two steps of the evolution, we define a density current which is gauge invariant and conserved. In the continuum limit, the dynamics of the particle, under a suitable choice of the parameters, becomes the Dirac equation and the conserved current satisfies the corresponding conservation equation.
