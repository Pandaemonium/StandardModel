import Mathlib

/-!
# Finite greedy coverage for order-only causal atlases

This module isolates the finite set-system theorem used by the Stage A3f-R2
order-atlas packing selector. Relative to any nonempty benchmark family, some
candidate contributes at least the average share of the benchmark union still
uncovered. A marginal maximizer over a larger available family inherits that
bound. The scalar residual then contracts geometrically and gives the exact
finite-step factor `1 - (1 - 1 / k)^k`.

The result controls a selector. It does not assert that a causal candidate
family contains a good cover, derive an order bulk, recover a metric, or open
the operator-locality or G2 gates. Claim grade: `M [orig]`.

Provenance: clean-room finite maximum-coverage argument prepared for
`AgentTasks/null-edge-causal-atlas-packing-stage-a3f-r2-plan-2026-07-16.md`.
The exact statements were frozen before the held-out benchmark. The average
marginal proof uses `Finset.card_biUnion_le` and a maximum over the finite
benchmark image; the residual proof is ordered-field algebra.
-/

namespace PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage

variable {Event Candidate : Type*}

/-- Events covered by a finite family of selected candidates. -/
def coveredBy [DecidableEq Event]
    (family : Candidate -> Finset Event) (chosen : Finset Candidate) :
    Finset Event :=
  chosen.biUnion family

/-- If every selected candidate covers at most `bound` events, their union
covers at most the number of selected candidates times `bound`. -/
theorem coveredBy_card_le_card_mul
    [DecidableEq Event]
    (family : Candidate -> Finset Event) (chosen : Finset Candidate)
    (bound : Nat) (hbound : forall candidate, candidate ∈ chosen ->
      (family candidate).card <= bound) :
    (coveredBy family chosen).card <= chosen.card * bound := by
  simpa only [coveredBy] using
    Finset.card_biUnion_le_card_mul chosen family bound hbound

/-- Any demanded absolute coverage cardinality forces the corresponding
atlas-cardinality times single-core-size budget. -/
theorem coverage_target_forces_card_mul
    [DecidableEq Event]
    (family : Candidate -> Finset Event) (chosen : Finset Candidate)
    (bound target : Nat) (hbound : forall candidate, candidate ∈ chosen ->
      (family candidate).card <= bound)
    (htarget : target <= (coveredBy family chosen).card) :
    target <= chosen.card * bound :=
  htarget.trans (coveredBy_card_le_card_mul family chosen bound hbound)

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
    (hsubset : benchmark ⊆ available) (_hgreedy : greedy ∈ available)
    (hmax : forall candidate, candidate ∈ available ->
      marginalGain family covered candidate <=
        marginalGain family covered greedy) :
    (coveredBy family benchmark \ covered).card <=
      benchmark.card * marginalGain family covered greedy := by
  rcases exists_marginal_card_mul_ge_uncovered family benchmark covered
      hbenchmark with ⟨candidate, hcandidate, hbound⟩
  exact hbound.trans (Nat.mul_le_mul_left benchmark.card
    (hmax candidate (hsubset hcandidate)))

/-- The average-marginal inequality contracts the uncovered residual by the
factor `1 - 1 / k` after one greedy step. -/
theorem residual_contract
    (k : Nat) (_hk : 0 < k) (optimum covered gain nextCovered : Rat)
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

/-- The preregistered one-step contraction implies the exact `k`-step greedy
maximum-coverage factor over the rationals. -/
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

end PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage.exists_marginal_card_mul_ge_uncovered' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage.exists_marginal_card_mul_ge_uncovered

/-- info: 'PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage.coverage_target_forces_card_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage.coverage_target_forces_card_mul

/-- info: 'PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage.greedy_marginal_card_mul_ge_uncovered' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage.greedy_marginal_card_mul_ge_uncovered

/-- info: 'PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage.residual_contract' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage.residual_contract

/-- info: 'PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage.finite_greedy_coverage_factor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage.finite_greedy_coverage_factor
