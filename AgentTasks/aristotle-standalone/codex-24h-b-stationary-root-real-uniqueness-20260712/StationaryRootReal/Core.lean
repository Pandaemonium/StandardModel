import Mathlib

/-!
# Target: exact real-root census of the stationary-Weyl elimination factors

Preserve every statement.  This is pure real polynomial algebra.  A convenient
proof of the left-tail theorem uses degree-five Bernstein expansions on
`[0,3/4]`, `[3/4,5/4]`, and `[5/4,149/100]`; every coefficient is negative.
For `t >= 3/2`, expand around `3/2`, where every coefficient is positive.
On `[149/100,3/2]`, the shifted divided difference has positive coefficients.
-/

noncomputable section

open Set

namespace StationaryRootReal

def rootPoly (t : ℝ) : ℝ :=
  480 * t ^ 5 - 575 * t ^ 4 - 1026 * t ^ 2 + 1440 * t - 575

def excludedPoly (t : ℝ) : ℝ :=
  16384 * t ^ 6 + 11040 * t ^ 5 + 56375 * t ^ 4 +
    48000 * t ^ 3 + 44050 * t ^ 2 + 19680 * t + 5175

theorem rootPoly_at_lower : rootPoly (149 / 100) < 0 := by
  sorry

theorem rootPoly_at_upper : 0 < rootPoly (3 / 2) := by
  sorry

/-- The elimination quintic is negative throughout the entire left region. -/
theorem rootPoly_neg_of_le_lower {t : ℝ} (ht : t ≤ 149 / 100) :
    rootPoly t < 0 := by
  sorry

/-- The elimination quintic is positive throughout the entire right region. -/
theorem rootPoly_pos_of_upper_le {t : ℝ} (ht : 3 / 2 ≤ t) :
    0 < rootPoly t := by
  sorry

/-- The quintic is strictly increasing on its rational root-isolating window. -/
theorem rootPoly_strictMonoOn_window :
    StrictMonoOn rootPoly (Icc (149 / 100) (3 / 2)) := by
  sorry

/-- The quintic has exactly one real root globally. -/
theorem rootPoly_existsUnique_real :
    ∃! t : ℝ, rootPoly t = 0 := by
  sorry

/-- The sextic elimination branch has no real point. -/
theorem excludedPoly_pos (t : ℝ) : 0 < excludedPoly t := by
  sorry

/-- Real elimination leaves only the `t=0` branch and the unique quintic
branch; the sextic factor contributes no real roots. -/
theorem real_elimination_factor_iff (t : ℝ) :
    t * rootPoly t * excludedPoly t = 0 ↔ t = 0 ∨ rootPoly t = 0 := by
  sorry

end StationaryRootReal
