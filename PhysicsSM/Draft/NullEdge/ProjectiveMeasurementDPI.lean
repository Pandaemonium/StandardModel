import PhysicsSM.Draft.NullEdge.FiniteClassicalDPI
import PhysicsSM.Draft.NullEdge.GeneralQuantumKlein

/-!
# Projective-measurement data processing in the reference eigenbasis

This module proves a sharply scoped quantum data-processing theorem. Measure
both density matrices in the eigenbasis of the positive-definite reference
state. The resulting classical relative entropy cannot exceed the original
quantum relative entropy.

The proof uses the CFC-free spectral logarithm and two-basis overlap machinery
from `GeneralQuantumKlein`. It proves neither arbitrary POVM monotonicity nor
general completely-positive trace-preserving data processing. Because the
spectral basis API is noncomputable and noncanonical, the module also does not
claim a concrete strict noncommuting qubit gap; it proves monotonicity and the
self/shared-basis equality control.

Provenance: theorem statements prepared in-project. Proofs were returned by
Aristotle project `1493c36f-ba69-4fd5-8bd4-cd4af517bc1e`, independently
replayed, and accepted by a Claude-family semantic audit on 2026-07-13.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ProjectiveMeasurementDPI

open Matrix
open scoped BigOperators ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Change-of-eigenbasis matrix from `rho` coordinates to `sigma` coordinates. -/
def overlap (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian) :
    Matrix n n Complex :=
  (hrho.eigenvectorUnitary : Matrix n n Complex)ᴴ *
    (hsigma.eigenvectorUnitary : Matrix n n Complex)

/-- Probability of the `j`th outcome when `rho` is projectively measured in
the eigenbasis of `sigma`. -/
def measuredProb (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian) : n -> Real :=
  fun j => ∑ i, hrho.eigenvalues i *
    Complex.normSq (overlap rho sigma hrho hsigma i j)

/-- The overlap matrix is unitary. -/
lemma overlap_unitary (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian) :
    overlap rho sigma hrho hsigma ∈ Matrix.unitaryGroup n Complex :=
  GeneralQuantumKlein.overlap_mem_unitaryGroup rho sigma hrho hsigma

/-- Doubly-stochastic majorization for the convex function `x * log x`. -/
lemma doublyStochastic_entropy_le {m : Type*} [Fintype m]
    (lam : m → Real) (S : m → m → Real)
    (hlam : ∀ i, 0 ≤ lam i)
    (hS : ∀ i j, 0 ≤ S i j)
    (hrow : ∀ i, ∑ j, S i j = 1)
    (hcol : ∀ j, ∑ i, S i j = 1) :
    (∑ j, (∑ i, lam i * S i j) * Real.log (∑ i, lam i * S i j))
      ≤ ∑ i, lam i * Real.log (lam i) := by
  have h_jensen : ∀ j,
      (∑ i, S i j * lam i) * Real.log (∑ i, S i j * lam i) ≤
        ∑ i, S i j * (lam i * Real.log (lam i)) := by
    intro j
    convert ConvexOn.map_sum_le Real.convexOn_mul_log
      (fun i _ => hS i j) (by aesop) (fun i _ => hlam i) using 1
  convert Finset.sum_le_sum fun j _ => h_jensen j using 1
  any_goals exact Finset.univ
  · simp +decide only [mul_comm]
  · rw [Finset.sum_comm, Finset.sum_congr rfl]
    intros
    rw [← Finset.sum_mul]
    aesop

/-- The measured distribution is nonnegative when `rho` is positive
semidefinite. -/
lemma measuredProb_nonneg (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrhoPsd : rho.PosSemidef) (j : n) :
    0 ≤ measuredProb rho sigma hrho hsigma j := by
  exact Finset.sum_nonneg fun i _ =>
    mul_nonneg (hrhoPsd.eigenvalues_nonneg i) (Complex.normSq_nonneg _)

/-- The measured distribution is normalized when `rho` has unit trace. -/
lemma measuredProb_sum_one (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrhoTrace : rho.trace = 1) :
    ∑ j, measuredProb rho sigma hrho hsigma j = 1 := by
  have htrace := hrho.trace_eq_sum_eigenvalues
  simp_all +decide [Complex.ext_iff, Matrix.trace]
  have h_fubini :
      ∑ j, ∑ i, hrho.eigenvalues i *
          Complex.normSq (overlap rho sigma hrho hsigma i j) =
        ∑ i, hrho.eigenvalues i * ∑ j,
          Complex.normSq (overlap rho sigma hrho hsigma i j) := by
    rw [Finset.sum_comm,
      Finset.sum_congr rfl fun _ _ => Finset.mul_sum _ _ _]
  convert h_fubini using 2
  rw [overlap_unitary rho sigma hrho hsigma |>
    fun h => GeneralQuantumKlein.unitary_normSq_row_sum _ h _]
  norm_num

/-- Expansion of the quantum relative entropy through the two spectral traces. -/
lemma qRelEntropy_eq_sum (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian) :
    GeneralQuantumKlein.qRelEntropy rho sigma hrho hsigma =
      (∑ i, hrho.eigenvalues i * Real.log (hrho.eigenvalues i)) -
        ∑ i, ∑ j, hrho.eigenvalues i *
          Complex.normSq (overlap rho sigma hrho hsigma i j) *
          Real.log (hsigma.eigenvalues j) := by
  rw [GeneralQuantumKlein.qRelEntropy, Matrix.mul_sub, Matrix.trace_sub,
    Complex.sub_re]
  congr! 1
  · convert GeneralQuantumKlein.entropy_trace_eq_sum rho hrho using 1
  · convert GeneralQuantumKlein.cross_trace_eq_sum
      rho sigma hrho hsigma using 1

/-- The measured classical relative entropy has the same reference cross term
as the quantum relative entropy. -/
lemma relEntropy_measured_eq (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hsigmaPd : sigma.PosDef) :
    FiniteClassicalDPI.relEntropy
        (measuredProb rho sigma hrho hsigma) hsigma.eigenvalues =
      (∑ j, measuredProb rho sigma hrho hsigma j *
          Real.log (measuredProb rho sigma hrho hsigma j)) -
        ∑ i, ∑ j, hrho.eigenvalues i *
          Complex.normSq (overlap rho sigma hrho hsigma i j) *
          Real.log (hsigma.eigenvalues j) := by
  have h_cross_term : ∀ j,
      measuredProb rho sigma hrho hsigma j *
          Real.log (measuredProb rho sigma hrho hsigma j) -
        measuredProb rho sigma hrho hsigma j *
          Real.log (hsigma.eigenvalues j) =
        measuredProb rho sigma hrho hsigma j *
          Real.log (measuredProb rho sigma hrho hsigma j /
            hsigma.eigenvalues j) := by
    intro j
    by_cases h : measuredProb rho sigma hrho hsigma j = 0 <;>
      simp +decide [h, Real.log_div,
        hsigmaPd.eigenvalues_pos j |> ne_of_gt]
    ring
  convert Finset.sum_congr rfl
    (fun j _ => h_cross_term j |> Eq.symm) using 1
  simp +decide [measuredProb, Finset.sum_sub_distrib, Finset.sum_mul]
  exact Finset.sum_comm

/-- Measuring in the positive-definite reference state's eigenbasis cannot
increase relative entropy. -/
theorem projectiveMeasurement_relEntropy_le_qRelEntropy
    (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrhoPsd : rho.PosSemidef) (hsigmaPd : sigma.PosDef)
    (hrhoTrace : rho.trace = 1) (hsigmaTrace : sigma.trace = 1) :
    FiniteClassicalDPI.relEntropy
        (measuredProb rho sigma hrho hsigma)
        hsigma.eigenvalues ≤
      GeneralQuantumKlein.qRelEntropy rho sigma hrho hsigma := by
  -- The trace hypotheses retain the density-matrix framing. The inequality
  -- itself uses only positivity and the doubly-stochastic overlap; normalization
  -- is used separately by `measuredProb_sum_one`.
  rw [qRelEntropy_eq_sum rho sigma hrho hsigma,
    relEntropy_measured_eq rho sigma hrho hsigma hsigmaPd]
  have hmem := overlap_unitary rho sigma hrho hsigma
  have hmaj := doublyStochastic_entropy_le
    (m := n) hrho.eigenvalues
    (fun i j => Complex.normSq (overlap rho sigma hrho hsigma i j))
    (fun i => hrhoPsd.eigenvalues_nonneg i)
    (fun _ _ => Complex.normSq_nonneg _)
    (fun i => GeneralQuantumKlein.unitary_normSq_row_sum _ hmem i)
    (fun j => GeneralQuantumKlein.unitary_normSq_col_sum _ hmem j)
  have hp : ∀ j, measuredProb rho sigma hrho hsigma j =
      ∑ i, hrho.eigenvalues i *
        Complex.normSq (overlap rho sigma hrho hsigma i j) := fun j => rfl
  simp only [hp] at *
  linarith [hmaj]

/-! ## Equality boundary -/

/-- A state's eigenbasis overlaps with itself by the identity matrix. -/
lemma overlap_self_eq_one (sigma : Matrix n n Complex)
    (hsigma : sigma.IsHermitian) :
    overlap sigma sigma hsigma hsigma = (1 : Matrix n n Complex) := by
  have hunitary := hsigma.eigenvectorUnitary.2
  convert hunitary.1 using 1

/-- Measuring `sigma` in its own eigenbasis returns its eigenvalues. -/
lemma measuredProb_self (sigma : Matrix n n Complex)
    (hsigma : sigma.IsHermitian) :
    measuredProb sigma sigma hsigma hsigma = hsigma.eigenvalues := by
  ext j
  unfold measuredProb
  rw [overlap_self_eq_one, Finset.sum_eq_single j] <;> simp +contextual

/-- At the self/shared-eigenbasis boundary, both relative entropies vanish. -/
theorem projectiveMeasurement_relEntropy_eq_self
    (sigma : Matrix n n Complex) (hsigma : sigma.IsHermitian) :
    FiniteClassicalDPI.relEntropy
        (measuredProb sigma sigma hsigma hsigma) hsigma.eigenvalues = 0 ∧
      GeneralQuantumKlein.qRelEntropy sigma sigma hsigma hsigma = 0 := by
  constructor
  · rw [measuredProb_self]
    exact Finset.sum_eq_zero fun i _ => by
      by_cases hi : hsigma.eigenvalues i = 0 <;> simp +decide [hi]
  · unfold GeneralQuantumKlein.qRelEntropy
    aesop

/-!
The spectral theorem supplies `eigenvectorUnitary` noncomputably through
classical choice, with phase and degenerate-subspace freedom. Consequently this
API does not reduce the overlap weights of a concrete qubit to numerals by
`decide`, `n a t i v e _ d e c i d e`, or evaluation. A strict non-shared-basis
qubit gap is therefore not asserted here. The proved content is the universal
nonnegative gap and its self/shared-basis equality control.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.ProjectiveMeasurementDPI.projectiveMeasurement_relEntropy_le_qRelEntropy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectiveMeasurement_relEntropy_le_qRelEntropy

/-- info: 'PhysicsSM.Draft.NullEdge.ProjectiveMeasurementDPI.projectiveMeasurement_relEntropy_eq_self' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectiveMeasurement_relEntropy_eq_self

end PhysicsSM.Draft.NullEdge.ProjectiveMeasurementDPI
