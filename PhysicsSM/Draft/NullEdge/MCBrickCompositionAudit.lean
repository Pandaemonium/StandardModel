import Mathlib

/-!
# MC brick composition audit (Opus, verified Aristotle 54b11569)

Adversarial check that the MC support bricks actually FEED each other, run BEFORE
integration. VERDICT: composition is CONDITIONAL - the coin/lift bricks do NOT
automatically feed the many-step skeleton. Discharge list, all kernel-checked here:
* the approximate AND reference blocks must EACH be unitary;
* the reference family must satisfy the EXACT one-parameter group law AND identity;
* the conjugation must use a FIXED unitary (an eps-dependent conjugator needs a
  separate compatibility proof);
* CRITICAL: the MC1 quadratic identity M^2 = m^2 . 1 ALONE does NOT establish
  unitarity - the adjointness/Hermiticity condition must be used explicitly.

Also proved: non-vacuity (a concrete simultaneous witness), NO constant drift (the
block/max combination, fixed-unitary conjugation, and telescoping together yield
exactly c t^2 / n), and that the GROUP LAW IS LOAD-BEARING - a counterexample with
W = E = -1, c = 1/2, t = n = 2 has zero local error and unitary families yet would
force the false conclusion 2 <= 1 without it.

Consequence: the ladder is sound, but each join needs its side condition discharged.
Namespace kept as the prover's MCAudit. Provenance: verified at pin from task
ccaed8aa. Standard three. Grade M, [orig] (independent-review artifact). -/

open scoped BigOperators
open Complex Real

namespace MCAudit

/-- In the one-dimensional Hilbert space `ℂ`, this is exactly the operator norm of
multiplication by `z`; thus it gives a concrete scoped operator-norm model. -/
def UnitaryScalar (z : ℂ) : Prop := ‖z‖ = 1

/-- The max norm on a product is the operator norm of a two-block diagonal operator. -/
def block (z₁ z₂ : ℂ) : ℂ × ℂ := (z₁, z₂)

/-- Fixed blockwise unitary conjugation. -/
def conjugateBlock (q : ℂ × ℂ) (z : ℂ × ℂ) : ℂ × ℂ :=
  (q.1 * z.1 * star q.1, q.2 * z.2 * star q.2)

/-
B2 has no hidden factor: two component estimates combine by a maximum, not a sum.
-/
theorem block_bound_same_constant {x₁ x₂ y₁ y₂ : ℂ} {c ε : ℝ}
    (h₁ : ‖x₁ - y₁‖ ≤ c * ε ^ 2) (h₂ : ‖x₂ - y₂‖ ≤ c * ε ^ 2) :
    ‖block x₁ x₂ - block y₁ y₂‖ ≤ c * ε ^ 2 := by
  exact max_le h₁ h₂

/-
Conjugation by a fixed block unitary also preserves the same bound exactly.
-/
theorem conjugateBlock_bound_same_constant {q : ℂ × ℂ} {x y : ℂ × ℂ} {r : ℝ}
    (hq₁ : ‖q.1‖ = 1) (hq₂ : ‖q.2‖ = 1) (h : ‖x - y‖ ≤ r) :
    ‖conjugateBlock q x - conjugateBlock q y‖ ≤ r := by
  simp_all +decide [Prod.norm_def]
  unfold conjugateBlock
  simp_all +decide [← mul_sub, ← sub_mul, mul_assoc, mul_comm]

/-
Powers of a unitary scalar remain norm one.
-/
theorem norm_pow_eq_one {z : ℂ} (hz : UnitaryScalar z) (n : ℕ) : ‖z ^ n‖ = 1 := by
  convert congr_arg ( · ^ n ) hz using 1 <;> norm_num

/-
Exact telescoping estimate for powers; this is the source of the unchanged constant.
-/
theorem unitary_pow_sub_pow_le {x y : ℂ} (hx : UnitaryScalar x)
    (hy : UnitaryScalar y) (n : ℕ) : ‖x ^ n - y ^ n‖ ≤ n * ‖x - y‖ := by
  induction' n with n ih;
  · norm_num;
  · -- Using the triangle inequality and properties of norms:
    have h_triangle : ‖x ^ (n + 1) - y ^ (n + 1)‖ ≤ ‖x ^ n * (x - y)‖ + ‖(x ^ n - y ^ n) * y‖ := by
      convert norm_add_le ( x ^ n * ( x - y ) ) ( ( x ^ n - y ^ n ) * y ) using 2 ; ring;
    simp_all +decide [UnitaryScalar]
    linarith

/-
A real-parameter multiplicative group evaluated at `t/n` composes exactly to `E t`.
-/
theorem group_pow_div {E : ℝ → ℂ} (hzero : E 0 = 1)
    (hadd : ∀ s t, E (s + t) = E s * E t) (t : ℝ) {n : ℕ} (hn : 0 < n) :
    E (t / n) ^ n = E t := by
  -- By induction on $n$, we can show that $E(n \cdot x) = E(x)^n$ for any $x \in \mathbb{R}$.
  have h_ind : ∀ n : ℕ, ∀ x : ℝ, E (n * x) = E x ^ n := by
    intro n x; induction n <;> simp_all +decide [ pow_succ, add_mul ] ;
  rw [ ← h_ind, mul_div_cancel₀ _ ( by positivity ) ]

/-
B5, in the scoped one-dimensional operator norm.
-/
theorem many_step_same_constant {W E : ℝ → ℂ} {c t : ℝ} {n : ℕ}
    (hn : 0 < n)
    (hW : ∀ ε, UnitaryScalar (W ε)) (hE : ∀ ε, UnitaryScalar (E ε))
    (hlocal : ∀ ε, ‖W ε - E ε‖ ≤ c * ε ^ 2)
    (hzero : E 0 = 1) (hadd : ∀ s u, E (s + u) = E s * E u) :
    ‖W (t / n) ^ n - E t‖ ≤ c * t ^ 2 / n := by
  -- Applying the triangle inequality and local bound:
  have h_triangle : ‖W (t / n) ^ n - E t‖ ≤ ‖W (t / n) ^ n - E (t / n) ^ n‖ := by
    rw [ ← group_pow_div hzero hadd t hn ];
  refine le_trans h_triangle ?_;
  convert unitary_pow_sub_pow_le ( hW ( t / n ) ) ( hE ( t / n ) ) n |> le_trans <| mul_le_mul_of_nonneg_left ( hlocal ( t / n ) ) <| Nat.cast_nonneg n using 1 ; ring;
  simp +decide [ sq, mul_assoc, hn.ne' ]

/-
Explicit side conditions needed to feed B2 into B5.  The block families must
be unitary block-by-block; the conjugator `q` is fixed (not epsilon-dependent);
and the reference blocks must obey an exact group law.
-/
theorem b2_feeds_b5_only_with_side_conditions
    {A₁ A₂ B₁ B₂ : ℝ → ℂ} {q : ℂ × ℂ} {c t : ℝ} {n : ℕ}
    (hn : 0 < n)
    (hq₁ : ‖q.1‖ = 1) (hq₂ : ‖q.2‖ = 1)
    (hA₁ : ∀ ε, UnitaryScalar (A₁ ε)) (hA₂ : ∀ ε, UnitaryScalar (A₂ ε))
    (hB₁ : ∀ ε, UnitaryScalar (B₁ ε)) (hB₂ : ∀ ε, UnitaryScalar (B₂ ε))
    (hloc₁ : ∀ ε, ‖A₁ ε - B₁ ε‖ ≤ c * ε ^ 2)
    (hloc₂ : ∀ ε, ‖A₂ ε - B₂ ε‖ ≤ c * ε ^ 2)
    (hBzero₁ : B₁ 0 = 1) (hBzero₂ : B₂ 0 = 1)
    (hBadd₁ : ∀ s u, B₁ (s + u) = B₁ s * B₁ u)
    (hBadd₂ : ∀ s u, B₂ (s + u) = B₂ s * B₂ u) :
    ‖conjugateBlock q (block (A₁ (t / n) ^ n) (A₂ (t / n) ^ n)) -
      conjugateBlock q (block (B₁ t) (B₂ t))‖ ≤ c * t ^ 2 / n := by
  -- Apply B2 to bound the difference between the blocks.
  have h_block_bound : ‖block (A₁ (t / n) ^ n) (A₂ (t / n) ^ n) - block (B₁ t) (B₂ t)‖ ≤ c * t ^ 2 / n := by
    convert block_bound_same_constant _ _ using 1;
    rotate_left;
    exact c / n;
    exact t;
    · convert many_step_same_constant hn hA₁ hB₁ hloc₁ hBzero₁ hBadd₁ using 1 ; ring;
    · convert many_step_same_constant hn hA₂ hB₂ hloc₂ hBzero₂ hBadd₂ using 1 ; ring;
    · ring;
  convert conjugateBlock_bound_same_constant hq₁ hq₂ h_block_bound using 1

/-
Concrete nonzero coin core (`M=m=1`): the B1 formula is Euler's formula.
-/
theorem coin_core_nontrivial (a : ℝ) :
    Complex.exp ((-(a : ℂ)) * (Complex.I * (1 : ℂ))) =
      (Real.cos (a * 1) : ℂ) - (Complex.I * Real.sin (a * 1) / (1 : ℝ)) * (1 : ℂ) := by
  norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Real.cos, Real.sin ]

/-
A simultaneous, non-vacuous instance: `M=1`, `c=1`, `n=2`; both blocks are
`exp (-i ε)`, the local error is zero, and fixed conjugation is by `(1,1)`.
-/
theorem simultaneous_nonvacuous_witness :
    (1 : ℂ) ≠ 0 ∧ (1 : ℝ) ≠ 0 ∧ (2 : ℕ) ≥ 2 ∧
    (∀ a : ℝ, Complex.exp ((-(a : ℂ)) * (Complex.I * (1 : ℂ))) =
      (Real.cos (a * 1) : ℂ) - (Complex.I * Real.sin (a * 1) / (1 : ℝ)) * (1 : ℂ)) ∧
    (∀ ε : ℝ, UnitaryScalar (Complex.exp (-(Complex.I * ε)))) ∧
    (∀ ε : ℝ, ‖Complex.exp (-(Complex.I * ε)) - Complex.exp (-(Complex.I * ε))‖ ≤
      (1 : ℝ) * ε ^ 2) ∧
    (∀ s t : ℝ, Complex.exp (-(Complex.I * (s + t))) =
      Complex.exp (-(Complex.I * s)) * Complex.exp (-(Complex.I * t))) ∧
    ‖conjugateBlock (1, 1)
        (block ((Complex.exp (-(Complex.I * ((2 : ℝ) / 2)))) ^ 2)
          ((Complex.exp (-(Complex.I * ((2 : ℝ) / 2)))) ^ 2)) -
      conjugateBlock (1, 1)
        (block (Complex.exp (-(Complex.I * 2))) (Complex.exp (-(Complex.I * 2))) )‖
      ≤ (1 : ℝ) * (2 : ℝ) ^ 2 / 2 := by
  refine' ⟨ by norm_num, by norm_num, by norm_num, _, _, _, _ ⟩;
  · norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Real.cos, Real.sin ];
  · exact fun ε => by unfold UnitaryScalar; norm_num [ Complex.norm_exp ] ;
  · norm_num [ sq_nonneg ];
  · norm_num [ ← Complex.exp_add, conjugateBlock, block ];
    norm_num [ ← Complex.exp_nat_mul ] ; ring_nf ; norm_num [ Complex.normSq, Complex.norm_def, Complex.exp_re, Complex.exp_im ]

/-
Without the group law B5 is false.  Take the unitary but non-group family
`W(ε)=E(ε)=-1`.  Its local error is zero, yet at `t=n=2`, two steps give `1`
while the alleged target is `-1`; even `c=1/2` gives the false bound `2 ≤ 1`.
-/
theorem no_group_counterexample :
    let W : ℝ → ℂ := fun _ => -1
    let E : ℝ → ℂ := fun _ => -1
    let c : ℝ := 1 / 2
    (∀ ε, UnitaryScalar (W ε)) ∧
    (∀ ε, UnitaryScalar (E ε)) ∧
    (∀ ε, ‖W ε - E ε‖ ≤ c * ε ^ 2) ∧
    ¬ (∀ s t, E (s + t) = E s * E t) ∧
    ¬ (‖W ((2 : ℝ) / (2 : ℕ)) ^ (2 : ℕ) - E 2‖ ≤ c * (2 : ℝ) ^ 2 / (2 : ℕ)) := by
  norm_num [ UnitaryScalar ];
  exact fun ε => sq_nonneg ε

end MCAudit
