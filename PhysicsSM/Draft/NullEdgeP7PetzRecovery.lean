import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Log.NegMulLog
import Mathlib.Analysis.Convex.Jensen

/-!
# P7 classical Petz recoverability and DPI saturation

This module contains the proof that the classical data-processing inequality for
Kullback-Leibler divergence is saturated (holds with equality) if the Petz
recovery map successfully reconstructs the state $p$ from $T p$.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7PetzRecovery

open BigOperators

/-- Finite Kullback-Leibler divergence. -/
noncomputable def kl {n : Nat} (p q : Fin n -> Real) : Real :=
  Finset.univ.sum fun i => p i * Real.log (p i / q i)

/-- Apply a finite nonnegative transition matrix. -/
def applyMap {m n : Nat} (T : Fin m -> Fin n -> Real)
    (p : Fin n -> Real) : Fin m -> Real :=
  fun i => Finset.univ.sum fun j => T i j * p j

/-
**Log-sum inequality** (finite form).
-/
lemma log_sum_ineq {n : Nat} (a b : Fin n -> Real)
    (ha : ∀ j, 0 ≤ a j) (hb : ∀ j, 0 ≤ b j)
    (hac : ∀ j, b j = 0 → a j = 0) :
    (Finset.univ.sum a) * Real.log ((Finset.univ.sum a) / (Finset.univ.sum b))
      ≤ Finset.univ.sum (fun j => a j * Real.log (a j / b j)) := by
  by_cases h : ∑ j, b j = 0 <;> simp_all +decide [ Finset.sum_eq_zero_iff_of_nonneg ];
  have h_jensen : (∑ j, (b j / ∑ k, b k) * ((a j / b j) * Real.log (a j / b j))) ≥ ((∑ j, (b j / ∑ k, b k) * (a j / b j))) * Real.log ((∑ j, (b j / ∑ k, b k) * (a j / b j))) := by
    have h_jensen : ConvexOn ℝ (Set.Ici 0) (fun x : ℝ => x * Real.log x) := by
      exact ( Real.convexOn_mul_log );
    apply ConvexOn.map_sum_le h_jensen;
    · exact fun i _ => div_nonneg ( hb i ) ( Finset.sum_nonneg fun _ _ => hb _ );
    · rw [ ← Finset.sum_div, div_self <| ne_of_gt <| lt_of_lt_of_le ( lt_of_le_of_ne ( hb h.choose ) <| Ne.symm h.choose_spec ) <| Finset.single_le_sum ( fun i _ => hb i ) <| Finset.mem_univ _ ];
    · exact fun i _ => div_nonneg ( ha i ) ( hb i );
  simp_all +decide [← Finset.sum_div _ _ _, div_mul_eq_mul_div];
  convert mul_le_mul_of_nonneg_right h_jensen ( show 0 ≤ ∑ k, b k from Finset.sum_nonneg fun _ _ => hb _ ) using 1;
  · rw [ div_mul_cancel₀ _ ( by obtain ⟨ j, hj ⟩ := h; exact ne_of_gt ( lt_of_lt_of_le ( lt_of_le_of_ne ( hb j ) ( Ne.symm hj ) ) ( Finset.single_le_sum ( fun i _ => hb i ) ( Finset.mem_univ j ) ) ) ) ] ; congr ; ext i ; by_cases hi : b i = 0 <;> simp +decide [ *, mul_div_cancel₀ ] ;
    exact funext fun i => by by_cases hi : b i = 0 <;> simp +decide [ *, mul_div_cancel₀ ] ;
  · rw [ div_mul_cancel₀ _ ( by obtain ⟨ i, hi ⟩ := h; exact ne_of_gt ( lt_of_lt_of_le ( lt_of_le_of_ne ( hb i ) ( Ne.symm hi ) ) ( Finset.single_le_sum ( fun i _ => hb i ) ( Finset.mem_univ i ) ) ) ), Finset.sum_congr rfl ] ; intros ; by_cases hi : b ‹_› = 0 <;> simp +decide [ *, mul_div_cancel₀ ]

