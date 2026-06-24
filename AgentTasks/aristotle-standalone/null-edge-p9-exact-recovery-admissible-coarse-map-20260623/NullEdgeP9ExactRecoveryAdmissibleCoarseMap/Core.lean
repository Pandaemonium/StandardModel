import Mathlib.Tactic

/-!
# P9 exact-recovery admissible coarse-map guardrail

This focused target packages a small finite information-theoretic guardrail for
the P9 source-visibility program.

Physics context: recent P9 finite counterexamples show that unrestricted
coarse maps can erase a local source signature.  The next useful positive
definition is therefore not "all coarse maps preserve visibility", but a named
admissible class.  This file uses a deliberately simple observer-channel
criterion: a coarse map is admissible for a pair of source distributions when
there is one common recovery map reconstructing both sources from their coarse
outputs.

Claim boundary: this is a finite exact-recovery guardrail only.  It does not
prove a cosmological-constant result, does not identify which physical
coarse-grainings are admissible, and does not claim approximate recovery.
-/

namespace NullEdgeP9ExactRecoveryAdmissibleCoarseMap

/-- A tiny finite distribution shell.  We only need the payload function for the
distinguishability theorem; normalization and positivity are intentionally
irrelevant to this exact-recovery guardrail. -/
structure FinSignal (Omega : Type*) where
  p : Omega -> Real

@[ext]
theorem FinSignal.ext {Omega : Type*} {p q : FinSignal Omega}
    (h : p.p = q.p) : p = q := by
  cases p
  cases q
  simp at h
  simp [h]

/-- A finite observer/coarse-graining channel.  This algebraic shell is a
function on signals; stochasticity hypotheses can be added later when a theorem
needs positivity or normalization. -/
structure Channel (Omega Kappa : Type*) where
  apply : FinSignal Omega -> FinSignal Kappa

/-- Composition of channels, written as first `T`, then `R`. -/
def Channel.comp {Omega Kappa Mu : Type*}
    (R : Channel Kappa Mu) (T : Channel Omega Kappa) : Channel Omega Mu where
  apply := fun x => R.apply (T.apply x)

/-- A coarse map is admissible for a pair when one common recovery map restores
both source signals from their coarse outputs. -/
def PairExactRecoverable {Omega Kappa : Type*}
    (T : Channel Omega Kappa) (p q : FinSignal Omega) : Prop :=
  exists R : Channel Kappa Omega,
    R.apply (T.apply p) = p /\ R.apply (T.apply q) = q

/-- A finite source/observer test. -/
structure Test (Omega : Type*) where
  eval : FinSignal Omega -> Real

/-- A test distinguishes two signals when it assigns different real values. -/
def Distinguishes {Omega : Type*} (test : Test Omega)
    (p q : FinSignal Omega) : Prop :=
  test.eval p = test.eval q -> False

/-- Pull a fine source test back along a recovery channel to a coarse observer
test. -/
def Test.pullback {Omega Kappa : Type*} (R : Channel Kappa Omega)
    (test : Test Omega) : Test Kappa where
  eval := fun y => test.eval (R.apply y)

/--
Exact recovery preserves pairwise distinguishability.

This is the minimal finite P9 admissibility theorem: if a single recovery map
reconstructs both source signals after coarse-graining, then the coarse outputs
cannot have been equal unless the original sources were equal.
-/
theorem exactRecovery_preserves_distinction {Omega Kappa : Type*}
    (T : Channel Omega Kappa) (p q : FinSignal Omega)
    (hrec : PairExactRecoverable T p q) (hpq : p = q -> False) :
    T.apply p = T.apply q -> False := by
  intro hcoarse
  cases hrec with
  | intro R h =>
  cases h with
  | intro hp hq =>
  apply hpq
  calc
    p = R.apply (T.apply p) := hp.symm
    _ = R.apply (T.apply q) := by rw [hcoarse]
    _ = q := hq

/-- Contrapositive form: if a coarse map erases a distinguished pair, then no
common exact recovery map can restore both sources. -/
theorem erased_distinction_not_exactRecoverable {Omega Kappa : Type*}
    (T : Channel Omega Kappa) (p q : FinSignal Omega)
    (hpq : p = q -> False) (hcoarse : T.apply p = T.apply q) :
    PairExactRecoverable T p q -> False := by
  intro hrec
  exact exactRecovery_preserves_distinction T p q hrec hpq hcoarse

/--
Exact recovery pulls every fine distinguishing test back to a coarse observer
test.

This is the more operational P9 form of admissibility: a recoverable coarse map
does not merely preserve abstract inequality of signals; it gives a concrete
observer-side test that reproduces any selected fine source test on the pair.
-/
theorem exactRecovery_pullsBack_distinguishingTest {Omega Kappa : Type*}
    (T : Channel Omega Kappa) (p q : FinSignal Omega)
    (hrec : PairExactRecoverable T p q) (test : Test Omega)
    (htest : Distinguishes test p q) :
    exists obsTest : Test Kappa,
      Distinguishes obsTest (T.apply p) (T.apply q) := by
  sorry

end NullEdgeP9ExactRecoveryAdmissibleCoarseMap
