import PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
import PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent

noncomputable section

/-!
# Nonlinear Lorentz Palatini response

This module pairs the corrected complementary coframe face with the exact
right-trivialized tangent of group-valued Lorentz plaquette holonomy. The
matrix tangent is first passed through the proved equivalence between the
six-component bivector fiber and the mostly-minus Lorentz Lie algebra. An
eta-Lorentz hypothesis on every link ensures that this coordinate recovery is
exact rather than a projection of an unconstrained matrix.

The resulting finite response one-form is

`sum_(x,a,b) [B_ab(e,x), (delta H_ab H_ab^(-1))^vee]_J`.

At identity link transport it reduces exactly to the existing coframe-derived
Krein response built from the oriented additive plaquette curl.

## Scope and provenance

This is an exact finite nonlinear response identity. It is not yet a scalar
action: no theorem here asserts that the right-logarithmic response one-form is
globally integrable on the link-connection space. Consequently this module
does not yet supply a nonlinear Euler equation or select Levi-Civita
transport.

The construction composes the guarded complementary face convention in
`LorentzCoframePalatiniFace`, the exact Lie-algebra equivalence in
`LorentzBivectorLieAlgebraBridge`, and the Aristotle-assisted plaquette tangent
in `LorentzPlaquetteTangent`. Claim label: finite identity. Originality tag:
`[orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent

/-- Identity matrix transport satisfies the eta-Lorentz link hypothesis. -/
theorem identityConnection_isEtaLorentz (Site : Type*) :
    forall site direction,
      IsEtaLorentz
        (unitMatrix (identityConnection Site site direction)) := by
  intro site direction
  simp [identityConnection, unitMatrix, IsEtaLorentz]

/-- Six-component coordinates of the exact plaquette tangent. The link
hypothesis ensures that the matrix inhabits the Lorentz Lie algebra before the
equivalence is inverted. -/
def plaquetteTangentBivector {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (hConnection : forall site direction,
      IsEtaLorentz (unitMatrix (connection site direction)))
    (variation : LinkVariation Site) (site : Site) (a b : Fin 4) : Fiber 6 :=
  lorentzGeneratorEquiv.symm
    ⟨rightTrivializedPlaquetteVariation shift connection variation site a b,
      rightTrivializedPlaquetteVariation_mem shift connection hConnection
        variation site a b⟩

/-- Coordinate recovery does not discard any part of the nonlinear tangent.
-/
theorem lorentzGenerator_plaquetteTangentBivector {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (hConnection : forall site direction,
      IsEtaLorentz (unitMatrix (connection site direction)))
    (variation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    lorentzGenerator
        (plaquetteTangentBivector shift connection hConnection variation site
          a b) =
      rightTrivializedPlaquetteVariation shift connection variation site a b := by
  change
    (lorentzGeneratorEquiv
      (lorentzGeneratorEquiv.symm
        ⟨rightTrivializedPlaquetteVariation shift connection variation site a b,
          rightTrivializedPlaquetteVariation_mem shift connection hConnection
            variation site a b⟩)).1 =
      rightTrivializedPlaquetteVariation shift connection variation site a b
  exact congrArg Subtype.val
    (lorentzGeneratorEquiv.apply_symm_apply
      ⟨rightTrivializedPlaquetteVariation shift connection variation site a b,
        rightTrivializedPlaquetteVariation_mem shift connection hConnection
          variation site a b⟩)

/-- At identity links, exact tangent coordinates are the additive plaquette
curl coordinates. -/
theorem plaquetteTangentBivector_identity {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) (variation : LinkVariation Site)
    (site : Site) (a b : Fin 4) :
    plaquetteTangentBivector shift (identityConnection Site)
        (identityConnection_isEtaLorentz Site) variation site a b =
      additivePlaquetteCurl shift variation site a b := by
  apply lorentzGenerator_injective
  rw [lorentzGenerator_plaquetteTangentBivector,
    rightTrivializedPlaquetteVariation_identity]

/-- The covariant additive curvature at identity fiber transport is the same
oriented curl recovered from the nonlinear group tangent. -/
theorem covariantLinearizedPlaquetteCurvature_identity
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (variation : LinkPotential Site 6) (site : Site) (a b : Fin 4) :
    covariantLinearizedPlaquetteCurvature shift identityLinkTransport variation
        site a b =
      additivePlaquetteCurl shift variation site a b := by
  funext component
  unfold covariantLinearizedPlaquetteCurvature covariantForwardDifference
    identityLinkTransport additivePlaquetteCurl
  rw [transportApply_one, transportApply_one]
  ring

variable {Site : Type*} [Fintype Site] [DecidableEq Site]

/-- Complementary-coframe pairing with the exact nonlinear Lorentz plaquette
response. This is a connection-space one-form, not yet a scalar action. -/
def nonlinearCoframePalatiniResponse
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (hConnection : forall site direction,
      IsEtaLorentz (unitMatrix (connection site direction)))
    (coframe : CoframeField Site) (variation : LinkVariation Site) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun site =>
        kreinPair lorentzBivectorFundamentalSymmetry
          (coframeFaceWeight coframe site a b)
          (plaquetteTangentBivector shift connection hConnection variation
            site a b))))

omit [DecidableEq Site] in
/-- The nonlinear response has the existing coframe-derived Krein/additive
response as its exact identity-link tangent control. -/
theorem nonlinearCoframePalatiniResponse_identity
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site)
    (variation : LinkVariation Site) :
    nonlinearCoframePalatiniResponse shift (identityConnection Site)
        (identityConnection_isEtaLorentz Site) coframe variation =
      coframeLinkFaceFirstVariation shift identityLinkTransport coframe
        variation := by
  unfold nonlinearCoframePalatiniResponse coframeLinkFaceFirstVariation
    lorentzBivectorLinkFaceFirstVariation kreinLinkFaceFirstVariation
  simp_rw [plaquetteTangentBivector_identity,
    covariantLinearizedPlaquetteCurvature_identity]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse.lorentzGenerator_plaquetteTangentBivector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzGenerator_plaquetteTangentBivector

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse.plaquetteTangentBivector_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plaquetteTangentBivector_identity

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse.nonlinearCoframePalatiniResponse_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePalatiniResponse_identity

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse
