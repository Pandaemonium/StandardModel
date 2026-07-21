import PhysicsSM.Draft.NullEdge.RingHolonomyAllN

/-!
# Ring-holonomy classification: holonomy is a COMPLETE gauge invariant

Target statements for the Aristotle job `ring-holonomy-classification-20260719`.

Context.  The landed chain proves: gauge transformations preserve holonomy
(`holonomy_gauge_invariant`), gauge-related fields give unitarily conjugate
Hamiltonians (`HRing_gauge_conjugacy`), and different holonomy REAL PARTS
give non-conjugate Hamiltonians at every `n > 2` (`RingHolonomyAllN`).
This module states the CONVERSE half: equal holonomy forces gauge
equivalence - so holonomy is a complete invariant of unit-link ring fields
up to gauge, and the spectral discriminator chain closes into a
classification statement.

Route: on a ring, fix the gauge site-by-site - define
`g 0 = 1`, `g (k+1) = g k * u k / v k` walking around; the closure
constraint at the last link is exactly `holonomy u = holonomy v`.
Unit-modulus of `g` follows from unit links.

Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.RingHolonomyClassification

open PhysicsSM.Draft.NullEdge.RingHolonomySpectrumN

/-- **Completeness of the holonomy invariant.**  Unit-link fields with
equal holonomy are gauge-equivalent (with a unit-modulus gauge). -/
theorem exists_gauge_of_holonomy_eq (n : ℕ) [NeZero n]
    (u v : ZMod n → ℂ) (hu : UnitLinks n u) (hv : UnitLinks n v)
    (h : holonomy n u = holonomy n v) :
    ∃ g : ZMod n → ℂ, (∀ k, ‖g k‖ = 1) ∧ gaugedLinks n g u = v := by
  sorry

/-- **Classification corollary.**  For unit-link fields, equal holonomy
gives unitarily conjugate ring Hamiltonians (composing completeness with
the landed gauge conjugacy). -/
theorem unitarily_conjugate_of_holonomy_eq (n : ℕ) [NeZero n]
    (hn : 2 < n) (u v : ZMod n → ℂ)
    (hu : UnitLinks n u) (hv : UnitLinks n v)
    (h : holonomy n u = holonomy n v) :
    ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n u * Wᴴ = HRing n v := by
  sorry

end PhysicsSM.Draft.NullEdge.RingHolonomyClassification
