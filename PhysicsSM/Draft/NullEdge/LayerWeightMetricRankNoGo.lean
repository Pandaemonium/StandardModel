import PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge

/-!
# Rank obstruction for layer-weight metric variation

The relaxed causal variation bridge requires the derivative of the
reconstructed metric to reach every symmetric metric variation. In four
dimensions that target has at least ten independent directions: four diagonal
components and six off-diagonal components.

This module proves the corresponding finite-dimensional obstruction. A metric
derivative whose parameter space consists of fewer than ten independent real
layer weights cannot satisfy `IsFullSymmetricMetricDerivative`.

The theorem is a necessary-condition audit, not a construction of the metric
map. It does not claim that ten weights are sufficient, identify the correct
interval observables, or prove that an action descends through fibers of the
metric reconstruction.
-/

namespace PhysicsSM.Draft.NullEdge.LayerWeightMetricRankNoGo

open EinsteinEquationVariation
open RelaxedCausalMetricVariationBridge

/-! ## Ten explicit symmetric directions in four dimensions -/

/-- The ten coordinates of a symmetric `4 x 4` matrix, arranged as

```text
0 4 5 6
4 1 7 8
5 7 2 9
6 8 9 3.
```
-/
def symmetricCoordinate : Fin 4 -> Fin 4 -> Fin 10 :=
  ![![0, 4, 5, 6],
    ![4, 1, 7, 8],
    ![5, 7, 2, 9],
    ![6, 8, 9, 3]]

/-- A representative matrix entry for each symmetric coordinate. -/
def coordinateRepresentative : Fin 10 -> Prod (Fin 4) (Fin 4) :=
  ![(0, 0), (1, 1), (2, 2), (3, 3), (0, 1),
    (0, 2), (0, 3), (1, 2), (1, 3), (2, 3)]

theorem symmetricCoordinate_transpose (i j : Fin 4) :
    symmetricCoordinate j i = symmetricCoordinate i j := by
  fin_cases i <;> fin_cases j <;> rfl

theorem symmetricCoordinate_representative (k : Fin 10) :
    symmetricCoordinate (coordinateRepresentative k).1
      (coordinateRepresentative k).2 = k := by
  fin_cases k <;> rfl

/-- A ten-parameter family that fills the ten manifest symmetric entries of a
four-dimensional metric variation. -/
def tenParameterSymmetricTensor :
    (Fin 10 -> Real) →ₗ[Real]
      symmetricTensorSubmodule (I := Fin 4) where
  toFun parameters :=
    ⟨fun i j => parameters (symmetricCoordinate i j), by
      apply Matrix.IsSymm.ext
      intro i j
      rw [symmetricCoordinate_transpose]⟩
  map_add' parameters parameters' := by
    apply Subtype.ext
    funext i j
    rfl
  map_smul' scalar parameters := by
    apply Subtype.ext
    funext i j
    rfl

/-- The ten displayed symmetric directions are linearly independent. -/
theorem tenParameterSymmetricTensor_injective :
    Function.Injective tenParameterSymmetricTensor := by
  intro parameters parameters' hEqual
  funext k
  have hMatrices :
      ((tenParameterSymmetricTensor parameters :
          symmetricTensorSubmodule (I := Fin 4)) : Tensor (I := Fin 4)) =
        ((tenParameterSymmetricTensor parameters' :
          symmetricTensorSubmodule (I := Fin 4)) : Tensor (I := Fin 4)) :=
    congrArg
      (fun variation : symmetricTensorSubmodule (I := Fin 4) =>
        (variation : Tensor (I := Fin 4))) hEqual
  have hEntry := congrFun
    (congrFun hMatrices (coordinateRepresentative k).1)
    (coordinateRepresentative k).2
  change parameters
      (symmetricCoordinate (coordinateRepresentative k).1
        (coordinateRepresentative k).2) =
    parameters'
      (symmetricCoordinate (coordinateRepresentative k).1
        (coordinateRepresentative k).2) at hEntry
  simpa only [symmetricCoordinate_representative] using hEntry

/-- The symmetric `4 x 4` tensor submodule has dimension at least ten. -/
theorem ten_le_finrank_symmetricTensorSubmodule :
    10 <= Module.finrank Real
      (symmetricTensorSubmodule (I := Fin 4)) := by
  have hDimension :=
    tenParameterSymmetricTensor.finrank_le_finrank_of_injective
      tenParameterSymmetricTensor_injective
  simpa only [Module.finrank_fintype_fun_eq_card, Fintype.card_fin] using
    hDimension

