import PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian
import PhysicsSM.Spinor.PluckerMassCovariance

/-!
# SL(2,C) presentation invariance of the Pluecker action Hessian

The project Pluecker wedge is a determinant-one relative invariant. Therefore
the arbitrary-pair mass, the finite action, and its positive-direction Hessian
are unchanged by every supplied `SL(2,C)` presentation change. A rational boost
preserves the nonzero `4/25` control, while the non-unimodular dilation `2 I`
changes it to `64/25`.

This proves presentation rigidity of the derived curvature. It does not select
a preferred presentation, derive spinor decorations, or establish invariance
under transformations outside determinant one.

Provenance: determinant-covariance and control proofs completed by Aristotle
project `88f1de11-8e6f-4a92-9a28-ffe97aa01ac1`; clean-room composition through
the existing `PluckerMassCovariance` and action APIs on 2026-07-10.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Carrier.PluckerHessianSL2Invariance

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Spinor.PluckerMassCovariance
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary
open PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass
open PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

/-- The Pluecker mass is invariant under determinant-one changes of spinor
presentation. -/
theorem massSq_sl2_invariant
    (A : Matrix (Fin 2) (Fin 2) Complex) (hA : A.det = 1)
    (psi phi : CSpinor) :
    massSq (actSpinor A psi) (actSpinor A phi) = massSq psi phi := by
  unfold massSq
  rw [spinorWedge_sl2_invariant A hA]

/-- The entire finite quadratic action is presentation invariant. -/
theorem action_sl2_invariant
    (A : Matrix (Fin 2) (Fin 2) Complex) (hA : A.det = 1)
    (psi phi : CSpinor) (x : Quartet) :
    action (actSpinor A psi) (actSpinor A phi) x = action psi phi x := by
  unfold action
  rw [massSq_sl2_invariant A hA]

/-- The positive-direction Hessian mass is a presentation invariant, not a
representative artifact. -/
theorem action_hessian_sl2_invariant
    (A : Matrix (Fin 2) (Fin 2) Complex) (hA : A.det = 1)
    (psi phi : CSpinor) (x : Quartet) :
    action (actSpinor A psi) (actSpinor A phi) (x + qe2) +
          action (actSpinor A psi) (actSpinor A phi) (x - qe2) -
          2 * action (actSpinor A psi) (actSpinor A phi) x =
      action psi phi (x + qe2) + action psi phi (x - qe2) -
          2 * action psi phi x := by
  simp only [action_sl2_invariant A hA]

noncomputable def rationalBoost : Matrix (Fin 2) (Fin 2) Complex :=
  !![(5 / 4 : ℝ), (3 / 4 : ℝ); (3 / 4 : ℝ), (5 / 4 : ℝ)]

theorem rational_boost_hessian_control (x : Quartet) :
    Matrix.det rationalBoost = 1 ∧
      action (actSpinor rationalBoost edge0)
          (actSpinor rationalBoost (edge1 (2 / 5))) (x + qe2) +
          action (actSpinor rationalBoost edge0)
            (actSpinor rationalBoost (edge1 (2 / 5))) (x - qe2) -
          2 * action (actSpinor rationalBoost edge0)
            (actSpinor rationalBoost (edge1 (2 / 5))) x = 4 / 25 := by
  have hdet : Matrix.det rationalBoost = 1 := by
    norm_num [rationalBoost, Matrix.det_fin_two, Complex.ext_iff]
  refine ⟨hdet, ?_⟩
  rw [action_hessian_sl2_invariant rationalBoost hdet,
    action_positive_hessian]
  norm_num [massSq, edge0, edge1, spinorWedge, Complex.normSq]

noncomputable def dilation2 : Matrix (Fin 2) (Fin 2) Complex :=
  !![2, 0; 0, 2]

/-- Determinant one is load-bearing: the dilation `2 I` scales the base
`4/25` Hessian to `64/25`. -/
theorem nonunimodular_dilation_control :
    Matrix.det dilation2 = 4 ∧
      massSq (actSpinor dilation2 edge0)
          (actSpinor dilation2 (edge1 (2 / 5))) = 64 / 25 ∧
      massSq (actSpinor dilation2 edge0)
          (actSpinor dilation2 (edge1 (2 / 5))) ≠
        massSq edge0 (edge1 (2 / 5)) := by
  unfold dilation2 massSq actSpinor edge0 edge1
  norm_num [Matrix.det_fin_two, Matrix.mulVec, dotProduct,
    Fin.sum_univ_two, spinorWedge, Complex.normSq]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerHessianSL2Invariance.action_hessian_sl2_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms action_hessian_sl2_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerHessianSL2Invariance.nonunimodular_dilation_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonunimodular_dilation_control

end PhysicsSM.Draft.NullEdge.Carrier.PluckerHessianSL2Invariance
