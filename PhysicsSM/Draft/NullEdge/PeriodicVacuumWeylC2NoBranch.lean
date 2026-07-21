import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch
import PhysicsSM.Draft.NullEdge.SecondOrderCurveTaylor

noncomputable section

open scoped Matrix.Norms.Frobenius

/-!
# Twice-differentiable no-branch theorem for the two-site curved sector

This module removes the primitive Taylor-witness hypothesis from the finite
vacuum-Weyl no-branch theorem.  Ordinary `C^2` forward link-matrix and coframe
curves are assumed at the identity background, with their first and second
derivatives fixed by the proposed tangent and correction fields.  Taylor's
theorem supplies the forward expansions, while exact matrix invertibility
forces the inverse-link expansion.

Consequently, every such locally coframe-stationary curve on the minimal
two-site periodic carrier has zero plus and cross curvature amplitudes.  This
is still a fixed-carrier finite obstruction; it is not an identification with
the continuum Taub charge and does not rule out larger, bounded, twisted, or
changing-carrier refinements.

Claim label: exact finite `C^2` no-branch theorem.  Originality tag:
`[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylC2NoBranch

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylSecondOrderObstruction
open PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion
open PhysicsSM.Draft.NullEdge.SecondOrderCurveTaylor

/-- Ordinary `C^2` data for an identity-based invertible link curve.  Only the
underlying forward matrices carry differentiability hypotheses; inverse-link
Taylor data are derived from invertibility. -/
structure IdentityLinkContDiffTwo
    {Site : Type*} (curve : Real -> LinkConnection Site GL4)
    (first correction : LinkVariation Site) where
  contDiff : forall site direction,
    ContDiff Real 2 (fun t => unitMatrix (curve t site direction))
  value : forall site direction,
    unitMatrix (curve 0 site direction) = 1
  firstDerivative : forall site direction,
    deriv (fun t => unitMatrix (curve t site direction)) 0 =
      linkTangentGenerator first site direction
  secondDerivative : forall site direction,
    iteratedDeriv 2 (fun t => unitMatrix (curve t site direction)) 0 =
      linkTangentGenerator first site direction *
          linkTangentGenerator first site direction +
        linkTangentGenerator correction site direction

/-- Taylor expansion of one forward link matrix from its ordinary `C^2`
derivative data. -/
def IdentityLinkContDiffTwo.forwardExpansion
    {Site : Type*} {curve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (h : IdentityLinkContDiffTwo curve first correction)
    (site : Site) (direction : Fin 4) :
    QuadraticExpansionAtZero
      (fun t => unitMatrix (curve t site direction))
      1 (linkTangentGenerator first site direction)
      ((1 / 2 : Real) •
        (linkTangentGenerator first site direction *
            linkTangentGenerator first site direction +
          linkTangentGenerator correction site direction)) := by
  let expansion := QuadraticExpansionAtZero.ofContDiffTwo
    (h.contDiff site direction)
  apply expansion.congr rfl (h.value site direction)
    (h.firstDerivative site direction)
  rw [h.secondDerivative site direction]

/-- `C^2` forward-link data automatically produce every primitive forward and
inverse expansion required by the nonlinear plaquette calculation. -/
def IdentityLinkContDiffTwo.toSecondExpansion
    {Site : Type*} {curve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (h : IdentityLinkContDiffTwo curve first correction) :
    IdentityLinkSecondExpansion curve first correction where
  forward site direction := h.forwardExpansion site direction
  inverse site direction :=
    QuadraticExpansionAtZero.unitInverseOfContDiffTwo
      (curve := fun t => curve t site direction)
      (h.contDiff site direction)
      (h.forwardExpansion site direction)

/-- Ordinary `C^2` data for an identity-based coframe curve. -/
structure IdentityCoframeContDiffTwo
    {Site : Type*} (curve : Real -> CoframeField Site)
    (first correction : CoframeField Site) where
  contDiff : forall site, ContDiff Real 2 (fun t => curve t site)
  value : forall site, curve 0 site = 1
  firstDerivative : forall site,
    deriv (fun t => curve t site) 0 = first site
  secondDerivative : forall site,
    iteratedDeriv 2 (fun t => curve t site) 0 = correction site

/-- `C^2` coframe data automatically produce the primitive coframe expansion
used by the nonlinear Euler calculation. -/
def IdentityCoframeContDiffTwo.toSecondExpansion
    {Site : Type*} {curve : Real -> CoframeField Site}
    {first correction : CoframeField Site}
    (h : IdentityCoframeContDiffTwo curve first correction) :
    IdentityCoframeSecondExpansion curve first correction where
  point site := by
    let expansion := QuadraticExpansionAtZero.ofContDiffTwo
      (h.contDiff site)
    apply expansion.congr rfl (h.value site) (h.firstDerivative site)
    rw [h.secondDerivative site]

/-- **Twice-differentiable local no-branch theorem.** Any identity-based `C^2`
invertible-link/coframe curve with the displayed first two derivatives that
satisfies every nonlinear coframe Euler equation near the identity background
has zero plus and cross first-order curvature amplitudes. -/
theorem no_nonzero_plusCross_contDiffTwo_coframeStationary_branch
    (plusScale crossScale : Real)
    (linkCorrection : LinkVariation NullWaveSite)
    (coframeCorrection : CoframeField NullWaveSite)
    {linkCurve : Real -> LinkConnection NullWaveSite GL4}
    {coframeCurve : Real -> CoframeField NullWaveSite}
    (hLink : IdentityLinkContDiffTwo linkCurve
      (plusCrossLinkCombination plusScale crossScale) linkCorrection)
    (hCoframe : IdentityCoframeContDiffTwo coframeCurve
      (plusCrossCoframeCombination plusScale crossScale) coframeCorrection)
    (hStationary : Filter.Eventually (fun t => forall site internal direction,
      nonlinearCoframeEulerCoefficient nullWaveShift (linkCurve t)
        (coframeCurve t) site internal direction = 0) (nhds 0)) :
    plusScale = 0 /\ crossScale = 0 :=
  no_nonzero_plusCross_coframeStationary_branch
    plusScale crossScale linkCorrection coframeCorrection
    hLink.toSecondExpansion hCoframe.toSecondExpansion hStationary

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylC2NoBranch.IdentityLinkContDiffTwo.toSecondExpansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms IdentityLinkContDiffTwo.toSecondExpansion

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylC2NoBranch.IdentityCoframeContDiffTwo.toSecondExpansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms IdentityCoframeContDiffTwo.toSecondExpansion

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylC2NoBranch.no_nonzero_plusCross_contDiffTwo_coframeStationary_branch' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_nonzero_plusCross_contDiffTwo_coframeStationary_branch

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylC2NoBranch
