import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative

noncomputable section

/-!
# Nonlinear Lorentz Palatini link Euler coefficient

The scalar ordered plaquette action now has an exact product/inverse derivative
along canonical exponential link curves. This target reorganizes that global
response by varied directed link.
For one link `(x,d)`, the local functional contains four families: the first
and third plaquette-tangent insertions based at `x`, and the second and fourth
insertions reindexed from the unique predecessor sites of the relevant shifts.

This module proves that the global response is the sum of these local
functionals, expands each local functional in the six coordinate probes, and
identifies formal connection stationarity with vanishing of every explicit
local six-component Euler coefficient.

The result is an exact finite identity for the displayed product/inverse
derivative. It does not yet prove Levi-Civita selection.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative

/-- Contribution of one adjoint-transported link generator to one ordered
coframe-face response, including the nonlinear plaquette-holonomy weight. -/
def nonlinearWeightedAdjointFaceResponse
    (face : Fiber 6) (transport : GL4) (probe : Fiber 6)
    (holonomy : GL4) : Real :=
  orderedPlaquetteActionFirstResponse face
    (lorentzAdjoint transport probe * unitMatrix holonomy)

/-- The matrix Lorentz generator is additive in its six bivector
coordinates. -/
lemma lorentzGenerator_add (left right : Fiber 6) :
    lorentzGenerator (left + right) =
      lorentzGenerator left + lorentzGenerator right := by
  ext mu nu
  fin_cases mu <;> fin_cases nu <;>
    simp [lorentzGenerator, bivectorMatrix, MinkowskiConvention.eta,
      Matrix.mul_apply, Fin.sum_univ_four] <;>
    ring

/-- The matrix Lorentz generator respects real scalar multiplication. -/
lemma lorentzGenerator_smul (scalar : Real) (probe : Fiber 6) :
    lorentzGenerator (scalar • probe) = scalar • lorentzGenerator probe := by
  ext mu nu
  fin_cases mu <;> fin_cases nu <;>
    simp [lorentzGenerator, bivectorMatrix, MinkowskiConvention.eta,
      Matrix.mul_apply, Fin.sum_univ_four]

/-- Adjoint transport is additive in the infinitesimal bivector probe. -/
lemma lorentzAdjoint_add (transport : GL4) (left right : Fiber 6) :
    lorentzAdjoint transport (left + right) =
      lorentzAdjoint transport left + lorentzAdjoint transport right := by
  simp [lorentzAdjoint, lorentzGenerator_add, Matrix.mul_add, Matrix.add_mul]

/-- Adjoint transport respects real scalar multiplication of the probe. -/
lemma lorentzAdjoint_smul
    (transport : GL4) (scalar : Real) (probe : Fiber 6) :
    lorentzAdjoint transport (scalar • probe) =
      scalar • lorentzAdjoint transport probe := by
  simp [lorentzAdjoint, lorentzGenerator_smul]

/-- A weighted ordered-face response is linear in its six-component link
probe. -/
lemma nonlinearWeightedAdjointFaceResponse_add
    (face : Fiber 6) (transport : GL4) (left right : Fiber 6)
    (holonomy : GL4) :
    nonlinearWeightedAdjointFaceResponse face transport (left + right)
        holonomy =
      nonlinearWeightedAdjointFaceResponse face transport left holonomy +
        nonlinearWeightedAdjointFaceResponse face transport right holonomy := by
  simp [nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint_add,
    Matrix.add_mul, Matrix.mul_add, Matrix.trace_add]
  ring

/-- A weighted ordered-face response respects real scalar multiplication of
its link probe. -/
lemma nonlinearWeightedAdjointFaceResponse_smul
    (face : Fiber 6) (transport : GL4) (scalar : Real) (probe : Fiber 6)
    (holonomy : GL4) :
    nonlinearWeightedAdjointFaceResponse face transport (scalar • probe)
        holonomy =
      scalar * nonlinearWeightedAdjointFaceResponse face transport probe
        holonomy := by
  simp [nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint_smul,
    Matrix.trace_smul]
  ring

