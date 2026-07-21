import PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryCancellation

/-!
# Finite Palatini boundary flux and interior Einstein equation

The closed-carrier cancellation theorem sums the incidence divergence over
every vertex. This module localizes that identity to a chosen finite interior.
The residual is then exactly the oriented flux through the cut separating the
interior from its complement:

```text
sum_(x in interior) div(flux)(x) = incoming cut flux - outgoing cut flux.
```

This gives a finite boundary form of the Palatini variation. If a boundary
counterterm cancels the cut flux for every symmetric metric variation
supported in the interior, ordinary stationarity of the resulting action is
equivalent to the finite Einstein equation at every interior site.

Claim labels: exact finite boundary identity and conditional finite action
theorem. The cut flux is an incidence boundary term; this module does not
identify it with the continuum Gibbons--Hawking--York term, construct the
required counterterm from null-edge geometry, or prove a continuum limit.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryFlux

open scoped BigOperators
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open LocalEinsteinEquationVariation
open FiniteEinsteinHilbertActionResponse
open FinitePalatiniEinsteinHilbertVariation
open FinitePalatiniBoundaryCancellation

variable {Vertex Edge : Type*} [Fintype Vertex] [Fintype Edge]
  [DecidableEq Vertex]

/-! ## Exact cut-flux identity -/

/-- Oriented flux through the cut of `interior`. An edge entering the interior
contributes positively, an edge leaving contributes negatively, and an edge
with both endpoints on the same side contributes zero. -/
def cutBoundaryFlux
    (interior : Finset Vertex)
    (source target : Edge -> Vertex) (flux : Edge -> Real) : Real :=
  ∑ edge : Edge,
    if source edge ∈ interior then
      if target edge ∈ interior then 0 else -flux edge
    else
      if target edge ∈ interior then flux edge else 0

omit [Fintype Vertex] in
/-- **Finite regional divergence theorem.** The incidence divergence summed
over a chosen interior is exactly its oriented cut flux. -/
theorem sum_interior_incidenceDivergence_eq_cutBoundaryFlux
    (interior : Finset Vertex)
    (source target : Edge -> Vertex) (flux : Edge -> Real) :
    (∑ vertex ∈ interior,
      incidenceDivergence source target flux vertex) =
      cutBoundaryFlux interior source target flux := by
  classical
  unfold incidenceDivergence cutBoundaryFlux
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro edge _
  by_cases hSource : source edge ∈ interior <;>
    by_cases hTarget : target edge ∈ interior <;>
      simp [hSource, hTarget]

/-- The regional theorem recovers the closed-carrier cancellation because the
cut of the full vertex set is empty. -/
theorem cutBoundaryFlux_univ_eq_zero
    (source target : Edge -> Vertex) (flux : Edge -> Real) :
    cutBoundaryFlux (Finset.univ : Finset Vertex) source target flux = 0 := by
  classical
  simp [cutBoundaryFlux]

/-- The one-edge witness has nonzero inward flux through the singleton
interior containing its target. -/
theorem witness_cutBoundaryFlux_singleton_target :
    cutBoundaryFlux ({1} : Finset (Fin 2)) witnessSource witnessTarget
      witnessFlux = 1 := by
  norm_num [cutBoundaryFlux, witnessSource, witnessTarget, witnessFlux,
    Fin.sum_univ_one]

/-- The regional divergence theorem is nonvacuous: the target-only interior
has total divergence one, although the full two-vertex carrier has total
divergence zero. -/
theorem witness_interior_divergence_nonzero :
    (∑ vertex ∈ ({1} : Finset (Fin 2)),
      incidenceDivergence witnessSource witnessTarget witnessFlux vertex) =
        1 := by
  rw [sum_interior_incidenceDivergence_eq_cutBoundaryFlux]
  exact witness_cutBoundaryFlux_singleton_target

/-! ## Interior Palatini response -/

