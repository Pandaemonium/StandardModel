import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinResponse

/-!
# Regional nonlinear Lorentz--Palatini action

The nonlinear null-edge Palatini action is a sum of plaquette terms based at
finite carrier sites. This module restricts that concrete action to a chosen
interior by setting the complementary coframe face to zero outside the
interior. The link holonomies remain the exact group-valued plaquettes of the
ambient carrier.

Two independent masks implement fixed-boundary variation:

* coframe lines vary only at sites in the selected interior;
* exponential link curves vary only a supplied finite set of dynamical links.

The ordinary derivatives of this one regional action are then equivalent to
the regional link Euler coefficients and the sixteen coframe Euler
coefficients at each interior site. For an invertible coframe, the latter are
equivalent to the mixed vacuum Einstein equations of the extracted plaquette
curvature.

Claim label: exact finite regional action theorem. The ambient shifts are still
finite equivalences, while the action support and variations are open-region
data. This module does not construct a continuum boundary functional, prove a
nonflat stationary branch, or identify the regional link equation with exact
finite-spacing Levi--Civita transport.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniRegionalAction

open scoped BigOperators
open FinitePeriodicLinkConnection
open LorentzBivectorKreinBridge
open NonlinearLorentzPalatiniAction
open NonlinearLorentzPalatiniCurveDerivative
open NonlinearLorentzPalatiniEuler
open NonlinearLorentzPalatiniCoframeVariation
open NonlinearLorentzPalatiniCurvatureExtraction
open NonlinearLorentzPalatiniEinsteinBridge

variable {Site : Type*} [Fintype Site] [DecidableEq Site]

/-! ## Regional fields and fixed-boundary curves -/

/-- Keep a coframe field on the selected interior and set its face-generating
value to zero outside. Since the complementary Palatini face is quadratic in
the coframe, this deletes precisely the plaquette terms based outside the
interior. -/
def regionalCoframe
    (interior : Finset Site) (coframe : CoframeField Site) :
    CoframeField Site :=
  fun site => if site ∈ interior then coframe site else 0

/-- Keep a link variation only on the supplied set of dynamical directed
links. Every other link is fixed boundary data. -/
def regionalLinkVariation
    (dynamicalLinks : Finset (Site × Fin 4))
    (variation : LinkVariation Site) : LinkVariation Site :=
  fun site direction =>
    if (site, direction) ∈ dynamicalLinks then variation site direction else 0

/-- Affine coframe line that leaves every site outside the selected interior
fixed. -/
def fixedBoundaryCoframeLine
    (interior : Finset Site) (coframe variation : CoframeField Site)
    (t : Real) : CoframeField Site :=
  fun site =>
    if site ∈ interior then coframe site + t • variation site else coframe site

@[simp]
theorem regionalCoframe_apply_of_mem
    (interior : Finset Site) (coframe : CoframeField Site)
    (site : Site) (hSite : site ∈ interior) :
    regionalCoframe interior coframe site = coframe site := by
  simp [regionalCoframe, hSite]

@[simp]
theorem regionalCoframe_apply_of_not_mem
    (interior : Finset Site) (coframe : CoframeField Site)
    (site : Site) (hSite : site ∉ interior) :
    regionalCoframe interior coframe site = 0 := by
  simp [regionalCoframe, hSite]

/-- Restricting a fixed-boundary line is the ordinary affine line through the
restricted base field in the restricted direction. -/
theorem regionalCoframe_fixedBoundaryCoframeLine
    (interior : Finset Site) (coframe variation : CoframeField Site)
    (t : Real) :
    regionalCoframe interior
        (fixedBoundaryCoframeLine interior coframe variation t) =
      coframeLine (regionalCoframe interior coframe)
        (regionalCoframe interior variation) t := by
  funext site
  by_cases hSite : site ∈ interior <;>
    simp [regionalCoframe, fixedBoundaryCoframeLine, coframeLine, hSite]

