import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse

noncomputable section

/-!
# Nonlinear Lorentz plaquette action

This module gives the corrected link branch a displayed scalar holonomy
functional. For the complementary coframe face `B_ab` and exact group
plaquette `H_ab`, the ordered local term is

`-1/2 tr(hat(B_ab) (H_ab - I))`.

Its formal product/inverse response pairs `hat(B_ab)` with `delta H_ab`.
Equivalently, because `delta H = (delta H H^(-1)) H`, the exact
right-trivialized tangent carries the necessary holonomy weight away from the
identity. At identity links the weight disappears and the response reduces
exactly to the existing coframe-derived Krein/additive Palatini response.
For an arbitrary face field already known to transform by the exterior-square
Lorentz action, the complete ordered scalar action is exactly invariant under
the existing vertex gauge transform.

Summing over ordered faces is intentional. Coframe-face antisymmetry and
`H_ba = H_ab^(-1)` combine the two orientations into the familiar
`H - H^(-1)` structure.

## Scope and provenance

The action and its formal response are exact finite algebraic definitions, and
their identity-link agreement, generic face/holonomy gauge invariance, and
concrete proper-Lorentz coframe gauge invariance are kernel checked. This
module does not yet formalize a differentiable curve in the matrix group,
include metric dual-cell volumes, or prove Levi-Civita selection. The separate
curve-derivative and nonlinear Euler successors realize the response by
canonical exponential link curves and derive its exact local coefficients.

The trace action is the standard first-order lattice-gravity shape used in
ordered holonomy discretizations, with conventions inherited from the project
Krein/trace bridge. The ordered complementary-face architecture matches Kur
and Glasser, arXiv:2202.02486, Eqs. (15), (16), and (25). Claim label: finite
identity. Originality tag: `[comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse

/-- Reversing the ordered plaquette directions inverts its group holonomy. -/
theorem plaquetteUnit_swap {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (site : Site) (a b : Fin 4) :
    plaquetteUnit shift connection site b a =
      (plaquetteUnit shift connection site a b)⁻¹ := by
  simp [plaquetteUnit, plaquetteHolonomy, twoStepTransport]

/-- Exterior-square transport of a bivector is exactly adjoint conjugation of
its Lorentz generator by an eta-Lorentz unit. -/
theorem lorentzGenerator_transportApply_wedgeTwoTransport_eq_conjugate
    (transport : GL4) (hTransport : IsEtaLorentz (unitMatrix transport))
    (bivector : Fiber 6) :
    lorentzGenerator
        (transportApply (wedgeTwoTransport (unitMatrix transport)) bivector) =
      unitMatrix transport * lorentzGenerator bivector *
        unitMatrix transport⁻¹ := by
  have hIntertwines :=
    lorentzGenerator_transportApply_wedgeTwoTransport_mul
      (unitMatrix transport) hTransport bivector
  calc
    lorentzGenerator
        (transportApply (wedgeTwoTransport (unitMatrix transport)) bivector) =
      lorentzGenerator
          (transportApply (wedgeTwoTransport (unitMatrix transport)) bivector) *
        (unitMatrix transport * unitMatrix transport⁻¹) := by
          simp [unitMatrix]
    _ = (lorentzGenerator
          (transportApply (wedgeTwoTransport (unitMatrix transport)) bivector) *
        unitMatrix transport) * unitMatrix transport⁻¹ := by
          simp [Matrix.mul_assoc]
    _ = (unitMatrix transport * lorentzGenerator bivector) *
        unitMatrix transport⁻¹ := by
          rw [hIntertwines]

/-- One ordered complementary-face/holonomy contribution to the scalar
Palatini action. -/
def orderedPlaquetteActionTerm (face : Fiber 6) (holonomy : GL4) : Real :=
  -(1 / 2 : Real) * Matrix.trace
    (lorentzGenerator face * (unitMatrix holonomy - 1))

/-- A simultaneous basepoint Lorentz transformation of the face bivector and
plaquette holonomy leaves one ordered scalar action term invariant. -/
theorem orderedPlaquetteActionTerm_conjugate
    (transport : GL4) (hTransport : IsEtaLorentz (unitMatrix transport))
    (face : Fiber 6) (holonomy : GL4) :
    orderedPlaquetteActionTerm
        (transportApply (wedgeTwoTransport (unitMatrix transport)) face)
        (transport * holonomy * transport⁻¹) =
      orderedPlaquetteActionTerm face holonomy := by
  unfold orderedPlaquetteActionTerm
  rw [lorentzGenerator_transportApply_wedgeTwoTransport_eq_conjugate
    transport hTransport]
  have hConjugateSub :
      unitMatrix (transport * holonomy * transport⁻¹) - 1 =
        unitMatrix transport * (unitMatrix holonomy - 1) *
          unitMatrix transport⁻¹ := by
    simp [unitMatrix, Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_assoc]
  rw [hConjugateSub]
  have hProduct :
      (unitMatrix transport * lorentzGenerator face * unitMatrix transport⁻¹) *
          (unitMatrix transport * (unitMatrix holonomy - 1) *
            unitMatrix transport⁻¹) =
        (unitMatrix transport *
          (lorentzGenerator face * (unitMatrix holonomy - 1))) *
            unitMatrix transport⁻¹ := by
    simp [unitMatrix, Matrix.mul_assoc]
  rw [hProduct, Matrix.trace_mul_comm]
  simp [unitMatrix]

/-- Ordered scalar holonomy action for an arbitrary six-component face field.
-/
def nonlinearFacePlaquetteAction
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (faceWeight : FaceWeight Site 6) :
    Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun site =>
        orderedPlaquetteActionTerm (faceWeight site a b)
          (plaquetteUnit shift connection site a b))))

/-- A Lorentz-covariant face field and conjugation-covariant plaquette
holonomy make the complete ordered scalar action vertex-gauge invariant. -/
theorem nonlinearFacePlaquetteAction_gaugeTransform
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (gauge : Site -> GL4)
    (hGauge : forall site, IsEtaLorentz (unitMatrix (gauge site)))
    (connection : LinkConnection Site GL4) (faceWeight : FaceWeight Site 6) :
    nonlinearFacePlaquetteAction shift (gaugeTransform shift gauge connection)
        (fun site a b =>
          transportApply (wedgeTwoTransport (unitMatrix (gauge site)))
            (faceWeight site a b)) =
      nonlinearFacePlaquetteAction shift connection faceWeight := by
  unfold nonlinearFacePlaquetteAction
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro b _
  apply Finset.sum_congr rfl
  intro site _
  rw [show plaquetteUnit shift (gaugeTransform shift gauge connection)
      site a b =
        gauge site * plaquetteUnit shift connection site a b *
          (gauge site)⁻¹ by
    simpa [plaquetteUnit] using
      plaquetteHolonomy_gaugeTransform shift hCommute gauge connection site a b]
  exact orderedPlaquetteActionTerm_conjugate _ (hGauge site) _ _

/-- Pointwise internal Lorentz action on a coframe field. -/
def coframeGaugeTransform
    {Site : Type*} (gauge : Site -> GL4) (coframe : CoframeField Site) :
    CoframeField Site :=
  fun site => unitMatrix (gauge site) * coframe site

/-- Scalar ordered-face holonomy action for a coframe and group-valued link
connection. -/
def nonlinearCoframePlaquetteAction
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) : Real :=
  nonlinearFacePlaquetteAction shift connection (coframeFaceWeight coframe)

/-- Once the concrete complementary coframe face is known to transform by the
exterior-square Lorentz action, generic face/holonomy gauge invariance gives
gauge invariance of the full coframe scalar action. -/
theorem nonlinearCoframePlaquetteAction_gaugeTransform_of_faceCovariant
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (gauge : Site -> GL4)
    (hGauge : forall site, IsEtaLorentz (unitMatrix (gauge site)))
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (hFace : forall site a b,
      coframeFaceWeight (coframeGaugeTransform gauge coframe) site a b =
        transportApply (wedgeTwoTransport (unitMatrix (gauge site)))
          (coframeFaceWeight coframe site a b)) :
    nonlinearCoframePlaquetteAction shift
        (gaugeTransform shift gauge connection)
        (coframeGaugeTransform gauge coframe) =
      nonlinearCoframePlaquetteAction shift connection coframe := by
  unfold nonlinearCoframePlaquetteAction
  have hFaceField :
      coframeFaceWeight (coframeGaugeTransform gauge coframe) =
        fun site a b =>
          transportApply (wedgeTwoTransport (unitMatrix (gauge site)))
            (coframeFaceWeight coframe site a b) := by
    funext site a b
    exact hFace site a b
  rw [hFaceField]
  exact nonlinearFacePlaquetteAction_gaugeTransform shift hCommute gauge
    hGauge connection (coframeFaceWeight coframe)

/-- The concrete coframe plaquette action is invariant under pointwise proper
Lorentz gauge transformations.  Properness is essential because the internal
Hodge star changes orientation under the other Lorentz-group component. -/
theorem nonlinearCoframePlaquetteAction_gaugeTransform
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (gauge : Site -> GL4)
    (hGauge : forall site, IsEtaLorentz (unitMatrix (gauge site)))
    (hProper : forall site, (unitMatrix (gauge site)).det = 1)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    nonlinearCoframePlaquetteAction shift
        (gaugeTransform shift gauge connection)
        (coframeGaugeTransform gauge coframe) =
      nonlinearCoframePlaquetteAction shift connection coframe := by
  apply nonlinearCoframePlaquetteAction_gaugeTransform_of_faceCovariant
    shift hCommute gauge hGauge connection coframe
  intro site a b
  exact complementaryPalatiniFaceWeight_mul
    (unitMatrix (gauge site)) (coframe site) (hGauge site) (hProper site) a b

/-- Formal response of one ordered scalar term to the product/inverse
plaquette tangent. -/
def orderedPlaquetteActionFirstResponse
    (face : Fiber 6) (deltaHolonomy : Matrix (Fin 4) (Fin 4) Real) : Real :=
  -(1 / 2 : Real) * Matrix.trace (lorentzGenerator face * deltaHolonomy)

/-- Formal connection response of the scalar ordered-face action. -/
def nonlinearCoframePlaquetteFirstResponse
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (variation : LinkVariation Site) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun site =>
        orderedPlaquetteActionFirstResponse (coframeFaceWeight coframe site a b)
          (plaquetteMatrixVariation shift connection variation site a b))))

/-- Translating the exact plaquette tangent to the identity and then back by
the plaquette holonomy recovers the original product/inverse tangent. -/
theorem plaquetteMatrixVariation_eq_rightTrivialized_mul
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (variation : LinkVariation Site)
    (site : Site) (a b : Fin 4) :
    plaquetteMatrixVariation shift connection variation site a b =
      rightTrivializedPlaquetteVariation shift connection variation site a b *
        unitMatrix (plaquetteUnit shift connection site a b) := by
  unfold rightTrivializedPlaquetteVariation
  rw [Matrix.mul_assoc]
  simp [unitMatrix]

/-- At identity links, the exact product/inverse plaquette tangent is the
Lorentz generator of the oriented additive curl. -/
theorem plaquetteMatrixVariation_identity
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (variation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    plaquetteMatrixVariation shift (identityConnection Site) variation site a b =
      lorentzGenerator (additivePlaquetteCurl shift variation site a b) := by
  rw [plaquetteMatrixVariation_eq_rightTrivialized_mul,
    rightTrivializedPlaquetteVariation_identity]
  simp [plaquetteUnit, plaquetteHolonomy, twoStepTransport,
    identityConnection, unitMatrix]

/-- The formal response of the scalar action is the right-trivialized
plaquette response with its required nonlinear holonomy weight. -/
theorem nonlinearCoframePlaquetteFirstResponse_eq_rightTrivialized
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (variation : LinkVariation Site) :
    nonlinearCoframePlaquetteFirstResponse shift connection coframe variation =
      Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            orderedPlaquetteActionFirstResponse
              (coframeFaceWeight coframe site a b)
              (rightTrivializedPlaquetteVariation shift connection variation
                  site a b *
                unitMatrix (plaquetteUnit shift connection site a b))))) := by
  unfold nonlinearCoframePlaquetteFirstResponse
  simp_rw [plaquetteMatrixVariation_eq_rightTrivialized_mul]

/-- Flat identity links make every plaquette action term vanish. -/
theorem nonlinearCoframePlaquetteAction_identity
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site) :
    nonlinearCoframePlaquetteAction shift (identityConnection Site) coframe = 0 := by
  simp [nonlinearCoframePlaquetteAction, nonlinearFacePlaquetteAction,
    orderedPlaquetteActionTerm,
    plaquetteUnit, plaquetteHolonomy, twoStepTransport,
    identityConnection, unitMatrix]

/-- At identity links, the formal scalar-action response is exactly the
previous coframe-derived Krein/additive response. -/
theorem nonlinearCoframePlaquetteFirstResponse_identity
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site)
    (variation : LinkVariation Site) :
    nonlinearCoframePlaquetteFirstResponse shift (identityConnection Site)
        coframe variation =
      coframeLinkFaceFirstVariation shift identityLinkTransport coframe
        variation := by
  calc
    nonlinearCoframePlaquetteFirstResponse shift (identityConnection Site)
        coframe variation =
      nonlinearCoframePalatiniResponse shift (identityConnection Site)
        (identityConnection_isEtaLorentz Site) coframe variation := by
          unfold nonlinearCoframePlaquetteFirstResponse
            orderedPlaquetteActionFirstResponse
            nonlinearCoframePalatiniResponse
          simp_rw [plaquetteMatrixVariation_identity,
            plaquetteTangentBivector_identity,
            normalizedTracePair_eq_kreinPair]
    _ = coframeLinkFaceFirstVariation shift identityLinkTransport coframe
        variation :=
      nonlinearCoframePalatiniResponse_identity shift coframe variation

/-- Formal connection stationarity of the displayed nonlinear scalar
plaquette action. This definition is phrased through the exact product/inverse
response; the curve-derivative successor proves that it is equivalent to
ordinary derivative stationarity along all canonical exponential link
variations. -/
def NonlinearCoframePlaquetteConnectionStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) : Prop :=
  forall variation,
    nonlinearCoframePlaquetteFirstResponse shift connection coframe variation = 0

/-- On the flat identity-link branch, nonlinear formal stationarity is exactly
the established coframe-derived Krein link equation. -/
theorem nonlinearCoframePlaquetteConnectionStationary_identity_iff_krein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site) :
    NonlinearCoframePlaquetteConnectionStationary shift
        (identityConnection Site) coframe <->
      KreinLinkConnectionEulerLagrange lorentzBivectorFundamentalSymmetry shift
        identityLinkTransport (coframeFaceWeight coframe) := by
  constructor
  · intro hStationary variation
    change coframeLinkFaceFirstVariation shift identityLinkTransport coframe
      variation = 0
    rw [<- nonlinearCoframePlaquetteFirstResponse_identity]
    exact hStationary variation
  · intro hKrein variation
    rw [nonlinearCoframePlaquetteFirstResponse_identity]
    exact hKrein variation

/-- Hence the exact identity-link Euler equation of the nonlinear scalar
action is vanishing Krein-covariant backward divergence of the complementary
coframe face. -/
theorem nonlinearCoframePlaquetteConnectionStationary_identity_iff_divergence
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site) :
    NonlinearCoframePlaquetteConnectionStationary shift
        (identityConnection Site) coframe <->
      forall site direction component,
        kreinFaceBackwardDivergence lorentzBivectorFundamentalSymmetry shift
          identityLinkTransport (coframeFaceWeight coframe) site direction
            component = 0 := by
  rw [nonlinearCoframePlaquetteConnectionStationary_identity_iff_krein,
    coframeLinkConnectionEulerLagrange_iff_divergence]

/-- A constant coframe with identity links is a nonvacuous stationary control
of the nonlinear scalar plaquette action's formal response. -/
theorem nonlinear_identity_siteConstantCoframe_stationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    NonlinearCoframePlaquetteConnectionStationary shift
      (identityConnection Site) (fun _ => coframe) := by
  rw [nonlinearCoframePlaquetteConnectionStationary_identity_iff_krein]
  exact identity_siteConstantCoframe_stationary shift coframe

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction.plaquetteUnit_swap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plaquetteUnit_swap

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction.orderedPlaquetteActionTerm_conjugate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms orderedPlaquetteActionTerm_conjugate

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction.nonlinearFacePlaquetteAction_gaugeTransform' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearFacePlaquetteAction_gaugeTransform

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction.nonlinearCoframePlaquetteAction_gaugeTransform_of_faceCovariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteAction_gaugeTransform_of_faceCovariant

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction.nonlinearCoframePlaquetteAction_gaugeTransform' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteAction_gaugeTransform

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction.plaquetteMatrixVariation_eq_rightTrivialized_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plaquetteMatrixVariation_eq_rightTrivialized_mul

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction.nonlinearCoframePlaquetteAction_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteAction_identity

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction.nonlinearCoframePlaquetteFirstResponse_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteFirstResponse_identity

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction.nonlinearCoframePlaquetteConnectionStationary_identity_iff_divergence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteConnectionStationary_identity_iff_divergence

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction.nonlinear_identity_siteConstantCoframe_stationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinear_identity_siteConstantCoframe_stationary

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
