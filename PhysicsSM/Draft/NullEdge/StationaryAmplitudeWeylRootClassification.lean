import Mathlib

/-!
# Exact real-root classification for stationary-Weyl elimination factors

This module proves an exact real census for the two nontrivial polynomial
factors produced by the tangent-coordinate elimination oracle for the
stationary-amplitude Weyl walk. The quintic has exactly one real root, isolated
in `[149/100, 3/2]`; the companion sextic is strictly positive on all of `Real`.
Consequently the displayed product has only the `t = 0` branch and one quintic
branch over the reals.

The polynomial proofs are kernel checked. The prior derivation of these
factors from the full matrix stationary equations remains an external exact-CAS
oracle until the elimination identity itself is formalized. This module also
does not cover tangent-chart boundary points with phase `-1`.

Provenance: statements prepared from the exact SymPy elimination recorded in
`Scripts/oracle/analyze_stationary_amplitude_weyl.py`. Proofs returned without
statement changes by Aristotle project `ba38840e-6ab1-4a5a-acaa-8a47dcb12a15`,
task `58784513-73a6-4969-a86c-962210601dfd`, then independently rebuilt under
the repository's pinned Lean 4.28.0 toolchain.
-/

noncomputable section

open Set

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylRootClassification

/-- The real quintic branch in the stationary-Weyl tangent elimination. -/
def rootPoly (t : ℝ) : ℝ :=
  480 * t ^ 5 - 575 * t ^ 4 - 1026 * t ^ 2 + 1440 * t - 575

/-- The companion sextic branch, proved below to have no real zero. -/
def excludedPoly (t : ℝ) : ℝ :=
  16384 * t ^ 6 + 11040 * t ^ 5 + 56375 * t ^ 4 +
    48000 * t ^ 3 + 44050 * t ^ 2 + 19680 * t + 5175

theorem rootPoly_at_lower : rootPoly (149 / 100) < 0 := by
  unfold rootPoly
  norm_num

theorem rootPoly_at_upper : 0 < rootPoly (3 / 2) := by
  unfold rootPoly
  norm_num

