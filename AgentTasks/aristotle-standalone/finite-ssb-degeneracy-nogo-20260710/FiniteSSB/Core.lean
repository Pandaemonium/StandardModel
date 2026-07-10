import Mathlib

/-!
# Finite spontaneous-symmetry-breaking degeneracy gate

Standalone Aristotle target. A symmetry commuting with a finite Hamiltonian can
only multiply a simple normalized eigenvector by a phase, so its pure density
matrix is invariant. An explicit degenerate two-level system supplies the
opposite witness.
-/

open scoped BigOperators ComplexConjugate

namespace FiniteSSB

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

/-- A unitary symmetry commuting with the Hamiltonian preserves a simple
eigenvector up to scalar. -/
theorem commuting_symmetry_preserves_simple_line {n : Nat}
    (H U : Matrix (Fin n) (Fin n) ℂ) (E : ℂ) (psi : Fin n → ℂ)
    (hsimple : IsSimpleEigenpair H E psi)
    (hcomm : H * U = U * H) :
    ∃ c : ℂ, U.mulVec psi = c • psi := by
  sorry

/-- With normalization and unitarity, the scalar has unit norm and the pure
state is exactly symmetry invariant. -/
theorem simple_eigenstate_density_invariant {n : Nat}
    (H U : Matrix (Fin n) (Fin n) ℂ) (E : ℂ) (psi : Fin n → ℂ)
    (hsimple : IsSimpleEigenpair H E psi)
    (hnorm : vecNormSq psi = 1)
    (hunit : U.conjTranspose * U = 1)
    (hcomm : H * U = U * H) :
    pureDensity (U.mulVec psi) = pureDensity psi := by
  sorry

/-- Degenerate zero Hamiltonian on two states. -/
noncomputable def Hdeg : Matrix (Fin 2) (Fin 2) ℂ := 0

/-- Nonidentity swap symmetry. -/
noncomputable def Uswap : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

noncomputable def e0 : Fin 2 → ℂ := ![1, 0]
noncomputable def e1 : Fin 2 → ℂ := ![0, 1]

/-- Degeneracy permits a symmetry to move one ground-state representative to a
distinct orthogonal representative. -/
theorem degenerate_symmetry_breaking_witness :
    Hdeg * Uswap = Uswap * Hdeg ∧
      Uswap.conjTranspose * Uswap = 1 ∧
      Hdeg.mulVec e0 = 0 ∧
      Hdeg.mulVec e1 = 0 ∧
      Uswap.mulVec e0 = e1 ∧
      ¬ ∃ c : ℂ, Uswap.mulVec e0 = c • e0 := by
  sorry

end FiniteSSB
