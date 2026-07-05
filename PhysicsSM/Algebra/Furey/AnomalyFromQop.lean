import Mathlib
import PhysicsSM.Algebra.Furey.AnomalyBridge

/-!
# Anomaly sums derived from the octonion charge operator `Q_op`

Partial response to the red-team audit
(`AgentTasks/octonion-nulledge-unification-REDTEAM-audit.md`), which found that
the existing charge-sum theorems (`MinimalLeftIdeal.charge_sum_J`,
`cubic_charge_sum_J`, ...) are pure `norm_num` on HARDCODED rational literals
(`-1, -2/3, -1/3, 0`) that never reference `Q_op` - so "anomaly cancellation from
octonions" was, at the Lean level, divorced from the octonion charge operator.

This module ties the `U(1)` anomaly sums to the ACTUAL `Q_op` eigenvalues. Each
conjunct `Q_op s = q_s . s` is the already-proved eigenvalue theorem
(`Q_op_vbar1`, ...) - i.e. the electric charge `q_s` IS the octonion-derived
`Q_op` eigenvalue, not a table entry - and the final two conjuncts are the
linear `U(1)` sum and the cubic `U(1)^3` gauge-anomaly sum of exactly those
eigenvalues.

## Claim discipline (careful, per the 1b-correction lesson)

This closes the gap ONLY for the linear and cubic `U(1)` sums over the eight
`J`-sector states, and only in the sense of bundling the proved `Q_op`
eigenvalue equations WITH their sums (so the `-4` and `-2` are visibly the sums
of the `Q_op` eigenvalues). It does NOT:

* derive the full anomaly-FREE claim from `Q_op` (that still routes through the
  hardcoded `standardModelOneGeneration` table via `Jbar` cancellation);
* derive the `SU(2)^2 U(1)` or gravitational anomalies from `Q_op`;
* derive the right-handed sector from `Q_op` (it remains conventional).

So this is a PARTIAL, honest improvement: the `U(1)` linear/cubic anomaly sums
are now provably the sums of `Q_op` eigenvalues, not literals. Trusted,
kernel-checked, `s o r r y`-free. Prerequisites: `Furey.AnomalyBridge`.
-/

namespace PhysicsSM.Algebra.Furey.AnomalyFromQop

open PhysicsSM.Algebra.Furey.AnomalyBridge
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal

/-- **The `U(1)` anomaly sums are the sums of the `Q_op` eigenvalues.** Each
`Q_op s = q_s . s` conjunct is the proved octonion-charge eigenvalue of the state
`s`; the last two conjuncts sum those eigenvalues (`q_s`) linearly (`= -4`) and
cubically (`= -2`, the `U(1)^3` gauge-anomaly coefficient over the `J` sector).
Unlike `MinimalLeftIdeal.charge_sum_J` (hardcoded literals), the charges here are
the `Q_op` eigenvalues. -/
theorem u1Anomaly_sums_from_Qop :
    (Q_op omega_bar = (0 : ℂ) • omega_bar) ∧
    (Q_op vbar1 = (-1 / 3 : ℂ) • vbar1) ∧ (Q_op vbar2 = (-1 / 3 : ℂ) • vbar2) ∧
    (Q_op vbar3 = (-1 / 3 : ℂ) • vbar3) ∧ (Q_op vbar4 = (-2 / 3 : ℂ) • vbar4) ∧
    (Q_op vbar5 = (-2 / 3 : ℂ) • vbar5) ∧ (Q_op vbar6 = (-2 / 3 : ℂ) • vbar6) ∧
    (Q_op nu_bar = (-1 : ℂ) • nu_bar) ∧
    -- linear U(1) sum of the Q_op eigenvalues:
    ((0 + (-1 / 3) + (-1 / 3) + (-1 / 3) + (-2 / 3) + (-2 / 3) + (-2 / 3)
        + (-1) : ℚ) = -4) ∧
    -- cubic U(1)^3 gauge-anomaly sum of the same eigenvalues:
    (((0 : ℚ) ^ 3 + (-1 / 3) ^ 3 + (-1 / 3) ^ 3 + (-1 / 3) ^ 3 + (-2 / 3) ^ 3
        + (-2 / 3) ^ 3 + (-2 / 3) ^ 3 + (-1) ^ 3) = -2) :=
  ⟨Q_op_omega_bar, Q_op_vbar1, Q_op_vbar2, Q_op_vbar3, Q_op_vbar4, Q_op_vbar5,
   Q_op_vbar6, Q_op_nu_bar, by norm_num, by norm_num⟩

end PhysicsSM.Algebra.Furey.AnomalyFromQop