/-
Data-processing inequality.
-/
theorem kl_data_processing {m n : Nat}
    (T : Fin m -> Fin n -> Real)
    (hnonneg : ∀ i j, 0 ≤ T i j)
    (hcol : ∀ j, Finset.univ.sum (fun i => T i j) = 1)
    (p q : Fin n -> Real)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i) :
    kl (applyMap T p) (applyMap T q) ≤ kl p q := by
  have h_log_sum : ∀ i, (∑ j, T i j * p j) * Real.log ((∑ j, T i j * p j) / (∑ j, T i j * q j)) ≤ ∑ j, T i j * p j * Real.log (p j / q j) := by
    intro i; convert log_sum_ineq ( fun j => T i j * p j ) ( fun j => T i j * q j ) ( fun j => mul_nonneg ( hnonneg i j ) ( hp j ) ) ( fun j => mul_nonneg ( hnonneg i j ) ( le_of_lt ( hq j ) ) ) ( fun j => ?_ ) using 1;
    · grind;
    · simp +contextual [ ne_of_gt ( hq _ ) ]
  calc kl (applyMap T p) (applyMap T q)
      ≤ ∑ i, ∑ j, T i j * p j * Real.log (p j / q j) :=
        Finset.sum_le_sum fun i _ => h_log_sum i
    _ = kl p q := by
        rw [Finset.sum_comm]
        simp only [kl, ← Finset.sum_mul, mul_assoc, mul_left_comm, hcol, one_mul]

/-- Classical Petz recovery map R(x | y) = q(x) T(y | x) / (T q)(y). -/
noncomputable def petzMap {m n : Nat} (T : Fin m -> Fin n -> Real) (q : Fin n -> Real) : Fin n -> Fin m -> Real :=
  fun x y => q x * T y x / applyMap T q y

/-- The Petz map is nonnegative when T and q are. -/
theorem petzMap_nonneg {m n : Nat} (T : Fin m -> Fin n -> Real) (q : Fin n -> Real)
    (hT : ∀ y x, 0 ≤ T y x) (hq : ∀ x, 0 ≤ q x) (hTq : ∀ y, 0 < applyMap T q y) :
    ∀ x y, 0 ≤ petzMap T q x y := by
  intro x y
  unfold petzMap
  exact div_nonneg (mul_nonneg (hq x) (hT y x)) (le_of_lt (hTq y))

/-- The Petz map is column-stochastic (its columns sum to 1). -/
theorem petzMap_col_sum {m n : Nat} (T : Fin m -> Fin n -> Real) (q : Fin n -> Real)
    (hTq : ∀ y, 0 < applyMap T q y) :
    ∀ y, Finset.univ.sum (fun x => petzMap T q x y) = 1 := by
  intro y
  unfold petzMap applyMap
  rw [← Finset.sum_div]
  have h_eq : (∑ x, q x * T y x) = applyMap T q y := by
    unfold applyMap
    exact Finset.sum_congr rfl (fun x _ => mul_comm _ _)
  rw [h_eq]
  exact div_self (ne_of_gt (hTq y))

/--
The Petz map recovers the reference state `q`.

The column-stochasticity hypothesis `hcol` is mathematically essential. Without
it the statement is false: in the one-point case with `T 0 0 = 1 / 2` and
`q 0 = 1`, the reconstructed state has total weight `1 / 2`, not `1`. This is
the finite classical version of the usual Petz setting, where the channel
preserves normalization.
-/
theorem petzMap_recovers_q {m n : Nat} (T : Fin m -> Fin n -> Real) (q : Fin n -> Real)
    (hcol : ∀ j, Finset.univ.sum (fun i => T i j) = 1)
    (hTq : ∀ y, 0 < applyMap T q y) :
    applyMap (petzMap T q) (applyMap T q) = q := by
  ext x
  show (∑ y, petzMap T q x y * applyMap T q y) = q x
  have h_term : ∀ y, petzMap T q x y * applyMap T q y = q x * T y x := by
    intro y
    simp only [petzMap]
    rw [div_mul_cancel₀ _ (ne_of_gt (hTq y))]
  rw [Finset.sum_congr rfl (fun y _ => h_term y), ← Finset.mul_sum, hcol x, mul_one]

/--
If the Petz map recovers the state p, then the relative entropy loss is zero
(meaning the data-processing inequality is saturated).
-/
theorem kl_equality_of_petz_recovery {m n : Nat}
    (T : Fin m -> Fin n -> Real)
    (hnonneg : ∀ i j, 0 ≤ T i j)
    (hcol : ∀ j, Finset.univ.sum (fun i => T i j) = 1)
    (p q : Fin n -> Real)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hTq : ∀ y, 0 < applyMap T q y)
    (hTpos : ∀ y, 0 < applyMap T p y)
    (h_recover_p : applyMap (petzMap T q) (applyMap T p) = p) :
    kl (applyMap T p) (applyMap T q) = kl p q := by
  refine le_antisymm (kl_data_processing T hnonneg hcol p q hp hq) ?_
  have hforward := kl_data_processing (petzMap T q)
    (petzMap_nonneg T q hnonneg (fun x => le_of_lt (hq x)) hTq)
    (petzMap_col_sum T q hTq)
    (applyMap T p) (applyMap T q)
    (fun i => le_of_lt (hTpos i)) hTq
  rw [h_recover_p, petzMap_recovers_q T q hcol hTq] at hforward
  exact hforward

end PhysicsSM.Draft.NullEdgeP7PetzRecovery
