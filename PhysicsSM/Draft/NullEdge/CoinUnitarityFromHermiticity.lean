import Mathlib

/-!
# Coin unitarity from Hermiticity (Opus, verified Aristotle 36a14fa9)

Discharges composition side conditions 2 and 4 identified by
`MCBrickCompositionAudit`. The composition audit found a TRAP: the quadratic
identity M^2 = m^2 . 1 ALONE does not give coin unitarity. This module sources the
unitarity correctly: Hermitian M => (-a).(I.M) skew-adjoint => its exponential is
unitary with norm 1 => via the closed form, the coin is unitary. It also proves the
EXACT group law coin a * coin b = coin (a+b) and coin 0 = 1 - the other side
condition the many-step skeleton requires of the reference family.

TRAP WITNESSED: badN (upper-left block [[1,1],[0,-1]]) satisfies badN^2 = 1 yet is
NON-Hermitian and yields a NON-unitary coin at m = 1, a = pi/2. So the squaring
relation is genuinely insufficient - the adjointness condition must be used.

Namespace kept as the prover's CoinUnitarity. Provenance: verified at pin from task
d806f6e9. Standard three. Claim grade M, [comp]. -/

open scoped Matrix.Norms.L2Operator
open scoped ComplexConjugate

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace CoinUnitarity

abbrev C := ℂ
abbrev R := ℝ
abbrev Mat4 := Matrix (Fin 4) (Fin 4) C

/-- The coin family associated with a mass `m` and matrix `M`. -/
noncomputable def coin (M : Mat4) (m a : R) : Mat4 :=
  (Real.cos (a * m) : C) • 1 -
    (Complex.I * Real.sin (a * m) / (m : C)) • M

/-
A real multiple of `I M` is skew-adjoint when `M` is Hermitian.
-/
lemma skewAdjoint_exponent (M : Mat4) (hM : M.IsHermitian) (a : R) :
    star (((-a : C)) • ((Complex.I : C) • M)) =
      -(((-a : C)) • ((Complex.I : C) • M)) := by
  ext i j
  have hij := congrFun (congrFun hM i) j
  simp_all [Complex.ext_iff]

/-
The exponential of a skew-adjoint `4 × 4` complex matrix is unitary.
-/
lemma exp_unitary_of_skewAdjoint (X : Mat4) (hX : star X = -X) :
    NormedSpace.exp X ∈ unitary Mat4 := by
  letI : NormedAlgebra ℚ Mat4 := NormedAlgebra.restrictScalars ℚ ℂ Mat4
  exact NormedSpace.exp_mem_unitary_of_mem_skewAdjoint
    (skewAdjoint.mem_iff.mpr hX)

/-
In the scoped L2 operator norm, a unitary exponential has norm one.
-/
lemma norm_exp_eq_one_of_skewAdjoint (X : Mat4) (hX : star X = -X) :
    ‖NormedSpace.exp X‖ = 1 := by
  exact CStarRing.norm_of_mem_unitary (exp_unitary_of_skewAdjoint X hX)

/-
Closed form for the exponential used by the coin, obtained from `M² = m² I`.
-/
lemma exp_exponent_eq_coin (M : Mat4) (m a : R)
    (hsq : M * M = (m ^ 2 : C) • 1) (hm0 : m = 0 → M = 0) :
    NormedSpace.exp (((-a : C)) • ((Complex.I : C) • M)) = coin M m a := by
  unfold coin;
  by_cases hm : m = 0 <;> simp_all +decide [ Complex.cos, Complex.sin, Complex.exp_re, Complex.exp_im ];
  -- We'll use the exponential representation of the matrix exponential.
  have h_exp : NormedSpace.exp (-(a • Complex.I • M)) = (∑' n, ((-a * Complex.I) ^ n / Nat.factorial n) • M ^ n) := by
    convert NormedSpace.exp_eq_tsum using 3 ; ring;
    constructor <;> intro h <;> simp_all +decide [ NormedSpace.exp_eq_tsum, mul_assoc, mul_comm, mul_left_comm, smul_pow ];
    convert NormedSpace.exp_eq_tsum using 3;
    convert congr_fun ( h ℂ ) ( - ( a • Complex.I • M ) ) using 1;
    refine' tsum_congr fun n => _ ; ring;
    rw [ show ( - ( a • Complex.I • M ) ) ^ n = ( -1 ) ^ n • ( a ^ n • Complex.I ^ n • M ^ n ) by
          induction n <;> simp_all +decide [ pow_succ, mul_assoc, mul_left_comm, smul_smul ];
          simp +decide [ mul_assoc, mul_left_comm, smul_smul, Algebra.smul_def ];
          simp +decide [ Algebra.algebraMap_eq_smul_one, mul_assoc, mul_left_comm, smul_smul ] ] ; norm_num [ mul_assoc, mul_comm, mul_left_comm, smul_smul ] ; ring;
    ext; norm_num; ring;
    simp +decide [ Matrix.mul_apply, mul_assoc, mul_comm, mul_left_comm ];
    erw [ show ( ( -1 : Mat4 ) ^ n ) = ( -1 : ℝ ) ^ n • 1 from ?_ ] ; norm_num [ mul_comm ];
    · simp +decide [ Matrix.one_apply, mul_comm ];
    · cases Nat.even_or_odd n <;> simp +decide [ * ];
  -- Let's simplify the expression using the fact that $M^2 = m^2 I$.
  have h_simp : ∀ n : ℕ, M ^ (2 * n) = (m ^ 2) ^ n • 1 ∧ M ^ (2 * n + 1) = (m ^ 2) ^ n • M := by
    intro n; induction n <;> simp_all +decide [ Nat.mul_succ, pow_succ, pow_mul ] ;
    simp +decide [ mul_assoc, mul_left_comm, Algebra.smul_def ];
    simp +decide [ ← mul_assoc, Algebra.algebraMap_eq_smul_one ];
  -- Let's split the sum into even and odd terms.
  have h_split : ∑' n, ((-a * Complex.I) ^ n / Nat.factorial n) • M ^ n = (∑' n, ((-a * Complex.I) ^ (2 * n) / Nat.factorial (2 * n)) • (m ^ 2) ^ n • 1) + (∑' n, ((-a * Complex.I) ^ (2 * n + 1) / Nat.factorial (2 * n + 1)) • (m ^ 2) ^ n • M) := by
    rw [ ← tsum_even_add_odd ];
    · aesop;
    · simp_all +decide [ pow_mul ];
      -- The series $\sum_{k=0}^{\infty} \frac{(-a^2 m^2)^k}{(2k)!}$ is a convergent p-series with $p = 2 > 1$.
      have h_pseries : Summable (fun k : ℕ => ((-a ^ 2 * m ^ 2) ^ k / (Nat.factorial (2 * k)) : ℂ)) := by
        exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.of_nonneg_of_le ( fun n => by positivity ) fun n => by gcongr ; linarith;
      convert h_pseries.smul_const ( ( m ^ 2 ) ^ 0 • 1 : Mat4 ) using 2 ; ring;
      norm_num [ pow_mul', ← mul_pow ] ; ring;
      ext i j ; norm_num ; ring;
    · simp_all +decide [ pow_add, pow_mul ];
      -- We'll use the fact that if the series $\sum_{k=0}^{\infty} \frac{(-a^2 m^2)^k}{(2k+1)!}$ converges, then the series $\sum_{k=0}^{\infty} \frac{(-a^2 m^2)^k}{(2k+1)!} M$ also converges.
      have h_series_conv : Summable (fun k : ℕ => ((-a ^ 2 * m ^ 2) ^ k / (Nat.factorial (2 * k + 1) : ℂ))) := by
        exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.of_nonneg_of_le ( fun n => by positivity ) fun n => by gcongr ; linarith;
      convert h_series_conv.smul_const ( - ( a * Complex.I ) • M ) using 2 ; ring;
      ext ; norm_num ; ring;
      norm_num [ pow_mul', mul_assoc, mul_comm, mul_left_comm ];
  -- Let's simplify the even and odd sums separately.
  have h_even : ∑' n, ((-a * Complex.I) ^ (2 * n) / Nat.factorial (2 * n)) • (m ^ 2) ^ n • (1 : Mat4) = (Complex.cos (a * m)) • (1 : Mat4) := by
    rw [ Complex.cos_eq_tsum ];
    rw [ ← Summable.tsum_smul_const ] ; congr ; ext n ; norm_num [ pow_mul, ← mul_pow ] ; ring;
    · norm_num [ pow_mul', mul_assoc, mul_comm, mul_left_comm ];
    · exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.comp_injective <| by intro m n h; simpa using h;
  have h_odd : ∑' n, ((-a * Complex.I) ^ (2 * n + 1) / Nat.factorial (2 * n + 1)) • (m ^ 2) ^ n • M = (-Complex.I * Complex.sin (a * m) / m) • M := by
    have h_odd : ∑' n, ((-a * Complex.I) ^ (2 * n + 1) / Nat.factorial (2 * n + 1)) * (m ^ 2) ^ n = -Complex.I * Complex.sin (a * m) / m := by
      rw [ Complex.sin_eq_tsum ];
      rw [ ← tsum_mul_left ] ; rw [ ← tsum_div_const ] ; congr ; ext n ; ring ; norm_num [ hm, pow_add, pow_mul, mul_assoc, mul_left_comm, mul_comm ] ; ring;
      norm_num [ pow_mul', ← mul_pow ] ; ring ; aesop;
    rw [ ← h_odd, ← Summable.tsum_smul_const ] ; congr ; ext n ; norm_num [ mul_assoc, mul_comm, mul_left_comm, smul_smul ];
    have := Complex.hasSum_sin ( a * m );
    convert this.summable.mul_left ( -Complex.I / m ) using 2 ; ring;
    norm_num [ pow_mul', hm ] ; ring;
    simp +decide [ hm, mul_assoc, mul_comm, mul_left_comm ];
  simp_all +decide [ Complex.cos, Complex.sin ];
  norm_num [ sub_eq_add_neg, add_smul ];
  norm_num [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm, smul_smul ]

/--
Coin unitarity is sourced from Hermiticity, via its skew-adjoint exponential.
The requested assumption `0 ≤ m` is retained in the interface, although the closed-form
argument shows that unitarity itself does not depend on the sign of `m`.
-/
theorem coin_mem_unitary (M : Mat4) (m a : R) (hM : M.IsHermitian)
    (hsq : M * M = (m ^ 2 : C) • 1) (hm : 0 ≤ m) (hm0 : m = 0 → M = 0) :
    coin M m a ∈ unitary Mat4 := by
  rw [← exp_exponent_eq_coin M m a hsq hm0]
  exact exp_unitary_of_skewAdjoint _ (skewAdjoint_exponent M hM a)

/-
Consequently every coin has L2 operator norm one.
-/
theorem coin_norm_eq_one (M : Mat4) (m a : R) (hM : M.IsHermitian)
    (hsq : M * M = (m ^ 2 : C) • 1) (hm : 0 ≤ m) (hm0 : m = 0 → M = 0) :
    ‖coin M m a‖ = 1 := by
  exact CStarRing.norm_of_mem_unitary (coin_mem_unitary M m a hM hsq hm hm0)

/--
The exact one-parameter group law under the requested hypotheses. Hermiticity and
nonnegativity are retained in the interface, though this algebraic law only uses the
quadratic relation and the specified zero-mass behavior.
-/
theorem coin_mul_coin (M : Mat4) (m a b : R) (hM : M.IsHermitian)
    (hsq : M * M = (m ^ 2 : C) • 1) (hm : 0 ≤ m) (hm0 : m = 0 → M = 0) :
    coin M m a * coin M m b = coin M m (a + b) := by
  clear hM hm
  by_cases hm : m = 0 <;> simp_all +decide [ coin ];
  simp_all +decide [ mul_sub, sub_mul, smul_sub, sub_smul, mul_smul_comm, smul_smul, add_mul, mul_add, div_eq_mul_inv ];
  ext i j ; norm_num [ Complex.cos_add, Complex.sin_add ] ; ring;
  norm_num [ hm, mul_assoc, mul_comm, mul_left_comm ] ; ring

/-
The coin family has the identity at parameter zero.
-/
theorem coin_zero (M : Mat4) (m : R) : coin M m 0 = 1 := by
  simp [coin]

/-- A concrete non-Hermitian involution: its upper-left block is `[[1,1],[0,-1]]`. -/
def badN : Mat4 := fun i j =>
  if i = 0 ∧ j = 0 then 1 else
  if i = 0 ∧ j = 1 then 1 else
  if i = 1 ∧ j = 1 then -1 else
  if i = 2 ∧ j = 2 then 1 else
  if i = 3 ∧ j = 3 then 1 else 0

lemma badN_sq : badN * badN = ((1 : R) ^ 2 : C) • 1 := by
  ext i j
  simp [badN, Matrix.mul_apply]
  fin_cases i <;> fin_cases j <;> simp +decide [Fin.sum_univ_four]

lemma badN_not_hermitian : ¬ badN.IsHermitian := by
  intro h
  have hij := congrFun (congrFun h 0) 1
  simp +decide [badN] at hij

lemma badN_coin_not_unitary :
    coin badN 1 (Real.pi / 2) ∉ unitary Mat4 := by
  unfold unitary
  simp +zetaDelta at *
  unfold coin
  intro h
  have h10 := congrFun (congrFun h 1) 0
  norm_num [Fin.sum_univ_succ, Matrix.mul_apply, badN] at h10
  simp +decide at h10

/-
The squaring relation alone does not imply Hermiticity or coin unitarity.
-/
theorem squaring_relation_alone_insufficient :
    ∃ (N : Mat4) (m a : R),
      N * N = (m ^ 2 : C) • 1 ∧
      ¬ N.IsHermitian ∧
      coin N m a ∉ unitary Mat4 := by
  exact ⟨badN, 1, Real.pi / 2, badN_sq,
    badN_not_hermitian, badN_coin_not_unitary⟩

end CoinUnitarity
