# Aristotle semantic context pack

Generated: 2026-07-17T23:21:13
Query: `exact tetrad coframe variation Palatini density determinant mixed Ricci Einstein coefficient antisymmetric Lorentz curvature`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/FinitePalatiniCoframeChartAction.lean`

Score: `0.837`

```text
import PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryCancellation

/-!
# Explicit finite Palatini coframe-chart action

The preceding modules derive the determinant volume response and show how a
Ricci-plus-divergence curvature response yields the Einstein tensor. This
module supplies an actual nonlinear finite action witnessing that architecture
at a fixed geometric base point.

The variables are local coframe generators `X(x)`. At each site,

```text
volume_X = det(e (1 + X)),
gInv_X   = gInv + delta_gInv(X),
R_X      = <Ric, gInv_X>.
```

The Ricci tensor is held fixed, as in the metric variation of a first-order
Palatini action with independent connection. The total chart action is

```text
(1 / (2 kappa)) sum_x volume_X (R_X - 2 Lambda)
  - (1 / 2) sum_x volume_0 <T, delta_gInv(X)>.
```

Its derivative is computed from the displayed action. The determinant theorem
supplies the volume channel, fixed-connection contraction supplies the Ricci
channel, and the coframe generator map reaches every symmetric inverse-metric
variation. Hence stationarity at the chart origin is equivalent to the
pointwise finite Einstein equation.

This is a nonvacuous finite action control, not the completed null-edge gravity
theory. Coframes, orientation, Ricci curvature, stress, and their common graph
origin are supplied, and the inverse-metric chart is a first-order local chart
rather than a global metric parametrization.
-/
```

### 2. `PhysicsSM/Draft/NullEdge/FinitePalatiniEinsteinHilbertVariation.lean` [metricVariationPairing_finiteEinsteinLHS]

Score: `0.830`

```text
theorem metricVariationPairing_finiteEinsteinLHS
    {I : Type*} [Fintype I]
    (ricci metric variation : Tensor (I := I))
    (scalarCurvature cosmologicalConstant : Real) :
    metricVariationPairing
        (finiteEinsteinLHS ricci scalarCurvature metric
          cosmologicalConstant)
        variation =
      metricVariationPairing ricci variation -
        (scalarCurvature / 2) * metricVariationPairing metric variation +
        cosmologicalConstant * metricVariationPairing metric variation := by
  classical
  unfold finiteEinsteinLHS finiteEinsteinTensor metricVariationPairing
  simp only [Matrix.transpose_add, Matrix.transpose_sub,
    Matrix.transpose_smul, Matrix.add_mul, Matrix.sub_mul,
    Matrix.smul_mul, Matrix.trace_add, Matrix.trace_sub,
    Matrix.trace_smul, smul_eq_mul]

/-- **Finite Palatini-to-Einstein composition.** The volume and curvature
channels combine into the Einstein tensor plus the displayed boundary
response. -/
```

### 3. `PhysicsSM/Draft/NullEdge/LorentzCoframePalatiniFace.lean` [spacetimeAlternatingSymbol]

Score: `0.829`

```text
noncomputable def spacetimeAlternatingSymbol (a b c d : Fin 4) : Real :=
  (((b : Real) - (a : Real)) * ((c : Real) - (a : Real)) *
      ((d : Real) - (a : Real)) * ((c : Real) - (b : Real)) *
      ((d : Real) - (b : Real)) * ((d : Real) - (c : Real))) / 12

/-- Coefficient of curvature on the ordered plaquette `(a,b)` in the
tetradic Palatini four-form.  The coframe bivector comes from the complementary
directions selected by the spacetime alternating symbol. -/
```

### 4. `docs/NULLSTRAND.md` [Gravity connection guardrails]

Score: `0.827`

```text
ls distinct. The internal building
  block is `star(e_a wedge e_b)`, but the coefficient of curvature plaquette
  `(a,b)` is `(1/2) sum_cd epsilon^(cdab) star(e_c wedge e_d)`. The exact
  module checks all six complements, including `F_01` paired with the `23`
  coframe plane. Reusing the same `(a,b)` for both factors is not the tetradic
  Palatini four-form.
- The complementary unweighted face field, orientation `0123`, `star^2=-1`,
  ordered antisymmetry, and the resulting Krein-divergence equation are exact.
  Proper local Lorentz covariance of both face fields is also exact. The
  metric dual-cell volume factor is still owed.
- In the fixed six-vector convention,
  `[star(B),C]_J = -(1/4) epsilon_IJKL B^IJ C^KL`. The minus sign is harmless
  for the vacuum connection stationarity equation, but a joint matter action
  must absorb it explicitly in the gravitational prefactor or curvature
  orientation before comparing `kappa` signs.
