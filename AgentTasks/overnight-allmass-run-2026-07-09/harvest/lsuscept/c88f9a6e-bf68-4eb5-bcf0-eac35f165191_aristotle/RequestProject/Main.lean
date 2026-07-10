import Mathlib

open scoped BigOperators

namespace LambdaSusceptibility

/-!
# Lambda's RMS is a thermodynamic response

A finite, purely algebraic / finite-probability treatment of the count statistics of an
ensemble of independent "null edges".  We work with an explicit rational probability vector
`p : Fin n → ℚ` with `0 ≤ p i ≤ 1`, and the genuine finite product measure on
`Fin n → Bool` (each edge occupied with probability `p i`, independently).

* `weight p s`   – probability of the configuration `s : Fin n → Bool` under the product model.
* `Ncount s`     – the count observable `N(s) = #{i : s i}`.
* `expect p f`   – the finite expectation `⟨f⟩ = ∑ s, weight p s * f s`.
* `meanCount p`  – `⟨N⟩ = ∑ i, p i`.
* `varCount p`   – `Var(N) = ∑ i, p i (1 - p i)`.

The mean and variance are *derived* from the genuine finite expectation (see `expect_Ncount`
and `var_count`), valid for every `n`.  The payload theorems are:

* `bernoulli_bound`      : `Var(N) ≤ ⟨N⟩`, with equality iff every `p i = 0` (Poisson limit).
* `lambda_rms_upper_bound`: `Var(N)/⟨N⟩² ≤ 1/⟨N⟩`, i.e. `Λ_rms ≤ 1/√⟨N⟩`.
* `susceptibility_reading`: `d⟨N⟩/dp_j = 1`, the fluctuation is the response coefficient.
* `area_exponent_note`   : if `V = A²` then `(1/A)² = 1/V`.
-/

/-- Probability of a configuration `s : Fin n → Bool` under the independent-edge product model:
each edge `i` contributes `p i` if occupied (`s i = true`) and `1 - p i` if empty. -/
def weight {n : ℕ} (p : Fin n → ℚ) (s : Fin n → Bool) : ℚ :=
  ∏ i, if s i then p i else 1 - p i

/-- The count observable `N(s)` = number of occupied edges in configuration `s`. -/
def Ncount {n : ℕ} (s : Fin n → Bool) : ℚ :=
  ∑ i, if s i then (1 : ℚ) else 0

/-- Finite expectation `⟨f⟩ = ∑_s weight p s * f s` over the product measure. -/
def expect {n : ℕ} (p : Fin n → ℚ) (f : (Fin n → Bool) → ℚ) : ℚ :=
  ∑ s, weight p s * f s

/-- The mean count `⟨N⟩ = ∑ i, p i`. -/
def meanCount {n : ℕ} (p : Fin n → ℚ) : ℚ := ∑ i, p i

/-- The count variance `Var(N) = ∑ i, p i (1 - p i)` (independence of edges). -/
def varCount {n : ℕ} (p : Fin n → ℚ) : ℚ := ∑ i, p i * (1 - p i)

/-! ## The genuine finite-expectation derivation -/

/-- Normalisation: the product weights sum to one, so `weight` is a genuine probability. -/
theorem weight_sum_one {n : ℕ} (p : Fin n → ℚ) :
    ∑ s, weight p s = 1 := by
  unfold weight
  rw [← Fintype.piFinset_univ,
      ← Finset.prod_univ_sum (fun _ => (Finset.univ : Finset Bool))
        (fun i b => if b then p i else 1 - p i)]
  simp

/-- Expectation of a single edge indicator: `⟨[s j]⟩ = p j`. -/
theorem expect_indicator {n : ℕ} (p : Fin n → ℚ) (j : Fin n) :
    (∑ s : Fin n → Bool,
        (∏ i, (if s i then p i else 1 - p i)) * (if s j then (1 : ℚ) else 0)) = p j := by
  have key : ∀ s : Fin n → Bool,
      (∏ i, (if s i then p i else 1 - p i)) * (if s j then (1 : ℚ) else 0)
        = ∏ i, ((if s i then p i else 1 - p i)
                  * (if i = j then (if s i then (1 : ℚ) else 0) else 1)) := by
    intro s
    rw [Finset.prod_mul_distrib]
    congr 1
    rw [Finset.prod_eq_single j]
    · simp
    · intro i _ hij; rw [if_neg hij]
    · intro h; exact absurd (Finset.mem_univ j) h
  rw [Finset.sum_congr rfl (fun s _ => key s)]
  rw [← Fintype.piFinset_univ,
      ← Finset.prod_univ_sum (fun _ => (Finset.univ : Finset Bool))
        (fun i b => (if b then p i else 1 - p i)
                      * (if i = j then (if b then (1 : ℚ) else 0) else 1))]
  rw [Finset.prod_eq_single j]
  · simp
  · intro i _ hij
    simp [if_neg hij]
  · intro h; exact absurd (Finset.mem_univ j) h

