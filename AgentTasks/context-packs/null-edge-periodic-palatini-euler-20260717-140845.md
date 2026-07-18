# Aristotle semantic context pack

Generated: 2026-07-17T14:08:53
Query: `periodic finite Palatini independent connection Euler coefficient densitized inverse metric backward difference Levi-Civita stationarity`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/NullEdgePalatiniJointAction.lean` [jointConnectionStationary_iff_eulerLagrange]

Score: `0.871`

```text
theorem jointConnectionStationary_iff_eulerLagrange
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (connection : DirectedConnection Site)
    (hKappa : Not (kappa = 0)) :
    JointConnectionStationary kappa chart stress cosmologicalConstant
        connection <->
      ConnectionEulerLagrange chart.target
        (chartBaseVolume (nullEdgeCoframe chart.edges))
        (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame)
        connection := by
  constructor
  · intro hStationary variation
    have hUnique :=
      (nullEdgePalatiniJointAction_connectionDirectionalDerivative kappa chart
        stress cosmologicalConstant connection variation).unique
        (hStationary variation)
    have hScale : (1 / (2 * kappa) : Real) ≠ 0 := by
      exact one_div_ne_zero (mul_ne_zero (by norm_num) hKappa)
    exact (mul_eq_zero.mp hUnique).resolve_left hScale
  · intro hEuler variation
    simpa [hEuler variation] using
      nullEdgePalatiniJointAction_connectionDirectionalDerivative kappa chart
        stress cosmologicalConstant connection variation

/-! ## Two-field endpoint -/

/-- Both partial stationarity equations of the joint finite Palatini action at
the null-edge Levi-Civita base connection. -/
```

### 2. `PhysicsSM/Draft/NullEdge/FiniteDirectedPalatiniConnectionVariation.lean` [zeroConnection_stationary_periodic]

Score: `0.871`

```text
theorem zeroConnection_stationary_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Real) (inverseMetric : Matrix (Fin 4) (Fin 4) Real) :
    ConnectionStationary (periodicTarget shift) (fun _ => volume)
      (fun _ => inverseMetric) 0 := by
  exact (connectionStationary_iff_eulerLagrange
    (periodicTarget shift) (fun _ => volume) (fun _ => inverseMetric) 0).2
      (zeroConnection_eulerLagrange_periodic shift volume inverseMetric)

/-- The Levi-Civita connection of the constant canonical null-edge chart is
stationary on every periodic carrier with constant Palatini coefficients. -/
```

### 3. `PhysicsSM/Draft/NullEdge/FiniteDirectedPalatiniConnectionVariation.lean` [ConnectionEulerLagrange]

Score: `0.870`

```text
def ConnectionEulerLagrange
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) : Prop :=
  forall variation : DirectedConnection Site,
    directedPalatiniConnectionResponse target volume inverseMetric connection
      variation = 0

/-- Stationarity is equivalent to vanishing of the derived finite connection
Euler-Lagrange functional. -/
```

### 4. `PhysicsSM/Draft/NullEdge/NullEdgePalatiniJointAction.lean` [JointPalatiniStationary]

Score: `0.859`

```text
def JointPalatiniStationary
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) : Prop :=
  JointMetricStationary kappa chart stress cosmologicalConstant
      (nullEdgeChristoffel chart) /\
    JointConnectionStationary kappa chart stress cosmologicalConstant
      (nullEdgeChristoffel chart)

/-- **Joint finite null-edge Palatini endpoint.**  The two partial
Euler-Lagrange equations are exactly the finite Einstein equation and the
independent finite connection equation. -/
```

### 5. `PhysicsSM/Draft/NullEdge/FiniteDirectedPalatiniConnectionVariation.lean` [zeroConnection_eulerLagrange_periodic]

Score: `0.854`

```text
theorem zeroConnection_eulerLagrange_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Real) (inverseMetric : Matrix (Fin 4) (Fin 4) Real) :
    ConnectionEulerLagrange (periodicTarget shift) (fun _ => volume)
      (fun _ => inverseMetric) 0 := by
  intro variation
  unfold directedPalatiniConnectionResponse
  rw [← Finset.mul_sum]
  rw [sum_metricVariationPairing_left]
  have hRicciSum :
      Finset.sum Finset.univ (fun site =>
        connectionRawRicciFirstVariation (periodicTarget shift) 0 variation
          site) = 0 := by
    ext lower right
    rw [Matrix.sum_apply]
    simp only [Matrix.zero_apply]
    exact sum_connectionRawRicciFirstVariation_zero_periodic shift variation
      lower right
  rw [hRicciSum]
  simp [metricVariationPairing]

