import PhysicsSM.Draft.NullEdge.Carrier.HodgePluckerMassBridge
import PhysicsSM.Draft.NullEdge.GeneralGramTurnScale

/-!
# Arbitrary decorated spinors select the quartet Hodge mass

For every supplied pair of complex null spinors, the general Pluecker turn scale
selects a member of the nondegenerate quartet decoder family. Every exact
representative then has Hodge class cost equal to the pair's Pluecker mass.
This removes the canonical-pair restriction from the landed family bridge.

The spinor decorations and the rule selecting this decoder family remain
supplied. This module does not reconstruct decorations from a bare graph,
derive the decoder from an action, fix physical units, or predict observed
masses.

Provenance: focused composition proof completed by Aristotle project
`5f5379b8-a5b6-4928-b773-19afb8192f2b`; clean-room port through the project
Pluecker, turn-scale, and nondegenerate Hodge APIs on 2026-07-10.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.ArbitrarySpinorHodgeBridge

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass
open PhysicsSM.Draft.NullEdge.GeneralGramTurnScale
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary

/-- The quartet decoder selected by the nonnegative Pluecker scale of an
arbitrary decorated spinor pair. -/
noncomputable def spinorSelectedDecoder (psi phi : CSpinor) :
    Quartet →ₗ[ℝ] Quartet :=
  quartetSAt (turnScale psi phi)

/-- **Arbitrary-pair Hodge-Pluecker bridge.** Every exact representative has
class cost equal to the supplied pair's Pluecker disagreement. -/
theorem arbitrary_spinor_class_cost_eq_plucker
    (psi phi : CSpinor) (chi : Quartet) :
    ((quartetB (qe2 + quartetQ chi)
        (spinorSelectedDecoder psi phi (qe2 + quartetQ chi)) : ℝ) : ℂ) =
      complexAbsSq (spinorWedge psi phi) := by
  rw [show spinorSelectedDecoder psi phi = quartetSAt (turnScale psi phi) by
      rfl,
    quartetSAt_class_cost, turnScale_sq, complexAbsSq_eq_ofReal_normSq]

/-- Two nonzero canonical scales and a collinear zero pair control the general
composition theorem. -/
theorem arbitrary_spinor_bridge_controls :
    (∀ chi : Quartet,
        ((quartetB (qe2 + quartetQ chi)
            (spinorSelectedDecoder edge0 (edge1 (2 / 5))
              (qe2 + quartetQ chi)) : ℝ) : ℂ) = 4 / 25) ∧
      (∀ chi : Quartet,
        ((quartetB (qe2 + quartetQ chi)
            (spinorSelectedDecoder edge0 (edge1 (3 / 5))
              (qe2 + quartetQ chi)) : ℝ) : ℂ) = 9 / 25) ∧
      (∀ chi : Quartet,
        ((quartetB (qe2 + quartetQ chi)
            (spinorSelectedDecoder edge0 collinearEdge
              (qe2 + quartetQ chi)) : ℝ) : ℂ) = 0) ∧
      (4 / 25 : ℂ) ≠ 9 / 25 := by
  refine ⟨fun chi => ?_, fun chi => ?_, fun chi => ?_, by norm_num⟩
  · rw [arbitrary_spinor_class_cost_eq_plucker, canonical_plucker_mass]
    norm_num
  · rw [arbitrary_spinor_class_cost_eq_plucker, canonical_plucker_mass]
    norm_num
  · rw [arbitrary_spinor_class_cost_eq_plucker]
    norm_num [edge0, collinearEdge, spinorWedge, complexAbsSq]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ArbitrarySpinorHodgeBridge.arbitrary_spinor_class_cost_eq_plucker' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms arbitrary_spinor_class_cost_eq_plucker

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ArbitrarySpinorHodgeBridge.arbitrary_spinor_bridge_controls' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms arbitrary_spinor_bridge_controls

end PhysicsSM.Draft.NullEdge.Carrier.ArbitrarySpinorHodgeBridge
