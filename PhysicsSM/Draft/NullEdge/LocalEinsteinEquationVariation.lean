import PhysicsSM.Draft.NullEdge.LocalizedIntervalActionMetric

/-!
# Local finite Einstein equation from sitewise metric variation

The existing `EinsteinEquationVariation` theorem identifies one symmetric
component equation from variation of one `4 x 4` tensor. A gravitational field
on a finite causal carrier is sitewise. This module lifts the theorem to a
finite field of local tensors and then to relaxed null-edge parameters.

For a finite set of selected bulk sites, stationarity against every sitewise
symmetric metric variation is equivalent to the pointwise equations

```text
G_ab(x) + Lambda g_ab(x) = kappa T_ab(x).
```

If a parameter-space action has this pulled-back first variation and its
metric Jacobian reaches every local symmetric variation, ordinary parameter
stationarity is equivalent to the same local finite Einstein equation.

The theorem does not construct the action derivative. In particular, the
fixed-measure localized interval action is affine and fails that dynamical
gate except in a degenerate zero-response case; the companion no-go module
records this explicitly.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.LocalEinsteinEquationVariation

open scoped BigOperators
open EinsteinEquationVariation
open RelaxedCausalMetricVariationBridge
open LayerWeightMetricRankNoGo

variable {Site : Type*} [Fintype Site]

/-- A field of local four-dimensional rank-two tensors. -/
abbrev LocalTensor := Site -> Tensor (I := Fin 4)

/-- Sitewise symmetry of a local tensor field. -/
def LocalSymmetric (variation : LocalTensor (Site := Site)) : Prop :=
  forall site, (variation site).IsSymm

/-- Sum of the normalized Einstein-matter first-variation pairing over the
selected finite bulk sites. -/
noncomputable def localTotalMetricFirstVariation
    (kappa : Real) (einstein stress variation : LocalTensor (Site := Site)) :
    Real :=
  ∑ site : Site,
    totalMetricFirstVariation kappa (einstein site) (stress site)
      (variation site)

/-- Stationarity against every sitewise symmetric local metric variation. -/
def LocalMetricStationary
    (kappa : Real) (einstein stress : LocalTensor (Site := Site)) : Prop :=
  forall variation : LocalTensor (Site := Site), LocalSymmetric variation ->
    localTotalMetricFirstVariation kappa einstein stress variation = 0

/-- Sitewise finite Einstein equation on the selected bulk field. -/
def LocalFiniteEinsteinEquation
    (kappa : Real) (ricci : LocalTensor (Site := Site))
    (scalarCurvature : Site -> Real) (metric : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) (stress : LocalTensor (Site := Site)) :
    Prop :=
  forall site,
    FiniteEinsteinEquation kappa (ricci site) (scalarCurvature site)
      (metric site) cosmologicalConstant (stress site)

/-- Local field stationarity is exactly pointwise component stationarity.
The reverse direction uses site-supported symmetric variations. -/
theorem localMetricStationary_iff_pointwiseMetricStationary
    (kappa : Real) (einstein stress : LocalTensor (Site := Site)) :
    LocalMetricStationary kappa einstein stress <->
      forall site, MetricStationary kappa (einstein site) (stress site) := by
  classical
  constructor
  · intro hLocal site variation hVariation
    let supported : LocalTensor (Site := Site) := fun other =>
      if other = site then variation else 0
    have hSupported : LocalSymmetric supported := by
      intro other
      by_cases hOther : other = site
      · simp only [supported, hOther, if_true]
        exact hVariation
      · simp only [supported, hOther, if_false]
        exact Matrix.isSymm_zero
    have hResponse := hLocal supported hSupported
    unfold localTotalMetricFirstVariation at hResponse
    rw [Finset.sum_eq_single site] at hResponse
    · simpa [supported] using hResponse
    · intro other _ hOther
      rw [show supported other = 0 by simp [supported, hOther]]
      unfold totalMetricFirstVariation
        StressEnergyPhysicalControls.metricVariationPairing
      simp
    · simp
  · intro hPointwise variation hVariation
    unfold localTotalMetricFirstVariation
    apply Finset.sum_eq_zero
    intro site _
    exact hPointwise site (variation site) (hVariation site)

/-- **Local finite Einstein equation.** For nonzero coupling and symmetric
fields, vanishing response against every site-supported symmetric variation is
equivalent to the pointwise Einstein equation. -/
theorem localMetricStationary_iff_localFiniteEinsteinEquation
    (kappa : Real) (ricci : LocalTensor (Site := Site))
    (scalarCurvature : Site -> Real) (metric : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) (stress : LocalTensor (Site := Site))
    (hRicci : LocalSymmetric ricci) (hMetric : LocalSymmetric metric)
    (hStress : LocalSymmetric stress) (hKappa : Not (kappa = 0)) :
    LocalMetricStationary kappa
        (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
          (metric site) cosmologicalConstant)
        stress <->
      LocalFiniteEinsteinEquation kappa ricci scalarCurvature metric
        cosmologicalConstant stress := by
  rw [localMetricStationary_iff_pointwiseMetricStationary]
  constructor
  · intro hStationary site
    exact (metricStationary_iff_finiteEinsteinEquation
      kappa (ricci site) (scalarCurvature site) (metric site)
      cosmologicalConstant (stress site) (hRicci site) (hMetric site)
      (hStress site) hKappa).mp (hStationary site)
  · intro hEquation site
    exact (metricStationary_iff_finiteEinsteinEquation
      kappa (ricci site) (scalarCurvature site) (metric site)
      cosmologicalConstant (stress site) (hRicci site) (hMetric site)
      (hStress site) hKappa).mpr (hEquation site)

/-! ## Actual local metric actions -/

/-- An action on local metrics has the Einstein-matter first variation when
every symmetric affine direction has the summed local response. -/
def HasLocalEinsteinMetricFirstVariation
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site)) (kappa : Real)
    (einstein stress : LocalTensor (Site := Site)) : Prop :=
  forall variation : LocalTensor (Site := Site), LocalSymmetric variation ->
    HasDerivAt
      (fun t : Real => action (baseMetric + t • variation))
      (localTotalMetricFirstVariation kappa einstein stress variation) 0

/-- Ordinary stationarity of an actual action on a local metric field. -/
def LocalActionMetricStationary
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site)) : Prop :=
  forall variation : LocalTensor (Site := Site), LocalSymmetric variation ->
    HasDerivAt (fun t : Real => action (baseMetric + t • variation)) 0 0

theorem localActionMetricStationary_iff_localMetricStationary
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site)) (kappa : Real)
    (einstein stress : LocalTensor (Site := Site))
    (hFirstVariation : HasLocalEinsteinMetricFirstVariation action baseMetric
      kappa einstein stress) :
    LocalActionMetricStationary action baseMetric <->
      LocalMetricStationary kappa einstein stress := by
  constructor
  · intro hAction variation hVariation
    exact (hFirstVariation variation hVariation).unique
      (hAction variation hVariation)
  · intro hMetric variation hVariation
    have hDerivative := hFirstVariation variation hVariation
    rw [hMetric variation hVariation] at hDerivative
    exact hDerivative

/-- Stationarity of an actual local metric action is equivalent to the local
finite Einstein equation once its first variation is proved. -/
theorem localActionMetricStationary_iff_localFiniteEinsteinEquation
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site))
    (kappa : Real) (ricci : LocalTensor (Site := Site))
    (scalarCurvature : Site -> Real) (metric : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) (stress : LocalTensor (Site := Site))
    (hFirstVariation : HasLocalEinsteinMetricFirstVariation action baseMetric
      kappa
      (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
        (metric site) cosmologicalConstant)
      stress)
    (hRicci : LocalSymmetric ricci) (hMetric : LocalSymmetric metric)
    (hStress : LocalSymmetric stress) (hKappa : Not (kappa = 0)) :
    LocalActionMetricStationary action baseMetric <->
      LocalFiniteEinsteinEquation kappa ricci scalarCurvature metric
        cosmologicalConstant stress :=
  (localActionMetricStationary_iff_localMetricStationary action baseMetric
    kappa _ stress hFirstVariation).trans
      (localMetricStationary_iff_localFiniteEinsteinEquation kappa ricci
        scalarCurvature metric cosmologicalConstant stress hRicci hMetric
        hStress hKappa)