/-- Explicit local nonlinear Euler functional for variation of one directed
link. The four sums correspond in order to the four terms of
`plaquetteAdjointSum`. -/
def nonlinearLinkEulerFunctional
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) : Real :=
  Finset.sum Finset.univ (fun b =>
      nonlinearWeightedAdjointFaceResponse
        (coframeFaceWeight coframe site direction b)
        (connection site direction) probe
        (plaquetteUnit shift connection site direction b)) +
    Finset.sum Finset.univ (fun a =>
      let predecessor := (shift a).symm site
      nonlinearWeightedAdjointFaceResponse
        (coframeFaceWeight coframe predecessor a direction)
        (twoStepUnit shift connection predecessor a direction) probe
        (plaquetteUnit shift connection predecessor a direction)) -
    Finset.sum Finset.univ (fun a =>
      let holonomy := plaquetteUnit shift connection site a direction
      nonlinearWeightedAdjointFaceResponse
        (coframeFaceWeight coframe site a direction)
        (holonomy * connection site direction) probe holonomy) -
    Finset.sum Finset.univ (fun b =>
      let predecessor := (shift b).symm site
      nonlinearWeightedAdjointFaceResponse
        (coframeFaceWeight coframe predecessor direction b)
        (twoStepUnit shift connection predecessor direction b) probe
        (plaquetteUnit shift connection predecessor direction b))

/-- Six ordinary coordinate coefficients of the local nonlinear link Euler
functional. -/
def nonlinearLinkEulerCoefficient
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) : Real :=
  nonlinearLinkEulerFunctional shift connection coframe site direction
    (Pi.single component (1 : Real))

/-- The explicit local nonlinear Euler functional as a real linear map on
the six link-generator coordinates. -/
def nonlinearLinkEulerLinearMap
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (direction : Fin 4) : Fiber 6 →ₗ[Real] Real where
  toFun := nonlinearLinkEulerFunctional shift connection coframe site direction
  map_add' left right := by
    simp [nonlinearLinkEulerFunctional,
      nonlinearWeightedAdjointFaceResponse_add,
      Finset.sum_add_distrib]
    ring
  map_smul' scalar probe := by
    unfold nonlinearLinkEulerFunctional
    simp_rw [nonlinearWeightedAdjointFaceResponse_smul,
      <- Finset.mul_sum]
    simp only [RingHom.id_apply, smul_eq_mul]
    ring

/-- Cycle two direction sums and one site sum from `(a,b,x)` to `(x,a,b)`. -/
lemma sum_direction_direction_site_cycle
    {Site : Type*} [Fintype Site]
    (summand : Fin 4 -> Fin 4 -> Site -> Real) :
    Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site => summand a b site))) =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b => summand a b site))) := by
  calc
    _ = Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun site =>
            Finset.sum Finset.univ (fun b => summand a b site))) := by
      apply Finset.sum_congr rfl
      intro a _
      rw [Finset.sum_comm]
    _ = _ := by rw [Finset.sum_comm]

/-- Reorder `(a,b,x)` to `(x,b,a)`. -/
lemma sum_direction_direction_site_swap_cycle
    {Site : Type*} [Fintype Site]
    (summand : Fin 4 -> Fin 4 -> Site -> Real) :
    Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site => summand a b site))) =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun a => summand a b site))) := by
  rw [sum_direction_direction_site_cycle]
  apply Finset.sum_congr rfl
  intro site _
  rw [Finset.sum_comm]

/-- Reindex the site sum by the first plaquette direction and order the result
as `(variedSite,b,a)`. -/
lemma sum_reindex_first_direction
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (summand : Fin 4 -> Fin 4 -> Site -> Real) :
    Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site => summand a b site))) =
      Finset.sum Finset.univ (fun variedSite =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun a =>
            summand a b ((shift a).symm variedSite)))) := by
  calc
    _ = Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            Finset.sum Finset.univ (fun variedSite =>
              summand a b ((shift a).symm variedSite)))) := by
      apply Finset.sum_congr rfl
      intro a _
      apply Finset.sum_congr rfl
      intro b _
      simpa using Equiv.sum_comp (shift a)
        (fun variedSite => summand a b ((shift a).symm variedSite))
    _ = _ := sum_direction_direction_site_swap_cycle
      (fun a b variedSite => summand a b ((shift a).symm variedSite))

/-- Reindex the site sum by the second plaquette direction and order the
result as `(variedSite,a,b)`. -/
lemma sum_reindex_second_direction
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (summand : Fin 4 -> Fin 4 -> Site -> Real) :
    Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site => summand a b site))) =
      Finset.sum Finset.univ (fun variedSite =>
        Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            summand a b ((shift b).symm variedSite)))) := by
  calc
    _ = Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            Finset.sum Finset.univ (fun variedSite =>
              summand a b ((shift b).symm variedSite)))) := by
      apply Finset.sum_congr rfl
      intro a _
      apply Finset.sum_congr rfl
      intro b _
      simpa using Equiv.sum_comp (shift b)
        (fun variedSite => summand a b ((shift b).symm variedSite))
    _ = _ := sum_direction_direction_site_cycle
      (fun a b variedSite => summand a b ((shift b).symm variedSite))