/-! ## Consequence for relaxed metric reconstruction -/

section RankObstruction

variable {P : Type*} [AddCommGroup P] [Module Real P]

/-- Restrict a metric derivative with symmetric image to the symmetric-tensor
submodule. -/
def symmetricRangeDerivative
    (metricDerivative : P →ₗ[Real] Tensor (I := Fin 4))
    (hSymmetric : forall direction : P,
      (metricDerivative direction).IsSymm) :
    P →ₗ[Real] symmetricTensorSubmodule (I := Fin 4) :=
  metricDerivative.codRestrict
    (symmetricTensorSubmodule (I := Fin 4)) hSymmetric

theorem symmetricRangeDerivative_surjective
    (metricDerivative : P →ₗ[Real] Tensor (I := Fin 4))
    (hFull : IsFullSymmetricMetricDerivative metricDerivative) :
    Function.Surjective
      (symmetricRangeDerivative metricDerivative hFull.1) := by
  intro variation
  obtain ⟨direction, hDirection⟩ :=
    hFull.2 (variation : Tensor (I := Fin 4)) variation.property
  refine ⟨direction, ?_⟩
  apply Subtype.ext
  exact hDirection

/-- Any finite-dimensional relaxed parameter space that reaches every
symmetric four-dimensional metric variation has dimension at least ten. -/
theorem ten_le_finrank_of_fullSymmetricMetricDerivative
    [Module.Finite Real P]
    (metricDerivative : P →ₗ[Real] Tensor (I := Fin 4))
    (hFull : IsFullSymmetricMetricDerivative metricDerivative) :
    10 <= Module.finrank Real P := by
  let restricted := symmetricRangeDerivative metricDerivative hFull.1
  have hSurjective : Function.Surjective restricted :=
    symmetricRangeDerivative_surjective metricDerivative hFull
  obtain ⟨rightInverseMap, hRightInverseMap⟩ :=
    restricted.exists_rightInverse_of_surjective
      (LinearMap.range_eq_top.mpr hSurjective)
  have hRightInverse : Function.RightInverse rightInverseMap restricted :=
    LinearMap.ext_iff.mp hRightInverseMap
  have hDimension :
      Module.finrank Real (symmetricTensorSubmodule (I := Fin 4)) <=
        Module.finrank Real P :=
    rightInverseMap.finrank_le_finrank_of_injective hRightInverse.injective
  exact ten_le_finrank_symmetricTensorSubmodule.trans hDimension

/-- A layer-weight metric derivative with full symmetric reach needs at least
ten independently variable layers in four dimensions. -/
theorem ten_le_layerCount_of_fullSymmetricMetricDerivative
    {layerCount : Nat}
    (metricDerivative :
      (Fin layerCount -> Real) →ₗ[Real] Tensor (I := Fin 4))
    (hFull : IsFullSymmetricMetricDerivative metricDerivative) :
    10 <= layerCount := by
  have hDimension :=
    ten_le_finrank_of_fullSymmetricMetricDerivative metricDerivative hFull
  simpa only [Module.finrank_fintype_fun_eq_card, Fintype.card_fin] using
    hDimension

/-- **Layer-count no-go.** Fewer than ten independent interval-layer weights
cannot generate arbitrary symmetric four-dimensional metric variations. -/
theorem not_fullSymmetricMetricDerivative_of_layerCount_lt_ten
    {layerCount : Nat}
    (metricDerivative :
      (Fin layerCount -> Real) →ₗ[Real] Tensor (I := Fin 4))
    (hLayerCount : layerCount < 10) :
    Not (IsFullSymmetricMetricDerivative metricDerivative) := by
  intro hFull
  exact (Nat.not_le_of_lt hLayerCount)
    (ten_le_layerCount_of_fullSymmetricMetricDerivative
      metricDerivative hFull)

end RankObstruction

/-! ## Local tensor-field obstruction -/

section LocalRankObstruction

variable {Site P : Type*} [Fintype Site]
variable [AddCommGroup P] [Module Real P]

/-- Symmetric four-dimensional tensor fields on a finite set of sites. -/
def localSymmetricTensorSubmodule :
    Submodule Real (Site -> Tensor (I := Fin 4)) where
  carrier := {variation | forall site, (variation site).IsSymm}
  zero_mem' := fun _ => Matrix.isSymm_zero
  add_mem' := fun hVariation hVariation' site =>
    (hVariation site).add (hVariation' site)
  smul_mem' := fun scalar _ hVariation site =>
    (hVariation site).smul scalar

/-- Ten independent symmetric coordinates at every site give a manifest
`10 * number of sites` family of local metric variations. -/
def localTenParameterSymmetricTensor :
    (Prod Site (Fin 10) -> Real) →ₗ[Real]
      localSymmetricTensorSubmodule (Site := Site) where
  toFun parameters :=
    ⟨fun site i j => parameters (site, symmetricCoordinate i j), by
      intro site
      apply Matrix.IsSymm.ext
      intro i j
      change parameters (site, symmetricCoordinate j i) =
        parameters (site, symmetricCoordinate i j)
      rw [symmetricCoordinate_transpose]⟩
  map_add' parameters parameters' := by
    apply Subtype.ext
    funext site i j
    rfl
  map_smul' scalar parameters := by
    apply Subtype.ext
    funext site i j
    rfl

omit [Fintype Site] in
theorem localTenParameterSymmetricTensor_injective :
    Function.Injective
      (localTenParameterSymmetricTensor (Site := Site)) := by
  intro parameters parameters' hEqual
  funext siteAndCoordinate
  rcases siteAndCoordinate with ⟨site, k⟩
  have hFields :
      ((localTenParameterSymmetricTensor (Site := Site) parameters :
          localSymmetricTensorSubmodule (Site := Site)) :
        Site -> Tensor (I := Fin 4)) =
      ((localTenParameterSymmetricTensor (Site := Site) parameters' :
          localSymmetricTensorSubmodule (Site := Site)) :
        Site -> Tensor (I := Fin 4)) :=
    congrArg
      (fun variation : localSymmetricTensorSubmodule (Site := Site) =>
        (variation : Site -> Tensor (I := Fin 4))) hEqual
  have hMatrix := congrFun hFields site
  have hEntry := congrFun
    (congrFun hMatrix (coordinateRepresentative k).1)
    (coordinateRepresentative k).2
  change parameters
      (site, symmetricCoordinate (coordinateRepresentative k).1
        (coordinateRepresentative k).2) =
    parameters'
      (site, symmetricCoordinate (coordinateRepresentative k).1
        (coordinateRepresentative k).2) at hEntry
  simpa only [symmetricCoordinate_representative] using hEntry

/-- The space of local symmetric four-tensors has at least ten dimensions per
site. -/
theorem siteCount_mul_ten_le_finrank_localSymmetricTensorSubmodule :
    Fintype.card Site * 10 <= Module.finrank Real
      (localSymmetricTensorSubmodule (Site := Site)) := by
  have hDimension :=
    (localTenParameterSymmetricTensor (Site := Site)).finrank_le_finrank_of_injective
      (localTenParameterSymmetricTensor_injective (Site := Site))
  simpa only [Module.finrank_fintype_fun_eq_card, Fintype.card_prod,
    Fintype.card_fin] using hDimension

/-- Full local symmetric reach for a metric field reconstructed from relaxed
parameters. This is stronger than reach for one tensor at one selected site. -/
def IsFullLocalSymmetricMetricDerivative
    (metricDerivative : P →ₗ[Real] (Site -> Tensor (I := Fin 4))) : Prop :=
  (forall direction : P, forall site,
    (metricDerivative direction site).IsSymm) /\
  (forall variation : Site -> Tensor (I := Fin 4),
    (forall site, (variation site).IsSymm) ->
      exists direction : P, metricDerivative direction = variation)

/-- Restrict a local metric derivative with symmetric image to the local
symmetric-tensor submodule. -/
def localSymmetricRangeDerivative
    (metricDerivative : P →ₗ[Real] (Site -> Tensor (I := Fin 4)))
    (hSymmetric : forall direction : P, forall site,
      (metricDerivative direction site).IsSymm) :
    P →ₗ[Real] localSymmetricTensorSubmodule (Site := Site) :=
  metricDerivative.codRestrict
    (localSymmetricTensorSubmodule (Site := Site)) hSymmetric

omit [Fintype Site] in
theorem localSymmetricRangeDerivative_surjective
    (metricDerivative : P →ₗ[Real] (Site -> Tensor (I := Fin 4)))
    (hFull : IsFullLocalSymmetricMetricDerivative metricDerivative) :
    Function.Surjective
      (localSymmetricRangeDerivative metricDerivative hFull.1) := by
  intro variation
  obtain ⟨direction, hDirection⟩ :=
    hFull.2 (variation : Site -> Tensor (I := Fin 4)) variation.property
  refine ⟨direction, ?_⟩
  apply Subtype.ext
  exact hDirection

/-- Full local metric reach needs at least ten real parameter directions per
site. -/
theorem siteCount_mul_ten_le_finrank_of_fullLocalMetricDerivative
    [Module.Finite Real P]
    (metricDerivative : P →ₗ[Real] (Site -> Tensor (I := Fin 4)))
    (hFull : IsFullLocalSymmetricMetricDerivative metricDerivative) :
    Fintype.card Site * 10 <= Module.finrank Real P := by
  let restricted := localSymmetricRangeDerivative metricDerivative hFull.1
  have hSurjective : Function.Surjective restricted :=
    localSymmetricRangeDerivative_surjective metricDerivative hFull
  obtain ⟨rightInverseMap, hRightInverseMap⟩ :=
    restricted.exists_rightInverse_of_surjective
      (LinearMap.range_eq_top.mpr hSurjective)
  have hRightInverse : Function.RightInverse rightInverseMap restricted :=
    LinearMap.ext_iff.mp hRightInverseMap
  have hDimension :
      Module.finrank Real
          (localSymmetricTensorSubmodule (Site := Site)) <=
        Module.finrank Real P :=
    rightInverseMap.finrank_le_finrank_of_injective hRightInverse.injective
  exact
    siteCount_mul_ten_le_finrank_localSymmetricTensorSubmodule.trans hDimension

/-- Global layer weights can have full local metric reach on `siteCount` sites
only if their number is at least `10 * siteCount`. -/
theorem siteCount_mul_ten_le_layerCount_of_fullLocalMetricDerivative
    {siteCount layerCount : Nat}
    (metricDerivative :
      (Fin layerCount -> Real) →ₗ[Real]
        (Fin siteCount -> Tensor (I := Fin 4)))
    (hFull : IsFullLocalSymmetricMetricDerivative metricDerivative) :
    siteCount * 10 <= layerCount := by
  have hDimension :=
    siteCount_mul_ten_le_finrank_of_fullLocalMetricDerivative
      metricDerivative hFull
  simpa only [Module.finrank_fintype_fun_eq_card, Fintype.card_fin] using
    hDimension

/-- **Global-weight local-field no-go.** A globally shared list of interval
layer coefficients with fewer than ten parameters per site cannot generate
arbitrary local symmetric metric variations. In particular, a fixed finite
list cannot retain full local reach on an unbounded refinement sequence. -/
theorem not_fullLocalMetricDerivative_of_layerCount_lt_siteCount_mul_ten
    {siteCount layerCount : Nat}
    (metricDerivative :
      (Fin layerCount -> Real) →ₗ[Real]
        (Fin siteCount -> Tensor (I := Fin 4)))
    (hLayerCount : layerCount < siteCount * 10) :
    Not (IsFullLocalSymmetricMetricDerivative metricDerivative) := by
  intro hFull
  exact (Nat.not_le_of_lt hLayerCount)
    (siteCount_mul_ten_le_layerCount_of_fullLocalMetricDerivative
      metricDerivative hFull)

end LocalRankObstruction

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LayerWeightMetricRankNoGo.tenParameterSymmetricTensor_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tenParameterSymmetricTensor_injective

/-- info: 'PhysicsSM.Draft.NullEdge.LayerWeightMetricRankNoGo.ten_le_finrank_of_fullSymmetricMetricDerivative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ten_le_finrank_of_fullSymmetricMetricDerivative

/-- info: 'PhysicsSM.Draft.NullEdge.LayerWeightMetricRankNoGo.not_fullSymmetricMetricDerivative_of_layerCount_lt_ten' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms not_fullSymmetricMetricDerivative_of_layerCount_lt_ten

/-- info: 'PhysicsSM.Draft.NullEdge.LayerWeightMetricRankNoGo.not_fullLocalMetricDerivative_of_layerCount_lt_siteCount_mul_ten' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms not_fullLocalMetricDerivative_of_layerCount_lt_siteCount_mul_ten

end PhysicsSM.Draft.NullEdge.LayerWeightMetricRankNoGo
