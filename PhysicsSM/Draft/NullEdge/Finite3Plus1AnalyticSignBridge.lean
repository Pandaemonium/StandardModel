import PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge

/-!
# Analytic sign convention for the finite 3+1 Fourier block

The live finite walk uses positive-exponential plane waves.  Its source shift
therefore corresponds to the analytic Clifford factor at the *negative*
lattice angle.  This module proves that conversion entrywise, at the conjugated
axis-block level, and for the complete ordered axis-0/axis-1/axis-2/mass block.

The quarter-zone theorem is a nondegenerate convention fixture: the backward
channel at residue one on `ZMod 4` contributes exactly `-i`.

Provenance: clean-room project integration of Aristotle project
`9620f01b-c5e6-4006-ac98-093967404821`, checked under Lean 4.28.0.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge

/-- Positive lattice angle represented by a finite momentum residue. -/
def latticeAngle {L : Nat} [NeZero L] (q : ZMod L) : Real :=
  2 * Real.pi * q.val / L

/-- Analytic channel phase with the live tetrahedral velocity convention. -/
def analyticPhase (axis : Axis) (a : Internal) (theta : Real) : Complex :=
  (Real.cos theta : Complex) -
    Complex.I * CliffordDiagonalPositionBridge.velocitySign axis a *
      (Real.sin theta : Complex)

/-- Diagonal analytic phase block for one axis. -/
def analyticPhaseDiag (axis : Axis) (theta : Real) : Mat4 :=
  diagonal fun a => analyticPhase axis a theta

/-- The finite source-shift phase is the analytic channel phase evaluated at
the negative lattice angle. -/
theorem shiftPhase_eq_analytic_neg {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) (a : Internal) :
    shiftPhase axis k a =
      analyticPhase axis a (-(latticeAngle (k axis))) := by
  set theta : Real := -(latticeAngle (k axis)) with htheta
  have expI : forall t : Real, Complex.exp (Complex.I * t) =
      (Real.cos t : Complex) + (Real.sin t : Complex) * Complex.I := by
    intro t
    rw [mul_comm, Complex.exp_mul_I, Complex.ofReal_cos, Complex.ofReal_sin]
  have hpos : ZMod.stdAddChar (k axis) =
      Complex.exp (Complex.I * ((-theta : Real))) := by
    rw [stdAddChar_val_formula]
    congr 1
    rw [htheta]
    simp only [latticeAngle, neg_neg, Complex.ofReal_div, Complex.ofReal_mul,
      Complex.ofReal_ofNat, Complex.ofReal_natCast]
    ring
  have hforward : ZMod.stdAddChar (k axis) =
      (Real.cos theta : Complex) - (Real.sin theta : Complex) * Complex.I := by
    rw [hpos, expI]
    simp only [Real.cos_neg, Real.sin_neg, Complex.ofReal_neg]
    ring
  have hbackward : ZMod.stdAddChar (-(k axis)) =
      (Real.cos theta : Complex) + (Real.sin theta : Complex) * Complex.I := by
    have h : ZMod.stdAddChar (-(k axis)) =
        Complex.exp (Complex.I * (theta : Real)) := by
      rw [AddChar.map_neg_eq_inv, hpos, <- Complex.exp_neg]
      congr 1
      rw [Complex.ofReal_neg]
      ring
    rw [h, expI]
  unfold shiftPhase analyticPhase CliffordDiagonalPositionBridge.velocitySign
  by_cases hv : SuccessiveAxisPositionWalk.tetraVelocity axis a
  · rw [if_pos hv, if_pos hv, hbackward]
    ring
  · rw [if_neg hv, if_neg hv, hforward]
    ring

/-- Matrix-level conversion of a finite diagonal phase block. -/
theorem phaseDiag_eq_analytic_neg {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) :
    phaseDiag axis k = analyticPhaseDiag axis (-(latticeAngle (k axis))) := by
  unfold phaseDiag analyticPhaseDiag
  congr 1
  funext a
  exact shiftPhase_eq_analytic_neg axis k a

/-- Analytic Clifford-basis symbol for one conditional-shift axis. -/
def analyticAxisSymbol (axis : Axis) (theta : Real) : Mat4 :=
  CliffordDiagonalPositionBridge.axisBasis axis *
    analyticPhaseDiag axis theta *
      (CliffordDiagonalPositionBridge.axisBasis axis)ᴴ

/-- The exact finite axis block equals the analytic block at negative lattice
momentum. -/
theorem finiteAxisSymbol_eq_analytic_neg {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) :
    finiteAxisSymbol axis k =
      analyticAxisSymbol axis (-(latticeAngle (k axis))) := by
  unfold finiteAxisSymbol analyticAxisSymbol
  rw [phaseDiag_eq_analytic_neg]

/-- Complete ordered analytic local symbol, with the live mass factor. -/
def analyticLocalSymbol (m eps q0 q1 q2 : Real) : Mat4 :=
  analyticAxisSymbol 0 q0 * analyticAxisSymbol 1 q1 *
    analyticAxisSymbol 2 q2 * Local3Plus1RateBridge.massFactor m eps

/-- Exact conversion of the complete finite Fourier block to the analytic
symbol, including all three ordered axes and the unchanged mass factor. -/
theorem finiteLocalSymbol_eq_analytic_neg {L : Nat} [NeZero L]
    (m eps : Real) (k : Position L) :
    finiteLocalSymbol m eps k =
      analyticLocalSymbol m eps
        (-(latticeAngle (k 0))) (-(latticeAngle (k 1)))
        (-(latticeAngle (k 2))) := by
  unfold finiteLocalSymbol analyticLocalSymbol
  rw [finiteAxisSymbol_eq_analytic_neg, finiteAxisSymbol_eq_analytic_neg,
    finiteAxisSymbol_eq_analytic_neg]

/-- Unit residue in every axis on the four-site torus. -/
def quarterMomentum : Position 4 := fun _ => 1

/-- Nondegenerate sign control for a live backward channel. -/
theorem quarter_zone_sign_control :
    latticeAngle (1 : ZMod 4) = Real.pi / 2 ∧
      shiftPhase 0 quarterMomentum 0 = -Complex.I ∧
      analyticPhase 0 0 (-(Real.pi / 2)) = -Complex.I := by
  have hangle : latticeAngle (1 : ZMod 4) = Real.pi / 2 := by
    have hval : (1 : ZMod 4).val = 1 := by decide
    unfold latticeAngle
    rw [hval]
    push_cast
    ring
  have hanalytic : analyticPhase 0 0 (-(Real.pi / 2)) = -Complex.I := by
    unfold analyticPhase CliffordDiagonalPositionBridge.velocitySign
    simp only [SuccessiveAxisPositionWalk.tetraVelocity, if_true]
    rw [Real.cos_neg, Real.sin_neg, Real.cos_pi_div_two, Real.sin_pi_div_two]
    push_cast
    ring
  refine ⟨hangle, ?_, hanalytic⟩
  have hq : quarterMomentum (0 : Axis) = (1 : ZMod 4) := rfl
  rw [shiftPhase_eq_analytic_neg, hq, hangle]
  exact hanalytic

end PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.shiftPhase_eq_analytic_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.shiftPhase_eq_analytic_neg

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.finiteLocalSymbol_eq_analytic_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.finiteLocalSymbol_eq_analytic_neg

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.quarter_zone_sign_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge.quarter_zone_sign_control
