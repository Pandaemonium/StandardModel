import Mathlib.MeasureTheory.Function.LpSeminorm.SMul
import Mathlib.MeasureTheory.Function.LpSpace.Basic

/-!
# Uniform multiplier error implies L2 convergence

This standalone target isolates the analytic step after the null-edge walk's
uniform momentum-symbol estimate.  A square-integrable wave packet is acted on
by a family of pointwise errors.  If the pointwise norm is bounded by a scalar
sequence times the wave-packet norm, and that scalar tends to zero, then the
L2 error tends to zero.

The intended application takes `err n k` to be
`(U_n(k) - exp (-i t H(k))) (f k)` and `eps n` to be the landed explicit
`Dbox * t^2 / (n+1)` envelope.  Fourier-isometry and lattice-to-continuum
identification are separate successor obligations.
-/

noncomputable section

open Filter MeasureTheory Topology

namespace NullEdgeL2PDEBridge

variable {X E : Type*} [MeasurableSpace X]
variable [NormedAddCommGroup E] [NormedSpace Real E]
variable {mu : Measure X}

/-- A pointwise relative error bound controls the full `L2` seminorm with the
same scalar coefficient. -/
theorem eLpNorm_two_le_of_uniform_relative_bound
    (err f : X -> E) (eps : Real)
    (heps : 0 <= eps)
    (hbound : ∀ᵐ x ∂mu, ‖err x‖ <= eps * ‖f x‖) :
    eLpNorm err 2 mu <= ENNReal.ofReal eps * eLpNorm f 2 mu := by
  have hmono : eLpNorm err 2 mu <= eLpNorm (eps • f) 2 mu := by
    apply eLpNorm_mono_ae
    filter_upwards [hbound] with x hx
    rw [Pi.smul_apply, norm_smul]
    simpa [Real.norm_eq_abs, abs_of_nonneg heps] using hx
  rw [eLpNorm_const_smul] at hmono
  calc eLpNorm err 2 mu <= ‖eps‖ₑ * eLpNorm f 2 mu := hmono
    _ = ENNReal.ofReal eps * eLpNorm f 2 mu := by
        rw [Real.enorm_eq_ofReal heps]

/-- If the uniform relative-error coefficients tend to zero, every `L2`
wave packet has vanishing `L2` error. -/
theorem eLpNorm_two_tendsto_zero_of_uniform_relative_bound
    (err : Nat -> X -> E) (f : X -> E) (eps : Nat -> Real)
    (hf : MemLp f 2 mu)
    (heps : forall n, 0 <= eps n)
    (heps0 : Tendsto eps atTop (nhds 0))
    (hbound : forall n, ∀ᵐ x ∂mu,
      ‖err n x‖ <= eps n * ‖f x‖) :
    Tendsto (fun n => eLpNorm (err n) 2 mu) atTop (nhds 0) := by
  have hle : ∀ n, eLpNorm (err n) 2 mu <= ENNReal.ofReal (eps n) * eLpNorm f 2 mu :=
    fun n => eLpNorm_two_le_of_uniform_relative_bound (err n) f (eps n) (heps n) (hbound n)
  have hbdd : Tendsto (fun n => ENNReal.ofReal (eps n) * eLpNorm f 2 mu) atTop (nhds 0) := by
    have h1 : Tendsto (fun n => ENNReal.ofReal (eps n)) atTop (nhds 0) := by
      rw [← ENNReal.ofReal_zero]
      exact (ENNReal.continuous_ofReal.tendsto 0).comp heps0
    have := ENNReal.Tendsto.mul_const h1 (Or.inr hf.eLpNorm_lt_top.ne)
    simpa using this
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds hbdd ?_ hle
  exact fun n => zero_le _

end NullEdgeL2PDEBridge
