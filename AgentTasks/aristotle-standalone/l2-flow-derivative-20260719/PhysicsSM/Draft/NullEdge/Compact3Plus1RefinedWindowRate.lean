import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate

/-!
# Small-step-sensitive 3+1 continuum rate

Handoff target for Paper D. The existing compact-box constant contains
`exp(B4)`, which is unsuitable when the momentum cutoff grows with lattice
refinement. The underlying proof first obtains `exp(|eps| * B4)`. Preserve
that dependence through the one-step and telescoping estimates.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate

open scoped Matrix.Norms.L2Operator
open PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate

/-- Refined split-product remainder retaining the small-step exponent. -/
theorem splitStep_sub_lin_bound_refined (kx ky kz m eps : Real) :
    ‖splitStep kx ky kz m eps - (1 + ((-(eps : Complex) • ((Complex.I : Complex) • H kx ky kz m))))‖ ≤
      eps ^ 2 * B4 kx ky kz m ^ 2 * Real.exp (|eps| * B4 kx ky kz m) := by
  have h_step1 : ‖splitStep kx ky kz m eps - 1 - ((-(eps : Complex) • ((Complex.I : Complex) • H kx ky kz m)))‖ ≤
      Real.exp (|eps| * B4 kx ky kz m) - 1 - |eps| * B4 kx ky kz m := by
    have h_diff : ‖(factor (kx * eps) alpha1) * (factor (ky * eps) alpha2) *
        (factor (kz * eps) alpha3) * (factor (m * eps) beta) - 1 -
          ((-(eps : Complex)) • ((Complex.I : Complex) • H kx ky kz m))‖ ≤
          Real.exp (|kx * eps| + |ky * eps| + |kz * eps| + |m * eps|) - 1 -
            (|kx * eps| + |ky * eps| + |kz * eps| + |m * eps|) := by
      have h_trotter : ∀ (P : Mat4) (S : Mat4) (q : ℝ) (g : Mat4) (a : ℝ),
          ‖g‖ ≤ 1 → ‖S‖ ≤ a → ‖P - 1 - S‖ ≤ Real.exp a - 1 - a →
            ‖P * (factor (q) g) - 1 - (S + (-(q : Complex) • ((Complex.I : Complex) • g)))‖ ≤
              Real.exp (a + |q|) - 1 - (a + |q|) := by
        intro P S q g a hg hS hP
        have hF : ‖factor q g - 1 - (-(q : Complex) • ((Complex.I : Complex) • g))‖ ≤
            Real.exp |q| - 1 - |q| := by
          convert factor_sub_one_sub_gen_bound q g hg using 1
        have hF1 : ‖factor q g - 1‖ ≤ Real.exp |q| - 1 := by
          convert factor_sub_one_bound q g hg using 1
        have hF2 : ‖factor q g‖ ≤ Real.exp |q| := by
          have htmp := norm_add_le (factor q g - 1) 1
          norm_num at *
          linarith
        have hF3 : 0 ≤ a := by
          exact le_trans (norm_nonneg _) hS
        have hF4 : 0 ≤ |q| := by positivity
        exact trotter_step P S (factor q g) (-(q : Complex) • ((Complex.I : Complex) • g)) a |q|
          hF3 hF4 hS hP hF hF1 hF2
      let L : ℝ → Mat4 → Mat4 := fun q g => -(q : Complex) • (Complex.I • g)
      have h_accum : ∀ (q1 q2 q3 q4 : ℝ) (g1 g2 g3 g4 : Mat4),
          ‖g1‖ ≤ 1 → ‖g2‖ ≤ 1 → ‖g3‖ ≤ 1 → ‖g4‖ ≤ 1 →
          ‖factor q1 g1 * factor q2 g2 * factor q3 g3 * factor q4 g4 - 1 - (L q1 g1 + L q2 g2 + L q3 g3 + L q4 g4)‖ ≤
            Real.exp (|q1| + |q2| + |q3| + |q4|) - 1 - (|q1| + |q2| + |q3| + |q4|) := by
        intro q1 q2 q3 q4 g1 g2 g3 g4 hg1 hg2 hg3 hg4
        have hS1 : ‖L q1 g1‖ ≤ |q1| := by
          unfold L
          calc
            ‖-(q1 : Complex) • (Complex.I • g1)‖ ≤ ‖(q1 : Complex)‖ * ‖Complex.I • g1‖ := by
              simpa using norm_smul_le (-(q1 : Complex)) (Complex.I • g1)
            _ = ‖(q1 : Complex)‖ * ‖g1‖ := by simp [norm_smul]
            _ ≤ ‖(q1 : Complex)‖ * 1 := by
              exact mul_le_mul_of_nonneg_left hg1 (by positivity)
            _ = |q1| := by simp
        have hS2 : ‖L q2 g2‖ ≤ |q2| := by
          unfold L
          calc
            ‖-(q2 : Complex) • (Complex.I • g2)‖ ≤ ‖(q2 : Complex)‖ * ‖Complex.I • g2‖ := by
              simpa using norm_smul_le (-(q2 : Complex)) (Complex.I • g2)
            _ = ‖(q2 : Complex)‖ * ‖g2‖ := by simp [norm_smul]
            _ ≤ ‖(q2 : Complex)‖ * 1 := by
              exact mul_le_mul_of_nonneg_left hg2 (by positivity)
            _ = |q2| := by simp
        have hS3 : ‖L q3 g3‖ ≤ |q3| := by
          unfold L
          calc
            ‖-(q3 : Complex) • (Complex.I • g3)‖ ≤ ‖(q3 : Complex)‖ * ‖Complex.I • g3‖ := by
              simpa using norm_smul_le (-(q3 : Complex)) (Complex.I • g3)
            _ = ‖(q3 : Complex)‖ * ‖g3‖ := by simp [norm_smul]
            _ ≤ ‖(q3 : Complex)‖ * 1 := by
              exact mul_le_mul_of_nonneg_left hg3 (by positivity)
            _ = |q3| := by simp
        have hS4 : ‖L q4 g4‖ ≤ |q4| := by
          unfold L
          calc
            ‖-(q4 : Complex) • (Complex.I • g4)‖ ≤ ‖(q4 : Complex)‖ * ‖Complex.I • g4‖ := by
              simpa using norm_smul_le (-(q4 : Complex)) (Complex.I • g4)
            _ = ‖(q4 : Complex)‖ * ‖g4‖ := by simp [norm_smul]
            _ ≤ ‖(q4 : Complex)‖ * 1 := by
              exact mul_le_mul_of_nonneg_left hg4 (by positivity)
            _ = |q4| := by simp
        have h1 : ‖factor q1 g1 - 1 - L q1 g1‖ ≤ Real.exp |q1| - 1 - |q1| := by
          exact factor_sub_one_sub_gen_bound q1 g1 hg1
        have h2 : ‖factor q1 g1 * factor q2 g2 - 1 - (L q1 g1 + L q2 g2)‖ ≤
            Real.exp (|q1| + |q2|) - 1 - (|q1| + |q2|) := by
          simpa [L] using h_trotter (factor q1 g1) (L q1 g1) q2 g2 |q1| hg2 hS1 h1
        have hS12 : ‖L q1 g1 + L q2 g2‖ ≤ |q1| + |q2| := by
          linarith [norm_add_le (L q1 g1) (L q2 g2), hS1, hS2]
        have h3 : ‖factor q1 g1 * factor q2 g2 * factor q3 g3 - 1 - (L q1 g1 + L q2 g2 + L q3 g3)‖ ≤
            Real.exp (|q1| + |q2| + |q3|) - 1 - (|q1| + |q2| + |q3|) := by
          simpa [L, mul_add, add_assoc, add_left_comm, add_comm] using
            h_trotter (factor q1 g1 * factor q2 g2) (L q1 g1 + L q2 g2) q3 g3 (|q1| + |q2|) hg3 hS12 h2
        have hS123 : ‖L q1 g1 + L q2 g2 + L q3 g3‖ ≤ |q1| + |q2| + |q3| := by
          linarith [norm_add_le (L q1 g1 + L q2 g2) (L q3 g3), hS12, hS3]
        have h4 : ‖factor q1 g1 * factor q2 g2 * factor q3 g3 * factor q4 g4 - 1 - (L q1 g1 + L q2 g2 + L q3 g3 + L q4 g4)‖ ≤
            Real.exp (|q1| + |q2| + |q3| + |q4|) - 1 - (|q1| + |q2| + |q3| + |q4|) := by
          simpa [L, mul_add, add_assoc, add_left_comm, add_comm] using
            h_trotter (factor q1 g1 * factor q2 g2 * factor q3 g3)
              (L q1 g1 + L q2 g2 + L q3 g3) q4 g4 (|q1| + |q2| + |q3|) hg4 hS123 h3
        exact h4
      have h_accum_apply := h_accum (kx * eps) (ky * eps) (kz * eps) (m * eps)
          alpha1 alpha2 alpha3 beta
          generators_norm_le_one.1 generators_norm_le_one.2.1 generators_norm_le_one.2.2.1 generators_norm_le_one.2.2.2
      have h_accum_h4 : ‖splitStep kx ky kz m eps - 1 - (-(eps : Complex) • (Complex.I • H kx ky kz m))‖ ≤
          Real.exp (|kx * eps| + |ky * eps| + |kz * eps| + |m * eps|) - 1 - (|kx * eps| + |ky * eps| + |kz * eps| + |m * eps|) := by
        convert h_accum_apply using 2
        norm_num [generators_norm_le_one]
        ext i j
        simp [splitStep, H, L, sub_eq_add_neg, add_assoc, add_left_comm, add_comm, mul_assoc, mul_left_comm]
      have hmul :
          |eps| * B4 kx ky kz m = |kx * eps| + |ky * eps| + |kz * eps| + |m * eps| := by
        have hx1 : |kx * eps| = |kx| * |eps| := abs_mul kx eps
        have hx2 : |ky * eps| = |ky| * |eps| := abs_mul ky eps
        have hx3 : |kz * eps| = |kz| * |eps| := abs_mul kz eps
        have hx4 : |m * eps| = |m| * |eps| := abs_mul m eps
        dsimp [B4] at *
        nlinarith [hx1, hx2, hx3, hx4]
      simpa [hmul] using h_accum_h4
    have hmul :
        |eps| * B4 kx ky kz m = |kx * eps| + |ky * eps| + |kz * eps| + |m * eps| := by
      have hx1 : |kx * eps| = |kx| * |eps| := abs_mul kx eps
      have hx2 : |ky * eps| = |ky| * |eps| := abs_mul ky eps
      have hx3 : |kz * eps| = |kz| * |eps| := abs_mul kz eps
      have hx4 : |m * eps| = |m| * |eps| := abs_mul m eps
      dsimp [B4] at *
      nlinarith [hx1, hx2, hx3, hx4]
    simpa [hmul] using h_diff
  have h_exp_bound : Real.exp (|eps| * B4 kx ky kz m) - 1 - |eps| * B4 kx ky kz m ≤
      (|eps| * B4 kx ky kz m) ^ 2 * Real.exp (|eps| * B4 kx ky kz m) := by
    have hB4 : 0 ≤ B4 kx ky kz m := by
      unfold B4
      positivity
    exact exp_sub_one_sub_self_le_sq (mul_nonneg (abs_nonneg eps) hB4)
  have h_step2 : ‖splitStep kx ky kz m eps - 1 - (-(eps : Complex) • ((Complex.I : Complex) • H kx ky kz m))‖ ≤
      (|eps| * B4 kx ky kz m) ^ 2 * Real.exp (|eps| * B4 kx ky kz m) := h_step1.trans h_exp_bound
  simpa [sub_eq_add_neg, add_assoc, add_left_comm, add_comm, mul_pow, sq_abs] using h_step2

/-- Refined exact-flow remainder with the same small-step exponent. -/
theorem exactFlow_sub_lin_bound_refined (kx ky kz m eps : Real) :
    ‖exactFlow kx ky kz m eps - (1 + ((-(eps : Complex) • ((Complex.I : Complex) • H kx ky kz m))))‖ ≤
      eps ^ 2 * B4 kx ky kz m ^ 2 * Real.exp (|eps| * B4 kx ky kz m) := by
  set X : Mat4 := -(eps : Complex) • (Complex.I • H kx ky kz m)
  have h_exp : ‖NormedSpace.exp X - 1 - X‖ ≤ ‖X‖ ^ 2 * Real.exp ‖X‖ := by
    simpa [sub_eq_add_neg, add_assoc, add_left_comm, add_comm] using
      (norm_exp_sub_one_sub_self_le X)
  have hX_norm : ‖X‖ ≤ |eps| * B4 kx ky kz m := by
    calc
      ‖X‖ ≤ ‖(eps : Complex)‖ * ‖Complex.I • H kx ky kz m‖ := by
        simpa [X, norm_neg] using norm_smul_le (-(eps : Complex)) (Complex.I • H kx ky kz m)
      _ ≤ ‖(eps : Complex)‖ * (‖(Complex.I : Complex)‖ * ‖H kx ky kz m‖) := by
        gcongr
        exact norm_smul_le (Complex.I : Complex) (H kx ky kz m)
      _ = |eps| * ‖H kx ky kz m‖ := by
        simp
      _ ≤ |eps| * B4 kx ky kz m := by
        exact mul_le_mul_of_nonneg_left (norm_H_le_B4 kx ky kz m) (abs_nonneg eps)
  have hX_sq_le : ‖X‖ ^ 2 ≤ eps ^ 2 * B4 kx ky kz m ^ 2 := by
    have hsq : ‖X‖ ^ 2 ≤ (|eps| * B4 kx ky kz m) ^ 2 := by
      exact pow_le_pow_left₀ (norm_nonneg _) hX_norm 2
    nlinarith [hsq, sq_abs (eps), sq_abs (B4 kx ky kz m)]
  have h_bound : ‖NormedSpace.exp X - 1 - X‖ ≤
      eps ^ 2 * B4 kx ky kz m ^ 2 * Real.exp (|eps| * B4 kx ky kz m) := by
    have hExp : Real.exp ‖X‖ ≤ Real.exp (|eps| * B4 kx ky kz m) := Real.exp_le_exp.mpr hX_norm
    calc
      ‖NormedSpace.exp X - 1 - X‖ ≤ ‖X‖ ^ 2 * Real.exp ‖X‖ := h_exp
      _ ≤ (eps ^ 2 * B4 kx ky kz m ^ 2) * Real.exp (|eps| * B4 kx ky kz m) := by
        exact mul_le_mul hX_sq_le hExp (by positivity) (by positivity)
  simpa [X, exactFlow, sub_eq_add_neg, add_assoc, add_left_comm, add_comm] using h_bound

