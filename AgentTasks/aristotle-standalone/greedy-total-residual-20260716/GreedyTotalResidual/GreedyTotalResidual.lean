import Mathlib

/-!
# Total-residual composition for finite greedy coverage

This standalone module records the valid algebraic composition behind the
finite maximum-coverage factor.  The residual is `optimum - covered`, where
`covered` is the total number of events covered by the greedy family.  This is
deliberate: replacing total coverage by the intersection with one benchmark
union would require a stronger hypothesis, because a greedy candidate may gain
events outside that benchmark.

The hypotheses isolate the two facts supplied by the finite-set argument:
average marginal gain and monotone accumulation of that gain.  The conclusion
is the exact rational factor `1 - (1 - 1 / k) ^ k`.

This controls a selector relative to a benchmark.  It does not assert that a
causal candidate family contains a good cover or open any geometric gate.
-/

namespace GreedyTotalResidual

/-- Average gain and accumulated gain imply one-step total-residual
contraction by `1 - 1/k`. -/
theorem residual_contract
    (k : Nat) (hk : 0 < k) (optimum covered gain nextCovered : Rat)
    (hgain : (optimum - covered) / (k : Rat) <= gain)
    (hnext : covered + gain <= nextCovered) :
    optimum - nextCovered <=
      (1 - 1 / (k : Rat)) * (optimum - covered) := by
  have hkq : (0 : Rat) < (k : Rat) := by exact_mod_cast hk
  calc
    optimum - nextCovered <= optimum - (covered + gain) :=
      sub_le_sub_left hnext optimum
    _ <= (1 - 1 / (k : Rat)) * (optimum - covered) := by
      rw [show
        (1 - 1 / (k : Rat)) * (optimum - covered) =
          (optimum - covered) - (optimum - covered) / (k : Rat) by
            field_simp]
      linarith

/-- Iterating a nonnegative multiplicative residual contraction gives the
geometric residual bound. -/
theorem geometric_residual_bound
    (q : Rat) (hq : 0 <= q) (residual : Nat -> Rat)
    (hstep : forall step, residual (step + 1) <= q * residual step) :
    forall steps, residual steps <= q ^ steps * residual 0 := by
  intro steps
  induction steps with
  | zero => simp
  | succ step inductionHypothesis =>
      calc
        residual (step + 1) <= q * residual step := hstep step
        _ <= q * (q ^ step * residual 0) :=
          mul_le_mul_of_nonneg_left inductionHypothesis hq
        _ = q ^ (step + 1) * residual 0 := by ring

/-- Exact `k`-step coverage lower bound from average marginal gain and total
coverage accumulation. -/
theorem geometric_coverage_lower_bound
    (k : Nat) (hk : 0 < k) (optimum : Rat)
    (covered gain : Nat -> Rat) (hcovered_zero : covered 0 = 0)
    (hgain : forall step,
      (optimum - covered step) / (k : Rat) <= gain step)
    (hnext : forall step,
      covered step + gain step <= covered (step + 1)) :
    (1 - (1 - 1 / (k : Rat)) ^ k) * optimum <= covered k := by
  have hkq : (0 : Rat) < (k : Rat) := by exact_mod_cast hk
  have hkNat : 1 <= k := by omega
  have hkqOne : (1 : Rat) <= (k : Rat) := by exact_mod_cast hkNat
  have hq : (0 : Rat) <= 1 - 1 / (k : Rat) := by
    rw [sub_nonneg]
    exact (div_le_one hkq).2 hkqOne
  let residual : Nat -> Rat := fun step => optimum - covered step
  have hstep : forall step,
      residual (step + 1) <=
        (1 - 1 / (k : Rat)) * residual step := by
    intro step
    exact residual_contract k hk optimum (covered step) (gain step)
      (covered (step + 1)) (hgain step) (hnext step)
  have hgeometric := geometric_residual_bound
    (1 - 1 / (k : Rat)) hq residual hstep k
  dsimp [residual] at hgeometric
  rw [hcovered_zero, sub_zero] at hgeometric
  calc
    (1 - (1 - 1 / (k : Rat)) ^ k) * optimum =
        optimum - (1 - 1 / (k : Rat)) ^ k * optimum := by ring
    _ <= covered k := by linarith

#print axioms residual_contract
#print axioms geometric_residual_bound
#print axioms geometric_coverage_lower_bound

end GreedyTotalResidual
