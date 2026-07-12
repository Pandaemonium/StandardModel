import PhysicsSM.Draft.NullEdge.DynamicalMassCovariance
import PhysicsSM.Draft.NullEdge.PluckerMassDynamics

/-!
# Exact covariance of the discrete Pluecker walk step

This module lifts the generator-family classification in
`DynamicalMassCovariance` to the ordered two-channel finite propagator
`transportStep * massCoin`. The diagonal branch preserves momentum and sends
`z` to `u * z`; the antidiagonal branch sends `k` to `-k` and `z` to
`u * conj z`.

Provenance: proof completed by Aristotle project
`47f71b37-fb7a-4727-a297-255f6d603af2`, task
`f2e86c88-9d0e-4679-aba8-eceace5efcf4`, then reviewed and integrated
against the pinned Lean 4.28.0 toolchain. The statement is scoped to the exact
two-channel walk below; it is not an exhaustion theorem for the live `3+1`
split-step regulator.
-/

noncomputable section

open Matrix Complex
open scoped Matrix ComplexConjugate

namespace PhysicsSM.Draft.NullEdge.DiscreteWalkMassCovariance

open PhysicsSM.Draft.NullEdge.DynamicalMassCovariance

abbrev Mat := Matrix (Fin 2) (Fin 2) Complex

/-- Exact null transport in momentum space. -/
def transportStep (k a : Real) : Mat :=
  !![Complex.exp (-Complex.I * (k * a)), 0;
     0, Complex.exp (Complex.I * (k * a))]

/-- Ordered finite step: null transport followed by the derived Pluecker mass coin. -/
def walkStep (k : Real) (z : Complex) (a : Real) : Mat :=
  transportStep k a * PhysicsSM.Draft.NullEdge.PluckerMassDynamics.massCoin z a

