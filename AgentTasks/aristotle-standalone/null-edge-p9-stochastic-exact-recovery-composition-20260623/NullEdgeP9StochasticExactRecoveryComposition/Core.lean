import Mathlib.Tactic

/-!
# P9 stochastic exact-recovery composition

Focused standalone theorem package for Aristotle.

Physics role: P9 needs an admissible observer-channel class, not unrestricted
coarse maps. Exact stochastic recovery is one sufficient admissibility
certificate. This file asks for the closure theorem: composing two exactly
recoverable observer channels is again exactly recoverable on the selected
source pair.
-/

namespace NullEdgeP9StochasticExactRecoveryComposition

open BigOperators

/-- A finite normalized probability distribution. -/
structure FinDist (Omega : Type*) [Fintype Omega] where
  p : Omega -> Real
  nonneg : forall x, 0 <= p x
  sum_one : Finset.univ.sum p = 1

namespace FinDist

/-- Finite distributions are equal when their probability functions agree. -/
theorem ext {Omega : Type*} [Fintype Omega] {d e : FinDist Omega}
    (h : forall x, d.p x = e.p x) : d = e := by
  cases d with
  | mk dp dnon dsum =>
  cases e with
  | mk ep enon esum =>
  dsimp at h
  have hp : dp = ep := funext h
  subst hp
  rfl

end FinDist

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

/-- Composition of finite stochastic channels. The channel `comp T S` first
applies `T : Omega -> Kappa`, then `S : Kappa -> Lambda`. -/
noncomputable def comp {Omega Kappa Lambda : Type*}
    [Fintype Omega] [Fintype Kappa] [Fintype Lambda]
    (T : Stoch Omega Kappa) (S : Stoch Kappa Lambda) :
    Stoch Omega Lambda where
  M := fun z x => Finset.univ.sum fun y => S.M z y * T.M y x
  nonneg := by
    intro z x
    exact Finset.sum_nonneg fun y _ => mul_nonneg (S.nonneg z y) (T.nonneg y x)
  col_sum := by
    intro x
    calc
      Finset.univ.sum (fun z =>
          Finset.univ.sum fun y => S.M z y * T.M y x)
          = Finset.univ.sum (fun y =>
              Finset.univ.sum fun z => S.M z y * T.M y x) := by
            rw [Finset.sum_comm]
      _ = Finset.univ.sum (fun y => T.M y x) := by
            refine Finset.sum_congr rfl ?_
            intro y _
            rw [<- Finset.sum_mul, S.col_sum y, one_mul]
      _ = 1 := T.col_sum x

/-- Applying a composite stochastic channel is the same as applying the two
channels successively. -/
theorem apply_comp {Omega Kappa Lambda : Type*}
    [Fintype Omega] [Fintype Kappa] [Fintype Lambda]
    (T : Stoch Omega Kappa) (S : Stoch Kappa Lambda) (d : FinDist Omega) :
    (comp T S).apply d = S.apply (T.apply d) := by
  apply FinDist.ext
  intro z
  unfold apply comp
  dsimp
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl ?_
  intro y _
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl ?_
  intro x _
  ring

end Stoch

/-- Common exact recovery for a pair of fine distributions. -/
def PairExactRecoverable {Omega Kappa : Type*}
    [Fintype Omega] [Fintype Kappa]
    (T : Stoch Omega Kappa) (p q : FinDist Omega) : Prop :=
  exists R : Stoch Kappa Omega,
    R.apply (T.apply p) = p /\ R.apply (T.apply q) = q

/--
Exact stochastic recoverability composes for a fixed source pair. If `T`
is recoverable on `p,q`, and `S` is recoverable on the already coarsened pair
`T.apply p, T.apply q`, then `Stoch.comp T S` is recoverable on `p,q`.
-/
theorem PairExactRecoverable.comp {Omega Kappa Lambda : Type*}
    [Fintype Omega] [Fintype Kappa] [Fintype Lambda]
    (T : Stoch Omega Kappa) (S : Stoch Kappa Lambda)
    (p q : FinDist Omega)
    (hT : PairExactRecoverable T p q)
    (hS : PairExactRecoverable S (T.apply p) (T.apply q)) :
    PairExactRecoverable (Stoch.comp T S) p q := by
  cases hT with
  | intro RT hTR =>
  cases hTR with
  | intro hTp hTq =>
  cases hS with
  | intro RS hSR =>
  cases hSR with
  | intro hSp hSq =>
  refine Exists.intro (Stoch.comp RS RT) ?_
  exact And.intro
    (by rw [Stoch.apply_comp, Stoch.apply_comp, hSp, hTp])
    (by rw [Stoch.apply_comp, Stoch.apply_comp, hSq, hTq])

end NullEdgeP9StochasticExactRecoveryComposition