- A physical Palatini claim still owes the metric dual-cell volume factor,
  a differentiable curve-level realization of the displayed formal response,
  projective and boundary analysis, and uniqueness of the compatible
  Levi-Civita link transport.
```

### 5. `PhysicsSM/Draft/NullEdge/GRFoundations.lean`

Score: `0.827`

```text
the determinant coframe-volume derivative, a finite Palatini-to-Einstein
   composition with incidence boundary cancellation, an explicit nonlinear
   coframe-chart action control, a spinor-null-edge coframe reconstruction,
   a directed-carrier Levi-Civita/Ricci reconstruction, and an exact
   aggregate-null-edge weight parameterization of arbitrary coframes,
   an independently varied directed connection with an exact curvature and
   action derivative, its exact periodic local Euler coefficients and finite
   Levi-Civita obstruction, and a joint aggregate-coframe/connection Palatini action,
   a gauge-covariant group-valued periodic link connection, linearized scalar
   and transported finite-fiber link/face Palatini actions with exact
    backward-divergence equations, a convention-explicit Krein predecessor
    adjoint, a spacetime-derived Lorentz-bivector representation, its exact
    six-coordinate Lorentz Lie-algebra realization and trace pairing, the exact
    nonlinear right-trivialized Lorentz-plaquette tangent and its additive
    identity-link limit, a scalar ordered holonomy action with the matching
    formal product/inverse response, its exact four-family nonidentity local
    link Euler coefficients and stationarity equation, and the full
    Krein-paired link/face Euler chain with a coframe-derived Lorentz-Hodge face field,
   causal-diamond path-comparison holonomy, and an exact shrinking-plaquette
   curvature limit,
   the exact sitewise stationarity-to-Einstein-equation implication,
   conditional source conservation, and imported FLRW controls.

The facade adds no umbrella theorem. In particular, importing it does not
assert manifoldlikeness, dimension selection, stochastic concentration,
continuum convergence, equivalence of forward-difference a
```

### 6. `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` [2. The canonical gates]

Score: `0.826`

```text
-relative coframe and a compatible spin lift of the metric atlas | Exact coframe covariance, Lorentz transitions, central sign, and finite obstruction interfaces | Derive the atlas and identify the stable finite class with the continuum spin obstruction |
| F6: one curvature | Levi-Civita, holonomy, operator, and Dirac-square curvature agree | Exact finite connection/Bianchi algebra, a gauge-covariant periodic link/plaquette substrate, and conditional shrinking-loop limits | Convergence of all routes to the same Riemann/Ricci/scalar curvature with the correct `R/4` coefficient |
| F7: one matter source | Localized variation of one matter action gives symmetric conserved `T` | Higgs/scalar controls, full symmetric-probe uniqueness, and the explicit Bianchi-to-source-conservation composition are exact | Derive the arbitrary local variation and matter Noether identity on the common reconstructed geometry |
| F8: one gravity action | One graph action converges to Einstein-Hilbert plus boundary and controlled corrections | Exact affine-action no-go, coframe determinant variation, Palatini-to-Einstein composition, incidence cancellation, nonlinear and joint two-field chart actions, spinor-null coframe and directed Levi-Civita/Ricci reconstruction, aggregate-weight coframe coverage, an exact independent pointwise-connection variation, its local periodic Euler coefficient and torsion-free Levi-Civita no-go, a group-valued link-curvature substrate, scalar, Euclidean finite-fiber, and full Krein-paired link/face Euler chains, plus a spacetime-derived six-component Lorentz-bivector representation preserved by the concrete null-edge `SL(2,C)` action and exactly equivalent to the matrix Lorentz Lie algebra with normalized trace pairing, the exact right-trivialized nonlinear Lorentz-
```

### 7. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [Current gate dashboard]

Score: `0.824`

```text
|
| G5: Dirac/Lichnerowicz bridge | The finite super-Dirac square and separation of spacetime/internal gradings are exact | Principal-symbol convergence and the continuum scalar-curvature coefficient are unproved |
| G6: stress-energy | Genuine coframe variations recover density, anisotropic pressure, and one flux component in controlled finite matter models | No arbitrary local coframe variation, full tensor identification, discrete Noether theorem, or conserved continuum source |
| G7: Einstein dynamics and constants | Exact affine-action no-go, determinant and Palatini bridges, incidence cancellation, nonlinear and joint two-field chart actions, null-edge coframe and directed Levi-Civita/Ricci reconstruction, bijective aggregate-weight coverage, exact independent pointwise-connection variation, its local periodic Euler coefficient and torsion-free Levi-Civita no-go, a gauge-covariant periodic link/plaquette substrate, scalar, Euclidean finite-fiber, and full Krein-paired link/face Euler chains, plus a spacetime-derived Lorentz-bivector representation preserved by the concrete null-edge `SL(2,C)` action and exactly equivalent to the matrix Lorentz Lie algebra with normalized trace pairing, the exact nonlinear right-logarithmic plaquette tangent, the scalar ordered holonomy action with exact four-family nonidentity local link Euler coefficients, and the complementary coframe-derived curvature-face coefficient `(1/2) epsilon^(cdab) star(e_c wedge e_d)` with exact divergence, proper-Lorentz covariance, and concrete action gauge invariance | Aggregate weights and frame synchronization are not yet derived from the operator sector, and the Gram metric is not identified with the operator metric; the corrected link/face action must supply metric dual-cell weighting of its Ho
```

### 8. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [6.1 Order/operator variational route (primary)]

Score: `0.823`

```text
rst-variation premise remains an
obligation, not an inserted conclusion.