/-- The elimination quintic is negative throughout the entire left region. -/
theorem rootPoly_neg_of_le_lower {t : ℝ} (ht : t ≤ 149 / 100) :
    rootPoly t < 0 := by
  unfold rootPoly
  rcases le_or_gt t 0 with h0 | h0
  · nlinarith [sq_nonneg t, mul_nonneg (neg_nonneg.2 h0) (sq_nonneg t), h0,
      sq_nonneg (t ^ 2),
      mul_nonneg (mul_nonneg (neg_nonneg.2 h0) (sq_nonneg t)) (sq_nonneg t)]
  · have h0' : (0 : ℝ) ≤ t := le_of_lt h0
    have hu : (0 : ℝ) ≤ 149 / 100 - t := by linarith
    nlinarith [mul_nonneg h0' hu, sq_nonneg (t - 1), sq_nonneg (t - 149 / 100),
      mul_nonneg (mul_nonneg h0' h0') hu,
      mul_nonneg (mul_nonneg (mul_nonneg h0' h0') h0') hu,
      mul_nonneg (mul_nonneg (mul_nonneg (mul_nonneg h0' h0') h0') h0') hu]

/-- The elimination quintic is positive throughout the entire right region. -/
theorem rootPoly_pos_of_upper_le {t : ℝ} (ht : 3 / 2 ≤ t) :
    0 < rootPoly t := by
  unfold rootPoly
  have htpos : (0 : ℝ) < t := by linarith
  nlinarith [sq_nonneg (t - 3 / 2), sq_nonneg t, pow_pos htpos 3, pow_pos htpos 5,
    sq_nonneg (t - 1), ht, mul_pos htpos htpos]

/-- The quintic is strictly increasing on its rational root-isolating window. -/
theorem rootPoly_strictMonoOn_window :
    StrictMonoOn rootPoly (Icc (149 / 100) (3 / 2)) := by
  intro x hx y hy hxy
  simp only [mem_Icc] at hx hy
  obtain ⟨hx1, hx2⟩ := hx
  obtain ⟨hy1, hy2⟩ := hy
  have ax : (0 : ℝ) ≤ x - 149 / 100 := by linarith
  have ay : (0 : ℝ) ≤ y - 149 / 100 := by linarith
  have bx : (0 : ℝ) ≤ 3 / 2 - x := by linarith
  have by' : (0 : ℝ) ≤ 3 / 2 - y := by linarith
  have hbracket : (0 : ℝ) <
      480 * (y ^ 4 + y ^ 3 * x + y ^ 2 * x ^ 2 + y * x ^ 3 + x ^ 4)
        - 575 * (y ^ 3 + y ^ 2 * x + y * x ^ 2 + x ^ 3) - 1026 * (y + x) + 1440 := by
    nlinarith [mul_nonneg ax ay, mul_nonneg ax bx, mul_nonneg ay by',
      mul_nonneg bx by', mul_nonneg ax by', mul_nonneg ay bx,
      mul_nonneg (mul_nonneg ax ax) ay, mul_nonneg (mul_nonneg ay ay) ax,
      sq_nonneg (x - y), hx1, hy1,
      mul_nonneg ax (le_of_lt (by linarith : (0 : ℝ) < x)),
      mul_nonneg ay (le_of_lt (by linarith : (0 : ℝ) < y))]
  unfold rootPoly
  nlinarith [mul_pos (by linarith : (0 : ℝ) < y - x) hbracket]

/-- The quintic has exactly one real root globally. -/
theorem rootPoly_existsUnique_real :
    ∃! t : ℝ, rootPoly t = 0 := by
  have hcont : ContinuousOn rootPoly (Icc (149 / 100) (3 / 2)) := by
    unfold rootPoly
    fun_prop
  have hlo : rootPoly (149 / 100) < 0 := rootPoly_neg_of_le_lower (by norm_num)
  have hhi : 0 < rootPoly (3 / 2) := rootPoly_pos_of_upper_le (by norm_num)
  have hmem : (0 : ℝ) ∈ Icc (rootPoly (149 / 100)) (rootPoly (3 / 2)) := by
    constructor <;> [linarith; linarith]
  have hivt := intermediate_value_Icc
    (by norm_num : (149 : ℝ) / 100 ≤ 3 / 2) hcont hmem
  obtain ⟨c, hcmem, hc0⟩ := hivt
  refine ⟨c, hc0, ?_⟩
  intro d hd
  have hdwin : d ∈ Icc (149 / 100 : ℝ) (3 / 2) := by
    rw [mem_Icc]
    refine ⟨?_, ?_⟩
    · by_contra h
      push_neg at h
      have hneg := rootPoly_neg_of_le_lower (le_of_lt h)
      rw [hd] at hneg
      linarith
    · by_contra h
      push_neg at h
      have hpos := rootPoly_pos_of_upper_le (le_of_lt h)
      rw [hd] at hpos
      linarith
  exact rootPoly_strictMonoOn_window.injOn hdwin hcmem (by rw [hd, hc0])

/-- The sextic elimination branch has no real point. -/
theorem excludedPoly_pos (t : ℝ) : 0 < excludedPoly t := by
  unfold excludedPoly
  nlinarith [sq_nonneg (t ^ 3), sq_nonneg (t ^ 2), sq_nonneg t,
    sq_nonneg (t ^ 3 + t ^ 2), sq_nonneg (t ^ 2 + t), sq_nonneg (t + 1),
    sq_nonneg (t ^ 3 + t), sq_nonneg (128 * t ^ 3 + 43 * t ^ 2),
    sq_nonneg (t ^ 3 + 3 * t ^ 2), sq_nonneg (t ^ 2 + 2 * t),
    sq_nonneg (t ^ 3 + 2 * t ^ 2), sq_nonneg (t ^ 2 + 3 * t)]

/-- Real elimination leaves only the `t = 0` branch and the unique quintic
branch; the sextic factor contributes no real roots. -/
theorem real_elimination_factor_iff (t : ℝ) :
    t * rootPoly t * excludedPoly t = 0 ↔ t = 0 ∨ rootPoly t = 0 := by
  have hne : excludedPoly t ≠ 0 := ne_of_gt (excludedPoly_pos t)
  rw [mul_eq_zero, mul_eq_zero, or_iff_left hne]

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylRootClassification.rootPoly_existsUnique_real' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rootPoly_existsUnique_real

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylRootClassification.excludedPoly_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms excludedPoly_pos

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylRootClassification.real_elimination_factor_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms real_elimination_factor_iff

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylRootClassification
