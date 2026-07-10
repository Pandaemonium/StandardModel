import Mathlib.MeasureTheory.Function.LpSeminorm.SMul
import Mathlib.MeasureTheory.Function.LpSpace.Basic

/-!
# Uniform multiplier error implies L2 convergence

This module isolates the analytic step after the null-edge walk's uniform
momentum-symbol estimate.  A square-integrable wave packet is acted on by a
family of pointwise errors.  If the pointwise norm is bounded by a scalar
sequence times the wave-packet norm, and that scalar tends to zero, then the
`L2` multiplier error tends to zero.

For the complex `3+1` walk, `err n k` can be instantiated by
`(U_n(k) - exp (-i t H(k))) (f k)` and `eps n` by the landed explicit compact
envelope.  This theorem closes the measure-theoretic multiplier step.  A
Fourier isometry between the chosen lattice/continuum spaces and identification
of the limiting multiplier with a position-space Dirac PDE remain separate
obligations.

Provenance: target prepared from the null-edge continuum audit; proofs
completed by Aristotle project `b4b82493-818d-48db-b7e1-148396c9e3e2`, then
reviewed and checked locally under Lean 4.28.0.  The proof uses Mathlib's
`eLpNorm_mono_ae`, scalar seminorm identity, and ENNReal squeeze APIs.
-/

noncomputable section

open Filter MeasureTheory Topology

namespace PhysicsSM.Draft.NullEdge.ContinuumL2MultiplierBridge

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
  calc
    eLpNorm err 2 mu <= ‖eps‖ₑ * eLpNorm f 2 mu := hmono
    _ = ENNReal.ofReal eps * eLpNorm f 2 mu := by
      rw [Real.enorm_eq_ofReal heps]

/-- If the uniform relative-error coefficients tend to zero, every `L2` wave
packet has vanishing `L2` multiplier error. -/
theorem eLpNorm_two_tendsto_zero_of_uniform_relative_bound
    (err : Nat -> X -> E) (f : X -> E) (eps : Nat -> Real)
    (hf : MemLp f 2 mu)
    (heps : forall n, 0 <= eps n)
    (heps0 : Tendsto eps atTop (nhds 0))
    (hbound : forall n, ∀ᵐ x ∂mu,
      ‖err n x‖ <= eps n * ‖f x‖) :
    Tendsto (fun n => eLpNorm (err n) 2 mu) atTop (nhds 0) := by
  have hle : forall n,
      eLpNorm (err n) 2 mu <=
        ENNReal.ofReal (eps n) * eLpNorm f 2 mu :=
    fun n => eLpNorm_two_le_of_uniform_relative_bound
      (err n) f (eps n) (heps n) (hbound n)
  have hbdd : Tendsto
      (fun n => ENNReal.ofReal (eps n) * eLpNorm f 2 mu)
      atTop (nhds 0) := by
    have h1 : Tendsto (fun n => ENNReal.ofReal (eps n))
        atTop (nhds 0) := by
      rw [← ENNReal.ofReal_zero]
      exact (ENNReal.continuous_ofReal.tendsto 0).comp heps0
    have hmul := ENNReal.Tendsto.mul_const h1
      (Or.inr hf.eLpNorm_lt_top.ne)
    simpa using hmul
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le
    tendsto_const_nhds hbdd ?_ hle
  exact fun n => zero_le _

end PhysicsSM.Draft.NullEdge.ContinuumL2MultiplierBridge

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ContinuumL2MultiplierBridge.eLpNorm_two_le_of_uniform_relative_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ContinuumL2MultiplierBridge.eLpNorm_two_le_of_uniform_relative_bound

/-- info: 'PhysicsSM.Draft.NullEdge.ContinuumL2MultiplierBridge.eLpNorm_two_tendsto_zero_of_uniform_relative_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ContinuumL2MultiplierBridge.eLpNorm_two_tendsto_zero_of_uniform_relative_bound
