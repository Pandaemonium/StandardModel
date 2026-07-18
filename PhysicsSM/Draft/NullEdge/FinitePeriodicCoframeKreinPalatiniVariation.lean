import PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
import PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace

noncomputable section

/-!
# Coframe-derived finite Krein link/face Palatini equation

This module inserts the geometric face field

`B_ab(x) = (1/2) sum_cd epsilon^(cdab) star(e_c(x) wedge e_d(x))`

into the exact periodic Krein link/face variation.  It thereby removes the
previous arbitrary antisymmetric face-vector input from the local connection
equation.  Here `a,b` label the curvature plaquette, so the spacetime
alternating symbol selects the complementary coframe plane required by the
Palatini four-form.  The resulting link stationarity condition is exactly
vanishing Krein-covariant backward divergence of the coframe-derived face
field.

## Scope and provenance

This is a finite first-order Palatini consistency theorem.  The link transport
is still the linearized six-component transport of the predecessor module.
The theorem does not yet include metric dual-cell volumes, the exact nonlinear
group plaquette tangent, or a proof that the divergence equation uniquely
selects the null-edge Levi-Civita connection.  Claim label: finite identity.
Originality tag: `[orig]`, composed from the standard complementary Palatini
face field and the guarded project-local Krein summation-by-parts theorem.
In the fixed six-vector convention, the project Krein pairing of the internal
Hodge dual is the negative of `(1/4) epsilon_IJKL B^IJ C^KL`; a future joint
gravity-matter action must compensate this explicit overall sign in its
gravitational prefactor or curvature-orientation convention.  Stationarity of
the vacuum connection response is unchanged by that nonzero global sign.
-/

namespace PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation

open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace

variable {Site : Type*} [Fintype Site] [DecidableEq Site]

/-- A concrete internal coframe at every carrier site. -/
abbrev CoframeField (Site : Type*) :=
  Site -> Matrix (Fin 4) (Fin 4) Real

/-- Ordered six-component Palatini face weight derived pointwise from the
coframe field. -/
def coframeFaceWeight (coframe : CoframeField Site) : FaceWeight Site 6 :=
  fun site a b => complementaryPalatiniFaceWeight (coframe site) a b

omit [Fintype Site] [DecidableEq Site] in
/-- The coframe-derived face field has the ordered antisymmetry required by the
Krein link Euler theorem. -/
theorem coframeFaceWeight_isAntisymmetric (coframe : CoframeField Site) :
    IsAntisymmetricFaceWeight (coframeFaceWeight coframe) := by
  intro site a b component
  exact congrFun
    (complementaryPalatiniFaceWeight_swap (coframe site) b a) component

/-- Full physical six-component link response with its face field supplied by
the coframe. -/
abbrev coframeLinkFaceFirstVariation
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site 6)
    (coframe : CoframeField Site) (variation : LinkPotential Site 6) : Real :=
  lorentzBivectorLinkFaceFirstVariation shift transport
    (coframeFaceWeight coframe) variation

omit [DecidableEq Site] in
/-- The coframe-derived response has the exact local Krein Euler pairing. -/
theorem coframeLinkFaceFirstVariation_eq_eulerPairing
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site 6)
    (coframe : CoframeField Site) (variation : LinkPotential Site 6) :
    coframeLinkFaceFirstVariation shift transport coframe variation =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun direction =>
          kreinPair lorentzBivectorFundamentalSymmetry
            (kreinLinkEulerCoefficient lorentzBivectorFundamentalSymmetry shift
              transport (coframeFaceWeight coframe) site direction)
            (variation site direction))) := by
  exact lorentzBivectorLinkFaceFirstVariation_eq_eulerPairing _ _ _ _

omit [DecidableEq Site] in
/-- Stationarity of the coframe-derived link response is exactly vanishing
Krein-covariant divergence of the complementary Palatini face field. -/
theorem coframeLinkConnectionEulerLagrange_iff_divergence
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site 6)
    (coframe : CoframeField Site) :
    KreinLinkConnectionEulerLagrange lorentzBivectorFundamentalSymmetry shift
        transport (coframeFaceWeight coframe) <->
      forall site direction component,
        kreinFaceBackwardDivergence lorentzBivectorFundamentalSymmetry shift
          transport (coframeFaceWeight coframe) site direction component = 0 := by
  exact kreinLinkConnectionEulerLagrange_iff_divergence _ _ _ _
    (coframeFaceWeight_isAntisymmetric coframe)

omit [DecidableEq Site] in
/-- A site-constant coframe with identity link transport is a nonvacuous
stationary control for the coframe-derived face equation. -/
theorem identity_siteConstantCoframe_stationary
    (shift : Fin 4 -> Equiv Site Site)
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    KreinLinkConnectionEulerLagrange lorentzBivectorFundamentalSymmetry shift
      identityLinkTransport (coframeFaceWeight (fun _ => coframe)) := by
  simpa [coframeFaceWeight] using
    identity_siteConstant_kreinLinkConnectionEulerLagrange
      lorentzBivectorFundamentalSymmetry shift
      (fun a b => complementaryPalatiniFaceWeight coframe a b)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation.coframeLinkConnectionEulerLagrange_iff_divergence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coframeLinkConnectionEulerLagrange_iff_divergence

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation.identity_siteConstantCoframe_stationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identity_siteConstantCoframe_stationary

end PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
