import Mathlib
import PhysicsSM.NullStrand.BellQFT.FiniteCurrent

/-!
# NullStrand.Graph.BellSupport

Graph-level support predicate for Bell operators and its transfer to current support.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Graph

open scoped BigOperators
open Matrix Complex
open PhysicsSM.NullStrand.BellQFT

/-- Configuration-level null-continuation relation. -/
abbrev IsNullContinuation {Q : Type*} (R : Q → Q → Prop) (q q' : Q) : Prop := R q q'

/-- Operator support restricted to null continuations. -/
def SupportedOnNullContinuations
    {Q : Type*} [Fintype Q] (R : Q → Q → Prop) (P : Q → Matrix Q Q Complex) (D : Matrix Q Q Complex) :
    Prop :=
  ∀ q q', ¬ IsNullContinuation R q q' → P q * D * P q' = 0

/-- Vanishing support gives vanishing current. -/
theorem operatorSupport_zero_of_not_continuation
    {Q : Type*} [Fintype Q] (R : Q → Q → Prop) (P : Q → Matrix Q Q Complex)
    (D : Matrix Q Q Complex) (ψ : Q → Complex) (q q' : Q)
    (hD : SupportedOnNullContinuations (Q := Q) R P D)
    (hno : ¬ IsNullContinuation R q q') :
    quantumCurrent q q' ψ D P = 0 := by
  exact quantumCurrent_zero_of_block_zero (q := q) (q' := q') (psi := ψ) (H := D) (P := P)
    (hblock := hD q q' hno)

/-- If current is nonzero, the labels are related by a null continuation. -/
theorem operatorSupport_implies_bellCurrentSupport
    {Q : Type*} [Fintype Q] (R : Q → Q → Prop) (P : Q → Matrix Q Q Complex)
    (D : Matrix Q Q Complex) (ψ : Q → Complex) (q q' : Q)
    (hD : SupportedOnNullContinuations (Q := Q) R P D) :
    quantumCurrent q q' ψ D P ≠ 0 → IsNullContinuation R q q' := by
  intro hcur
  by_contra hno
  exact hcur (operatorSupport_zero_of_not_continuation (Q := Q) (R := R) (P := P) (D := D) (ψ := ψ)
    (q := q) (q' := q') hD hno)

/-- Immediate consequence used by Bell-rate formulations: every nonzero current is null-supported. -/
theorem minimalBellHistories_supportedOnNullContinuations
    {Q : Type*} [Fintype Q] (R : Q → Q → Prop) (P : Q → Matrix Q Q Complex)
    (D : Matrix Q Q Complex) (ψ : Q → Complex) (q q' : Q)
    (hD : SupportedOnNullContinuations (Q := Q) R P D) :
    quantumCurrent q q' ψ D P ≠ 0 → IsNullContinuation R q q' := by
  exact operatorSupport_implies_bellCurrentSupport (Q := Q) (R := R) (P := P) (D := D) (ψ := ψ)
    (q := q) (q' := q') hD

end PhysicsSM.NullStrand.Graph
