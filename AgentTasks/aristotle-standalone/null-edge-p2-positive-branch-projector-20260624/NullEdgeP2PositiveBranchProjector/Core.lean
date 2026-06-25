import Mathlib

/-!
# Positive chiral branch projector

This focused finite algebra target follows the chiral Hamiltonian coherence
bridge.  Under the mass-shell hypotheses, the same positive branch whose
left/right coherence is `m/(2E)` is a genuine trace-one idempotent.
-/

noncomputable section

namespace NullEdgeP2PositiveBranchProjector

open Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/-- Positive branch `(1/2)(I + H/E)` of the two-level chiral Hamiltonian. -/
def positiveBranch (h p m E : Real) : RMat2 :=
  (1 / 2 : Real) •
    ((1 : RMat2) + E⁻¹ • chiralHamiltonian h p m)

/-- The chiral Hamiltonian squares to the scalar mass-shell block. -/
theorem chiralHamiltonian_sq_eq_massShell
    (h p m : Real) (hh : h * h = 1) :
    chiralHamiltonian h p m * chiralHamiltonian h p m =
      (p ^ 2 + m ^ 2) • (1 : RMat2) := by
  unfold chiralHamiltonian
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two] <;>
    nlinarith [hh]

/-
The positive branch is trace one.
-/
theorem positiveBranch_trace_eq_one
    (h p m E : Real) :
    Matrix.trace (positiveBranch h p m E) = 1 := by
  simp [positiveBranch, chiralHamiltonian, Matrix.trace, Matrix.diag, Fin.sum_univ_two]
  ring

/-
On the mass shell `E^2 = p^2 + m^2`, with nonzero energy, the positive branch
is an idempotent projector.
-/
theorem positiveBranch_idempotent_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    positiveBranch h p m E * positiveBranch h p m E =
      positiveBranch h p m E := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [positiveBranch, chiralHamiltonian, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply] <;>
    field_simp <;> nlinarith [hshell, hh, sq_nonneg E]

end NullEdgeP2PositiveBranchProjector

end
