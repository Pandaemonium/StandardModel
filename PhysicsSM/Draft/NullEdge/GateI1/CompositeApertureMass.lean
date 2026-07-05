import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core

/-!
# Gate I1 / NE-U1: composite aperture mass (the "no primitive mass" keystone)

STATEMENT FREEZE for rung NE-U1 of the null-edge mass unification ladder
(`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md`).

The keystone kinematic identity: for future-pointing NULL momenta
`p_1 ... p_n`,

    M^2 = minkowskiSq (sum_i p_i) = sum_{i,j} minkDot (p_i) (p_j),

every cross term `minkDot p_i p_j` is NONNEGATIVE (reverse Cauchy-Schwarz on
the light cone), and `M^2 = 0` exactly when all constituents are collinear -
i.e. **a composite of null constituents is massless iff it is effectively a
single null edge**. Mass is the APERTURE of the null bundle: a sum of
pairwise angles, purely relational, with no primitive mass input anywhere.

The two-constituent case ties directly to the Gate I1 Plucker identity:
`det (minkHerm (p + q)) = minkowskiSq (p + q) = 2 * minkDot p q`, so
`det P = m^2` (I1 headline, `Core.det_minkHerm_eq_minkowskiSq`) is the
two-body germ of the composite/hadron mass story.

## Claim discipline (NULLSTRAND / NERD)

Claim label: **kinematic identity / finite identity**. This module makes NO
dynamical claim: it does not say WHY constituents stay non-collinear (that is
confinement, Track A / QMF territory - the closure obstruction), only that
non-collinearity IS mass for null composites. Frame status: `minkowskiSq` and
`minkDot` are Lorentz invariants; everything here is frame-invariant (unlike
the observer-conditioned entropy dictionary in `MassEntropyDictionary.lean`).
Mass-taxonomy note: this is taxonomy-row-agnostic KINEMATICS; using it as
evidence for any specific taxonomy row still requires that row's own
dynamical theorem (F-YM-CONFLATE discipline).

## Proof status

FULLY PROVED, no `s o r r y`: the bilinear-form layer (`minkDot`
polarization, double-sum expansion), the reverse Cauchy-Schwarz
nonnegativity on the future light cone (via the 3D Lagrange identity - a
ring identity, no inner-product machinery), the composite nonnegativity,
the two-body Plucker bridge, the pairwise-zero characterization, the
equality case of reverse Cauchy-Schwarz (collinearity extraction via a
cross-term elimination identity - no case split on components), and the
headline `compositeMassSq_eq_zero_iff_collinear`.

Prerequisites: `GateI1.Core` (for `Momentum4`, `minkowskiSq`, `minkHerm`,
`det_minkHerm_eq_minkowskiSq`). Successor: NE-U5 ("mass without mass" toy)
uses this module's reading; the entropy-dictionary extension is optional.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace CompositeApertureMass

open PhysicsSM.Draft.NullEdge.GateI1

/-- The Minkowski bilinear form (polar form of `minkowskiSq`), signature
`(+,-,-,-)` matching `Core.minkowskiSq`. -/
def minkDot (p q : Momentum4) : Real :=
  p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3

/-- `minkDot` is symmetric. -/
theorem minkDot_comm (p q : Momentum4) : minkDot p q = minkDot q p := by
  unfold minkDot; ring

/-- `minkDot` on the diagonal is the Minkowski square. -/
theorem minkDot_self (p : Momentum4) : minkDot p p = minkowskiSq p := by
  unfold minkDot minkowskiSq; ring

/-- Polarization: `Q(p + q) = Q p + Q q + 2 B(p, q)`. -/
theorem minkowskiSq_add (p q : Momentum4) :
    minkowskiSq (p + q) = minkowskiSq p + minkowskiSq q + 2 * minkDot p q := by
  unfold minkowskiSq minkDot
  simp only [Pi.add_apply]
  ring

/-- A momentum is null when its Minkowski square vanishes. -/
def IsNull (p : Momentum4) : Prop := minkowskiSq p = 0

/-- Future-pointing null: null with nonnegative energy. On the light cone
this forces `p 0 = sqrt (spatialNormSq p)`. -/
def IsFutureNull (p : Momentum4) : Prop := IsNull p ∧ 0 ≤ p 0

/-- **Reverse Cauchy-Schwarz on the future light cone**: two future-pointing
null momenta have nonnegative Minkowski product. Proof: with
`(p 0)^2 = |p_vec|^2` and `(q 0)^2 = |q_vec|^2`, the claim
`p 0 * q 0 >= p_vec . q_vec` follows from the 3D Lagrange identity
`|p_vec|^2 |q_vec|^2 - (p_vec . q_vec)^2 = |p_vec x q_vec|^2` - a pure ring
identity, so `nlinarith` closes it from the three cross-product squares. -/
theorem minkDot_nonneg_of_futureNull (p q : Momentum4)
    (hp : IsFutureNull p) (hq : IsFutureNull q) : 0 ≤ minkDot p q := by
  obtain ⟨hpnull, hp0⟩ := hp
  obtain ⟨hqnull, hq0⟩ := hq
  unfold IsNull minkowskiSq at hpnull hqnull
  unfold minkDot
  nlinarith [sq_nonneg (p 2 * q 3 - p 3 * q 2), sq_nonneg (p 3 * q 1 - p 1 * q 3),
    sq_nonneg (p 1 * q 2 - p 2 * q 1), mul_nonneg hp0 hq0,
    sq_nonneg (p 0 * q 0 - (p 1 * q 1 + p 2 * q 2 + p 3 * q 3)),
    sq_nonneg (p 0 * q 0 + (p 1 * q 1 + p 2 * q 2 + p 3 * q 3)),
    sq_nonneg (p 0 - q 0), sq_nonneg (p 0 + q 0)]

/-- **The double-sum expansion (the aperture identity, raw form)**: the
Minkowski square of a finite sum is the full double sum of pairwise Minkowski
products. No nullness needed - this is bilinearity. -/
theorem minkowskiSq_sum {ι : Type*} (s : Finset ι) (p : ι → Momentum4) :
    minkowskiSq (∑ i ∈ s, p i) = ∑ i ∈ s, ∑ j ∈ s, minkDot (p i) (p j) := by
  have hcomp : ∀ k : Fin 4, (∑ i ∈ s, p i) k = ∑ i ∈ s, p i k := by
    intro k; exact Finset.sum_apply k s p
  unfold minkowskiSq minkDot
  simp only [hcomp, sq, Finset.sum_mul_sum]
  rw [← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib]

/-- **Composite mass nonnegativity**: a composite of future-pointing null
momenta has nonnegative Minkowski square (no imaginary composite masses on
the null substrate). -/
theorem compositeMassSq_nonneg {ι : Type*} (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    0 ≤ minkowskiSq (∑ i ∈ s, p i) := by
  rw [minkowskiSq_sum]
  refine Finset.sum_nonneg fun i hi => Finset.sum_nonneg fun j hj => ?_
  exact minkDot_nonneg_of_futureNull _ _ (hnull i hi) (hnull j hj)

/-- **Masslessness = pairwise nullity**: the composite of future-pointing
null momenta is massless iff EVERY pairwise Minkowski product vanishes
(a sum of nonnegative terms is zero iff each term is). This is the
convention-free core of "massless iff effectively one null edge"; the
geometric collinearity reading is the separate handoff below. -/
theorem compositeMassSq_eq_zero_iff_pairwise {ι : Type*} (s : Finset ι)
    (p : ι → Momentum4) (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    minkowskiSq (∑ i ∈ s, p i) = 0 ↔
      ∀ i ∈ s, ∀ j ∈ s, minkDot (p i) (p j) = 0 := by
  rw [minkowskiSq_sum]
  rw [Finset.sum_eq_zero_iff_of_nonneg fun i hi =>
    Finset.sum_nonneg fun j hj =>
      minkDot_nonneg_of_futureNull _ _ (hnull i hi) (hnull j hj)]
  constructor
  · intro h i hi j hj
    have := h i hi
    rw [Finset.sum_eq_zero_iff_of_nonneg fun j hj =>
      minkDot_nonneg_of_futureNull _ _ (hnull i hi) (hnull j hj)] at this
    exact this j hj
  · intro h i hi
    exact Finset.sum_eq_zero fun j hj => h i hi j hj

/-- **The two-body Plucker bridge**: for null constituents the composite mass
square is exactly twice the cross product term, and it equals the
determinant of the soldered Hermitian block - so the Gate I1 headline
`det P = m^2` is the two-body case of the aperture identity. -/
theorem det_minkHerm_pair_eq_two_minkDot (p q : Momentum4)
    (hp : IsNull p) (hq : IsNull q) :
    (minkHerm (p + q)).det = 2 * minkDot p q := by
  rw [det_minkHerm_eq_minkowskiSq, minkowskiSq_add, hp, hq]
  push_cast
  ring

/-- **The equality case of reverse Cauchy-Schwarz on the future light cone**
(the collinearity extraction): for future-pointing null `p`, `q` with
`p <> 0`, the Minkowski product vanishes iff `q` is a NONNEGATIVE multiple of
`p`. Combined with `compositeMassSq_eq_zero_iff_pairwise` this yields the
headline "massless composite iff all constituents collinear".

Proof route (all ring-level): `minkDot = 0` plus the null conditions force
equality in Lagrange, so the spatial cross products vanish; then the
elimination identity `p 0 * (p 0 * q i - q 0 * p i) = 0` (multiply the dot
relation by `p i` and absorb the cross terms) gives every component of `q`
as `(q 0 / p 0) * p i` directly - no case split on which spatial component
of `p` is nonzero, and the degenerate `q = 0` case is covered by `c = 0`. -/
theorem minkDot_eq_zero_iff_smul_of_futureNull (p q : Momentum4)
    (hp : IsFutureNull p) (hq : IsFutureNull q) (hpne : p ≠ 0) :
    minkDot p q = 0 ↔ ∃ c : Real, 0 ≤ c ∧ q = c • p := by
  obtain ⟨hpnull, hp0⟩ := hp
  obtain ⟨hqnull, hq0⟩ := hq
  unfold IsNull minkowskiSq at hpnull hqnull
  -- `p <> 0` on the future cone forces strictly positive energy.
  have hp0pos : 0 < p 0 := by
    rcases hp0.lt_or_eq with h | h
    · exact h
    · exfalso
      apply hpne
      have hp00 : p 0 = 0 := h.symm
      rw [hp00] at hpnull
      have h1 : p 1 ^ 2 + p 2 ^ 2 + p 3 ^ 2 = 0 := by linarith [hpnull]
      have hp1z : p 1 = 0 := by
        have : p 1 ^ 2 = 0 :=
          le_antisymm (by nlinarith [sq_nonneg (p 2), sq_nonneg (p 3)]) (sq_nonneg _)
        exact pow_eq_zero_iff two_ne_zero |>.mp this
      have hp2z : p 2 = 0 := by
        have : p 2 ^ 2 = 0 :=
          le_antisymm (by nlinarith [sq_nonneg (p 1), sq_nonneg (p 3)]) (sq_nonneg _)
        exact pow_eq_zero_iff two_ne_zero |>.mp this
      have hp3z : p 3 = 0 := by
        have : p 3 ^ 2 = 0 :=
          le_antisymm (by nlinarith [sq_nonneg (p 1), sq_nonneg (p 2)]) (sq_nonneg _)
        exact pow_eq_zero_iff two_ne_zero |>.mp this
      funext k
      fin_cases k
      · exact hp00
      · exact hp1z
      · exact hp2z
      · exact hp3z
  have hp0ne : p 0 ≠ 0 := ne_of_gt hp0pos
  constructor
  · intro hdot
    unfold minkDot at hdot
    -- Equality in Lagrange: the spatial cross products all vanish.
    have hp' : p 1 ^ 2 + p 2 ^ 2 + p 3 ^ 2 = p 0 ^ 2 := by linarith [hpnull]
    have hq' : q 1 ^ 2 + q 2 ^ 2 + q 3 ^ 2 = q 0 ^ 2 := by linarith [hqnull]
    have hd : p 1 * q 1 + p 2 * q 2 + p 3 * q 3 = p 0 * q 0 := by linarith [hdot]
    have hcross : (p 2 * q 3 - p 3 * q 2) ^ 2 + (p 3 * q 1 - p 1 * q 3) ^ 2
        + (p 1 * q 2 - p 2 * q 1) ^ 2 = 0 := by
      have lagrange : (p 2 * q 3 - p 3 * q 2) ^ 2 + (p 3 * q 1 - p 1 * q 3) ^ 2
          + (p 1 * q 2 - p 2 * q 1) ^ 2
          = (p 1 ^ 2 + p 2 ^ 2 + p 3 ^ 2) * (q 1 ^ 2 + q 2 ^ 2 + q 3 ^ 2)
            - (p 1 * q 1 + p 2 * q 2 + p 3 * q 3) ^ 2 := by ring
      rw [lagrange, hp', hq', hd]
      ring
    have h1 : p 2 * q 3 - p 3 * q 2 = 0 := by
      have hle : (p 2 * q 3 - p 3 * q 2) ^ 2 ≤ 0 := by
        nlinarith [sq_nonneg (p 3 * q 1 - p 1 * q 3), sq_nonneg (p 1 * q 2 - p 2 * q 1)]
      have : (p 2 * q 3 - p 3 * q 2) ^ 2 = 0 := le_antisymm hle (sq_nonneg _)
      exact pow_eq_zero_iff two_ne_zero |>.mp this
    have h2 : p 3 * q 1 - p 1 * q 3 = 0 := by
      have hle : (p 3 * q 1 - p 1 * q 3) ^ 2 ≤ 0 := by
        nlinarith [sq_nonneg (p 2 * q 3 - p 3 * q 2), sq_nonneg (p 1 * q 2 - p 2 * q 1)]
      have : (p 3 * q 1 - p 1 * q 3) ^ 2 = 0 := le_antisymm hle (sq_nonneg _)
      exact pow_eq_zero_iff two_ne_zero |>.mp this
    have h3 : p 1 * q 2 - p 2 * q 1 = 0 := by
      have hle : (p 1 * q 2 - p 2 * q 1) ^ 2 ≤ 0 := by
        nlinarith [sq_nonneg (p 2 * q 3 - p 3 * q 2), sq_nonneg (p 3 * q 1 - p 1 * q 3)]
      have : (p 1 * q 2 - p 2 * q 1) ^ 2 = 0 := le_antisymm hle (sq_nonneg _)
      exact pow_eq_zero_iff two_ne_zero |>.mp this
    -- The elimination identities `p 0 * (p 0 * q i - q 0 * p i) = 0`.
    have k1 : p 0 * (p 0 * q 1 - q 0 * p 1) = 0 := by
      linear_combination q 1 * hpnull - p 1 * hdot + p 3 * h2 - p 2 * h3
    have k2 : p 0 * (p 0 * q 2 - q 0 * p 2) = 0 := by
      linear_combination q 2 * hpnull - p 2 * hdot + p 1 * h3 - p 3 * h1
    have k3 : p 0 * (p 0 * q 3 - q 0 * p 3) = 0 := by
      linear_combination q 3 * hpnull - p 3 * hdot + p 2 * h1 - p 1 * h2
    have e1 : p 0 * q 1 - q 0 * p 1 = 0 := (mul_eq_zero.mp k1).resolve_left hp0ne
    have e2 : p 0 * q 2 - q 0 * p 2 = 0 := (mul_eq_zero.mp k2).resolve_left hp0ne
    have e3 : p 0 * q 3 - q 0 * p 3 = 0 := (mul_eq_zero.mp k3).resolve_left hp0ne
    refine ⟨q 0 / p 0, div_nonneg hq0 hp0, ?_⟩
    have hc0 : q 0 = q 0 / p 0 * p 0 := by field_simp
    have hc1 : q 1 = q 0 / p 0 * p 1 := by field_simp; linear_combination e1
    have hc2 : q 2 = q 0 / p 0 * p 2 := by field_simp; linear_combination e2
    have hc3 : q 3 = q 0 / p 0 * p 3 := by field_simp; linear_combination e3
    funext k
    fin_cases k
    · exact hc0
    · exact hc1
    · exact hc2
    · exact hc3
  · rintro ⟨c, -, rfl⟩
    unfold minkDot
    simp only [Pi.smul_apply, smul_eq_mul]
    linear_combination c * hpnull

/-- `minkDot` vanishes against the zero momentum. -/
theorem minkDot_zero_left (q : Momentum4) : minkDot 0 q = 0 := by
  unfold minkDot
  simp

/-- **THE HEADLINE ("massless composite iff effectively one null edge")**:
a composite of future-pointing null momenta is massless iff every
constituent is a nonnegative multiple of every nonzero constituent - i.e.
iff the whole bundle points along a single null direction (zero
constituents allowed as degenerate members). Mass is exactly the APERTURE
of the null bundle. -/
theorem compositeMassSq_eq_zero_iff_collinear {ι : Type*} (s : Finset ι)
    (p : ι → Momentum4) (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    minkowskiSq (∑ i ∈ s, p i) = 0 ↔
      ∀ i ∈ s, ∀ j ∈ s, p i ≠ 0 → ∃ c : Real, 0 ≤ c ∧ p j = c • p i := by
  rw [compositeMassSq_eq_zero_iff_pairwise s p hnull]
  constructor
  · intro h i hi j hj hne
    exact (minkDot_eq_zero_iff_smul_of_futureNull _ _ (hnull i hi) (hnull j hj)
      hne).mp (h i hi j hj)
  · intro h i hi j hj
    by_cases hne : p i = 0
    · rw [hne]
      exact minkDot_zero_left _
    · exact (minkDot_eq_zero_iff_smul_of_futureNull _ _ (hnull i hi) (hnull j hj)
        hne).mpr (h i hi j hj hne)

end CompositeApertureMass
end PhysicsSM.Draft.NullEdge.GateI1
