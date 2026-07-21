import PhysicsSM.Draft.NullEdge.RingHolonomyHalfLinkN
import PhysicsSM.Draft.NullEdge.PlueckerWindingDerived

/-!
# Paper A completion brick: derived winding-one rings at every odd length

Target statements for the Aristotle job `derived-winding-ring-n-20260719`.

Context.  Tonight's chain: `RingHolonomySpectrumN` (odd-`n` trace-power
discriminator) + `RingHolonomyHalfLinkN` (turning `2π` => holonomy `-1` =>
not conjugate to trivial).  The derived-winding layer
(`PlueckerWindingDerived`) is ALREADY generic over `ZMod L`
(`linkIncrement`, `totalTurning`).  This module states the last bridge:
the half-link field DERIVED from any winding-one Pluecker phase field
produces, at every odd ring length, a ring spectrally distinct from the
trivial one.  With it, Paper A's ring-holonomy section runs end-to-end
from derived Pluecker data at arbitrary odd length.

Pre-registered honesty license: `totalTurning` is definitionally the sum
of `linkIncrement`; if a coercion detail (Real vs the half-angle division)
needs an auxiliary rewriting lemma, add it as a helper.  Every
`s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DerivedWindingRingN

open Matrix Complex
open PhysicsSM.Draft.NullEdge.RingHolonomySpectrumN
open PhysicsSM.Draft.NullEdge.RingHolonomyHalfLinkN
open PhysicsSM.Draft.NullEdge.PlueckerWindingDerived

/-- The half-link field derived from a Pluecker phase field. -/
def derivedHalfLinkN (L : ℕ) [NeZero L] (z : ZMod L → ℂ) : ZMod L → ℂ :=
  halfLinkField L (linkIncrement z)

/-- Derived winding one forces holonomy `-1` at every length. -/
theorem holonomy_derivedHalfLinkN (L : ℕ) [NeZero L] (z : ZMod L → ℂ)
    (hturn : totalTurning z = 2 * Real.pi) :
    holonomy L (derivedHalfLinkN L z) = -1 := by
  convert holonomy_halfLinkField L (linkIncrement z) _
  exact hturn

/-- **Paper A completion.**  At every odd ring length, the ring built from
a derived winding-one Pluecker field is not unitarily conjugate to the
trivial ring. -/
theorem derived_winding_one_not_conjugate_trivial (L : ℕ) [NeZero L]
    (hodd : Odd L) (hL : 2 < L) (z : ZMod L → ℂ)
    (hturn : totalTurning z = 2 * Real.pi) :
    ¬ ∃ W : Matrix (ZMod L) (ZMod L) ℂ, W ∈ Matrix.unitaryGroup (ZMod L) ℂ ∧
      W * HRing L (derivedHalfLinkN L z) * Wᴴ = HRing L (fun _ => 1) := by
  convert halfLink_ring_not_conjugate_trivial L hodd hL (linkIncrement z) _ using 1
  exact hturn

end PhysicsSM.Draft.NullEdge.DerivedWindingRingN
