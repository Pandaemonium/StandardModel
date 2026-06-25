import Mathlib

/-!
# NullStrand.ZigZag.EntropicTraffic

Finite algebraic identities used in the entropic traffic toy layer.
-/

noncomputable section

namespace PhysicsSM.NullStrand.ZigZag

/-- Entropic optimal positive branch. -/
def entropicTraffic_plus (J : ℝ) (s0 : ℝ) : ℝ :=
  (J + Real.sqrt (J ^ 2 + 4 * s0 ^ 2)) / 2

/-- Entropic optimal negative branch. -/
def entropicTraffic_minus (J : ℝ) (s0 : ℝ) : ℝ :=
  (-J + Real.sqrt (J ^ 2 + 4 * s0 ^ 2)) / 2

/-- Sum of branches is the positive discriminant term. -/
theorem entropicTraffic_sum (J : ℝ) (s0 : ℝ) :
    entropicTraffic_plus J s0 + entropicTraffic_minus J s0 = Real.sqrt (J ^ 2 + 4 * s0 ^ 2) := by
  unfold entropicTraffic_plus entropicTraffic_minus
  ring

/-- Difference of branches is the prescribed signed flux `J`. -/
theorem entropicTraffic_diff (J : ℝ) (s0 : ℝ) :
    entropicTraffic_plus J s0 - entropicTraffic_minus J s0 = J := by
  unfold entropicTraffic_plus entropicTraffic_minus
  ring

/-- Their product reproduces the squared reference scale. -/
theorem entropicTraffic_product_eq_referenceSq (J : ℝ) (s0 : ℝ) :
    entropicTraffic_plus J s0 * entropicTraffic_minus J s0 = s0 ^ 2 := by
  unfold entropicTraffic_plus entropicTraffic_minus
  set s := Real.sqrt (J ^ 2 + 4 * s0 ^ 2)
  have hs : s ^ 2 = J ^ 2 + 4 * s0 ^ 2 := by
    dsimp [s]
    exact Real.sq_sqrt (by positivity)
  nlinarith [hs]

/-- A useful nonnegativity fact used by optimization layers. -/
theorem entropicTraffic_plus_nonneg (J : ℝ) (s0 : ℝ) : 0 ≤ entropicTraffic_plus J s0 := by
  unfold entropicTraffic_plus
  have hsq : J ^ 2 ≤ J ^ 2 + 4 * s0 ^ 2 := by
    nlinarith [sq_nonneg s0]
  have hAbs : |J| ≤ Real.sqrt (J ^ 2 + 4 * s0 ^ 2) := by
    calc
      |J| = Real.sqrt (J ^ 2) := by simpa using (Real.sqrt_sq_eq_abs J).symm
      _ ≤ Real.sqrt (J ^ 2 + 4 * s0 ^ 2) := Real.sqrt_le_sqrt hsq
  have hnum : 0 ≤ J + Real.sqrt (J ^ 2 + 4 * s0 ^ 2) := by
    nlinarith [neg_abs_le J, hAbs]
  exact div_nonneg hnum (show (0 : ℝ) ≤ 2 by norm_num)

/-- A useful nonnegativity fact used by optimization layers. -/
theorem entropicTraffic_minus_nonneg (J : ℝ) (s0 : ℝ) : 0 ≤ entropicTraffic_minus J s0 := by
  unfold entropicTraffic_minus
  have hsq : J ^ 2 ≤ J ^ 2 + 4 * s0 ^ 2 := by
    nlinarith [sq_nonneg s0]
  have hAbs : |J| ≤ Real.sqrt (J ^ 2 + 4 * s0 ^ 2) := by
    calc
      |J| = Real.sqrt (J ^ 2) := by simpa using (Real.sqrt_sq_eq_abs J).symm
      _ ≤ Real.sqrt (J ^ 2 + 4 * s0 ^ 2) := Real.sqrt_le_sqrt hsq
  have hnum : 0 ≤ -J + Real.sqrt (J ^ 2 + 4 * s0 ^ 2) := by
    nlinarith [le_abs_self J, hAbs]
  exact div_nonneg hnum (show (0 : ℝ) ≤ 2 by norm_num)

end PhysicsSM.NullStrand.ZigZag
