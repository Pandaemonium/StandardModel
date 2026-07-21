import PhysicsSM.Draft.NullEdge.RingHolonomyHalfLinkN

/-!
# Ring-holonomy spectral witness at EVERY length: dropping the parity hypothesis

Target statements for the Aristotle job `ring-holonomy-alln-20260719`.

Context.  The landed chain (`RingHolonomySpectrumN`, `RingHolonomyHalfLinkN`)
proves the trace-power holonomy formula, the spectral discriminator, and the
composed half-link witness at every ODD ring length `n > 2`.  The odd
hypothesis entered ONLY through the trace formula: for odd `n` no closed
length-`n` walk is balanced, so `trace (H^n) = n (w + conj w)` exactly.

For EVEN `n` the balanced walks contribute a holonomy-INDEPENDENT
combinatorial constant.  Key collapse: with unit links the hops satisfy
`F * B = B * F = 1` (landed: `forward_backward_mul`, `backward_forward_mul`),
so in the binomial expansion `(F + B)^n = ∑ C(n,k) • F^k B^(n-k)` each term
telescopes to a pure power `F^(2k-n)` (or `B^(n-2k)`), whose trace vanishes
unless the exponent is `0` or `n`.  Hence for even `n`:

  `trace (H^n) = n * C(n, n/2) + n * (w + conj w)`.

The constant cancels in any trace comparison, so the spectral discriminator
- and therefore the composed half-link witness, whose holonomy input
`holonomy_halfLinkField` is already parity-free - holds at EVERY `n > 2`.
This removes the parity hypothesis from the Paper A chain end-to-end.

Conventions: exactly those of `RingHolonomySpectrumN` (directed ring,
`HRing = forwardHop + backwardHop`, holonomy = product of link phases).
Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.RingHolonomyAllN

open PhysicsSM.Draft.NullEdge.RingHolonomySpectrumN
open PhysicsSM.Draft.NullEdge.RingHolonomyHalfLinkN

/-- Powers of the forward hop below the ring length are traceless (the
shifted diagonal never returns: `i = i + m` in `ZMod n` forces `n ∣ m`). -/
theorem trace_forwardHop_pow_of_lt (n m : ℕ) [NeZero n] (u : ZMod n → ℂ)
    (hm0 : 0 < m) (hmn : m < n) :
    ((forwardHop n u) ^ m).trace = 0 := by
  sorry

/-- Powers of the backward hop below the ring length are traceless. -/
theorem trace_backwardHop_pow_of_lt (n m : ℕ) [NeZero n] (u : ZMod n → ℂ)
    (hm0 : 0 < m) (hmn : m < n) :
    ((backwardHop n u) ^ m).trace = 0 := by
  sorry

/-- **Even-`n` trace-power holonomy formula.**  For even `n > 2` and unit
links, the balanced walks contribute the combinatorial constant
`n * C(n, n/2)` and the winding walks contribute `n * (w + conj w)`. -/
theorem trace_pow_even (n : ℕ) [NeZero n] (heven : Even n) (hn : 2 < n)
    (u : ZMod n → ℂ) (hu : UnitLinks n u) :
    ((HRing n u) ^ n).trace =
      (n : ℂ) * (n.choose (n / 2) : ℂ)
        + (n : ℂ) * (holonomy n u + starRingEnd ℂ (holonomy n u)) := by
  sorry

/-- **Spectral discriminator at every even `n`.**  The combinatorial
constant is holonomy-independent, so it cancels in the trace comparison. -/
theorem not_unitarily_conjugate_of_holonomy_re_ne_even (n : ℕ) [NeZero n]
    (heven : Even n) (hn : 2 < n) (u v : ZMod n → ℂ)
    (hu : UnitLinks n u) (hv : UnitLinks n v)
    (hre : (holonomy n u).re ≠ (holonomy n v).re) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n u * Wᴴ = HRing n v := by
  sorry

/-- **Spectral discriminator at EVERY `n > 2` - the parity hypothesis is
gone.**  Composes the landed odd case with the new even case. -/
theorem not_unitarily_conjugate_of_holonomy_re_ne_all (n : ℕ) [NeZero n]
    (hn : 2 < n) (u v : ZMod n → ℂ)
    (hu : UnitLinks n u) (hv : UnitLinks n v)
    (hre : (holonomy n u).re ≠ (holonomy n v).re) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n u * Wᴴ = HRing n v := by
  sorry

/-- **Composed half-link spectral witness at EVERY length `n > 2`.**  Total
turning `2π` (holonomy `-1`, parity-free by `holonomy_halfLinkField`) is not
unitarily conjugate to the trivial ring - at every ring length. -/
theorem halfLink_ring_not_conjugate_trivial_all (n : ℕ) [NeZero n]
    (hn : 2 < n) (delta : ZMod n → ℝ)
    (hsum : ∑ p, delta p = 2 * Real.pi) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n (halfLinkField n delta) * Wᴴ = HRing n (fun _ => 1) := by
  sorry

end PhysicsSM.Draft.NullEdge.RingHolonomyAllN
