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

namespace PhysicsSM.Draft.NullEdgeP7BlochMassRatio

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

/-- On the Bloch ball the mass ratio equals `sqrt(1 - |r|^2)`.

(The hypothesis `hr : blochNormSq r ≤ 1` is kept since it is the physically
meaningful "Bloch ball" condition the statement asks for; the identity in fact
holds for all `r`, because outside the ball both sides are `0`.) -/
theorem massRatio_eq_sqrt_one_minus_blochNormSq (r : Bloch)
    (_hr : blochNormSq r <= 1) :
    massRatio r = Real.sqrt (1 - blochNormSq r) := by
  have hnn : 0 ≤ blochNormSq r := Finset.sum_nonneg fun k _ => sq_nonneg _
  unfold massRatio detRho lamPlus lamMinus
  ring_nf
  norm_num [Real.sq_sqrt hnn]
  rw [show 1 / 4 + -(blochNormSq r * (1 / 4)) = (1 - blochNormSq r) / 4 by ring,
    Real.sqrt_div'] <;> norm_num

/-- Contracting the Bloch vector (a unital observer channel) does not decrease
the visible mass ratio. -/
theorem massRatio_monotone_under_bloch_contraction (r r' : Bloch)
    (hr : blochNormSq r <= 1) (hcontract : blochNormSq r' <= blochNormSq r) :
    massRatio r <= massRatio r' := by
  rw [massRatio_eq_sqrt_one_minus_blochNormSq r hr,
    massRatio_eq_sqrt_one_minus_blochNormSq r' (by linarith)]
  exact Real.sqrt_le_sqrt <| sub_le_sub_left hcontract _

end PhysicsSM.Draft.NullEdgeP7BlochMassRatio
