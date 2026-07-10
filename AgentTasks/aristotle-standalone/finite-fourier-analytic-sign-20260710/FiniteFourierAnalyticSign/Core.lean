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
  sorry

/-- Target 2: the finite shift phase equals the analytic channel phase at
negative lattice momentum. -/
theorem shiftPhase_eq_analytic_neg {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k : Position L) (a : Internal) :
    shiftPhase velocity axis k a =
      analyticPhase velocity axis a (-(latticeAngle (k axis))) := by
  sorry

/-- Target 3: matrix-level diagonal phase conversion. -/
theorem finitePhaseDiag_eq_analytic_neg {L : Nat} [NeZero L]
    (velocity : Axis -> Internal -> Bool) (axis : Axis)
    (k : Position L) :
    finitePhaseDiag velocity axis k =
      analyticPhaseDiag velocity axis (-(latticeAngle (k axis))) := by
  sorry

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
  sorry

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
  sorry

def allTrue : Axis -> Internal -> Bool := fun _ _ => true

def quarterMomentum : Position 4 := fun _ => 1

/-- Target 6: nondegenerate quarter-zone control.  A backward source shift on
the positive exponential mode contributes `-i`, and the analytic negative
momentum convention gives the same sign. -/
theorem quarter_zone_sign_control :
    latticeAngle (1 : ZMod 4) = Real.pi / 2 ∧
      shiftPhase allTrue 0 quarterMomentum 0 = -Complex.I ∧
      analyticPhase allTrue 0 0 (-(Real.pi / 2)) = -Complex.I := by
  sorry

end FiniteFourierAnalyticSign
