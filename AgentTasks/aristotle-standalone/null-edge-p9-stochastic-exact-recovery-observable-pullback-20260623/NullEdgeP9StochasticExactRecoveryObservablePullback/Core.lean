import Mathlib.Tactic

/-!
# P9 stochastic exact-recovery observable pullback

Focused proof target for the null-edge P9 source-visibility program.

The previous exact-recovery guardrail used an algebraic channel shell.  This
target adds the missing finite stochastic hypotheses: normalized finite
distributions and column-stochastic observer channels.  The intended theorem is
that common exact recovery pulls any fine observable that distinguishes two
source distributions back to a coarse observable distinguishing their coarse
observer outputs.

Claim boundary: this is still exact finite recovery, not approximate recovery
and not a physical cosmological-constant theorem.
-/

namespace NullEdgeP9StochasticExactRecoveryObservablePullback

open BigOperators

/-- A finite normalized probability distribution. -/
structure FinDist (Omega : Type*) [Fintype Omega] where
  p : Omega -> Real
  nonneg : forall x, 0 <= p x
  sum_one : Finset.univ.sum p = 1

/-- A column-stochastic finite observer channel, acting from `Omega` to `Kappa`. -/
structure Stoch (Omega Kappa : Type*) [Fintype Omega] [Fintype Kappa] where
  M : Kappa -> Omega -> Real
  nonneg : forall y x, 0 <= M y x
  col_sum : forall x, Finset.univ.sum (fun y => M y x) = 1

/-- Push a distribution through a stochastic channel. -/
noncomputable def Stoch.apply {Omega Kappa : Type*}
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
If a common exact recovery map restores both fine distributions, then every fine
observable distinguishing them pulls back to a coarse observable distinguishing
their coarse outputs.
-/
theorem exactRecovery_pullsBack_distinguishingObservable
    {Omega Kappa : Type*} [Fintype Omega] [Fintype Kappa]
    (T : Stoch Omega Kappa) (p q : FinDist Omega)
    (hrec : PairExactRecoverable T p q) (f : Omega -> Real)
    (hf : expect f p = expect f q -> False) :
    exists g : Kappa -> Real,
      expect g (T.apply p) = expect g (T.apply q) -> False := by
  cases hrec with
  | intro R h =>
  cases h with
  | intro hp hq =>
  refine Exists.intro (pullbackObservable R f) ?_
  intro hcoarse
  apply hf
  rw [<- hp, <- hq]
  rw [<- expect_pullbackObservable_eq_expect_recovered R f (T.apply p)]
  rw [<- expect_pullbackObservable_eq_expect_recovered R f (T.apply q)]
  exact hcoarse

end NullEdgeP9StochasticExactRecoveryObservablePullback
