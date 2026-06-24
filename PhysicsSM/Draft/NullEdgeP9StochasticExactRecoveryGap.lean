import PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback

/-!
# P9 stochastic exact-recovery gap preservation

This draft module sharpens the stochastic exact-recovery observable-pullback
theorem from qualitative distinction to quantitative gap preservation.

If a coarse observer channel has a common exact stochastic recovery for two
fine source distributions, then any fine observable has a pulled-back coarse
observable with exactly the same expectation gap on that source pair.

Claim boundary: this is exact finite stochastic bookkeeping. It does not prove
approximate recovery, does not characterize all physically admissible coarse
maps, and does not by itself prove cosmological source suppression.
-/

namespace PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback

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
  cases hrec with
  | intro R h =>
  cases h with
  | intro hp hq =>
  refine Exists.intro (pullbackObservable R f) ?_
  rw [expect_pullbackObservable_eq_expect_recovered]
  rw [expect_pullbackObservable_eq_expect_recovered]
  rw [hp, hq]

end PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback
