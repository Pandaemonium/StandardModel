import Mathlib

/-!
# The uniform many-step bound: unitary telescoping over the one-step estimate

The program's single most important open problem (Paper I's strongest stated
falsifier) is the many-step continuum limit.  This package proves its
fixed-momentum core: a compact-domain uniform Lie-Trotter-type bound obtained
by telescoping the landed one-step `O(a^2)` estimate through unitarity, with
all constants explicit and no operator-norm API — everything runs through the
max-entry seminorm with the elementary `2x2` product inequality.

Composed with the landed one-step bound
`‖U(k eps, m eps) - (1 - i eps H)‖_max ≤ C(k,m) eps^2` (parent repository,
`QuantitativeDiracWalkContinuum`), the corollary gives
`sup_{|k| ≤ K, n a ≤ T} ‖U_a(k)^n - E_a(k)^n‖_max ≤ 4 T C(K, m) a`:
the finite walk converges to the exact continuum evolution uniformly on
compact momentum domains at rate `O(a)` — a theorem, not a numerical trend.

## Targets

1. `maxEntry_mul_le` — the `2x2` product inequality
   `‖M N‖_max ≤ 2 ‖M‖_max ‖N‖_max`.
2. `unitary_entry_le_one` — entries of a unitary matrix are bounded by one
   (row-norm argument from `U Uᴴ = 1`).
3. `unitary_pow` — powers of unitary matrices are unitary.
4. `telescoping_bound` — the heart: for unitary `A, B`,
   `‖A^n - B^n‖_max ≤ 4 n ‖A - B‖_max`
   (telescope `A^n - B^n = Σ_j A^(n-1-j) (A - B) B^j`; each summand is
   controlled by the product inequality and the unitary entry bound; no norm
   growth because unitaries have unit-bounded entries).
5. `uniform_compact_bound` — the compact-domain corollary: if two unitary
   families satisfy the one-step bound `‖A_a(k) - B_a(k)‖_max ≤ C k * a^2`
   with `C` monotone on `[0, K]` in `|k|`, then for all `|k| ≤ K` and
   `n * a ≤ T`: `‖A_a(k)^n - B_a(k)^n‖_max ≤ 4 * T * C K * a` (for
   `a > 0`).
6. `Cpoly_mono` — the landed one-step constant
   `C(k, m) = 2k^2 + 2m^2 + |k| m^2 + k^2 |m| + |k| |m|` is monotone in
   `|k|`: `|k| ≤ K → C(k, m) ≤ C(K, m)` for `K ≥ 0` — so target 5 applies
   to the landed estimate with the explicit constant `C(K, m)`.

Honest scope: fixed-momentum uniform control; the position-space lift
(Plancherel on the periodic lattice) and any `3+1` statement are the named
remaining steps, not claimed.  Do not weaken the statements.  Helper lemmas
welcome.  Run `lake env lean UniformTrotterTelescope/ManyStepBound.lean`
first.
-/

namespace UniformTrotterTelescope

open Matrix

/-- Max-entry seminorm of a `2x2` complex matrix. -/
noncomputable def maxEntry (M : Matrix (Fin 2) (Fin 2) ℂ) : ℝ :=
  max (max ‖M 0 0‖ ‖M 0 1‖) (max ‖M 1 0‖ ‖M 1 1‖)

/-
Target 1: the `2x2` product inequality.
-/
theorem maxEntry_mul_le (M N : Matrix (Fin 2) (Fin 2) ℂ) :
    maxEntry (M * N) ≤ 2 * maxEntry M * maxEntry N := by
  -- Consider the norm of each term in the expanded product matrix.
  have h_term_norm (i j : Fin 2) : ‖(M * N) i j‖ ≤ 2 * maxEntry M * maxEntry N := by
    -- By definition of matrix multiplication, we have:
    have h_mul : (M * N) i j = M i 0 * N 0 j + M i 1 * N 1 j := by
      fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply ];
    -- By definition of maxEntry, we know that ‖M i 0‖ ≤ maxEntry M and ‖N 0 j‖ ≤ maxEntry N.
    have hM : ‖M i 0‖ ≤ maxEntry M := by
      fin_cases i <;> simp +decide [ maxEntry ]
    have hN : ‖N 0 j‖ ≤ maxEntry N := by
      fin_cases j <;> simp +decide [ maxEntry ]
    have hM' : ‖M i 1‖ ≤ maxEntry M := by
      fin_cases i <;> simp +decide [ maxEntry ]
    have hN' : ‖N 1 j‖ ≤ maxEntry N := by
      fin_cases j <;> simp +decide [ maxEntry ];
    exact h_mul.symm ▸ le_trans ( norm_add_le _ _ ) ( by nlinarith [ norm_mul ( M i 0 ) ( N 0 j ), norm_mul ( M i 1 ) ( N 1 j ), norm_nonneg ( M i 0 ), norm_nonneg ( N 0 j ), norm_nonneg ( M i 1 ), norm_nonneg ( N 1 j ) ] );
  exact max_le ( max_le ( h_term_norm 0 0 ) ( h_term_norm 0 1 ) ) ( max_le ( h_term_norm 1 0 ) ( h_term_norm 1 1 ) )

/-
Target 2: unitary matrices have entries bounded by one.
-/
theorem unitary_entry_le_one (U : Matrix (Fin 2) (Fin 2) ℂ)
    (hU : U * Uᴴ = 1) (i j : Fin 2) : ‖U i j‖ ≤ 1 := by
  replace hU := congr_fun ( congr_fun hU i ) i ; simp_all +decide [ Matrix.mul_apply ];
  fin_cases i <;> fin_cases j <;> simp_all +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq ];
  · norm_cast at hU; nlinarith;
  · norm_cast at hU; nlinarith;
  · norm_cast at hU; nlinarith;
  · norm_cast at hU; nlinarith

/-
Target 3: powers of unitary matrices are unitary.
-/
theorem unitary_pow (U : Matrix (Fin 2) (Fin 2) ℂ) (hU : U * Uᴴ = 1)
    (n : ℕ) : U ^ n * (U ^ n)ᴴ = 1 := by
  induction n <;> simp_all +decide [ pow_succ', mul_assoc ];
  simp_all +decide [ ← mul_assoc ]

/-
The max-entry seminorm is nonnegative.
-/
theorem maxEntry_nonneg (M : Matrix (Fin 2) (Fin 2) ℂ) : 0 ≤ maxEntry M := by
  exact le_max_of_le_left ( le_max_of_le_left ( norm_nonneg _ ) )

/-
The max-entry seminorm satisfies the triangle inequality.
-/
theorem maxEntry_add_le (M N : Matrix (Fin 2) (Fin 2) ℂ) :
    maxEntry (M + N) ≤ maxEntry M + maxEntry N := by
  apply max_le;
  · apply max_le;
    · exact le_trans ( norm_add_le _ _ ) ( add_le_add ( le_max_of_le_left ( le_max_left _ _ ) ) ( le_max_of_le_left ( le_max_left _ _ ) ) );
    · exact le_trans ( norm_add_le _ _ ) ( add_le_add ( le_max_of_le_left ( le_max_right _ _ ) ) ( le_max_of_le_left ( le_max_right _ _ ) ) );
  · exact max_le_iff.mpr ⟨ by exact le_trans ( norm_add_le _ _ ) ( add_le_add ( le_max_of_le_right ( le_max_left _ _ ) ) ( le_max_of_le_right ( le_max_left _ _ ) ) ), by exact le_trans ( norm_add_le _ _ ) ( add_le_add ( le_max_of_le_right ( le_max_right _ _ ) ) ( le_max_of_le_right ( le_max_right _ _ ) ) ) ⟩

/-
The max-entry seminorm of a finite sum is bounded by the sum of the
max-entry seminorms.
-/
theorem maxEntry_sum_le (n : ℕ) (f : ℕ → Matrix (Fin 2) (Fin 2) ℂ) :
    maxEntry (∑ j ∈ Finset.range n, f j) ≤ ∑ j ∈ Finset.range n, maxEntry (f j) := by
  induction' n with n ih;
  · unfold maxEntry; norm_num;
  · simpa only [ Finset.sum_range_succ ] using le_trans ( maxEntry_add_le _ _ ) ( add_le_add ih le_rfl )

/-
A unitary matrix has max-entry seminorm at most one.
-/
theorem maxEntry_unitary_le_one (U : Matrix (Fin 2) (Fin 2) ℂ)
    (hU : U * Uᴴ = 1) : maxEntry U ≤ 1 := by
  exact max_le ( max_le ( unitary_entry_le_one U hU 0 0 ) ( unitary_entry_le_one U hU 0 1 ) ) ( max_le ( unitary_entry_le_one U hU 1 0 ) ( unitary_entry_le_one U hU 1 1 ) )

/-
Telescoping identity: `A^n - B^n = Σ_{j<n} A^j (A - B) B^{n-1-j}`.
-/
theorem telescope_identity (A B : Matrix (Fin 2) (Fin 2) ℂ) (n : ℕ) :
    A ^ n - B ^ n = ∑ j ∈ Finset.range n, A ^ j * (A - B) * B ^ (n - 1 - j) := by
  induction n <;> simp_all +decide [ pow_succ, Finset.sum_range_succ ];
  rename_i k hk;
  convert congr_arg ( · * B + A ^ k * ( A - B ) ) hk using 1;
  · grind;
  · simp +decide only [Finset.sum_mul _ _ _];
    exact congrArg₂ ( · + · ) ( Finset.sum_congr rfl fun i hi => by rw [ show k - i = k - 1 - i + 1 by rw [ tsub_right_comm, tsub_add_cancel_of_le ( Nat.succ_le_of_lt ( Nat.sub_pos_of_lt ( Finset.mem_range.mp hi ) ) ) ] ] ; simp +decide [ pow_succ, mul_assoc ] ) rfl

/-
Target 4: the unitary telescoping bound — no norm growth over `n`
steps.
-/
theorem telescoping_bound (A B : Matrix (Fin 2) (Fin 2) ℂ)
    (hA : A * Aᴴ = 1) (hB : B * Bᴴ = 1) (n : ℕ) :
    maxEntry (A ^ n - B ^ n) ≤ 4 * n * maxEntry (A - B) := by
  -- By the properties of the maxEntry function and the telescoping identity, we can bound the maxEntry of each term in the sum.
  have h_term_bound : ∀ j ∈ Finset.range n, maxEntry (A ^ j * (A - B) * B ^ (n - 1 - j)) ≤ 4 * maxEntry (A - B) := by
    intros j hj
    have h_maxEntry_Aj : maxEntry (A ^ j) ≤ 1 := by
      exact maxEntry_unitary_le_one _ ( unitary_pow _ hA _ )
    have h_maxEntry_Bn1j : maxEntry (B ^ (n - 1 - j)) ≤ 1 := by
      exact maxEntry_unitary_le_one _ ( unitary_pow _ hB _ );
    refine le_trans ( maxEntry_mul_le _ _ ) ?_;
    have h_maxEntry_Aj_Bn1j :
        maxEntry (A ^ j * (A - B)) ≤ 2 * maxEntry (A ^ j) * maxEntry (A - B) :=
      maxEntry_mul_le _ _
    nlinarith [maxEntry_nonneg (A ^ j), maxEntry_nonneg (A - B),
      maxEntry_nonneg (B ^ (n - 1 - j)),
      mul_le_mul_of_nonneg_right h_maxEntry_Aj (maxEntry_nonneg (A - B)),
      mul_le_mul_of_nonneg_right h_maxEntry_Bn1j (maxEntry_nonneg (A - B))]
  rw [telescope_identity]
  refine le_trans (maxEntry_sum_le _ _) ?_
  simpa [mul_assoc, mul_comm, mul_left_comm] using Finset.sum_le_sum h_term_bound

/-
Target 5: the compact-domain uniform many-step bound.
-/
theorem uniform_compact_bound
    (A B : ℝ → ℝ → Matrix (Fin 2) (Fin 2) ℂ) (C : ℝ → ℝ) (K T : ℝ)
    (hunitA : ∀ a k, A a k * (A a k)ᴴ = 1)
    (hunitB : ∀ a k, B a k * (B a k)ᴴ = 1)
    (honestep : ∀ a k, maxEntry (A a k - B a k) ≤ C k * a ^ 2)
    (hmono : ∀ k, |k| ≤ K → C k ≤ C K)
    (a : ℝ) (ha : 0 < a) (k : ℝ) (hk : |k| ≤ K) (n : ℕ)
    (hT : n * a ≤ T) :
    maxEntry ((A a k) ^ n - (B a k) ^ n) ≤ 4 * T * C K * a := by
  refine le_trans (telescoping_bound _ _ (hunitA a k) (hunitB a k) n) ?_
  refine le_trans (mul_le_mul_of_nonneg_left (honestep a k) (by positivity)) ?_
  nlinarith [mul_le_mul_of_nonneg_left (hmono k hk) (show 0 ≤ n * a by positivity),
    mul_le_mul_of_nonneg_left (hmono k hk) (show 0 ≤ a ^ 2 by positivity), honestep a k,
    show 0 ≤ maxEntry (A a k - B a k) from
      le_trans (norm_nonneg _) (le_max_of_le_left <| le_max_left _ _),
    mul_pos ha ha, mul_pos ha (show 0 < a ^ 2 by positivity)]

/-- The landed one-step constant of the parent repository. -/
noncomputable def Cpoly (k m : ℝ) : ℝ :=
  2 * k ^ 2 + 2 * m ^ 2 + |k| * m ^ 2 + k ^ 2 * |m| + |k| * |m|

/-
Target 6: monotonicity of the landed constant in `|k|`, so the uniform
bound applies with the explicit constant `Cpoly K m`.
-/
theorem Cpoly_mono (k K m : ℝ) (hK : 0 ≤ K) (hk : |k| ≤ K) :
    Cpoly k m ≤ Cpoly K m := by
  unfold Cpoly
  rw [abs_of_nonneg hK]
  nlinarith [abs_nonneg k, abs_nonneg m,
    mul_le_mul_of_nonneg_right hk (abs_nonneg k),
    mul_le_mul_of_nonneg_right hk (abs_nonneg m), sq_abs k, sq_abs m]

end UniformTrotterTelescope
