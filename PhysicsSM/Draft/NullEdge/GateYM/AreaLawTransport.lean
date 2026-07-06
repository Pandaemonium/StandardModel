import Mathlib

/-!
# Gate YM: abstract Wilson area-law transport bookkeeping

This module formalizes the *safe abstract scalar core* of the continuum
area-law route sketched in Faizal-Shabir, arXiv:2606.19362 (mining note
`AgentTasks/paper-units/faizal-shabir-2606-19362-mining.md`, takeaway 5, and
context pack `AgentTasks/context-packs/sm-area-law-transport-20260706-061955.md`).

We deliberately stay one layer above any lattice/continuum content: everything
here is elementary real-sequence bookkeeping.  **No continuum string-tension or
physical confinement claim is made.**  The paper's step-scaling ladder

```text
sigma_{k+1} >= sigma_k - delta_k
sum_k delta_k < sigma_0
--------------------------------
uniform positive lower bound on sigma_k
```

is exactly the shape proved here for a real "string-tension" sequence `sig` with
explicit local "loss" data `loss`.  We give both the finite-prefix-sum version
(`sig_lower_bound_of_prefix_bound`) and the genuinely summable version
(`sig_lower_bound_of_summable`, `sig_pos_of_summable`) whose hypothesis is
literally `∑' k, loss k < sig 0`.

The second half is an explicit finite-step area-perimeter *transport* lemma.
From a one-step Wilson bound of the shape

```text
W_{k+1} <= exp(perimeter/cusp correction_k) * W_k + defect_k
```

together with an explicit local *counterterm admissibility* hypothesis relating
the running area-law envelope across one step, we transport a base
area-perimeter bound to every step:

```text
W_k <= exp(- sigma * area_k + perim_k + cusp_k).
```

Here `area`, `perim`, `cusp`, `pc` (the perimeter/cusp correction exponent) and
`defect` are all explicit sequences supplied as hypotheses; there are no hidden
constants.  This is the *finite-step transport layer* only: it does NOT prove a
strong-coupling base area law, nor a continuum renormalized-loop area law.

## Proved statements

* `sig_ge_base_sub_prefix` — telescoped prefix lower bound.
* `sig_lower_bound_of_prefix_bound`, `sig_pos_of_prefix_bound` — uniform lower
  bound / positivity from a finite prefix-sum bound below the base tension.
* `sig_lower_bound_of_summable`, `sig_pos_of_summable` — the same with the
  literal summable hypothesis `∑' k, loss k < sig 0`.
* `wilson_transport_bound` — abstract envelope transport for a step recurrence
  `W_{k+1} ≤ exp(pc_k) * W_k + defect_k`.
* `wilson_area_perimeter_transport` — the explicit area/perimeter/cusp
  specialization.

## Explicitly NOT proved (no silent assumptions)

* Any strong-coupling base area law (that is upstream, `Theorem2AreaLaw` etc.).
* Any continuum step-scaling / renormalized Wilson-loop statement.
* Any identification of `sig` with a physical continuum string tension.

Draft-trust: kernel-checked, no `s o r r y`, no new axioms. Claim label:
**finite/abstract bookkeeping**.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace AreaLawTransport

open scoped BigOperators

/-! ## Scalar string-tension transport core -/

/-- **Telescoped prefix lower bound.**  If the string-tension sequence `sig`
loses at most `loss k` per step, then after `n` steps it has dropped by at most
the finite prefix sum `∑_{j<n} loss j` from its base value `sig 0`. -/
theorem sig_ge_base_sub_prefix (sig loss : ℕ → ℝ)
    (hstep : ∀ k, sig k - loss k ≤ sig (k + 1)) (n : ℕ) :
    sig 0 - ∑ j ∈ Finset.range n, loss j ≤ sig n := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ]
    have hs := hstep m
    linarith

/-- **Uniform lower bound from a finite prefix-sum bound.**  If every finite
prefix sum of the losses is bounded by `S`, then `sig` never drops below
`sig 0 - S`, uniformly in `k`. -/
theorem sig_lower_bound_of_prefix_bound (sig loss : ℕ → ℝ)
    (hstep : ∀ k, sig k - loss k ≤ sig (k + 1))
    (S : ℝ) (hpref : ∀ n, ∑ j ∈ Finset.range n, loss j ≤ S) (n : ℕ) :
    sig 0 - S ≤ sig n := by
  have h := sig_ge_base_sub_prefix sig loss hstep n
  have := hpref n
  linarith

/-- **Uniform positivity from a finite prefix-sum bound below the base.**  If in
addition the bound `S` is strictly below the base tension `sig 0`, then `sig`
stays uniformly positive. -/
theorem sig_pos_of_prefix_bound (sig loss : ℕ → ℝ)
    (hstep : ∀ k, sig k - loss k ≤ sig (k + 1))
    (S : ℝ) (hpref : ∀ n, ∑ j ∈ Finset.range n, loss j ≤ S)
    (hS : S < sig 0) (n : ℕ) : 0 < sig n := by
  have h := sig_lower_bound_of_prefix_bound sig loss hstep S hpref n
  linarith

/-- **Uniform lower bound from summable losses.**  This is the literal
`sum_k delta_k < sigma_0` route: with nonnegative summable losses, every `sig k`
is bounded below by `sig 0 - ∑' k, loss k`, uniformly in `k`. -/
theorem sig_lower_bound_of_summable (sig loss : ℕ → ℝ)
    (hstep : ∀ k, sig k - loss k ≤ sig (k + 1))
    (hloss_nonneg : ∀ k, 0 ≤ loss k) (hsum : Summable loss) (n : ℕ) :
    sig 0 - ∑' k, loss k ≤ sig n := by
  refine sig_lower_bound_of_prefix_bound sig loss hstep (∑' k, loss k) ?_ n
  intro m
  exact hsum.sum_le_tsum _ (fun i _ => hloss_nonneg i)

/-- **Uniform positive lower bound on the string tension.**  The safe abstract
scalar core of the area-law transport ladder: a step-scaling inequality with
nonnegative summable losses whose total is below the base tension yields a
uniform positive lower bound on `sig k`. -/
theorem sig_pos_of_summable (sig loss : ℕ → ℝ)
    (hstep : ∀ k, sig k - loss k ≤ sig (k + 1))
    (hloss_nonneg : ∀ k, 0 ≤ loss k) (hsum : Summable loss)
    (hlt : ∑' k, loss k < sig 0) (n : ℕ) : 0 < sig n := by
  have h := sig_lower_bound_of_summable sig loss hstep hloss_nonneg hsum n
  linarith

/-! ## Finite-step area-perimeter transport -/

/-- **Abstract envelope transport.**  Given a base bound `W 0 ≤ B 0`, a one-step
recurrence `W_{k+1} ≤ exp(pc_k) · W_k + defect_k`, and a counterterm
admissibility hypothesis `exp(pc_k) · B_k + defect_k ≤ B_{k+1}` propagating the
envelope `B`, the bound `W_k ≤ B_k` holds for all `k`.

All correction and defect data (`pc`, `defect`) and the envelope `B` are
explicit inputs; no hidden constant is introduced. -/
theorem wilson_transport_bound (W B pc defect : ℕ → ℝ)
    (hbase : W 0 ≤ B 0)
    (hstep : ∀ k, W (k + 1) ≤ Real.exp (pc k) * W k + defect k)
    (hcounter : ∀ k, Real.exp (pc k) * B k + defect k ≤ B (k + 1))
    (n : ℕ) : W n ≤ B n := by
  induction n with
  | zero => exact hbase
  | succ m ih =>
    have h1 := hstep m
    have h2 := hcounter m
    have hmul : Real.exp (pc m) * W m ≤ Real.exp (pc m) * B m :=
      mul_le_mul_of_nonneg_left ih (Real.exp_pos _).le
    linarith

/-- **Explicit area-perimeter transport.**  Specializing the envelope to the
running area-law form `exp(- sigmaT · area_k + perim_k + cusp_k)`, a base area
law plus the one-step Wilson bound plus explicit local counterterm
admissibility transports the area-perimeter bound to every step.

The area, perimeter, cusp, perimeter/cusp exponent correction (`pc`) and defect
sequences are all explicit local counterterm data supplied as hypotheses, matching
the paper's requirement that these be explicit rather than hidden constants.

This is only the finite-step transport layer: it assumes the base area law and
each one-step bound; it establishes no continuum or physical confinement claim. -/
theorem wilson_area_perimeter_transport (W : ℕ → ℝ)
    (sigmaT : ℝ) (area perim cusp pc defect : ℕ → ℝ)
    (hbase : W 0 ≤ Real.exp (- sigmaT * area 0 + perim 0 + cusp 0))
    (hstep : ∀ k, W (k + 1) ≤ Real.exp (pc k) * W k + defect k)
    (hcounter : ∀ k,
        Real.exp (pc k) * Real.exp (- sigmaT * area k + perim k + cusp k) + defect k
          ≤ Real.exp (- sigmaT * area (k + 1) + perim (k + 1) + cusp (k + 1)))
    (n : ℕ) :
    W n ≤ Real.exp (- sigmaT * area n + perim n + cusp n) :=
  wilson_transport_bound W
    (fun k => Real.exp (- sigmaT * area k + perim k + cusp k)) pc defect
    hbase hstep hcounter n

end AreaLawTransport
end GateYM
end NullEdge
end Draft
end PhysicsSM
