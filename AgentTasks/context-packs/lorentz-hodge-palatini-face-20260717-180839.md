# Aristotle semantic context pack

Generated: 2026-07-17T18:09:19
Query: `Lorentz Hodge star proper Lorentz exterior-square coframe wedge Palatini face bivector covariance`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` [2. The canonical gates]

Score: `0.809`

```text
-relative coframe and a compatible spin lift of the metric atlas | Exact coframe covariance, Lorentz transitions, central sign, and finite obstruction interfaces | Derive the atlas and identify the stable finite class with the continuum spin obstruction |
| F6: one curvature | Levi-Civita, holonomy, operator, and Dirac-square curvature agree | Exact finite connection/Bianchi algebra, a gauge-covariant periodic link/plaquette substrate, and conditional shrinking-loop limits | Convergence of all routes to the same Riemann/Ricci/scalar curvature with the correct `R/4` coefficient |
| F7: one matter source | Localized variation of one matter action gives symmetric conserved `T` | Higgs/scalar controls, full symmetric-probe uniqueness, and the explicit Bianchi-to-source-conservation composition are exact | Derive the arbitrary local variation and matter Noether identity on the common reconstructed geometry |
| F8: one gravity action | One graph action converges to Einstein-Hilbert plus boundary and controlled corrections | Exact affine-action no-go, coframe determinant variation, Palatini-to-Einstein composition, incidence cancellation, nonlinear and joint two-field chart actions, spinor-null coframe and directed Levi-Civita/Ricci reconstruction, aggregate-weight coframe coverage, an exact independent pointwise-connection variation, and a separate group-valued link-curvature substrate | Derive the aggregate weights and synchronized frame from the operator sector, identify the Gram and operator metrics, validate or replace the pointwise connection equation, construct the link/face Palatini pairing and its local divergence, then prove curvature-route equivalence, physical boundaries, `G_N`/`Lambda`, global descent, and variation-limit interchange |
| F9: physical recovery | Ne
```

### 2. `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` [2. The canonical gates]

Score: `0.808`

```text
rators reach every symmetric inverse-metric variation.

`FinitePalatiniEinsteinHilbertVariation` derives the Einstein coefficient from
that volume identity and the narrower finite Palatini premise
`sum volume delta R = sum volume <Ric,h> + boundary`. The result is the
volume-weighted pairing with `Ric-(R/2)g+Lambda g`, plus the displayed boundary
response. Nonzero local volumes cancel from the Euler-Lagrange equations.
`FinitePalatiniBoundaryCancellation` further proves exact incidence summation
by parts: if the local Palatini residual is an edge divergence, its total
vanishes on a closed finite carrier. A two-vertex unit-flux witness has local
residuals `-1` and `+1`, so this cancellation is nonvacuous.

`FinitePalatiniCoframeChartAction` supplies an actual nonlinear action control.
Its action is defined from `det(e(1+X))`, a fixed-connection Ricci contraction,
the cosmological term, and the matter pairing. Its derivative is calculated
from that formula, and stationarity at the chart origin is equivalent to the
pointwise finite Einstein equation. The control still supplies the coframe,
Ricci tensor, stress tensor, orientation, and common graph origin; it is not a
completed null-edge derivation.

`NullEdgeCoframeEinsteinBridge` removes four of those supplied inputs. Four
Weyl-spinor null edges at each site are soldered to future-null vectors and
assembled as the columns of a coframe. Nonzero determinant constructs the
inverse coframe, while the same edge data determine the mostly-minus Gram
metric, inverse metric, determinant volume, and scalar-curvature contraction.
Every diagonal Gram component is exactly zero. The canonical four-spinor
witness has determinant `1/2`, so the construction is nonvacuous. The
resulting nonlinear action is stationary exactly when the finit
```

### 3. `PhysicsSM/Draft/NullEdge/FinitePalatiniCoframeChartAction.lean` [chartTotalAction_hasPulledBackWeightedEinsteinFirstVariation]

Score: `0.797`

```text
appa coframe
    ricci inverseMetric stress direction cosmologicalConstant
  rw [normalizedResponse_eq_weightedLocalTotalMetricFirstVariation kappa
    (chartBaseVolume coframe) (chartVolumeResponse coframe direction)
    (chartBaseScalarCurvature ricci inverseMetric)
    (chartCurvatureResponse ricci inverseMetric direction) ricci metric stress
    (localInverseMetricVariation inverseMetric direction)
    cosmologicalConstant hKappa hVolume hPalatini] at hDerivative
  simpa using hDerivative

