import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass

/-!
# Gate I1 / NE-U1b: aperture entropy — the rest-frame maximally-mixed direction state

Companion to `CompositeApertureMass.lean`. That module proved the keystone
*kinematic identity* for future-pointing null momenta `p₁ … pₙ`:

    M² = minkowskiSq (∑ᵢ pᵢ) = ∑_{i,j} minkDot (pᵢ) (pⱼ) ≥ 0,

with `M² = 0` **iff** every constituent points along a single null direction
(`compositeMassSq_eq_zero_iff_collinear`). Mass is the *aperture* of the null
bundle.

Here we read that aperture through a **Shannon-type entropy of the
energy-normalized null-direction distribution**, at finite, kernel-checked
grade.

## What is built

* `dirWeight` — the normalized *direction weight* `wᵢ := (energy of pᵢ)/E`,
  where `E := totalEnergy` is the total energy. For a massive composite these
  form a genuine probability vector (`dirWeight_nonneg`, `dirWeight_le_one`,
  `dirWeight_sum_one`).
* `apertureEntropy` — `H := - ∑ᵢ wᵢ log wᵢ = ∑ᵢ Real.negMulLog wᵢ`, the
  Shannon entropy of the direction distribution.
* `apertureEntropy_nonneg` — `H ≥ 0`.
* `apertureEntropy_eq_zero_iff_concentrated` — `H = 0` **iff** the weight is
  concentrated on a single constituent (`IsConcentrated`), i.e. the *pure*
  (zero-entropy) direction state.
* `concentrated_imp_massless` — the pure / single-direction case is exactly the
  **massless** case: concentration forces `minkowskiSq (∑ᵢ pᵢ) = 0`. This is
  the entropy-side shadow of `compositeMassSq_eq_zero_iff_collinear`.
* `apertureEntropy_pos_of_massive` — **the honest reading**: a genuine aperture
  (`0 < minkowskiSq (∑ᵢ pᵢ)`) forces `0 < H`. Positive composite mass is
  *carried by the entropy/spread* of the null-direction distribution.
* `massive_needs_two_directions` — massiveness requires ≥ 2 *distinct*
  (non-collinear) null directions.

## Claim discipline (NULLSTRAND / NERD)

Claim label: **finite kinematic identity**, exactly as in the parent module.
This is NOT a thermodynamic statement: `H` is the combinatorial Shannon entropy
of a finite probability vector, `E` and `wᵢ` are frame-DEPENDENT (energy is not
a Lorentz invariant), and no ensemble, temperature, or coarse-graining is
invoked. The content is the strictly one-directional implication

    positive composite mass  ⟹  positive direction-spread entropy,

together with its pure/massless boundary. The converse FAILS (two *collinear*
constituents with split energy give `H > 0` but `M² = 0`), which is precisely
why this is a finite identity and not a thermodynamic equivalence.

## Proof status

FULLY PROVED, no `sorry` / `axiom` / `native_decide`. Depends on the parent
`CompositeApertureMass` module and `GateI1.Core`.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateI1.ApertureEntropy

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass

variable {ι : Type*}

/-! ### The energy-normalized direction weights -/

/-- Total energy of a finite family of momenta: the sum of the energy
components `p i 0`. -/
noncomputable def totalEnergy (s : Finset ι) (p : ι → Momentum4) : ℝ :=
  ∑ i ∈ s, p i 0

/-- The normalized **direction weight** `wᵢ := (energy of pᵢ)/(total energy)`. -/
noncomputable def dirWeight (s : Finset ι) (p : ι → Momentum4) (i : ι) : ℝ :=
  p i 0 / totalEnergy s p

/-- The **aperture entropy** `H := - ∑ᵢ wᵢ log wᵢ`, expressed via Mathlib's
`Real.negMulLog x = - x * log x`. -/
noncomputable def apertureEntropy (s : Finset ι) (p : ι → Momentum4) : ℝ :=
  ∑ i ∈ s, Real.negMulLog (dirWeight s p i)

/-! ### Basic energy facts -/

/-- The total energy of a family of future-null momenta is nonnegative. -/
theorem totalEnergy_nonneg (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) : 0 ≤ totalEnergy s p :=
  Finset.sum_nonneg fun i hi => (hnull i hi).2

/-- A future-pointing null momentum with vanishing energy is the zero momentum
(the light cone pinches to the origin). -/
theorem futureNull_energy_zero_imp_zero (q : Momentum4)
    (hq : IsFutureNull q) (h0 : q 0 = 0) : q = 0 := by
  obtain ⟨hnull, _⟩ := hq
  unfold IsNull minkowskiSq at hnull
  rw [h0] at hnull
  have h1 : q 1 = 0 := by nlinarith [sq_nonneg (q 1), sq_nonneg (q 2), sq_nonneg (q 3)]
  have h2 : q 2 = 0 := by nlinarith [sq_nonneg (q 1), sq_nonneg (q 2), sq_nonneg (q 3)]
  have h3 : q 3 = 0 := by nlinarith [sq_nonneg (q 1), sq_nonneg (q 2), sq_nonneg (q 3)]
  funext k; fin_cases k <;> simp_all

/-- **A massive composite has strictly positive total energy.** Since
`0 < M² = E² - |P⃗|² ≤ E²`, the energy `E` cannot vanish; being a sum of
nonnegative energies it is strictly positive. -/
theorem totalEnergy_pos_of_massive (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i))
    (hpos : 0 < minkowskiSq (∑ i ∈ s, p i)) :
    0 < totalEnergy s p := by
  have hsum0 : (∑ i ∈ s, p i) 0 = ∑ i ∈ s, p i 0 := Finset.sum_apply 0 s p
  have hnn : 0 ≤ totalEnergy s p := totalEnergy_nonneg s p hnull
  have hle : minkowskiSq (∑ i ∈ s, p i) ≤ ((∑ i ∈ s, p i) 0) ^ 2 := by
    unfold minkowskiSq
    nlinarith [sq_nonneg ((∑ i ∈ s, p i) 1), sq_nonneg ((∑ i ∈ s, p i) 2),
      sq_nonneg ((∑ i ∈ s, p i) 3)]
  rw [hsum0] at hle
  unfold totalEnergy at hnn ⊢
  nlinarith [hpos, hle, hnn]

/-! ### The direction weights form a probability vector -/

/-- Each direction weight is nonnegative. -/
theorem dirWeight_nonneg (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p)
    {i : ι} (hi : i ∈ s) : 0 ≤ dirWeight s p i :=
  div_nonneg (hnull i hi).2 htot.le

/-- Each direction weight is at most one. -/
theorem dirWeight_le_one (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p)
    {i : ι} (hi : i ∈ s) : dirWeight s p i ≤ 1 := by
  unfold dirWeight
  rw [div_le_one htot]
  exact Finset.single_le_sum (fun j hj => (hnull j hj).2) hi

/-- **The direction weights sum to one**: they form a probability vector. -/
theorem dirWeight_sum_one (s : Finset ι) (p : ι → Momentum4)
    (htot : 0 < totalEnergy s p) : ∑ i ∈ s, dirWeight s p i = 1 := by
  unfold dirWeight
  rw [← Finset.sum_div]
  rw [div_eq_one_iff_eq (ne_of_gt htot)]
  rfl

/-! ### Entropy nonnegativity and the pure (zero-entropy) case -/

/-- **The aperture entropy is nonnegative.** -/
theorem apertureEntropy_nonneg (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p) :
    0 ≤ apertureEntropy s p :=
  Finset.sum_nonneg fun _ hi =>
    Real.negMulLog_nonneg (dirWeight_nonneg s p hnull htot hi)
      (dirWeight_le_one s p hnull htot hi)

/-- `negMulLog x = 0 ↔ x = 0 ∨ x = 1` on the unit interval. -/
theorem negMulLog_eq_zero_iff {x : ℝ} (h0 : 0 ≤ x) (h1 : x ≤ 1) :
    Real.negMulLog x = 0 ↔ x = 0 ∨ x = 1 := by
  rw [Real.negMulLog, neg_mul, neg_eq_zero, mul_eq_zero]
  constructor
  · rintro (rfl | hlog)
    · left; rfl
    · rcases Real.log_eq_zero.mp hlog with h | h | h
      · left; exact h
      · right; exact h
      · linarith
  · rintro (rfl | rfl)
    · left; rfl
    · right; simp

