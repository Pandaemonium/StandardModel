import Mathlib.Tactic

/-!
# P7 recoverability is not source invisibility

This toy finite API keeps two predicates separate: a source may be recoverable
under a chosen observer bookkeeping notion without being invisible to a specified
source test. The point is not the toy `Recoverable` predicate itself; the point
is to make future P7/P9 definitions state the source test explicitly.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7RecoverabilityInvisibilitySeparation

open BigOperators

/-- A deliberately separate recoverability predicate for an observer channel. -/
def Recoverable {N : Nat} (_source : Fin N -> Real) : Prop := True

/-- Invisibility to the constant source test. -/
def ConstantInvisible {N : Nat} (source : Fin N -> Real) : Prop :=
  Finset.univ.sum source = 0

/--
Recoverability, by itself, does not imply source invisibility.

This is a toy finite guardrail for P7/P9: source invisibility must be connected
to a specified source test, not inferred merely from a recoverability label.
-/
theorem recoverable_not_imply_constantInvisible :
    ∃ source : Fin 1 -> Real,
      Recoverable source ∧ Not (ConstantInvisible source) := by
  exact ⟨fun _ => 1, trivial, by norm_num [ConstantInvisible]⟩

end PhysicsSM.Draft.NullEdgeP7RecoverabilityInvisibilitySeparation