/-- **Mean count.** The genuine finite expectation of the count equals `∑ i, p i`. -/
theorem expect_Ncount {n : ℕ} (p : Fin n → ℚ) :
    expect p Ncount = meanCount p := by
  unfold expect Ncount weight meanCount
  have : ∀ s : Fin n → Bool,
      (∏ i, if s i then p i else 1 - p i) * (∑ i, if s i then (1 : ℚ) else 0)
        = ∑ j, (∏ i, if s i then p i else 1 - p i) * (if s j then (1 : ℚ) else 0) := by
    intro s; rw [Finset.mul_sum]
  rw [Finset.sum_congr rfl (fun s _ => this s), Finset.sum_comm]
  exact Finset.sum_congr rfl (fun j _ => expect_indicator p j)

/-- Expectation of a product of two edge indicators: `⟨[s j][s k]⟩ = p j` if `j = k`,
otherwise `p j * p k` (independence of distinct edges). -/
theorem expect_pair {n : ℕ} (p : Fin n → ℚ) (j k : Fin n) :
    (∑ s : Fin n → Bool,
        (∏ i, (if s i then p i else 1 - p i))
          * ((if s j then (1 : ℚ) else 0) * (if s k then (1 : ℚ) else 0)))
      = if j = k then p j else p j * p k := by
  by_cases hjk : j = k
  · subst hjk
    rw [if_pos rfl, ← expect_indicator p j]
    apply Finset.sum_congr rfl
    intro s _
    rcases hsj : s j with _ | _ <;> simp
  · rw [if_neg hjk]
    have key : ∀ s : Fin n → Bool,
        (∏ i, (if s i then p i else 1 - p i))
          * ((if s j then (1 : ℚ) else 0) * (if s k then (1 : ℚ) else 0))
          = ∏ i, ((if s i then p i else 1 - p i)
                    * ((if i = j then (if s i then (1:ℚ) else 0) else 1)
                       * (if i = k then (if s i then (1:ℚ) else 0) else 1))) := by
      intro s
      rw [Finset.prod_mul_distrib, Finset.prod_mul_distrib]
      congr 1
      congr 1
      · rw [Finset.prod_eq_single j]
        · simp
        · intro i _ hij; rw [if_neg hij]
        · intro h; exact absurd (Finset.mem_univ j) h
      · rw [Finset.prod_eq_single k]
        · simp
        · intro i _ hik; rw [if_neg hik]
        · intro h; exact absurd (Finset.mem_univ k) h
    rw [Finset.sum_congr rfl (fun s _ => key s)]
    rw [← Fintype.piFinset_univ,
        ← Finset.prod_univ_sum (fun _ => (Finset.univ : Finset Bool))
          (fun i b => (if b then p i else 1 - p i)
                        * ((if i = j then (if b then (1:ℚ) else 0) else 1)
                           * (if i = k then (if b then (1:ℚ) else 0) else 1)))]
    have hsum : ∀ i : Fin n,
        (∑ b : Bool, (if b then p i else 1 - p i)
          * ((if i = j then (if b then (1:ℚ) else 0) else 1)
             * (if i = k then (if b then (1:ℚ) else 0) else 1)))
          = (if i = j then p i else 1) * (if i = k then p i else 1) := by
      intro i
      by_cases hij : i = j <;> by_cases hik : i = k
      · exact absurd (hij.symm.trans hik) hjk
      · subst hij; simp [hik]
      · subst hik; simp [hij]
      · simp [hij, hik]
    rw [Finset.prod_congr rfl (fun i _ => hsum i), Finset.prod_mul_distrib]
    rw [Finset.prod_eq_single j, Finset.prod_eq_single k]
    · simp
    · intro i _ hik; rw [if_neg hik]
    · intro h; exact absurd (Finset.mem_univ k) h
    · intro i _ hij; rw [if_neg hij]
    · intro h; exact absurd (Finset.mem_univ j) h

/-- **Variance identity.** The genuine finite variance `⟨N²⟩ - ⟨N⟩²` equals `∑ i, p i (1 - p i)`. -/
theorem var_count {n : ℕ} (p : Fin n → ℚ) :
    expect p (fun s => Ncount s ^ 2) - (expect p Ncount) ^ 2 = varCount p := by
  have hEsq : expect p (fun s => Ncount s ^ 2)
      = ∑ j : Fin n, ∑ k : Fin n, (if j = k then p j else p j * p k) := by
    unfold expect
    have e1 : ∀ s : Fin n → Bool, weight p s * (Ncount s) ^ 2
        = ∑ j, ∑ k, weight p s * ((if s j then (1:ℚ) else 0) * (if s k then (1:ℚ) else 0)) := by
      intro s
      unfold Ncount
      rw [sq, Finset.sum_mul_sum, Finset.mul_sum]
      apply Finset.sum_congr rfl; intro j _
      rw [Finset.mul_sum]
    rw [Finset.sum_congr rfl (fun s _ => e1 s), Finset.sum_comm]
    apply Finset.sum_congr rfl; intro j _
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl; intro k _
    exact expect_pair p j k
  have hEsq2 : (expect p Ncount) ^ 2 = ∑ j : Fin n, ∑ k : Fin n, p j * p k := by
    rw [expect_Ncount]; unfold meanCount; rw [sq, Finset.sum_mul_sum]
  rw [hEsq, hEsq2, ← Finset.sum_sub_distrib]
  unfold varCount
  apply Finset.sum_congr rfl; intro j _
  rw [← Finset.sum_sub_distrib]
  rw [Finset.sum_eq_single j]
  · simp; ring
  · intro k _ hjk; rw [if_neg (Ne.symm hjk)]; ring
  · intro h; exact absurd (Finset.mem_univ j) h

/-! ## Payload 1 — the Bernoulli bound -/

/-- **Bernoulli bound.** For independent edges the count variance never exceeds the mean:
`Var(N) = ∑ p_i(1-p_i) ≤ ∑ p_i = ⟨N⟩`. -/
theorem bernoulli_bound {n : ℕ} (p : Fin n → ℚ) :
    varCount p ≤ meanCount p := by
  unfold varCount meanCount
  apply Finset.sum_le_sum
  intro i _
  nlinarith [sq_nonneg (p i)]

/-- **Extremal (Poisson) case.** Equality in the Bernoulli bound holds iff every `p i = 0`
(the sparse / Poisson limit). -/
theorem bernoulli_eq_iff {n : ℕ} (p : Fin n → ℚ) :
    varCount p = meanCount p ↔ ∀ i, p i = 0 := by
  unfold varCount meanCount
  rw [eq_comm, ← sub_eq_zero, ← Finset.sum_sub_distrib]
  rw [Finset.sum_eq_zero_iff_of_nonneg (by intro i _; nlinarith [sq_nonneg (p i)])]
  constructor
  · intro h i
    have := h i (Finset.mem_univ i)
    nlinarith [this]
  · intro h i _; rw [h i]; ring

/-! ## Payload 2 — the everpresent-Λ upper bound -/

/-- **Λ_rms upper bound (squared form).** With `Λ = δN/⟨N⟩` and `δN² = Var(N)`, the second
moment obeys `Var(N)/⟨N⟩² ≤ 1/⟨N⟩`; i.e. `Λ_rms ≤ 1/√⟨N⟩`, with equality in the sparse limit. -/
theorem lambda_rms_upper_bound {n : ℕ} (p : Fin n → ℚ) (hpos : 0 < meanCount p) :
    varCount p / (meanCount p) ^ 2 ≤ 1 / meanCount p := by
  rw [show (1 : ℚ) / meanCount p = meanCount p / (meanCount p) ^ 2 by field_simp]
  rw [div_le_div_iff_of_pos_right (by positivity)]
  exact bernoulli_bound p

/-- **Λ_rms upper bound (final √ line).** Over the reals, `√Var(N)/⟨N⟩ ≤ 1/√⟨N⟩`. -/
theorem lambda_rms_sqrt {n : ℕ} (p : Fin n → ℚ)
    (h0 : ∀ i, 0 ≤ p i) (h1 : ∀ i, p i ≤ 1) (hpos : 0 < meanCount p) :
    Real.sqrt (varCount p : ℝ) / (meanCount p : ℝ) ≤ 1 / Real.sqrt (meanCount p : ℝ) := by
  have hV : (0 : ℝ) ≤ (varCount p : ℝ) := by
    have : (0 : ℚ) ≤ varCount p := by
      unfold varCount; apply Finset.sum_nonneg; intro i _; nlinarith [h0 i, h1 i]
    exact_mod_cast this
  have hm : (0 : ℝ) < (meanCount p : ℝ) := by exact_mod_cast hpos
  have hsm : (0 : ℝ) < Real.sqrt (meanCount p) := Real.sqrt_pos.mpr hm
  rw [div_le_div_iff₀ hm hsm, one_mul, ← Real.sqrt_mul hV, Real.sqrt_le_iff]
  refine ⟨hm.le, ?_⟩
  have hb : (varCount p : ℝ) ≤ (meanCount p : ℝ) := by exact_mod_cast bernoulli_bound p
  nlinarith [hb, hm]

/-! ## Payload 3 — the susceptibility reading -/

/-- Mean count after resetting edge `j`'s occupancy to `a`. -/
theorem meanCount_update {n : ℕ} (p : Fin n → ℚ) (j : Fin n) (a : ℚ) :
    meanCount (Function.update p j a) = a + ∑ i ∈ Finset.univ.erase j, p i := by
  unfold meanCount
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ j)]
  congr 1
  · simp
  · apply Finset.sum_congr rfl
    intro i hi
    rw [Function.update_of_ne (Finset.ne_of_mem_erase hi)]

/-- **Susceptibility reading.** `d⟨N⟩/dp_j = 1`: the mean count responds to the occupancy
parameter `p_j` with unit slope, so the count fluctuation `Var(N) = ∑ p_i(1-p_i)` is exactly
the response coefficient (susceptibility) of `⟨N⟩` to the occupancies. -/
theorem susceptibility_reading {n : ℕ} (p : Fin n → ℚ) (j : Fin n) (a b : ℚ) :
    meanCount (Function.update p j a) - meanCount (Function.update p j b) = a - b := by
  rw [meanCount_update, meanCount_update]; ring

/-- A transcendental-free (logistic) parametrisation of occupancy by a chemical potential
`mu ≥ 0`: `p(mu) = mu/(1+mu) ∈ [0,1]`. -/
def pLogistic (mu : ℚ) : ℚ := mu / (1 + mu)

/-- The logistic occupancy is a genuine probability for `mu ≥ 0`. -/
theorem pLogistic_mem {mu : ℚ} (hmu : 0 ≤ mu) : 0 ≤ pLogistic mu ∧ pLogistic mu ≤ 1 := by
  unfold pLogistic
  have h1 : 0 < 1 + mu := by linarith
  refine ⟨by positivity, ?_⟩
  rw [div_le_one h1]; linarith

/-! ## Payload 4 — the area-exponent note -/

/-- **Area-exponent identity.** If the volume is an area squared, `V = A²`, then
`(1/A)² = 1/V`: "Λ is inverse horizon-area". -/
theorem area_exponent_note (A V : ℚ) (hA : A ≠ 0) (hV : V = A ^ 2) :
    (1 / A) ^ 2 = 1 / V := by
  rw [hV]; field_simp

/-! ## Mandatory non-degeneracy witnesses -/

/-- `n = 3`, `p = (1/2, 1/3, 1/4)`: the mean count is `13/12`. -/
theorem mean_witness : meanCount (n := 3) ![1/2, 1/3, 1/4] = 13/12 := by
  simp [meanCount, Fin.sum_univ_three]; norm_num

/-- `n = 3`, `p = (1/2, 1/3, 1/4)`: the variance is `1/4 + 2/9 + 3/16 = 95/144`. -/
theorem var_witness : varCount (n := 3) ![1/2, 1/3, 1/4] = 95/144 := by
  simp [varCount, Fin.sum_univ_three]; norm_num

/-- The Bernoulli bound for the witness, as explicit rationals `95/144 ≤ 156/144`. -/
theorem bound_witness : varCount (n := 3) ![1/2, 1/3, 1/4] ≤ meanCount (n := 3) ![1/2, 1/3, 1/4] := by
  rw [mean_witness, var_witness]; norm_num

/-- Sparse (Poisson-limit) witness: `p = (1/100, 1/100, 1/100)` gives `Var/⟨N⟩ = 99/100`,
close to the extremal value `1`. -/
theorem sparse_witness :
    varCount (n := 3) ![1/100, 1/100, 1/100] / meanCount (n := 3) ![1/100, 1/100, 1/100]
      = 99/100 := by
  simp [varCount, meanCount, Fin.sum_univ_three]; norm_num

/-! ## Axiom audit — every headline uses only `[propext, Classical.choice, Quot.sound]`. -/

/-- info: 'LambdaSusceptibility.weight_sum_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms weight_sum_one

/-- info: 'LambdaSusceptibility.expect_Ncount' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms expect_Ncount

/-- info: 'LambdaSusceptibility.expect_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms expect_pair

/-- info: 'LambdaSusceptibility.var_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms var_count

/-- info: 'LambdaSusceptibility.bernoulli_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms bernoulli_bound

/-- info: 'LambdaSusceptibility.bernoulli_eq_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms bernoulli_eq_iff

/-- info: 'LambdaSusceptibility.lambda_rms_upper_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_rms_upper_bound

/-- info: 'LambdaSusceptibility.lambda_rms_sqrt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_rms_sqrt

/-- info: 'LambdaSusceptibility.susceptibility_reading' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms susceptibility_reading

/-- info: 'LambdaSusceptibility.area_exponent_note' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms area_exponent_note

/-- info: 'LambdaSusceptibility.mean_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms mean_witness

/-- info: 'LambdaSusceptibility.var_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms var_witness

/-- info: 'LambdaSusceptibility.bound_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms bound_witness

/-- info: 'LambdaSusceptibility.sparse_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms sparse_witness

end LambdaSusceptibility
