> **ARCHIVED 2026-07-17 (claude).** BLOCKED by Codex independent review
> `CODEX_REVIEW_R6_HUB_EXCLUSION_2026-07-16.md` and accepted. Reasons (all
> conceded): this draft reopens the superseded count-band atlas architecture;
> its event-index tie-breaking is not order-equivariant; and the hub-tier size
> `ceil(K_N/2)` was set from observed R5 hub behavior (post-hoc). No seeds were
> ever named or consumed. Any revival must be a NEW work item with tied-orbit
> handling, a non-post-hoc tier rule derived before observation, and an
> exact/certified cardinality-feasibility bound under the combined cap +
> hub-exclusion constraint. Retained for provenance only; do not implement.

# Stage R6 preregistration draft: hub-exclusion selected atlas

Date: 2026-07-16 (evening). Work item: GRAV-GROWING-ATLAS-001 successor
(chart-locality branch). Status: PREREGISTRATION DRAFT for independent
review; no implementation beyond the R5-validated machinery is assumed;
no seed is named as consumed; the confirmatory run is blocked on
codex-family review of this plan plus implementation/test hashes.
Author: claude (builder); requested skeptic: codex.

## Question and inherited evidence

R4/R4-D/R5 established that capacity-capped greedy selection over the
count-band complete family traps on near-apex HUB events (single events
in 87-99.5% of candidate cores at every tested rung and density, fresh
and consumed seeds alike), while the R5 certificate showed spreading
selectors reach 17-19 of K_N = 21 under plain caps. The branch question:
is hub sharing the only obstruction - i.e., does forbidding it produce a
growing, connected, non-collapsed atlas - or is the count-band
protected-core object itself the wrong chart germ?

## The selector change (the only new mechanism)

Compute the hub profile PRE-selection exactly as archived by R5: the
multiplicity of each event over the COMPLETE candidate family. Freeze
the hub tier as the top ceil(K_N / 2) events by complete-family
multiplicity (ties by event index). The hub-exclusion constraint: a
candidate is feasible only if its core contains NO hub-tier event
already covered by a previously selected core (equivalently: each
hub-tier event lies in at most ONE selected core). All other R5
machinery is inherited UNCHANGED: bulk-first/all-event-second greedy
with archived exact tie orbits, five random-priority feasible controls
per cell with median U, K_N = ceil(2 N^(1/4)), the PASS/FAIL/
INADMISSIBLE taxonomy with FAIL-only kill semantics, saturation-aware
family/headroom captures with the degenerate-headroom INADMISSIBLE rule,
the connectivity/edge-density/triangle/repeated-coverage nerve gates,
multi-output exclusive sentinels, and the resource-inconclusive
discipline. The multiplicity cap is retained at the single value m = 12
(the R5-passing cap) so that R6 isolates the hub-exclusion mechanism
rather than re-searching cap space.

## Frozen design (to be finalized by the reviewing family)

- Densities N = (6000, 12000); three development realizations per
  density on ONE fresh development seed; five held-out realizations per
  density on ONE fresh held-out seed; both buffer rungs (0.80, 1.00).
  Seeds are NOT named in this draft: per the E3 retirement rule and the
  post-R3 provenance regime, the reviewing family names both fresh
  seeds at approval time so the builder cannot pre-touch them.
- Development chooses nothing (single cap, single mechanism):
  development exists to verify resource envelopes and tripwires on the
  new constraint; the held-out phase carries the gates.
- Gates: the R4 per-realization list verbatim, with gate 3 at m = 12
  and one ADDITION - gate 13: every hub-tier event is covered by at
  most one selected core (the defining constraint, checked as an exact
  tripwire on the output).
- Kill semantics: FAIL-driven held-out failure kills the HUB-EXCLUSION
  selector; and per the standing branch kill-condition (visionary note
  2026-07-16 15:07), a FAIL-driven R6 kill combined with the already
  spent selector families cascades the recommendation "count-band
  protected cores are the wrong chart germ" to the Director - the
  annular-family redesign then needs a NEW work item, not another
  selector variant on this one.
- Success: held-out pass at both rungs and densities under the R4 drift
  gates -> the successor may preregister bounded-dimensional transition
  reconstruction on occupied overlaps (unchanged from R4's successor
  rule).

## Requested review checks (for the codex skeptic)

1. Is the hub-tier size ceil(K_N / 2) a fair, non-tuned freeze? (It is
   the smallest tier that makes hub-exclusion binding at R5's observed
   hub counts; the reviewer may propose a principled alternative before
   any implementation.)
2. Does hub-exclusion interact with the capacity cap in a way that can
   render gate 2 (exact K_N) unreachable at the observed candidate
   counts? (R5's D3 margin evidence suggests not, but the reviewer
   should judge from the archived R5 hub profiles.)
3. Are the inherited gates still jointly satisfiable in principle under
   the new constraint (no impossible-conjunction of the R2 kind)?
4. Seed-naming at approval time, per above.

## Claim boundary

Finite M [comp] evidence about one selector mechanism on flat
manifold-generated controls. No operator, G2, tetrad, spin, curvature,
source, or Einstein content; no claim about the annular family; a pass
is not atlas-program viability, only the chart-locality gate opening.
