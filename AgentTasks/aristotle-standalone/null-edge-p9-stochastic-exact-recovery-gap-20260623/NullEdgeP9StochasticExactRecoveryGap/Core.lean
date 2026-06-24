import Mathlib.Tactic

/-!
# P9 stochastic exact-recovery gap preservation

Focused standalone theorem package for Aristotle.

Physics role: the previous stochastic exact-recovery theorem shows that a fine
observable distinction pulls back to a coarse distinction. This target asks for
the sharper quantitative statement: the actual expectation gap is preserved by
the pulled-back observable under common exact recovery.
-/

namespace NullEdgeP9StochasticExactRecoveryGap

open BigOperators

/-- A finite normalized probability distribution. -/
structure FinDist (Omega : Type*) [Fintype Omega] where
  p : Omega -> Real
  nonneg : forall x, 0 <= p x
  sum_one : Finset.univ.sum p = 1

/-- A column-stochastic finite observer channel, acting from `Omega` to
`Kappa`. -/
structure Stoch (Omega Kappa : Type*) [Fintype Omega] [Fintype Kappa] where
  M : Kappa -> Omega -> Real
  nonneg : forall y x, 0 <= M y x
  col_sum : forall x, Finset.univ.sum (fun y => M y x) = 1

namespace Stoch

/-- Push a distribution through a stochastic channel. -/
noncomputable def apply {Omega Kappa : Type*}
    [Fintype Omega] [Fintype Kappa]
    (T : Stoch Omega Kappa) (d : FinDist Omega) : FinDist Kappa where
  p := fun y => Finset.univ.sum fun x => T.M y x * d.p x
  nonneg := by
    intro y
    exact Finset.sum_nonneg fun x _ => mul_nonneg (T.nonneg y x) (d.nonneg x)
  sum_one := by
    calc
      Finset.univ.sum (fun y => Finset.univ.sum fun x => T.M y x * d.p x)
          = Finset.univ.sum (fun x => Finset.univ.sum fun y => T.M y x * d.p x) := by
            rw [Finset.sum_comm]
      _ = Finset.univ.sum (fun x => d.p x) := by
            refine Finset.sum_congr rfl ?_
            intro x _
            rw [<- Finset.sum_mul, T.col_sum x, one_mul]
      _ = 1 := d.sum_one

end Stoch

/-- Expected value of a finite observable. -/
def expect {Omega : Type*} [Fintype Omega]
    (f : Omega -> Real) (d : FinDist Omega) : Real :=
  Finset.univ.sum fun x => f x * d.p x

/-- Pull a fine observable back along a recovery channel. -/
def pullbackObservable {Omega Kappa : Type*}
    [Fintype Omega] [Fintype Kappa]
    (R : Stoch Kappa Omega) (f : Omega -> Real) : Kappa -> Real :=
  fun y => Finset.univ.sum fun x => R.M x y * f x

/-- Common exact recovery for a pair of fine distributions. -/
def PairExactRecoverable {Omega Kappa : Type*}
    [Fintype Omega] [Fintype Kappa]
    (T : Stoch Omega Kappa) (p q : FinDist Omega) : Prop :=
  exists R : Stoch Kappa Omega,
    R.apply (T.apply p) = p /\ R.apply (T.apply q) = q

/-- Pullback expectation agrees with recovered expectation. -/
theorem expect_pullbackObservable_eq_expect_recovered {Omega Kappa : Type*}
    [Fintype Omega] [Fintype Kappa]
    (R : Stoch Kappa Omega) (f : Omega -> Real) (d : FinDist Kappa) :
    expect (pullbackObservable R f) d = expect f (R.apply d) := by
  unfold expect pullbackObservable Stoch.apply
  dsimp
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl ?_
  intro x _
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl ?_
  intro y _
  ring

/--
Under common exact recovery, the pulled-back coarse observable preserves the
exact expectation gap of the fine observable on the selected source pair.
-/
theorem exactRecovery_preserves_observableGap
    {Omega Kappa : Type*} [Fintype Omega] [Fintype Kappa]
    (T : Stoch Omega Kappa) (p q : FinDist Omega)
    (hrec : PairExactRecoverable T p q) (f : Omega -> Real) :
    exists g : Kappa -> Real,
      expect g (T.apply p) - expect g (T.apply q) =
        expect f p - expect f q := by
  obtain ⟨R, hp, hq⟩ := hrec
  refine ⟨pullbackObservable R f, ?_⟩
  rw [expect_pullbackObservable_eq_expect_recovered,
      expect_pullbackObservable_eq_expect_recovered, hp, hq]

end NullEdgeP9StochasticExactRecoveryGap
