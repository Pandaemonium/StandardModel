import PhysicsSM.Draft.NullEdge.FiniteUniformMaxEntropy

/-!
# Finite von Neumann entropy ceiling

For a finite-dimensional density matrix, this module defines von Neumann
entropy as the Shannon entropy of the Hermitian eigenvalue vector and proves
`S(rho) <= log d`. The proof uses positive semidefiniteness to obtain
nonnegative eigenvalues and unit trace to normalize their sum.

This is the matrix entropy ceiling together with its equality characterization:
entropy saturation forces the maximally mixed scalar matrix. It is not the
energy-constrained Gibbs variational principle, so it does not yet prove the
nontrivial modular-state uniqueness required by `DYN-MODULAR-001`.

Provenance: clean-room integration of Aristotle project
`8300c085-2c69-47ba-9e92-67b3319bf553`, task
`ac9e8301-be7d-48b8-952a-3cb20c0476cb`. The submitted target was returned
unchanged and independently replayed under the repository toolchain on
2026-07-12.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.VonNeumannEntropyBound

open Matrix
open scoped ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Von Neumann entropy as the Shannon entropy of the real eigenvalues of a
Hermitian matrix. -/
def vonNeumannEntropy (rho : Matrix n n Complex) (hrho : rho.IsHermitian) : Real :=
  ∑ i, Real.negMulLog (hrho.eigenvalues i)

omit [DecidableEq n] in
/-- Finite Shannon entropy is bounded by the logarithm of the cardinality. -/
lemma sum_negMulLog_le_log_card [Nonempty n] (p : n -> Real)
    (hp : ∀ i, 0 <= p i) (hpsum : ∑ i, p i = 1) :
    ∑ i, Real.negMulLog (p i) <= Real.log (Fintype.card n) := by
  by_contra! hcontra
  have hjensen :
      (∑ i : n, (1 / (Fintype.card n : Real)) *
          Real.negMulLog (p i)) <=
        Real.negMulLog
          (∑ i : n, (1 / (Fintype.card n : Real)) * p i) := by
    convert Real.strictConcaveOn_negMulLog.concaveOn.le_map_sum _ _ _ <;>
      norm_num [hp, hpsum]
  simp_all +decide [← Finset.mul_sum]
  rw [Real.negMulLog] at hjensen
  ring_nf at *
  norm_num at *
  exact hcontra.not_ge (le_of_mul_le_mul_left hjensen (by positivity))

/-- A unit-trace Hermitian matrix has eigenvalue sum one. -/
lemma sum_eigenvalues_eq_one (rho : Matrix n n Complex)
    (hrho : rho.IsHermitian) (htrace : rho.trace = 1) :
    ∑ i, hrho.eigenvalues i = 1 := by
  convert htrace using 1
  rw [← Complex.ofReal_inj]
  convert Matrix.IsHermitian.trace_eq_sum_eigenvalues hrho using 1
  aesop

/-- Von Neumann entropy of a finite density matrix is at most `log d`. -/
theorem vonNeumann_le_log_card [Nonempty n] (rho : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hpsd : rho.PosSemidef)
    (htrace : rho.trace = 1) :
    vonNeumannEntropy rho hrho <= Real.log (Fintype.card n) := by
  refine sum_negMulLog_le_log_card (fun i => hrho.eigenvalues i)
    (fun i => hpsd.eigenvalues_nonneg i) ?_
  exact sum_eigenvalues_eq_one rho hrho htrace

/-- A Hermitian matrix with one constant eigenvalue is the corresponding
scalar multiple of the identity. -/
theorem eq_smul_one_of_eigenvalues_constant
    (rho : Matrix n n Complex) (hrho : rho.IsHermitian) (c : Real)
    (heigen : ∀ i, hrho.eigenvalues i = c) :
    rho = (c : Complex) • (1 : Matrix n n Complex) := by
  rw [hrho.spectral_theorem]
  have hdiag :
      Matrix.diagonal (RCLike.ofReal ∘ hrho.eigenvalues) =
        (c : Complex) • (1 : Matrix n n Complex) := by
    ext i j
    by_cases hij : i = j
    · subst j
      simp [heigen]
    · simp [Matrix.diagonal, hij]
  rw [hdiag]
  simp

/-- A real scalar multiple of the complex identity matrix. -/
def scalarState (c : Real) : Matrix n n Complex :=
  (c : Complex) • (1 : Matrix n n Complex)

omit [Fintype n] in
/-- A real scalar state is Hermitian. -/
theorem scalarState_isHermitian (c : Real) :
    (scalarState (n := n) c).IsHermitian := by
  ext i j
  by_cases hij : i = j
  · subst j
    simp [scalarState, Matrix.conjTranspose_apply]
  · simp [scalarState, Matrix.conjTranspose_apply, hij, Ne.symm hij]

/-- Every eigenvalue of a real scalar state is its scalar. -/
theorem scalarState_eigenvalues (c : Real) (i : n) :
    (scalarState_isHermitian (n := n) c).eigenvalues i = c := by
  have hmem := (scalarState_isHermitian (n := n) c).eigenvalues_mem_spectrum_real i
  haveI : Nonempty n := ⟨i⟩
  have hspec : spectrum Real (scalarState (n := n) c) = {c} := by
    have heq : scalarState (n := n) c =
        algebraMap Real (Matrix n n Complex) c := by
      simp [scalarState, Algebra.algebraMap_eq_smul_one]
    rw [heq, spectrum.scalar_eq]
  rw [hspec] at hmem
  simpa using hmem

/-- The normalized scalar identity matrix. -/
def maximallyMixed : Matrix n n Complex :=
  scalarState (n := n) (Fintype.card n : Real)⁻¹

/-- The maximally mixed matrix is Hermitian. -/
theorem maximallyMixed_isHermitian :
    (maximallyMixed (n := n)).IsHermitian := by
  exact scalarState_isHermitian _

/-- Every eigenvalue of the maximally mixed matrix is `1 / d`. -/
theorem maximallyMixed_eigenvalues (i : n) :
    (maximallyMixed_isHermitian (n := n)).eigenvalues i =
      (Fintype.card n : Real)⁻¹ := by
  simpa only [maximallyMixed] using
    scalarState_eigenvalues (n := n) (Fintype.card n : Real)⁻¹ i

/-- The maximally mixed density matrix attains the entropy ceiling. -/
theorem maximallyMixed_entropy [Nonempty n] :
    vonNeumannEntropy (maximallyMixed (n := n))
        (maximallyMixed_isHermitian (n := n)) =
      Real.log (Fintype.card n) := by
  unfold vonNeumannEntropy
  simp only [maximallyMixed_eigenvalues]
  rw [Finset.sum_const, Finset.card_univ]
  have hd : (Fintype.card n : Real) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  rw [Real.negMulLog, Real.log_inv, nsmul_eq_mul]
  field_simp

/-- Matrix-level uniqueness at the entropy ceiling: if a finite density
matrix reaches `log d`, it is the maximally mixed scalar matrix. -/
theorem entropy_eq_log_card_implies_maximallyMixed [Nonempty n]
    (rho : Matrix n n Complex) (hrho : rho.IsHermitian)
    (hpsd : rho.PosSemidef) (htrace : rho.trace = 1)
    (hentropy : vonNeumannEntropy rho hrho = Real.log (Fintype.card n)) :
    rho = (((Fintype.card n : Real)⁻¹ : Real) : Complex) •
      (1 : Matrix n n Complex) := by
  have heigen :
      ∀ i, hrho.eigenvalues i = (Fintype.card n : Real)⁻¹ := by
    apply (FiniteUniformMaxEntropy.entropy_eq_log_card_iff
      (fun i => hrho.eigenvalues i)
      (fun i => hpsd.eigenvalues_nonneg i)
      (sum_eigenvalues_eq_one rho hrho htrace)).mp
    simpa [vonNeumannEntropy,
      FiniteUniformMaxEntropy.shannonEntropy] using hentropy
  exact eq_smul_one_of_eigenvalues_constant rho hrho _ heigen

/-- info: 'PhysicsSM.Draft.NullEdge.VonNeumannEntropyBound.vonNeumann_le_log_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms vonNeumann_le_log_card

/-- info: 'PhysicsSM.Draft.NullEdge.VonNeumannEntropyBound.entropy_eq_log_card_implies_maximallyMixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms entropy_eq_log_card_implies_maximallyMixed

/-- info: 'PhysicsSM.Draft.NullEdge.VonNeumannEntropyBound.maximallyMixed_entropy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms maximallyMixed_entropy

end PhysicsSM.Draft.NullEdge.VonNeumannEntropyBound
