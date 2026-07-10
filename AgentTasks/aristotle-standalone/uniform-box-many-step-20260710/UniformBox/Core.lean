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
  have hk2 : k ^ 2 ≤ K ^ 2 := by
    rw [← sq_abs k]
    exact (sq_le_sq₀ (abs_nonneg k) hK).2 hk
  have hm2 : m ^ 2 ≤ M ^ 2 := by
    rw [← sq_abs m]
    exact (sq_le_sq₀ (abs_nonneg m) hM).2 hm
  have hkm2 : |k| * m ^ 2 ≤ K * M ^ 2 :=
    mul_le_mul hk hm2 (sq_nonneg m) hK
  have hk2m : k ^ 2 * |m| ≤ K ^ 2 * M :=
    mul_le_mul hk2 hm (abs_nonneg m) (sq_nonneg K)
  have hkm : |k| * |m| ≤ K * M :=
    mul_le_mul hk hm (abs_nonneg m) hK
  have hC : Ckm k m ≤ Cbox K M := by
    unfold Ckm Cbox
    nlinarith
  have hsum : |k| + |m| ≤ K + M := add_le_add hk hm
  have hsq : (|k| + |m|) ^ 2 ≤ (K + M) ^ 2 :=
    pow_le_pow_left₀ (by positivity) hsum 2
  have hexp : Real.exp (|k| + |m|) ≤ Real.exp (K + M) :=
    Real.exp_le_exp.mpr hsum
  have hprod :
      (|k| + |m|) ^ 2 * Real.exp (|k| + |m|) ≤
        (K + M) ^ 2 * Real.exp (K + M) :=
    mul_le_mul hsq hexp (Real.exp_nonneg _) (sq_nonneg _)
  unfold Dkm Dbox
  nlinarith

theorem uniform_error_bound (err k m K M t : ℝ) (n : ℕ) (hn : 0 < n)
    (hK : 0 ≤ K) (hM : 0 ≤ M) (hk : |k| ≤ K) (hm : |m| ≤ M)
    (hpoint : err ≤ Dkm k m * t ^ 2 / n) :
    err ≤ Dbox K M * t ^ 2 / n := by
  have hD := Dkm_le_Dbox k m K M hK hM hk hm
  have hfactor : 0 ≤ t ^ 2 / (n : ℝ) :=
    div_nonneg (sq_nonneg t) (Nat.cast_nonneg n)
  calc
    err ≤ Dkm k m * t ^ 2 / n := hpoint
    _ = Dkm k m * (t ^ 2 / n) := by ring
    _ ≤ Dbox K M * (t ^ 2 / n) :=
      mul_le_mul_of_nonneg_right hD hfactor
    _ = Dbox K M * t ^ 2 / n := by ring

theorem rational_box_witness :
    Dkm (3 / 5) (4 / 5) ≤ Dbox 1 1 ∧ Dbox 1 1 > 0 := by
  constructor
  · apply Dkm_le_Dbox <;> norm_num
  · unfold Dbox Cbox
    positivity

end UniformBox
