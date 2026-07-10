import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000

/-!
# Total-variation distinguishability of the two null directions ("mass")

Port of the total-variation / data-processing core from the
`testing-lower-bounds` package
(https://github.com/RemyDegenne/testing-lower-bounds : KL/Rényi/f-divergence,
total variation, DeGroot testing, DPI).  Provenance / reference only — this file
depends on Mathlib alone, not on that package.

The *mass* of a two-null-edge state is read here as the **distinguishability** of
the two null directions: collinear directions are indistinguishable (massless),
orthogonal directions are perfectly distinguishable (maximal mass).  We prove the
finite, rational total-variation avatar together with the data-processing
inequality (coarse-graining cannot increase distinguishability).
-/

namespace TVDistinguishabilityMass

/-- A rational probability vector: nonnegative entries summing to `1`. -/
def IsProb {n : ℕ} (p : Fin n → ℚ) : Prop :=
  (∀ i, 0 ≤ p i) ∧ ∑ i, p i = 1

/-- Total variation distance between two rational vectors:
`TV p q = (1/2) ∑ᵢ |pᵢ - qᵢ|`.  This is the L¹ distinguishability of the two
null-direction readouts. -/
def TV {n : ℕ} (p q : Fin n → ℚ) : ℚ := (1 / 2) * ∑ i, |p i - q i|

/-- Two readouts have **disjoint support** when at each outcome at least one of
them vanishes — the perfectly distinguishable (orthogonal) case. -/
def DisjointSupport {n : ℕ} (p q : Fin n → ℚ) : Prop :=
  ∀ i, p i = 0 ∨ q i = 0

/-- A rational column-stochastic (coarse-graining) map from `Fin n` inputs to
`Fin m` outputs. -/
def ColStoch {m n : ℕ} (K : Fin m → Fin n → ℚ) : Prop :=
  (∀ i j, 0 ≤ K i j) ∧ (∀ j, ∑ i, K i j = 1)

/-- Action of a coarse-graining map on a readout: `(K p)ᵢ = ∑ⱼ Kᵢⱼ pⱼ`. -/
def applyK {m n : ℕ} (K : Fin m → Fin n → ℚ) (p : Fin n → ℚ) : Fin m → ℚ :=
  fun i => ∑ j, K i j * p j

/-! ## Elementary total-variation facts -/

theorem TV_comm {n : ℕ} (p q : Fin n → ℚ) : TV p q = TV q p := by
  unfold TV; congr 1; apply Finset.sum_congr rfl; intro i _; rw [abs_sub_comm]

theorem TV_nonneg {n : ℕ} (p q : Fin n → ℚ) : 0 ≤ TV p q := by
  unfold TV; positivity

/-- `|a - b| = a + b` for nonnegative `a, b` iff one of them vanishes. -/
theorem abs_sub_eq_add_iff {a b : ℚ} (ha : 0 ≤ a) (hb : 0 ≤ b) :
    |a - b| = a + b ↔ a = 0 ∨ b = 0 := by
  rcases le_total a b with h | h
  · rw [abs_of_nonpos (by linarith)]
    constructor
    · intro hh; left; linarith
    · rintro (rfl | rfl) <;> · ring_nf; try linarith
  · rw [abs_of_nonneg (by linarith)]
    constructor
    · intro hh; right; linarith
    · rintro (rfl | rfl) <;> · ring_nf; try linarith

theorem TV_le_one {n : ℕ} {p q : Fin n → ℚ} (hp : IsProb p) (hq : IsProb q) :
    TV p q ≤ 1 := by
  obtain ⟨hp0, hp1⟩ := hp
  obtain ⟨hq0, hq1⟩ := hq
  have hS : ∑ i, |p i - q i| ≤ 2 := by
    calc ∑ i, |p i - q i| ≤ ∑ i, (p i + q i) := by
          apply Finset.sum_le_sum; intro i _
          rw [abs_sub_le_iff]
          exact ⟨by linarith [hq0 i], by linarith [hp0 i]⟩
      _ = 2 := by rw [Finset.sum_add_distrib, hp1, hq1]; norm_num
  unfold TV; linarith

theorem TV_eq_zero_iff {n : ℕ} (p q : Fin n → ℚ) : TV p q = 0 ↔ p = q := by
  unfold TV
  rw [mul_eq_zero]
  simp only [one_div, inv_eq_zero, OfNat.ofNat_ne_zero, false_or]
  rw [Finset.sum_eq_zero_iff_of_nonneg (by intro i _; positivity)]
  constructor
  · intro h; funext i
    have := h i (Finset.mem_univ i)
    rwa [abs_eq_zero, sub_eq_zero] at this
  · intro h i _; rw [h]; simp

theorem TV_eq_one_iff {n : ℕ} {p q : Fin n → ℚ} (hp : IsProb p) (hq : IsProb q) :
    TV p q = 1 ↔ DisjointSupport p q := by
  obtain ⟨hp0, hp1⟩ := hp
  obtain ⟨hq0, hq1⟩ := hq
  have hsum : ∑ i, ((p i + q i) - |p i - q i|) = 2 - ∑ i, |p i - q i| := by
    rw [Finset.sum_sub_distrib, Finset.sum_add_distrib, hp1, hq1]; norm_num
  have hnn : ∀ i ∈ Finset.univ, (0 : ℚ) ≤ (p i + q i) - |p i - q i| := by
    intro i _; rw [sub_nonneg, abs_sub_le_iff]
    exact ⟨by linarith [hq0 i], by linarith [hp0 i]⟩
  constructor
  · intro h
    have hS : ∑ i, |p i - q i| = 2 := by unfold TV at h; linarith
    have hz : ∑ i, ((p i + q i) - |p i - q i|) = 0 := by rw [hsum, hS]; ring
    rw [Finset.sum_eq_zero_iff_of_nonneg hnn] at hz
    intro i
    have hi := hz i (Finset.mem_univ i)
    have heq : |p i - q i| = p i + q i := by linarith
    exact (abs_sub_eq_add_iff (hp0 i) (hq0 i)).mp heq
  · intro h
    have hall : ∀ i, |p i - q i| = p i + q i :=
      fun i => (abs_sub_eq_add_iff (hp0 i) (hq0 i)).mpr (h i)
    unfold TV
    rw [show (∑ i, |p i - q i|) = ∑ i, (p i + q i) from
      Finset.sum_congr rfl (fun i _ => hall i)]
    rw [Finset.sum_add_distrib, hp1, hq1]; norm_num

/-- **`tv_bounds`** — the basic properties of total variation as a
distinguishability measure: it lies in `[0,1]`, vanishes exactly for identical
(indistinguishable) readouts, and equals `1` exactly for disjoint-support
(perfectly distinguishable) readouts. -/
theorem tv_bounds {n : ℕ} {p q : Fin n → ℚ} (hp : IsProb p) (hq : IsProb q) :
    0 ≤ TV p q ∧ TV p q ≤ 1 ∧ (TV p q = 0 ↔ p = q)
      ∧ (TV p q = 1 ↔ DisjointSupport p q) :=
  ⟨TV_nonneg p q, TV_le_one hp hq, TV_eq_zero_iff p q, TV_eq_one_iff hp hq⟩

/-! ## Data-processing inequality -/

/-- Finite L¹ contraction under a column-stochastic map:
`∑ᵢ |∑ⱼ Kᵢⱼ dⱼ| ≤ ∑ⱼ |dⱼ|`.  This is the combinatorial heart of the DPI. -/
theorem l1_contraction {m n : ℕ} {K : Fin m → Fin n → ℚ} (hK : ColStoch K)
    (d : Fin n → ℚ) :
    ∑ i, |∑ j, K i j * d j| ≤ ∑ j, |d j| := by
  obtain ⟨hK0, hK1⟩ := hK
  calc ∑ i, |∑ j, K i j * d j|
      ≤ ∑ i, ∑ j, |K i j * d j| := by
        apply Finset.sum_le_sum; intro i _; exact Finset.abs_sum_le_sum_abs _ _
    _ = ∑ i, ∑ j, K i j * |d j| := by
        apply Finset.sum_congr rfl; intro i _
        apply Finset.sum_congr rfl; intro j _
        rw [abs_mul, abs_of_nonneg (hK0 i j)]
    _ = ∑ j, (∑ i, K i j) * |d j| := by
        rw [Finset.sum_comm]; apply Finset.sum_congr rfl; intro j _
        rw [Finset.sum_mul]
    _ = ∑ j, |d j| := by
        apply Finset.sum_congr rfl; intro j _; rw [hK1 j, one_mul]

/-- **`dpi_total_variation`** — the data-processing inequality (the
testing-lower-bounds core, in finite total-variation form): a coarse-graining
`K` cannot increase the distinguishability of the two null directions. -/
theorem dpi_total_variation {m n : ℕ} {K : Fin m → Fin n → ℚ} (hK : ColStoch K)
    (p q : Fin n → ℚ) :
    TV (applyK K p) (applyK K q) ≤ TV p q := by
  unfold TV applyK
  apply mul_le_mul_of_nonneg_left _ (by norm_num)
  have hstep : ∀ i, (∑ j, K i j * p j) - (∑ j, K i j * q j)
      = ∑ j, K i j * (p j - q j) := by
    intro i; rw [← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl; intro j _; ring
  simp_rw [hstep]
  exact l1_contraction hK (fun j => p j - q j)

/-! ## Mass as distinguishability (Plücker/wedge dictionary) -/

/-- The Plücker/wedge determinant of two `2`-outcome readouts, viewed as the
`2×2` matrix of the two null spinors: `det = p₀ q₁ - p₁ q₀`. -/
def wedge (p q : Fin 2 → ℚ) : ℚ := p 0 * q 1 - p 1 * q 0

/-- The **mass** of the two-null-edge state: the magnitude of the wedge. -/
def mass (p q : Fin 2 → ℚ) : ℚ := |wedge p q|

/-- **`mass_is_distinguishability`** — with the explicit rational Bloch/celestial
readout model (each null edge is a `2`-outcome probability vector), the
total-variation distinguishability of the two null directions equals the Plücker
mass, and hence vanishes exactly when the edges are collinear (`wedge = 0`,
massless). -/
theorem mass_is_distinguishability {p q : Fin 2 → ℚ}
    (hp : IsProb p) (hq : IsProb q) :
    TV p q = mass p q ∧ (TV p q = 0 ↔ wedge p q = 0)
      ∧ (wedge p q = 0 ↔ p = q) := by
  obtain ⟨hp0, hp1⟩ := hp
  obtain ⟨hq0, hq1⟩ := hq
  rw [Fin.sum_univ_two] at hp1 hq1
  have hp1' : p 1 = 1 - p 0 := by linarith
  have hq1' : q 1 = 1 - q 0 := by linarith
  have hw : wedge p q = p 0 - q 0 := by unfold wedge; rw [hp1', hq1']; ring
  have htv : TV p q = |p 0 - q 0| := by
    unfold TV; rw [Fin.sum_univ_two, hp1', hq1']
    rw [show p 0 - q 0 = -((1 - p 0) - (1 - q 0)) by ring, abs_neg]; ring
  refine ⟨?_, ?_, ?_⟩
  · rw [htv]; unfold mass; rw [hw]
  · rw [htv, hw, abs_eq_zero]
  · rw [hw, sub_eq_zero]
    constructor
    · intro h; funext i; fin_cases i <;> simp_all
    · intro h; rw [h]

/-! ## Non-degeneracy witnesses -/

/-- Collinear witness: identical readouts `(1,0)` — massless, `TV = 0`. -/
theorem witness_collinear :
    TV (![1, 0] : Fin 2 → ℚ) (![1, 0] : Fin 2 → ℚ) = 0
      ∧ mass (![1, 0] : Fin 2 → ℚ) (![1, 0] : Fin 2 → ℚ) = 0 := by
  constructor <;> simp [TV, mass, wedge]

/-- Perfectly distinguishable witness: `(1,0)` vs `(0,1)` — `TV = 1`, maximal. -/
theorem witness_distinguishable :
    TV (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ) = 1
      ∧ mass (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ) = 1 := by
  refine ⟨?_, ?_⟩
  · simp [TV, Fin.sum_univ_two]; norm_num
  · simp [mass, wedge]

/-- The total collapse map `Fin 2 → Fin 1`, `K i j = 1`: a coarse-graining. -/
def collapse : Fin 1 → Fin 2 → ℚ := fun _ _ => 1

theorem collapse_colStoch : ColStoch collapse :=
  ⟨fun i j => by simp [collapse], fun j => by simp [collapse]⟩

/-- Strict data-processing witness: the collapse map sends the perfectly
distinguishable pair to an indistinguishable one, so
`TV (K p) (K q) < TV p q`. -/
theorem witness_strict_dpi :
    TV (applyK collapse (![1, 0] : Fin 2 → ℚ))
        (applyK collapse (![0, 1] : Fin 2 → ℚ))
      < TV (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ) := by
  simp [TV, applyK, collapse, Fin.sum_univ_two]

/-! ## Verdict package -/

/-- **`distinguishability_verdict`** — the packaged mass dictionary: mass is the
data-processing-monotone total-variation distinguishability of the two
null-direction messages.  It is `0` exactly for collinear (massless) edges,
equals the Plücker wedge magnitude, is bounded in `[0,1]`, is monotone under any
coarse-graining, and is strictly decreased by the total-collapse coarse-graining
on a perfectly distinguishable pair. -/
theorem distinguishability_verdict :
    (∀ (p q : Fin 2 → ℚ), IsProb p → IsProb q →
        TV p q = mass p q ∧ 0 ≤ TV p q ∧ TV p q ≤ 1
          ∧ (TV p q = 0 ↔ wedge p q = 0)) ∧
    (∀ {m n : ℕ} (K : Fin m → Fin n → ℚ), ColStoch K →
        ∀ (p q : Fin n → ℚ), TV (applyK K p) (applyK K q) ≤ TV p q) ∧
    TV (applyK collapse (![1, 0] : Fin 2 → ℚ))
        (applyK collapse (![0, 1] : Fin 2 → ℚ))
      < TV (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ) := by
  refine ⟨?_, ?_, witness_strict_dpi⟩
  · intro p q hp hq
    obtain ⟨h1, h2, _⟩ := mass_is_distinguishability hp hq
    exact ⟨h1, TV_nonneg p q, TV_le_one hp hq, h2⟩
  · intro m n K hK p q; exact dpi_total_variation hK p q

end TVDistinguishabilityMass

/-! ## Axiom audit — every headline is kernel-checked with the standard footprint. -/

/-- info: 'TVDistinguishabilityMass.tv_bounds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms TVDistinguishabilityMass.tv_bounds

/-- info: 'TVDistinguishabilityMass.dpi_total_variation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms TVDistinguishabilityMass.dpi_total_variation

/-- info: 'TVDistinguishabilityMass.mass_is_distinguishability' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms TVDistinguishabilityMass.mass_is_distinguishability

/-- info: 'TVDistinguishabilityMass.distinguishability_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms TVDistinguishabilityMass.distinguishability_verdict
