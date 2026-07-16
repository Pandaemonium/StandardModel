import PhysicsSM.Draft.NullEdge.GeneralQuantumKlein
import PhysicsSM.Draft.NullEdge.ScalarKleinEqualityCore

/-!
# Equality in the general noncommuting quantum Klein inequality

Focused Aristotle target.  `GeneralQuantumKlein.qKlein_nonneg` proves
nonnegativity of the CFC-free finite-dimensional quantum relative entropy.
`ScalarKleinEqualityCore.scalar_klein_eq` now proves the strict scalar
doubly-stochastic equality condition.  This target reconstructs the matrix
equality case, including degenerate eigenspaces.

The key intermediate statement is basis-independent: equality forces the
two-basis overlap to intertwine the two eigenvalue diagonals.  Combined with
the two spectral decompositions, that gives `rho = sigma` without requiring
the overlap itself to be a permutation inside degenerate eigenspaces.
-/

noncomputable section

open Matrix
open scoped BigOperators ComplexOrder

namespace PhysicsSM.Draft.NullEdge.GeneralQuantumKleinEquality

open GeneralQuantumKlein
open ScalarKleinEqualityCore

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Change-of-eigenbasis matrix from `rho` coordinates to `sigma`
coordinates. -/
def overlap (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian) :
    Matrix n n Complex :=
  (hrho.eigenvectorUnitary : Matrix n n Complex)ᴴ *
    (hsigma.eigenvectorUnitary : Matrix n n Complex)

/-- Vanishing relative entropy forces the overlap to connect only equal
eigenvalues, equivalently to intertwine the two spectral diagonals. -/
theorem overlap_intertwines_of_qRelEntropy_eq_zero
    (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrhoPsd : rho.PosSemidef) (hsigmaPd : sigma.PosDef)
    (hrhoTrace : rho.trace = 1) (hsigmaTrace : sigma.trace = 1)
    (hzero : qRelEntropy rho sigma hrho hsigma = 0) :
    diagonal (fun i => (hrho.eigenvalues i : Complex)) *
        overlap rho sigma hrho hsigma =
      overlap rho sigma hrho hsigma *
        diagonal (fun j => (hsigma.eigenvalues j : Complex)) := by
  sorry

/-- **General quantum Klein equality capstone.** For an arbitrary finite
density matrix and a positive-definite reference density matrix, quantum
relative entropy vanishes exactly when the states coincide. -/
theorem qKlein_eq_zero_iff
    (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrhoPsd : rho.PosSemidef) (hsigmaPd : sigma.PosDef)
    (hrhoTrace : rho.trace = 1) (hsigmaTrace : sigma.trace = 1) :
    qRelEntropy rho sigma hrho hsigma = 0 <-> rho = sigma := by
  sorry

/-- Strictness control: distinct admissible states have strictly positive
quantum relative entropy. -/
theorem qKlein_pos_of_ne
    (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrhoPsd : rho.PosSemidef) (hsigmaPd : sigma.PosDef)
    (hrhoTrace : rho.trace = 1) (hsigmaTrace : sigma.trace = 1)
    (hne : rho != sigma) :
    0 < qRelEntropy rho sigma hrho hsigma := by
  sorry

end PhysicsSM.Draft.NullEdge.GeneralQuantumKleinEquality