/-- Pointwise Ricci-plus-divergence response on a chosen interior. -/
def HasInteriorPointwisePalatiniDivergence
    (interior : Finset Vertex)
    (source target : Edge -> Vertex)
    (volume curvatureResponse : Vertex -> Real)
    (ricci variation : LocalTensor (Site := Vertex))
    (flux : Edge -> Real) : Prop :=
  forall vertex, vertex ∈ interior ->
    volume vertex * curvatureResponse vertex =
      volume vertex *
          metricVariationPairing (ricci vertex) (variation vertex) +
        incidenceDivergence source target flux vertex

/-- Integrated Palatini response on an interior with an explicit boundary
response. -/
def HasInteriorPalatiniCurvatureResponse
    (interior : Finset Vertex)
    (volume : Vertex -> Real)
    (ricci variation : LocalTensor (Site := Vertex))
    (curvatureResponse : Vertex -> Real)
    (boundaryResponse : Real) : Prop :=
  (∑ vertex ∈ interior, volume vertex * curvatureResponse vertex) =
    (∑ vertex ∈ interior,
      volume vertex *
        metricVariationPairing (ricci vertex) (variation vertex)) +
      boundaryResponse

omit [Fintype Vertex] in
/-- A pointwise Ricci-plus-divergence identity integrates to the Palatini
identity whose boundary response is the exact cut flux. -/
theorem interiorPointwisePalatini_implies_cutBoundaryResponse
    (interior : Finset Vertex)
    (source target : Edge -> Vertex)
    (volume curvatureResponse : Vertex -> Real)
    (ricci variation : LocalTensor (Site := Vertex))
    (flux : Edge -> Real)
    (hPointwise : HasInteriorPointwisePalatiniDivergence interior source
      target volume curvatureResponse ricci variation flux) :
    HasInteriorPalatiniCurvatureResponse interior volume ricci variation
      curvatureResponse (cutBoundaryFlux interior source target flux) := by
  unfold HasInteriorPalatiniCurvatureResponse
  calc
    (∑ vertex ∈ interior, volume vertex * curvatureResponse vertex) =
        ∑ vertex ∈ interior,
          (volume vertex *
              metricVariationPairing (ricci vertex) (variation vertex) +
            incidenceDivergence source target flux vertex) := by
          apply Finset.sum_congr rfl
          intro vertex hVertex
          exact hPointwise vertex hVertex
    _ = (∑ vertex ∈ interior,
          volume vertex *
            metricVariationPairing (ricci vertex) (variation vertex)) +
        ∑ vertex ∈ interior,
          incidenceDivergence source target flux vertex := by
          rw [Finset.sum_add_distrib]
    _ = (∑ vertex ∈ interior,
          volume vertex *
            metricVariationPairing (ricci vertex) (variation vertex)) +
        cutBoundaryFlux interior source target flux := by
          rw [sum_interior_incidenceDivergence_eq_cutBoundaryFlux]

omit [Fintype Vertex] in
/-- An added boundary response that is the negative cut flux removes the
Palatini boundary residual from the interior variation. -/
theorem interiorPalatini_plus_boundaryCounterterm
    (interior : Finset Vertex)
    (source target : Edge -> Vertex)
    (volume curvatureResponse : Vertex -> Real)
    (ricci variation : LocalTensor (Site := Vertex))
    (flux : Edge -> Real) (boundaryCountertermResponse : Real)
    (hPointwise : HasInteriorPointwisePalatiniDivergence interior source
      target volume curvatureResponse ricci variation flux)
    (hCancel : cutBoundaryFlux interior source target flux +
      boundaryCountertermResponse = 0) :
    (∑ vertex ∈ interior, volume vertex * curvatureResponse vertex) +
        boundaryCountertermResponse =
      ∑ vertex ∈ interior,
        volume vertex *
          metricVariationPairing (ricci vertex) (variation vertex) := by
  have hResponse := interiorPointwisePalatini_implies_cutBoundaryResponse
    interior source target volume curvatureResponse ricci variation flux
    hPointwise
  unfold HasInteriorPalatiniCurvatureResponse at hResponse
  rw [hResponse]
  linarith

