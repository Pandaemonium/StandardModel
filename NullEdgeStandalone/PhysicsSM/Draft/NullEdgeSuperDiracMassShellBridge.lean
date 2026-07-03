import Mathlib

/-!
# Draft.NullEdgeSuperDiracMassShellBridge

Finite no-double-count bridge for the corrected super-Dirac conjecture.

The kinetic graph Dirac block has symbol `det(P)`, while the Higgs/Yukawa block
has square `Phi^dagger Phi`.  On shell these are equal; they should not be
added as two separate mass-square contributions.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeSuperDiracMassShellBridge

open Matrix Complex

variable {Idx : Type*} [Fintype Idx] [DecidableEq Idx]

/-- Record equality of the kinetic Pluecker symbol and the Yukawa square. -/
def MassShellConstraint (kineticPlucker yukawaSq : Complex) : Prop :=
  kineticPlucker = yukawaSq

/-- A kinetic square with symbol `kineticPlucker` rewrites to the Yukawa square on shell. -/
theorem kinetic_square_rewrites_to_yukawa_on_massShell
    (D : Matrix Idx Idx Complex) (kineticPlucker yukawaSq : Complex)
    (hD : D * D = kineticPlucker • (1 : Matrix Idx Idx Complex))
    (hShell : MassShellConstraint kineticPlucker yukawaSq) :
    D * D = yukawaSq • (1 : Matrix Idx Idx Complex) := by
  unfold MassShellConstraint at hShell
  rw [← hShell]
  exact hD

/-- Adding the kinetic and Yukawa terms would double-count a nonzero mass square. -/
theorem adding_kinetic_and_yukawa_doubleCounts_of_nonzero
    (kineticPlucker yukawaSq : Complex)
    (hShell : MassShellConstraint kineticPlucker yukawaSq)
    (hkin : kineticPlucker != 0) :
    kineticPlucker + yukawaSq != kineticPlucker := by
  unfold MassShellConstraint at hShell
  subst hShell
  simp only [bne_iff_ne, ne_eq] at *
  intro h
  apply hkin
  linear_combination h

/-- The correct on-shell replacement is equality, not an additive contribution. -/
theorem noDoubleCount_laplacianSymbol_plusYukawa_is_constraint_not_sum
    (kineticPlucker yukawaSq : Complex)
    (hShell : MassShellConstraint kineticPlucker yukawaSq) :
    kineticPlucker = yukawaSq := by
  exact hShell

/--
A scalar Yukawa flip block has the same square as the kinetic symbol exactly
when the mass-shell constraint holds.
-/
theorem scalarYukawaSq_eq_kineticSymbol_iff_massShell
    (m kineticPlucker : Complex) :
    MassShellConstraint kineticPlucker (m * m) <-> kineticPlucker = m * m :=
  Iff.rfl

end PhysicsSM.Draft.NullEdgeSuperDiracMassShellBridge

end
