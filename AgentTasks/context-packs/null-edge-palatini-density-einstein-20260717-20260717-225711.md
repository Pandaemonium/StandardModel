# Aristotle semantic context pack

Generated: 2026-07-17T22:57:33
Query: `four-dimensional tetrad Palatini epsilon e e curvature equals minus determinant coframe times inverse-coframe scalar curvature exact normalization`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/LorentzCoframePalatiniFace.lean` [spacetimeAlternatingSymbol]

Score: `0.853`

```text
noncomputable def spacetimeAlternatingSymbol (a b c d : Fin 4) : Real :=
  (((b : Real) - (a : Real)) * ((c : Real) - (a : Real)) *
      ((d : Real) - (a : Real)) * ((c : Real) - (b : Real)) *
      ((d : Real) - (b : Real)) * ((d : Real) - (c : Real))) / 12

/-- Coefficient of curvature on the ordered plaquette `(a,b)` in the
tetradic Palatini four-form.  The coframe bivector comes from the complementary
directions selected by the spacetime alternating symbol. -/
```

### 2. `AgentTasks/model-calls/gemini/2026-07-17-143854-null-edge-periodic-palatini-no-go-audit-20260717.md` [Null-edge coframes and the finite Einstein-action bridge]

Score: `0.834`

```text
Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove,
    Matrix.submatrix_apply, Matrix.of_apply]
  all_goals norm_num

/-- The canonical four-spinor decoration is a nondegenerate null-edge frame
at every site. -/
def canonicalFrame (Site : Type*) : NondegenerateNullEdgeFrame Site where
  edges := fun _ => canonicalNullEdges
  det_ne_zero site := by
    rw [nullEdgeCoframe, canonicalNullEdgeCoframe_eq, canonicalCoframe_det]
    norm_num

/-! ## Null-edge-derived Einstein-action endpoint -/

variable {Site : Type*} [Fintype Site]

/-- The Palatini chart action with coframe, inverse metric, metric, and volume
all derived from one nondegenerate null-edge decoration. -/
def nullEdgeChartTotalAction
    (kappa : Real) (frame : NondegenerateNullEdgeFrame Site)
    (ricci stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) :
    LocalTensor (Site := Site) -> Real :=
  chartTotalAction kappa (nullEdgeCoframe frame.edges) ricci
    (nullEdgeInverseMetric frame) stress cosmologicalConstant

/-- Scalar curvature obtained by contracting supplied Ricci curvature with
the inverse metric reconstructed from the null edges. -/
def nullEdgeScalarCurvature
    (frame : NondegenerateNullEdgeFrame Site)
    (ricci : LocalTensor (Site := Site)) : Site -> Real :=
  chartBaseScalarCurvature ricci (nullEdgeInverseMetric frame)

omit [Fintype Site] in
/-- The explicit canonical decoration has positive oriented volume `1 / 2` at
every site. -/
theorem canonicalFrame_volume (site : Site) :
    chartBaseVolume
        (nullEdgeCoframe (canonicalFrame Site).edges) site = (1 / 2 : Real) := by
  simp [chartBaseVolume, coframeVolume, canonicalFrame, nullEdgeCoframe,
    canonicalNullEdgeCoframe_eq, canonicalCoframe_det]

/-- **Null-edge coframe Einstein-action theorem.**
```

### 3. `docs/NULLSTRAND.md` [Gravity connection guardrails]

Score: `0.829`

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

### 4. `PhysicsSM/Draft/NullEdge/LambdaGravityCosmologyBridge.lean` [gravityUnificationStmt]

Score: `0.828`

```text
nHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
    ((TeleparallelSoldering.curvatureLoop = 1 ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
        (∀ g : TeleparallelSoldering.M,
          g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
        (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
          TeleparallelSoldering.nonmetricity TeleparallelSoldering.g
```

### 5. `PhysicsSM/Draft/NullEdge/GoalIVReconciliationCapstone.lean` [source_equation_route_capstone]

Score: `0.827`

```text
HilbertTerm.D E) =
          Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dkin) + EinsteinHilbertTerm.Rfin E) ∧
      (∀ E : ℚ, EinsteinHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
    ((TeleparallelSoldering.curvatureLoop = 1 ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
        (∀ g : TeleparallelSoldering.M,
          g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
        (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gPu
```

### 6. `PhysicsSM/Draft/NullEdge/FinitePalatiniEinsteinHilbertVariation.lean` [metricVariationPairing_finiteEinsteinLHS]

Score: `0.827`

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

### 7. `PhysicsSM/Draft/NullEdge/GravityUnificationCapstone.lean` [gravity_unification_capstone]

Score: `0.823`

```text
.D 2 0 0 0 ^ 4).trace = 60 ∧
        (60 : ℚ) ≠ 0) ∧
      (SpectralActionAvatar.D 3 1 3 5 ^ 2).trace ≠ (SpectralActionAvatar.D 2 1 3 5 ^ 2).trace ∧
      (SpectralActionAvatar.D 2 7 8 9 ^ 2).trace = (SpectralActionAvatar.D 2 1 3 5 ^ 2).trace ∧
      (SpectralActionAvatar.D 2 1 3 6 ^ 4).trace ≠ (SpectralActionAvatar.D 2 1 3 5 ^ 4).trace) ∧
    -- (10) order-2 curvature / Einstein–Hilbert avatar
    ((∀ E : ℚ, Matrix.trace (EinsteinHilbertTerm.D E * EinsteinHilbertTerm.D E) =
          Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dkin) + EinsteinHilbertTerm.Rfin E) ∧
      (∀ E : ℚ, EinsteinHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    -- (11) teleparallel E-slot torsion/nonmetricity split
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion Tele
```

### 8. `PhysicsSM/Draft/NullEdge/GRFoundations.lean`

Score: `0.822`

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

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.743`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. Higher gauge theory

Score: `0.737`
DOI: `10.1090/conm/431/08264`
URL: https://doi.org/10.1090/conm/431/08264

### 3. The generalized Lichnerowicz formula and analysis of Dirac operators

Score: `0.736`
Zotero key: `BQJAG9TR`
arXiv: `hep-th/9503153`
URL: http://arxiv.org/abs/hep-th/9503153v1

Abstract:

Generalized Lichnerowicz formula for Dirac operator squares, with applications to gravity and Yang-Mills actions from Dirac operators.

### 4. A New Spin Foam Model for 4d Gravity

Score: `0.736`
Zotero key: `K8QAB5UD`
arXiv: `0708.1595`
DOI: `10.1088/0264-9381/25/12/125018`
URL: http://arxiv.org/abs/0708.1595

Abstract:

Spin-foam model for four-dimensional gravity from constrained Plebanski BF theory; source guardrail for distinguishing single-bivector simplicity from full spin-foam cross-simplicity constraints.

### 5. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.734`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.
