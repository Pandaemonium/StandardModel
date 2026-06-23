import Mathlib.Tactic

/-!
# P7 observer-loss factorization

This draft module integrates Aristotle project
`3cfb5bcc-f262-45a2-8941-3151350a4617`.

It is deliberately small bookkeeping algebra for the observer-channel branch.
It does not prove that recoverability is the same as invisibility. Instead, it
separates three quantities:

* loss from a fine description to the observer output;
* additional loss after a proposed recovery map;
* the total recoverability gap from fine description to recovered description.

This is useful for P7/P9 because any future source-visibility theorem must say
which of these quantities its defect is controlled by.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7ObserverLoss

/--
Three finite information levels:
`pre` is the fine description, `observer` is after the observer channel, and
`recovered` is after applying a proposed recovery map.
-/
structure LossBookkeeping where
  pre : Real
  observer : Real
  recovered : Real

/-- Loss from coarse observer channel. -/
def observerLoss (B : LossBookkeeping) : Real :=
  B.pre - B.observer

/-- Additional loss after attempting recovery. -/
def recoveryLoss (B : LossBookkeeping) : Real :=
  B.observer - B.recovered

/-- Total recoverability gap from fine to recovered description. -/
def recoverabilityGap (B : LossBookkeeping) : Real :=
  B.pre - B.recovered

/-- Recoverability gap splits into observer loss plus post-recovery loss. -/
theorem recoverabilityGap_eq_observerLoss_plus_recoveryLoss (B : LossBookkeeping) :
    recoverabilityGap B = observerLoss B + recoveryLoss B := by
  unfold recoverabilityGap observerLoss recoveryLoss
  ring

/--
If a source-visibility defect is controlled by observer loss, and recovery does
not increase information, then it is controlled by the full recoverability gap.
-/
theorem sourceDefect_le_recoverabilityGap_of_le_observerLoss
    (B : LossBookkeeping) (defect : Real)
    (hdef : defect <= observerLoss B) (hrec : 0 <= recoveryLoss B) :
    defect <= recoverabilityGap B := by
  rw [recoverabilityGap_eq_observerLoss_plus_recoveryLoss]
  linarith

end PhysicsSM.Draft.NullEdgeP7ObserverLoss