/-! ## Pullback to null-edge parameters -/

section ParameterPullback

variable {P : Type*} [AddCommGroup P] [Module Real P]

/-- The first variation of a parameter action equals the local Einstein-matter
response pulled back through its sitewise metric Jacobian. -/
def HasPulledBackLocalEinsteinFirstVariation
    (action : P -> Real) (baseParameter : P)
    (metricDerivative : P →ₗ[Real] LocalTensor (Site := Site))
    (kappa : Real) (einstein stress : LocalTensor (Site := Site)) : Prop :=
  forall direction : P,
    HasDerivAt
      (fun t : Real => action (baseParameter + t • direction))
      (localTotalMetricFirstVariation kappa einstein stress
        (metricDerivative direction)) 0

/-- Full local metric reach upgrades parameter stationarity to local metric
stationarity, and conversely. -/
theorem parameterStationary_iff_localMetricStationary
    (action : P -> Real) (baseParameter : P)
    (metricDerivative : P →ₗ[Real] LocalTensor (Site := Site))
    (kappa : Real) (einstein stress : LocalTensor (Site := Site))
    (hFirstVariation : HasPulledBackLocalEinsteinFirstVariation action
      baseParameter metricDerivative kappa einstein stress)
    (hFull : IsFullLocalSymmetricMetricDerivative metricDerivative) :
    ParameterStationary action baseParameter <->
      LocalMetricStationary kappa einstein stress := by
  constructor
  · intro hParameter variation hVariation
    obtain ⟨direction, hDirection⟩ := hFull.2 variation hVariation
    rw [← hDirection]
    exact (hFirstVariation direction).unique (hParameter direction)
  · intro hMetric direction
    have hDerivative := hFirstVariation direction
    have hResponseZero :=
      hMetric (metricDerivative direction) (hFull.1 direction)
    rw [hResponseZero] at hDerivative
    exact hDerivative

/-- **Null-edge parameter endpoint.** If one parameter action has the local
Einstein first variation through a full local metric Jacobian, its ordinary
stationarity is equivalent to the pointwise finite Einstein equation. -/
theorem parameterStationary_iff_localFiniteEinsteinEquation
    (action : P -> Real) (baseParameter : P)
    (metricDerivative : P →ₗ[Real] LocalTensor (Site := Site))
    (kappa : Real) (ricci : LocalTensor (Site := Site))
    (scalarCurvature : Site -> Real) (metric : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) (stress : LocalTensor (Site := Site))
    (hFirstVariation : HasPulledBackLocalEinsteinFirstVariation action
      baseParameter metricDerivative kappa
      (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
        (metric site) cosmologicalConstant)
      stress)
    (hFull : IsFullLocalSymmetricMetricDerivative metricDerivative)
    (hRicci : LocalSymmetric ricci) (hMetric : LocalSymmetric metric)
    (hStress : LocalSymmetric stress) (hKappa : Not (kappa = 0)) :
    ParameterStationary action baseParameter <->
      LocalFiniteEinsteinEquation kappa ricci scalarCurvature metric
        cosmologicalConstant stress :=
  (parameterStationary_iff_localMetricStationary action baseParameter
    metricDerivative kappa _ stress hFirstVariation hFull).trans
      (localMetricStationary_iff_localFiniteEinsteinEquation kappa ricci
        scalarCurvature metric cosmologicalConstant stress hRicci hMetric
        hStress hKappa)

end ParameterPullback

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LocalEinsteinEquationVariation.localMetricStationary_iff_localFiniteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localMetricStationary_iff_localFiniteEinsteinEquation

/-- info: 'PhysicsSM.Draft.NullEdge.LocalEinsteinEquationVariation.localActionMetricStationary_iff_localFiniteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localActionMetricStationary_iff_localFiniteEinsteinEquation

/-- info: 'PhysicsSM.Draft.NullEdge.LocalEinsteinEquationVariation.parameterStationary_iff_localFiniteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parameterStationary_iff_localFiniteEinsteinEquation

end PhysicsSM.Draft.NullEdge.LocalEinsteinEquationVariation