/-- Splitting the exact four-corner adjoint tangent through one ordered scalar
face response. -/
lemma orderedPlaquetteActionFirstResponse_adjointSum
    {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (variation : LinkVariation Site)
    (face : Fiber 6) (site : Site) (a b : Fin 4) :
    orderedPlaquetteActionFirstResponse face
        (plaquetteAdjointSum shift connection variation site a b *
          unitMatrix (plaquetteUnit shift connection site a b)) =
      nonlinearWeightedAdjointFaceResponse face (connection site a)
          (variation site a) (plaquetteUnit shift connection site a b) +
        nonlinearWeightedAdjointFaceResponse face
          (twoStepUnit shift connection site a b)
          (variation (shift a site) b)
          (plaquetteUnit shift connection site a b) -
        nonlinearWeightedAdjointFaceResponse face
          (plaquetteUnit shift connection site a b * connection site b)
          (variation site b) (plaquetteUnit shift connection site a b) -
        nonlinearWeightedAdjointFaceResponse face
          (twoStepUnit shift connection site a b)
          (variation (shift b site) a)
          (plaquetteUnit shift connection site a b) := by
  simp [plaquetteAdjointSum, nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, Matrix.add_mul, Matrix.sub_mul,
    Matrix.mul_add, Matrix.mul_sub, Matrix.trace_add, Matrix.trace_sub]
  ring

/-- The exact nonlinear global response reorganizes into the sum of
the four-family local link Euler functionals. -/
theorem nonlinearCoframePlaquetteFirstResponse_eq_localEuler
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (variation : LinkVariation Site) :
    nonlinearCoframePlaquetteFirstResponse shift connection coframe variation =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun direction =>
          nonlinearLinkEulerFunctional shift connection coframe site direction
            (variation site direction))) := by
  have hFirst := sum_direction_direction_site_cycle
    (fun a b site =>
      nonlinearWeightedAdjointFaceResponse
        (coframeFaceWeight coframe site a b) (connection site a)
        (variation site a) (plaquetteUnit shift connection site a b))
  have hSecond := sum_reindex_first_direction shift
    (fun a b site =>
      nonlinearWeightedAdjointFaceResponse
        (coframeFaceWeight coframe site a b)
        (twoStepUnit shift connection site a b)
        (variation (shift a site) b)
        (plaquetteUnit shift connection site a b))
  simp only [Equiv.apply_symm_apply] at hSecond
  have hThird := sum_direction_direction_site_swap_cycle
    (fun a b site =>
      nonlinearWeightedAdjointFaceResponse
        (coframeFaceWeight coframe site a b)
        (plaquetteUnit shift connection site a b * connection site b)
        (variation site b) (plaquetteUnit shift connection site a b))
  have hFourth := sum_reindex_second_direction shift
    (fun a b site =>
      nonlinearWeightedAdjointFaceResponse
        (coframeFaceWeight coframe site a b)
        (twoStepUnit shift connection site a b)
        (variation (shift b site) a)
        (plaquetteUnit shift connection site a b))
  simp only [Equiv.apply_symm_apply] at hFourth
  rw [nonlinearCoframePlaquetteFirstResponse_eq_rightTrivialized]
  simp_rw [rightTrivializedPlaquetteVariation_eq_adjointSum,
    orderedPlaquetteActionFirstResponse_adjointSum]
  unfold nonlinearLinkEulerFunctional
  simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib]
  linear_combination hFirst + hSecond - hThird - hFourth

/-- The local functional is the dot product of its six coordinate
coefficients with an arbitrary link probe. -/
theorem nonlinearLinkEulerFunctional_eq_coordinateSum
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) :
    nonlinearLinkEulerFunctional shift connection coframe site direction probe =
      Finset.sum Finset.univ (fun component =>
        nonlinearLinkEulerCoefficient shift connection coframe site direction
          component * probe component) := by
  let localMap := nonlinearLinkEulerLinearMap shift connection coframe site
    direction
  have hProbe :
      probe = Finset.sum Finset.univ (fun component =>
        probe component •
          (Pi.single component (1 : Real) : Fiber 6)) := by
    funext component
    simp [Pi.single_apply]
  calc
    nonlinearLinkEulerFunctional shift connection coframe site direction
        probe = localMap probe := rfl
    _ = localMap (Finset.sum Finset.univ (fun component =>
          probe component •
            (Pi.single component (1 : Real) : Fiber 6))) := by
      exact congrArg (fun field => localMap field) hProbe
    _ = Finset.sum Finset.univ (fun component =>
          localMap (probe component •
            (Pi.single component (1 : Real) : Fiber 6))) := by
      exact map_sum localMap _ _
    _ = Finset.sum Finset.univ (fun component =>
          probe component * localMap
            (Pi.single component (1 : Real) : Fiber 6)) := by
      simp
    _ = Finset.sum Finset.univ (fun component =>
          nonlinearLinkEulerCoefficient shift connection coframe site direction
            component * probe component) := by
      apply Finset.sum_congr rfl
      intro component _
      change probe component *
          nonlinearLinkEulerCoefficient shift connection coframe site direction
            component =
        nonlinearLinkEulerCoefficient shift connection coframe site direction
          component * probe component
      ring

/-- Link variation supported on one site, direction, and bivector component.
-/
def nonlinearLinkComponentProbe
    {Site : Type*} [DecidableEq Site]
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    LinkVariation Site :=
  Pi.single site
    (Pi.single direction (Pi.single component (1 : Real)))

/-- A component probe extracts one explicit nonlinear local Euler
coefficient. -/
theorem nonlinearCoframePlaquetteFirstResponse_componentProbe
    {Site : Type*} [Fintype Site] [DecidableEq Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    nonlinearCoframePlaquetteFirstResponse shift connection coframe
        (nonlinearLinkComponentProbe site direction component) =
      nonlinearLinkEulerCoefficient shift connection coframe site direction
        component := by
  rw [nonlinearCoframePlaquetteFirstResponse_eq_localEuler]
  rw [Fintype.sum_eq_single site]
  · rw [Fintype.sum_eq_single direction]
    · rw [nonlinearLinkEulerFunctional_eq_coordinateSum,
        Fintype.sum_eq_single component]
      · simp [nonlinearLinkComponentProbe]
      · intro otherComponent hOther
        simp [nonlinearLinkComponentProbe, hOther]
    · intro otherDirection hOther
      rw [nonlinearLinkEulerFunctional_eq_coordinateSum]
      simp [nonlinearLinkComponentProbe, hOther]
  · intro otherSite hOther
    apply Finset.sum_eq_zero
    intro otherDirection _
    rw [nonlinearLinkEulerFunctional_eq_coordinateSum]
    simp [nonlinearLinkComponentProbe, hOther]

/-- Formal stationarity of the nonlinear scalar action is exactly
vanishing of all six explicit local link Euler coefficients. -/
theorem nonlinearCoframePlaquetteConnectionStationary_iff_coefficients
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    NonlinearCoframePlaquetteConnectionStationary shift connection coframe <->
      forall site direction component,
        nonlinearLinkEulerCoefficient shift connection coframe site direction
          component = 0 := by
  classical
  constructor
  · intro hStationary site direction component
    rw [<- nonlinearCoframePlaquetteFirstResponse_componentProbe]
    exact hStationary
      (nonlinearLinkComponentProbe site direction component)
  · intro hCoefficients variation
    rw [nonlinearCoframePlaquetteFirstResponse_eq_localEuler]
    apply Finset.sum_eq_zero
    intro site _
    apply Finset.sum_eq_zero
    intro direction _
    rw [nonlinearLinkEulerFunctional_eq_coordinateSum]
    apply Finset.sum_eq_zero
    intro component _
    rw [hCoefficients site direction component, zero_mul]

/-- Ordinary derivative stationarity along every canonical exponential link
curve is exactly vanishing of all six explicit local nonlinear Euler
coefficients. -/
theorem nonlinearCoframePlaquetteExponentialStationary_iff_coefficients
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    (forall variation,
      deriv (fun t => nonlinearCoframePlaquetteAction shift
        (exponentialLinkCurve connection variation t) coframe) 0 = 0) <->
      forall site direction component,
        nonlinearLinkEulerCoefficient shift connection coframe site direction
          component = 0 := by
  calc
    (forall variation,
      deriv (fun t => nonlinearCoframePlaquetteAction shift
        (exponentialLinkCurve connection variation t) coframe) 0 = 0) <->
        NonlinearCoframePlaquetteConnectionStationary shift connection
          coframe :=
      (nonlinearCoframePlaquetteConnectionStationary_iff_exponential_deriv
        shift connection coframe).symm
    _ <-> forall site direction component,
        nonlinearLinkEulerCoefficient shift connection coframe site direction
          component = 0 :=
      nonlinearCoframePlaquetteConnectionStationary_iff_coefficients
        shift connection coframe

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler.nonlinearCoframePlaquetteFirstResponse_eq_localEuler' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteFirstResponse_eq_localEuler

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler.nonlinearCoframePlaquetteConnectionStationary_iff_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteConnectionStationary_iff_coefficients

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler.nonlinearCoframePlaquetteExponentialStationary_iff_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteExponentialStationary_iff_coefficients

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
