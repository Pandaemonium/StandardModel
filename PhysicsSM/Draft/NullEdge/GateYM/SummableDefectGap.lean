import Mathlib

/-!
# Gate YM: summable-defect gap transport

This module formalizes the abstract **summable-defect gap transport** lemma
inspired by the multiscale interlacing part of Faizal-Shabir
(arXiv:2606.19362), tracked locally as `thm:interlacing` / `thm:gap-step` /
`prop:summable` / `thm:uniform-gap` in
`AgentTasks/paper-units/faizal-shabir-2606-19362-mining.md`.

## The scalar theorem

Given a sequence of gaps `Δ : ℕ → ℝ` and defects `ε : ℕ → ℝ` obeying the
one-step interlacing lower bound

```text
Δ_{k+1} ≥ Δ_k - ε_k
```

we prove:

* **Finite prefix** (`Delta_ge_range_sum`): for every `k`,
  `Δ_k ≥ Δ_0 - ∑_{j < k} ε_j`.  This is pure induction over `Finset.range` and
  needs *no* summability or sign hypothesis on `ε`.
* **Infinite series** (`Delta_ge_tsum`): if the defects are nonnegative and
  summable, then for every `k`, `Δ_k ≥ Δ_0 - ∑' j, ε_j`.
* **Uniform positive gap** (`uniform_gap`, `pos_iInf`): if in addition
  `∑' j, ε_j < Δ_0`, then `Δ_0 - ∑' j, ε_j > 0` is a scale-independent lower
  bound for every `Δ_k`, hence `inf_k Δ_k > 0`.

## Operator-level corollary

`step_of_operator` records the reduction from an operator-level interlacing
inequality of the shape

```text
T_{k+1} = V* T_k^♭ V - D_k + E_k,   D_k ≥ 0,   ‖E_k‖ ≤ ε_k
```

to the scalar recurrence.  Modeling the induced spectral gap by a real sequence
`gap`, the unitary conjugation `V* · V` preserves the normalized gap and the
positive defect `D_k ≥ 0` only *increases* it, so the only downward pressure is
the perturbation `E_k`, giving `gap_{k+1} ≥ gap_k - ‖E_k‖`.  With `‖E_k‖ ≤ ε_k`
this yields exactly the scalar hypothesis `gap_{k+1} ≥ gap_k - ε_k`, after which
the transport lemmas above apply verbatim (`operator_uniform_gap`).

## Normalization caveat

All quantities here are **contraction-side gaps** (dimensionless spectral
separations of the transfer/interlacing operators).  We deliberately keep the
time-spacing normalization implicit in the sequences themselves and do *not*
convert to a generator gap `-log(·)`; no logarithmic lemma is asserted, so no
contraction/generator conflation occurs.  This is an abstract transport lemma
with no continuum claim.

Draft-trust: no `s o r r y`, no new `a x i o m`, `o p a q u e`, `u n s a f e`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace SummableDefectGap

open Finset

/-! ## Finite-prefix scalar transport -/

/-- **Finite-prefix gap transport.**  If the gaps satisfy the one-step
interlacing bound `Δ_{k+1} ≥ Δ_k - ε_k`, then each gap is bounded below by the
initial gap minus the finite prefix sum of defects:
`Δ_k ≥ Δ_0 - ∑_{j < k} ε_j`.

No summability or sign hypothesis on `ε` is required. -/
theorem Delta_ge_range_sum (Delta eps : ℕ → ℝ)
    (hrec : ∀ k, Delta k - eps k ≤ Delta (k + 1)) :
    ∀ k, Delta 0 - ∑ j ∈ Finset.range k, eps j ≤ Delta k := by
  intro k
  induction k with
  | zero => simp
  | succ n ih =>
      rw [Finset.sum_range_succ]
      have := hrec n
      linarith

/-! ## Infinite-series scalar transport -/

/-- **Series gap transport.**  If additionally the defects are nonnegative and
summable, then every gap is bounded below by the initial gap minus the *total*
defect: `Δ_k ≥ Δ_0 - ∑' j, ε_j`. -/
theorem Delta_ge_tsum (Delta eps : ℕ → ℝ)
    (hrec : ∀ k, Delta k - eps k ≤ Delta (k + 1))
    (hnn : ∀ k, 0 ≤ eps k) (hsum : Summable eps) :
    ∀ k, Delta 0 - ∑' j, eps j ≤ Delta k := by
  intro k
  have hprefix : ∑ j ∈ Finset.range k, eps j ≤ ∑' j, eps j :=
    hsum.sum_le_tsum (Finset.range k) (fun i _ => hnn i)
  have hrange := Delta_ge_range_sum Delta eps hrec k
  linarith