/-- A one-component coframe probe at an interior site survives the regional
mask unchanged. -/
theorem regionalCoframe_componentProbe_of_mem
    (interior : Finset Site) (site : Site) (hSite : site ∈ interior)
    (internal direction : Fin 4) :
    regionalCoframe interior
        (nonlinearCoframeComponentProbe site internal direction) =
      nonlinearCoframeComponentProbe site internal direction := by
  funext other
  by_cases hOther : other = site
  · subst other
    simp [regionalCoframe, hSite]
  · simp [regionalCoframe, nonlinearCoframeComponentProbe, hOther]

/-- A one-component link probe on a dynamical link survives the regional mask
unchanged. -/
theorem regionalLinkVariation_componentProbe_of_mem
    (dynamicalLinks : Finset (Site × Fin 4))
    (site : Site) (direction : Fin 4)
    (hLink : (site, direction) ∈ dynamicalLinks) (component : Fin 6) :
    regionalLinkVariation dynamicalLinks
        (nonlinearLinkComponentProbe site direction component) =
      nonlinearLinkComponentProbe site direction component := by
  funext other otherDirection otherComponent
  by_cases hOther : other = site
  · subst other
    by_cases hDirection : otherDirection = direction
    · subst otherDirection
      simp [regionalLinkVariation, nonlinearLinkComponentProbe, hLink]
    · simp [regionalLinkVariation, nonlinearLinkComponentProbe, hDirection]
  · simp [regionalLinkVariation, nonlinearLinkComponentProbe, hOther]

/-! ## The concrete regional action -/

