import Mathlib

/-!
# Exact one-loop dimensional-transmutation algebra

Starting from a supplied asymptotically-free one-loop running law, this module
proves positivity on the physical branch, the exact inverse-coupling cocycle,
and reconstruction of an RG-invariant dimensionful scale. The explicit
`b = 1/2`, `Lambda = 1`, `mu = exp 1` fixture is nondegenerate.

The beta function and its coefficient are inputs. This module does not identify
the running coupling with QCD, derive the law from null information, or predict
a measured energy scale.

Provenance: clean-room formalization of the standard one-loop
dimensional-transmutation algebra. Proofs were completed by Aristotle project
`3ea09edf-0206-4b6c-94b5-d3e618ba8ec2` and locally rechecked under the pinned
toolchain.
-/

namespace PhysicsSM.Draft.NullEdge.OneLoopDimensionalTransmutation

/-- Inverse squared coupling for the one-loop asymptotically-free branch. -/
noncomputable def runningInv (b Lambda mu : ℝ) : ℝ :=
  2 * b * Real.log (mu / Lambda)

/-- Squared running coupling. -/
noncomputable def runningGSq (b Lambda mu : ℝ) : ℝ :=
  1 / runningInv b Lambda mu

/-- RG-invariant scale reconstructed from a scale and squared coupling. -/
noncomputable def dynScale (b mu gSq : ℝ) : ℝ :=
  mu * Real.exp (-1 / (2 * b * gSq))

/-- The inverse coupling is positive above a positive reference scale. -/
theorem runningInv_pos {b Lambda mu : ℝ}
    (hb : 0 < b) (hL : 0 < Lambda) (hmu : Lambda < mu) :
    0 < runningInv b Lambda mu := by
  unfold runningInv
  have hlog : 0 < Real.log (mu / Lambda) :=
    Real.log_pos ((one_lt_div hL).mpr hmu)
  positivity

/-- The running squared coupling is positive on the same branch. -/
theorem runningGSq_pos {b Lambda mu : ℝ}
    (hb : 0 < b) (hL : 0 < Lambda) (hmu : Lambda < mu) :
    0 < runningGSq b Lambda mu := by
  unfold runningGSq
  exact div_pos one_pos (runningInv_pos hb hL hmu)

/-- Reconstructing the invariant scale from the supplied running coupling
returns exactly `Lambda`. -/
theorem dynScale_running {b Lambda mu : ℝ}
    (hb : 0 < b) (hL : 0 < Lambda) (hmu : Lambda < mu) :
    dynScale b mu (runningGSq b Lambda mu) = Lambda := by
  have hlog : 0 < Real.log (mu / Lambda) :=
    Real.log_pos ((one_lt_div hL).mpr hmu)
  have hb' : b ≠ 0 := ne_of_gt hb
  have hlog' : Real.log (mu / Lambda) ≠ 0 := ne_of_gt hlog
  unfold dynScale runningGSq runningInv
  have hstep : -1 / (2 * b * (1 / (2 * b * Real.log (mu / Lambda)))) =
      Real.log (Lambda / mu) := by
    rw [Real.log_div (ne_of_gt hL) (ne_of_gt (lt_trans hL hmu))]
    rw [Real.log_div (ne_of_gt (lt_trans hL hmu)) (ne_of_gt hL)]
    field_simp
    ring
  rw [hstep, Real.exp_log (div_pos hL (lt_trans hL hmu)), mul_comm,
      div_mul_cancel₀ _ (ne_of_gt (lt_trans hL hmu))]

/-- Exact one-loop RG cocycle for the inverse coupling. -/
theorem runningInv_cocycle {b Lambda mu1 mu2 : ℝ}
    (hL : 0 < Lambda) (h1 : 0 < mu1) (h2 : 0 < mu2) :
    runningInv b Lambda mu2 =
      runningInv b Lambda mu1 + 2 * b * Real.log (mu2 / mu1) := by
  unfold runningInv
  rw [Real.log_div (ne_of_gt h2) (ne_of_gt hL),
      Real.log_div (ne_of_gt h1) (ne_of_gt hL),
      Real.log_div (ne_of_gt h2) (ne_of_gt h1)]
  ring

/-- The nondegenerate witness `b=1/2`, `Lambda=1`, `mu=e` gives `g^2=1` and
reconstructs unit dynamical scale. -/
theorem exponential_witness :
    runningGSq (1 / 2) 1 (Real.exp 1) = 1 ∧
      dynScale (1 / 2) (Real.exp 1) 1 = 1 := by
  constructor
  · unfold runningGSq runningInv
    rw [div_one, Real.log_exp]
    norm_num
  · unfold dynScale
    norm_num
    rw [← Real.exp_add]
    norm_num

end PhysicsSM.Draft.NullEdge.OneLoopDimensionalTransmutation