/-- Refined local Trotter estimate. -/
theorem one_step_to_exact_flow_bound_refined (kx ky kz m eps : Real) :
    ‖splitStep kx ky kz m eps - exactFlow kx ky kz m eps‖ ≤
      2 * eps ^ 2 * B4 kx ky kz m ^ 2 * Real.exp (|eps| * B4 kx ky kz m) := by
  let Y : Mat4 := 1 + ((-(eps : Complex) • ((Complex.I : Complex) • H kx ky kz m)))
  have hsplit : ‖splitStep kx ky kz m eps - Y‖ ≤
      eps ^ 2 * B4 kx ky kz m ^ 2 * Real.exp (|eps| * B4 kx ky kz m) :=
    by simpa [Y] using splitStep_sub_lin_bound_refined kx ky kz m eps
  have hexact : ‖exactFlow kx ky kz m eps - Y‖ ≤
      eps ^ 2 * B4 kx ky kz m ^ 2 * Real.exp (|eps| * B4 kx ky kz m) :=
    by simpa [Y] using exactFlow_sub_lin_bound_refined kx ky kz m eps
  have htrick : ‖splitStep kx ky kz m eps - exactFlow kx ky kz m eps‖ ≤ ‖splitStep kx ky kz m eps - Y‖ + ‖exactFlow kx ky kz m eps - Y‖ := by
    have htmp : splitStep kx ky kz m eps - exactFlow kx ky kz m eps =
        (splitStep kx ky kz m eps - Y) - (exactFlow kx ky kz m eps - Y) := by
      simp [Y, sub_eq_add_neg, add_assoc, add_left_comm, add_comm]
    rw [htmp]
    simpa [sub_eq_add_neg, add_assoc, add_left_comm, add_comm] using
      (norm_sub_le (splitStep kx ky kz m eps - Y) (exactFlow kx ky kz m eps - Y))
  nlinarith [htrick, hsplit, hexact]

/-- Refined many-step estimate suitable for a momentum window growing slower than the step count. -/
theorem fixed_time_many_step_bound_refined
    (kx ky kz m t : Real) (n : Nat) (hn : 0 < n) :
    ‖(splitStep kx ky kz m (t / (n : Real))) ^ n - exactFlow kx ky kz m t‖ ≤
      2 * B4 kx ky kz m ^ 2 * t ^ 2 / n *
        Real.exp (|t| * B4 kx ky kz m / n) := by
  rw [← exactFlow_div_pow kx ky kz m t n hn]
  refine le_trans (unitary_pow_telescope
      (splitStep_mem_unitary kx ky kz m (t / (n : Real)))
      (exactFlow_mem_unitary kx ky kz m (t / (n : Real))) n) ?_
  have hstep : ‖splitStep kx ky kz m (t / (n : Real)) - exactFlow kx ky kz m (t / (n : Real))‖ ≤
      2 * (t / (n : Real)) ^ 2 * B4 kx ky kz m ^ 2 * Real.exp (|t / (n : Real)| * B4 kx ky kz m) := by
    simpa using one_step_to_exact_flow_bound_refined kx ky kz m (t / (n : Real))
  have hMul : (n : ℝ) * (2 * (t / (n : ℝ)) ^ 2 * B4 kx ky kz m ^ 2 *
      Real.exp (|t / (n : ℝ)| * B4 kx ky kz m)) ≤
      2 * B4 kx ky kz m ^ 2 * t ^ 2 / (n : ℝ) * Real.exp (|t| * B4 kx ky kz m / (n : ℝ)) := by
    have hnR : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hn.ne'
    have hAbs : |t / (n : ℝ)| = |t| / (n : ℝ) := by
      rw [abs_div]
      have hnnonneg : (0 : ℝ) ≤ (n : ℝ) := by positivity
      simp [abs_of_nonneg hnnonneg]
    rw [hAbs]
    field_simp [hnR]
    ring_nf
    linarith
  exact (mul_le_mul_of_nonneg_left hstep (Nat.cast_nonneg n)).trans hMul

/-- info: 'PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate.splitStep_sub_lin_bound_refined' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms splitStep_sub_lin_bound_refined
/-- info: 'PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate.exactFlow_sub_lin_bound_refined' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlow_sub_lin_bound_refined
/-- info: 'PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate.one_step_to_exact_flow_bound_refined' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms one_step_to_exact_flow_bound_refined
/-- info: 'PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate.fixed_time_many_step_bound_refined' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixed_time_many_step_bound_refined

end PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate
