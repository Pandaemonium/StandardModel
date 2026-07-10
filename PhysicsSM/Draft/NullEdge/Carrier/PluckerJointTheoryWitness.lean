import PhysicsSM.Draft.NullEdge.Carrier.ArbitrarySpinorHodgeBridge
import PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerVariationalFlow
import PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsVariance

/-!
# One-pair witness for the finite mass, dynamics, and ensemble chain

The same supplied spinor pair instantiates the Hodge class cost, action
Hessian, variational-flow stiffness, Gibbs gap, and both exact finite response
identities. This closes a real interface seam: no layer may silently introduce
an unrelated mass parameter.

This is a composition theorem on one decorated pair. It does not derive the
decorations or action, identify this finite state with the separate spatial
Dirac walk, produce irreversibility, or predict an observed mass.

Provenance: composed from the project Hodge, action, variational-flow, and
finite-Gibbs payload declarations during the 2026-07-10 overnight run. The
theorem shape responds to the joint-witness gate in Grand Strategy 05.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.PluckerJointTheoryWitness

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary
open PhysicsSM.Draft.NullEdge.GeneralGramTurnScale
open PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass
open PhysicsSM.Draft.NullEdge.Carrier.ArbitrarySpinorHodgeBridge
open PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian
open PhysicsSM.Draft.NullEdge.Carrier.DiscretePluckerVariationalFlow

/-- One supplied pair supplies every scalar in the finite
mass/action/flow/ensemble chain. -/
theorem one_pair_joint_chain
    (psi phi : CSpinor) (chi q : Quartet) (x : State) (beta : ℝ) :
    ((quartetB (qe2 + quartetQ chi)
        (spinorSelectedDecoder psi phi (qe2 + quartetQ chi)) : ℝ) : ℂ) =
        (massSq psi phi : ℂ) ∧
      action psi phi (q + qe2) + action psi phi (q - qe2) -
          2 * action psi phi q = massSq psi phi ∧
      firstIntegral (massSq psi phi) (step (massSq psi phi) x) =
          firstIntegral (massSq psi phi) x ∧
      HasDerivAt
          (fun b => Real.log
            (FiniteGibbsResponse.partition
              (FiniteGibbsResponse.pluckerTwoLevel psi phi) b))
          (-FiniteGibbsResponse.meanEnergy
            (FiniteGibbsResponse.pluckerTwoLevel psi phi) beta) beta ∧
      HasDerivAt
          (FiniteGibbsVariance.meanEnergy
            (FiniteGibbsResponse.pluckerTwoLevel psi phi))
          (-FiniteGibbsVariance.variance
            (FiniteGibbsResponse.pluckerTwoLevel psi phi) beta) beta := by
  refine ⟨?_, action_positive_hessian psi phi q,
    first_integral_conserved (massSq psi phi) x, ?_, ?_⟩
  · rw [arbitrary_spinor_class_cost_eq_plucker,
      complexAbsSq_eq_ofReal_normSq]
    rfl
  · exact FiniteGibbsResponse.log_partition_hasDerivAt _ beta
  · exact FiniteGibbsVariance.meanEnergy_hasDerivAt _ beta

/-- The rational noncollinear pair is jointly nondegenerate in every layer. -/
theorem rational_joint_chain_control :
    massSq edge0 (edge1 (2 / 5)) = 4 / 25 ∧
      (∀ chi : Quartet,
        ((quartetB (qe2 + quartetQ chi)
          (spinorSelectedDecoder edge0 (edge1 (2 / 5))
            (qe2 + quartetQ chi)) : ℝ) : ℂ) = 4 / 25) ∧
      (∀ q : Quartet,
        action edge0 (edge1 (2 / 5)) (q + qe2) +
          action edge0 (edge1 (2 / 5)) (q - qe2) -
          2 * action edge0 (edge1 (2 / 5)) q = 4 / 25) ∧
      step (4 / 25) ((0, 1) : State) = (1, 46 / 25) ∧
      FiniteGibbsVariance.variance
        (FiniteGibbsResponse.pluckerTwoLevel edge0 (edge1 (2 / 5))) 0 =
          4 / 625 := by
  refine ⟨?_, arbitrary_spinor_bridge_controls.1, ?_, ?_, ?_⟩
  · norm_num [massSq, edge0, edge1, spinorWedge, Complex.normSq]
  · intro q
    rw [action_positive_hessian]
    norm_num [massSq, edge0, edge1, spinorWedge, Complex.normSq]
  · norm_num [step]
  · exact FiniteGibbsVariance.rational_plucker_variance_control.1

/-- Collinearity collapses the shared scalar in mass, action, and variance. -/
theorem collinear_joint_zero_control :
    massSq edge0 collinearEdge = 0 ∧
      (∀ q : Quartet,
        action edge0 collinearEdge (q + qe2) +
          action edge0 collinearEdge (q - qe2) -
          2 * action edge0 collinearEdge q = 0) ∧
      FiniteGibbsVariance.variance
        (FiniteGibbsResponse.pluckerTwoLevel edge0 collinearEdge) 0 = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · norm_num [massSq, edge0, collinearEdge, spinorWedge, Complex.normSq]
  · intro q
    rw [action_positive_hessian]
    norm_num [massSq, edge0, collinearEdge, spinorWedge, Complex.normSq]
  · have hE : FiniteGibbsResponse.pluckerTwoLevel edge0 collinearEdge =
        fun _ : Fin 2 => 0 := by
      funext i
      fin_cases i <;>
        norm_num [FiniteGibbsResponse.pluckerTwoLevel, massSq, edge0,
          collinearEdge, spinorWedge, Complex.normSq]
    rw [hE]
    exact FiniteGibbsVariance.degenerate_spectrum_zero_control 0 0

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerJointTheoryWitness.one_pair_joint_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms one_pair_joint_chain

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerJointTheoryWitness.rational_joint_chain_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_joint_chain_control

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerJointTheoryWitness.collinear_joint_zero_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms collinear_joint_zero_control

end PhysicsSM.Draft.NullEdge.Carrier.PluckerJointTheoryWitness
