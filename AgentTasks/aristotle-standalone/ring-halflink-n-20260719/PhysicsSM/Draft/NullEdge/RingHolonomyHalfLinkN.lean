import PhysicsSM.Draft.NullEdge.RingHolonomySpectrumN

/-!
# Half-link fields at general ring length: turning `2π` forces holonomy `-1`

Target statements for the Aristotle job `ring-halflink-n-20260719`.

Context (Paper A chain).  `RingHolonomySpectrumN` (included, PROVEN
tonight): the odd-`n` trace-power holonomy formula and the spectral
discriminator - unit-link rings with different holonomy real parts are not
unitarily conjugate, at every odd `n > 2`.  The three-site bridge
(`PlueckerRingHolonomyBridge`) feeds that spectral layer with half-link
fields `u p = exp(i δ p / 2)` derived from a Pluecker phase field with
total turning `2π`.  This module states the general-`n` half-link layer:
any phase-increment field summing to `2π` produces a unit-link field of
holonomy exactly `-1`, hence (odd `n`) a ring spectrally distinct from the
trivial one.  The general-`n` derived-Pluecker instantiation is a later
brick; this closes the abstract half of the chain.

Pre-registered honesty license: if a factor-of-two or sign convention in
the half-link exponent must shift for holonomy `-1` to come out exactly,
fix it once, record it prominently, and keep the composed corollary
exact.  Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RingHolonomyHalfLinkN

open Matrix Complex
open PhysicsSM.Draft.NullEdge.RingHolonomySpectrumN

/-- The half-link field of a phase-increment field. -/
def halfLinkField (n : ℕ) [NeZero n] (delta : ZMod n → ℝ) : ZMod n → ℂ :=
  fun p => Complex.exp (((delta p / 2 : ℝ) : ℂ) * Complex.I)

/-- Half-link fields are unit links. -/
theorem unitLinks_halfLinkField (n : ℕ) [NeZero n] (delta : ZMod n → ℝ) :
    UnitLinks n (halfLinkField n delta) := by
  sorry

/-- **Total turning `2π` forces holonomy `-1`.** -/
theorem holonomy_halfLinkField (n : ℕ) [NeZero n] (delta : ZMod n → ℝ)
    (hsum : ∑ p, delta p = 2 * Real.pi) :
    holonomy n (halfLinkField n delta) = -1 := by
  sorry

/-- **Composed spectral witness at every odd length.**  A winding-one
half-link ring is not unitarily conjugate to the constant trivial ring. -/
theorem halfLink_ring_not_conjugate_trivial (n : ℕ) [NeZero n]
    (hodd : Odd n) (hn : 2 < n) (delta : ZMod n → ℝ)
    (hsum : ∑ p, delta p = 2 * Real.pi) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n (halfLinkField n delta) * Wᴴ = HRing n (fun _ => 1) := by
  sorry

end PhysicsSM.Draft.NullEdge.RingHolonomyHalfLinkN
