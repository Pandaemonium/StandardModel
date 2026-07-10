import PhysicsSM.Draft.NullEdge.Carrier.ArbitrarySpinorHodgeBridge

/-!
# Finite Pluecker action, equation of motion, and Hessian mass

The Pluecker disagreement of a supplied spinor pair defines a nonnegative
quadratic action on the positive quartet coordinate. Its exact Taylor formula
exhibits the equation of motion, and its positive-direction Hessian is exactly
the Pluecker mass. That curvature equals the arbitrary-pair Hodge class cost.

This derives EOM and Hessian consequences from the displayed action. The action,
spinor decorations, and physical normalization remain supplied; no uniqueness,
vacuum selection, or observed mass prediction is claimed.

Provenance: clean-room theorem shape informed by PhysLean variational APIs;
proof completed by Aristotle project `1df692db-8204-479c-8db4-5dd8d1359299`
and ported through project Pluecker/Hodge APIs on 2026-07-10.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass
open PhysicsSM.Draft.NullEdge.Carrier.ArbitrarySpinorHodgeBridge

def massSq (psi phi : CSpinor) : ℝ :=
  Complex.normSq (spinorWedge psi phi)

/-- Finite action whose positive-direction curvature is the pair's Pluecker
disagreement. -/
noncomputable def action (psi phi : CSpinor) (x : Quartet) : ℝ :=
  (1 / 2 : ℝ) * massSq psi phi * (x 2) ^ 2

def eom (psi phi : CSpinor) (x : Quartet) : ℝ :=
  massSq psi phi * x 2

theorem action_nonnegative (psi phi : CSpinor) (x : Quartet) :
    0 ≤ action psi phi x := by
  unfold action massSq
  have h := Complex.normSq_nonneg (spinorWedge psi phi)
  positivity

/-- Exact finite Taylor formula: the linear coefficient is the EOM and the
quadratic coefficient is the Pluecker Hessian. -/
theorem action_exact_taylor (psi phi : CSpinor)
    (x v : Quartet) (t : ℝ) :
    action psi phi (x + t • v) =
      action psi phi x +
        t * eom psi phi x * v 2 +
        (1 / 2 : ℝ) * t ^ 2 * massSq psi phi * (v 2) ^ 2 := by
  simp only [action, eom, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  ring

/-- The positive-direction second difference is exactly the Pluecker mass. -/
theorem action_positive_hessian (psi phi : CSpinor) (x : Quartet) :
    action psi phi (x + qe2) + action psi phi (x - qe2) -
      2 * action psi phi x = massSq psi phi := by
  simp only [action, qe2, Pi.add_apply, Pi.sub_apply,
    Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons]
  ring

/-- For a noncollinear pair, the finite EOM is equivalent to vanishing of the
positive quartet coordinate. -/
theorem eom_zero_iff (psi phi : CSpinor)
    (hnonzero : massSq psi phi ≠ 0) (x : Quartet) :
    eom psi phi x = 0 ↔ x 2 = 0 := by
  rw [eom, mul_eq_zero]
  simp [hnonzero]

/-- The finite action curvature and arbitrary-pair Hodge class cost are the
same project Pluecker invariant. -/
theorem action_hessian_eq_hodge_class_cost
    (psi phi : CSpinor) (x chi : Quartet) :
    (((action psi phi (x + qe2) + action psi phi (x - qe2) -
        2 * action psi phi x : ℝ)) : ℂ) =
      ((quartetB (qe2 + quartetQ chi)
        (spinorSelectedDecoder psi phi (qe2 + quartetQ chi)) : ℝ) : ℂ) := by
  rw [action_positive_hessian, arbitrary_spinor_class_cost_eq_plucker,
    complexAbsSq_eq_ofReal_normSq]
  rfl

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian.action_exact_taylor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms action_exact_taylor

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian.action_hessian_eq_hodge_class_cost' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms action_hessian_eq_hodge_class_cost

end PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian
