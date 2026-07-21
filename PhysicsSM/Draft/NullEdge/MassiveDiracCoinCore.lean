import Mathlib

/-!
# Massive-coin exponential core (Opus, verified Aristotle d43b43ad)

Abstract Mathlib-only core of the MC1 identity: for M with M*M = (m^2 : C) . 1,
0 <= m, AND the side condition (m = 0 -> M = 0),
  exp ((-a : C) . (I . M)) = cos (a*m) . 1 - (I * sin (a*m) / (m : C)) . M.

SHARPENS the audit `OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md` item 2. That
audit concluded MC1 needs no `z != 0` hypothesis; that conclusion STANDS for the
concrete `mass4` (because `mass4 0 = 0`), but the reasoning must be stated more
carefully in general: the side condition `m = 0 -> M = 0` is NECESSARY for a
formula uniform in `a`. Square-zero alone does NOT suffice - at m = 0 with M^2 = 0
one gets exp(-i a M) = 1 - i a M (proved here), and a concrete nonzero square-zero
4x4 counterexample is included. The exact fixed-`a` condition for the exponential
to be 1 is ((-a i) . M = 0).

So: Codex may drop `z != 0` from MC1 for `mass4`, discharging the side condition
by `mass4 0 = 0`. Offered for the MC1 integration (walk-agnostic; no MC file
touched). Namespace kept as the prover's MassiveDiracCoin. Provenance: verified at
pin from task d13eba8c. Standard three. Claim grade M, [comp]. -/

open scoped Matrix.Norms.L2Operator

namespace MassiveDiracCoin

open NormedSpace

private lemma matrix_pow_even_of_sq_scalar
    (M : Matrix (Fin 4) (Fin 4) ℂ) (m : ℝ)
    (hM : M * M = (m ^ 2 : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ)) (n : ℕ) :
    M ^ (2 * n) = (m : ℂ) ^ (2 * n) • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  induction n <;> simp_all +decide [ Nat.mul_succ, pow_succ, mul_assoc ] ;
  rw [ smul_smul ]

private lemma matrix_pow_odd_of_sq_scalar
    (M : Matrix (Fin 4) (Fin 4) ℂ) (m : ℝ)
    (hM : M * M = (m ^ 2 : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ)) (n : ℕ) :
    M ^ (2 * n + 1) = (m : ℂ) ^ (2 * n) • M := by
  induction n <;> simp_all +decide [ Nat.mul_succ, pow_succ, mul_assoc ];
  rw [ smul_smul ]

private lemma expSeries_even_neg_I_mul_matrix
    (M : Matrix (Fin 4) (Fin 4) ℂ) (m a : ℝ)
    (hM : M * M = (m ^ 2 : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ)) (n : ℕ) :
    expSeries ℚ (Matrix (Fin 4) (Fin 4) ℂ) (2 * n)
        (fun _ ↦ (-a : ℂ) • (Complex.I • M)) =
      ((-1 : ℂ) ^ n * (a * m : ℂ) ^ (2 * n) /
        ((2 * n).factorial : ℂ)) • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  convert congr_arg ( fun x : Matrix ( Fin 4 ) ( Fin 4 ) ℂ => ( ( 1 : ℚ ) / ( 2 * n ).factorial : ℂ ) • x ) ( show ( ( -a • Complex.I • M ) ^ ( 2 * n ) ) = ( ( -1 : ℂ ) ^ n * ( a * m ) ^ ( 2 * n ) : ℂ ) • 1 from ?_ ) using 1;
  · norm_num [ NormedSpace.expSeries_apply_eq, smul_pow ];
    ext; norm_num [ Algebra.smul_def ];
  · simp +decide [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm, smul_smul ];
  · convert congr_arg ( fun x : Matrix ( Fin 4 ) ( Fin 4 ) ℂ => ( -a : ℂ ) ^ ( 2 * n ) • ( Complex.I ^ ( 2 * n ) : ℂ ) • x ) ( matrix_pow_even_of_sq_scalar M m hM n ) using 1 ; norm_num [ Algebra.smul_def ] ; ring;
    · induction n * 2 <;> simp_all +decide [ pow_succ, mul_assoc ];
      simp +decide [ mul_assoc, mul_left_comm, Algebra.algebraMap_eq_smul_one ];
    · norm_num [ pow_mul, ← mul_pow ] ; ring;
      simp +decide [ mul_assoc, mul_comm, mul_left_comm, smul_smul ]

private lemma expSeries_odd_neg_I_mul_matrix
    (M : Matrix (Fin 4) (Fin 4) ℂ) (m a : ℝ)
    (hM : M * M = (m ^ 2 : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ))
    (hm : m ≠ 0) (n : ℕ) :
    expSeries ℚ (Matrix (Fin 4) (Fin 4) ℂ) (2 * n + 1)
        (fun _ ↦ (-a : ℂ) • (Complex.I • M)) =
      ((-1 : ℂ) ^ n * (a * m : ℂ) ^ (2 * n + 1) /
        ((2 * n + 1).factorial : ℂ)) • ((-Complex.I / (m : ℂ)) • M) := by
  simp +decide [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm, smul_smul, pow_succ, pow_mul, ← mul_pow, hM, hm, Nat.factorial_succ, Nat.cast_mul, Nat.cast_add, Nat.cast_one, expSeries ];
  simp +decide [ smul_pow, mul_pow, ← mul_assoc, ← pow_add, hM ] ; ring;
  rw [ show M * M ^ ( n * 2 ) = ( m ^ 2 : ℂ ) ^ n • M from ?_ ] ; norm_num [ pow_mul', hm, mul_assoc, mul_left_comm, mul_comm ] ; ring;
  · module;
  · induction n <;> simp_all +decide [ Nat.succ_mul, pow_succ, mul_assoc ];
    rw [ smul_smul, mul_comm ]

/-
The exponential of a square-zero matrix truncates after its linear term.
-/
theorem exp_matrix_of_sq_eq_zero
    (X : Matrix (Fin 4) (Fin 4) ℂ) (hX : X * X = 0) :
    NormedSpace.exp X = 1 + X := by
  rw [ exp ];
  split_ifs <;> simp_all +decide [ NormedSpace.expSeries_sum_eq ];
  · rw [ tsum_eq_sum ];
    any_goals exact { 0, 1 };
    · norm_num [ Algebra.smul_def ];
    · rintro ( _ | _ | n ) hn <;> simp_all +decide [ pow_succ, mul_assoc ];
      norm_num [ Algebra.smul_def ];
  · exact False.elim <| ‹IsEmpty ( Algebra ℚ ( Matrix ( Fin 4 ) ( Fin 4 ) ℂ ) ) ›.elim <| inferInstance

/-
At zero mass, the square relation alone gives a linear nilpotent correction,
not necessarily the value `1`.
-/
theorem exp_neg_I_mul_matrix_of_sq_eq_zero
    (M : Matrix (Fin 4) (Fin 4) ℂ) (a : ℝ) (hM : M * M = 0) :
    NormedSpace.exp ((-a : ℂ) • (Complex.I • M)) =
      1 + (-a : ℂ) • (Complex.I • M) := by
  convert exp_matrix_of_sq_eq_zero _ _ using 2 ; norm_num [ hM, mul_assoc, mul_smul_comm, smul_smul ]

/-
The exact extra condition in the square-zero case for the exponential to be
`1`. For fixed `a`, this is weaker than `M = 0` when `a = 0`; when `a ≠ 0`, it
is equivalent to `M = 0`.
-/
theorem exp_neg_I_mul_matrix_eq_one_iff
    (M : Matrix (Fin 4) (Fin 4) ℂ) (a : ℝ) (hM : M * M = 0) :
    NormedSpace.exp ((-a : ℂ) • (Complex.I • M)) = 1 ↔
      (-a : ℂ) • (Complex.I • M) = 0 := by
  rw [ exp_neg_I_mul_matrix_of_sq_eq_zero ];
  · simp +zetaDelta at *;
  · exact hM

/-
A concrete witness that `M * M = 0` alone does not force the zero-mass
closed form (already for `a = 1`).
-/
theorem exists_square_zero_matrix_with_nontrivial_exp :
    ∃ M : Matrix (Fin 4) (Fin 4) ℂ,
      M * M = 0 ∧ NormedSpace.exp ((-(1 : ℝ) : ℂ) • (Complex.I • M)) ≠ 1 := by
  -- Consider the matrix $M = E_{01}$, where $E_{01}$ is the matrix with a 1 at the $(0,1)$ position and 0 elsewhere.
  use Matrix.of (fun i j => if i = 0 ∧ j = 1 then 1 else 0);
  refine' ⟨ _, _ ⟩;
  · ext i j; rw [ Matrix.mul_apply ] ; aesop;
  · convert exp_neg_I_mul_matrix_eq_one_iff _ _ _ |>.not.mpr _;
    · ext i j; rw [ Matrix.mul_apply ] ; aesop;
    · exact ne_of_apply_ne ( fun m => m 0 1 ) ( by norm_num [ Complex.ext_iff ] )

/-
Closed form for the exponential of a matrix whose square is a scalar matrix.

The extra hypothesis at `m = 0` is necessary: square-zero alone does not suffice,
since for `M ^ 2 = 0` one has `exp (-i a M) = 1 - i a M`, which need not be `1`.
For nonzero `m`, no additional hypothesis on `M` is needed. The nonnegativity of
`m` records its interpretation as a mass; the algebraic identity itself does not
use it.
-/
theorem exp_neg_I_mul_matrix_closed_form
    (M : Matrix (Fin 4) (Fin 4) ℂ) (m a : ℝ)
    (hm : 0 ≤ m)
    (hM : M * M = (m ^ 2 : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ))
    (hzero : m = 0 → M = 0) :
    NormedSpace.exp ((-a : ℂ) • (Complex.I • M)) =
      Complex.cos (a * m) • (1 : Matrix (Fin 4) (Fin 4) ℂ) -
        (Complex.I * Complex.sin (a * m) / (m : ℂ)) • M := by
  by_cases h : m = 0 <;> simp_all +decide [ div_eq_inv_mul, mul_assoc, mul_left_comm, neg_mul ];
  -- For the case when $m \neq 0$, we can apply the exponential series to $-i a M$.
  have h_exp : (∑' n : ℕ, expSeries ℚ (Matrix (Fin 4) (Fin 4) ℂ) n (fun _ => (-a : ℂ) • (Complex.I • M))) = Complex.cos (a * m) • (1 : Matrix (Fin 4) (Fin 4) ℂ) - (Complex.I * Complex.sin (a * m) / m) • M := by
    rw [ ← tsum_even_add_odd ];
    · rw [ tsum_congr fun n => expSeries_even_neg_I_mul_matrix M m a hM n, tsum_congr fun n => expSeries_odd_neg_I_mul_matrix M m a hM h n ];
      rw [ Complex.cos_eq_tsum, Complex.sin_eq_tsum ];
      rw [ Summable.tsum_smul_const, Summable.tsum_smul_const ] ; norm_num [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm, tsum_mul_left, tsum_mul_right ] ; ring;
      · simp +decide [ sub_eq_add_neg, mul_assoc, mul_comm, mul_left_comm, smul_smul ];
      · exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.comp_injective <| by intro m n h; simpa using h;
      · exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.comp_injective <| by intro m n h; simpa using h;
    · -- The series $\sum_{k=0}^{\infty} \frac{(-1)^k (a m)^{2k}}{(2k)!}$ is the Taylor series for $\cos(a m)$, which converges for all $a$ and $m$.
      have h_cos_series : Summable (fun k : ℕ => ((-1 : ℂ) ^ k * (a * m) ^ (2 * k) / ((2 * k).factorial : ℂ))) := by
        exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.comp_injective <| by intro m n h; simpa using h;
      convert h_cos_series.smul_const ( 1 : Matrix ( Fin 4 ) ( Fin 4 ) ℂ ) using 2 ; ring;
      convert expSeries_even_neg_I_mul_matrix M m a hM _ using 1 ; ring;
    · -- The series $\sum_{n=0}^{\infty} \frac{(-i a m)^{2n+1}}{(2n+1)!}$ is the Taylor series for $\sin(a m)$, which converges.
      have h_sin_series : Summable (fun n : ℕ => ((-1 : ℂ) ^ n * (a * m : ℂ) ^ (2 * n + 1) / ((2 * n + 1).factorial : ℂ))) := by
        exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.comp_injective <| by intro m n h; simpa using h;
      convert h_sin_series.smul_const ( ( -Complex.I / m ) • M ) using 2 ; norm_num [ expSeries_odd_neg_I_mul_matrix, hM, h ];
      convert expSeries_odd_neg_I_mul_matrix M m a hM h _ using 1 ; norm_num [ div_eq_inv_mul, mul_assoc, mul_left_comm, h ];
  convert NormedSpace.exp_eq_tsum _ using 1;
  any_goals exact ℚ;
  all_goals try infer_instance;
  constructor <;> intro h <;> simp_all +decide [ funext_iff, expSeries ];
  · grind +suggestions;
  · grind +suggestions

/-- The explicitly degenerate case of the closed form. -/
theorem exp_neg_I_mul_matrix_zero
    (M : Matrix (Fin 4) (Fin 4) ℂ) (a : ℝ) (hM : M = 0) :
    NormedSpace.exp ((-a : ℂ) • (Complex.I • M)) =
      Complex.cos (a * (0 : ℝ)) • (1 : Matrix (Fin 4) (Fin 4) ℂ) -
        (Complex.I * Complex.sin (a * (0 : ℝ)) / (0 : ℂ)) • M := by
  aesop

end MassiveDiracCoin
