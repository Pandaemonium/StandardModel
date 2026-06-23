import Mathlib.Tactic

/-!
# P11 metastable log lifetime algebra

For a metastable eigenvalue with modulus `0 < r < 1`, the denominator
`-log r` in the lifetime formula is positive. This is the smallest clean
spectral-sector theorem behind `tau = Delta t / (-log |lambda|)`.
-/

noncomputable section

namespace NullEdgeP11MetastableLogLifetime

def lifetimeDenom (r : Real) : Real :=
  - Real.log r

def metastableLifetime (dt r : Real) : Real :=
  dt / lifetimeDenom r

theorem lifetimeDenom_pos_of_lt_one (r : Real) (hr0 : 0 < r) (hr1 : r < 1) :
    0 < lifetimeDenom r := by
  sorry

theorem metastableLifetime_pos
    (dt r : Real) (hdt : 0 < dt) (hr0 : 0 < r) (hr1 : r < 1) :
    0 < metastableLifetime dt r := by
  sorry

end NullEdgeP11MetastableLogLifetime
