import PhysicsSM.Draft.NullEdge.BoundedMomentumManyStepContinuum
import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
import PhysicsSM.Draft.NullEdge.FiniteFourierContinuumLift

/-!
# Finite position-kernel convergence for Dirac walks

The uniform momentum-symbol estimates for the `1+1` and successive-axis
`3+1` walks lift directly to finite periodic Fourier kernels. The result is an
explicit position-space synthesis bound for every finite mode set and every
phase family of modulus at most one.

This is stronger than a pointwise symbol statement, but deliberately weaker
than an infinite-volume `L2` propagator or Dirac PDE theorem. The cardinality
factor is the sharp generic cost of using only a uniform modewise estimate;
Plancherel can improve it when an orthogonal Fourier normalization is supplied.

Provenance: clean-room composition of the kernel-checked uniform symbol bounds
with `FiniteFourierContinuumLift.finite_fourier_error_bound`.
-/

noncomputable section

open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.FiniteWalkPositionConvergence

open PhysicsSM.Draft.NullEdge.FiniteFourierContinuumLift

variable {ι : Type*} [Fintype ι]

/-- Every finite Fourier synthesis of the `1+1` walk inherits the uniform
bounded-momentum `O(1/n)` estimate. -/
theorem onePlusOne_finite_kernel_bound
    (phase : ι → ℂ) (momentum mass : ι → ℝ)
    (K M t : ℝ) (n : ℕ)
    (hn : 0 < n) (hsmall : |t / (n : ℝ)| ≤ 1)
    (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hphase : ∀ p, ‖phase p‖ ≤ 1)
    (hk : ∀ p, |momentum p| ≤ K) (hm : ∀ p, |mass p| ≤ M) :
    ‖synth phase (fun p =>
        (FixedMomentumManyStepContinuum.walk
          (momentum p * (t / (n : ℝ)))
          (mass p * (t / (n : ℝ)))) ^ n) -
      synth phase (fun p =>
        FixedMomentumManyStepContinuum.exactFlow
          (momentum p) (mass p) t)‖ ≤
      (Fintype.card ι : ℝ) *
        (BoundedMomentumManyStepContinuum.Dbox K M * t ^ 2 / n) := by
  apply finite_fourier_error_bound
  · exact hphase
  · intro p
    exact BoundedMomentumManyStepContinuum.fixed_time_many_step_bound_on_box
      (momentum p) (mass p) K M t n hn hsmall hK hM (hk p) (hm p)

/-- Every finite Fourier synthesis of the four-factor successive-axis `3+1`
walk inherits its compact-box `O(1/n)` estimate. -/
theorem threePlusOne_finite_kernel_bound
    (phase : ι → ℂ) (kx ky kz mass : ι → ℝ)
    (K M t : ℝ) (n : ℕ)
    (hn : 0 < n) (hsmall : |t / (n : ℝ)| ≤ 1)
    (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hphase : ∀ p, ‖phase p‖ ≤ 1)
    (hx : ∀ p, |kx p| ≤ K) (hy : ∀ p, |ky p| ≤ K)
    (hz : ∀ p, |kz p| ≤ K) (hm : ∀ p, |mass p| ≤ M) :
    ‖synth phase (fun p =>
        (Compact3Plus1DiracRate.splitStep
          (kx p) (ky p) (kz p) (mass p) (t / (n : ℝ))) ^ n) -
      synth phase (fun p =>
        Compact3Plus1DiracRate.exactFlow
          (kx p) (ky p) (kz p) (mass p) t)‖ ≤
      (Fintype.card ι : ℝ) *
        (Compact3Plus1DiracRate.Dbox K M * t ^ 2 / n) := by
  apply finite_fourier_error_bound
  · exact hphase
  · intro p
    exact Compact3Plus1DiracRate.fixed_time_many_step_bound_on_box
      (kx p) (ky p) (kz p) (mass p) K M t n hn hsmall hK hM
      (hx p) (hy p) (hz p) (hm p)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteWalkPositionConvergence.onePlusOne_finite_kernel_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms onePlusOne_finite_kernel_bound

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteWalkPositionConvergence.threePlusOne_finite_kernel_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms threePlusOne_finite_kernel_bound

end PhysicsSM.Draft.NullEdge.FiniteWalkPositionConvergence
