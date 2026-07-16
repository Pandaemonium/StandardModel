import Mathlib.Analysis.Matrix.HermitianFunctionalCalculus

/-!
# Hermitian functional-calculus bridge for finite quantum entropy

Focused Mathlib-only Aristotle target.  The live project proves the general
finite-dimensional quantum Klein inequality through an explicit Hermitian
spectral decomposition.  This file isolates the reusable library-facing part:

* the entropy-compatible spectral logarithm is exactly Mathlib's Hermitian
  functional calculus applied to `Real.log`;
* its self trace is the expected eigenvalue sum; and
* its two-basis cross trace is an overlap-weighted eigenvalue sum.

The last identity is deliberately stated without a raised heartbeat limit.  It
is the proof-engineering target: factor the calculation through small matrix
lemmas instead of one large normalization pass.

For a singular positive-semidefinite matrix, `Real.log 0 = 0` makes this an
entropy-compatible extension, not the ordinary invertible matrix logarithm.
No claim about an external Mathlib contribution is made here.
-/

noncomputable section

namespace QuantumKleinCFCBridge

open Matrix
open scoped BigOperators ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Explicit spectral form of the entropy-compatible Hermitian logarithm. -/
def spectralLog (rho : Matrix n n Complex) (hrho : rho.IsHermitian) :
    Matrix n n Complex :=
  (hrho.eigenvectorUnitary : Matrix n n Complex) *
      diagonal (fun i => (Real.log (hrho.eigenvalues i) : Complex)) *
    (hrho.eigenvectorUnitary : Matrix n n Complex)ᴴ

/-- The explicit spectral logarithm is Mathlib's Hermitian functional
calculus specialized to `Real.log`. -/
theorem spectralLog_eq_hermitianCFC
    (rho : Matrix n n Complex) (hrho : rho.IsHermitian) :
    spectralLog rho hrho = hrho.cfc Real.log := by
  rfl

/-- The explicit spectral logarithm also agrees with the generic continuous
functional-calculus API. -/
theorem spectralLog_eq_cfc
    (rho : Matrix n n Complex) (hrho : rho.IsHermitian) :
    spectralLog rho hrho = cfc Real.log rho := by
  rw [spectralLog_eq_hermitianCFC]
  exact (hrho.cfc_eq Real.log).symm

/-- Entropy trace identity in a single eigenbasis. -/
theorem self_trace_eq_eigenvalue_sum
    (rho : Matrix n n Complex) (hrho : rho.IsHermitian) :
    (rho * spectralLog rho hrho).trace.re =
      ∑ i, hrho.eigenvalues i * Real.log (hrho.eigenvalues i) := by
  have hdiag :
      rho * spectralLog rho hrho =
        (hrho.eigenvectorUnitary : Matrix n n Complex) *
            diagonal (fun i =>
              (hrho.eigenvalues i : Complex) *
                (Real.log (hrho.eigenvalues i) : Complex)) *
          (hrho.eigenvectorUnitary : Matrix n n Complex)ᴴ := by
    have hspectral := hrho.spectral_theorem
    convert congr_arg (fun x => x * spectralLog rho hrho) hspectral using 1
    unfold spectralLog
    simp +decide [Matrix.mul_assoc]
    simp +decide [← mul_assoc]
  convert congrArg Complex.re (congrArg Matrix.trace hdiag) using 1
  rw [← Matrix.trace_mul_comm]
  simp +decide [Matrix.trace]
  simp +decide [← mul_assoc, Matrix.IsHermitian.eigenvectorUnitary]

/-- Change-of-eigenbasis matrix from `rho` coordinates to `sigma`
coordinates. -/
def overlap (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian) :
    Matrix n n Complex :=
  (hrho.eigenvectorUnitary : Matrix n n Complex)ᴴ *
    (hsigma.eigenvectorUnitary : Matrix n n Complex)

/-- Two-basis cross trace identity.  Prove this without a local
`maxHeartbeats` increase by extracting reusable diagonal/conjugation trace
lemmas. -/
theorem cross_trace_eq_overlap_sum
    (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian) :
    (rho * spectralLog sigma hsigma).trace.re =
      ∑ i, ∑ j, hrho.eigenvalues i *
        Complex.normSq (overlap rho sigma hrho hsigma i j) *
          Real.log (hsigma.eigenvalues j) := by
  /-
  Proof handoff:
  Expand both spectral decompositions, cycle the trace so that the two
  eigenvector unitaries meet, and evaluate the trace of
  `diag(lambda) * W * diag(log mu) * W^H` entrywise.  The live project has a
  kernel-checked proof of this statement with a one-million-heartbeat local
  allowance.  This target asks for a modular proof under the default limit.
  -/
  sorry

end QuantumKleinCFCBridge
