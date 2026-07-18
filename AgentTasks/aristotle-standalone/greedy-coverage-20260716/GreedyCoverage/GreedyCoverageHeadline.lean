import Mathlib

/-!
# Finite greedy coverage: geometric composition

This companion composes the preregistered one-step residual inequality into
the exact finite-step coverage factor. It remains a scalar recurrence theorem:
the set-system lemmas in `GreedyCoverage` supply the one-step hypothesis for a
greedy selector, while a concrete selector must separately show that each
archived marginal is added to the covered union.
-/

namespace GreedyCoverage

/-- A residual contraction required only through a finite horizon gives the
same geometric bound at that horizon. -/
theorem geometric_residual_bound_upto
    (q : Rat) (hq : 0 <= q) (residual : Nat -> Rat) (steps : Nat)
    (hstep : forall step, step < steps ->
      residual (step + 1) <= q * residual step) :
    residual steps <= q ^ steps * residual 0 := by
  induction steps with
  | zero => simp
  | succ steps inductionHypothesis =>
      calc
        residual (steps + 1) <= q * residual steps :=
          hstep steps (Nat.lt_succ_self steps)
        _ <= q * (q ^ steps * residual 0) := by
          apply mul_le_mul_of_nonneg_left _ hq
          exact inductionHypothesis (fun step hlt =>
            hstep step (Nat.lt_trans hlt (Nat.lt_succ_self steps)))
        _ = q ^ (steps + 1) * residual 0 := by ring

/-- The preregistered one-step average-gain conditions imply the exact
`K`-step greedy maximum-coverage factor over the rationals. -/
theorem finite_greedy_coverage_factor
    (k : Nat) (hk : 0 < k) (optimum : Rat)
    (covered : Nat -> Rat) (hzero : covered 0 = 0)
    (hcontract : forall step, step < k ->
      optimum - covered (step + 1) <=
        (1 - 1 / (k : Rat)) * (optimum - covered step)) :
    (1 - (1 - 1 / (k : Rat)) ^ k) * optimum <= covered k := by
  let q : Rat := 1 - 1 / (k : Rat)
  have hkRat : (0 : Rat) < (k : Rat) := by exact_mod_cast hk
  have hone_le_k : (1 : Rat) <= (k : Rat) := by exact_mod_cast hk
  have hq : 0 <= q := by
    dsimp [q]
    have hone_div_le_one : (1 : Rat) / (k : Rat) <= 1 :=
      (div_le_one hkRat).2 hone_le_k
    linarith
  have hresidual : forall step, step < k ->
      optimum - covered (step + 1) <= q * (optimum - covered step) := by
    simpa [q] using hcontract
  have hgeometric := geometric_residual_bound_upto q hq
    (fun step => optimum - covered step) k hresidual
  change optimum - covered k <= q ^ k * (optimum - covered 0) at hgeometric
  rw [hzero, sub_zero] at hgeometric
  change (1 - q ^ k) * optimum <= covered k
  calc
    (1 - q ^ k) * optimum = optimum - q ^ k * optimum := by ring
    _ <= covered k := by linarith

end GreedyCoverage
