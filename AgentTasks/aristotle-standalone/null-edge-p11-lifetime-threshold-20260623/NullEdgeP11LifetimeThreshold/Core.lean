import Mathlib.Tactic

/-!
# P11 metastable lifetime threshold

This finite inequality avoids a filter-limit statement: if the eigenvalue
modulus is closer to one than `exp(-dt/T)`, then the metastable lifetime
`dt / (-log r)` exceeds the threshold `T`.
-/

noncomputable section

namespace NullEdgeP11LifetimeThreshold

def lifetimeDenom (r : Real) : Real :=
  - Real.log r

def metastableLifetime (dt r : Real) : Real :=
  dt / lifetimeDenom r

theorem lifetime_gt_threshold_of_exp_bound
    (dt T r : Real) (hdt : 0 < dt) (hT : 0 < T)
    (hr0 : 0 < r) (hr1 : r < 1)
    (hexp : Real.exp (-(dt / T)) < r) :
    T < metastableLifetime dt r := by
  sorry

end NullEdgeP11LifetimeThreshold
