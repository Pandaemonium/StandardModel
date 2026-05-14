import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring
import PhysicsSM.Lie.Exceptional.E8

/-!
# Positive definiteness of the E8 Cartan / Gram matrix

This file provides a sorry-free proof that the E8 Cartan matrix, equivalently
the E8 root-lattice Gram matrix, is positive definite over `R`.

## Proof method

We use an explicit LDL^T certificate: the quadratic form `x^T G x` is
rewritten as a weighted sum of squares

```text
  Q(x) = 2*(x0 - x2/2)^2 + 2*(x1 - x3/2)^2
       + (3/2)*(x2 - 2*x3/3)^2 + (5/6)*(x3 - 6*x4/5)^2
       + (4/5)*(x4 - 5*x5/4)^2 + (3/4)*(x5 - 4*x6/3)^2
       + (2/3)*(x6 - 3*x7/2)^2 + (1/2)*x7^2.
```

All weights are positive rationals, so `Q(x) >= 0`. The linear forms are
related to `x` by an invertible upper-triangular change of variables, so
`Q(x) = 0` implies `x = 0`.
-/

set_option linter.style.longLine false

open PhysicsSM.Lie.Exceptional.E8

namespace PhysicsSM.Lie.Exceptional.E8PositiveDefinite

/-! ### Reduction-friendly real matrix

The `!!` matrix notation creates deeply nested `Matrix.cons` terms that are
expensive for `simp` to reduce. We define an equivalent real matrix using
`if`/`else` on `Fin 8` equalities, which `simp (config := { decide := true })`
can handle efficiently. -/

/-- The E8 Gram matrix as a real-valued function matrix, defined in a
reduction-friendly way using `if`/`else` instead of `!!` notation. -/
noncomputable def e8GramR : Matrix (Fin 8) (Fin 8) ℝ := fun i j =>
  if i = j then (2 : ℝ)
  else if (i = 0 ∧ j = 2) ∨ (i = 2 ∧ j = 0) ∨
          (i = 1 ∧ j = 3) ∨ (i = 3 ∧ j = 1) ∨
          (i = 2 ∧ j = 3) ∨ (i = 3 ∧ j = 2) ∨
          (i = 3 ∧ j = 4) ∨ (i = 4 ∧ j = 3) ∨
          (i = 4 ∧ j = 5) ∨ (i = 5 ∧ j = 4) ∨
          (i = 5 ∧ j = 6) ∨ (i = 6 ∧ j = 5) ∨
          (i = 6 ∧ j = 7) ∨ (i = 7 ∧ j = 6) then (-1 : ℝ)
  else (0 : ℝ)

/-- `e8GramR` equals the integer Cartan matrix cast to `R`. -/
theorem e8GramR_eq_map : e8GramR = (e8Cartan).map (Int.castRingHom ℝ) := by
  ext i j
  simp only [e8GramR, Matrix.map_apply]
  fin_cases i <;> fin_cases j <;> simp [e8Cartan]

/-! ### The sum-of-squares identity (LDL^T certificate) -/

set_option maxHeartbeats 800000 in
-- Reducing the 8 by 8 matrix entries and normalizing the quadratic-form
-- identity is finite but heartbeat-heavy.
/-- The quadratic form `sum i j, x i * G i j * x j` equals a weighted sum of
squares, derived from the LDL^T decomposition of the E8 Cartan matrix. -/
theorem e8_quadForm_eq_sumOfSquares (x : Fin 8 → ℝ) :
    ∑ i : Fin 8, ∑ j : Fin 8, x i * e8GramR i j * x j =
      2 * (x 0 - x 2 / 2) ^ 2
    + 2 * (x 1 - x 3 / 2) ^ 2
    + (3 : ℝ) / 2 * (x 2 - 2 * x 3 / 3) ^ 2
    + (5 : ℝ) / 6 * (x 3 - 6 * x 4 / 5) ^ 2
    + (4 : ℝ) / 5 * (x 4 - 5 * x 5 / 4) ^ 2
    + (3 : ℝ) / 4 * (x 5 - 4 * x 6 / 3) ^ 2
    + (2 : ℝ) / 3 * (x 6 - 3 * x 7 / 2) ^ 2
    + (1 : ℝ) / 2 * x 7 ^ 2 := by
  simp only [Fin.sum_univ_eight, e8GramR]
  simp (config := { decide := true }) only [ite_true, ite_false]
  ring

/-! ### Positivity from the sum-of-squares form -/

set_option maxHeartbeats 400000 in
-- The back-substitution chain gives `nlinarith` several nonnegative square
-- facts at once, so the local proof needs a larger heartbeat budget.
/-- If the sum-of-squares form is zero, then `x = 0`.

The proof uses back-substitution: the linear forms are upper-triangular
(`x7` appears alone, `x6` in terms of `x7`, etc.), so we can solve from the
bottom up. -/
theorem e8_sumOfSquares_eq_zero_imp (x : Fin 8 → ℝ)
    (h : 2 * (x 0 - x 2 / 2) ^ 2
       + 2 * (x 1 - x 3 / 2) ^ 2
       + (3 : ℝ) / 2 * (x 2 - 2 * x 3 / 3) ^ 2
       + (5 : ℝ) / 6 * (x 3 - 6 * x 4 / 5) ^ 2
       + (4 : ℝ) / 5 * (x 4 - 5 * x 5 / 4) ^ 2
       + (3 : ℝ) / 4 * (x 5 - 4 * x 6 / 3) ^ 2
       + (2 : ℝ) / 3 * (x 6 - 3 * x 7 / 2) ^ 2
       + (1 : ℝ) / 2 * x 7 ^ 2 = 0) :
    x = 0 := by
  have sq0 := sq_nonneg (x 0 - x 2 / 2)
  have sq1 := sq_nonneg (x 1 - x 3 / 2)
  have sq2 := sq_nonneg (x 2 - 2 * x 3 / 3)
  have sq3 := sq_nonneg (x 3 - 6 * x 4 / 5)
  have sq4 := sq_nonneg (x 4 - 5 * x 5 / 4)
  have sq5 := sq_nonneg (x 5 - 4 * x 6 / 3)
  have sq6 := sq_nonneg (x 6 - 3 * x 7 / 2)
  have sq7 := sq_nonneg (x 7)
  have h7 : x 7 = 0 := by nlinarith
  have h6 : x 6 = 0 := by nlinarith
  have h5 : x 5 = 0 := by nlinarith
  have h4 : x 4 = 0 := by nlinarith
  have h3 : x 3 = 0 := by nlinarith
  have h2 : x 2 = 0 := by nlinarith
  have h1 : x 1 = 0 := by nlinarith
  have h0 : x 0 = 0 := by nlinarith
  ext i
  fin_cases i <;> assumption

/-- The quadratic form is strictly positive for nonzero `x`. -/
theorem e8_quadForm_pos (x : Fin 8 → ℝ) (hx : x ≠ 0) :
    0 < ∑ i : Fin 8, ∑ j : Fin 8, x i * e8GramR i j * x j := by
  rw [e8_quadForm_eq_sumOfSquares]
  by_contra hle
  push_neg at hle
  have hge : 0 ≤ 2 * (x 0 - x 2 / 2) ^ 2 + 2 * (x 1 - x 3 / 2) ^ 2 +
    (3 : ℝ) / 2 * (x 2 - 2 * x 3 / 3) ^ 2 + (5 : ℝ) / 6 * (x 3 - 6 * x 4 / 5) ^ 2 +
    (4 : ℝ) / 5 * (x 4 - 5 * x 5 / 4) ^ 2 + (3 : ℝ) / 4 * (x 5 - 4 * x 6 / 3) ^ 2 +
    (2 : ℝ) / 3 * (x 6 - 3 * x 7 / 2) ^ 2 + (1 : ℝ) / 2 * x 7 ^ 2 := by
      positivity
  exact hx (e8_sumOfSquares_eq_zero_imp x (le_antisymm hle hge))

/-! ### Converting Finsupp sums to regular sums -/

/-- Conversion lemma: the Finsupp double sum equals the regular double sum
over `Fin 8`. -/
theorem finsupp_bilin_eq_sum (M : Matrix (Fin 8) (Fin 8) ℝ) (x : Fin 8 →₀ ℝ) :
    (x.sum fun i xi => x.sum fun j xj => star xi * M i j * xj) =
    ∑ i, ∑ j, x i * M i j * x j := by
  rw [Finsupp.sum_fintype]
  · congr 1
    ext i
    rw [Finsupp.sum_fintype]
    · simp [star_trivial]
    · intro j
      ring
  · intro i
    rw [Finsupp.sum_fintype]
    · simp
    · intro j
      ring

/-! ### Main theorem: e8GramR is positive definite -/

/-- `e8GramR` is Hermitian. -/
theorem e8GramR_isHermitian : e8GramR.IsHermitian := by
  ext i j
  simp only [Matrix.conjTranspose, Matrix.transpose, Matrix.map_apply, star_trivial, e8GramR]
  fin_cases i <;> fin_cases j <;> simp

/-- The E8 Gram/Cartan matrix, cast to `R`, is positive definite in the sense
of `Matrix.PosDef`. -/
theorem e8GramR_posDef : e8GramR.PosDef := by
  refine ⟨e8GramR_isHermitian, fun x hx => ?_⟩
  rw [finsupp_bilin_eq_sum]
  exact e8_quadForm_pos (fun i => x i) (by
    intro hf
    apply hx
    ext i
    have := congr_fun hf i
    simp only [Pi.zero_apply] at this
    exact this)

/-- The original `e8Cartan` mapped to `R` is positive definite. -/
theorem e8Cartan_map_posDef : ((e8Cartan).map (Int.castRingHom ℝ)).PosDef := by
  rw [← e8GramR_eq_map]
  exact e8GramR_posDef

end PhysicsSM.Lie.Exceptional.E8PositiveDefinite
