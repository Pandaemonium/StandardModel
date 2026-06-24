import PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback

/-!
# P9 stochastic erasure is not exactly recoverable

This draft module supplies the no-go side of the exact-recovery admissible
observer-channel story. If a stochastic observer channel sends two genuinely
distinct fine source distributions to the same coarse output, then it cannot
have a common exact recovery for that source pair.

Claim boundary: this excludes fully erased separated pairs from the exact
recovery class. It does not characterize all nonrecoverable maps, does not
prove approximate no-go bounds, and does not by itself prove cosmological
source suppression.
-/

namespace PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback

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
  intro hrec
  cases hrec with
  | intro R h =>
  cases h with
  | intro hp hq =>
  apply hneq
  rw [<- hp, <- hq, herase]

end PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback
