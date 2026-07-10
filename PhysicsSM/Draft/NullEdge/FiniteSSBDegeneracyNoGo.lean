import Mathlib

/-!
# Finite spontaneous-symmetry-breaking degeneracy gate

A unitary symmetry commuting with a finite Hamiltonian can only multiply a
simple normalized eigenvector by a phase, so its pure density matrix is
invariant. An explicit degenerate two-level Hamiltonian supplies the opposite
witness: a commuting unitary can move one ground-state representative to a
distinct representative.

This is a finite degeneracy gate. It does not construct a thermodynamic or
refinement limit, an order parameter, or a Higgs potential.

Provenance: clean-room finite-dimensional formulation of the elementary
nondegenerate-eigenstate obstruction. Proofs were completed by Aristotle
project `af7eb850-5998-430e-9e11-4e2d15ae7685` and locally rechecked under the
pinned toolchain.
-/

open scoped BigOperators ComplexConjugate

namespace PhysicsSM.Draft.NullEdge.FiniteSSBDegeneracyNoGo

/-- Squared norm of a finite complex vector. -/
noncomputable def vecNormSq {n : Nat} (psi : Fin n → ℂ) : ℝ :=
  ∑ i, Complex.normSq (psi i)

/-- Rank-one density matrix of a pure vector. -/
noncomputable def pureDensity {n : Nat} (psi : Fin n → ℂ) :
    Matrix (Fin n) (Fin n) ℂ :=
  fun i j => psi i * star (psi j)

/-- A displayed eigenvalue is simple when every eigenvector at that value is a
scalar multiple of the chosen nonzero vector. -/
def IsSimpleEigenpair {n : Nat} (H : Matrix (Fin n) (Fin n) ℂ)
    (E : ℂ) (psi : Fin n → ℂ) : Prop :=
  psi ≠ 0 ∧ H.mulVec psi = E • psi ∧
    ∀ phi : Fin n → ℂ, H.mulVec phi = E • phi → ∃ c : ℂ, phi = c • psi

/-- A symmetry commuting with the Hamiltonian preserves a simple eigenspace
line. -/
theorem commuting_symmetry_preserves_simple_line {n : Nat}
    (H U : Matrix (Fin n) (Fin n) ℂ) (E : ℂ) (psi : Fin n → ℂ)
    (hsimple : IsSimpleEigenpair H E psi)
    (hcomm : H * U = U * H) :
    ∃ c : ℂ, U.mulVec psi = c • psi := by
  convert hsimple.2.2 _ _
  convert congr_arg (fun x => U.mulVec x) hsimple.2.1 using 1
  · simp [hcomm.symm]
  · rw [Matrix.mulVec_smul]

/-- A unitary finite matrix preserves the squared norm of a vector. -/
theorem vecNormSq_mulVec_unitary {n : Nat} (U : Matrix (Fin n) (Fin n) ℂ)
    (psi : Fin n → ℂ) (hunit : U.conjTranspose * U = 1) :
    vecNormSq (U.mulVec psi) = vecNormSq psi := by
  have h_norm_sq : ∀ v : Fin n → ℂ, vecNormSq v = (star v ⬝ᵥ v).re := by
    simp +decide [dotProduct]
    exact fun v => Finset.sum_congr rfl fun _ _ => Complex.normSq_apply _
  have h_lhs : star (U.mulVec psi) ⬝ᵥ (U.mulVec psi) =
      (star psi) ⬝ᵥ ((U.conjTranspose * U).mulVec psi) := by
    simp +decide [Matrix.mulVec, dotProduct]
    simp +decide [Matrix.mul_apply, mul_assoc, mul_comm, mul_left_comm,
      Finset.mul_sum _ _ _]
    exact Finset.sum_comm.trans
      (Finset.sum_congr rfl fun _ _ => Finset.sum_comm)
  aesop

/-- A normalized simple eigenstate has a symmetry-invariant pure density
matrix. -/
theorem simple_eigenstate_density_invariant {n : Nat}
    (H U : Matrix (Fin n) (Fin n) ℂ) (E : ℂ) (psi : Fin n → ℂ)
    (hsimple : IsSimpleEigenpair H E psi)
    (hnorm : vecNormSq psi = 1)
    (hunit : U.conjTranspose * U = 1)
    (hcomm : H * U = U * H) :
    pureDensity (U.mulVec psi) = pureDensity psi := by
  obtain ⟨c, hc⟩ := commuting_symmetry_preserves_simple_line H U E psi hsimple hcomm
  have hnormc : Complex.normSq c = 1 := by
    have h1 : vecNormSq (U.mulVec psi) = vecNormSq psi :=
      vecNormSq_mulVec_unitary U psi hunit
    have h2 : vecNormSq (c • psi) = Complex.normSq c * vecNormSq psi := by
      unfold vecNormSq
      rw [Finset.mul_sum]
      refine Finset.sum_congr rfl (fun i _ => ?_)
      simp [Complex.normSq_mul]
    rw [hc] at h1
    rw [h2, hnorm, mul_one] at h1
    exact h1
  have hcc : c * star c = 1 := by
    have h := Complex.mul_conj c
    rw [hnormc] at h
    simpa [mul_comm, RCLike.star_def] using h
  ext i j
  simp only [pureDensity, hc, Pi.smul_apply, smul_eq_mul, star_mul']
  have hrw : c * psi i * (star c * star (psi j)) =
      (c * star c) * (psi i * star (psi j)) := by ring
  rw [hrw, hcc, one_mul]

/-- Degenerate zero Hamiltonian on two states. -/
noncomputable def Hdeg : Matrix (Fin 2) (Fin 2) ℂ := 0

/-- Nonidentity swap symmetry. -/
noncomputable def Uswap : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

noncomputable def e0 : Fin 2 → ℂ := ![1, 0]
noncomputable def e1 : Fin 2 → ℂ := ![0, 1]

/-- Degeneracy permits a symmetry to move one ground-state representative to a
distinct representative rather than merely multiply it by a phase. -/
theorem degenerate_symmetry_breaking_witness :
    Hdeg * Uswap = Uswap * Hdeg ∧
      Uswap.conjTranspose * Uswap = 1 ∧
      Hdeg.mulVec e0 = 0 ∧
      Hdeg.mulVec e1 = 0 ∧
      Uswap.mulVec e0 = e1 ∧
      ¬ ∃ c : ℂ, Uswap.mulVec e0 = c • e0 := by
  refine' ⟨_, _, _, _, _⟩
  · unfold Hdeg Uswap
    ext i j
    fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply]
  · ext i j
    fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply, Uswap]
  · unfold Hdeg e0
    ext i
    fin_cases i <;> norm_num [Matrix.mulVec]
  · ext i
    fin_cases i <;> norm_num [Hdeg]
  · simp +decide [funext_iff, Fin.forall_fin_two, Uswap, e0, e1]

end PhysicsSM.Draft.NullEdge.FiniteSSBDegeneracyNoGo
