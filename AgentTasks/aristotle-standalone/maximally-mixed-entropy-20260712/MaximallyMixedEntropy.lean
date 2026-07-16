import Mathlib

/-!
# Aristotle target: entropy of the maximally mixed finite matrix

Prove the two stated targets without changing their definitions or hypotheses.
The first identifies every eigenvalue of a real scalar identity matrix. The
second uses that result to prove that the normalized scalar identity attains
the von Neumann entropy ceiling `log d`.

This is a focused Mathlib-only package. Run
`lake env lean MaximallyMixedEntropy.lean` and close only the two proof gaps.
-/

noncomputable section

namespace MaximallyMixedEntropy

open Matrix
open scoped BigOperators ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A real scalar multiple of the complex identity matrix. -/
def scalarState (c : Real) : Matrix n n Complex :=
  (c : Complex) • (1 : Matrix n n Complex)

/-- The scalar state is Hermitian. -/
theorem scalarState_isHermitian (c : Real) :
    (scalarState (n := n) c).IsHermitian := by
  ext i j
  by_cases hij : i = j
  · subst j
    simp [scalarState, Matrix.conjTranspose_apply]
  · simp [scalarState, Matrix.conjTranspose_apply, hij, Ne.symm hij]

/-- Von Neumann entropy as the Shannon entropy of Hermitian eigenvalues. -/
def vonNeumannEntropy (rho : Matrix n n Complex) (hrho : rho.IsHermitian) : Real :=
  ∑ i, Real.negMulLog (hrho.eigenvalues i)

/-- **TARGET 1.** Every eigenvalue of `c I` is `c`. -/
theorem scalarState_eigenvalues (c : Real) (i : n) :
    (scalarState_isHermitian (n := n) c).eigenvalues i = c := by
  sorry

/-- **TARGET 2.** The maximally mixed state attains entropy `log d`. -/
theorem maximallyMixed_entropy [Nonempty n] :
    vonNeumannEntropy
        (scalarState (n := n) (Fintype.card n : Real)⁻¹)
        (scalarState_isHermitian (n := n) (Fintype.card n : Real)⁻¹) =
      Real.log (Fintype.card n) := by
  sorry

end MaximallyMixedEntropy
