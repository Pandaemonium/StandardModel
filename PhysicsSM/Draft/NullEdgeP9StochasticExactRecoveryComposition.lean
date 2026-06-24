import PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback

/-!
# P9 stochastic exact-recovery composition

This draft module extends the finite stochastic exact-recovery guardrail with a
closure theorem. Exact stochastic recovery is meant as one sufficient
admissibility certificate for P9 observer channels. To be usable as a class of
observer channels, it should compose.

The main theorem proves that if `T : Omega -> Kappa` is exactly recoverable on a
fixed source pair `p,q`, and `S : Kappa -> Lambda` is exactly recoverable on the
already-coarsened pair `T.apply p, T.apply q`, then the composite channel is
exactly recoverable on `p,q`.

Claim boundary: this is exact finite stochastic bookkeeping. It does not prove
approximate recovery, does not characterize all physically admissible coarse
maps, and does not by itself prove cosmological source suppression.
-/

namespace PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback

open BigOperators

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

namespace Stoch

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

end PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback
