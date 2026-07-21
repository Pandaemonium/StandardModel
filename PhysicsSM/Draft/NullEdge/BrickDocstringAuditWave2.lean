import Mathlib

/-!
# Adversarial docstring audit, wave 2 (Opus, verified 703405f6)

Second severity pass over my own brick prose, after wave 1 found all five audited
claims overclaimed. Verdicts:

1. PROSE-OUTRUNS-STATEMENT - calling the coin closed form 'unconditional' in the
   mass is unfair: at m = 0 a nonzero NILPOTENT 2x2 satisfies the square relation
   and nonnegativity, so the hypothesis (m = 0 -> M = 0) does real work.
2. PROSE-OUTRUNS-STATEMENT - naming UNITARITY for the telescoping estimate is
   stronger than needed; it holds in any normed ring for CONTRACTIONS.
3. SOUND one-way only - commuting generators make the commutator RHS zero, but the
   RHS vanishes exactly when eps = 0 OR the commutator is zero, so an 'exactly when
   commuting' gloss would overclaim. Also the `0 <= eps` restriction is NOT
   load-bearing for the quadratic RHS (invariant under eps -> -eps).
4. SOUND but for a stated reason - the ball supremum is finite by ENDPOINT
   DOMINATION from monotonicity; boundedness of the domain alone does not ensure
   finiteness for an arbitrary extended-real profile.
5. SOUND with the compactwise meaning only - boxwise estimates give a bound on every
   compact subset with a compact-dependent constant, hence pointwise coverage, and
   NOT one global uniform constant (counterexample formalized).

Affected docstrings corrected. Provenance: verified at pin from task 816a6adb.
Standard three. Grade M, [orig] (independent-review artifact). -/

open scoped BigOperators ENNReal

namespace AdversarialAudit

/-! Machine-checked witnesses for the five prose audits. -/

section Coin

abbrev NilpotentCoin : Matrix (Fin 2) (Fin 2) ℝ := !![0, 1; 0, 0]

theorem nilpotentCoin_sq : NilpotentCoin ^ 2 = 0 := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ sq ]

theorem nilpotentCoin_ne_zero : NilpotentCoin ≠ 0 := by
  -- By definition of matrix equality, if two matrices are equal, then their corresponding entries must be equal.
  intro h
  have := congr_fun (congr_fun h 0) 1
  simp at this

/-
At mass zero, the square relation and nonnegativity do not force the matrix to vanish.
-/
theorem coin_third_hypothesis_witness :
    NilpotentCoin ^ 2 = (0 : ℝ) ^ 2 • (1 : Matrix (Fin 2) (Fin 2) ℝ) ∧
      (0 : ℝ) ≤ 0 ∧ NilpotentCoin ≠ 0 := by
  simp +zetaDelta at *;
  exact ⟨ nilpotentCoin_sq, nilpotentCoin_ne_zero ⟩

end Coin

section Powers

/-
Telescoping only needs both elements to be contractions, not unitaries.
-/
theorem norm_pow_sub_pow_le_of_contractions
    {A : Type*} [NormedRing A] (U V : A) (n : ℕ)
    (hU : ‖U‖ ≤ 1) (hV : ‖V‖ ≤ 1) :
    ‖U ^ n - V ^ n‖ ≤ n * ‖U - V‖ := by
  induction' n with n ih;
  · simp +decide;
  · -- Use the triangle inequality and submultiplicative properties of the norm.
    have h_triangle : ‖U^(n+1) - V^(n+1)‖ ≤ ‖U^n‖ * ‖U - V‖ + ‖U^n - V^n‖ * ‖V‖ := by
      convert norm_add_le (U ^ n * (U - V)) ((U ^ n - V ^ n) * V) |>
          le_trans <| add_le_add (norm_mul_le _ _) (norm_mul_le _ _) using 1
      noncomm_ring
    rcases n with ( _ | n ) <;> norm_num at *;
    refine' le_trans h_triangle _;
    refine' le_trans ( add_le_add ( mul_le_mul_of_nonneg_right ( norm_pow_le' _ ( by linarith ) ) ( norm_nonneg _ ) ) ( mul_le_mul_of_nonneg_right ih ( norm_nonneg _ ) ) ) _;
    nlinarith [ norm_nonneg ( U - V ), pow_le_pow_of_le_one ( norm_nonneg U ) hU ( by linarith : n + 1 ≥ 1 ), mul_le_mul_of_nonneg_right hV ( norm_nonneg ( U - V ) ) ]

end Powers

section Commutator

/-
The usual quadratic commutator RHS has an additional zero case at `eps = 0`.
-/
theorem quadratic_commutator_rhs_eq_zero_iff
    {A : Type*} [NormedRing A] (eps : ℝ) (X : A) :
    eps ^ 2 / 2 * ‖X‖ = 0 ↔ eps = 0 ∨ X = 0 := by
  by_cases h : eps = 0 <;> simp +decide [ h ]

/-
The quadratic RHS is unchanged when the time parameter is negated.
-/
theorem quadratic_rhs_neg (eps c : ℝ) :
    (-eps) ^ 2 / 2 * c = eps ^ 2 / 2 * c := by
  ring

end Commutator

section MassBall

/-
Monotonicity plus an included endpoint makes the supremum finite and attained there.
-/
theorem monotone_profile_attains_on_bounded_set
    (profile : ℝ → ℝ) (S : Set ℝ) (R : ℝ)
    (hmono : Monotone profile) (hR : R ∈ S) (hbound : ∀ x ∈ S, x ≤ R) :
    sSup (profile '' S) = profile R := by
  rw [ @csSup_eq_of_forall_le_of_forall_lt_exists_gt ] <;> norm_num;
  · exact ⟨ R, hR ⟩;
  · exact fun x hx => hmono <| hbound x hx;
  · exact fun w hw => ⟨ R, hR, hw ⟩

/-
Boundedness of the domain alone does not keep an arbitrary `ℝ≥0∞` profile finite.
-/
theorem bounded_ball_infinite_sup_witness :
    ⨆ _x : Set.Icc (0 : ℝ) 1, (⊤ : ℝ≥0∞) = ⊤ := by
  simp [iSup]

end MassBall

section CompactBoxes

/-
Every compact subset of finite-dimensional momentum space is contained in a box.
-/
theorem compact_subset_some_closed_box {d : ℕ} (K : Set (Fin d → ℝ))
    (hK : IsCompact K) :
    ∃ R : ℝ, 0 ≤ R ∧ K ⊆ Set.Icc (fun _ => -R) (fun _ => R) := by
  obtain ⟨ R, hR ⟩ := hK.isBounded.exists_pos_norm_le;
  exact ⟨ R, le_of_lt hR.1, fun x hx => ⟨ fun i => neg_le_of_abs_le <| by simpa using pi_norm_le_iff_of_nonneg ( by linarith ) |>.1 ( hR.2 x hx ) i, fun i => le_of_abs_le <| by simpa using pi_norm_le_iff_of_nonneg ( by linarith ) |>.1 ( hR.2 x hx ) i ⟩ ⟩

/-
Consequently, a boxwise estimate restricts to every compact set, but keeps its
box-dependent constant.
-/
theorem boxwise_estimate_restricts_to_compact {d : ℕ}
    (K : Set (Fin d → ℝ)) (hK : IsCompact K)
    (error : (Fin d → ℝ) → ℝ)
    (hbox : ∀ R : ℝ, 0 ≤ R → ∃ C : ℝ,
      ∀ p ∈ Set.Icc (fun _ => -R) (fun _ => R), error p ≤ C) :
    ∃ C : ℝ, ∀ p ∈ K, error p ≤ C := by
  obtain ⟨ R, hR₁, hR₂ ⟩ := AdversarialAudit.compact_subset_some_closed_box K hK;
  exact Exists.elim ( hbox R hR₁ ) fun C hC => ⟨ C, fun p hp => hC p ( hR₂ hp ) ⟩

/-
Box-dependent bounds do not assemble into one global bound: absolute value is
bounded on every finite interval but unbounded on `ℝ`.
-/
theorem boxwise_does_not_imply_global_bound :
    (∀ R : ℝ, 0 ≤ R → ∃ C : ℝ, ∀ x ∈ Set.Icc (-R) R, |x| ≤ C) ∧
      ¬ ∃ C : ℝ, ∀ x : ℝ, |x| ≤ C := by
  exact ⟨ fun R hR => ⟨ R, fun x hx => abs_le.mpr hx ⟩, fun ⟨ C, hC ⟩ => by linarith [ hC ( C + 1 ), abs_le.mp ( hC ( C + 1 ) ) ] ⟩

end CompactBoxes

end AdversarialAudit