/-- Conjugation by a unitary distributes over a product. -/
lemma conj_mul_of_unitary (W T M : Mat) (h : W * Wᴴ = 1) :
    W * (T * M) * Wᴴ = (W * T * Wᴴ) * (W * M * Wᴴ) := by
  have h' : Wᴴ * W = 1 := mul_eq_one_comm.mp h
  rw [show (W * T * Wᴴ) * (W * M * Wᴴ) = W * T * (Wᴴ * W) * M * Wᴴ by
    noncomm_ring, h']
  noncomm_ring

/-- The scaled chiral phase is unitary. -/
lemma chiralPhase_scaled_unitary (lam u : Complex)
    (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    (lam • chiralPhase u) * (lam • chiralPhase u)ᴴ = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [chiralPhase, Matrix.mul_apply, Complex.ext_iff] at * <;>
    ring_nf at * <;>
    simp_all +decide [Complex.normSq_eq_norm_sq, Complex.norm_mul]
  · simp_all +decide [Complex.normSq, Complex.norm_def]
    nlinarith
  · simp [← Complex.normSq_add_mul_I, Complex.normSq_eq_norm_sq, hlam]

/-- Conjugation by the scaled chiral phase leaves diagonal transport fixed. -/
lemma chiralPhase_transport_inv (lam u : Complex) (k a : Real)
    (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    (lam • chiralPhase u) * transportStep k a * (lam • chiralPhase u)ᴴ =
      transportStep k a := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [*, Matrix.mul_apply, chiralPhase, transportStep] <;> ring
  · simp_all +decide [Complex.normSq_eq_norm_sq, Complex.ext_iff, mul_assoc,
      mul_comm, mul_left_comm]
    norm_num [Complex.normSq, Complex.norm_def, Complex.exp_re, Complex.exp_im] at *
    grind
  · rw [mul_right_comm, Complex.mul_conj, Complex.normSq_eq_norm_sq]
    aesop

/-- Chiral-phase conjugation sends the mass coin at `z` to that at `u * z`. -/
lemma chiralPhase_massCoin_cov (lam u z : Complex) (a : Real)
    (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    (lam • chiralPhase u) *
        PhysicsSM.Draft.NullEdge.PluckerMassDynamics.massCoin z a *
        (lam • chiralPhase u)ᴴ =
      PhysicsSM.Draft.NullEdge.PluckerMassDynamics.massCoin (u * z) a := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [Matrix.mul_apply, PluckerMassDynamics.massCoin] <;> ring
  · simp_all +decide [chiralPhase, PluckerMassOperator.massOperator]
    simp_all +decide [mul_assoc, mul_comm, mul_left_comm, Complex.ext_iff]
    norm_cast
    simp_all +decide [Complex.normSq, Complex.norm_def]
    ring
    grind
  · unfold chiralPhase PluckerMassOperator.massOperator
    simp +decide [hu]
    ring
    simp_all +decide [mul_assoc, mul_left_comm lam, Complex.mul_conj,
      Complex.normSq_eq_norm_sq]
  · simp +decide [chiralPhase, PluckerMassOperator.massOperator]
    ring
    simp_all +decide [mul_assoc, mul_comm, mul_left_comm, Complex.ext_iff]
    norm_cast
    simp_all +decide [Complex.normSq, Complex.norm_def]
    ring_nf
    grind
  · simp_all +decide [mul_assoc, mul_comm, mul_left_comm,
      PluckerMassOperator.massOperator, chiralPhase]
    simp_all +decide [mul_left_comm lam, Complex.ext_iff, Complex.exp_re,
      Complex.exp_im, Complex.cos, Complex.sin]
    simp_all +decide [Complex.normSq, Complex.norm_def]
    exact Or.inr (by ring)

/-- The scaled chiral flip is unitary. -/
lemma chiralFlip_scaled_unitary (lam u : Complex)
    (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    (lam • chiralFlip u) * (lam • chiralFlip u)ᴴ = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [*, Matrix.mul_apply, chiralFlip]
  · simp_all +decide [mul_assoc, mul_comm, mul_left_comm, Complex.ext_iff]
    norm_num [Complex.normSq, Complex.norm_def] at *
    grind
  · simp +decide [Complex.mul_conj, Complex.normSq_eq_norm_sq, hlam]

/-- Chiral-flip conjugation reverses diagonal transport, `k -> -k`. -/
lemma chiralFlip_transport_parity (lam u : Complex) (k a : Real)
    (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    (lam • chiralFlip u) * transportStep k a * (lam • chiralFlip u)ᴴ =
      transportStep (-k) a := by
  unfold chiralFlip transportStep
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, Matrix.smul_apply] <;> ring
  · simp_all +decide [Complex.ext_iff, Complex.exp_re, Complex.exp_im, mul_assoc]
    simp_all +decide [Complex.norm_def, Complex.normSq_apply]
    grind
  · rw [mul_right_comm, mul_comm]
    simp +decide [Complex.mul_conj, Complex.normSq_eq_norm_sq, hlam]

/-- Chiral-flip conjugation sends the mass coin at `z` to that at `u * conj z`. -/
lemma chiralFlip_massCoin_cov (lam u z : Complex) (a : Real)
    (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    (lam • chiralFlip u) *
        PhysicsSM.Draft.NullEdge.PluckerMassDynamics.massCoin z a *
        (lam • chiralFlip u)ᴴ =
      PhysicsSM.Draft.NullEdge.PluckerMassDynamics.massCoin (u * conj z) a := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [*, Matrix.mul_apply, Fin.sum_univ_succ] <;> ring
  · simp +decide [chiralFlip, PluckerMassDynamics.massCoin]
    simp +decide [PluckerMassOperator.massOperator, hu]
    simp_all +decide [Complex.ext_iff, mul_assoc, mul_comm, mul_left_comm]
    norm_cast
    simp_all +decide [Complex.normSq, Complex.norm_def]
    ring_nf
    grind
  · unfold PluckerMassDynamics.massCoin
    simp +decide [chiralFlip, PluckerMassOperator.massOperator]
    simp_all +decide [Complex.ext_iff, mul_assoc, mul_comm, mul_left_comm]
    norm_cast
    simp_all +decide [Complex.normSq, Complex.norm_def]
    ring_nf
    grind
  · simp_all +decide [chiralFlip, PluckerMassDynamics.massCoin]
    simp_all +decide [PluckerMassOperator.massOperator, mul_assoc, mul_comm,
      mul_left_comm, Complex.mul_conj, Complex.normSq_eq_norm_sq]
  · unfold PluckerMassDynamics.massCoin
    simp_all +decide [PluckerMassOperator.massOperator, chiralFlip]
    rw [mul_right_comm, Complex.mul_conj, Complex.normSq_eq_norm_sq]
    aesop

/-- Every classified same-momentum covariance acts exactly on the ordered finite step. -/
theorem chiralPhase_walk_covariance (lam u z : Complex) (k a : Real)
    (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    (lam • chiralPhase u) * walkStep k z a * (lam • chiralPhase u)ᴴ =
      walkStep k (u * z) a := by
  rw [walkStep,
    conj_mul_of_unitary _ _ _ (chiralPhase_scaled_unitary lam u hlam hu),
    chiralPhase_transport_inv lam u k a hlam hu,
    chiralPhase_massCoin_cov lam u z a hlam hu, walkStep]

/-- Every classified orientation-reversing covariance acts on the ordered step
only when accompanied by parity `k -> -k`. -/
theorem chiralFlip_walk_parity_covariance (lam u z : Complex) (k a : Real)
    (hlam : ‖lam‖ = 1) (hu : ‖u‖ = 1) :
    (lam • chiralFlip u) * walkStep k z a * (lam • chiralFlip u)ᴴ =
      walkStep (-k) (u * conj z) a := by
  rw [walkStep,
    conj_mul_of_unitary _ _ _ (chiralFlip_scaled_unitary lam u hlam hu),
    chiralFlip_transport_parity lam u k a hlam hu,
    chiralFlip_massCoin_cov lam u z a hlam hu, walkStep]

end PhysicsSM.Draft.NullEdge.DiscreteWalkMassCovariance