/-- The total-defect lower bound is strictly positive once the summed defect is
below the initial gap. -/
theorem pos_of_tsum_lt (Delta eps : ℕ → ℝ)
    (hlt : ∑' j, eps j < Delta 0) :
    0 < Delta 0 - ∑' j, eps j := by
  linarith

/-- **Uniform positive gap (packaged).**  Under the one-step interlacing bound,
nonnegative summable defects, and a total defect strictly below the initial gap,
the constant `Δ_0 - ∑' j, ε_j` is a strictly positive, scale-independent lower
bound valid for every gap `Δ_k`. -/
theorem uniform_gap (Delta eps : ℕ → ℝ)
    (hrec : ∀ k, Delta k - eps k ≤ Delta (k + 1))
    (hnn : ∀ k, 0 ≤ eps k) (hsum : Summable eps)
    (hlt : ∑' j, eps j < Delta 0) :
    0 < Delta 0 - ∑' j, eps j ∧ ∀ k, Delta 0 - ∑' j, eps j ≤ Delta k :=
  ⟨pos_of_tsum_lt Delta eps hlt, Delta_ge_tsum Delta eps hrec hnn hsum⟩

/-- The gap sequence is bounded below (by the uniform lower bound). -/
theorem bddBelow_range (Delta eps : ℕ → ℝ)
    (hrec : ∀ k, Delta k - eps k ≤ Delta (k + 1))
    (hnn : ∀ k, 0 ≤ eps k) (hsum : Summable eps) :
    BddBelow (Set.range Delta) := by
  refine ⟨Delta 0 - ∑' j, eps j, ?_⟩
  rintro _ ⟨k, rfl⟩
  exact Delta_ge_tsum Delta eps hrec hnn hsum k

/-- **Uniform positive infimum.**  Under the transport hypotheses with total
defect below the initial gap, the infimum of the gaps is strictly positive:
`inf_k Δ_k ≥ Δ_0 - ∑' j, ε_j > 0`. -/
theorem pos_iInf (Delta eps : ℕ → ℝ)
    (hrec : ∀ k, Delta k - eps k ≤ Delta (k + 1))
    (hnn : ∀ k, 0 ≤ eps k) (hsum : Summable eps)
    (hlt : ∑' j, eps j < Delta 0) :
    0 < ⨅ k, Delta k := by
  have hpos := pos_of_tsum_lt Delta eps hlt
  have hbd := Delta_ge_tsum Delta eps hrec hnn hsum
  have : Delta 0 - ∑' j, eps j ≤ ⨅ k, Delta k := le_ciInf hbd
  linarith

/-! ## Operator-level corollary

We model the induced spectral gap of the interlacing operator sequence by a real
sequence `gap : ℕ → ℝ`, and the perturbation blocks `E_k` by elements of an
arbitrary normed additive commutative group `H`.  The interlacing identity
`T_{k+1} = V* T_k^♭ V - D_k + E_k` with `D_k ≥ 0` and unitary `V` yields the
one-step gap inequality `gap_{k+1} ≥ gap_k - ‖E_k‖`; combined with `‖E_k‖ ≤ ε_k`
this reduces to the scalar recurrence used above. -/

section Operator

variable {H : Type*} [NormedAddCommGroup H]

/-- **Reduction of the operator interlacing bound to the scalar recurrence.**
Given the operator-induced one-step bound `gap_{k+1} ≥ gap_k - ‖E_k‖` and a
summable defect envelope `‖E_k‖ ≤ ε_k`, the scalar interlacing recurrence
`gap_{k+1} ≥ gap_k - ε_k` holds. -/
theorem step_of_operator (gap eps : ℕ → ℝ) (E : ℕ → H)
    (hE : ∀ k, ‖E k‖ ≤ eps k)
    (hstep : ∀ k, gap k - ‖E k‖ ≤ gap (k + 1)) :
    ∀ k, gap k - eps k ≤ gap (k + 1) := by
  intro k
  have := hstep k
  have := hE k
  linarith

/-- **Operator-level uniform gap.**  From the operator interlacing bound
`gap_{k+1} ≥ gap_k - ‖E_k‖` with `‖E_k‖ ≤ ε_k`, nonnegative summable `ε`, and
total defect below the initial gap, the induced spectral gap stays uniformly
positive across all scales. -/
theorem operator_uniform_gap (gap eps : ℕ → ℝ) (E : ℕ → H)
    (hE : ∀ k, ‖E k‖ ≤ eps k)
    (hstep : ∀ k, gap k - ‖E k‖ ≤ gap (k + 1))
    (hnn : ∀ k, 0 ≤ eps k) (hsum : Summable eps)
    (hlt : ∑' j, eps j < gap 0) :
    0 < gap 0 - ∑' j, eps j ∧ ∀ k, gap 0 - ∑' j, eps j ≤ gap k :=
  uniform_gap gap eps (step_of_operator gap eps E hE hstep) hnn hsum hlt

/-- Operator-level positive infimum of the induced spectral gaps. -/
theorem operator_pos_iInf (gap eps : ℕ → ℝ) (E : ℕ → H)
    (hE : ∀ k, ‖E k‖ ≤ eps k)
    (hstep : ∀ k, gap k - ‖E k‖ ≤ gap (k + 1))
    (hnn : ∀ k, 0 ≤ eps k) (hsum : Summable eps)
    (hlt : ∑' j, eps j < gap 0) :
    0 < ⨅ k, gap k :=
  pos_iInf gap eps (step_of_operator gap eps E hE hstep) hnn hsum hlt

end Operator

end SummableDefectGap
end GateYM
end NullEdge
end Draft
end PhysicsSM
