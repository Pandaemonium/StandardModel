import Mathlib

/-!
# Draft.NullEdgeP2BranchResolution

Finite positive/negative branch resolution for the two-level chiral Hamiltonian.

This module extends the positive-branch projector certification with the
negative branch

`P- = (1/2)(I - H/E)`.

On the mass shell, the two branches are trace-one idempotents, resolve the
identity, are mutually orthogonal, and reconstruct the finite Hamiltonian by

`E • (P+ - P-) = H`.

The spectral reconstruction identity is the compact finite precursor to a
null-step walk coin/reflection operator and to the two-sheet super-Dirac branch
interpretation.  This is finite `2 x 2` matrix algebra only.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP2BranchResolution

open Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/-- Positive branch `(1/2)(I + H/E)` of the two-level chiral Hamiltonian. -/
def positiveBranch (h p m E : Real) : RMat2 :=
  (1 / 2 : Real) •
    ((1 : RMat2) + E⁻¹ • chiralHamiltonian h p m)

/-- Negative branch `(1/2)(I - H/E)` of the two-level chiral Hamiltonian. -/
def negativeBranch (h p m E : Real) : RMat2 :=
  (1 / 2 : Real) •
    ((1 : RMat2) - E⁻¹ • chiralHamiltonian h p m)

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

/-- The positive branch is trace one. -/
theorem positiveBranch_trace_eq_one
    (h p m E : Real) :
    Matrix.trace (positiveBranch h p m E) = 1 := by
  simp [positiveBranch, chiralHamiltonian, Matrix.trace, Matrix.diag, Fin.sum_univ_two]
  ring

/-- The negative branch is trace one. -/
theorem negativeBranch_trace_eq_one
    (h p m E : Real) :
    Matrix.trace (negativeBranch h p m E) = 1 := by
  simp [negativeBranch, chiralHamiltonian, Matrix.trace, Matrix.diag, Fin.sum_univ_two]
  ring

/-- Positive and negative branches resolve the identity. -/
theorem positive_add_negative_eq_one
    (h p m E : Real) :
    positiveBranch h p m E + negativeBranch h p m E = (1 : RMat2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [positiveBranch, negativeBranch, chiralHamiltonian,
      Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply] <;>
    ring

/--
The positive branch is idempotent on shell.  Included here so the branch
resolution package is self-contained.
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

/-- The negative branch is idempotent on shell. -/
theorem negativeBranch_idempotent_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    negativeBranch h p m E * negativeBranch h p m E =
      negativeBranch h p m E := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [negativeBranch, chiralHamiltonian, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply] <;>
    field_simp <;> nlinarith [hshell, hh, sq_nonneg E]

/-- Positive followed by negative branch vanishes on shell. -/
theorem positive_mul_negative_eq_zero_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    positiveBranch h p m E * negativeBranch h p m E = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [positiveBranch, negativeBranch, chiralHamiltonian, Matrix.mul_apply,
      Fin.sum_univ_two, Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply,
      Matrix.one_apply] <;>
    field_simp <;> nlinarith [hshell, hh, sq_nonneg E]

/-- Negative followed by positive branch vanishes on shell. -/
theorem negative_mul_positive_eq_zero_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    negativeBranch h p m E * positiveBranch h p m E = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [positiveBranch, negativeBranch, chiralHamiltonian, Matrix.mul_apply,
      Fin.sum_univ_two, Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply,
      Matrix.one_apply] <;>
    field_simp <;> nlinarith [hshell, hh, sq_nonneg E]

/-- Spectral reconstruction of the Hamiltonian from the two branch projectors. -/
theorem spectral_reconstruction
    (h p m E : Real) (hE0 : E ≠ 0) :
    E • (positiveBranch h p m E - negativeBranch h p m E) =
      chiralHamiltonian h p m := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [positiveBranch, negativeBranch, chiralHamiltonian,
      Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply] <;>
    field_simp <;> ring

end PhysicsSM.Draft.NullEdgeP2BranchResolution

end
