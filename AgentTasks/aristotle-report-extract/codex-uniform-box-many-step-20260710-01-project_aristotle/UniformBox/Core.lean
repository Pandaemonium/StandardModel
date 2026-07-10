import Mathlib

namespace UniformBox

def Ckm (k m : ℝ) : ℝ :=
  2 * k ^ 2 + 2 * m ^ 2 + |k| * m ^ 2 + k ^ 2 * |m| + |k| * |m|

noncomputable def Dkm (k m : ℝ) : ℝ :=
  4 * Ckm k m + 4 * (|k| + |m|) ^ 2 * Real.exp (|k| + |m|)

def Cbox (K M : ℝ) : ℝ :=
  2 * K ^ 2 + 2 * M ^ 2 + K * M ^ 2 + K ^ 2 * M + K * M

noncomputable def Dbox (K M : ℝ) : ℝ :=
  4 * Cbox K M + 4 * (K + M) ^ 2 * Real.exp (K + M)

theorem Dkm_le_Dbox (k m K M : ℝ) (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hk : |k| ≤ K) (hm : |m| ≤ M) :
    Dkm k m ≤ Dbox K M := by
  refine add_le_add ?_ ?_
  · refine mul_le_mul_of_nonneg_left ?_ zero_le_four
    refine add_le_add (add_le_add (add_le_add (add_le_add ?_ ?_) ?_) ?_) ?_
    · nlinarith only [abs_le.mp hk]
    · nlinarith [abs_le.mp hm]
    · exact mul_le_mul hk (by nlinarith [abs_le.mp hm]) (by positivity) (by positivity)
    · exact mul_le_mul (by nlinarith [abs_le.mp hk]) hm (by positivity) (by positivity)
    · gcongr
  · gcongr

theorem uniform_error_bound (err k m K M t : ℝ) (n : ℕ) (hn : 0 < n)
    (hK : 0 ≤ K) (hM : 0 ≤ M) (hk : |k| ≤ K) (hm : |m| ≤ M)
    (hpoint : err ≤ Dkm k m * t ^ 2 / n) :
    err ≤ Dbox K M * t ^ 2 / n := by
  exact hpoint.trans (by gcongr; exact Dkm_le_Dbox _ _ _ _ hK hM hk hm)

theorem rational_box_witness :
    Dkm (3 / 5) (4 / 5) ≤ Dbox 1 1 ∧ Dbox 1 1 > 0 := by
  refine ⟨?_, ?_⟩
  · convert Dkm_le_Dbox _ _ _ _ _ _ _ _ using 1 <;> norm_num [abs_of_pos]
  · have hexp : (0 : ℝ) ≤ 4 * (1 + 1) ^ 2 * Real.exp (1 + 1) :=
      mul_nonneg (by norm_num) (Real.exp_nonneg _)
    have hc : (0 : ℝ) < 4 * Cbox 1 1 := mul_pos zero_lt_four (by norm_num [Cbox])
    exact add_pos_of_pos_of_nonneg hc hexp

end UniformBox
