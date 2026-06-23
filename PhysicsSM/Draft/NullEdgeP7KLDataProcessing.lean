import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Log.NegMulLog
import Mathlib.Analysis.Convex.Jensen

/-!
# P7 relative-entropy data-processing inequality

The core monotonicity of the P7 recoverability program: a stochastic (Markov)
map cannot increase the finite Kullback-Leibler divergence. This is the discrete
data-processing inequality for relative entropy - an observer / coarse-graining
channel can only lose distinguishability. Its (approximate) saturation is what
"recoverability" controls.

```text
KL(T p, T q) <= KL(p, q)   for column-stochastic T.
```

Standalone (Mathlib only), `Real.log 0 = 0` convention.

The proof is the classical termwise application of the **log-sum inequality**
(equivalently, joint convexity of `(x,y) ↦ x log (x/y)`, here packaged as
convexity of `x ↦ x log x` plus Jensen's inequality). No normalization of `p`
or `q` to probability vectors is required: the statement holds for arbitrary
nonnegative `p` and positive `q`, with only column-stochasticity of `T`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7KLDataProcessing

open BigOperators

/-- Finite Kullback-Leibler divergence. -/
def kl {n : Nat} (p q : Fin n -> Real) : Real :=
  Finset.univ.sum fun i => p i * Real.log (p i / q i)

/-- Apply a finite nonnegative transition matrix. -/
def applyMap {m n : Nat} (T : Fin m -> Fin n -> Real)
    (p : Fin n -> Real) : Fin m -> Real :=
  fun i => Finset.univ.sum fun j => T i j * p j

/-
**Log-sum inequality** (finite form).  For nonnegative `a` and `b` with
`a` absolutely continuous with respect to `b` (`b j = 0 → a j = 0`),
`(∑ a) · log ((∑ a)/(∑ b)) ≤ ∑ a j · log (a j / b j)`, under the
`Real.log 0 = 0` convention.
-/
lemma log_sum_ineq {n : Nat} (a b : Fin n -> Real)
    (ha : ∀ j, 0 ≤ a j) (hb : ∀ j, 0 ≤ b j)
    (hac : ∀ j, b j = 0 → a j = 0) :
    (Finset.univ.sum a) * Real.log ((Finset.univ.sum a) / (Finset.univ.sum b))
      ≤ Finset.univ.sum (fun j => a j * Real.log (a j / b j)) := by
  by_cases h : ∑ j, b j = 0 <;> simp_all +decide [ Finset.sum_eq_zero_iff_of_nonneg ];
  -- Apply Jensen's inequality with the convex function $f(x) = x \log x$ and weights $w_j = \frac{b_j}{\sum_{k=0}^{n-1} b_k}$.
  have h_jensen : (∑ j, (b j / ∑ k, b k) * ((a j / b j) * Real.log (a j / b j))) ≥ ((∑ j, (b j / ∑ k, b k) * (a j / b j))) * Real.log ((∑ j, (b j / ∑ k, b k) * (a j / b j))) := by
    have h_jensen : ConvexOn ℝ (Set.Ici 0) (fun x : ℝ => x * Real.log x) := by
      exact ( Real.convexOn_mul_log );
    apply ConvexOn.map_sum_le h_jensen;
    · exact fun i _ => div_nonneg ( hb i ) ( Finset.sum_nonneg fun _ _ => hb _ );
    · rw [ ← Finset.sum_div, div_self <| ne_of_gt <| lt_of_lt_of_le ( lt_of_le_of_ne ( hb h.choose ) <| Ne.symm h.choose_spec ) <| Finset.single_le_sum ( fun i _ => hb i ) <| Finset.mem_univ _ ];
    · exact fun i _ => div_nonneg ( ha i ) ( hb i );
  simp_all +decide [ ← mul_assoc, ← Finset.sum_div _ _ _, div_mul_eq_mul_div ];
  convert mul_le_mul_of_nonneg_right h_jensen ( show 0 ≤ ∑ k, b k from Finset.sum_nonneg fun _ _ => hb _ ) using 1;
  · rw [ div_mul_cancel₀ _ ( by obtain ⟨ j, hj ⟩ := h; exact ne_of_gt ( lt_of_lt_of_le ( lt_of_le_of_ne ( hb j ) ( Ne.symm hj ) ) ( Finset.single_le_sum ( fun i _ => hb i ) ( Finset.mem_univ j ) ) ) ) ] ; congr ; ext i ; by_cases hi : b i = 0 <;> simp +decide [ *, mul_div_cancel₀ ] ;
    exact funext fun i => by by_cases hi : b i = 0 <;> simp +decide [ *, mul_div_cancel₀ ] ;
  · rw [ div_mul_cancel₀ _ ( by obtain ⟨ i, hi ⟩ := h; exact ne_of_gt ( lt_of_lt_of_le ( lt_of_le_of_ne ( hb i ) ( Ne.symm hi ) ) ( Finset.single_le_sum ( fun i _ => hb i ) ( Finset.mem_univ i ) ) ) ), Finset.sum_congr rfl ] ; intros ; by_cases hi : b ‹_› = 0 <;> simp +decide [ *, mul_div_cancel₀ ]

/-
Data-processing inequality: a column-stochastic map does not increase the
relative entropy (log-sum inequality).
-/
theorem kl_data_processing {m n : Nat}
    (T : Fin m -> Fin n -> Real)
    (hnonneg : ∀ i j, 0 ≤ T i j)
    (hcol : ∀ j, Finset.univ.sum (fun i => T i j) = 1)
    (p q : Fin n -> Real)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i) :
    kl (applyMap T p) (applyMap T q) ≤ kl p q := by
  -- Apply the log-sum inequality to each term in the sum.
  have h_log_sum : ∀ i, (∑ j, T i j * p j) * Real.log ((∑ j, T i j * p j) / (∑ j, T i j * q j)) ≤ ∑ j, T i j * p j * Real.log (p j / q j) := by
    intro i; convert log_sum_ineq ( fun j => T i j * p j ) ( fun j => T i j * q j ) ( fun j => mul_nonneg ( hnonneg i j ) ( hp j ) ) ( fun j => mul_nonneg ( hnonneg i j ) ( le_of_lt ( hq j ) ) ) ( fun j => ?_ ) using 1;
    · grind;
    · simp +contextual [ ne_of_gt ( hq _ ) ]
  -- Summing over all rows and using column-stochasticity of `T`.
  calc kl (applyMap T p) (applyMap T q)
      ≤ ∑ i, ∑ j, T i j * p j * Real.log (p j / q j) :=
        Finset.sum_le_sum fun i _ => h_log_sum i
    _ = kl p q := by
        rw [Finset.sum_comm]
        simp only [kl, ← Finset.sum_mul, mul_assoc, mul_left_comm, hcol, one_mul]

end PhysicsSM.Draft.NullEdgeP7KLDataProcessing
