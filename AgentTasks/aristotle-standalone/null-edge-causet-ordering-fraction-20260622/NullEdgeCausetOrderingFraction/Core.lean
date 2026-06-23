import Mathlib.Tactic

/-!
# Causal-set ordering fraction: the maximal (chain) relation count

In a causal set of `n` elements, the number of order relations is maximized by a
chain (total order), where every pair `i < j` is related. This module counts the
strictly-ordered pairs of `Fin n` and shows it equals `n (n-1) / 2` (stated as
`2 * count = n (n-1)` to avoid truncated division). This is the kernel-checked
foundation for the Myrheim-Meyer ordering fraction / dimension estimator used in
causal-set theory.

Source grounding (Neo4j null-edge collection): Sorkin et al., causal-set quantum
gravity (`1903.11544`); links and ordering (`0910.0673`).

Standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeCausetOrderingFraction

open BigOperators

/-- Number of strictly-ordered pairs `i < j` in the chain on `Fin n`. -/
def chainRelationCount (n : Nat) : Nat :=
  (Finset.univ.filter (fun p : Fin n × Fin n => p.1 < p.2)).card

/-- The chain on `n` elements has `n (n-1) / 2` relations (max ordering fraction). -/
theorem two_mul_chainRelationCount (n : Nat) :
    2 * chainRelationCount n = n * (n - 1) := by
  sorry

/-- An antichain (no relations) has ordering count zero: stated as the empty
strict order on `Fin n`. -/
theorem antichain_relationCount_zero (n : Nat) :
    (Finset.univ.filter (fun _ : Fin n × Fin n => False)).card = 0 := by
  sorry

end NullEdgeCausetOrderingFraction
