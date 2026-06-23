import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Log.Basic

/-!
# P7 qubit entropy bound

The binary (von Neumann) entropy of a qubit eigenvalue distribution is bounded by
`log 2`, attained at the maximally mixed state. This is the finite entropy bound
underlying the observer-channel / mixedness side of the P7 relative-entropy
program: an observer's coarse-grained qubit cannot be more uncertain than the
maximally mixed reference.

```text
H(x) = -x log x - (1-x) log(1-x) <= log 2   for x in [0,1].
```

Standalone (Mathlib only), with the `Real.log 0 = 0` convention.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7BinaryEntropyBound

/-- Binary entropy. -/
def binEntropy (x : Real) : Real := -x * Real.log x - (1 - x) * Real.log (1 - x)

/-
The binary entropy is bounded by `log 2`.
-/
theorem binEntropy_le_log2 (x : Real) (h0 : 0 ≤ x) (h1 : x ≤ 1) :
    binEntropy x ≤ Real.log 2 := by
  by_cases hx : x = 0 ∨ x = 1
  · rcases hx with rfl | rfl <;> unfold binEntropy <;> norm_num
    all_goals positivity
  · -- Main case: `0 < x` and `0 < 1 - x`.
    have hx0 : 0 < x := lt_of_le_of_ne h0 (Ne.symm (by tauto))
    have hx1 : 0 < 1 - x := sub_pos.mpr (lt_of_le_of_ne h1 (by tauto))
    -- Tangent-line inequality `log t ≤ t - 1` at `t = 1/(2x)` and `t = 1/(2(1-x))`.
    have ht0 : Real.log (1 / (2 * x)) ≤ 1 / (2 * x) - 1 :=
      Real.log_le_sub_one_of_pos (one_div_pos.mpr (by positivity))
    have ht1 : Real.log (1 / (2 * (1 - x))) ≤ 1 / (2 * (1 - x)) - 1 :=
      Real.log_le_sub_one_of_pos (one_div_pos.mpr (by positivity))
    rw [one_div, Real.log_inv, Real.log_mul (by norm_num) hx0.ne'] at ht0
    rw [one_div, Real.log_inv, Real.log_mul (by norm_num) hx1.ne'] at ht1
    -- Multiply each tangent bound by the corresponding positive weight.
    have e0 : x * (2 * x)⁻¹ = 1 / 2 := by field_simp
    have e1 : (1 - x) * (2 * (1 - x))⁻¹ = 1 / 2 := by field_simp
    have h0' := mul_le_mul_of_nonneg_left ht0 hx0.le
    have h1' := mul_le_mul_of_nonneg_left ht1 hx1.le
    rw [mul_sub, mul_one, e0] at h0'
    rw [mul_sub, mul_one, e1] at h1'
    unfold binEntropy
    nlinarith [Real.log_pos one_lt_two, h0', h1']

/-
The maximally mixed qubit attains entropy `log 2`.
-/
theorem binEntropy_half : binEntropy (1 / 2) = Real.log 2 := by
  unfold binEntropy
  rw [show (1 : Real) - 1 / 2 = 1 / 2 by norm_num, Real.log_div one_ne_zero two_ne_zero,
    Real.log_one]
  ring

end PhysicsSM.Draft.NullEdgeP7BinaryEntropyBound