open Classical in
/-- The weight distribution is **concentrated** on a single constituent `i₀`:
`w j = 1` if `j = i₀` and `0` otherwise. This is the pure direction state. -/
def IsConcentrated (s : Finset ι) (p : ι → Momentum4) : Prop :=
  ∃ i₀ ∈ s, ∀ j ∈ s, dirWeight s p j = if j = i₀ then 1 else 0

/-- **Entropy is zero iff the direction distribution is pure.** `H = 0`
exactly when the weight collapses onto a single null constituent — the
zero-entropy / single-direction state. -/
theorem apertureEntropy_eq_zero_iff_concentrated (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p) :
    apertureEntropy s p = 0 ↔ IsConcentrated s p := by
  classical
  have hnonneg : ∀ i ∈ s, 0 ≤ Real.negMulLog (dirWeight s p i) := fun i hi =>
    Real.negMulLog_nonneg (dirWeight_nonneg s p hnull htot hi)
      (dirWeight_le_one s p hnull htot hi)
  constructor
  · intro hH
    -- each term vanishes, so each weight is 0 or 1
    have hterm : ∀ i ∈ s, Real.negMulLog (dirWeight s p i) = 0 :=
      (Finset.sum_eq_zero_iff_of_nonneg hnonneg).mp hH
    have h01 : ∀ i ∈ s, dirWeight s p i = 0 ∨ dirWeight s p i = 1 := fun i hi =>
      (negMulLog_eq_zero_iff (dirWeight_nonneg s p hnull htot hi)
        (dirWeight_le_one s p hnull htot hi)).mp (hterm i hi)
    have hsum : ∑ i ∈ s, dirWeight s p i = 1 := dirWeight_sum_one s p htot
    -- exactly one weight equals 1
    set w := dirWeight s p with hw
    set T := s.filter (fun i => w i = 1) with hT
    have hcard : (T.card : ℝ) = 1 := by
      have hsc : ∑ i ∈ s, w i = (T.card : ℝ) := by
        rw [hT, ← Finset.sum_filter_add_sum_filter_not s (fun i => w i = 1) w]
        have h1 : ∑ i ∈ s.filter (fun i => w i = 1), w i
            = (s.filter (fun i => w i = 1)).card := by
          rw [Finset.sum_congr rfl (fun i hi => (Finset.mem_filter.mp hi).2)]; simp
        have h2 : ∑ i ∈ s.filter (fun i => ¬ w i = 1), w i = 0 := by
          apply Finset.sum_eq_zero
          intro i hi
          rw [Finset.mem_filter] at hi
          exact (h01 i hi.1).resolve_right hi.2
        rw [h1, h2, add_zero]
      rw [← hsc, hsum]
    have hcardnat : T.card = 1 := by exact_mod_cast hcard
    obtain ⟨i₀, hi₀⟩ := Finset.card_eq_one.mp hcardnat
    have hi₀mem : i₀ ∈ T := by rw [hi₀]; exact Finset.mem_singleton_self i₀
    refine ⟨i₀, (Finset.mem_filter.mp hi₀mem).1, ?_⟩
    intro j hj
    by_cases hjw : w j = 1
    · have hjT : j ∈ T := Finset.mem_filter.mpr ⟨hj, hjw⟩
      rw [hi₀, Finset.mem_singleton] at hjT
      subst hjT; rw [if_pos rfl]; exact hjw
    · have hj0 : w j = 0 := (h01 j hj).resolve_right hjw
      have hjne : j ≠ i₀ := by
        intro h; subst h; exact hjw (Finset.mem_filter.mp hi₀mem).2
      rw [if_neg hjne]; exact hj0
  · rintro ⟨i₀, hi₀, hconc⟩
    unfold apertureEntropy
    apply Finset.sum_eq_zero
    intro i hi
    rcases eq_or_ne i i₀ with h | h
    · rw [hconc i hi, if_pos h]; simp [Real.negMulLog]
    · rw [hconc i hi, if_neg h]; simp [Real.negMulLog]

/-! ### Tying entropy to composite mass -/

/-- **The pure (zero-entropy) case is exactly massless.** If the direction
distribution is concentrated on a single constituent, then all other
constituents carry zero energy — hence are the zero momentum — so the composite
reduces to a single null momentum and `minkowskiSq (∑ᵢ pᵢ) = 0`. This is the
entropy-side statement of `compositeMassSq_eq_zero_iff_collinear`. -/
theorem concentrated_imp_massless (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p)
    (hconc : IsConcentrated s p) :
    minkowskiSq (∑ i ∈ s, p i) = 0 := by
  classical
  obtain ⟨i₀, hi₀, hconcw⟩ := hconc
  -- every non-`i₀` constituent has zero energy, hence is the zero momentum
  have hzero : ∀ j ∈ s, j ≠ i₀ → p j = 0 := by
    intro j hj hjne
    have hwj : dirWeight s p j = 0 := by rw [hconcw j hj, if_neg hjne]
    have hej : p j 0 = 0 := by
      have := hwj
      unfold dirWeight at this
      rw [div_eq_zero_iff] at this
      exact this.resolve_right (ne_of_gt htot)
    exact futureNull_energy_zero_imp_zero _ (hnull j hj) hej
  -- the sum collapses to `p i₀`
  have hcollapse : (∑ i ∈ s, p i) = p i₀ := by
    rw [Finset.sum_eq_single i₀]
    · intro j hj hjne; exact hzero j hj hjne
    · intro h; exact absurd hi₀ h
  rw [hcollapse]
  exact (hnull i₀ hi₀).1

/-- **THE HONEST READING**: a genuine aperture carries positive entropy.
If the composite of future-pointing null momenta is *massive*
(`0 < minkowskiSq (∑ᵢ pᵢ)`), then the direction-spread entropy is strictly
positive (`0 < H`). Contrapositive of `concentrated_imp_massless`: zero entropy
would force masslessness.

This is a finite kinematic implication, NOT a thermodynamic equivalence: the
converse fails, since two *collinear* constituents with split energy give
`H > 0` while `M² = 0`. Positive composite mass is *carried by* — but is
strictly stronger than — the spread of the null-direction distribution. -/
theorem apertureEntropy_pos_of_massive (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i))
    (hpos : 0 < minkowskiSq (∑ i ∈ s, p i)) :
    0 < apertureEntropy s p := by
  have htot : 0 < totalEnergy s p := totalEnergy_pos_of_massive s p hnull hpos
  refine lt_of_le_of_ne (apertureEntropy_nonneg s p hnull htot) ?_
  intro hEq
  have hconc : IsConcentrated s p :=
    (apertureEntropy_eq_zero_iff_concentrated s p hnull htot).mp hEq.symm
  have hmassless : minkowskiSq (∑ i ∈ s, p i) = 0 :=
    concentrated_imp_massless s p hnull htot hconc
  rw [hmassless] at hpos
  exact lt_irrefl 0 hpos

/-- **A genuine aperture requires ≥ 2 distinct (non-collinear) null
directions.** Directly the contrapositive of the parent module's
`compositeMassSq_eq_zero_iff_collinear`: if the composite is massive there exist
two constituents `pᵢ, pⱼ` with `pᵢ ≠ 0` and `pⱼ` NOT a nonnegative multiple of
`pᵢ`, i.e. two genuinely distinct null directions. -/
theorem massive_needs_two_directions (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i))
    (hpos : 0 < minkowskiSq (∑ i ∈ s, p i)) :
    ∃ i ∈ s, ∃ j ∈ s, p i ≠ 0 ∧ ¬ ∃ c : ℝ, 0 ≤ c ∧ p j = c • p i := by
  have hne : ¬ (∀ i ∈ s, ∀ j ∈ s, p i ≠ 0 → ∃ c : ℝ, 0 ≤ c ∧ p j = c • p i) := by
    rw [← compositeMassSq_eq_zero_iff_collinear s p hnull]
    exact ne_of_gt hpos
  push_neg at hne
  obtain ⟨i, hi, j, hj, hpi, hnc⟩ := hne
  exact ⟨i, hi, j, hj, hpi, fun ⟨c, hc, he⟩ => hnc c hc he⟩

end PhysicsSM.Draft.NullEdge.GateI1.ApertureEntropy
