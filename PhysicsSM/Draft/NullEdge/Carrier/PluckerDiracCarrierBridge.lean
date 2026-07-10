import PhysicsSM.Draft.NullEdge.Carrier.PluckerJointTheoryWitness
import PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk

/-!
# One-pair bridge from finite mass and fluctuations to the Dirac carrier

This module closes the literal parameter seam between the finite
mass/action/flow/ensemble witness and the internal `3+1` Dirac symbol. The same
supplied spinor pair defines both the two-level Gibbs gap and the mass argument
of the Dirac Hamiltonian and split-step tangent.

This is a finite parameter-identification theorem. It does not derive the
spinor pair, the Clifford frame, or the action, and it does not prove a
position-space or continuum limit. The Dirac and variational dynamics still
come from distinct selected actions.

Provenance: project composition theorem motivated by the cross-cluster seam
identified in Aristotle Audit 13 during the 2026-07-10 overnight run.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.PluckerDiracCarrierBridge

open Matrix Complex
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary
open PhysicsSM.Draft.NullEdge.GeneralGramTurnScale
open PhysicsSM.Draft.NullEdge.Carrier.ArbitrarySpinorHodgeBridge
open PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian
open PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsResponse
open PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk

/-- One supplied pair's Pluecker mass is simultaneously its Gibbs gap, the
mass in the `3+1` Clifford dispersion relation, and the mass in the
split-step tangent generator. -/
theorem one_pair_drives_dirac_symbol
    (psi phi : CSpinor) (kx ky kz : ℂ) (i j : Fin 4) :
    pluckerTwoLevel psi phi 1 = massSq psi phi ∧
      H kx ky kz (massSq psi phi) * H kx ky kz (massSq psi phi) =
        (kx ^ 2 + ky ^ 2 + kz ^ 2 + (massSq psi phi : ℂ) ^ 2) •
          (1 : Mat4) ∧
      HasDerivAt
        (fun eps : ℂ =>
          linearSplit kx ky kz (massSq psi phi) eps i j)
        ((-I) * H kx ky kz (massSq psi phi) i j) 0 := by
  exact ⟨rfl, H_sq _ _ _ _, linear_split_entry_hasDerivAt _ _ _ _ _ _⟩

/-- The rational noncollinear pair supplies a nonzero `4/25` Gibbs and Dirac
mass, with an exact nonzero relativistic square at momentum `(1,2,2)`. -/
theorem rational_massive_dirac_control :
    pluckerTwoLevel edge0 (edge1 (2 / 5)) 1 = 4 / 25 ∧
      H 1 2 2 (4 / 25) * H 1 2 2 (4 / 25) =
        (5641 / 625 : ℂ) • (1 : Mat4) ∧
      H 1 2 2 (4 / 25) ≠ 0 := by
  refine ⟨?_, ?_, ?_⟩
  · norm_num [pluckerTwoLevel, massSq, edge0, edge1, spinorWedge,
      Complex.normSq]
  · convert H_sq 1 2 2 (4 / 25) using 1 <;> norm_num
  · intro h
    have h00 := congr_fun (congr_fun h 0) 0
    norm_num [H, alpha1, alpha2, alpha3, beta] at h00

/-- Collinearity and zero momentum collapse both the ensemble gap and the
entire internal Dirac generator. -/
theorem collinear_zero_dirac_control :
    pluckerTwoLevel edge0 collinearEdge 1 = 0 ∧
      H 0 0 0 (massSq edge0 collinearEdge) = 0 := by
  constructor
  · norm_num [pluckerTwoLevel, massSq, edge0, collinearEdge, spinorWedge,
      Complex.normSq]
  · norm_num [H, massSq, edge0, collinearEdge, spinorWedge, Complex.normSq]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerDiracCarrierBridge.one_pair_drives_dirac_symbol' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms one_pair_drives_dirac_symbol

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerDiracCarrierBridge.rational_massive_dirac_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_massive_dirac_control

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerDiracCarrierBridge.collinear_zero_dirac_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms collinear_zero_dirac_control

end PhysicsSM.Draft.NullEdge.Carrier.PluckerDiracCarrierBridge