/-! ## Fixed-boundary interior metric variations -/

variable {Site : Type*} [Fintype Site] [DecidableEq Site]

/-- A local variation is supported in the chosen interior. Thus all sites
outside the interior, including the fixed boundary data, remain unchanged. -/
def SupportedIn
    (interior : Finset Site)
    (variation : LocalTensor (Site := Site)) : Prop :=
  forall site, site ∉ interior -> variation site = 0

/-- Volume-weighted Einstein-matter response restricted to the interior. -/
def weightedInteriorTotalMetricFirstVariation
    (interior : Finset Site)
    (kappa : Real) (volume : Site -> Real)
    (einstein stress variation : LocalTensor (Site := Site)) : Real :=
  ∑ site ∈ interior,
    volume site *
      totalMetricFirstVariation kappa (einstein site) (stress site)
        (variation site)

/-- Stationarity against all symmetric metric variations supported in the
interior. -/
def InteriorMetricStationary
    (interior : Finset Site)
    (kappa : Real) (volume : Site -> Real)
    (einstein stress : LocalTensor (Site := Site)) : Prop :=
  forall variation : LocalTensor (Site := Site),
    LocalSymmetric variation -> SupportedIn interior variation ->
      weightedInteriorTotalMetricFirstVariation interior kappa volume
        einstein stress variation = 0

/-- The finite Einstein equation at every site of a chosen interior. -/
def InteriorFiniteEinsteinEquation
    (interior : Finset Site)
    (kappa : Real) (ricci : LocalTensor (Site := Site))
    (scalarCurvature : Site -> Real)
    (metric : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (stress : LocalTensor (Site := Site)) : Prop :=
  forall site, site ∈ interior ->
    FiniteEinsteinEquation kappa (ricci site) (scalarCurvature site)
      (metric site) cosmologicalConstant (stress site)

omit [Fintype Site] [DecidableEq Site] in
/-- Nonzero interior volumes make supported weighted stationarity equivalent
to component stationarity at every interior site. -/
theorem interiorMetricStationary_iff_pointwiseMetricStationary
    (interior : Finset Site)
    (kappa : Real) (volume : Site -> Real)
    (einstein stress : LocalTensor (Site := Site))
    (hVolume : forall site, site ∈ interior -> volume site ≠ 0) :
    InteriorMetricStationary interior kappa volume einstein stress <->
      forall site, site ∈ interior ->
        MetricStationary kappa (einstein site) (stress site) := by
  classical
  constructor
  · intro hInterior site hSite variation hVariation
    let supported : LocalTensor (Site := Site) := fun other =>
      if other = site then variation else 0
    have hSupportedSymmetric : LocalSymmetric supported := by
      intro other
      by_cases hOther : other = site
      · simp only [supported, hOther, if_true]
        exact hVariation
      · simp only [supported, hOther, if_false]
        exact Matrix.isSymm_zero
    have hSupported : SupportedIn interior supported := by
      intro other hOther
      by_cases hEqual : other = site
      · subst other
        exact False.elim (hOther hSite)
      · simp [supported, hEqual]
    have hResponse := hInterior supported hSupportedSymmetric hSupported
    unfold weightedInteriorTotalMetricFirstVariation at hResponse
    rw [Finset.sum_eq_single site] at hResponse
    · have hProduct :
          volume site * totalMetricFirstVariation kappa (einstein site)
            (stress site) variation = 0 := by
        simpa [supported] using hResponse
      exact (mul_eq_zero.mp hProduct).resolve_left (hVolume site hSite)
    · intro other hOther hNotEqual
      rw [show supported other = 0 by simp [supported, hNotEqual]]
      unfold totalMetricFirstVariation
        StressEnergyPhysicalControls.metricVariationPairing
      simp
    · simp [hSite]
  · intro hPointwise variation hVariation _
    unfold weightedInteriorTotalMetricFirstVariation
    apply Finset.sum_eq_zero
    intro site hSite
    rw [hPointwise site hSite (variation site) (hVariation site)]
    ring

omit [Fintype Site] [DecidableEq Site] in
/-- **Interior finite Einstein equation.** Fixed-boundary stationarity is
equivalent to the tensor equation at every interior site. -/
theorem interiorMetricStationary_iff_interiorFiniteEinsteinEquation
    (interior : Finset Site)
    (kappa : Real) (volume scalarCurvature : Site -> Real)
    (ricci metric stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hVolume : forall site, site ∈ interior -> volume site ≠ 0)
    (hRicci : LocalSymmetric ricci) (hMetric : LocalSymmetric metric)
    (hStress : LocalSymmetric stress) (hKappa : Not (kappa = 0)) :
    InteriorMetricStationary interior kappa volume
        (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
          (metric site) cosmologicalConstant)
        stress <->
      InteriorFiniteEinsteinEquation interior kappa ricci scalarCurvature
        metric cosmologicalConstant stress := by
  rw [interiorMetricStationary_iff_pointwiseMetricStationary interior kappa
    volume _ stress hVolume]
  constructor
  · intro hStationary site hSite
    exact (metricStationary_iff_finiteEinsteinEquation kappa (ricci site)
      (scalarCurvature site) (metric site) cosmologicalConstant (stress site)
      (hRicci site) (hMetric site) (hStress site) hKappa).mp
        (hStationary site hSite)
  · intro hEquation site hSite
    exact (metricStationary_iff_finiteEinsteinEquation kappa (ricci site)
      (scalarCurvature site) (metric site) cosmologicalConstant (stress site)
      (hRicci site) (hMetric site) (hStress site) hKappa).mpr
        (hEquation site hSite)

/-! ## Interior Palatini-to-Einstein action chain -/

/-- Volume-weighted tensor pairing restricted to the interior. -/
def weightedInteriorMetricPairing
    (interior : Finset Site) (volume : Site -> Real)
    (coefficient variation : LocalTensor (Site := Site)) : Real :=
  ∑ site ∈ interior,
    volume site *
      metricVariationPairing (coefficient site) (variation site)

/-- Standard inverse-metric volume response at every interior site. -/
def HasInteriorInverseMetricVolumeResponse
    (interior : Finset Site)
    (volume volumeResponse : Site -> Real)
    (metric variation : LocalTensor (Site := Site)) : Prop :=
  forall site, site ∈ interior ->
    volumeResponse site =
      -(volume site / 2) *
        metricVariationPairing (metric site) (variation site)

/-- Einstein--Hilbert bulk response restricted to the chosen interior. -/
def interiorEinsteinHilbertBulkResponse
    (interior : Finset Site)
    (volume volumeResponse scalarCurvature curvatureResponse : Site -> Real)
    (cosmologicalConstant : Real) : Real :=
  ∑ site ∈ interior,
    (volumeResponse site *
        (scalarCurvature site - 2 * cosmologicalConstant) +
      volume site * curvatureResponse site)

omit [Fintype Site] in
/-- The interior volume and curvature channels combine into the weighted
Einstein pairing plus the exact cut flux. -/
theorem interiorEinsteinHilbertBulkResponse_eq_weightedEinsteinPairing
    (interior : Finset Site)
    (source target : Edge -> Site)
    (volume volumeResponse scalarCurvature curvatureResponse : Site -> Real)
    (ricci metric variation : LocalTensor (Site := Site))
    (flux : Edge -> Real) (cosmologicalConstant : Real)
    (hVolumeResponse : HasInteriorInverseMetricVolumeResponse interior volume
      volumeResponse metric variation)
    (hPointwise : HasInteriorPointwisePalatiniDivergence interior source
      target volume curvatureResponse ricci variation flux) :
    interiorEinsteinHilbertBulkResponse interior volume volumeResponse
        scalarCurvature curvatureResponse cosmologicalConstant =
      weightedInteriorMetricPairing interior volume
        (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
          (metric site) cosmologicalConstant)
        variation + cutBoundaryFlux interior source target flux := by
  have hPalatini := interiorPointwisePalatini_implies_cutBoundaryResponse
    interior source target volume curvatureResponse ricci variation flux
    hPointwise
  unfold interiorEinsteinHilbertBulkResponse
  rw [Finset.sum_add_distrib]
  unfold HasInteriorPalatiniCurvatureResponse at hPalatini
  rw [hPalatini]
  rw [← add_assoc]
  congr 1
  unfold weightedInteriorMetricPairing
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro site hSite
  rw [hVolumeResponse site hSite,
    metricVariationPairing_finiteEinsteinLHS]
  ring

/-- Normalized interior gravity-plus-matter response. The gravitational input
includes both the bulk response and any boundary-counterterm response. -/
def normalizedInteriorEinsteinHilbertMatterResponse
    (interior : Finset Site) (kappa : Real)
    (gravityResponse : Real) (volume : Site -> Real)
    (stress variation : LocalTensor (Site := Site)) : Real :=
  (1 / (2 * kappa)) * gravityResponse -
    (1 / 2) * weightedInteriorMetricPairing interior volume stress variation

omit [Fintype Site] in
/-- Cut-flux cancellation converts the decomposed interior
Einstein--Hilbert-plus-matter response into the weighted Einstein response. -/
theorem normalizedInteriorResponse_eq_weightedInteriorTotalMetricFirstVariation
    (interior : Finset Site)
    (source target : Edge -> Site)
    (kappa : Real)
    (volume volumeResponse scalarCurvature curvatureResponse : Site -> Real)
    (ricci metric stress variation : LocalTensor (Site := Site))
    (flux : Edge -> Real) (cosmologicalConstant boundaryResponse : Real)
    (hKappa : Not (kappa = 0))
    (hVolumeResponse : HasInteriorInverseMetricVolumeResponse interior volume
      volumeResponse metric variation)
    (hPointwise : HasInteriorPointwisePalatiniDivergence interior source
      target volume curvatureResponse ricci variation flux)
    (hBoundary : cutBoundaryFlux interior source target flux +
      boundaryResponse = 0) :
    normalizedInteriorEinsteinHilbertMatterResponse interior kappa
        (interiorEinsteinHilbertBulkResponse interior volume volumeResponse
          scalarCurvature curvatureResponse cosmologicalConstant +
          boundaryResponse)
        volume stress variation =
      weightedInteriorTotalMetricFirstVariation interior kappa volume
        (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
          (metric site) cosmologicalConstant)
        stress variation := by
  rw [interiorEinsteinHilbertBulkResponse_eq_weightedEinsteinPairing interior
    source target volume volumeResponse scalarCurvature curvatureResponse
    ricci metric variation flux cosmologicalConstant hVolumeResponse
    hPointwise]
  unfold normalizedInteriorEinsteinHilbertMatterResponse
  rw [add_assoc, hBoundary, add_zero]
  unfold weightedInteriorTotalMetricFirstVariation
    weightedInteriorMetricPairing
  simp_rw [totalMetricFirstVariation_eq_standard _ _ _ _ hKappa]
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro site _
  ring

/-- An actual local-metric action has the weighted interior Einstein first
variation in every symmetric fixed-boundary direction. -/
def HasInteriorEinsteinMetricFirstVariation
    (interior : Finset Site)
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site))
    (kappa : Real) (volume : Site -> Real)
    (einstein stress : LocalTensor (Site := Site)) : Prop :=
  forall variation : LocalTensor (Site := Site),
    LocalSymmetric variation -> SupportedIn interior variation ->
      HasDerivAt
        (fun t : Real => action (baseMetric + t • variation))
        (weightedInteriorTotalMetricFirstVariation interior kappa volume
          einstein stress variation) 0

