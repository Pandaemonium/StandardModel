import Mathlib

/-!
# Gate I1 / NE-U1 — n-body aperture = turn: the composite mass is the total turn of the null bundle

This module generalizes the two-body `aperture = turn` germ to the **n-body**
case: the composite aperture mass-squared of `N` future-null momenta is a sum
over unordered pairs of a per-pair **turn** quantity — the relative
rapidity/angle content `turn kᵢ kⱼ = 2 · minkDot kᵢ kⱼ` between the two null
directions.  The composite is massless iff every pairwise turn vanishes iff the
whole bundle points along a single null direction.

## Provenance / self-containedness

The task attached two source files, `ApertureEqualsTurn.lean` and
`NBodyAperture.lean`.  Both `import`
`PhysicsSM.Draft.NullEdge.GateI1.Core`,
`PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass`,
`PhysicsSM.Draft.NullEdge.GateI1.MassCoinBridge` and
`PhysicsSM.Draft.NullEdge.GateYM.ChiralMassStructure`, none of which are present
anywhere in this project (there are no `PhysicsSM` sources or `.olean`s).  As a
consequence the two attached files cannot be elaborated in this environment, and
neither can any file that imports them.

To deliver a genuinely typechecking artifact this module is therefore
**self-contained**: it reconstructs, from Mathlib only, the small piece of
Minkowski kinematics the story needs (`Momentum4`, `minkDot`, `minkowskiSq`,
`IsNull`, `IsFutureNull`), reproves the reused facts
(`nbody_aperture_massless_iff_collinear`, the strict-upper-triangular pairwise
identity, and the two-body germ `twoNull_aperture_massSq`), and then states and
proves the n-body `aperture = turn` deliverables.  The definitions match those
used by the attached files, so the results transport verbatim once the external
library is available.

## Deliverables

* `nbody_compositeMassSq_eq_sum_turn` — the finite kinematic identity
  `minkowskiSq (∑ i, p i) = ∑_{i<j} turn (p i) (p j)`.
* `nbody_aperture_massless_iff_turns_zero` — massless iff every pairwise turn
  vanishes.
* `nbody_aperture_massless_iff_collinear` — massless iff a single null direction
  (the reused headline).
* `nbody_turn_iff` chaining the two above.
* `twoNull_aperture_massSq` / `twoNull_turn_eq_massSq` — the two-body germ tying
  the per-pair turn to the `ApertureEqualsTurn` bridge, and its embedding as the
  `N = 2` instance of the n-body identity (`twobody_massSq_eq_turn`).

## Claim discipline

**Honest label: finite kinematic identity.**  Every statement is a Lorentz-
invariant finite identity / inequality about null four-momenta; no dynamical
content, no new axiom, no `native_decide`, no `sorry`.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace NBodyApertureTurn

/-! ## 0. Minkowski kinematic scaffolding (reconstructed from Mathlib) -/

/-- A four-momentum: a real function on the four Lorentz indices `Fin 4`
(index `0` temporal, `1,2,3` spatial).  `abbrev` so the pointwise
`+`, `•`, `0` `Pi` instances apply. -/
abbrev Momentum4 := Fin 4 → ℝ

/-- The Minkowski bilinear product with signature `(+,-,-,-)`. -/
def minkDot (p q : Momentum4) : ℝ :=
  p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3

/-- The Minkowski square (mass-squared) of a four-momentum. -/
def minkowskiSq (p : Momentum4) : ℝ := minkDot p p

/-- `p` is null (lightlike): `minkowskiSq p = 0`. -/
def IsNull (p : Momentum4) : Prop := minkowskiSq p = 0

/-- `p` is future-null: null and future-pointing (`0 ≤ p 0`). -/
def IsFutureNull (p : Momentum4) : Prop := IsNull p ∧ 0 ≤ p 0

/-- **The per-pair turn.**  Twice the Minkowski product of two null directions;
for future-null momenta this is `2 |k⃗ᵢ||k⃗ⱼ| (1 − cos θᵢⱼ) ≥ 0`, the relative
rapidity/angle content ("turn") between the two null edges. -/
def turn (p q : Momentum4) : ℝ := 2 * minkDot p q

/-! ### Basic algebra of `minkDot` -/

theorem minkDot_comm (p q : Momentum4) : minkDot p q = minkDot q p := by
  unfold minkDot; ring

theorem minkDot_self (p : Momentum4) : minkDot p p = minkowskiSq p := rfl

theorem minkDot_zero_left (q : Momentum4) : minkDot 0 q = 0 := by
  unfold minkDot; simp

theorem minkDot_smul_right (c : ℝ) (p q : Momentum4) :
    minkDot p (c • q) = c * minkDot p q := by
  unfold minkDot; simp only [Pi.smul_apply, smul_eq_mul]; ring

theorem minkowskiSq_add (p q : Momentum4) :
    minkowskiSq (p + q) = minkowskiSq p + 2 * minkDot p q + minkowskiSq q := by
  unfold minkowskiSq minkDot; simp only [Pi.add_apply]; ring

/-- Bilinearity: the Minkowski product of two finite sums is the double sum of
the pairwise products. -/
theorem minkDot_sum_sum {ι κ : Type*} (s : Finset ι) (t : Finset κ)
    (p : ι → Momentum4) (q : κ → Momentum4) :
    minkDot (∑ i ∈ s, p i) (∑ j ∈ t, q j)
      = ∑ i ∈ s, ∑ j ∈ t, minkDot (p i) (q j) := by
  unfold minkDot
  simp only [Finset.sum_apply]
  rw [Finset.sum_mul_sum, Finset.sum_mul_sum, Finset.sum_mul_sum, Finset.sum_mul_sum]
  simp only [← Finset.sum_sub_distrib]

/-- **N-body aperture identity (double-sum form).** Pure bilinearity. -/
theorem minkowskiSq_sum {ι : Type*} (s : Finset ι) (p : ι → Momentum4) :
    minkowskiSq (∑ i ∈ s, p i) = ∑ i ∈ s, ∑ j ∈ s, minkDot (p i) (p j) :=
  minkDot_sum_sum s s p p

/-! ### Positivity on the future light cone -/

/-- **Cross-term nonnegativity (reverse Cauchy–Schwarz on the future cone).**
The Minkowski product of two future-null momenta is nonnegative. -/
theorem minkDot_nonneg_of_futureNull (p q : Momentum4)
    (hp : IsFutureNull p) (hq : IsFutureNull q) : 0 ≤ minkDot p q := by
  obtain ⟨hpn, hp0⟩ := hp
  obtain ⟨hqn, hq0⟩ := hq
  unfold IsNull minkowskiSq minkDot at hpn hqn
  unfold minkDot
  nlinarith [sq_nonneg (p 1 * q 2 - p 2 * q 1), sq_nonneg (p 1 * q 3 - p 3 * q 1),
    sq_nonneg (p 2 * q 3 - p 3 * q 2),
    sq_nonneg (p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3),
    mul_nonneg hp0 hq0, sq_nonneg (p 0 * q 0)]

/-- The turn between two future-null momenta is nonnegative. -/
theorem turn_nonneg_of_futureNull (p q : Momentum4)
    (hp : IsFutureNull p) (hq : IsFutureNull q) : 0 ≤ turn p q := by
  unfold turn
  have := minkDot_nonneg_of_futureNull p q hp hq
  linarith

/-- A nonzero future-null momentum has strictly positive energy. -/
theorem futureNull_pos_zero (p : Momentum4) (hp : IsFutureNull p) (hne : p ≠ 0) :
    0 < p 0 := by
  obtain ⟨hpn, hp0⟩ := hp
  unfold IsNull minkowskiSq minkDot at hpn
  rcases lt_or_eq_of_le hp0 with h | h
  · exact h
  · exfalso; apply hne
    have h1 : p 1 = 0 := by nlinarith [sq_nonneg (p 1), sq_nonneg (p 2), sq_nonneg (p 3)]
    have h2 : p 2 = 0 := by nlinarith [sq_nonneg (p 1), sq_nonneg (p 2), sq_nonneg (p 3)]
    have h3 : p 3 = 0 := by nlinarith [sq_nonneg (p 1), sq_nonneg (p 2), sq_nonneg (p 3)]
    funext i; fin_cases i <;> simp [h1, h2, h3, ← h]

