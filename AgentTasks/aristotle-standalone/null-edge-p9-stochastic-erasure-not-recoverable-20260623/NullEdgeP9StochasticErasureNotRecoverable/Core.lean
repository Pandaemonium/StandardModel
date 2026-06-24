import Mathlib.Tactic

/-!
# P9 stochastic erasure is not exactly recoverable

Focused standalone theorem package for Aristotle.

Physics role: exact stochastic recovery is a sufficient admissibility
certificate for P9 observer channels. This target proves the matching no-go
guardrail: if a channel sends two fine source distributions to the same coarse
distribution, then it cannot be exactly recoverable for that source pair unless
the sources were already equal.
-/

namespace NullEdgeP9StochasticErasureNotRecoverable

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

/-- Common exact recovery for a pair of fine distributions. -/
def PairExactRecoverable {Omega Kappa : Type*}
    [Fintype Omega] [Fintype Kappa]
    (T : Stoch Omega Kappa) (p q : FinDist Omega) : Prop :=
  exists R : Stoch Kappa Omega,
    R.apply (T.apply p) = p /\ R.apply (T.apply q) = q

/--
If a stochastic channel erases a genuinely distinct source pair by sending both
sources to the same coarse distribution, then it is not exactly recoverable for
that pair.
-/
theorem erased_pair_not_exactRecoverable {Omega Kappa : Type*}
    [Fintype Omega] [Fintype Kappa]
    (T : Stoch Omega Kappa) (p q : FinDist Omega)
    (herase : T.apply p = T.apply q) (hneq : p = q -> False) :
    PairExactRecoverable T p q -> False := by
  rintro ⟨R, hp, hq⟩
  apply hneq
  rw [← hp, ← hq, herase]

end NullEdgeP9StochasticErasureNotRecoverable
