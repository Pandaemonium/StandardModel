import PhysicsSM.Draft.NullEdge.CoframeVolumeMetricVariation

/-!
# Finite Palatini-to-Einstein-Hilbert variation bridge

This module composes the two noncircular channels needed for the finite
Einstein-Hilbert first variation.

1. The inverse-metric volume response is
   `delta volume = -(volume/2) <g, h>`.
2. The integrated curvature response is a Ricci pairing plus a boundary
   response:
   `sum volume * delta R = sum volume * <Ric, h> + boundary`.

Substitution into

```text
delta sum_x volume(x) (R(x) - 2 Lambda)
```

gives exactly

```text
sum_x volume(x) <Ric - (R/2) g + Lambda g, h> + boundary.
```

The second premise is the finite Palatini gate. It is strictly weaker than
assuming the Einstein tensor as the action derivative: it mentions only the
independently constructed Ricci tensor and an explicit boundary response.

Because a genuine finite action carries local volume weights, the module also
proves the weighted stationarity theorem. If every local oriented volume is
nonzero, stationarity against all site-supported symmetric variations is
equivalent to the pointwise finite Einstein equation.

The module does not prove the Palatini gate from null-edge connection data or
show that the boundary response vanishes. Those are now isolated as the next
geometric obligations.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FinitePalatiniEinsteinHilbertVariation

open scoped BigOperators
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open LocalEinsteinEquationVariation
open RelaxedCausalMetricVariationBridge
open LayerWeightMetricRankNoGo
open FiniteEinsteinHilbertActionResponse
open CoframeVolumeMetricVariation

variable {Site : Type*} [Fintype Site]

/-- Volume-weighted pairing of a local tensor coefficient with a local metric
variation. -/
def weightedLocalMetricPairing
    (volume : Site -> Real)
    (coefficient variation : LocalTensor (Site := Site)) : Real :=
  ∑ site : Site,
    volume site * metricVariationPairing (coefficient site) (variation site)

/-- The actual local Einstein-matter response with a finite event-volume
weight at every site. -/
def weightedLocalTotalMetricFirstVariation
    (kappa : Real) (volume : Site -> Real)
    (einstein stress variation : LocalTensor (Site := Site)) : Real :=
  ∑ site : Site,
    volume site *
      totalMetricFirstVariation kappa (einstein site) (stress site)
        (variation site)

/-- Stationarity of the volume-weighted local Einstein-matter response. -/
def WeightedLocalMetricStationary
    (kappa : Real) (volume : Site -> Real)
    (einstein stress : LocalTensor (Site := Site)) : Prop :=
  forall variation : LocalTensor (Site := Site), LocalSymmetric variation ->
    weightedLocalTotalMetricFirstVariation kappa volume einstein stress
      variation = 0

/-- Nonzero local volumes make weighted and unweighted local stationarity
equivalent. Site-supported variations prove the nontrivial direction. -/
theorem weightedLocalMetricStationary_iff_localMetricStationary
    (kappa : Real) (volume : Site -> Real)
    (einstein stress : LocalTensor (Site := Site))
    (hVolume : forall site, volume site ≠ 0) :
    WeightedLocalMetricStationary kappa volume einstein stress <->
      LocalMetricStationary kappa einstein stress := by
  classical
  constructor
  · intro hWeighted
    rw [localMetricStationary_iff_pointwiseMetricStationary]
    intro site variation hVariation
    let supported : LocalTensor (Site := Site) := fun other =>
      if other = site then variation else 0
    have hSupported : LocalSymmetric supported := by
      intro other
      by_cases hOther : other = site
      · simp only [supported, hOther, if_true]
        exact hVariation
      · simp only [supported, hOther, if_false]
        exact Matrix.isSymm_zero
    have hResponse := hWeighted supported hSupported
    unfold weightedLocalTotalMetricFirstVariation at hResponse
    rw [Finset.sum_eq_single site] at hResponse
    · have hProduct :
          volume site * totalMetricFirstVariation kappa (einstein site)
            (stress site) variation = 0 := by
        simpa [supported] using hResponse
      exact (mul_eq_zero.mp hProduct).resolve_left (hVolume site)
    · intro other _ hOther
      rw [show supported other = 0 by simp [supported, hOther]]
      unfold totalMetricFirstVariation
        StressEnergyPhysicalControls.metricVariationPairing
      simp
    · simp
  · intro hLocal variation hVariation
    have hPointwise :=
      (localMetricStationary_iff_pointwiseMetricStationary kappa einstein
        stress).mp hLocal
    unfold weightedLocalTotalMetricFirstVariation
    apply Finset.sum_eq_zero
    intro site _
    rw [hPointwise site (variation site) (hVariation site)]
    ring

/-- **Weighted local Einstein equation.** Nonzero local volume factors cancel
from the Euler-Lagrange equations, leaving the pointwise tensor equation. -/
theorem weightedLocalMetricStationary_iff_localFiniteEinsteinEquation
    (kappa : Real) (volume : Site -> Real)
    (ricci : LocalTensor (Site := Site))
    (scalarCurvature : Site -> Real)
    (metric : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (stress : LocalTensor (Site := Site))
    (hVolume : forall site, volume site ≠ 0)
    (hRicci : LocalSymmetric ricci) (hMetric : LocalSymmetric metric)
    (hStress : LocalSymmetric stress) (hKappa : Not (kappa = 0)) :
    WeightedLocalMetricStationary kappa volume
        (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
          (metric site) cosmologicalConstant)
        stress <->
      LocalFiniteEinsteinEquation kappa ricci scalarCurvature metric
        cosmologicalConstant stress :=
  (weightedLocalMetricStationary_iff_localMetricStationary kappa volume _
    stress hVolume).trans
      (localMetricStationary_iff_localFiniteEinsteinEquation kappa ricci
        scalarCurvature metric cosmologicalConstant stress hRicci hMetric
        hStress hKappa)

/-! ## Volume and Palatini response channels -/

/-- The supplied volume response is the standard inverse-metric response at
every site. `CoframeVolumeMetricVariation` derives this relation for coframe
determinants and coframe-generated inverse-metric variations. -/
def HasInverseMetricVolumeResponse
    (volume volumeResponse : Site -> Real)
    (metric variation : LocalTensor (Site := Site)) : Prop :=
  forall site,
    volumeResponse site =
      -(volume site / 2) *
        metricVariationPairing (metric site) (variation site)

/-- Finite integrated Palatini identity: the scalar-curvature response gives
the Ricci pairing plus one explicit boundary response. -/
def HasFinitePalatiniCurvatureResponse
    (volume : Site -> Real)
    (ricci variation : LocalTensor (Site := Site))
    (curvatureResponse : Site -> Real)
    (boundaryResponse : Real) : Prop :=
  (∑ site : Site, volume site * curvatureResponse site) =
    weightedLocalMetricPairing volume ricci variation + boundaryResponse

omit [Fintype Site] in
/-- Coframe determinant responses satisfy the inverse-metric volume relation
site by site. -/
theorem coframe_hasInverseMetricVolumeResponse
    (coframe : Site -> RealCoframe (I := Fin 4))
    (metric inverseMetric generator : LocalTensor (Site := Site))
    (hMetric : forall site, (metric site).IsSymm)
    (hLeft : forall site, inverseMetric site * metric site = 1)
    (hRight : forall site, metric site * inverseMetric site = 1) :
    HasInverseMetricVolumeResponse
      (fun site => coframeVolume (coframe site))
      (fun site => coframeVolume (coframe site) * (generator site).trace)
      metric
      (fun site => inverseMetricVariation (inverseMetric site)
        (generator site)) := by
  intro site
  simpa using (coframeVolumeResponse_eq_inverseMetricPairing
    (coframe site) (metric site) (inverseMetric site) (generator site)
    (hMetric site) (hLeft site) (hRight site))

/-- Pairing expansion for the finite Einstein left side. -/
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
theorem finiteEinsteinHilbertBulkResponse_eq_weightedEinsteinPairing
    (volume volumeResponse scalarCurvature curvatureResponse : Site -> Real)
    (ricci metric variation : LocalTensor (Site := Site))
    (cosmologicalConstant boundaryResponse : Real)
    (hVolumeResponse : HasInverseMetricVolumeResponse volume volumeResponse
      metric variation)
    (hPalatini : HasFinitePalatiniCurvatureResponse volume ricci variation
      curvatureResponse boundaryResponse) :
    finiteEinsteinHilbertBulkResponse volume volumeResponse scalarCurvature
        curvatureResponse cosmologicalConstant =
      weightedLocalMetricPairing volume
        (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
          (metric site) cosmologicalConstant)
        variation + boundaryResponse := by
  unfold finiteEinsteinHilbertBulkResponse
  rw [Finset.sum_add_distrib]
  rw [hPalatini]
  rw [← add_assoc]
  congr 1
  unfold weightedLocalMetricPairing
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro site _
  rw [hVolumeResponse site,
    metricVariationPairing_finiteEinsteinLHS]
  ring

/-! ## Normalized gravity plus matter response -/

/-- Normalized Einstein-Hilbert bulk response plus the standard matter metric
response. -/
def normalizedEinsteinHilbertMatterResponse
    (kappa : Real)
    (gravityBulkResponse : Real)
    (volume : Site -> Real)
    (stress variation : LocalTensor (Site := Site)) : Real :=
  (1 / (2 * kappa)) * gravityBulkResponse -
    (1 / 2) * weightedLocalMetricPairing volume stress variation

/-- With vanishing boundary response, the decomposed Einstein-Hilbert and
matter response is exactly the volume-weighted local response used above. -/
theorem normalizedResponse_eq_weightedLocalTotalMetricFirstVariation
    (kappa : Real)
    (volume volumeResponse scalarCurvature curvatureResponse : Site -> Real)
    (ricci metric stress variation : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hKappa : Not (kappa = 0))
    (hVolumeResponse : HasInverseMetricVolumeResponse volume volumeResponse
      metric variation)
    (hPalatini : HasFinitePalatiniCurvatureResponse volume ricci variation
      curvatureResponse 0) :
    normalizedEinsteinHilbertMatterResponse kappa
        (finiteEinsteinHilbertBulkResponse volume volumeResponse
          scalarCurvature curvatureResponse cosmologicalConstant)
        volume stress variation =
      weightedLocalTotalMetricFirstVariation kappa volume
        (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
          (metric site) cosmologicalConstant)
        stress variation := by
  rw [finiteEinsteinHilbertBulkResponse_eq_weightedEinsteinPairing volume
    volumeResponse scalarCurvature curvatureResponse ricci metric variation
    cosmologicalConstant 0 hVolumeResponse hPalatini]
  unfold normalizedEinsteinHilbertMatterResponse
    weightedLocalTotalMetricFirstVariation weightedLocalMetricPairing
  simp only [add_zero]
  simp_rw [totalMetricFirstVariation_eq_standard _ _ _ _ hKappa]
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro site _
  ring

/-! ## Pullback through general geometric parameters -/

section ParameterPullback

variable {P : Type*} [AddCommGroup P] [Module Real P]

/-- A parameter action has the volume-weighted Einstein-matter first variation
after pullback through its local metric Jacobian. -/
def HasPulledBackWeightedEinsteinFirstVariation
    (action : P -> Real) (baseParameter : P)
    (metricDerivative : P →ₗ[Real] LocalTensor (Site := Site))
    (kappa : Real) (volume : Site -> Real)
    (einstein stress : LocalTensor (Site := Site)) : Prop :=
  forall direction : P,
    HasDerivAt
      (fun t : Real => action (baseParameter + t • direction))
      (weightedLocalTotalMetricFirstVariation kappa volume einstein stress
        (metricDerivative direction)) 0

/-- Full local metric reach upgrades parameter stationarity to weighted local
metric stationarity, and conversely. -/
theorem parameterStationary_iff_weightedLocalMetricStationary
    (action : P -> Real) (baseParameter : P)
    (metricDerivative : P →ₗ[Real] LocalTensor (Site := Site))
    (kappa : Real) (volume : Site -> Real)
    (einstein stress : LocalTensor (Site := Site))
    (hFirstVariation : HasPulledBackWeightedEinsteinFirstVariation action
      baseParameter metricDerivative kappa volume einstein stress)
    (hFull : IsFullLocalSymmetricMetricDerivative metricDerivative) :
    ParameterStationary action baseParameter <->
      WeightedLocalMetricStationary kappa volume einstein stress := by
  constructor
  · intro hParameter variation hVariation
    obtain ⟨direction, hDirection⟩ := hFull.2 variation hVariation
    rw [← hDirection]
    exact (hFirstVariation direction).unique (hParameter direction)
  · intro hWeighted direction
    have hDerivative := hFirstVariation direction
    have hResponseZero :=
      hWeighted (metricDerivative direction) (hFull.1 direction)
    rw [hResponseZero] at hDerivative
    exact hDerivative

/-- **Weighted parameter endpoint.** A full parameter-to-metric Jacobian and
the weighted Einstein first variation turn parameter stationarity into the
pointwise finite Einstein equation. -/
theorem parameterStationary_iff_weightedLocalFiniteEinsteinEquation
    (action : P -> Real) (baseParameter : P)
    (metricDerivative : P →ₗ[Real] LocalTensor (Site := Site))
    (kappa : Real) (volume scalarCurvature : Site -> Real)
    (ricci metric stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hFirstVariation : HasPulledBackWeightedEinsteinFirstVariation action
      baseParameter metricDerivative kappa volume
      (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
        (metric site) cosmologicalConstant)
      stress)
    (hFull : IsFullLocalSymmetricMetricDerivative metricDerivative)
    (hVolume : forall site, volume site ≠ 0)
    (hRicci : LocalSymmetric ricci) (hMetric : LocalSymmetric metric)
    (hStress : LocalSymmetric stress) (hKappa : Not (kappa = 0)) :
    ParameterStationary action baseParameter <->
      LocalFiniteEinsteinEquation kappa ricci scalarCurvature metric
        cosmologicalConstant stress :=
  (parameterStationary_iff_weightedLocalMetricStationary action baseParameter
    metricDerivative kappa volume _ stress hFirstVariation hFull).trans
      (weightedLocalMetricStationary_iff_localFiniteEinsteinEquation kappa
        volume ricci scalarCurvature metric cosmologicalConstant stress hVolume
        hRicci hMetric hStress hKappa)

end ParameterPullback

/-! ## Actual action endpoint -/

/-- A finite action has a decomposed Einstein-Hilbert plus matter first
variation when each symmetric direction supplies separate volume and curvature
responses, satisfies the inverse-volume and zero-boundary Palatini identities,
and differentiates to the normalized raw response. -/
def HasDecomposedEinsteinHilbertMatterFirstVariation
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site))
    (kappa : Real) (volume scalarCurvature : Site -> Real)
    (ricci metric stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (volumeResponse curvatureResponse :
      LocalTensor (Site := Site) -> Site -> Real) : Prop :=
  forall variation : LocalTensor (Site := Site), LocalSymmetric variation ->
    HasInverseMetricVolumeResponse volume (volumeResponse variation)
        metric variation ∧
      HasFinitePalatiniCurvatureResponse volume ricci variation
        (curvatureResponse variation) 0 ∧
      HasDerivAt
        (fun t : Real => action (baseMetric + t • variation))
        (normalizedEinsteinHilbertMatterResponse kappa
          (finiteEinsteinHilbertBulkResponse volume (volumeResponse variation)
            scalarCurvature (curvatureResponse variation)
            cosmologicalConstant)
          volume stress variation) 0

/-- A decomposed action first variation is equivalent to weighted metric
stationarity. The proof uses derivative uniqueness after deriving the Einstein
coefficient from the two response channels. -/
theorem localActionMetricStationary_iff_weightedLocalMetricStationary
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site))
    (kappa : Real) (volume scalarCurvature : Site -> Real)
    (ricci metric stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (volumeResponse curvatureResponse :
      LocalTensor (Site := Site) -> Site -> Real)
    (hKappa : Not (kappa = 0))
    (hFirstVariation : HasDecomposedEinsteinHilbertMatterFirstVariation
      action baseMetric kappa volume scalarCurvature ricci metric stress
      cosmologicalConstant volumeResponse curvatureResponse) :
    LocalActionMetricStationary action baseMetric <->
      WeightedLocalMetricStationary kappa volume
        (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
          (metric site) cosmologicalConstant)
        stress := by
  constructor
  · intro hAction variation hVariation
    obtain ⟨hVolume, hPalatini, hDerivative⟩ :=
      hFirstVariation variation hVariation
    rw [normalizedResponse_eq_weightedLocalTotalMetricFirstVariation
      kappa volume (volumeResponse variation) scalarCurvature
      (curvatureResponse variation) ricci metric stress variation
      cosmologicalConstant hKappa hVolume hPalatini] at hDerivative
    exact hDerivative.unique (hAction variation hVariation)
  · intro hWeighted variation hVariation
    obtain ⟨hVolume, hPalatini, hDerivative⟩ :=
      hFirstVariation variation hVariation
    rw [normalizedResponse_eq_weightedLocalTotalMetricFirstVariation
      kappa volume (volumeResponse variation) scalarCurvature
      (curvatureResponse variation) ricci metric stress variation
      cosmologicalConstant hKappa hVolume hPalatini] at hDerivative
    rw [hWeighted variation hVariation] at hDerivative
    exact hDerivative

/-- **Decomposed action to finite Einstein equation.** Once a genuine action's
raw volume and curvature responses satisfy the derived determinant identity
and zero-boundary Palatini identity, its stationarity is equivalent to the
pointwise finite Einstein equation. -/
theorem decomposedActionStationary_iff_localFiniteEinsteinEquation
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site))
    (kappa : Real) (volume scalarCurvature : Site -> Real)
    (ricci metric stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (volumeResponse curvatureResponse :
      LocalTensor (Site := Site) -> Site -> Real)
    (hVolume : forall site, volume site ≠ 0)
    (hRicci : LocalSymmetric ricci) (hMetric : LocalSymmetric metric)
    (hStress : LocalSymmetric stress) (hKappa : Not (kappa = 0))
    (hFirstVariation : HasDecomposedEinsteinHilbertMatterFirstVariation
      action baseMetric kappa volume scalarCurvature ricci metric stress
      cosmologicalConstant volumeResponse curvatureResponse) :
    LocalActionMetricStationary action baseMetric <->
      LocalFiniteEinsteinEquation kappa ricci scalarCurvature metric
        cosmologicalConstant stress :=
  (localActionMetricStationary_iff_weightedLocalMetricStationary action
    baseMetric kappa volume scalarCurvature ricci metric stress
    cosmologicalConstant volumeResponse curvatureResponse hKappa
    hFirstVariation).trans
      (weightedLocalMetricStationary_iff_localFiniteEinsteinEquation kappa
        volume ricci scalarCurvature metric cosmologicalConstant stress hVolume
        hRicci hMetric hStress hKappa)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniEinsteinHilbertVariation.finiteEinsteinHilbertBulkResponse_eq_weightedEinsteinPairing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteEinsteinHilbertBulkResponse_eq_weightedEinsteinPairing

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniEinsteinHilbertVariation.parameterStationary_iff_weightedLocalFiniteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parameterStationary_iff_weightedLocalFiniteEinsteinEquation

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniEinsteinHilbertVariation.decomposedActionStationary_iff_localFiniteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms decomposedActionStationary_iff_localFiniteEinsteinEquation

end PhysicsSM.Draft.NullEdge.FinitePalatiniEinsteinHilbertVariation
