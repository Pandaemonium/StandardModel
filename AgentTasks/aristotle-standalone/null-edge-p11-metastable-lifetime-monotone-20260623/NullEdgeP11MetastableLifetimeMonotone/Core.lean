import Mathlib.Tactic

/-!
# P11 metastable lifetime monotonicity

For fixed positive time step, the metastable lifetime
`dt / (-log r)` should increase as the eigenvalue modulus `r` approaches one
from below.
-/

noncomputable section

namespace NullEdgeP11MetastableLifetimeMonotone

def lifetimeDenom (r : Real) : Real :=
  - Real.log r

def metastableLifetime (dt r : Real) : Real :=
  dt / lifetimeDenom r

theorem lifetimeDenom_antitone_on_unit
    (r1 r2 : Real) (hr10 : 0 < r1) (hr12 : r1 <= r2) (hr21 : r2 < 1) :
    lifetimeDenom r2 <= lifetimeDenom r1 := by
  sorry

theorem metastableLifetime_monotone_in_r
    (dt r1 r2 : Real) (hdt : 0 < dt)
    (hr10 : 0 < r1) (hr12 : r1 <= r2) (hr21 : r2 < 1) :
    metastableLifetime dt r1 <= metastableLifetime dt r2 := by
  sorry

end NullEdgeP11MetastableLifetimeMonotone
