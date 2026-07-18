import PhysicsSM.Draft.NullEdge.NullEdgeSpinorSolderingAristotle
import PhysicsSM.Draft.NullEdge.FinitePalatiniCoframeChartAction

/-!
# Null-edge coframes and the finite Einstein-action bridge

This module removes the coframe, metric, inverse metric, and volume from the
list of independently supplied inputs in the finite Palatini action theorem.
At each carrier site, four Weyl-spinor null edges are soldered to four
future-null Minkowski vectors and assembled as the columns of a real coframe.
When that coframe has nonzero determinant, its nonsingular matrix inverse
constructs the inverse metric.  Consequently:

* every coframe column is future-null;
* the induced Gram metric has zero diagonal in the null-edge basis;
* the metric, inverse metric, and oriented volume are all functions of the
  same four null edges;
* stationarity of the displayed nonlinear Palatini chart action is equivalent
  to the sitewise finite Einstein equation with this derived geometry.

The explicit canonical family proves nonvacuity: four concrete spinors give a
positively oriented coframe of determinant `1 / 2`.

This is a decorated-null-edge reconstruction theorem, not a bare-graph
reconstruction.  The selection of four independent spinors at each site,
Ricci curvature, stress, and the continuum/refinement interpretation remain
separate obligations.  Moreover, the action theorem uses unrestricted
coframe-generator variations around the null-edge base.  A guarded no-go below
shows that variations preserving four null columns have zero Gram diagonal and
cannot by themselves reach all ten symmetric metric components.  A gauge or
Bianchi completion, or a larger aggregate variation space, is still required
before calling the stationarity condition a null-edge-only variation.
Signature is mostly minus `(+,-,-,-)`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge

open Matrix
open NullEdgeSpinorSoldering
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open LocalEinsteinEquationVariation
open RelaxedCausalMetricVariationBridge
open CoframeVolumeMetricVariation
open FinitePalatiniCoframeChartAction

/-- Four selected Weyl-spinor null edges at every carrier site. -/
abbrev NullEdgeDecoration (Site : Type*) := Site -> Fin 4 -> Spinor

/-- Assemble four soldered null vectors as the columns of a real coframe. -/
def nullEdgeCoframeAt (edges : Fin 4 -> Spinor) :
    RealCoframe (I := Fin 4) :=
  fun mu a => nullEdgeVector (edges a) mu

/-- Sitewise null-edge coframe. -/
def nullEdgeCoframe {Site : Type*} (edges : NullEdgeDecoration Site) :
    Site -> RealCoframe (I := Fin 4) :=
  fun site => nullEdgeCoframeAt (edges site)

/-- Mostly-minus Minkowski metric in the soldered vector coordinates. -/
def minkowskiMetric : Matrix (Fin 4) (Fin 4) Real :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, -1]

/-- The mostly-minus metric is symmetric. -/
theorem minkowskiMetric_isSymm : minkowskiMetric.IsSymm := by
  unfold Matrix.IsSymm
  ext i j
  fin_cases i <;> fin_cases j <;> simp [minkowskiMetric]