/-- Ordinary stationarity of an action under symmetric variations supported
in the interior. -/
def InteriorActionMetricStationary
    (interior : Finset Site)
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site)) : Prop :=
  forall variation : LocalTensor (Site := Site),
    LocalSymmetric variation -> SupportedIn interior variation ->
      HasDerivAt (fun t : Real => action (baseMetric + t • variation)) 0 0

omit [Fintype Site] [DecidableEq Site] in
/-- Actual fixed-boundary action stationarity is equivalent to vanishing of
its weighted interior Einstein response. -/
theorem interiorActionMetricStationary_iff_interiorMetricStationary
    (interior : Finset Site)
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site))
    (kappa : Real) (volume : Site -> Real)
    (einstein stress : LocalTensor (Site := Site))
    (hFirstVariation : HasInteriorEinsteinMetricFirstVariation interior action
      baseMetric kappa volume einstein stress) :
    InteriorActionMetricStationary interior action baseMetric <->
      InteriorMetricStationary interior kappa volume einstein stress := by
  constructor
  · intro hAction variation hVariation hSupported
    exact (hFirstVariation variation hVariation hSupported).unique
      (hAction variation hVariation hSupported)
  · intro hMetric variation hVariation hSupported
    have hDerivative := hFirstVariation variation hVariation hSupported
    rw [hMetric variation hVariation hSupported] at hDerivative
    exact hDerivative

