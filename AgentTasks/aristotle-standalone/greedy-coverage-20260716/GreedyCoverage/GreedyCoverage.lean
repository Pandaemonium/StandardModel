import Mathlib

/-!
# Finite greedy coverage core

This standalone target isolates the combinatorial theorem needed by a possible
order-only diversified causal-atlas selector. It is independent of causal sets:
a candidate is simply a finite subset of a finite event type.

The central target says that, relative to any nonempty benchmark family of
`k` candidates, one benchmark candidate has marginal gain at least the average
share of the benchmark union that remains uncovered. A candidate maximizing
marginal gain over a larger available family therefore obeys the same bound.

This theorem controls a selector; it does not assert that the benchmark family
covers a desired fraction or that causal operators are local.
-/

namespace GreedyCoverage

variable {Event Candidate : Type*}

/-- Events covered by a finite family of selected candidates. -/
def coveredBy [DecidableEq Event]
    (family : Candidate -> Finset Event) (chosen : Finset Candidate) :
    Finset Event :=
  chosen.biUnion family

/-- New events contributed by one candidate beyond an existing covered set. -/
def marginalGain [DecidableEq Event]
    (family : Candidate -> Finset Event) (covered : Finset Event)
    (candidate : Candidate) : Nat :=
  ((family candidate) \ covered).card

/-- Removing an existing covered set commutes with the finite candidate union. -/
theorem coveredBy_sdiff_eq_biUnion_sdiff
    [DecidableEq Event] [DecidableEq Candidate]
    (family : Candidate -> Finset Event) (chosen : Finset Candidate)
    (covered : Finset Event) :
    coveredBy family chosen \ covered =
      chosen.biUnion (fun candidate => family candidate \ covered) := by
  ext event
  simp [coveredBy]
  aesop

/-- One member of a nonempty benchmark family attains at least its average
share of the benchmark union that remains uncovered. -/
theorem exists_marginal_card_mul_ge_uncovered
    [DecidableEq Event] [DecidableEq Candidate]
    (family : Candidate -> Finset Event) (benchmark : Finset Candidate)
    (covered : Finset Event) (hbenchmark : benchmark.Nonempty) :
    exists candidate, candidate ∈ benchmark /\
      (coveredBy family benchmark \ covered).card <=
        benchmark.card * marginalGain family covered candidate := by
  let gains : Finset Nat :=
    benchmark.image (marginalGain family covered)
  have hgains : gains.Nonempty := hbenchmark.image _
  let maximum : Nat := gains.max' hgains
  have hmaximum : maximum ∈ gains := gains.max'_mem hgains
  rcases Finset.mem_image.mp hmaximum with
    ⟨candidate, hcandidate, hcandidateMaximum⟩
  refine ⟨candidate, hcandidate, ?_⟩
  rw [coveredBy_sdiff_eq_biUnion_sdiff]
  calc
    (benchmark.biUnion (fun index => family index \ covered)).card
        <= ∑ index ∈ benchmark, (family index \ covered).card :=
      Finset.card_biUnion_le
    _ <= ∑ _index ∈ benchmark, maximum := by
      apply Finset.sum_le_sum
      intro index hindex
      exact Finset.le_max' gains _
        (Finset.mem_image.mpr ⟨index, hindex, rfl⟩)
    _ = benchmark.card * maximum := by simp
    _ = benchmark.card * marginalGain family covered candidate := by
      rw [hcandidateMaximum]

/-- A marginal-gain maximizer over an available family dominates the average
benchmark share whenever the benchmark is contained in the available family. -/
theorem greedy_marginal_card_mul_ge_uncovered
    [DecidableEq Event] [DecidableEq Candidate]
    (family : Candidate -> Finset Event)
    (available benchmark : Finset Candidate) (covered : Finset Event)
    (greedy : Candidate) (hbenchmark : benchmark.Nonempty)
    (hsubset : benchmark ⊆ available) (hgreedy : greedy ∈ available)
    (hmax : ∀ candidate ∈ available,
      marginalGain family covered candidate <=
        marginalGain family covered greedy) :
    (coveredBy family benchmark \ covered).card <=
      benchmark.card * marginalGain family covered greedy := by
  rcases exists_marginal_card_mul_ge_uncovered family benchmark covered
      hbenchmark with ⟨candidate, hcandidate, hbound⟩
  exact hbound.trans (Nat.mul_le_mul_left benchmark.card
    (hmax candidate (hsubset hcandidate)))

/-- The average-marginal inequality contracts the uncovered residual by the
factor `1 - 1/k` after one greedy step. -/
theorem residual_contract
    (k : Nat) (hk : 0 < k) (optimum covered gain nextCovered : Rat)
    (hgain : (optimum - covered) / (k : Rat) <= gain)
    (hnext : covered + gain <= nextCovered) :
    optimum - nextCovered <=
      (1 - 1 / (k : Rat)) * (optimum - covered) := by
  calc
    optimum - nextCovered <= optimum - (covered + gain) := by linarith
    _ = (optimum - covered) - gain := by ring
    _ <= (optimum - covered) - (optimum - covered) / (k : Rat) := by
      linarith
    _ = (1 - 1 / (k : Rat)) * (optimum - covered) := by ring

/-- Iterating any nonnegative multiplicative residual contraction gives the
expected geometric bound. -/
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

/-- Relabeling events by an embedding preserves each candidate's marginal
gain. This is the finite symmetry control needed before random tie handling. -/
theorem marginalGain_map
    [DecidableEq Event] [DecidableEq Candidate]
    {Relabeled : Type*} [DecidableEq Relabeled]
    (embedding : Event ↪ Relabeled)
    (family : Candidate -> Finset Event) (covered : Finset Event)
    (candidate : Candidate) :
    marginalGain (fun index => (family index).map embedding)
        (covered.map embedding) candidate =
      marginalGain family covered candidate := by
  rw [marginalGain, marginalGain, ← Finset.map_sdiff, Finset.card_map]

/-- Singleton benchmark control: the average-share conclusion reduces to
equality for its only candidate. -/
theorem singleton_benchmark_control
    [DecidableEq Event] [DecidableEq Candidate]
    (family : Candidate -> Finset Event) (covered : Finset Event)
    (candidate : Candidate) :
    (coveredBy family {candidate} \ covered).card =
      ({candidate} : Finset Candidate).card *
        marginalGain family covered candidate := by
  simp [coveredBy, marginalGain]

end GreedyCoverage

#print axioms GreedyCoverage.exists_marginal_card_mul_ge_uncovered
#print axioms GreedyCoverage.greedy_marginal_card_mul_ge_uncovered
#print axioms GreedyCoverage.residual_contract
