import Mathlib

/-!
# NullStrand finite probability primitives (manifest PR02: DEF-006, DEF-007, STO-001, STO-002)

Discrete-time finite Markov kernels and continuous-time finite jump generators,
with the composition and mass-conservation lemmas that every downstream
equivariance proof reuses. Mathlib-only; intended as a focused Aristotle target.

Convention (manifest §6.3): "kernel" = discrete-time `α → PMF β`; a continuous-time
rate matrix is a `FiniteJumpGenerator`, never called a kernel. Row sums of the
generator are zero (probability conservation).
-/

namespace NullStrand.Probability

open scoped BigOperators
open Finset

/-- DEF-006. A finite-state discrete-time Markov kernel. -/
abbrev FiniteKernel (α β : Type*) := α → PMF β

/-- STO-001. Pushing a law through composed finite kernels equals successive
pushforwards (associativity of the pushforward / `bind`). -/
theorem pushforward_comp {α β γ : Type*}
    (μ : PMF α) (K : FiniteKernel α β) (L : FiniteKernel β γ) :
    μ.bind (fun a => (K a).bind L) = (μ.bind K).bind L := by
  sorry

/-- DEF-007. A continuous-time finite jump generator: nonnegative off-diagonal
rates and zero row sums (so total probability is conserved by the forward
equation). -/
structure FiniteJumpGenerator (α : Type*) [Fintype α] where
  rate : α → α → ℝ
  offdiag_nonneg : ∀ i j, i ≠ j → 0 ≤ rate i j
  row_sum_zero : ∀ i, ∑ j, rate i j = 0

/-- STO-002. The forward (master) equation `ṗ i = ∑ j, rate j i * p j` conserves
total probability: the total time-derivative `∑ i, ṗ i` is zero. -/
theorem masterEquation_mass_conserved {α : Type*} [Fintype α]
    (G : FiniteJumpGenerator α) (p : α → ℝ) :
    ∑ i, (∑ j, G.rate j i * p j) = 0 := by
  sorry

end NullStrand.Probability
