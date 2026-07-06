import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
import PhysicsSM.Draft.NullEdge.GateI1.ApertureEqualsTurn

/-!
# Gate I1 / NE-U1 — Lane A: the full N-body origin of mass (aperture of the null bundle)

This module generalizes the composite aperture mass story to `N` null
constituents indexed by an arbitrary `Finset`.  It is a pure ASSEMBLY module:
every mathematical fact is reused from `CompositeApertureMass` (and the
two-body germ from `ApertureEqualsTurn`); nothing new is postulated.

## Deliverables (as requested by Lane A)

1. **The N-body aperture identity + nonnegativity.**  For a `Finset s` of
   future-null momenta `p : ι → Momentum4`,

   * the double-sum (bilinear) form
     `minkowskiSq (∑ i ∈ s, p i) = ∑ i ∈ s, ∑ j ∈ s, minkDot (p i) (p j)`
     (`nbody_massSq_eq_double_sum`, from `minkowskiSq_sum`), and
   * each cross term is nonnegative (`minkDot_nonneg_of_futureNull`), hence
     the composite Minkowski square is nonnegative
     (`nbody_massSq_nonneg`, from `compositeMassSq_nonneg`).

   The requested strict upper-triangular `∑_{i<j} 2 · minkDot` presentation
   is provided as `nbody_massSq_eq_sum_pairwise` — see the PROOF STATUS note
   below: it is a purely cosmetic re-indexing of the (proved) double sum, and
   is now fully proved (no `sorry`).

2. **THE HEADLINE (any N).**  `nbody_aperture_massless_iff_collinear`:
   `minkowskiSq (∑ i ∈ s, p i) = 0 ↔` the whole bundle points along a single
   null direction (every constituent a nonnegative multiple of every nonzero
   constituent).  Directly `compositeMassSq_eq_zero_iff_collinear`.  This is
   the full N-body statement of "mass = aperture of the null bundle": the
   composite is massless iff it is effectively one null edge, for ANY N.

## Claim discipline

Kinematic / finite identity only — no dynamical content, `minkDot` and
`minkowskiSq` are Lorentz invariants, everything is frame-invariant.  No new
axiom, no `native_decide`, no weakening of the statements.

## Proof status (see report `AgentTasks/.../NBodyAperture_report.md`)

* `nbody_massSq_eq_double_sum` — PROVED (reuse of `minkowskiSq_sum`).
* `nbody_massSq_nonneg` — PROVED (reuse of `compositeMassSq_nonneg`).
* `nbody_massSq_eq_zero_iff_pairwise` — PROVED (reuse).
* `nbody_aperture_massless_iff_collinear` (THE HEADLINE) — PROVED (reuse of
  `compositeMassSq_eq_zero_iff_collinear`).
* `nbody_massSq_eq_sum_pairwise` — PROVED: the strict-upper-triangular
  `∑_{i<j} 2·minkDot` re-indexing of the already-proved double sum, using the
  diagonal vanishing `minkDot (p i) (p i) = 0` for null `p i` and the symmetry
  `minkDot_comm` (trichotomy split + `Finset.sum_comm'`).
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace NBodyAperture

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass

/-! ## 1. The N-body aperture identity and nonnegativity -/

/-- **N-body aperture identity (bilinear / double-sum form).**  The Minkowski
square of a finite sum of momenta is the full double sum of pairwise Minkowski
products.  No nullness needed — pure bilinearity.  Reuse of
`CompositeApertureMass.minkowskiSq_sum`. -/
theorem nbody_massSq_eq_double_sum {ι : Type*} (s : Finset ι) (p : ι → Momentum4) :
    minkowskiSq (∑ i ∈ s, p i) = ∑ i ∈ s, ∑ j ∈ s, minkDot (p i) (p j) :=
  minkowskiSq_sum s p

/-- **N-body cross-term nonnegativity.**  Each pairwise Minkowski product of
future-null momenta is nonnegative (reverse Cauchy–Schwarz on the future light
cone).  Reuse of `CompositeApertureMass.minkDot_nonneg_of_futureNull`. -/
theorem nbody_minkDot_nonneg {ι : Type*} (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    ∀ i ∈ s, ∀ j ∈ s, 0 ≤ minkDot (p i) (p j) :=
  fun i hi j hj => minkDot_nonneg_of_futureNull _ _ (hnull i hi) (hnull j hj)

/-- **N-body composite-mass nonnegativity.**  A composite of future-null
momenta has nonnegative Minkowski square (no imaginary composite masses on the
null substrate).  Reuse of `CompositeApertureMass.compositeMassSq_nonneg`. -/
theorem nbody_massSq_nonneg {ι : Type*} (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    0 ≤ minkowskiSq (∑ i ∈ s, p i) :=
  compositeMassSq_nonneg s p hnull

/-- **Strict upper-triangular (`∑_{i<j} 2·minkDot`) aperture identity.**  For
future-null constituents indexed by a linearly ordered type, the composite
Minkowski square is exactly twice the sum of the strictly-ordered pairwise
Minkowski products (the diagonal terms `minkDot (p i) (p i) = minkowskiSq (p i)`
vanish by nullness, and off-diagonal terms pair up by `minkDot_comm`).

PROOF STATUS: PROVED.  A pure combinatorial re-indexing of the already-proved
`nbody_massSq_eq_double_sum`: the full double sum is split by trichotomy into
the strict upper triangle (`i < j`), the strict lower triangle (`j < i`) and
the diagonal (`i = j`).  The diagonal terms vanish because
`minkDot (p i) (p i) = minkowskiSq (p i) = 0` for future-null `p i`, and the
lower triangle is turned into the upper triangle via `Finset.sum_comm'` and
`minkDot_comm`, yielding the factor `2`. -/
theorem nbody_massSq_eq_sum_pairwise {ι : Type*} [LinearOrder ι]
    (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    minkowskiSq (∑ i ∈ s, p i)
      = ∑ i ∈ s, ∑ j ∈ s.filter (i < ·), 2 * minkDot (p i) (p j) := by
  rw [nbody_massSq_eq_double_sum]
  have key :
      ∑ i ∈ s, ∑ j ∈ s.filter (· < i), minkDot (p i) (p j)
        = ∑ i ∈ s, ∑ j ∈ s.filter (i < ·), minkDot (p i) (p j) := by
    rw [Finset.sum_comm' (t' := s) (s' := fun j => s.filter (j < ·))
        (by intro x y; simp only [Finset.mem_filter]; tauto)]
    exact Finset.sum_congr rfl fun i _ =>
      Finset.sum_congr rfl fun j _ => minkDot_comm (p j) (p i)
  have split : ∀ i ∈ s, ∑ j ∈ s, minkDot (p i) (p j)
      = ∑ j ∈ s.filter (i < ·), minkDot (p i) (p j)
        + ∑ j ∈ s.filter (· < i), minkDot (p i) (p j) := by
    intro i hi
    rw [← Finset.sum_filter_add_sum_filter_not s (i < ·) (minkDot (p i) <| p ·)]
    congr 1
    have hset : s.filter (fun j => ¬ i < j) = insert i (s.filter (· < i)) := by
      ext j
      simp only [Finset.mem_filter, Finset.mem_insert]
      constructor
      · rintro ⟨hjs, hij⟩
        rcases lt_trichotomy j i with h | h | h
        · exact Or.inr ⟨hjs, h⟩
        · exact Or.inl h
        · exact absurd h hij
      · rintro (rfl | ⟨hjs, hji⟩)
        · exact ⟨hi, lt_irrefl _⟩
        · exact ⟨hjs, not_lt.mpr (le_of_lt hji)⟩
    rw [hset, Finset.sum_insert (by simp),
      (minkDot_self (p i)).trans (hnull i hi).1, zero_add]
  calc ∑ i ∈ s, ∑ j ∈ s, minkDot (p i) (p j)
      = ∑ i ∈ s, (∑ j ∈ s.filter (i < ·), minkDot (p i) (p j)
          + ∑ j ∈ s.filter (· < i), minkDot (p i) (p j)) :=
        Finset.sum_congr rfl split
    _ = ∑ i ∈ s, ∑ j ∈ s.filter (i < ·), minkDot (p i) (p j)
        + ∑ i ∈ s, ∑ j ∈ s.filter (· < i), minkDot (p i) (p j) := by
          rw [Finset.sum_add_distrib]
    _ = ∑ i ∈ s, ∑ j ∈ s.filter (i < ·), minkDot (p i) (p j)
        + ∑ i ∈ s, ∑ j ∈ s.filter (i < ·), minkDot (p i) (p j) := by rw [key]
    _ = ∑ i ∈ s, ∑ j ∈ s.filter (i < ·), 2 * minkDot (p i) (p j) := by
        rw [← Finset.sum_add_distrib]
        exact Finset.sum_congr rfl fun i _ => by
          rw [← Finset.sum_add_distrib]
          exact Finset.sum_congr rfl fun j _ => by ring

/-! ## 2. The N-body headline: massless iff one null direction -/

/-- **Masslessness = pairwise nullity (any N).**  Reuse of
`CompositeApertureMass.compositeMassSq_eq_zero_iff_pairwise`. -/
theorem nbody_massSq_eq_zero_iff_pairwise {ι : Type*} (s : Finset ι)
    (p : ι → Momentum4) (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    minkowskiSq (∑ i ∈ s, p i) = 0 ↔
      ∀ i ∈ s, ∀ j ∈ s, minkDot (p i) (p j) = 0 :=
  compositeMassSq_eq_zero_iff_pairwise s p hnull

/-- **THE N-BODY HEADLINE — "mass = aperture of the null bundle".**  For ANY
`N` (any `Finset s`) of future-null momenta, the composite is massless iff the
whole bundle points along a single null direction — every constituent a
nonnegative multiple of every nonzero constituent, i.e. it is effectively one
null edge.  Reuse of
`CompositeApertureMass.compositeMassSq_eq_zero_iff_collinear`. -/
theorem nbody_aperture_massless_iff_collinear {ι : Type*} (s : Finset ι)
    (p : ι → Momentum4) (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    minkowskiSq (∑ i ∈ s, p i) = 0 ↔
      ∀ i ∈ s, ∀ j ∈ s, p i ≠ 0 → ∃ c : Real, 0 ≤ c ∧ p j = c • p i :=
  compositeMassSq_eq_zero_iff_collinear s p hnull

end NBodyAperture
end PhysicsSM.Draft.NullEdge.GateI1
