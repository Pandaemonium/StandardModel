import Mathlib.Tactic

/-!
# P7 Bloch mass ratio and observer-channel monotonicity

For a qubit visible density matrix written via its Bloch vector `r` in the Bloch
ball, the two eigenvalues are `(1 +- |r|)/2`, so `det rho = (1 - |r|^2)/4` and the
visible mass ratio `m/E = 2 sqrt(det rho) = sqrt(1 - |r|^2)`.

This is the cheapest physics-facing reduced-density statement (the concurrence /
proper-time-rate bridge), plus the observer-channel monotonicity the P7
relative-entropy line needs: contracting the Bloch vector (a unital qubit channel
/ coarse-graining) cannot decrease the mass ratio.

Standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeP7BlochMassRatio

open BigOperators

abbrev Bloch := Fin 3 -> Real

/-- Squared Bloch radius. -/
def blochNormSq (r : Bloch) : Real := Finset.univ.sum fun k => r k ^ 2

/-- Larger eigenvalue of the Bloch qubit density `(1 + |r|)/2`. -/
def lamPlus (r : Bloch) : Real := (1 + Real.sqrt (blochNormSq r)) / 2

/-- Smaller eigenvalue of the Bloch qubit density `(1 - |r|)/2`. -/
def lamMinus (r : Bloch) : Real := (1 - Real.sqrt (blochNormSq r)) / 2

/-- Determinant of the Bloch density. -/
def detRho (r : Bloch) : Real := lamPlus r * lamMinus r

/-- Visible mass ratio `m / E = 2 sqrt(det rho)`. -/
def massRatio (r : Bloch) : Real := 2 * Real.sqrt (detRho r)

/-- On the Bloch ball the mass ratio equals `sqrt(1 - |r|^2)`. -/
theorem massRatio_eq_sqrt_one_minus_blochNormSq (r : Bloch)
    (hr : blochNormSq r <= 1) :
    massRatio r = Real.sqrt (1 - blochNormSq r) := by
  sorry

/-- Contracting the Bloch vector (a unital observer channel) does not decrease
the visible mass ratio. -/
theorem massRatio_monotone_under_bloch_contraction (r r' : Bloch)
    (hr : blochNormSq r <= 1) (hcontract : blochNormSq r' <= blochNormSq r) :
    massRatio r <= massRatio r' := by
  sorry

end NullEdgeP7BlochMassRatio
