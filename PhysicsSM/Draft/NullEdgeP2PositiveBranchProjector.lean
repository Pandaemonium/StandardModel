import Mathlib

/-!
# Draft.NullEdgeP2PositiveBranchProjector

Finite positive-branch projector certification for the two-level chiral
Hamiltonian used in the null-edge P2/P4/P7 bridge.

The previous chiral-coherence module proves that

`H_h(p,m) = [[-h p, m], [m, h p]]`

squares to the mass-shell scalar and that the positive branch
`(1/2)(I + H/E)` has left/right coherence `m/(2E)`.  This module proves that
the same branch is trace one and, on shell with nonzero energy, idempotent.
Thus the coherence scalar belongs to an actual finite branch projector rather
than an arbitrary matrix entry.

This is finite `2 x 2` matrix algebra only.  It does not prove a continuum
Dirac limit or a Lorentz-covariant quantum-walk theorem.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP2PositiveBranchProjector

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

/-- The positive branch is trace one. -/
theorem positiveBranch_trace_eq_one
    (h p m E : Real) :
    Matrix.trace (positiveBranch h p m E) = 1 := by
  simp [positiveBranch, chiralHamiltonian, Matrix.trace, Matrix.diag, Fin.sum_univ_two]
  ring

/--
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

end PhysicsSM.Draft.NullEdgeP2PositiveBranchProjector

end