/-- **Explicit nonlinear Palatini action control.** Under symmetric
nondegenerate supplied geometry and nonzero oriented local volumes,
stationarity of the displayed coframe-chart action at the origin is equivalent
to the pointwise finite Einstein equation. -/
```

### 4. `PhysicsSM/Draft/NullEdge/FinitePalatiniCoframeChartAction.lean`

Score: `0.790`

```text
namespace PhysicsSM.Draft.NullEdge.FinitePalatiniCoframeChartAction

open scoped BigOperators
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open LocalEinsteinEquationVariation
open RelaxedCausalMetricVariationBridge
open LayerWeightMetricRankNoGo
open FiniteEinsteinHilbertActionResponse
open CoframeVolumeMetricVariation
open FinitePalatiniEinsteinHilbertVariation

variable {Site : Type*} [Fintype Site]

/-- Sitewise inverse-metric variation generated by local coframe matrices. -/
```

### 5. `PhysicsSM/Draft/NullEdge/RelativeScaleTetradBridge.lean` [weylLorentzTransition]

Score: `0.790`

```text
def weylLorentzTransition
    (r : Real) (L : Matrix ι ι Real) : Matrix ι ι Real :=
  r • L

/-- Row-coframe metric has Weyl weight two. -/
```

### 6. `PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` [conformalCoframe]

Score: `0.790`

```text
def conformalCoframe (omega : Real) (e : Coframe4) : Coframe4 :=
  omega • e

/-- Four-dimensional coframe volume has Weyl weight four. -/
```

### 7. `AgentTasks/aristotle-standalone/null-edge-einstein-action-variation-20260717/Null_Edge_GR_Foundations_Spine_2026-07-17.md` [Layer C: spin and matter]

Score: `0.790`

```text
### Layer C: spin and matter

The same coframe solders the Dirac principal symbol. The same metric and count
measure enter the matter action. Stress-energy is the localized metric or
coframe variation of that action, not an energy scalar or trace budget.

Spin structure is a global lift condition on the reconstructed oriented
Lorentz atlas. It is not supplied by a local `SL(2,C)` formula alone.
```

### 8. `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` [Layer C: spin and matter]

Score: `0.789`

```text
### Layer C: spin and matter

The same coframe solders the Dirac principal symbol. The same metric and count
measure enter the matter action. Stress-energy is the localized metric or
coframe variation of that action, not an energy scalar or trace budget.

Spin structure is a global lift condition on the reconstructed oriented
Lorentz atlas. It is not supplied by a local `SL(2,C)` formula alone.
```

## Scoped paper hits

### 1. Spinors and Twistors in Loop Gravity and Spin Foams

Score: `0.738`
Zotero key: `TCC2N3U6`
arXiv: `1201.2120`
URL: http://arxiv.org/abs/1201.2120

Abstract:

Spinorial tools have recently come back to fashion in loop gravity and spin foams. They provide an elegant tool relating the standard holonomy-flux algebra to the twisted geometry picture of the classical phase space on a fixed graph, and to twistors. In these lectures we provide a brief and technical introduction to the formalism and some of its applications.

### 2. The generalized Lichnerowicz formula and analysis of Dirac operators

Score: `0.738`
Zotero key: `BQJAG9TR`
arXiv: `hep-th/9503153`
URL: http://arxiv.org/abs/hep-th/9503153v1

Abstract:

Generalized Lichnerowicz formula for Dirac operator squares, with applications to gravity and Yang-Mills actions from Dirac operators.

### 3. Discrete Exterior Calculus

Score: `0.733`
Zotero key: `8XEX66QJ`
arXiv: `math/0508341`
URL: https://www.zotero.org/19894138/items/8XEX66QJ

### 4. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.733`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 5. Finite-Difference Approach to the Hodge Theory of Harmonic Forms

Score: `0.733`
Zotero key: `TSAQXS9N`
DOI: `10.2307/2373615`
URL: https://doi.org/10.2307/2373615