/-- Decomposed interior Palatini first variation with a boundary response that
cancels the graph cut flux in every fixed-boundary metric direction. -/
def HasFixedBoundaryInteriorPalatiniFirstVariation
    (interior : Finset Site)
    (source target : Edge -> Site)
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site))
    (kappa : Real) (volume scalarCurvature : Site -> Real)
    (ricci metric stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (volumeResponse curvatureResponse :
      LocalTensor (Site := Site) -> Site -> Real)
    (fluxResponse : LocalTensor (Site := Site) -> Edge -> Real)
    (boundaryResponse : LocalTensor (Site := Site) -> Real) : Prop :=
  forall variation : LocalTensor (Site := Site),
    LocalSymmetric variation -> SupportedIn interior variation ->
      HasInteriorInverseMetricVolumeResponse interior volume
          (volumeResponse variation) metric variation ∧
        HasInteriorPointwisePalatiniDivergence interior source target volume
          (curvatureResponse variation) ricci variation
          (fluxResponse variation) ∧
        cutBoundaryFlux interior source target (fluxResponse variation) +
            boundaryResponse variation = 0 ∧
        HasDerivAt
          (fun t : Real => action (baseMetric + t • variation))
          (normalizedInteriorEinsteinHilbertMatterResponse interior kappa
            (interiorEinsteinHilbertBulkResponse interior volume
                (volumeResponse variation) scalarCurvature
                (curvatureResponse variation) cosmologicalConstant +
              boundaryResponse variation)
            volume stress variation) 0

omit [Fintype Site] in
/-- The decomposed Palatini and cut-cancellation data produce the interior
Einstein first variation of the same actual action. -/
theorem fixedBoundaryPalatini_implies_interiorEinsteinFirstVariation
    (interior : Finset Site)
    (source target : Edge -> Site)
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site))
    (kappa : Real) (volume scalarCurvature : Site -> Real)
    (ricci metric stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (volumeResponse curvatureResponse :
      LocalTensor (Site := Site) -> Site -> Real)
    (fluxResponse : LocalTensor (Site := Site) -> Edge -> Real)
    (boundaryResponse : LocalTensor (Site := Site) -> Real)
    (hKappa : Not (kappa = 0))
    (hFirstVariation : HasFixedBoundaryInteriorPalatiniFirstVariation
      interior source target action baseMetric kappa volume scalarCurvature
      ricci metric stress cosmologicalConstant volumeResponse
      curvatureResponse fluxResponse boundaryResponse) :
    HasInteriorEinsteinMetricFirstVariation interior action baseMetric kappa
      volume
      (fun site => finiteEinsteinLHS (ricci site) (scalarCurvature site)
        (metric site) cosmologicalConstant)
      stress := by
  intro variation hVariation hSupported
  obtain ⟨hVolumeResponse, hPointwise, hBoundary, hDerivative⟩ :=
    hFirstVariation variation hVariation hSupported
  rw [normalizedInteriorResponse_eq_weightedInteriorTotalMetricFirstVariation
    interior source target kappa volume (volumeResponse variation)
    scalarCurvature (curvatureResponse variation) ricci metric stress variation
    (fluxResponse variation) cosmologicalConstant (boundaryResponse variation)
    hKappa hVolumeResponse hPointwise hBoundary] at hDerivative
  exact hDerivative

omit [Fintype Site] in
/-- **Fixed-boundary null-edge action to interior Einstein equation.** A
decomposed Palatini action whose boundary response cancels the exact cut flux
is stationary under all interior-supported metric variations exactly when the
finite Einstein equation holds at every interior site. -/
theorem fixedBoundaryPalatiniActionStationary_iff_interiorEinsteinEquation
    (interior : Finset Site)
    (source target : Edge -> Site)
    (action : LocalTensor (Site := Site) -> Real)
    (baseMetric : LocalTensor (Site := Site))
    (kappa : Real) (volume scalarCurvature : Site -> Real)
    (ricci metric stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (volumeResponse curvatureResponse :
      LocalTensor (Site := Site) -> Site -> Real)
    (fluxResponse : LocalTensor (Site := Site) -> Edge -> Real)
    (boundaryResponse : LocalTensor (Site := Site) -> Real)
    (hVolume : forall site, site ∈ interior -> volume site ≠ 0)
    (hRicci : LocalSymmetric ricci) (hMetric : LocalSymmetric metric)
    (hStress : LocalSymmetric stress) (hKappa : Not (kappa = 0))
    (hFirstVariation : HasFixedBoundaryInteriorPalatiniFirstVariation
      interior source target action baseMetric kappa volume scalarCurvature
      ricci metric stress cosmologicalConstant volumeResponse
      curvatureResponse fluxResponse boundaryResponse) :
    InteriorActionMetricStationary interior action baseMetric <->
      InteriorFiniteEinsteinEquation interior kappa ricci scalarCurvature
        metric cosmologicalConstant stress :=
  (interiorActionMetricStationary_iff_interiorMetricStationary interior action
    baseMetric kappa volume _ stress
    (fixedBoundaryPalatini_implies_interiorEinsteinFirstVariation interior
      source target action baseMetric kappa volume scalarCurvature ricci metric
      stress cosmologicalConstant volumeResponse curvatureResponse fluxResponse
      boundaryResponse hKappa hFirstVariation)).trans
    (interiorMetricStationary_iff_interiorFiniteEinsteinEquation interior kappa
      volume scalarCurvature ricci metric stress cosmologicalConstant hVolume
      hRicci hMetric hStress hKappa)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryFlux.sum_interior_incidenceDivergence_eq_cutBoundaryFlux' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sum_interior_incidenceDivergence_eq_cutBoundaryFlux

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryFlux.witness_interior_divergence_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_interior_divergence_nonzero

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryFlux.normalizedInteriorResponse_eq_weightedInteriorTotalMetricFirstVariation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalizedInteriorResponse_eq_weightedInteriorTotalMetricFirstVariation

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryFlux.fixedBoundaryPalatiniActionStationary_iff_interiorEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixedBoundaryPalatiniActionStationary_iff_interiorEinsteinEquation

end PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryFlux
