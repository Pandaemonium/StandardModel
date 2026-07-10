import PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary

/-!
# General Gram-derived turn scale

For every pair of decorated complex null spinors, this module derives the
nonnegative turn scale `sqrt(normSq(spinorWedge psi phi))`. The square of this
scale is the two-edge Gram/Pluecker determinant, and the free mass operator
equals the complexified checkerboard turn channel at that derived scale. This
removes the earlier restriction to the canonical pair `e0, m e1`.

The spinor decorations remain supplied data. No theorem here reconstructs them
from a bare graph, fixes physical units, or identifies an interacting mass.

Provenance: composition target selected by Aristotle strategy audit
`823a61ad-00ed-4a32-97a3-4ad694aa5fa8`; standalone proof completed by Aristotle
project `0a3433d8-7a02-4b8b-babf-ee75f573a95c` and ported through the existing
project Pluecker and turn-channel APIs.
-/

namespace PhysicsSM.Draft.NullEdge.GeneralGramTurnScale

open Matrix Complex
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.Carrier.FreeMassBridge
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary

/-- Nonnegative turn scale derived from the disagreement of two decorated null
directions. -/
noncomputable def turnScale (psi phi : CSpinor) : ℝ :=
  Real.sqrt (Complex.normSq (spinorWedge psi phi))

theorem turnScale_sq (psi phi : CSpinor) :
    turnScale psi phi ^ 2 = Complex.normSq (spinorWedge psi phi) := by
  unfold turnScale
  rw [Real.sq_sqrt]
  exact Complex.normSq_nonneg _

/-- **General Gram-to-turn theorem.** For every decorated spinor pair, the free
mass operator is the checkerboard turn channel at the derived nonnegative
Pluecker scale. -/
theorem free_mass_operator_eq_derived_turn (psi phi : CSpinor) :
    twoEdgeMomentum psi phi * (twoEdgeMomentum psi phi).adjugate =
      complexify (DiracWalkCarrier.Q_T (turnScale psi phi)) := by
  rw [free_mass_operator_eq_plucker, complexAbsSq_eq_ofReal_normSq,
    DiracWalkCarrier.turn_is_mass_squared, turnScale_sq]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [complexify, Matrix.smul_apply]

/-- A collinear decorated edge used as the required zero control. -/
def collinearEdge : CSpinor := ![(3 : ℂ), 0]

/-- The derived scale has a nonzero rational fixture, a collinear zero control,
and a nonzero free mass operator. -/
theorem derived_scale_controls :
    turnScale edge0 (edge1 (2 / 5)) = 2 / 5 ∧
      turnScale edge0 collinearEdge = 0 ∧
      twoEdgeMomentum edge0 (edge1 (2 / 5)) *
          (twoEdgeMomentum edge0 (edge1 (2 / 5))).adjugate ≠ 0 := by
  refine ⟨?_, ?_, ?_⟩
  · norm_num [turnScale, edge0, edge1, spinorWedge, Complex.normSq]
  · norm_num [turnScale, edge0, collinearEdge, spinorWedge]
  · rw [free_mass_operator_eq_plucker, canonical_plucker_mass]
    intro h
    have h00 := congrFun (congrFun h 0) 0
    norm_num [Matrix.smul_apply] at h00

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GeneralGramTurnScale.free_mass_operator_eq_derived_turn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms free_mass_operator_eq_derived_turn

/-- info: 'PhysicsSM.Draft.NullEdge.GeneralGramTurnScale.derived_scale_controls' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms derived_scale_controls

end PhysicsSM.Draft.NullEdge.GeneralGramTurnScale
