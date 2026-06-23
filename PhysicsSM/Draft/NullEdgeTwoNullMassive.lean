import Mathlib.Tactic

/-!
# Two null edges combine into a massive system

Two massless (null) edge momenta with positive energy sum to a timelike (massive)
total momentum: `(p+q)^2 = 2 p.q >= 0`, with equality only when they are
collinear. This is the multi-edge origin of mass in the null-edge program - mass
comes from the spread of null edges, complementing the visible-fan no-go.
Signature (+,-,-,-).

Standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeTwoNullMassive

open BigOperators

abbrev Four := Fin 4 -> Real

/-- Minkowski inner product, signature (+,-,-,-). -/
def mink (p q : Four) : Real := p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3

/-- Spatial squared norm. -/
def spaceNormSq (p : Four) : Real := p 1 ^ 2 + p 2 ^ 2 + p 3 ^ 2

/-- Mass square of a four-momentum. -/
def massSq (p : Four) : Real := mink p p

/-
The mass square of a sum of two null momenta is `2 p.q`.
-/
theorem two_null_sum_massSq (p q : Four)
    (hp : massSq p = 0) (hq : massSq q = 0) :
    massSq (fun i => p i + q i) = 2 * mink p q := by
  unfold massSq mink at *
  linarith

/-
For two future-pointing null momenta (positive energy, on the light cone),
the Minkowski product is nonnegative, so the combined system is non-tachyonic.
-/
theorem mink_two_null_nonneg (p q : Four)
    (hp : p 0 ^ 2 = spaceNormSq p) (hq : q 0 ^ 2 = spaceNormSq q)
    (hpe : 0 ≤ p 0) (hqe : 0 ≤ q 0) :
    0 ≤ mink p q := by
  unfold mink
  norm_num [spaceNormSq] at *
  nlinarith [sq_nonneg (p 1 * q 2 - p 2 * q 1), sq_nonneg (p 1 * q 3 - p 3 * q 1),
    sq_nonneg (p 2 * q 3 - p 3 * q 2), mul_nonneg hpe hqe]

end PhysicsSM.Draft.NullEdgeTwoNullMassive
