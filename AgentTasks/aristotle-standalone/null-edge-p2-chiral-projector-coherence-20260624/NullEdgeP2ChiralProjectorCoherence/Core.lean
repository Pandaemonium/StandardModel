import Mathlib

/-!
# Chiral Hamiltonian projector coherence

This focused finite algebra target supports the null-edge P2/P4/P7 bridge.
It isolates the two-level chiral Hamiltonian

`H_h(p,m) = [[-h p, m], [m, h p]]`

whose off-diagonal scalar is the Higgs/Yukawa mass entry and whose square is the
mass-shell scalar `(p^2 + m^2) I` when `h^2 = 1`.  The positive-branch projector
then has left/right coherence `m/(2E)`, so the squared coherence is the
observer-channel mass ratio `m^2/(4E^2)`.
-/

noncomputable section

namespace NullEdgeP2ChiralProjectorCoherence

open Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/--
Positive-branch algebraic projector-like matrix.  When
`E^2 = p^2 + m^2` and `E != 0`, this is the usual `(1/2)(I + H/E)`.
-/
def positiveBranch (h p m E : Real) : RMat2 :=
  (1 / 2 : Real) •
    ((1 : RMat2) + E⁻¹ • chiralHamiltonian h p m)

/-
The chiral Hamiltonian squares to the scalar mass-shell block.
-/
theorem chiralHamiltonian_sq_eq_massShell
    (h p m : Real) (hh : h * h = 1) :
    chiralHamiltonian h p m * chiralHamiltonian h p m =
      (p ^ 2 + m ^ 2) • (1 : RMat2) := by
  unfold chiralHamiltonian
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two] <;>
    nlinarith [hh]

/-- The left/right coherence entry of the positive branch is `m/(2E)`. -/
theorem positiveBranch_leftRight_eq_mass_over_two_energy
    (h p m E : Real) :
    positiveBranch h p m E 0 1 = m / (2 * E) := by
  simp [positiveBranch, chiralHamiltonian]
  ring

/--
Squared left/right coherence is the mass-ratio scalar `m^2/(4E^2)`.

This is the finite two-level bridge from a first-order chiral mass operator to
the observer-channel `m/E` readout used in the null-edge publication plan.
-/
theorem positiveBranch_leftRight_sq_eq_massRatioSq
    (h p m E : Real) :
    (positiveBranch h p m E 0 1) ^ 2 = m ^ 2 / (4 * E ^ 2) := by
  rw [positiveBranch_leftRight_eq_mass_over_two_energy]; ring

end NullEdgeP2ChiralProjectorCoherence

end
