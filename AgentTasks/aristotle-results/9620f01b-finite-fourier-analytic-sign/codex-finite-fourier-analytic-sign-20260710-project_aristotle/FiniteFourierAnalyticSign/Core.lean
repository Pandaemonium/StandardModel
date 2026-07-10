import Mathlib.Analysis.Fourier.ZMod
import Mathlib.LinearAlgebra.Matrix.Hermitian

/-!
# Exact sign bridge from finite Fourier characters to analytic walk symbols

The finite local walk is diagonal on positive-exponential product plane waves.
Its exact root-of-unity phase must be matched to the analytic Clifford factor
with the convention `k * eps = -2*pi*n/L`.  This file makes that conversion a
theorem and includes a quarter-zone sign control.
-/

noncomputable section

open Matrix Complex

namespace FiniteFourierAnalyticSign

abbrev Axis := Fin 3
abbrev Internal := Fin 4
abbrev Position (L : Nat) := Axis -> ZMod L
abbrev Mat4 := Matrix Internal Internal Complex

/-- Positive lattice angle represented by a residue. -/
def latticeAngle {L : Nat} [NeZero L] (q : ZMod L) : Real :=
  2 * Real.pi * q.val / L

/-- The sign table used by the analytic conditional-shift factor. -/
def velocitySign (velocity : Axis -> Internal -> Bool)
    (axis : Axis) (a : Internal) : Complex :=
  if velocity axis a then -1 else 1

/-- Exact finite phase in the positive-exponential plane-wave convention. -/
def shiftPhase {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k : Position L) (a : Internal) : Complex :=
  if velocity axis a then
    ZMod.stdAddChar (-(k axis))
  else
    ZMod.stdAddChar (k axis)

/-- Analytic phase of a channel at dimensionless angle `theta`. -/
def analyticPhase (velocity : Axis -> Internal -> Bool)
    (axis : Axis) (a : Internal) (theta : Real) : Complex :=
  (Real.cos theta : Complex) -
    Complex.I * velocitySign velocity axis a * (Real.sin theta : Complex)

def finitePhaseDiag {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k : Position L) : Mat4 :=
  diagonal (shiftPhase velocity axis k)

def analyticPhaseDiag (velocity : Axis -> Internal -> Bool)
    (axis : Axis) (theta : Real) : Mat4 :=
  diagonal fun a => analyticPhase velocity axis a theta

/-- Target 1: exact lattice-character exponential. -/
theorem stdAddChar_val_formula {L : Nat} [NeZero L] (q : ZMod L) :
    ZMod.stdAddChar q =
      Complex.exp (2 * Real.pi * Complex.I * q.val / L) := by
  rw [ZMod.stdAddChar_apply, ZMod.toCircle_apply]

/-- Target 2: the finite shift phase equals the analytic channel phase at
negative lattice momentum. -/
theorem shiftPhase_eq_analytic_neg {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k : Position L) (a : Internal) :
    shiftPhase velocity axis k a =
      analyticPhase velocity axis a (-(latticeAngle (k axis))) := by
  set θ : ℝ := -(latticeAngle (k axis)) with hθ
  -- Euler's formula for the positive-exponential character.
  have expI : ∀ t : ℝ, Complex.exp (Complex.I * t)
      = (Real.cos t : ℂ) + (Real.sin t : ℂ) * Complex.I := by
    intro t
    rw [mul_comm, Complex.exp_mul_I, Complex.ofReal_cos, Complex.ofReal_sin]
  -- The forward character has angle `-θ = latticeAngle`.
  have hpos : ZMod.stdAddChar (k axis) = Complex.exp (Complex.I * ((-θ : ℝ))) := by
    rw [stdAddChar_val_formula]
    congr 1
    rw [hθ]
    simp only [latticeAngle, neg_neg, Complex.ofReal_div, Complex.ofReal_mul,
      Complex.ofReal_ofNat, Complex.ofReal_natCast]
    ring
  -- Forward channel (velocity false): `cos θ - sin θ · i`.
  have hA : ZMod.stdAddChar (k axis)
      = (Real.cos θ : ℂ) - (Real.sin θ : ℂ) * Complex.I := by
    rw [hpos, expI]
    simp only [Real.cos_neg, Real.sin_neg, Complex.ofReal_neg]
    ring
  -- Backward channel (velocity true): source shift flips the sign of the angle.
  have hB : ZMod.stdAddChar (-(k axis))
      = (Real.cos θ : ℂ) + (Real.sin θ : ℂ) * Complex.I := by
    have h2 : ZMod.stdAddChar (-(k axis)) = Complex.exp (Complex.I * (θ : ℝ)) := by
      rw [AddChar.map_neg_eq_inv, hpos, ← Complex.exp_neg]
      congr 1
      rw [Complex.ofReal_neg]
      ring
    rw [h2, expI]
  unfold shiftPhase analyticPhase velocitySign
  by_cases h : velocity axis a
  · rw [if_pos h, if_pos h, hB]; ring
  · rw [if_neg h, if_neg h, hA]; ring

/-- Target 3: matrix-level diagonal phase conversion. -/
theorem finitePhaseDiag_eq_analytic_neg {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k : Position L) :
    finitePhaseDiag velocity axis k =
      analyticPhaseDiag velocity axis (-(latticeAngle (k axis))) := by
  unfold finitePhaseDiag analyticPhaseDiag
  congr 1
  funext a
  exact shiftPhase_eq_analytic_neg velocity axis k a

def finiteAxisSymbol {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (U : Axis -> Mat4)
    (axis : Axis) (k : Position L) : Mat4 :=
  U axis * finitePhaseDiag velocity axis k * (U axis)ᴴ

def analyticAxisSymbol (velocity : Axis -> Internal -> Bool)
    (U : Axis -> Mat4) (axis : Axis) (theta : Real) : Mat4 :=
  U axis * analyticPhaseDiag velocity axis theta * (U axis)ᴴ

/-- Target 4: the basis-conjugated finite block is exactly the analytic axis
symbol at negative lattice momentum. -/
theorem finiteAxisSymbol_eq_analytic_neg {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (U : Axis -> Mat4)
    (axis : Axis) (k : Position L) :
    finiteAxisSymbol velocity U axis k =
      analyticAxisSymbol velocity U axis (-(latticeAngle (k axis))) := by
  unfold finiteAxisSymbol analyticAxisSymbol
  rw [finitePhaseDiag_eq_analytic_neg]

def finiteLocalSymbol {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (U : Axis -> Mat4)
    (mass : Mat4) (k : Position L) : Mat4 :=
  finiteAxisSymbol velocity U 0 k * finiteAxisSymbol velocity U 1 k *
    finiteAxisSymbol velocity U 2 k * mass

def analyticLocalSymbol (velocity : Axis -> Internal -> Bool)
    (U : Axis -> Mat4) (mass : Mat4) (q0 q1 q2 : Real) : Mat4 :=
  analyticAxisSymbol velocity U 0 q0 *
    analyticAxisSymbol velocity U 1 q1 *
      analyticAxisSymbol velocity U 2 q2 * mass

/-- Target 5: exact ordered local-block conversion, including every axis and
the unchanged mass coin. -/
theorem finiteLocalSymbol_eq_analytic_neg {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (U : Axis -> Mat4)
    (mass : Mat4) (k : Position L) :
    finiteLocalSymbol velocity U mass k =
      analyticLocalSymbol velocity U mass
        (-(latticeAngle (k 0))) (-(latticeAngle (k 1)))
        (-(latticeAngle (k 2))) := by
  unfold finiteLocalSymbol analyticLocalSymbol
  rw [finiteAxisSymbol_eq_analytic_neg, finiteAxisSymbol_eq_analytic_neg,
    finiteAxisSymbol_eq_analytic_neg]

def allTrue : Axis -> Internal -> Bool := fun _ _ => true

def quarterMomentum : Position 4 := fun _ => 1

/-- Target 6: nondegenerate quarter-zone control.  A backward source shift on
the positive exponential mode contributes `-i`, and the analytic negative
momentum convention gives the same sign. -/
theorem quarter_zone_sign_control :
    latticeAngle (1 : ZMod 4) = Real.pi / 2 ∧
      shiftPhase allTrue 0 quarterMomentum 0 = -Complex.I ∧
      analyticPhase allTrue 0 0 (-(Real.pi / 2)) = -Complex.I := by
  have h1 : latticeAngle (1 : ZMod 4) = Real.pi / 2 := by
    have hv : (1 : ZMod 4).val = 1 := by decide
    unfold latticeAngle
    rw [hv]
    push_cast
    ring
  have h3 : analyticPhase allTrue 0 0 (-(Real.pi / 2)) = -Complex.I := by
    unfold analyticPhase velocitySign allTrue
    simp only [if_pos]
    rw [Real.cos_neg, Real.sin_neg, Real.cos_pi_div_two, Real.sin_pi_div_two]
    push_cast
    ring
  refine ⟨h1, ?_, h3⟩
  have hq : quarterMomentum (0 : Axis) = (1 : ZMod 4) := rfl
  rw [shiftPhase_eq_analytic_neg, hq, h1]
  exact h3

end FiniteFourierAnalyticSign