/-- The mostly-minus metric is its own matrix inverse. -/
theorem minkowskiMetric_mul_self : minkowskiMetric * minkowskiMetric = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [minkowskiMetric, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The determinant records one timelike and three spacelike directions. -/
theorem minkowskiMetric_det : minkowskiMetric.det = (-1 : Real) := by
  simp (maxSteps := 8000000) [minkowskiMetric,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove,
    Matrix.submatrix_apply, Matrix.of_apply]

/-- Every column of the assembled coframe is a null vector. -/
theorem nullEdgeCoframeAt_column_null
    (edges : Fin 4 -> Spinor) (a : Fin 4) :
    minkowskiSq (fun mu => nullEdgeCoframeAt edges mu a) = 0 := by
  simpa [nullEdgeCoframeAt] using nullEdgeVector_minkowskiSq (edges a)

/-- Every column is future-directed, and a column has zero energy exactly
when its underlying spinor vanishes. -/
theorem nullEdgeCoframeAt_column_future
    (edges : Fin 4 -> Spinor) (a : Fin 4) :
    0 <= nullEdgeCoframeAt edges 0 a /\
      (nullEdgeCoframeAt edges 0 a = 0 <-> edges a = 0) := by
  simpa [nullEdgeCoframeAt] using nullEdgeVector_time_nonneg (edges a)

/-- Covariant Gram metric derived from one site's four null edges. -/
def nullEdgeMetricAt (edges : Fin 4 -> Spinor) : Tensor (I := Fin 4) :=
  inducedCovariantMetric minkowskiMetric (nullEdgeCoframeAt edges)

/-- Sitewise covariant metric derived from the same null-edge decoration. -/
def nullEdgeMetric {Site : Type*} (edges : NullEdgeDecoration Site) :
    LocalTensor (Site := Site) :=
  fun site => nullEdgeMetricAt (edges site)

/-- In the edge-labelled basis, every diagonal Gram entry vanishes because
the corresponding coframe column is null. -/
theorem nullEdgeMetricAt_diagonal_zero
    (edges : Fin 4 -> Spinor) (a : Fin 4) :
    nullEdgeMetricAt edges a a = 0 := by
  have hNull := nullEdgeCoframeAt_column_null edges a
  simpa [nullEdgeMetricAt, inducedCovariantMetric, minkowskiMetric,
    nullEdgeCoframeAt, minkowskiSq, Matrix.mul_apply, Fin.sum_univ_succ,
    pow_two, sub_eq_add_neg, add_assoc] using hNull

/-- The determinant of the null-edge Gram metric is minus the square of the
null-edge coframe determinant. -/
theorem nullEdgeMetricAt_det (edges : Fin 4 -> Spinor) :
    (nullEdgeMetricAt edges).det = -(nullEdgeCoframeAt edges).det ^ 2 := by
  unfold nullEdgeMetricAt inducedCovariantMetric
  rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose,
    minkowskiMetric_det]
  ring

/-- A tangent to the space of null Gram matrices has zero diagonal. -/
def HasZeroDiagonal (variation : Tensor (I := Fin 4)) : Prop :=
  forall direction, variation direction direction = 0

/-- Any differentiable path whose Gram diagonal stays null has a
zero-diagonal tangent. -/
theorem nullGramPath_tangent_hasZeroDiagonal
    (metricPath : Real -> Tensor (I := Fin 4))
    (variation : Tensor (I := Fin 4))
    (hNull : forall t direction,
      metricPath t direction direction = 0)
    (hDerivative : forall direction,
      HasDerivAt (fun t => metricPath t direction direction)
        (variation direction direction) 0) :
    HasZeroDiagonal variation := by
  intro direction
  have hFunction :
      (fun t : Real => metricPath t direction direction) =
        (fun _ : Real => 0) := by
    funext t
    exact hNull t direction
  have hVariation := hDerivative direction
  rw [hFunction] at hVariation
  exact hVariation.unique (hasDerivAt_const 0 0)

/-- **Null-column tangent no-go.** A parameter derivative whose image always
has zero diagonal cannot reach every symmetric `4 x 4` metric variation. -/
theorem zeroDiagonalMetricDerivative_not_full
    {Parameter : Type*} [AddCommGroup Parameter] [Module Real Parameter]
    (metricDerivative :
      Parameter →ₗ[Real] Tensor (I := Fin 4))
    (hDiagonal : forall parameter,
      HasZeroDiagonal (metricDerivative parameter)) :
    Not (IsFullSymmetricMetricDerivative metricDerivative) := by
  intro hFull
  have hOne : (1 : Tensor (I := Fin 4)).IsSymm := by
    unfold Matrix.IsSymm
    simp
  obtain ⟨parameter, hParameter⟩ := hFull.2 1 hOne
  have hZero := hDiagonal parameter 0
  rw [hParameter] at hZero
  norm_num at hZero

/-- Diagonal part of a metric variation. -/
def diagonalPart (variation : Tensor (I := Fin 4)) : Tensor (I := Fin 4) :=
  Matrix.diagonal (fun direction => variation direction direction)

/-- Zero-diagonal part of a metric variation. -/
def zeroDiagonalPart
    (variation : Tensor (I := Fin 4)) : Tensor (I := Fin 4) :=
  variation - diagonalPart variation

/-- The diagonal part is symmetric. -/
theorem diagonalPart_isSymm (variation : Tensor (I := Fin 4)) :
    (diagonalPart variation).IsSymm := by
  unfold diagonalPart Matrix.IsSymm
  exact Matrix.diagonal_transpose _

/-- Removing the diagonal preserves symmetry. -/
theorem zeroDiagonalPart_isSymm
    (variation : Tensor (I := Fin 4)) (hVariation : variation.IsSymm) :
    (zeroDiagonalPart variation).IsSymm := by
  exact hVariation.sub (diagonalPart_isSymm variation)

/-- The off-diagonal projection has zero diagonal. -/
theorem zeroDiagonalPart_hasZeroDiagonal
    (variation : Tensor (I := Fin 4)) :
    HasZeroDiagonal (zeroDiagonalPart variation) := by
  intro direction
  simp [zeroDiagonalPart, diagonalPart]

/-- Every metric variation is the sum of its zero-diagonal and diagonal
parts. -/
theorem zeroDiagonalPart_add_diagonalPart
    (variation : Tensor (I := Fin 4)) :
    zeroDiagonalPart variation + diagonalPart variation = variation := by
  unfold zeroDiagonalPart
  abel

/-- **Six-plus-four completion theorem.** If one parameter derivative reaches
every symmetric zero-diagonal variation and every diagonal variation, then it
reaches every symmetric metric variation.  This is the exact algebraic target
for completing null-column variations by gauge or aggregate directions. -/
theorem full_of_zeroDiagonal_and_diagonal_reach
    {Parameter : Type*} [AddCommGroup Parameter] [Module Real Parameter]
    (metricDerivative : Parameter →ₗ[Real] Tensor (I := Fin 4))
    (hSymmetric : forall parameter,
      (metricDerivative parameter).IsSymm)
    (hZeroDiagonalReach : forall variation,
      variation.IsSymm -> HasZeroDiagonal variation ->
        ∃ parameter, metricDerivative parameter = variation)
    (hDiagonalReach : forall diagonal : Fin 4 -> Real,
      ∃ parameter,
        metricDerivative parameter = Matrix.diagonal diagonal) :
    IsFullSymmetricMetricDerivative metricDerivative := by
  constructor
  · exact hSymmetric
  · intro variation hVariation
    obtain ⟨offParameter, hOffParameter⟩ :=
      hZeroDiagonalReach (zeroDiagonalPart variation)
        (zeroDiagonalPart_isSymm variation hVariation)
        (zeroDiagonalPart_hasZeroDiagonal variation)
    obtain ⟨diagonalParameter, hDiagonalParameter⟩ :=
      hDiagonalReach (fun direction => variation direction direction)
    refine ⟨offParameter + diagonalParameter, ?_⟩
    rw [map_add, hOffParameter, hDiagonalParameter]
    exact zeroDiagonalPart_add_diagonalPart variation

/-- A nondegenerate decorated null-edge frame.  Nondegeneracy is exactly the
requirement that the four soldered null directions span four dimensions. -/
structure NondegenerateNullEdgeFrame (Site : Type*) where
  edges : NullEdgeDecoration Site
  det_ne_zero : forall site, (nullEdgeCoframe edges site).det ≠ 0

/-- The inverse coframe is constructed from the null-edge coframe rather than
supplied as independent geometry. -/
def inverseCoframe {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    RealCoframe (I := Fin 4) :=
  (nullEdgeCoframe frame.edges site)⁻¹

/-- The constructed inverse coframe is a left inverse. -/
theorem inverseCoframe_mul {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    inverseCoframe frame site * nullEdgeCoframe frame.edges site = 1 := by
  exact Matrix.nonsing_inv_mul _
    (isUnit_iff_ne_zero.mpr (frame.det_ne_zero site))

/-- The constructed inverse coframe is a right inverse. -/
theorem mul_inverseCoframe {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    nullEdgeCoframe frame.edges site * inverseCoframe frame site = 1 := by
  exact Matrix.mul_nonsing_inv _
    (isUnit_iff_ne_zero.mpr (frame.det_ne_zero site))

/-- Inverse metric derived from the inverse of the null-edge coframe. -/
def nullEdgeInverseMetric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) :
    LocalTensor (Site := Site) :=
  fun site => inducedCovariantMetric minkowskiMetric
    (inverseCoframe frame site).transpose

/-- The null-edge Gram metric is symmetric. -/
theorem nullEdgeMetric_symmetric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) :
    LocalSymmetric (nullEdgeMetric frame.edges) := by
  intro site
  exact inducedCovariantMetric_isSymm _ _ minkowskiMetric_isSymm

/-- The derived inverse metric is symmetric. -/
theorem nullEdgeInverseMetric_symmetric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) :
    LocalSymmetric (nullEdgeInverseMetric frame) := by
  intro site
  exact inducedCovariantMetric_isSymm _ _ minkowskiMetric_isSymm

/-- The metric reconstructed from a nondegenerate null-edge frame is itself
nondegenerate. -/
theorem nullEdgeMetric_det_ne_zero {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    (nullEdgeMetric frame.edges site).det ≠ 0 := by
  have hCoframe : (nullEdgeCoframeAt (frame.edges site)).det ≠ 0 := by
    simpa [nullEdgeCoframe] using frame.det_ne_zero site
  change (nullEdgeMetricAt (frame.edges site)).det ≠ 0
  rw [nullEdgeMetricAt_det]
  exact neg_ne_zero.mpr (pow_ne_zero 2 hCoframe)

/-- The metric built from the inverse null-edge coframe is a left inverse of
the null-edge Gram metric. -/
theorem nullEdgeInverseMetric_mul_metric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    nullEdgeInverseMetric frame site * nullEdgeMetric frame.edges site = 1 := by
  let E := nullEdgeCoframe frame.edges site
  let F := inverseCoframe frame site
  have hFE : F * E = 1 := inverseCoframe_mul frame site
  have hEF : E * F = 1 := mul_inverseCoframe frame site
  have hTranspose : F.transpose * E.transpose = 1 := by
    rw [<- Matrix.transpose_mul, hEF, Matrix.transpose_one]
  change (F * minkowskiMetric * F.transpose) *
      (E.transpose * minkowskiMetric * E) = 1
  calc
    (F * minkowskiMetric * F.transpose) *
        (E.transpose * minkowskiMetric * E) =
        F * minkowskiMetric * (F.transpose * E.transpose) *
          minkowskiMetric * E := by noncomm_ring
    _ = F * minkowskiMetric * 1 * minkowskiMetric * E := by rw [hTranspose]
    _ = F * (minkowskiMetric * minkowskiMetric) * E := by noncomm_ring
    _ = F * E := by rw [minkowskiMetric_mul_self, Matrix.mul_one]
    _ = 1 := hFE

/-- The null-edge Gram metric is also a left inverse of its derived inverse
metric. -/
theorem nullEdgeMetric_mul_inverseMetric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    nullEdgeMetric frame.edges site * nullEdgeInverseMetric frame site = 1 := by
  let E := nullEdgeCoframe frame.edges site
  let F := inverseCoframe frame site
  have hFE : F * E = 1 := inverseCoframe_mul frame site
  have hEF : E * F = 1 := mul_inverseCoframe frame site
  have hTranspose : E.transpose * F.transpose = 1 := by
    rw [<- Matrix.transpose_mul, hFE, Matrix.transpose_one]
  change (E.transpose * minkowskiMetric * E) *
      (F * minkowskiMetric * F.transpose) = 1
  calc
    (E.transpose * minkowskiMetric * E) *
        (F * minkowskiMetric * F.transpose) =
        E.transpose * minkowskiMetric * (E * F) *
          minkowskiMetric * F.transpose := by noncomm_ring
    _ = E.transpose * minkowskiMetric * 1 * minkowskiMetric * F.transpose := by
      rw [hEF]
    _ = E.transpose * (minkowskiMetric * minkowskiMetric) * F.transpose := by
      noncomm_ring
    _ = E.transpose * F.transpose := by
      rw [minkowskiMetric_mul_self, Matrix.mul_one]
    _ = 1 := hTranspose

/-! ## An explicit nondegenerate four-null-edge witness -/

/-- Four concrete future-null spinors.  The first two are the opposite
`z`-directions, followed by the positive `x`- and `y`-directions. -/
def canonicalNullEdges : Fin 4 -> Spinor :=
  ![![0, 1], ![1, 0], ![1, 1], ![1, Complex.I]]

/-- The exact coframe soldered from `canonicalNullEdges`. -/
def canonicalCoframe : RealCoframe (I := Fin 4) :=
  !![1 / 2, 1 / 2, 1, 1;
     0, 0, 1, 0;
     0, 0, 0, 1;
     -1 / 2, 1 / 2, 0, 0]

/-- Soldering the four canonical spinors gives the displayed coframe. -/
theorem canonicalNullEdgeCoframe_eq :
    nullEdgeCoframeAt canonicalNullEdges = canonicalCoframe := by
  ext mu a
  fin_cases mu <;> fin_cases a <;>
    norm_num [nullEdgeCoframeAt, canonicalNullEdges, canonicalCoframe,
      nullEdgeVector, vecOfHerm, rankOne]

/-- The canonical null-edge coframe has positive oriented volume `1 / 2`. -/
theorem canonicalCoframe_det : canonicalCoframe.det = (1 / 2 : Real) := by
  simp (maxSteps := 8000000) [canonicalCoframe,
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

/-- **Null-edge coframe Einstein-action theorem.**  Once four independent
spinor null edges are selected at every site, the coframe, Gram metric,
inverse metric, scalar curvature contraction, and volume in the action are
derived from those edges.  Stationarity of the explicit nonlinear action is
equivalent to the pointwise finite Einstein equation under unrestricted local
coframe-generator variations.  The theorem above shows that this full
variation space is larger than the null-column-preserving tangent space. -/
theorem nullEdgeChartTotalAction_stationary_iff_localFiniteEinsteinEquation
    (kappa : Real) (frame : NondegenerateNullEdgeFrame Site)
    (ricci stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hRicci : LocalSymmetric ricci)
    (hStress : LocalSymmetric stress)
    (hKappa : Not (kappa = 0)) :
    ParameterStationary
        (nullEdgeChartTotalAction kappa frame ricci stress
          cosmologicalConstant) 0 <->
      LocalFiniteEinsteinEquation kappa ricci
        (nullEdgeScalarCurvature frame ricci)
        (nullEdgeMetric frame.edges) cosmologicalConstant stress := by
  apply chartTotalAction_stationary_iff_localFiniteEinsteinEquation
    kappa (nullEdgeCoframe frame.edges) ricci (nullEdgeMetric frame.edges)
    (nullEdgeInverseMetric frame) stress cosmologicalConstant
  · intro site
    simpa [chartBaseVolume, coframeVolume] using frame.det_ne_zero site
  · exact hRicci
  · exact nullEdgeMetric_symmetric frame
  · exact nullEdgeInverseMetric_symmetric frame
  · exact hStress
  · exact nullEdgeInverseMetric_mul_metric frame
  · exact nullEdgeMetric_mul_inverseMetric frame
  · exact hKappa

/-- **Explicit nonvacuity corollary.**  The four displayed canonical spinors
provide a concrete null-edge action whose stationary points are exactly the
finite Einstein solutions for the resulting null-tetrad metric. -/
theorem canonicalNullEdgeChartTotalAction_stationary_iff
    (kappa : Real) (ricci stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hRicci : LocalSymmetric ricci)
    (hStress : LocalSymmetric stress)
    (hKappa : Not (kappa = 0)) :
    ParameterStationary
        (nullEdgeChartTotalAction kappa (canonicalFrame Site) ricci stress
          cosmologicalConstant) 0 <->
      LocalFiniteEinsteinEquation kappa ricci
        (nullEdgeScalarCurvature (canonicalFrame Site) ricci)
        (nullEdgeMetric (canonicalFrame Site).edges)
        cosmologicalConstant stress :=
  nullEdgeChartTotalAction_stationary_iff_localFiniteEinsteinEquation
    kappa (canonicalFrame Site) ricci stress cosmologicalConstant
      hRicci hStress hKappa

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.nullEdgeMetricAt_diagonal_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgeMetricAt_diagonal_zero

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.zeroDiagonalMetricDerivative_not_full' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zeroDiagonalMetricDerivative_not_full

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.full_of_zeroDiagonal_and_diagonal_reach' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms full_of_zeroDiagonal_and_diagonal_reach

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.nullEdgeInverseMetric_mul_metric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgeInverseMetric_mul_metric

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.canonicalCoframe_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalCoframe_det

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.canonicalNullEdgeChartTotalAction_stationary_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalNullEdgeChartTotalAction_stationary_iff

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.nullEdgeChartTotalAction_stationary_iff_localFiniteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgeChartTotalAction_stationary_iff_localFiniteEinsteinEquation

end PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge
