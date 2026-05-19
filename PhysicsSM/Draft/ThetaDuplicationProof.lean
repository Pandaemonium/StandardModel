import Mathlib

/-!
# Theta duplication identities (Mathlib-only proof)

We define theta functions matching SPL's conventions and prove the
duplication identities using only Mathlib.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.style.setOption false
set_option linter.style.refine false
set_option linter.style.multiGoal false
set_option linter.flexible false
set_option maxHeartbeats 800000

open Complex Real Filter Topology

noncomputable section

/-- Local theta₃: `∑' n : ℤ, cexp (π * I * n² * τ)` -/
def myΘ₃ (τ : ℂ) : ℂ := ∑' n : ℤ, cexp (↑π * I * (n : ℂ) ^ 2 * τ)

/-- Local theta₄: `∑' n : ℤ, (-1)^n * cexp (π * I * n² * τ)` -/
def myΘ₄ (τ : ℂ) : ℂ := ∑' n : ℤ, (-1 : ℂ) ^ n * cexp (↑π * I * (n : ℂ) ^ 2 * τ)

/-- Local theta₂: `∑' n : ℤ, cexp (π * I * (n + 1/2)² * τ)` -/
def myΘ₂ (τ : ℂ) : ℂ := ∑' n : ℤ, cexp (↑π * I * ((n : ℂ) + 1 / 2) ^ 2 * τ)

/-- `myΘ₃ τ = jacobiTheta₂ 0 τ` -/
theorem myΘ₃_eq_jacobiTheta₂ (τ : ℂ) : myΘ₃ τ = jacobiTheta₂ 0 τ := by
  simp only [myΘ₃, jacobiTheta₂, jacobiTheta₂_term]
  congr 1; ext n; ring_nf

/-
`myΘ₄ τ = jacobiTheta₂ (1/2) τ`
-/
theorem myΘ₄_eq_jacobiTheta₂ (τ : ℂ) : myΘ₄ τ = jacobiTheta₂ (1 / 2) τ := by
  simp only [myΘ₄, jacobiTheta₂, jacobiTheta₂_term]
  congr 1; ext n
  rw [ ← Complex.exp_log ( by norm_num : ( -1 : ℂ ) ≠ 0 ), ← Complex.exp_int_mul ] ; ring;
  rw [ ← Complex.exp_add, Complex.log ] ; norm_num ; ring;

-- Summability helpers
theorem summable_Θ₃_term {τ : ℂ} (hτ : 0 < τ.im) :
    Summable (fun n : ℤ => cexp (↑π * I * (n : ℂ) ^ 2 * τ)) := by
  have : (fun n : ℤ => cexp (↑π * I * (n : ℂ) ^ 2 * τ)) =
    (fun n : ℤ => jacobiTheta₂_term n 0 τ) := by
    ext n; simp [jacobiTheta₂_term]
  rw [this]
  exact (hasSum_jacobiTheta₂_term 0 hτ).summable

theorem summable_Θ₄_term {τ : ℂ} (hτ : 0 < τ.im) :
    Summable (fun n : ℤ => (-1 : ℂ) ^ n * cexp (↑π * I * (n : ℂ) ^ 2 * τ)) := by
  convert ( hasSum_jacobiTheta₂_term ( 1 / 2 ) hτ ) |> ( fun h => h.summable ) using 1;
  ext n; norm_num [ jacobiTheta₂_term ] ; ring;
  rw [ ← Complex.exp_log ( show ( -1 : ℂ ) ≠ 0 by norm_num ), ← Complex.exp_int_mul ] ; ring;
  rw [ ← Complex.exp_add, Complex.log ] ; norm_num ; ring

theorem summable_Θ₂_term {τ : ℂ} (hτ : 0 < τ.im) :
    Summable (fun n : ℤ => cexp (↑π * I * ((n : ℂ) + 1 / 2) ^ 2 * τ)) := by
  -- The norm of the exponential term is $e^{-\pi \tau.im (n + 1/2)^2}$, which decays exponentially as $|n|$ increases.
  have h_exp_decay : Summable (fun n : ℤ => Real.exp (-Real.pi * τ.im * (n + 1 / 2) ^ 2)) := by
    have h_gaussian : Summable (fun n : ℤ => Real.exp (-Real.pi * τ.im * n ^ 2 / 2)) := by
      have h_gaussian : Summable (fun n : ℕ => Real.exp (-Real.pi * τ.im * n ^ 2 / 2)) := by
        have h_gaussian : Summable (fun n : ℕ => Real.exp (-Real.pi * τ.im * n / 2)) := by
          have h_gaussian : Summable (fun n : ℕ => (Real.exp (-Real.pi * τ.im / 2)) ^ n) := by
            exact summable_geometric_of_lt_one ( by positivity ) ( by rw [ Real.exp_lt_one_iff ] ; nlinarith [ Real.pi_pos ] );
          exact h_gaussian.congr fun n => by rw [ ← Real.exp_nat_mul ] ; ring;
        simp +zetaDelta at *;
        exact h_gaussian.of_nonneg_of_le ( fun n => by positivity ) fun n => by gcongr ; norm_cast ; nlinarith;
      have h_split : ∀ {f : ℤ → ℝ}, Summable f ↔ Summable (fun n : ℕ => f n) ∧ Summable (fun n : ℕ => f (-n)) := by
        exact fun {f} => summable_int_iff_summable_nat_and_neg
      aesop;
    have h_gaussian : ∀ n : ℤ, Real.exp (-Real.pi * τ.im * (n + 1 / 2) ^ 2) ≤ Real.exp (-Real.pi * τ.im * n ^ 2 / 2) + Real.exp (-Real.pi * τ.im * (n + 1) ^ 2 / 2) := by
      intro n; rcases n with ( _ | n ) <;> norm_num <;> ring_nf <;> norm_num [ Real.pi_pos, hτ ] ;
      · exact le_add_of_le_of_nonneg ( Real.exp_le_exp.mpr <| by nlinarith [ Real.pi_pos, mul_nonneg Real.pi_pos.le hτ.le ] ) ( Real.exp_nonneg _ );
      · exact le_add_of_nonneg_of_le ( Real.exp_nonneg _ ) ( Real.exp_le_exp.mpr ( by nlinarith [ Real.pi_pos, mul_nonneg Real.pi_pos.le hτ.le ] ) );
    refine' Summable.of_nonneg_of_le ( fun n => Real.exp_nonneg _ ) ( fun n => h_gaussian n ) _;
    exact Summable.add ‹_› ( by exact_mod_cast ‹Summable fun n : ℤ => Real.exp ( -Real.pi * τ.im * n ^ 2 / 2 ) ›.comp_injective ( add_left_injective 1 ) );
  rw [ ← summable_norm_iff ] at *;
  convert h_exp_decay using 2 ; norm_num [ Complex.norm_exp ] ; ring;
  norm_num ; ring;
  norm_cast ; norm_num

/-
The key identity: Θ₄(τ)² = Θ₃(2τ)² - Θ₂(2τ)²
-/
theorem myTheta4_sq_duplication {τ : ℂ} (hτ : 0 < τ.im) :
    myΘ₄ τ ^ 2 = myΘ₃ (2 * τ) ^ 2 - myΘ₂ (2 * τ) ^ 2 := by
  have h_expand : (∑' n : ℤ, (-1 : ℂ) ^ n * Complex.exp (Real.pi * Complex.I * (n : ℂ) ^ 2 * τ)) ^ 2 = (∑' p : ℤ × ℤ, (-1 : ℂ) ^ (p.1 + p.2) * Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)) := by
    erw [ sq, Summable.tsum_prod ];
    · rw [ ← tsum_mul_right ] ; congr ; ext n ; rw [ ← tsum_mul_left ] ; congr ; ext m ; ring ; norm_num [ zpow_add₀, zpow_mul ] ; ring;
      rw [ Complex.exp_add ] ; ring;
    · have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)) := by
        have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * n ^ 2 * τ)) := by
          convert summable_Θ₃_term hτ using 1;
        have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * p.1 ^ 2 * τ) * Complex.exp (Real.pi * Complex.I * p.2 ^ 2 * τ)) := by
          exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.norm ) ( h_summable.norm ) ;
        exact h_summable.congr fun p => by rw [ ← Complex.exp_add ] ; ring;
      exact Summable.of_norm <| by simpa using h_summable.norm;
  -- Split the sum into two parts: one where $m+n$ is even and one where $m+n$ is odd.
  have h_split : (∑' p : ℤ × ℤ, (-1 : ℂ) ^ (p.1 + p.2) * Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)) = (∑' p : ℤ × ℤ, if (p.1 + p.2) % 2 = 0 then Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ) else 0) - (∑' p : ℤ × ℤ, if (p.1 + p.2) % 2 = 1 then Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ) else 0) := by
    rw [ ← Summable.tsum_sub ];
    · refine' tsum_congr fun p => _;
      rcases Int.even_or_odd' ( p.1 + p.2 ) with ⟨ k, hk | hk ⟩ <;> norm_num [ hk, zpow_add₀, zpow_mul ];
    · have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)) := by
        have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * (n : ℂ) ^ 2 * τ)) := by
          convert summable_Θ₃_term hτ using 1;
        have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 : ℂ) ^ 2 * τ) * Complex.exp (Real.pi * Complex.I * (p.2 : ℂ) ^ 2 * τ)) := by
          exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.norm ) ( h_summable.norm ) ;
        convert h_summable using 2 ; push_cast [ ← Complex.exp_add ] ; ring;
      -- Since the original series is summable, any subseries (where we pick some terms and ignore others) is also summable.
      have h_subseries : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)) → Summable (fun p : ℤ × ℤ => if (p.1 + p.2) % 2 = 0 then Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ) else 0) := by
        intro h_summable
        have h_subseries : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)) → Summable (fun p : ℤ × ℤ => if (p.1 + p.2) % 2 = 0 then Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ) else 0) := by
          intro h_summable
          have h_abs_summable : Summable (fun p : ℤ × ℤ => ‖Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)‖) := by
            exact h_summable.norm
          have h_abs_summable : Summable (fun p : ℤ × ℤ => ‖if (p.1 + p.2) % 2 = 0 then Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ) else 0‖) := by
            exact Summable.of_nonneg_of_le ( fun p => norm_nonneg _ ) ( fun p => by split_ifs <;> norm_num ) h_abs_summable;
          exact .of_norm h_abs_summable;
        exact h_subseries h_summable;
      exact h_subseries h_summable;
    · have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ)) := by
        have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * (n : ℂ) ^ 2 * τ)) := by
          convert summable_Θ₃_term hτ using 1;
        have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 : ℂ) ^ 2 * τ) * Complex.exp (Real.pi * Complex.I * (p.2 : ℂ) ^ 2 * τ)) := by
          exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.norm ) ( h_summable.norm ) ;
        convert h_summable using 2 ; push_cast [ ← Complex.exp_add ] ; ring;
      convert h_summable.indicator ( { p : ℤ × ℤ | ( p.1 + p.2 ) % 2 = 1 } ) using 1;
      ext; simp [Set.indicator];
  -- For the even part, use the bijection $\phi : \mathbb{Z} \times \mathbb{Z} \to \mathbb{Z} \times \mathbb{Z}$ given by $(m,n) \mapsto ((m+n)/2, (m-n)/2)$.
  have h_even : (∑' p : ℤ × ℤ, if (p.1 + p.2) % 2 = 0 then Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ) else 0) = (∑' p : ℤ × ℤ, Complex.exp (Real.pi * Complex.I * (2 * p.1 ^ 2 + 2 * p.2 ^ 2) * τ)) := by
    have h_even_bij : ∀ p : ℤ × ℤ, (p.1 + p.2) % 2 = 0 ↔ ∃ q : ℤ × ℤ, p = (q.1 + q.2, q.1 - q.2) := by
      simp +zetaDelta at *;
      exact fun a b => ⟨ fun h => ⟨ ( a + b ) / 2, ( a - b ) / 2, by omega, by omega ⟩, fun ⟨ a', b', ha', hb' ⟩ => by omega ⟩;
    rw [ tsum_eq_tsum_of_ne_zero_bij ];
    use fun x => ( x.val.1 + x.val.2, x.val.1 - x.val.2 );
    · norm_num [ Function.Injective ];
      exact fun a b c d h₁ h₂ => ⟨ by linarith, by linarith ⟩;
    · intro p hp; specialize h_even_bij p; aesop;
    · intro x; ring; norm_num [ Complex.exp_ne_zero ] ;
      exact congr_arg _ ( by ring );
  -- For the odd part, use the bijection $\psi : \mathbb{Z} \times \mathbb{Z} \to \mathbb{Z} \times \mathbb{Z}$ given by $(m,n) \mapsto ((m+n-1)/2, (m-n-1)/2)$.
  have h_odd : (∑' p : ℤ × ℤ, if (p.1 + p.2) % 2 = 1 then Complex.exp (Real.pi * Complex.I * (p.1 ^ 2 + p.2 ^ 2) * τ) else 0) = (∑' p : ℤ × ℤ, Complex.exp (Real.pi * Complex.I * (2 * p.1 ^ 2 + 2 * p.2 ^ 2 + 2 * p.1 + 2 * p.2 + 1) * τ)) := by
    have h_odd_bij : ∀ p : ℤ × ℤ, (p.1 + p.2) % 2 = 1 ↔ ∃ q : ℤ × ℤ, p = (q.1 + q.2 + 1, q.1 - q.2) := by
      simp +zetaDelta at *;
      exact fun a b => ⟨ fun h => ⟨ ( a + b - 1 ) / 2, ( a - b - 1 ) / 2, by omega, by omega ⟩, by rintro ⟨ a, b, rfl, rfl ⟩ ; omega ⟩;
    rw [ tsum_eq_tsum_of_ne_zero_bij ];
    use fun x => ( x.val.1 + x.val.2 + 1, x.val.1 - x.val.2 );
    · norm_num [ Function.Injective ];
      grind;
    · intro p hp; specialize h_odd_bij p; aesop;
    · grind;
  -- Recognize that the sums in h_even and h_odd are the squares of the theta functions.
  have h_even_sq : (∑' p : ℤ × ℤ, Complex.exp (Real.pi * Complex.I * (2 * p.1 ^ 2 + 2 * p.2 ^ 2) * τ)) = (∑' n : ℤ, Complex.exp (Real.pi * Complex.I * (n : ℂ) ^ 2 * (2 * τ))) ^ 2 := by
    rw [ sq, Summable.tsum_prod ];
    · rw [ ← tsum_mul_right ] ; congr ; ext n ; rw [ ← tsum_mul_left ] ; congr ; ext m ; ring;
      rw [ ← Complex.exp_add ];
    · have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * (2 * n ^ 2) * τ)) := by
        convert summable_Θ₃_term ( show 0 < ( 2 * τ ).im by norm_num; linarith ) using 1;
        exact funext fun n => by ring;
      have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (2 * p.1 ^ 2) * τ) * Complex.exp (Real.pi * Complex.I * (2 * p.2 ^ 2) * τ)) := by
        exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.norm ) ( h_summable.norm ) ;
      convert h_summable using 2 ; push_cast [ ← Complex.exp_add ] ; ring
  have h_odd_sq : (∑' p : ℤ × ℤ, Complex.exp (Real.pi * Complex.I * (2 * p.1 ^ 2 + 2 * p.2 ^ 2 + 2 * p.1 + 2 * p.2 + 1) * τ)) = (∑' n : ℤ, Complex.exp (Real.pi * Complex.I * ((n : ℂ) + 1 / 2) ^ 2 * (2 * τ))) ^ 2 := by
    erw [ sq, Summable.tsum_prod ];
    · rw [ ← tsum_mul_right ] ; congr ; ext n ; rw [ ← tsum_mul_left ] ; congr ; ext m ; ring;
      rw [ ← Complex.exp_add ] ; ring;
    · have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * ((n : ℂ) + 1 / 2) ^ 2 * (2 * τ))) := by
        convert summable_Θ₂_term ( show 0 < ( 2 * τ ).im by norm_num; linarith ) using 1;
      have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * ((p.1 : ℂ) + 1 / 2) ^ 2 * (2 * τ)) * Complex.exp (Real.pi * Complex.I * ((p.2 : ℂ) + 1 / 2) ^ 2 * (2 * τ))) := by
        exact .of_norm <| by simpa [ ← mul_assoc, ← Complex.exp_add ] using Summable.mul_norm ( h_summable.norm ) ( h_summable.norm ) ;
      convert h_summable using 2 ; push_cast [ ← Complex.exp_add ] ; ring;
  unfold myΘ₃ myΘ₄ myΘ₂; aesop;

/-
The key identity: Θ₂(τ)² = 2 * Θ₂(2τ) * Θ₃(2τ)
-/
theorem myTheta2_sq_duplication {τ : ℂ} (hτ : 0 < τ.im) :
    myΘ₂ τ ^ 2 = 2 * myΘ₂ (2 * τ) * myΘ₃ (2 * τ) := by
  -- Write Θ₂(τ)² using HasSum.mul to get the double sum ∑_{(m,n) : ℤ×ℤ} cexp(πi((m+1/2)²+(n+1/2)²)τ).
  have h_sum : (myΘ₂ τ) ^ 2 = ∑' (p : ℤ × ℤ), Complex.exp (Real.pi * Complex.I * ((p.1 + 1 / 2) ^ 2 + (p.2 + 1 / 2) ^ 2) * τ) := by
    erw [ sq, Summable.tsum_prod ];
    · rw [ myΘ₂, ← tsum_mul_right ];
      exact tsum_congr fun _ => by rw [ ← tsum_mul_left ] ; exact tsum_congr fun _ => by rw [ ← mul_comm ] ; rw [ ← Complex.exp_add ] ; ring;
    · have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * (n + 1 / 2) ^ 2 * τ)) := by
        convert summable_Θ₂_term hτ using 1;
      have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 + 1 / 2) ^ 2 * τ) * Complex.exp (Real.pi * Complex.I * (p.2 + 1 / 2) ^ 2 * τ)) := by
        exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.norm ) ( h_summable.norm ) ;
      exact h_summable.congr fun _ => by rw [ ← Complex.exp_add ] ; ring;
  -- Split by parity of m-n: Even case (m-n=2l): set a=(m+n)/2, b=l=(m-n)/2, so m=a+b, n=a-b.
  have h_even : ∑' (p : ℤ × ℤ), Complex.exp (Real.pi * Complex.I * ((p.1 + 1 / 2) ^ 2 + (p.2 + 1 / 2) ^ 2) * τ) = ∑' (a : ℤ × ℤ), Complex.exp (Real.pi * Complex.I * (2 * (a.1 + 1 / 2) ^ 2 + 2 * a.2 ^ 2) * τ) + ∑' (a : ℤ × ℤ), Complex.exp (Real.pi * Complex.I * (2 * a.1 ^ 2 + 2 * (a.2 + 1 / 2) ^ 2) * τ) := by
    have h_split : ∑' (p : ℤ × ℤ), Complex.exp (Real.pi * Complex.I * ((p.1 + 1 / 2) ^ 2 + (p.2 + 1 / 2) ^ 2) * τ) = ∑' (p : ℤ × ℤ), (if (p.1 - p.2) % 2 = 0 then Complex.exp (Real.pi * Complex.I * ((p.1 + 1 / 2) ^ 2 + (p.2 + 1 / 2) ^ 2) * τ) else 0) + ∑' (p : ℤ × ℤ), (if (p.1 - p.2) % 2 = 1 then Complex.exp (Real.pi * Complex.I * ((p.1 + 1 / 2) ^ 2 + (p.2 + 1 / 2) ^ 2) * τ) else 0) := by
      rw [ ← Summable.tsum_add ] ; congr ; ext p ; aesop;
      · have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * ((p.1 + 1 / 2) ^ 2 + (p.2 + 1 / 2) ^ 2) * τ)) := by
          have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * (n + 1 / 2) ^ 2 * τ)) := by
            convert summable_Θ₂_term hτ using 1;
          have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 + 1 / 2) ^ 2 * τ) * Complex.exp (Real.pi * Complex.I * (p.2 + 1 / 2) ^ 2 * τ)) := by
            exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.norm ) ( h_summable.norm ) ;
          convert h_summable using 2 ; push_cast [ ← Complex.exp_add ] ; ring;
        convert h_summable.indicator ( { p : ℤ × ℤ | ( p.1 - p.2 ) % 2 = 0 } ) using 1;
        ext; simp [Set.indicator];
      · have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * ((p.1 + 1 / 2) ^ 2 + (p.2 + 1 / 2) ^ 2) * τ)) := by
          have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * (n + 1 / 2) ^ 2 * τ)) := by
            convert summable_Θ₂_term hτ using 1;
          have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 + 1 / 2) ^ 2 * τ) * Complex.exp (Real.pi * Complex.I * (p.2 + 1 / 2) ^ 2 * τ)) := by
            exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.norm ) ( h_summable.norm ) ;
          convert h_summable using 2 ; push_cast [ ← Complex.exp_add ] ; ring;
        convert h_summable.indicator ( { p : ℤ × ℤ | ( p.1 - p.2 ) % 2 = 1 } ) using 1;
        ext; simp [Set.indicator];
    convert h_split using 2;
    · rw [ ← tsum_eq_tsum_of_ne_zero_bij ];
      use fun x => ( x.val.1 + x.val.2, x.val.1 - x.val.2 );
      · norm_num [ Function.Injective ];
        lia;
      · intro x hx; use ⟨ ( ( x.1 + x.2 ) / 2, ( x.1 - x.2 ) / 2 ), by
          simp_all +decide [ Function.support ] ⟩ ; simp +decide ; ring;
        exact Prod.ext ( by linarith [ Int.ediv_mul_cancel ( show 2 ∣ x.1 + x.2 from Int.dvd_of_emod_eq_zero ( by norm_num at hx; omega ) ), Int.ediv_mul_cancel ( show 2 ∣ x.1 - x.2 from Int.dvd_of_emod_eq_zero ( by norm_num at hx; omega ) ) ] ) ( by linarith [ Int.ediv_mul_cancel ( show 2 ∣ x.1 + x.2 from Int.dvd_of_emod_eq_zero ( by norm_num at hx; omega ) ), Int.ediv_mul_cancel ( show 2 ∣ x.1 - x.2 from Int.dvd_of_emod_eq_zero ( by norm_num at hx; omega ) ) ] );
      · grind;
    · rw [ ← tsum_eq_tsum_of_ne_zero_bij ];
      use fun x => ( x.val.1 + x.val.2, x.val.1 - x.val.2 - 1 );
      · norm_num [ Function.Injective ];
        grind +qlia;
      · intro x hx; simp_all +decide [ Function.support ] ;
        exact ⟨ ( x.1 + x.2 + 1 ) / 2, ( x.1 - x.2 - 1 ) / 2, by ext <;> omega ⟩;
      · grind;
  -- Recognize that the sums in h_even are exactly the definitions of myΘ₂(2τ) and myΘ₃(2τ).
  have h_def : ∑' (a : ℤ × ℤ), Complex.exp (Real.pi * Complex.I * (2 * (a.1 + 1 / 2) ^ 2 + 2 * a.2 ^ 2) * τ) = myΘ₂ (2 * τ) * myΘ₃ (2 * τ) ∧ ∑' (a : ℤ × ℤ), Complex.exp (Real.pi * Complex.I * (2 * a.1 ^ 2 + 2 * (a.2 + 1 / 2) ^ 2) * τ) = myΘ₃ (2 * τ) * myΘ₂ (2 * τ) := by
    constructor <;> rw [ Summable.tsum_prod ] <;> norm_num [ myΘ₂, myΘ₃ ];
    · rw [ ← tsum_mul_right ] ; congr ; ext n ; rw [ ← tsum_mul_left ] ; congr ; ext m ; rw [ ← mul_comm ] ; ring;
      rw [ ← Complex.exp_add ];
    · have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * (n + 1 / 2) ^ 2 * (2 * τ))) ∧ Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * n ^ 2 * (2 * τ))) := by
        constructor;
        · convert summable_Θ₂_term ( show 0 < ( 2 * τ |> Complex.im ) by norm_num; linarith ) using 1;
        · convert summable_Θ₃_term ( show 0 < ( 2 * τ ).im by norm_num; linarith ) using 1;
      have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (p.1 + 1 / 2) ^ 2 * (2 * τ)) * Complex.exp (Real.pi * Complex.I * p.2 ^ 2 * (2 * τ))) := by
        exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.1.norm ) ( h_summable.2.norm ) ;
      convert h_summable using 2 ; rw [ ← Complex.exp_add ] ; ring;
    · rw [ ← tsum_mul_right ] ; congr ; ext n ; rw [ ← tsum_mul_left ] ; congr ; ext m ; ring;
      rw [ ← Complex.exp_add ] ; ring;
    · have h_summable : Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * (2 * n ^ 2) * τ)) ∧ Summable (fun n : ℤ => Complex.exp (Real.pi * Complex.I * (2 * (n + 1 / 2) ^ 2) * τ)) := by
        constructor;
        · convert summable_Θ₃_term ( show 0 < ( 2 * τ ).im by simpa ) using 1;
          exact funext fun n => by ring;
        · convert summable_Θ₂_term ( show 0 < ( 2 * τ |> Complex.im ) by simpa using by positivity ) using 1;
          exact funext fun n => by ring;
      have h_summable : Summable (fun p : ℤ × ℤ => Complex.exp (Real.pi * Complex.I * (2 * p.1 ^ 2) * τ) * Complex.exp (Real.pi * Complex.I * (2 * (p.2 + 1 / 2) ^ 2) * τ)) := by
        exact .of_norm <| by simpa using Summable.mul_norm ( h_summable.1.norm ) ( h_summable.2.norm ) ;
      convert h_summable using 2 ; push_cast [ ← Complex.exp_add ] ; ring;
  grind

end