`FiniteEinsteinHilbertActionResponse` now states the minimal nonlinear bulk
interface without pretending to derive it from intervals. For supplied local
volume and scalar curvature, the action
`sum_x volume(x) * (R(x) - 2 Lambda)` has separate volume-response and
curvature-response channels, plus the exact quadratic cross term under
simultaneous affine perturbations. A successful successor to the affine action
must derive these metric-dependent channels from the same graph geometry,
include the boundary response, and prove the curvature integration-by-parts
identity that yields the Einstein tensor.

The volume channel is no longer merely supplied.
`CoframeVolumeMetricVariation` proves from polynomial determinant calculus that
the multiplicative coframe path (e(t)=e(1+tX)) has

\[
  \delta\det e=(\det e)\operatorname{tr}X.
\]

For the corresponding inverse-metric variation
(h=-(Xg^{-1}+g^{-1}X^T)), exact matrix algebra gives
(\langle g,h\rangle=-2\operatorname{tr}X). Hence

\[
  \delta\det e=-\frac{\det e}{2}\langle g,h\rangle.
\]

For symmetric two-sided inverse metrics, the coframe-generator map reaches
every symmetric inverse-metric variation. This proves both the determinant
response and the local rank condition for supplied nondegenerate coframes.

`FinitePalatiniEinsteinHilbertVariation` then makes the curvature obligation
strictly narrower than an assumed Einstein derivative. Its premise is the
finite integrated Palatini identity

\[
  \sum_x v_x\,\delta R_x
   =\sum_x v_x\langle \operatorname{Ric}_x,h_x\rangle+B.
\]

Combining this with the determinant response yields, by checked algebra,

\[
  \delta S_{EH}
   =\sum_x v_x\left\langle
      \operatorname{Ric}_x-\frac{R_x}{2}g_x+\Lambda g_x,
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.749`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. Noise kernel in stochastic gravity and stress energy bitensor of quantum fields in curved spacetimes

Score: `0.732`
Zotero key: `5T5BQ6PT`
DOI: `10.1103/physrevd.63.104001`

### 3. The generalized Lichnerowicz formula and analysis of Dirac operators

Score: `0.731`
Zotero key: `BQJAG9TR`
arXiv: `hep-th/9503153`
URL: http://arxiv.org/abs/hep-th/9503153v1

Abstract:

Generalized Lichnerowicz formula for Dirac operator squares, with applications to gravity and Yang-Mills actions from Dirac operators.

### 4. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.728`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 5. Regge Calculus in Teleparallel Gravity

Score: `0.724`
Zotero key: `T5ZH4WC8`
arXiv: `gr-qc/0208036`
DOI: `10.1088/0264-9381/19/19/301`
URL: http://arxiv.org/abs/gr-qc/0208036

Abstract:

In the context of the teleparallel equivalent of general relativity, the Weitzenbock manifold is considered as the limit of a suitable sequence of discrete lattices composed of an increasing number of smaller an smaller simplices, where the interior of each simplex (Delaunay lattice) is assumed to be flat. The link lengths between any pair of vertices serve as independent variables, so that torsion turns out to be localized in the two dimensional hypersurfaces (dislocation triangle, or hinge) of the lattice. Assuming that a vector undergoes a dislocation in relation to its initial position as it is parallel transported along the perimeter of the dual lattice (Voronoi polygon), we obtain the discrete analogue of the teleparallel action, as well as the corresponding simplicial vacuum field equations.
