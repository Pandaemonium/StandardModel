import Mathlib

/-!
# Johnston four-dimensional light-cone delta sequence

This module proves the one-variable analytic calibration behind the expected
four-dimensional causal-set link kernel. With squared timelike separation
`s = tau^2`, Alexandrov volume `V = pi * s^2 / 24`, and sprinkling density
`rho`, the expected normalized link kernel is the Gaussian below.

Its positive-half-line mass is exactly `1/(2*pi)`, it vanishes pointwise away
from `s = 0` as `rho` grows, and its pairing with every bounded continuous test
function converges to evaluation at the light cone with that coefficient.

This is only the normal-coordinate delta sequence for the ensemble-expected
link indicator. It does not prove the Lorentzian coarea lift, concentration of
individual sprinklings, convergence of the massive path sum, or a Higgs pole.

Provenance: Steven Johnston, "Particle propagators on discrete spacetime,"
arXiv:0806.3083. Proofs were completed without statement changes by Aristotle
task `c712b62d-6237-4cf4-bedc-54dd19549f62` and replayed locally.
Claim grade: `M [comp]` analytic continuum precursor.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Johnston4DLightconeDelta

open Filter MeasureTheory Set
open scoped Topology

/-- Johnston's normalized expected four-dimensional link kernel as a function
of squared timelike separation `s = tau^2`. -/
def lightconeApprox (rho s : Real) : Real :=
  Real.sqrt rho / (2 * Real.pi * Real.sqrt 6) *
    Real.exp (-(rho * Real.pi / 24) * s ^ 2)

/-- The kernel is nonnegative at nonnegative sprinkling density. -/
theorem lightconeApprox_nonneg (rho s : Real) (hrho : 0 <= rho) :
    0 <= lightconeApprox rho s := by
  exact mul_nonneg (by positivity) (Real.exp_nonneg _)

/-- At positive density the kernel is integrable on squared timelike
separations `s > 0`. -/
theorem lightconeApprox_integrableOn_Ioi (rho : Real) (hrho : 0 < rho) :
    IntegrableOn (lightconeApprox rho) (Ioi 0) := by
  exact MeasureTheory.Integrable.const_mul
    ((by simpa using integrable_exp_neg_mul_sq (by positivity)) |>
      MeasureTheory.Integrable.integrableOn) _