/-- The nonlinear Lorentz--Palatini action restricted to plaquettes based in
the selected interior. Holonomies are not linearized or truncated. -/
def nonlinearCoframePlaquetteRegionalAction
    (interior : Finset Site) (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    Real :=
  nonlinearCoframePlaquetteAction shift connection
    (regionalCoframe interior coframe)

/-- The full vertex set recovers the existing nonlinear action exactly. -/
theorem nonlinearCoframePlaquetteRegionalAction_univ
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    nonlinearCoframePlaquetteRegionalAction Finset.univ shift connection
        coframe =
      nonlinearCoframePlaquetteAction shift connection coframe := by
  unfold nonlinearCoframePlaquetteRegionalAction
  congr 1
  funext site
  simp [regionalCoframe]

/-- Regional restriction commutes with pointwise coframe gauge action. -/
theorem regionalCoframe_gaugeTransform
    (interior : Finset Site) (gauge : Site -> GL4)
    (coframe : CoframeField Site) :
    regionalCoframe interior (coframeGaugeTransform gauge coframe) =
      coframeGaugeTransform gauge (regionalCoframe interior coframe) := by
  funext site
  by_cases hSite : site ∈ interior <;>
    simp [regionalCoframe, coframeGaugeTransform, hSite]

/-- The regional action retains exact pointwise proper-Lorentz gauge
invariance. -/
theorem nonlinearCoframePlaquetteRegionalAction_gaugeTransform
    (interior : Finset Site)
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (gauge : Site -> GL4)
    (hGauge : forall site, IsEtaLorentz (unitMatrix (gauge site)))
    (hProper : forall site, (unitMatrix (gauge site)).det = 1)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    nonlinearCoframePlaquetteRegionalAction interior shift
        (gaugeTransform shift gauge connection)
        (coframeGaugeTransform gauge coframe) =
      nonlinearCoframePlaquetteRegionalAction interior shift connection
        coframe := by
  unfold nonlinearCoframePlaquetteRegionalAction
  rw [regionalCoframe_gaugeTransform]
  exact nonlinearCoframePlaquetteAction_gaugeTransform shift hCommute gauge
    hGauge hProper connection (regionalCoframe interior coframe)

/-! ## Ordinary derivatives of the regional action -/

/-- Exact derivative of the regional action along a group-valued exponential
link curve. -/
theorem hasDerivAt_nonlinearCoframePlaquetteRegionalAction_exponentialLinkCurve
    (interior : Finset Site) (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (variation : LinkVariation Site) :
    HasDerivAt
      (fun t => nonlinearCoframePlaquetteRegionalAction interior shift
        (exponentialLinkCurve connection variation t) coframe)
      (nonlinearCoframePlaquetteFirstResponse shift connection
        (regionalCoframe interior coframe) variation) 0 := by
  exact hasDerivAt_nonlinearCoframePlaquetteAction_exponentialLinkCurve shift
    connection (regionalCoframe interior coframe) variation

/-- Exact derivative of the regional action along a fixed-boundary affine
coframe line. -/
theorem hasDerivAt_nonlinearCoframePlaquetteRegionalAction_coframeLine
    (interior : Finset Site) (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe variation : CoframeField Site) :
    HasDerivAt
      (fun t => nonlinearCoframePlaquetteRegionalAction interior shift
        connection (fixedBoundaryCoframeLine interior coframe variation t))
      (nonlinearCoframePlaquetteCoframeFirstResponse shift connection
        (regionalCoframe interior coframe)
        (regionalCoframe interior variation)) 0 := by
  simpa [nonlinearCoframePlaquetteRegionalAction,
    regionalCoframe_fixedBoundaryCoframeLine] using
      hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine shift connection
        (regionalCoframe interior coframe)
        (regionalCoframe interior variation)

/-! ## Fixed-boundary Euler systems -/

/-- One regional link Euler coefficient. It contains exactly the plaquette
terms based in the selected interior because all other face weights vanish. -/
def regionalLinkEulerCoefficient
    (interior : Finset Site) (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) : Real :=
  nonlinearLinkEulerCoefficient shift connection
    (regionalCoframe interior coframe) site direction component

/-- Ordinary stationarity under exponential variations of exactly the
supplied dynamical links. -/
def RegionalConnectionDerivativeStationary
    (interior : Finset Site) (dynamicalLinks : Finset (Site × Fin 4))
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    Prop :=
  forall variation,
    deriv
      (fun t => nonlinearCoframePlaquetteRegionalAction interior shift
        (exponentialLinkCurve connection
          (regionalLinkVariation dynamicalLinks variation) t)
        coframe) 0 = 0

/-- Ordinary stationarity under affine coframe variations that fix every site
outside the selected interior. -/
def RegionalCoframeDerivativeStationary
    (interior : Finset Site) (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    Prop :=
  forall variation,
    deriv
      (fun t => nonlinearCoframePlaquetteRegionalAction interior shift
        connection (fixedBoundaryCoframeLine interior coframe variation t))
      0 = 0

/-- Both fixed-boundary partial stationarity conditions of the same regional
nonlinear action. -/
def RegionalJointDerivativeStationary
    (interior : Finset Site) (dynamicalLinks : Finset (Site × Fin 4))
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    Prop :=
  RegionalConnectionDerivativeStationary interior dynamicalLinks shift
      connection coframe ∧
    RegionalCoframeDerivativeStationary interior shift connection coframe

/-- Fixed-boundary connection stationarity is exactly vanishing of the six
regional Euler coordinates on every dynamical link. -/
theorem regionalConnectionDerivativeStationary_iff_coefficients
    (interior : Finset Site) (dynamicalLinks : Finset (Site × Fin 4))
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    RegionalConnectionDerivativeStationary interior dynamicalLinks shift
        connection coframe <->
      forall site direction, (site, direction) ∈ dynamicalLinks ->
        forall component,
          regionalLinkEulerCoefficient interior shift connection coframe
            site direction component = 0 := by
  classical
  constructor
  · intro hStationary site direction hLink component
    have hDerivative := hStationary
      (nonlinearLinkComponentProbe site direction component)
    rw [(hasDerivAt_nonlinearCoframePlaquetteRegionalAction_exponentialLinkCurve
      interior shift connection coframe
      (regionalLinkVariation dynamicalLinks
        (nonlinearLinkComponentProbe site direction component))).deriv]
      at hDerivative
    rw [regionalLinkVariation_componentProbe_of_mem dynamicalLinks site
      direction hLink component,
      nonlinearCoframePlaquetteFirstResponse_componentProbe] at hDerivative
    exact hDerivative
  · intro hCoefficients variation
    rw [(hasDerivAt_nonlinearCoframePlaquetteRegionalAction_exponentialLinkCurve
      interior shift connection coframe
      (regionalLinkVariation dynamicalLinks variation)).deriv]
    rw [nonlinearCoframePlaquetteFirstResponse_eq_localEuler]
    apply Finset.sum_eq_zero
    intro site _
    apply Finset.sum_eq_zero
    intro direction _
    rw [nonlinearLinkEulerFunctional_eq_coordinateSum]
    by_cases hLink : (site, direction) ∈ dynamicalLinks
    · apply Finset.sum_eq_zero
      intro component _
      rw [show nonlinearLinkEulerCoefficient shift connection
          (regionalCoframe interior coframe) site direction component =
          regionalLinkEulerCoefficient interior shift connection coframe
            site direction component by rfl,
        hCoefficients site direction hLink component, zero_mul]
    · simp [regionalLinkVariation, hLink]

/-- At an interior basepoint, masking does not change any local coframe Euler
coefficient. -/
theorem nonlinearCoframeEulerCoefficient_regional_of_mem
    (interior : Finset Site) (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (hSite : site ∈ interior)
    (internal direction : Fin 4) :
    nonlinearCoframeEulerCoefficient shift connection
        (regionalCoframe interior coframe) site internal direction =
      nonlinearCoframeEulerCoefficient shift connection coframe site
        internal direction := by
  unfold nonlinearCoframeEulerCoefficient nonlinearCoframeLocalEulerLinearMap
    nonlinearCoframeLocalEulerFunctional
  simp only [regionalCoframe_apply_of_mem interior coframe site hSite]

/-- Fixed-boundary coframe stationarity is exactly vanishing of all sixteen
local tetrad Euler coefficients at every interior site. -/
theorem regionalCoframeDerivativeStationary_iff_coefficients
    (interior : Finset Site) (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    RegionalCoframeDerivativeStationary interior shift connection coframe <->
      forall site, site ∈ interior -> forall internal direction,
        nonlinearCoframeEulerCoefficient shift connection coframe site
          internal direction = 0 := by
  classical
  constructor
  · intro hStationary site hSite internal direction
    have hDerivative := hStationary
      (nonlinearCoframeComponentProbe site internal direction)
    rw [(hasDerivAt_nonlinearCoframePlaquetteRegionalAction_coframeLine
      interior shift connection coframe
      (nonlinearCoframeComponentProbe site internal direction)).deriv]
      at hDerivative
    rw [regionalCoframe_componentProbe_of_mem interior site hSite internal
      direction,
      nonlinearCoframePlaquetteCoframeFirstResponse_componentProbe,
      nonlinearCoframeEulerCoefficient_regional_of_mem interior shift
        connection coframe site hSite] at hDerivative
    exact hDerivative
  · intro hCoefficients variation
    rw [(hasDerivAt_nonlinearCoframePlaquetteRegionalAction_coframeLine
      interior shift connection coframe variation).deriv]
    rw [nonlinearCoframePlaquetteCoframeFirstResponse_eq_localEuler]
    apply Finset.sum_eq_zero
    intro site _
    by_cases hSite : site ∈ interior
    · rw [nonlinearCoframeLocalEulerFunctional_eq_coordinateSum]
      apply Finset.sum_eq_zero
      intro internal _
      apply Finset.sum_eq_zero
      intro direction _
      rw [nonlinearCoframeEulerCoefficient_regional_of_mem interior shift
          connection coframe site hSite,
        hCoefficients site hSite internal direction, zero_mul]
    · change nonlinearCoframeLocalEulerLinearMap shift connection
        (regionalCoframe interior coframe) site
          (regionalCoframe interior variation site) = 0
      rw [regionalCoframe_apply_of_not_mem interior variation site hSite]
      exact LinearMap.map_zero _

/-! ## Interior Einstein equation from the concrete regional action -/

/-- Mixed vacuum Einstein equation for the extracted nonlinear plaquette
curvature at every selected interior site. -/
def InteriorMixedVacuumEinstein
    (interior : Finset Site) (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (inverseCoframe : CoframeField Site) : Prop :=
  forall site, site ∈ interior -> forall coframeDirection raisedDirection,
    2 * mixedRicciCurvature (inverseCoframe site)
        (extractedPlaquetteCurvature shift connection site)
        coframeDirection raisedDirection -
      (1 : Matrix (Fin 4) (Fin 4) Real)
          raisedDirection coframeDirection *
        inverseCoframeScalarCurvature (inverseCoframe site)
          (extractedPlaquetteCurvature shift connection site) = 0

/-- **Concrete fixed-boundary action to interior Einstein equation.** The
ordinary coframe derivative of the regional nonlinear Lorentz--Palatini action
vanishes in every fixed-boundary direction exactly when the extracted
curvature satisfies the mixed vacuum Einstein equation at every interior site.
-/
theorem regionalCoframeDerivativeStationary_iff_interiorMixedVacuumEinstein
    (interior : Finset Site) (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1) :
    RegionalCoframeDerivativeStationary interior shift connection coframe <->
      InteriorMixedVacuumEinstein interior shift connection inverseCoframe := by
  rw [regionalCoframeDerivativeStationary_iff_coefficients]
  constructor
  · intro hEuler site hSite
    exact (nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein shift
      connection coframe inverseCoframe hLeft site).mp (hEuler site hSite)
  · intro hEinstein site hSite
    exact (nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein shift
      connection coframe inverseCoframe hLeft site).mpr
        (hEinstein site hSite)

/-- Joint fixed-boundary stationarity of the same regional action consists of
the regional link equations on the dynamical links and the mixed vacuum
Einstein equations at all interior sites. -/
theorem regionalJointDerivativeStationary_iff_linkEuler_and_interiorEinstein
    (interior : Finset Site) (dynamicalLinks : Finset (Site × Fin 4))
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1) :
    RegionalJointDerivativeStationary interior dynamicalLinks shift connection
        coframe <->
      (forall site direction, (site, direction) ∈ dynamicalLinks ->
        forall component,
          regionalLinkEulerCoefficient interior shift connection coframe
            site direction component = 0) ∧
      InteriorMixedVacuumEinstein interior shift connection inverseCoframe := by
  exact and_congr
    (regionalConnectionDerivativeStationary_iff_coefficients interior
      dynamicalLinks shift connection coframe)
    (regionalCoframeDerivativeStationary_iff_interiorMixedVacuumEinstein
      interior shift connection coframe inverseCoframe hLeft)

/-- Identity links give a nonvacuous flat interior Einstein control for every
regional coframe action. -/
theorem regional_identityConnection_coframeDerivativeStationary
    (interior : Finset Site) (shift : Fin 4 -> Equiv Site Site)
    (coframe : CoframeField Site) :
    RegionalCoframeDerivativeStationary interior shift
      (identityConnection Site) coframe := by
  rw [regionalCoframeDerivativeStationary_iff_coefficients]
  intro site _ internal direction
  exact nonlinearCoframeEulerCoefficient_identityConnection shift coframe site
    internal direction

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniRegionalAction.nonlinearCoframePlaquetteRegionalAction_gaugeTransform' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteRegionalAction_gaugeTransform

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniRegionalAction.regionalConnectionDerivativeStationary_iff_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms regionalConnectionDerivativeStationary_iff_coefficients

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniRegionalAction.regionalCoframeDerivativeStationary_iff_interiorMixedVacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms regionalCoframeDerivativeStationary_iff_interiorMixedVacuumEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniRegionalAction.regionalJointDerivativeStationary_iff_linkEuler_and_interiorEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms regionalJointDerivativeStationary_iff_linkEuler_and_interiorEinstein

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniRegionalAction
