import Mathlib.Tactic

/-!
# P9 everpresent-Lambda magnitude scaling

The everpresent-Lambda prediction (Ahmed, Dodelson, Greene, Sorkin, 2002,
`astro-ph/0209274`; Ahmed-Sorkin 2012 `1210.2589`; Zwane-Afshordi-Sorkin 2017
`1703.06265`): in unimodular gravity with causal-set discreteness, the
cosmological "constant" fluctuates with vanishing mean and magnitude set by
number-volume fluctuations, `Lambda ~ delta N / V` with `delta N ~ sqrt(V)`
(Poisson), so `|Lambda| ~ 1 / sqrt(V)`, of order the ambient density at every
epoch.

This module states the finite scaling-law core: given a number fluctuation with
second moment equal to the volume `V`, the normalized `Lambda = deltaN / V` has
second moment `1/V`, i.e. RMS magnitude `1/sqrt(V)`. This connects the kernel-
checked variance-`N` fluctuation identities to the named cosmological prediction.

Standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9EverpresentLambdaScaling

/-- Normalized cosmological constant from a number fluctuation `deltaN` over a
spacetime volume `V`: `Lambda = deltaN / V`. -/
def lambdaOfFluct (deltaN V : Real) : Real := deltaN / V

/-
Everpresent-Lambda magnitude: when the number-fluctuation second moment equals
the volume, the normalized Lambda has second moment `1/V`.
-/
theorem everpresentLambda_secondMoment_eq_inv_volume
    (V deltaNSecondMoment : Real) (hV : 0 < V)
    (hpoisson : deltaNSecondMoment = V) :
    deltaNSecondMoment / V ^ 2 = 1 / V := by
  grind

/-- The RMS everpresent-Lambda magnitude is `1 / sqrt(V)`. -/
theorem everpresentLambda_rms_eq_inv_sqrt_volume
    (V : Real) (hV : 0 < V) :
    Real.sqrt (V / V ^ 2) = 1 / Real.sqrt V := by
  rw [sq, mul_comm, ← div_div, div_self hV.ne', Real.sqrt_div' 1 hV.le,
    Real.sqrt_one]

end PhysicsSM.Draft.NullEdgeP9EverpresentLambdaScaling
