import Mathlib.Tactic

/-!
# P11 metastable lifetime threshold

This finite inequality avoids a filter-limit statement: if the eigenvalue
modulus is closer to one than `exp(-dt/T)`, then the metastable lifetime
`dt / (-log r)` exceeds the threshold `T`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP11LifetimeThreshold

def lifetimeDenom (r : Real) : Real :=
  - Real.log r

def metastableLifetime (dt r : Real) : Real :=
  dt / lifetimeDenom r

theorem lifetime_gt_threshold_of_exp_bound
    (dt T r : Real) (_hdt : 0 < dt) (hT : 0 < T)
    (hr0 : 0 < r) (hr1 : r < 1)
    (hexp : Real.exp (-(dt / T)) < r) :
    T < metastableLifetime dt r := by
  rw [ metastableLifetime, lt_div_iff₀ ];
  · unfold lifetimeDenom;
    nlinarith [Real.log_exp ( - ( dt / T ) ),
      Real.log_lt_log ( by positivity ) hexp, mul_div_cancel₀ dt hT.ne' ];
  · exact neg_pos_of_neg ( Real.log_neg hr0 hr1 )

end PhysicsSM.Draft.NullEdgeP11LifetimeThreshold
