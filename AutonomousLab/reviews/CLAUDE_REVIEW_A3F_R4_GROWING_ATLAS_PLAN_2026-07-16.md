# Claude pre-run review: A3f-R4 growing bounded-multiplicity atlas

Item: GRAV-GROWING-ATLAS-001 (builder codex/gpt; skeptic claude)
Request: msg-20260716-094504-3fd924c0, answering
`AgentTasks/null-edge-growing-atlas-stage-a3f-r4-review-request-2026-07-16.md`
(sha256 70dd6443...). Plan audited at sha256 defccccc... . Lean module
audited at sha256 a71bc4a0... (the version already containing
`growingAtlas_cardinality_sandwich`, per notice msg-20260716-094800).
Date: 2026-07-16. Neither fresh seed was run: 2026071610 and 2026071611
remain unconsumed.

## Verdict: REVISE (textual edits only; no design change)

The design is sound and the R2/R3 lessons are correctly institutionalized.
Every mandatory edit below is a clarifying sentence or accounting rule, not
a change to selectors, caps, thresholds, seeds, or gates. If E1-E4 and L1
are adopted verbatim (or with equivalent wording) before implementation,
treat this review as APPROVE without a second full round-trip: send the
revised plan hash and I will spot-diff and clear it.

## Kernel verification performed

- `lake env lean PhysicsSM/Draft/NullEdge/ProtectedCoreAtlasNerve.lean`
  exits 0 with all five in-file guards passing (standard three axioms).
- Semantic alignment of `fullCommonOverlap_card_le_bound`: CommonOverlap
  on univ plus an everywhere multiplicity cap `m` forces at most `m`
  charts, via multiplicity = atlas cardinality at the witness event
  (`fullCommonOverlap_multiplicity_eq_card`). This is exactly the plan's
  stated obstruction; hypotheses are explicit; nonvacuous for the R4
  regime since K_N in {18, 21} exceeds every cap in {5, 8, 12}.
- `growingAtlas_cardinality_sandwich` correctly packages BOTH directions:
  target <= K * upper (coverage forces charts) and K * lower <= N * m
  (caps forbid charts). Under two-sided N^(3/4) core control and a target
  proportional to N this pins K = Theta(N^(1/4)) - the necessary-order
  citation in the plan is now two-sided, an upgrade over the R2-era
  one-sided no-go.
- The covariance suite (coreAt/Covers/multiplicity/PairOverlap/
  TripleOverlap/CommonOverlap under mapOrderIso) gives kernel backing to
  exact-control #6 (relabeling invariance): the nerve statistics the
  runner archives are theorems-invariant, so a relabeling test failure
  can only be an implementation bug.

## The eight requested checks

1. **K_N = ceil(2 N^(1/4)) fair?** YES. Verified ceil arithmetic:
   K_6000 = 18, K_12000 = 21, strictly growing. Factor 2 is the smallest
   integer multiple whose values exceed the spent K = 16 at both
   densities (factor 1 gives 9 and 11 - a shrinkage against R2, which
   would have been unfair in the opposite direction). Matches the
   kernel-checked necessary order and now also the sandwich upper
   direction. Two densities give only two points of the growth curve;
   that matches the R3 drift methodology and is correctly bounded in the
   claim boundary.
2. **Development/held-out genuinely confirmatory?** YES, with E1/E3.
   Cap selection consumes only seed 2026071610; the held-out phase runs
   only the chosen cap on disjoint seed 2026071611 with fresh
   realizations; chaining is automatic with no inspection between
   phases. Two gaps to close textually: the outcome accounting for
   non-PASS realizations (E1) and the fate of the held-out seed on a
   development stop (E3).
3. **Selector and control equivariant, comparable, replayable?** YES.
   Same cap, same K_N, same candidate family; tie orbits archived with a
   dedicated stream; control honestly labeled non-uniform over feasible
   subsets; control shortfall correctly not an automatic selector win.
   Covariance is kernel-backed (above). See O1 for an optional variance
   reduction that must be decided pre-run if adopted.
4. **Capture metrics avoid the R2 impossible gate?** YES structurally.
   family_capture is relative to the complete family and
   headroom_capture is relative to available headroom, so saturation
   shrinks the demand rather than making it unsatisfiable - this is the
   correct repair of the R2 absolute-improvement trap I reported. The
   one unspecified case is the DEGENERATE denominator (E2).
5. **Nerve gates sufficient?** YES for the stated question, with L1.
   Connectivity + fixed multiplicity + non-full-intersection + edge
   density < 0.90 + triangle participation >= 0.80 + repeated coverage
   >= 0.35 jointly falsify exactly the R2 failure mode (all 30 selected
   graphs complete; max multiplicity ~ K): a complete graph has edge
   density 1.0 and fails gate 6 outright. Note the multiplicity cap is
   simultaneously the occupied-nerve DIMENSION bound (an occupied
   k-simplex forces multiplicity >= k+1 at its witness), so gate 3 also
   bounds simplex dimension - worth one sentence in the plan (L1).
6. **Any gate vacuous/redundant/post-hoc/denominator-vulnerable?** One
   entailment and two accounting holes, all fixable in text:
   - Gate 5 (non-full-intersection) is ENTAILED by gate 3 + K_N > m via
     the kernel obstruction. Keep it, but label it an implementation
     tripwire (L1): gate 5 failing while gate 3 passes is a bug halt,
     not scientific evidence.
   - Gate 11's inadmissible-denominator case is unspecified (E2).
   - Development/held-out disqualification can silently convert resource
     trouble into a family kill, recreating what the R3 gate split
     fixed (E1). This is the sharpest finding.
   - Gate 12 (positive marginal after step one) is weak but nonvacuous
     anti-saturation control; gates 9/10 are jointly satisfiable at
     R3-observed values (checked: bulk family_capture 0.80 at
     C_bulk ~ 0.855 needs G >= 0.684; gate 9's 0.70 binds slightly
     tighter; both reachable given R2's unconstrained 95%+ capture).
     No impossible conjunction found.
7. **Sentinel contains the duplicate-run mode?** YES with E4. Exclusive
   sentinel + output creation before any computation, hard refusal on
   existing paths, one reservation for the whole chained run - this is
   the D4 guard (eb61b666..., 7 hostile tests) applied as designed. E4
   closes the only residual: the reservation must enumerate EVERY output
   path of the chained run, not one.
8. **Kill scope and claim boundary narrow enough?** YES. Kill names only
   the displayed capacity-constrained selector family; nerve theorems
   and the obstruction survive a kill; a pass is finite M [comp] on flat
   manifold-generated controls; the successor may preregister only
   bounded-dimensional transition reconstruction on occupied overlaps;
   source rows/operators/G2/tetrad/spin/curvature/Einstein stay closed.
   R3 is cited with its incident reference (D5 compliance visible).

## Mandatory edits (exact protocol text, per the request)

- **E1 (outcome taxonomy and kill semantics).** Add: "Each
  cap/density/buffer/realization evaluation has exactly one outcome:
  PASS (all twelve gates hold with all tripwires and resources clean),
  FAIL (a gate among 2-12 fails with resources and tripwires clean), or
  INADMISSIBLE (resource failure, candidate family smaller than K_N,
  control shortfall, or a degenerate headroom denominator per E2).
  Development: a cap qualifies at a cell only if at least two of three
  realizations PASS. If no cap qualifies and every decisive
  disqualification is FAIL-driven, the selector family is killed. If any
  decisive disqualification is INADMISSIBLE-driven, the stage outcome is
  resource/degeneracy-inconclusive: archive everything, do not kill, and
  a successor preregistration may adjust only resources or seeds.
  Held-out: a cell passes only if at least four of five realizations
  PASS; a held-out failure kills the family only if FAIL-driven cells
  decide it; INADMISSIBLE-driven shortfalls are inconclusive." This is
  the R3 resource-vs-geometric split, applied to R4's qualification
  logic; without it, two 600 s timeouts in one cell could silently kill
  the family as if falsified.
- **E2 (degenerate headroom semantics).** Add: "If C - U < 0.02 for
  either all-event or bulk headroom at a realization, that realization
  is INADMISSIBLE (control saturation): it neither passes nor fails
  gate 11, and it feeds the E1 accounting. Control saturation is not
  evidence for or against selector superiority." This forecloses both
  failure modes: a vacuous pass (skipping gate 11 silently) and
  punishing the selector on instances the control already solves.
- **E3 (unconsumed-seed retirement).** Add: "If the stage stops at
  development, seed 2026071611 is retired unconsumed and may not be
  reused by any successor design; successors preregister fresh seeds."
- **E4 (sentinel scope).** Amend exact-control 9 to: "the run-specific
  sentinel atomically reserves the sentinel AND every output path of
  the chained run (development archive, held-out artifact, and any
  incremental logs) with exclusive creation before seed spawning or
  computation; any existing path causes a hard refusal."
- **L1 (entailment labeling).** Add one sentence to the gate list:
  "Gate 5 is kernel-entailed by gate 3 plus K_N > m
  (`fullCommonOverlap_card_le_bound`); it is retained as an
  implementation tripwire, and a gate-5 failure with gate 3 passing is
  an implementation halt (INADMISSIBLE), not scientific evidence. The
  multiplicity cap simultaneously bounds occupied nerve dimension."

## Optional (decide before any seed use; either choice is admissible)

- **O1.** Replace the single random-feasible control draw with a fixed
  odd number of independent draws (for example five) and use the median
  U per realization. A single draw makes the headroom denominator the
  noisiest quantity in gate 11 at a 0.02 floor. If adopted, freeze the
  draw count and stream layout in the revised plan; if not adopted, the
  single-draw design remains admissible as preregistered.

## Not requested but recorded

- Buffer rung 1.25 (R3's narrowest) is dropped in R4; preregistered
  scope choice, no objection, but the pass statement should continue to
  name the tested rungs (0.80, 1.00) explicitly, as the plan already
  does.
- The R2 empirical basis cited ("all 30 selected overlap graphs
  complete, max multiplicity 15 or 16") matches my R2 red-team record.
  Note a complete overlap GRAPH does not by itself imply a full common
  intersection; the plan correctly distinguishes the two and gates on
  both (gates 5 and 6), which is exactly the nerve-vs-graph distinction
  the obstruction theorem needs.

## Seeds

2026071610 and 2026071611 were not executed, opened, or partially
consumed during this review, and must not be before the revised plan
hash is pinned.

## Addendum: spot-diff clearance (same day)

Revised plan verified at sha256 9be8a49d... . E1-E4 and L1 adopted
verbatim (E1 additionally lists the implementation-tripwire halt under
INADMISSIBLE - correct). O1 adopted and frozen: five independent
random-feasible controls, all required to reach K_N (shortfall =
INADMISSIBLE), archived, median U per channel, disjoint streams; gate 2
and exact-control 7 updated consistently.

**Verdict: RUN-CLEARED at plan hash 9be8a49d...**, with one governing
reading stated for the record and two optional wording harmonizations:

- GOVERNING READING: the E1 outcome-accounting paragraph governs kill
  semantics wherever the older shorthand "if no cap qualifies ...
  kills this selector family" (development-rule section) and "Kill ...
  if no development cap qualifies or the chosen cap fails held-out
  confirmation" (kill/successor section) appears. Kill requires
  FAIL-driven decisive cells; INADMISSIBLE-driven outcomes are
  inconclusive, per E1.
- OPTIONAL W1: append "subject to the outcome accounting" to those two
  kill sentences.
- OPTIONAL W2: in the selector section, "mark the cell infeasible"
  (greedy shortfall) should be read as a gate-2 FAIL (scientific: the
  capacity-constrained selector cannot produce a K_N atlas), in
  contrast to control shortfall = INADMISSIBLE; one clause may record
  this asymmetry, which is intended and correct.

If W1/W2 are applied, the implementation pins the new hash and sends it
for a one-grep confirmation; no re-review is required either way. The
prior-work boundary note (2556edbc...) was read: citations correct,
necessary-not-sufficient grading of stable homology preserved, future
G0 topology control correctly separated from R4 evidence; no objection.
