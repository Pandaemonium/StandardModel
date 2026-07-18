import PhysicsSM.Draft.NullEdge.WeightedIntervalActionVariation
import PhysicsSM.Draft.NullEdge.LayerWeightMetricRankNoGo
import PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator

/-!
# Event-local interval action and operator-metric variation

`LayerWeightMetricRankNoGo` proves that a fixed global list of interval-layer
coefficients cannot provide unrestricted local metric variation on a growing
finite carrier. This module implements the first constructive repair: every
event receives its own finite row of layer coefficients.

The same coefficient field defines both

1. a graph-native interval-count action, by applying the localized causal
   operator to the constant field and summing over events; and
2. a symmetric metric response, through the corrected principal-symbol
   pairing of that operator on supplied probe fields.

The action has an exact affine first variation, and the operator metric is a
linear map of the localized coefficients. An explicit eleven-event chain has
ten distinct layers at its top event. With a displayed supplied four-probe
family, those ten layer moments span every symmetric `4 x 4` tensor and the
metric map is injective, so the toy action is constant on metric fibers.

This is a finite algebraic sufficiency witness. It does not derive the probes,
select a four-dimensional manifoldlike phase, identify the metric response
with Ricci curvature, recover the Einstein-Hilbert coefficient, or prove a
continuum limit.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.LocalizedIntervalActionMetric

open scoped BigOperators
open FiniteCausalOrderOperator
open CorrectedPairingDifferenceOperator
open EinsteinEquationVariation
open RelaxedCausalMetricVariationBridge

variable {V W : Type*} [Fintype V] [Fintype W]

/-! ## Localized interval operator and action -/

/-- Extend a finite row of layer coefficients by zero to every natural layer
index. -/
def truncatedLayerCoefficient (K : Nat) (row : Fin K -> Real)
    (layer : Nat) : Real :=
  if hLayer : layer < K then row ⟨layer, hLayer⟩ else 0

/-- Strict-past causal operator with an independently variable layer row at
each output event. A diagonal term may be added separately; it cancels from
the corrected metric pairing. -/
def eventLocalIntervalOperator
    (C : FiniteCausalOrder V) (K : Nat)
    (coefficient : V -> Fin K -> Real) :
    (V -> Real) -> V -> Real :=
  fun phi x =>
    C.layeredOperator 1 0
      (truncatedLayerCoefficient K (coefficient x)) phi x

/-- The bulk interval-count action obtained from the same localized operator
by evaluating it on the constant field and summing with a fixed event measure.
-/
def eventLocalIntervalBulkAction
    (C : FiniteCausalOrder V) (bulkWeight : V -> Real) (K : Nat)
    (coefficient : V -> Fin K -> Real) : Real :=
  ∑ x : V, bulkWeight x *
    eventLocalIntervalOperator C K coefficient 1 x

/-- Bulk response to an affine coefficient direction. -/
def eventLocalIntervalBulkResponse
    (C : FiniteCausalOrder V) (bulkWeight : V -> Real) (K : Nat)
    (direction : V -> Fin K -> Real) : Real :=
  eventLocalIntervalBulkAction C bulkWeight K direction

/-- Full first-stage action with held-fixed boundary and cosmological terms.
Their geometric formulas and variations remain separate obligations. -/
def eventLocalIntervalAction
    (C : FiniteCausalOrder V) (bulkWeight : V -> Real) (K : Nat)
    (coefficient : V -> Fin K -> Real)
    (boundary cosmological : Real) : Real :=
  eventLocalIntervalBulkAction C bulkWeight K coefficient +
    boundary + cosmological

theorem truncatedLayerCoefficient_add
    (K : Nat) (row row' : Fin K -> Real) (layer : Nat) :
    truncatedLayerCoefficient K (row + row') layer =
      truncatedLayerCoefficient K row layer +
        truncatedLayerCoefficient K row' layer := by
  unfold truncatedLayerCoefficient
  split_ifs
  · rfl
  · ring

theorem truncatedLayerCoefficient_smul
    (K : Nat) (scalar : Real) (row : Fin K -> Real) (layer : Nat) :
    truncatedLayerCoefficient K (scalar • row) layer =
      scalar * truncatedLayerCoefficient K row layer := by
  unfold truncatedLayerCoefficient
  split_ifs
  · rfl
  · ring

theorem eventLocalIntervalOperator_add
    (C : FiniteCausalOrder V) (K : Nat)
    (coefficient coefficient' : V -> Fin K -> Real)
    (phi : V -> Real) (x : V) :
    eventLocalIntervalOperator C K (coefficient + coefficient') phi x =
      eventLocalIntervalOperator C K coefficient phi x +
        eventLocalIntervalOperator C K coefficient' phi x := by
  classical
  unfold eventLocalIntervalOperator FiniteCausalOrder.layeredOperator
    FiniteCausalOrder.layeredPastSum
  simp only [Pi.add_apply, one_mul, zero_mul, zero_add]
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro y _
  by_cases hyx : C.before y x
  · simp only [hyx, if_true, truncatedLayerCoefficient_add, add_mul]
  · simp only [hyx, if_false, add_zero]

theorem eventLocalIntervalOperator_smul
    (C : FiniteCausalOrder V) (K : Nat) (scalar : Real)
    (coefficient : V -> Fin K -> Real) (phi : V -> Real) (x : V) :
    eventLocalIntervalOperator C K (scalar • coefficient) phi x =
      scalar * eventLocalIntervalOperator C K coefficient phi x := by
  classical
  unfold eventLocalIntervalOperator FiniteCausalOrder.layeredOperator
    FiniteCausalOrder.layeredPastSum
  simp only [Pi.smul_apply, one_mul, zero_mul, zero_add]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro y _
  by_cases hyx : C.before y x
  · simp only [hyx, if_true, truncatedLayerCoefficient_smul]
    ring
  · simp only [hyx, if_false, mul_zero]

/-- The localized bulk action is linear in its event-layer coefficient field.
-/
def eventLocalIntervalBulkActionLinear
    (C : FiniteCausalOrder V) (bulkWeight : V -> Real) (K : Nat) :
    (V -> Fin K -> Real) →ₗ[Real] Real where
  toFun := eventLocalIntervalBulkAction C bulkWeight K
  map_add' coefficient coefficient' := by
    unfold eventLocalIntervalBulkAction
    simp only [eventLocalIntervalOperator_add, mul_add,
      Finset.sum_add_distrib]
  map_smul' scalar coefficient := by
    unfold eventLocalIntervalBulkAction
    simp only [eventLocalIntervalOperator_smul, RingHom.id_apply,
      smul_eq_mul]
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro x _
    ring

/-- **Exact event-local interval derivative.** The derivative is obtained from
the displayed graph action, without inserting curvature or an Einstein tensor.
-/
theorem eventLocalIntervalAction_directionalDerivative
    (C : FiniteCausalOrder V) (bulkWeight : V -> Real) (K : Nat)
    (coefficient direction : V -> Fin K -> Real)
    (boundary cosmological : Real) :
    HasDerivAt
      (fun t : Real => eventLocalIntervalAction C bulkWeight K
        (coefficient + t • direction) boundary cosmological)
      (eventLocalIntervalBulkResponse C bulkWeight K direction) 0 := by
  let response := eventLocalIntervalBulkResponse C bulkWeight K direction
  have hDerivative : HasDerivAt
      (fun t : Real =>
        eventLocalIntervalBulkAction C bulkWeight K coefficient +
          t * response + boundary + cosmological)
      response 0 := by
    simpa using
      (((((hasDerivAt_id (𝕜 := Real) 0).mul_const response).const_add
        (eventLocalIntervalBulkAction C bulkWeight K coefficient)).add_const
          boundary).add_const cosmological)
  convert hDerivative using 1
  funext t
  unfold eventLocalIntervalAction
  change
    (eventLocalIntervalBulkActionLinear C bulkWeight K)
        (coefficient + t • direction) + boundary + cosmological = _
  rw [map_add, map_smul]
  change eventLocalIntervalBulkAction C bulkWeight K coefficient +
      t * eventLocalIntervalBulkResponse C bulkWeight K direction +
        boundary + cosmological = _
  rfl

/-! ## Relabeling covariance -/

/-- The localized operator is intrinsic when its event-indexed coefficient
field and scalar field are transported together. -/
theorem eventLocalIntervalOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (K : Nat)
    (coefficient : V -> Fin K -> Real) (phi : V -> Real) (x : V) :
    eventLocalIntervalOperator D K (e.relabelField coefficient)
        (e.relabelField phi) (e.toEquiv x) =
      eventLocalIntervalOperator C K coefficient phi x := by
  unfold eventLocalIntervalOperator
  rw [e.relabelField_apply]
  exact e.layeredOperator_equivariant 1 0
    (truncatedLayerCoefficient K (coefficient x)) phi x

/-- The localized action is invariant under causal-order relabeling. -/
theorem eventLocalIntervalAction_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (bulkWeight : V -> Real) (K : Nat)
    (coefficient : V -> Fin K -> Real)
    (boundary cosmological : Real) :
    eventLocalIntervalAction D (e.relabelField bulkWeight) K
        (e.relabelField coefficient) boundary cosmological =
      eventLocalIntervalAction C bulkWeight K coefficient
        boundary cosmological := by
  unfold eventLocalIntervalAction eventLocalIntervalBulkAction
  congr 2
  symm
  apply Fintype.sum_equiv e.toEquiv
  intro x
  rw [e.relabelField_apply]
  have hone : e.relabelField (1 : V -> Real) = (1 : W -> Real) := by
    funext w
    simp [OrderIso.relabelField]
  rw [← hone, eventLocalIntervalOperator_equivariant e]

/-! ## Metric derivative from the same localized operator -/

/-- The strict-past row weight is linear in the finite layer row. -/
def layeredPastWeightLinear
    (C : FiniteCausalOrder V) (K : Nat) (x : V) :
    (Fin K -> Real) →ₗ[Real] (V -> Real) where
  toFun row :=
    layeredPastWeight C 1 (truncatedLayerCoefficient K row) x
  map_add' row row' := by
    funext y
    unfold layeredPastWeight
    by_cases hyx : C.before y x
    · simp only [hyx, if_true, one_mul, truncatedLayerCoefficient_add,
        Pi.add_apply]
    · simp only [hyx, if_false, Pi.add_apply, add_zero]
  map_smul' scalar row := by
    funext y
    unfold layeredPastWeight
    by_cases hyx : C.before y x
    · simp only [hyx, if_true, one_mul, truncatedLayerCoefficient_smul,
        RingHom.id_apply, Pi.smul_apply, smul_eq_mul]
    · simp only [hyx, if_false, RingHom.id_apply, Pi.smul_apply,
        smul_eq_mul, mul_zero]

/-- The weighted-difference form is a linear functional of its row weight. -/
def weightedDifferenceFormWeightLinear
    (x : V) (f h : V -> Real) :
    (V -> Real) →ₗ[Real] Real where
  toFun weight := weightedDifferenceForm weight x f h
  map_add' weight weight' := by
    classical
    unfold weightedDifferenceForm
    have hsum :
        (∑ y : V, (weight + weight') y * (f y - f x) *
          (h y - h x)) =
          (∑ y : V, weight y * (f y - f x) * (h y - h x)) +
            ∑ y : V, weight' y * (f y - f x) * (h y - h x) := by
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro y _
      simp only [Pi.add_apply]
      ring
    rw [hsum]
    ring
  map_smul' scalar weight := by
    classical
    unfold weightedDifferenceForm
    have hsum :
        (∑ y : V, (scalar • weight) y * (f y - f x) *
          (h y - h x)) =
          scalar * ∑ y : V, weight y * (f y - f x) *
            (h y - h x) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro y _
      simp only [Pi.smul_apply, smul_eq_mul]
      ring
    rw [hsum]
    simp only [RingHom.id_apply, smul_eq_mul]
    ring

/-- Linearized corrected-pairing metric response at one event for a supplied
four-probe family. -/
def rowMetricDerivativeAt
    (C : FiniteCausalOrder V) (K : Nat) (x : V)
    (probe : Fin 4 -> V -> Real) :
    (Fin K -> Real) →ₗ[Real] Tensor (I := Fin 4) where
  toFun row i j :=
    weightedDifferenceFormWeightLinear x (probe i) (probe j)
      (layeredPastWeightLinear C K x row)
  map_add' row row' := by
    ext i j
    rw [map_add, map_add]
    rfl
  map_smul' scalar row := by
    ext i j
    rw [map_smul, map_smul]
    rfl

/-- Eventwise metric Jacobian for event-local layer coefficients and supplied
eventwise probe frames. -/
def eventLocalMetricDerivative
    (C : FiniteCausalOrder V) (K : Nat)
    (probe : V -> Fin 4 -> V -> Real) :
    (V -> Fin K -> Real) →ₗ[Real]
      (V -> Tensor (I := Fin 4)) where
  toFun coefficient x :=
    rowMetricDerivativeAt C K x (probe x) (coefficient x)
  map_add' coefficient coefficient' := by
    funext x
    exact map_add (rowMetricDerivativeAt C K x (probe x))
      (coefficient x) (coefficient' x)
  map_smul' scalar coefficient := by
    funext x
    exact map_smul (rowMetricDerivativeAt C K x (probe x))
      scalar (coefficient x)

/-- The metric Jacobian is exactly the corrected pairing of the same localized
causal operator used by the action. -/
theorem eventLocalMetricDerivative_eq_correctedPairing
    (C : FiniteCausalOrder V) (K : Nat)
    (probe : V -> Fin 4 -> V -> Real)
    (coefficient : V -> Fin K -> Real) (x : V) (i j : Fin 4) :
    eventLocalMetricDerivative C K probe coefficient x i j =
      correctedPairingAt (eventLocalIntervalOperator C K coefficient) x
        (probe x i) (probe x j) := by
  change weightedDifferenceForm
      (layeredPastWeight C 1
        (truncatedLayerCoefficient K (coefficient x)) x)
      x (probe x i) (probe x j) = _
  symm
  change correctedPairingAt
      (C.layeredOperator 1 0
        (truncatedLayerCoefficient K (coefficient x))) x
      (probe x i) (probe x j) = _
  exact correctedPairingAt_layeredOperator_eq_weightedDifferenceForm
    C 1 0 (truncatedLayerCoefficient K (coefficient x)) x
      (probe x i) (probe x j)

/-- Every metric response produced by the localized operator is symmetric. -/
theorem eventLocalMetricDerivative_symmetric
    (C : FiniteCausalOrder V) (K : Nat)
    (probe : V -> Fin 4 -> V -> Real)
    (coefficient : V -> Fin K -> Real) (x : V) :
    (eventLocalMetricDerivative C K probe coefficient x).IsSymm := by
  apply Matrix.IsSymm.ext
  intro i j
  exact weightedDifferenceForm_comm
    (layeredPastWeight C 1
      (truncatedLayerCoefficient K (coefficient x)) x)
    x (probe x j) (probe x i)

/-! ## From row reach to local-field reach on selected bulk events -/

section SelectedBulk

variable {Site : Type*}

/-- Restrict the event-local metric Jacobian to an injectively selected family
of bulk centers, allowing a separate supplied probe frame at each center. -/
def selectedEventLocalMetricDerivative
    (C : FiniteCausalOrder V) (K : Nat) (center : Site -> V)
    (probe : Site -> Fin 4 -> V -> Real) :
    (V -> Fin K -> Real) →ₗ[Real]
      (Site -> Tensor (I := Fin 4)) where
  toFun coefficient site :=
    rowMetricDerivativeAt C K (center site) (probe site)
      (coefficient (center site))
  map_add' coefficient coefficient' := by
    funext site
    exact map_add
      (rowMetricDerivativeAt C K (center site) (probe site))
      (coefficient (center site)) (coefficient' (center site))
  map_smul' scalar coefficient := by
    funext site
    exact map_smul
      (rowMetricDerivativeAt C K (center site) (probe site))
      scalar (coefficient (center site))

/-- Full row reach at every distinct selected bulk center upgrades to full
sitewise metric reach. The proof extends independently chosen coefficient rows
from the centers to the rest of the event set. -/
theorem selectedEventLocalMetricDerivative_isFull
    (C : FiniteCausalOrder V) (K : Nat) (center : Site -> V)
    (probe : Site -> Fin 4 -> V -> Real)
    (hCenter : Function.Injective center)
    (hRow : forall site : Site,
      IsFullSymmetricMetricDerivative
        (rowMetricDerivativeAt C K (center site) (probe site))) :
    LayerWeightMetricRankNoGo.IsFullLocalSymmetricMetricDerivative
      (selectedEventLocalMetricDerivative C K center probe) := by
  constructor
  · intro coefficient site
    exact (hRow site).1 (coefficient (center site))
  · intro variation hVariation
    classical
    let row : Site -> Fin K -> Real := fun site =>
      Classical.choose ((hRow site).2 (variation site) (hVariation site))
    let coefficient : V -> Fin K -> Real :=
      Function.extend center row (fun _ => 0)
    refine ⟨coefficient, ?_⟩
    funext site
    change rowMetricDerivativeAt C K (center site) (probe site)
      (coefficient (center site)) = variation site
    have hCoefficient : coefficient (center site) = row site := by
      exact hCenter.extend_apply row (fun _ => 0) site
    rw [hCoefficient]
    exact Classical.choose_spec
      ((hRow site).2 (variation site) (hVariation site))

end SelectedBulk

/-! ## Explicit rank-ten bulk-event witness -/

/-- Strict eleven-event chain. Its top event has one predecessor in each open
interval layer from zero through nine. -/
def elevenChainOrder : FiniteCausalOrder (Fin 11) where
  before i j := i < j
  decidableBefore := fun _ _ => inferInstance
  irrefl := lt_irrefl
  trans := lt_trans

@[simp] theorem elevenChainOrder_intervalCount_to_top (y : Fin 11) :
    elevenChainOrder.openIntervalCount y 10 = 9 - y.val := by
  fin_cases y <;> decide

@[simp] theorem elevenChainOrder_before_top (y : Fin 11) :
    elevenChainOrder.before y 10 ↔ y ≠ 10 := by
  fin_cases y <;> decide

/-- Ten four-vectors whose rank-one symmetric moments form a basis of the
symmetric `4 x 4` matrices: four coordinate vectors and six pair sums. -/
def tenMomentVector : Fin 10 -> Fin 4 -> Real :=
  ![![1, 0, 0, 0],
    ![0, 1, 0, 0],
    ![0, 0, 1, 0],
    ![0, 0, 0, 1],
    ![1, 1, 0, 0],
    ![1, 0, 1, 0],
    ![1, 0, 0, 1],
    ![0, 1, 1, 0],
    ![0, 1, 0, 1],
    ![0, 0, 1, 1]]

/-- Symmetric moment tensor synthesized from ten layer coefficients. -/
def tenMomentMetric (row : Fin 10 -> Real) : Tensor (I := Fin 4) :=
  fun i j => (2 : Real)⁻¹ *
    ∑ k : Fin 10, row k * tenMomentVector k i * tenMomentVector k j

theorem tenMomentMetric_add (row row' : Fin 10 -> Real) :
    tenMomentMetric (row + row') =
      tenMomentMetric row + tenMomentMetric row' := by
  ext i j
  unfold tenMomentMetric
  have hsum :
      (∑ k : Fin 10,
        (row + row') k * tenMomentVector k i * tenMomentVector k j) =
        (∑ k : Fin 10,
          row k * tenMomentVector k i * tenMomentVector k j) +
        ∑ k : Fin 10,
          row' k * tenMomentVector k i * tenMomentVector k j := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro k _
    simp only [Pi.add_apply]
    ring
  rw [hsum]
  change (2 : Real)⁻¹ * (_ + _) =
    (2 : Real)⁻¹ * _ + (2 : Real)⁻¹ * _
  ring

theorem tenMomentMetric_smul (scalar : Real) (row : Fin 10 -> Real) :
    tenMomentMetric (scalar • row) = scalar • tenMomentMetric row := by
  ext i j
  unfold tenMomentMetric
  have hsum :
      (∑ k : Fin 10,
        (scalar • row) k * tenMomentVector k i * tenMomentVector k j) =
        scalar * ∑ k : Fin 10,
          row k * tenMomentVector k i * tenMomentVector k j := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro k _
    simp only [Pi.smul_apply, smul_eq_mul]
    ring
  rw [hsum]
  change (2 : Real)⁻¹ * (scalar * _) =
    scalar * ((2 : Real)⁻¹ * _)
  ring

/-- Linear form of the ten-moment synthesis map. -/
def tenMomentMetricLinear :
    (Fin 10 -> Real) →ₗ[Real] Tensor (I := Fin 4) where
  toFun := tenMomentMetric
  map_add' := tenMomentMetric_add
  map_smul' := tenMomentMetric_smul

/-- Every synthesized moment tensor is symmetric. -/
theorem tenMomentMetric_isSymm (row : Fin 10 -> Real) :
    (tenMomentMetric row).IsSymm := by
  apply Matrix.IsSymm.ext
  intro i j
  unfold tenMomentMetric
  apply congrArg (fun z : Real => (2 : Real)⁻¹ * z)
  apply Finset.sum_congr rfl
  intro k _
  ring

/-- Probe values on the eleven-event chain. The top value is zero; proceeding
down its past reverses the ten moment vectors so layer `k` sees vector `k`. -/
def elevenChainProbe : Fin 4 -> Fin 11 -> Real :=
  fun i y =>
    ![![0, 0, 1, 1],
      ![0, 1, 0, 1],
      ![0, 1, 1, 0],
      ![1, 0, 0, 1],
      ![1, 0, 1, 0],
      ![1, 1, 0, 0],
      ![0, 0, 0, 1],
      ![0, 0, 1, 0],
      ![0, 1, 0, 0],
      ![1, 0, 0, 0],
      ![0, 0, 0, 0]] y i

/-- The corrected-pairing metric at the top of the eleven-event chain is
exactly the ten-moment synthesis map. -/
theorem elevenChain_rowMetricDerivative_eq_tenMomentMetric
    (row : Fin 10 -> Real) :
    rowMetricDerivativeAt elevenChainOrder 10 10 elevenChainProbe row =
      tenMomentMetric row := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rowMetricDerivativeAt, weightedDifferenceFormWeightLinear,
      layeredPastWeightLinear, weightedDifferenceForm, layeredPastWeight,
      truncatedLayerCoefficient, elevenChainProbe,
      tenMomentMetric, tenMomentVector, Fin.sum_univ_succ] <;>
    ring

/-- Explicit coefficient row reconstructing a symmetric matrix from the ten
moment directions. -/
def tenMomentRightInverse (metric : Tensor (I := Fin 4)) :
    Fin 10 -> Real :=
  ![2 * (metric 0 0 - metric 0 1 - metric 0 2 - metric 0 3),
    2 * (metric 1 1 - metric 0 1 - metric 1 2 - metric 1 3),
    2 * (metric 2 2 - metric 0 2 - metric 1 2 - metric 2 3),
    2 * (metric 3 3 - metric 0 3 - metric 1 3 - metric 2 3),
    2 * metric 0 1,
    2 * metric 0 2,
    2 * metric 0 3,
    2 * metric 1 2,
    2 * metric 1 3,
    2 * metric 2 3]

/-- The displayed inverse reconstructs every symmetric tensor. -/
theorem tenMomentMetric_rightInverse
    (metric : Tensor (I := Fin 4)) (hMetric : metric.IsSymm) :
    tenMomentMetric (tenMomentRightInverse metric) = metric := by
  have h01 : metric 1 0 = metric 0 1 := hMetric.apply 0 1
  have h02 : metric 2 0 = metric 0 2 := hMetric.apply 0 2
  have h03 : metric 3 0 = metric 0 3 := hMetric.apply 0 3
  have h12 : metric 2 1 = metric 1 2 := hMetric.apply 1 2
  have h13 : metric 3 1 = metric 1 3 := hMetric.apply 1 3
  have h23 : metric 3 2 = metric 2 3 := hMetric.apply 2 3
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [tenMomentMetric, tenMomentRightInverse, tenMomentVector,
      Fin.sum_univ_succ, h01, h02, h03, h12, h13, h23] <;>
    ring

/-- The inverse also recovers every coefficient row, so the ten-moment map has
no nontrivial metric fibers. -/
theorem tenMomentRightInverse_leftInverse (row : Fin 10 -> Real) :
    tenMomentRightInverse (tenMomentMetric row) = row := by
  funext k
  fin_cases k <;>
    simp [tenMomentMetric, tenMomentRightInverse, tenMomentVector,
      Fin.sum_univ_succ] <;>
    ring

theorem tenMomentMetric_injective :
    Function.Injective tenMomentMetric := by
  intro row row' hMetric
  have hInverse := congrArg tenMomentRightInverse hMetric
  simpa only [tenMomentRightInverse_leftInverse] using hInverse

/-- **Concrete rank-ten witness.** Ten independently localized interval layers
at one bulk event reach every symmetric four-dimensional metric variation. -/
theorem elevenChain_rowMetricDerivative_isFull :
    IsFullSymmetricMetricDerivative
      (rowMetricDerivativeAt elevenChainOrder 10 10 elevenChainProbe) := by
  constructor
  · intro row
    rw [elevenChain_rowMetricDerivative_eq_tenMomentMetric]
    exact tenMomentMetric_isSymm row
  · intro variation hVariation
    refine ⟨tenMomentRightInverse variation, ?_⟩
    rw [elevenChain_rowMetricDerivative_eq_tenMomentMetric]
    exact tenMomentMetric_rightInverse variation hVariation

/-- The concrete chain metric Jacobian is injective; hence its coefficient
fibers are singletons. -/
theorem elevenChain_rowMetricDerivative_injective :
    Function.Injective
      (rowMetricDerivativeAt elevenChainOrder 10 10 elevenChainProbe) := by
  intro row row' hMetric
  apply tenMomentMetric_injective
  rw [← elevenChain_rowMetricDerivative_eq_tenMomentMetric row,
    ← elevenChain_rowMetricDerivative_eq_tenMomentMetric row']
  exact hMetric

/-! ## Explicit action descent in the rank-ten witness -/

/-- Select only the top chain event in the bulk sum. -/
def elevenChainTopWeight (x : Fin 11) : Real :=
  if x = 10 then 1 else 0

/-- Place a ten-coefficient row only at the top chain event. -/
def elevenChainTopCoefficient (row : Fin 10 -> Real) :
    Fin 11 -> Fin 10 -> Real :=
  fun x => if x = 10 then row else 0

/-- In the chain witness, every displayed layer has one predecessor, so the
bulk action is the sum of the ten row coefficients. -/
theorem elevenChain_bulkAction_eq_sum (row : Fin 10 -> Real) :
    eventLocalIntervalBulkAction elevenChainOrder elevenChainTopWeight 10
      (elevenChainTopCoefficient row) = ∑ k : Fin 10, row k := by
  simp [eventLocalIntervalBulkAction, eventLocalIntervalOperator,
    elevenChainTopWeight, elevenChainTopCoefficient,
    FiniteCausalOrder.layeredOperator,
    FiniteCausalOrder.layeredPastSum, truncatedLayerCoefficient,
    Fin.sum_univ_succ]
  ring

/-- Action on a symmetric metric obtained by reconstructing its unique ten
layer coefficients. -/
def elevenChainMetricAction (metric : Tensor (I := Fin 4)) : Real :=
  ∑ k : Fin 10, tenMomentRightInverse metric k

/-- The localized interval action factors exactly through the corrected
operator metric in the rank-ten chain witness. -/
theorem elevenChain_bulkAction_descends_to_metric
    (row : Fin 10 -> Real) :
    eventLocalIntervalBulkAction elevenChainOrder elevenChainTopWeight 10
        (elevenChainTopCoefficient row) =
      elevenChainMetricAction
        (rowMetricDerivativeAt elevenChainOrder 10 10
          elevenChainProbe row) := by
  rw [elevenChain_bulkAction_eq_sum,
    elevenChain_rowMetricDerivative_eq_tenMomentMetric]
  unfold elevenChainMetricAction
  rw [tenMomentRightInverse_leftInverse]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LocalizedIntervalActionMetric.eventLocalIntervalAction_directionalDerivative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eventLocalIntervalAction_directionalDerivative

/-- info: 'PhysicsSM.Draft.NullEdge.LocalizedIntervalActionMetric.eventLocalMetricDerivative_eq_correctedPairing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eventLocalMetricDerivative_eq_correctedPairing

/-- info: 'PhysicsSM.Draft.NullEdge.LocalizedIntervalActionMetric.selectedEventLocalMetricDerivative_isFull' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selectedEventLocalMetricDerivative_isFull

/-- info: 'PhysicsSM.Draft.NullEdge.LocalizedIntervalActionMetric.elevenChain_rowMetricDerivative_isFull' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms elevenChain_rowMetricDerivative_isFull

/-- info: 'PhysicsSM.Draft.NullEdge.LocalizedIntervalActionMetric.elevenChain_bulkAction_descends_to_metric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms elevenChain_bulkAction_descends_to_metric

end PhysicsSM.Draft.NullEdge.LocalizedIntervalActionMetric
