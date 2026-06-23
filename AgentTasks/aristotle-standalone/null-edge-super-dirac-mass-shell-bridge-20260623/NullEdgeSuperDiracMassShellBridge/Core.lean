import Mathlib

/-!
# NullEdgeSuperDiracMassShellBridge.Core

Focused Aristotle target for the no-double-count mass-shell bridge.

The corrected conjecture says:

* the kinetic graph Dirac block has symbol `det(P)`;
* the Higgs/Yukawa block has square `Phi^dagger Phi`;
* on shell these are equal;
* they must not be added as two separate mass terms.
-/

noncomputable section

namespace NullEdgeSuperDiracMassShellBridge

open Matrix Complex

variable {Idx : Type*} [Fintype Idx] [DecidableEq Idx]

/-- Record equality of the kinetic Pluecker symbol and the Yukawa square. -/
def MassShellConstraint (kineticPlucker yukawaSq : Complex) : Prop :=
  kineticPlucker = yukawaSq

/-- A kinetic square with symbol `kineticPlucker` rewrites to the Yukawa square
on shell. -/
theorem kinetic_square_rewrites_to_yukawa_on_massShell
    (D : Matrix Idx Idx Complex) (kineticPlucker yukawaSq : Complex)
    (hD : D * D = kineticPlucker • (1 : Matrix Idx Idx Complex))
    (hShell : MassShellConstraint kineticPlucker yukawaSq) :
    D * D = yukawaSq • (1 : Matrix Idx Idx Complex) := by
  sorry

/-- Adding the kinetic and Yukawa terms would double-count a nonzero mass square.
-/
theorem adding_kinetic_and_yukawa_doubleCounts_of_nonzero
    (kineticPlucker yukawaSq : Complex)
    (hShell : MassShellConstraint kineticPlucker yukawaSq)
    (hkin : kineticPlucker != 0) :
    kineticPlucker + yukawaSq != kineticPlucker := by
  sorry

/-- The correct on-shell replacement is equality, not an additive contribution.
-/
theorem noDoubleCount_laplacianSymbol_plusYukawa_is_constraint_not_sum
    (kineticPlucker yukawaSq : Complex)
    (hShell : MassShellConstraint kineticPlucker yukawaSq) :
    kineticPlucker = yukawaSq := by
  sorry

/-- A scalar Yukawa flip block has the same square as the kinetic symbol exactly
when the mass-shell constraint holds. -/
theorem scalarYukawaSq_eq_kineticSymbol_iff_massShell
    (m kineticPlucker : Complex) :
    MassShellConstraint kineticPlucker (m * m) <-> kineticPlucker = m * m := by
  sorry

end NullEdgeSuperDiracMassShellBridge

end
