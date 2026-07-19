import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionCancellation

noncomputable section

/-!
# Nonlinear link-Euler torsion-selection capstone

This short successor turns the component identity of
`NonlinearLorentzPalatiniEulerTorsionSelection` into the sitewise equivalence:
all derivatives of the actual nonlinear link Euler coefficients vanish if
and only if the globally site-constant connection variation and backward
coframe jets have zero linearized Cartan torsion.

The theorem has the same identity-background and first-jet scope as its
predecessor.  Claim label: finite first-jet identity.  Originality tag:
`[orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

/-- **Actual nonlinear link-Euler first jets select Cartan torsion.**  At the
identity coframe and connection, all local nonlinear Euler derivatives vanish
if and only if the global zero-lattice-momentum connection variation and
backward coframe jets are covariantly torsion-free at every site. -/
theorem nonlinearLinkEulerCoefficient_derivatives_vanish_iff_torsionFree
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (hLinkConstant : forall x y, linkVariation x = linkVariation y) :
    (forall site direction component,
      deriv (fun t => nonlinearLinkEulerCoefficient shift
        (exponentialLinkCurve (identityConnection Site) linkVariation t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site direction component) 0 = 0) <->
      forall site,
        LinearizedCovariantTorsionFree
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site) := by
  constructor
  · intro hEuler site
    apply (linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real) 1 (by simp)
      (fun connectionDirection => linkVariation site connectionDirection)
      (backwardCoframeVelocity shift coframeVariation site)).mp
    intro direction component
    have hRaised :
        transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real)
            (fun connectionDirection =>
              linkVariation site connectionDirection)
            (backwardCoframeVelocity shift coframeVariation site)
            direction) = 0 := by
      funext index
      have hDerivative :=
        (hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantPalatiniResidual
          shift linkVariation coframeVariation site
            (fun x => hLinkConstant x site) direction index).deriv
      have hComponent := hEuler site direction index
      rw [hDerivative] at hComponent
      simp only [Pi.zero_apply] at hComponent ⊢
      linarith
    exact congrFun
      ((transportApply_fundamentalSymmetry_eq_zero_iff _).mp hRaised)
      component
  · intro hTorsion site direction component
    have hResidual :=
      (linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
        (1 : Matrix (Fin 4) (Fin 4) Real) 1 (by simp)
        (fun connectionDirection => linkVariation site connectionDirection)
        (backwardCoframeVelocity shift coframeVariation site)).mpr
          (hTorsion site)
    rw [(hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantPalatiniResidual
      shift linkVariation coframeVariation site
        (fun x => hLinkConstant x site) direction component).deriv]
    have hResidualField :
        linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction = 0 := by
      funext index
      exact hResidual direction index
    rw [hResidualField]
    simp [transportApply]

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonlinearLinkEulerCoefficient_derivatives_vanish_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_derivatives_vanish_iff_torsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
