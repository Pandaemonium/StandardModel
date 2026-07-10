import PhysicsSM.Draft.NullEdge.Carrier.FreeMassBridge
import PhysicsSM.Draft.NullEdge.CheckerboardCarrierBridge

/-!
# A canonical Gram-to-turn mass dictionary

The project contains two exact finite mass constructions:

* the Pluecker/Gram invariant of a pair of complex null spinors; and
* the squared turn parameter in the `1+1` checkerboard carrier.

They are not equal without a map between their input data. This module supplies
the smallest explicit dictionary: use the canonical spinor pair
`e0, m * e1`. Its wedge has squared modulus `m^2`, so the free mass operator is
exactly the complexification of the checkerboard turn channel `Q_T m`.

The negative control proves that a fixed pair cannot encode both `m = 1` and
`m = 2`. Thus the bridge is a theorem after the scale-bearing dictionary is
displayed, while derivation of that dictionary from primitive histories remains
open.

Provenance: composition target independently selected by the 2026-07-10
Aristotle grand-strategy and architecture audits; clean-room formalization by
Codex from `PluckerMass`, `FreeMassBridge`, and `CheckerboardCarrierBridge`.
-/

namespace PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary

open Matrix
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.Carrier.FreeMassBridge

/-- The first canonical null spinor. -/
def edge0 : CSpinor := ![(1 : ℂ), 0]

/-- The scale-bearing second null spinor. -/
def edge1 (m : ℝ) : CSpinor := ![0, (m : ℂ)]

/-- Entrywise complexification of a real `2 x 2` matrix. -/
def complexify (A : Matrix (Fin 2) (Fin 2) ℝ) :
    Matrix (Fin 2) (Fin 2) ℂ := fun i j => (A i j : ℂ)

/-- The canonical pair's Pluecker invariant is exactly `m^2`. -/
theorem canonical_plucker_mass (m : ℝ) :
    complexAbsSq (spinorWedge edge0 (edge1 m)) = ((m ^ 2 : ℝ) : ℂ) := by
  simp [edge0, edge1, spinorWedge, complexAbsSq]
  ring

/-- **Gram-to-turn bridge.** Under the displayed canonical scale dictionary,
the free Pluecker mass operator equals the complexified checkerboard turn
channel. -/
theorem free_mass_operator_eq_complexified_turn (m : ℝ) :
    (twoEdgeMomentum edge0 (edge1 m)) *
        (twoEdgeMomentum edge0 (edge1 m)).adjugate =
      complexify (DiracWalkCarrier.Q_T m) := by
  rw [free_mass_operator_eq_plucker, canonical_plucker_mass,
    DiracWalkCarrier.turn_is_mass_squared]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [complexify, Matrix.smul_apply]

/-- The canonical dictionary is nondegenerate at the rational scale `m=3/5`:
its common mass coefficient is exactly `9/25`, not zero. -/
theorem rational_dictionary_witness :
    complexAbsSq (spinorWedge edge0 (edge1 (3 / 5))) =
        ((9 / 25 : ℝ) : ℂ) ∧
      DiracWalkCarrier.Q_T (3 / 5) =
        (9 / 25 : ℝ) • (1 : Matrix (Fin 2) (Fin 2) ℝ) ∧
      (9 / 25 : ℝ) ≠ 0 := by
  refine ⟨?_, ?_, by norm_num⟩
  · rw [canonical_plucker_mass]
    norm_num
  · rw [DiracWalkCarrier.turn_is_mass_squared]
    norm_num

/-- **Missing-dictionary control.** One fixed null-spinor pair cannot represent
both turn scales `m=1` and `m=2`. The checkerboard parameter is therefore not
derived from a scale-independent pair merely by naming both quantities
"mass". -/
theorem fixed_pair_cannot_encode_two_turn_scales :
    ¬ ((twoEdgeMomentum edge0 (edge1 1)) *
          (twoEdgeMomentum edge0 (edge1 1)).adjugate =
        complexify (DiracWalkCarrier.Q_T 1) ∧
      (twoEdgeMomentum edge0 (edge1 1)) *
          (twoEdgeMomentum edge0 (edge1 1)).adjugate =
        complexify (DiracWalkCarrier.Q_T 2)) := by
  rintro ⟨_, htwo⟩
  have hentry := congrFun (congrFun htwo 0) 0
  norm_num [twoEdgeMomentum, edge0, edge1, rankOneHermitian,
    Matrix.vecMulVec, Matrix.det_fin_two, Matrix.adjugate_fin_two,
    DiracWalkCarrier.Q_T, DiracWalkCarrier.turn, complexify,
    Matrix.mul_apply, Fin.sum_univ_two] at hentry

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary.free_mass_operator_eq_complexified_turn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms free_mass_operator_eq_complexified_turn

/-- info: 'PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary.rational_dictionary_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_dictionary_witness

/-- info: 'PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary.fixed_pair_cannot_encode_two_turn_scales' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixed_pair_cannot_encode_two_turn_scales

end PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary
