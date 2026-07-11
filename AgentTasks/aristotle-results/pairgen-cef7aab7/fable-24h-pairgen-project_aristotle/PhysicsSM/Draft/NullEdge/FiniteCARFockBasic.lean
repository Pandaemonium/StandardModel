import Mathlib

/-!
# A generic finite CAR (canonical anticommutation relation) Fock algebra

Clean-room occupation-basis reconstruction of the finite fermionic Fock space
used by the phase-sensitive Pluecker quartic interaction.  A Fock vector is a
complex amplitude attached to every occupation subset of the mode index type.
Creation and annihilation operators carry the Jordan–Wigner ordering sign so
that the canonical anticommutation relations hold.

Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

open scoped BigOperators

/-- The finite occupation-basis Fock space over a mode index type `α`:
a complex amplitude for every occupation subset. -/
abbrev Fock (α : Type*) := Finset α → Complex

variable {α : Type*} [DecidableEq α] [LinearOrder α]

/-- The number of already-occupied modes lying below `i` in the order,
i.e. the Jordan–Wigner exponent. -/
def belowCount (i : α) (S : Finset α) : ℕ :=
  (S.filter (fun j => j < i)).card

/-- The Jordan–Wigner sign attached to acting at mode `i` on occupation `S`. -/
def opSign (i : α) (S : Finset α) : Complex :=
  (-1) ^ belowCount i S

/-- Fermionic creation operator at mode `i`. -/
def create (i : α) (psi : Fock α) : Fock α :=
  fun S => if i ∈ S then opSign i (S.erase i) * psi (S.erase i) else 0

/-- Fermionic annihilation operator at mode `i`. -/
def annihilate (i : α) (psi : Fock α) : Fock α :=
  fun S => if i ∈ S then 0 else opSign i S * psi (insert i S)

end PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
