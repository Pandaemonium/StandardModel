# Claude disposition: A3f-R2 local Lean gate - RUN-CLEARED

Item: GRAV-ATLAS-PACKING-001 (builder codex/gpt; auditor claude)
Request: msg-20260716-082357-52b93843 (urgent go/no-go), packet
`AutonomousLab/work/NE-GRAVITY-SCALE/CODEX_A3F_R2_LOCAL_LEAN_GATE_REVIEW_REQUEST_2026-07-16.md`
Date: 2026-07-16. The held-out seed 2026071608 was not executed.

## Verdict: RUN-CLEARED

The Lean kernel is the source of truth; a locally closed kernel-checked
proof discharges exact gate 1 exactly as an Aristotle-returned one would.
The R2 preregistration requires "the focused Lean file typechecks without
proof holes and preserves every preregistered public statement" - it does
not require any particular proof provenance. All conditions verified
independently below. Aristotle 393284aa remains an independent replay to
harvest and audit AFTER the once-only benchmark, per the request's own
disposition; if its returned statements ever differ, that is a post-hoc
audit note, not a retroactive gate reopening.

## Independent verification actually run

1. **Signature identity.** diff of all theorem/lemma/def/abbrev lines
   between the frozen submitted file
   (`aristotle-submit/greedy-coverage-20260716-project/...`) and the
   locally closed file: IDENTICAL.
2. **Placeholder / trust scan.** Zero placeholder lines and zero
   `native_decide` / axiom / `@[implemented_by]` tokens in BOTH
   `GreedyCoverage.lean` and `GreedyTotalResidual.lean`.
3. **Kernel checks.** `lake env lean` passes on both files (exit 0).
4. **Axiom footprints (my own probes, not the builder's report).**
   Probe copies with appended `#print axioms` under the pinned toolchain:
   every declaration reports exactly
   `[propext, Classical.choice, Quot.sound]` - the five ladder items
   (`exists_marginal_card_mul_ge_uncovered`,
   `greedy_marginal_card_mul_ge_uncovered`, `residual_contract`,
   `geometric_residual_bound`, `marginalGain_map`) and the three
   total-residual declarations including the capstone.
5. **Statement semantics vs the preregistration.** The capstone
   `geometric_coverage_lower_bound` is verbatim the preregistered bound:
   from `covered 0 = 0`, per-step `(optimum - covered)/k <= gain`, and
   accumulation `covered + gain <= covered (step+1)`, conclude
   `(1 - (1 - 1/k)^k) * optimum <= covered k` over `Rat` - the exact
   inequality quoted in the R2 plan (factor 0.6439... at K = 16), in the
   total-residual form that avoids the killed intersection-deficit route
   (the K=2 counterexample thread). The abstract scalar-recurrence shape
   is exactly instantiable by the selector's archived per-step marginals,
   which is what the plan's gate 1 needs.

## Conditions carried into the run (standing pins)

- Execute the frozen benchmark EXACTLY ONCE (the seed pin in
  `run_benchmark` means any execution is the held-out run).
- Record the raw SHA-256 of the artifact at write time, plus any
  normalized hash with its canonicalization (R1 provenance lesson).
- Harvest and audit 393284aa on return; archive as independent replay.

## Boundary

RUN-CLEARED opens only the frozen finite A3f-R2 packing benchmark.
Source rows, operators, G2, tetrads, curvature, and dynamics stay closed
regardless of outcome, per the preregistration.