/-- Exact one-sided normalization. -/
theorem lightconeApprox_integral_Ioi (rho : Real) (hrho : 0 < rho) :
    integral (Measure.restrict volume (Ioi 0)) (lightconeApprox rho) =
      1 / (2 * Real.pi) := by
  convert congr_arg
      (fun x : Real => Real.sqrt rho / (2 * Real.pi * Real.sqrt 6) * x)
      (integral_gaussian_Ioi (rho * Real.pi / 24)) using 1
  · unfold lightconeApprox
    norm_num [mul_assoc, MeasureTheory.integral_const_mul]
  · field_simp
    ring
    norm_num [← mul_assoc, ← Real.sqrt_mul, hrho.le, hrho.ne']
    rw [show (24 : Real) = 6 * 4 by norm_num, Real.sqrt_mul] <;> norm_num

/-- Away from the light cone, the expected kernel decays to zero as density
tends to infinity. -/
theorem lightconeApprox_tendsto_zero (s : Real) (hs : s != 0) :
    Tendsto (fun rho : Real => lightconeApprox rho s) atTop (nhds 0) := by
  unfold lightconeApprox
  set b : Real := Real.pi * s ^ 2 / 24
  have hb_pos : 0 < b := by
    exact div_pos
      (mul_pos Real.pi_pos (sq_pos_of_ne_zero (by simpa using hs)))
      (by norm_num)
  suffices h_factor :
      Tendsto (fun rho => Real.sqrt rho * Real.exp (-b * rho)) atTop (nhds 0) by
    convert h_factor.const_mul (1 / (2 * Real.pi * Real.sqrt 6)) using 2 <;> ring
    grind +splitImp
  convert tendsto_rpow_mul_exp_neg_mul_atTop_nhds_zero
      (1 / 2 : Real) b hb_pos using 2
  norm_num [Real.sqrt_eq_rpow]

/-- Pairing with every bounded continuous test function converges to one-sided
light-cone evaluation with coefficient `1/(2*pi)`. -/
theorem lightconeApprox_pairing_tendsto
    (f : BoundedContinuousFunction Real Real) :
    Tendsto
      (fun rho : Real =>
        integral (Measure.restrict volume (Ioi 0))
          (fun s => lightconeApprox rho s * f s))
      atTop (nhds ((1 / (2 * Real.pi)) * f 0)) := by
  suffices h_subst :
      Tendsto
        (fun rho =>
          ∫ t in Ioi 0,
            (1 / (2 * Real.pi * Real.sqrt 6)) *
              Real.exp (-(Real.pi / 24) * t ^ 2) *
                f (t / Real.sqrt rho))
        atTop (nhds (1 / (2 * Real.pi) * f 0)) by
    refine h_subst.congr' ?_
    filter_upwards [eventually_gt_atTop 0] with rho hrho
    have h_change : forall {g : Real -> Real},
        ∫ s in Ioi 0, g s =
          ∫ t in Ioi 0, g (t / Real.sqrt rho) * (1 / Real.sqrt rho) := by
      intro g
      simp +decide [div_eq_mul_inv, mul_comm,
        MeasureTheory.integral_const_mul, hrho.le, ne_of_gt hrho]
      rw [MeasureTheory.integral_comp_mul_right_Ioi] <;>
        norm_num [hrho.le, hrho.ne']
      positivity
    convert h_change.symm using 3 <;>
      norm_num [lightconeApprox] <;> ring <;> grind
  have h_dominated_convergence :
      Tendsto
        (fun rho =>
          ∫ t in Ioi 0,
            (1 / (2 * Real.pi * Real.sqrt 6)) *
              Real.exp (-(Real.pi / 24) * t ^ 2) *
                f (t / Real.sqrt rho))
        atTop
        (nhds
          (∫ t in Ioi 0,
            (1 / (2 * Real.pi * Real.sqrt 6)) *
              Real.exp (-(Real.pi / 24) * t ^ 2) * f 0)) := by
    refine MeasureTheory.tendsto_integral_filter_of_dominated_convergence
      (fun t =>
        1 / (2 * Real.pi * Real.sqrt 6) *
          Real.exp (-(Real.pi / 24) * t ^ 2) * ‖f‖) ?_ ?_ ?_ ?_
    · exact Eventually.of_forall fun _ =>
        Continuous.aestronglyMeasurable
          (Continuous.mul
            (Continuous.mul continuous_const
              (Real.continuous_exp.comp (by continuity)))
            (f.continuous.comp (by continuity)))
    · simp +zetaDelta at *
      exact ⟨1, fun _ _ => eventually_inf_principal.mpr <|
        Eventually.of_forall fun x _ => by
          rw [abs_of_nonneg (Real.sqrt_nonneg _),
            abs_of_nonneg Real.pi_pos.le]
          exact mul_le_mul_of_nonneg_left (f.norm_coe_le_norm _) (by positivity)⟩
    · exact MeasureTheory.Integrable.mul_const
        (MeasureTheory.Integrable.const_mul
          ((by simpa using integrable_exp_neg_mul_sq (by positivity)) |>
            MeasureTheory.Integrable.integrableOn) _) _
    · exact Eventually.of_forall fun _ =>
        tendsto_const_nhds.mul
          (f.continuous.continuousAt.tendsto.comp <|
            tendsto_const_nhds.div_atTop <|
              tendsto_atTop_atTop.mpr fun y =>
                ⟨y ^ 2, fun n hn => Real.le_sqrt_of_sq_le (by nlinarith)⟩)
  convert h_dominated_convergence using 2
  norm_num [MeasureTheory.integral_const_mul, mul_assoc]
  rw [MeasureTheory.integral_mul_const]
  have hGaussian := integral_gaussian_Ioi (Real.pi / 24)
  simp_all +decide [div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm]
  rw [show (24 : Real) = 4 * 6 by norm_num,
    Real.sqrt_mul (by norm_num)]
  ring
  norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Johnston4DLightconeDelta.lightconeApprox_integral_Ioi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lightconeApprox_integral_Ioi

/-- info: 'PhysicsSM.Draft.NullEdge.Johnston4DLightconeDelta.lightconeApprox_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lightconeApprox_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.Johnston4DLightconeDelta.lightconeApprox_pairing_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lightconeApprox_pairing_tendsto

end PhysicsSM.Draft.NullEdge.Johnston4DLightconeDelta

end