/-- The zero connection is therefore an actual stationary point of the finite
Palatini connection action on a periodic constant background. -/
```

### 6. `PhysicsSM/Draft/NullEdge/FiniteDirectedPalatiniConnectionVariation.lean` [connectionStationary_iff_eulerLagrange]

Score: `0.850`

```text
theorem connectionStationary_iff_eulerLagrange
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    ConnectionStationary target volume inverseMetric connection <->
      ConnectionEulerLagrange target volume inverseMetric connection := by
  constructor
  · intro hStationary variation
    exact
      (directedPalatiniConnectionAction_directionalDerivative target volume
        inverseMetric connection variation).unique (hStationary variation)
  · intro hEuler variation
    simpa [hEuler variation] using
      directedPalatiniConnectionAction_directionalDerivative target volume
        inverseMetric connection variation

/-! ## Closed periodic flat control -/

/-- Target map induced by four invertible shifts of a finite carrier. -/
```

### 7. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [12.3 Selected Einstein dynamics]

Score: `0.848`

```text
ic-active and frame-gauge lemmas separate physical inverse-metric response
from metric-invisible frame motion. What remains open is no longer finite
coverage, but deriving the aggregate-weight field and its gauge law from the
causal/operator dynamics.

The joint successor also closes the finite two-field bookkeeping clause.
`jointPalatiniStationary_iff_fieldEquations` proves that the two partial
stationarity equations of one action are the finite Einstein equation and the
explicit independent-connection Euler-Lagrange equation. The open connection
problem is now sharply narrower: prove that this finite equation selects the
metric-compatible null-edge Levi-Civita connection, modulo any genuine finite
projective or boundary freedom, and express the residual as the local
Palatini divergence used by the boundary-cancellation theorem.

The thermodynamic route may independently recover the same equation under the
all-local-null-horizon assumptions displayed in Section 6.2. The teleparallel
route may reformulate the same action through the TEGR torsion scalar plus its
required boundary term. Agreement would be a strong control; combining their
finite avatars does not reduce their separate continuum debts.
```

### 8. `PhysicsSM/Draft/NullEdge/FiniteDirectedPalatiniConnectionVariation.lean` [ConnectionStationary]

Score: `0.847`

```text
def ConnectionStationary
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) : Prop :=
  forall variation : DirectedConnection Site,
    HasDerivAt
      (fun t : Real =>
        directedPalatiniConnectionAction target volume inverseMetric
          (connectionLine connection variation t)) 0 0

/-- Vanishing of the explicit connection Euler-Lagrange functional. -/
```

## Scoped paper hits

### 1. Discrete Exterior Calculus

Score: `0.745`
Zotero key: `8XEX66QJ`
arXiv: `math/0508341`
URL: https://www.zotero.org/19894138/items/8XEX66QJ

### 2. The generalized Lichnerowicz formula and analysis of Dirac operators

Score: `0.741`
Zotero key: `BQJAG9TR`
arXiv: `hep-th/9503153`
URL: http://arxiv.org/abs/hep-th/9503153v1

Abstract:

Generalized Lichnerowicz formula for Dirac operator squares, with applications to gravity and Yang-Mills actions from Dirac operators.

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.741`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 4. Finite element exterior calculus: from Hodge theory to numerical stability

Score: `0.732`
Zotero key: `8JFSI9CS`
DOI: `10.1090/s0273-0979-10-01278-4`
URL: https://doi.org/10.1090/s0273-0979-10-01278-4

### 5. Finite-Difference Approach to the Hodge Theory of Harmonic Forms

Score: `0.729`
Zotero key: `TSAQXS9N`
DOI: `10.2307/2373615`
URL: https://doi.org/10.2307/2373615