/-- **Equality case (collinearity extraction).**  If two future-null momenta
have vanishing Minkowski product and the first is nonzero, the second is a
nonnegative multiple of the first — the two null edges coincide as directions. -/
theorem futureNull_collinear (p q : Momentum4) (hp : IsFutureNull p)
    (hq : IsFutureNull q) (hpq : minkDot p q = 0) (hne : p ≠ 0) :
    ∃ c : ℝ, 0 ≤ c ∧ q = c • p := by
  have hp0pos : 0 < p 0 := futureNull_pos_zero p hp hne
  have hp0ne : p 0 ≠ 0 := ne_of_gt hp0pos
  obtain ⟨hpn, hp0⟩ := hp
  obtain ⟨hqn, hq0⟩ := hq
  unfold IsNull minkowskiSq minkDot at hpn hqn
  unfold minkDot at hpq
  refine ⟨q 0 / p 0, by positivity, ?_⟩
  have hsum : (p 0 * q 1 - q 0 * p 1) ^ 2 + (p 0 * q 2 - q 0 * p 2) ^ 2
      + (p 0 * q 3 - q 0 * p 3) ^ 2 = 0 := by
    linear_combination (-(q 0) ^ 2) * hpn + (-(p 0) ^ 2) * hqn + (2 * p 0 * q 0) * hpq
  have e1 : p 0 * q 1 - q 0 * p 1 = 0 := by
    nlinarith [sq_nonneg (p 0 * q 1 - q 0 * p 1), sq_nonneg (p 0 * q 2 - q 0 * p 2),
      sq_nonneg (p 0 * q 3 - q 0 * p 3)]
  have e2 : p 0 * q 2 - q 0 * p 2 = 0 := by
    nlinarith [sq_nonneg (p 0 * q 1 - q 0 * p 1), sq_nonneg (p 0 * q 2 - q 0 * p 2),
      sq_nonneg (p 0 * q 3 - q 0 * p 3)]
  have e3 : p 0 * q 3 - q 0 * p 3 = 0 := by
    nlinarith [sq_nonneg (p 0 * q 1 - q 0 * p 1), sq_nonneg (p 0 * q 2 - q 0 * p 2),
      sq_nonneg (p 0 * q 3 - q 0 * p 3)]
  have c0 : q 0 = q 0 / p 0 * p 0 := by field_simp
  have c1 : q 1 = q 0 / p 0 * p 1 := by rw [div_mul_eq_mul_div, eq_div_iff hp0ne]; linarith [e1]
  have c2 : q 2 = q 0 / p 0 * p 2 := by rw [div_mul_eq_mul_div, eq_div_iff hp0ne]; linarith [e2]
  have c3 : q 3 = q 0 / p 0 * p 3 := by rw [div_mul_eq_mul_div, eq_div_iff hp0ne]; linarith [e3]
  funext i
  fin_cases i <;> simp only [Pi.smul_apply, smul_eq_mul]
  · exact c0
  · exact c1
  · exact c2
  · exact c3

/-- The converse direction: if `q = c • p` with `p` null, their Minkowski
product vanishes. -/
theorem minkDot_eq_zero_of_smul (c : ℝ) (p : Momentum4) (hp : IsNull p) :
    minkDot p (c • p) = 0 := by
  rw [minkDot_smul_right, minkDot_self, hp, mul_zero]

/-! ## 1. Composite nonnegativity and the pairwise (upper-triangular) identity -/

/-- **N-body composite-mass nonnegativity.** -/
theorem nbody_massSq_nonneg {ι : Type*} (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    0 ≤ minkowskiSq (∑ i ∈ s, p i) := by
  rw [minkowskiSq_sum]
  refine Finset.sum_nonneg fun i hi => Finset.sum_nonneg fun j hj => ?_
  exact minkDot_nonneg_of_futureNull _ _ (hnull i hi) (hnull j hj)

/-- **Strict upper-triangular (`∑_{i<j} 2·minkDot`) aperture identity.**  A pure
combinatorial re-indexing of the double-sum `minkowskiSq_sum`: the diagonal
`minkDot (p i) (p i) = minkowskiSq (p i)` vanishes by nullness, and off-diagonal
terms pair up by `minkDot_comm`, yielding the factor `2`. -/
theorem nbody_massSq_eq_sum_pairwise {ι : Type*} [LinearOrder ι]
    (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    minkowskiSq (∑ i ∈ s, p i)
      = ∑ i ∈ s, ∑ j ∈ s.filter (i < ·), 2 * minkDot (p i) (p j) := by
  rw [minkowskiSq_sum]
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

/-- **THE N-BODY APERTURE = TURN IDENTITY.**  For a `Finset s` of future-null
momenta, the composite aperture mass-squared is exactly the sum, over unordered
pairs `i < j`, of the per-pair turn `turn (p i) (p j) = 2 · minkDot (p i) (p j)`
between the two null directions.  Honest label: a finite kinematic identity. -/
theorem nbody_compositeMassSq_eq_sum_turn {ι : Type*} [LinearOrder ι]
    (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    minkowskiSq (∑ i ∈ s, p i)
      = ∑ i ∈ s, ∑ j ∈ s.filter (i < ·), turn (p i) (p j) := by
  simpa only [turn] using nbody_massSq_eq_sum_pairwise s p hnull

/-! ## 2. Vanishing criteria: pairwise turns and single null direction -/

/-- **Masslessness = pairwise nullity (any N).** -/
theorem nbody_massSq_eq_zero_iff_pairwise {ι : Type*} (s : Finset ι)
    (p : ι → Momentum4) (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    minkowskiSq (∑ i ∈ s, p i) = 0 ↔
      ∀ i ∈ s, ∀ j ∈ s, minkDot (p i) (p j) = 0 := by
  rw [minkowskiSq_sum]
  constructor
  · intro h i hi j hj
    have hnn : ∀ a ∈ s, 0 ≤ ∑ b ∈ s, minkDot (p a) (p b) := fun a ha =>
      Finset.sum_nonneg fun b hb =>
        minkDot_nonneg_of_futureNull _ _ (hnull a ha) (hnull b hb)
    have hi0 : ∑ b ∈ s, minkDot (p i) (p b) = 0 :=
      (Finset.sum_eq_zero_iff_of_nonneg hnn).1 h i hi
    have hnn' : ∀ b ∈ s, 0 ≤ minkDot (p i) (p b) := fun b hb =>
      minkDot_nonneg_of_futureNull _ _ (hnull i hi) (hnull b hb)
    exact (Finset.sum_eq_zero_iff_of_nonneg hnn').1 hi0 j hj
  · intro h
    refine Finset.sum_eq_zero fun i hi => Finset.sum_eq_zero fun j hj => h i hi j hj

/-- **Masslessness = every pairwise turn vanishes (any N).**  The composite is
massless iff the null bundle carries no turn on any pair. -/
theorem nbody_aperture_massless_iff_turns_zero {ι : Type*} (s : Finset ι)
    (p : ι → Momentum4) (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    minkowskiSq (∑ i ∈ s, p i) = 0 ↔
      ∀ i ∈ s, ∀ j ∈ s, turn (p i) (p j) = 0 := by
  rw [nbody_massSq_eq_zero_iff_pairwise s p hnull]
  unfold turn
  constructor
  · intro h i hi j hj; rw [h i hi j hj, mul_zero]
  · intro h i hi j hj
    have := h i hi j hj
    linarith

/-- **THE N-BODY HEADLINE — "mass = aperture of the null bundle".**  For ANY
`N` (any `Finset s`) of future-null momenta, the composite is massless iff the
whole bundle points along a single null direction — every constituent a
nonnegative multiple of every nonzero constituent, i.e. it is effectively one
null edge.  (Reconstructed reuse of the attached
`NBodyAperture.nbody_aperture_massless_iff_collinear`.) -/
theorem nbody_aperture_massless_iff_collinear {ι : Type*} (s : Finset ι)
    (p : ι → Momentum4) (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    minkowskiSq (∑ i ∈ s, p i) = 0 ↔
      ∀ i ∈ s, ∀ j ∈ s, p i ≠ 0 → ∃ c : ℝ, 0 ≤ c ∧ p j = c • p i := by
  rw [nbody_massSq_eq_zero_iff_pairwise s p hnull]
  constructor
  · intro h i hi j hj hne
    exact futureNull_collinear (p i) (p j) (hnull i hi) (hnull j hj) (h i hi j hj) hne
  · intro h i hi j hj
    by_cases hpi : p i = 0
    · rw [hpi, minkDot_zero_left]
    · obtain ⟨c, _hc, hpj⟩ := h i hi j hj hpi
      rw [hpj, minkDot_eq_zero_of_smul c (p i) (hnull i hi).1]

/-- **The full chain (any N).**  Massless ⇔ every pairwise turn vanishes ⇔ a
single null direction. -/
theorem nbody_turn_iff {ι : Type*} (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) :
    (minkowskiSq (∑ i ∈ s, p i) = 0
      ↔ ∀ i ∈ s, ∀ j ∈ s, turn (p i) (p j) = 0)
    ∧ (minkowskiSq (∑ i ∈ s, p i) = 0
      ↔ ∀ i ∈ s, ∀ j ∈ s, p i ≠ 0 → ∃ c : ℝ, 0 ≤ c ∧ p j = c • p i) :=
  ⟨nbody_aperture_massless_iff_turns_zero s p hnull,
   nbody_aperture_massless_iff_collinear s p hnull⟩

/-! ## 3. Tie to the two-body `ApertureEqualsTurn` germ -/

/-- **The two-body aperture identity (germ).**  For two null momenta the
Minkowski square of their sum is exactly the per-pair turn — the composite mass
is the pure cross-term (the "aperture"/"turn" between the two null edges).  This
is the two-body germ of `ApertureEqualsTurn.twoNull_aperture_massSq`. -/
theorem twoNull_aperture_massSq (kPlus kMinus : Momentum4)
    (hp : IsNull kPlus) (hq : IsNull kMinus) :
    minkowskiSq (kPlus + kMinus) = 2 * minkDot kPlus kMinus := by
  unfold IsNull at hp hq
  rw [minkowskiSq_add, hp, hq]; ring

/-- The two-body composite mass is exactly the single per-pair turn. -/
theorem twoNull_turn_eq_massSq (kPlus kMinus : Momentum4)
    (hp : IsNull kPlus) (hq : IsNull kMinus) :
    minkowskiSq (kPlus + kMinus) = turn kPlus kMinus := by
  rw [twoNull_aperture_massSq kPlus kMinus hp hq]; rfl

/-- **On-shell two-body aperture = turn.**  For an on-shell timelike momentum
`p = kPlus + kMinus` with `minkowskiSq p = m²`, the single per-pair turn of the
two-null resolution equals the on-shell mass-squared `m²`. -/
theorem twoNull_aperture_onShell (p kPlus kMinus : Momentum4) (m : ℝ)
    (hkp : IsFutureNull kPlus) (hkm : IsFutureNull kMinus)
    (hres : p = kPlus + kMinus) (hp : minkowskiSq p = m ^ 2) :
    minkowskiSq (kPlus + kMinus) = turn kPlus kMinus
      ∧ turn kPlus kMinus = m ^ 2 := by
  have h1 := twoNull_turn_eq_massSq kPlus kMinus hkp.1 hkm.1
  exact ⟨h1, by rw [← h1, ← hres, hp]⟩

/-- **The germ is the `N = 2` instance of the n-body identity.**  For a two-
element index set `{a, b}` (`a < b`) of future-null momenta, the n-body
`aperture = turn` identity collapses to the single per-pair turn `turn (p a)
(p b)`, i.e. to `twoNull_turn_eq_massSq`. -/
theorem twobody_massSq_eq_turn {ι : Type*} [LinearOrder ι] (a b : ι) (hab : a < b)
    (p : ι → Momentum4)
    (ha : IsFutureNull (p a)) (hb : IsFutureNull (p b)) :
    minkowskiSq (∑ i ∈ ({a, b} : Finset ι), p i) = turn (p a) (p b) := by
  have hne : a ≠ b := ne_of_lt hab
  have hnull : ∀ i ∈ ({a, b} : Finset ι), IsFutureNull (p i) := by
    intro i hi
    simp only [Finset.mem_insert, Finset.mem_singleton] at hi
    rcases hi with rfl | rfl
    · exact ha
    · exact hb
  rw [nbody_compositeMassSq_eq_sum_turn ({a, b} : Finset ι) p hnull]
  rw [Finset.sum_insert (by simp [hne]), Finset.sum_singleton]
  -- filter (a < ·) over {a,b} = {b}; filter (b < ·) over {a,b} = ∅
  have hfa : ({a, b} : Finset ι).filter (a < ·) = {b} := by
    ext x
    simp only [Finset.mem_filter, Finset.mem_insert, Finset.mem_singleton]
    constructor
    · rintro ⟨hx, hax⟩
      rcases hx with rfl | rfl
      · exact absurd hax (lt_irrefl _)
      · rfl
    · rintro rfl; exact ⟨Or.inr rfl, hab⟩
  have hfb : ({a, b} : Finset ι).filter (b < ·) = ∅ := by
    rw [Finset.filter_eq_empty_iff]
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl
    · exact not_lt.mpr (le_of_lt hab)
    · exact lt_irrefl _
  rw [hfa, hfb, Finset.sum_singleton, Finset.sum_empty, add_zero]

end NBodyApertureTurn
end PhysicsSM.Draft.NullEdge.GateI1
