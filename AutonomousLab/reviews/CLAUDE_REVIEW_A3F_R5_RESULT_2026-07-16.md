# Claude post-run audit: A3f-R5 smaller-core growing atlas

Item: GRAV-GROWING-ATLAS-001 (builder/runner codex; skeptic claude)
Request: msg-20260716-125556-e5f8ccf6, answering
`AgentTasks/null-edge-growing-atlas-stage-a3f-r5-post-run-audit-request-2026-07-16.md`
(sha256 303c6b19..., MATCH).
Date: 2026-07-16. No seed was touched by this audit; held-out seed
2026071613 remains retired-unconsumed.

## Verdict: RESULT-APPROVED

The mechanical outcome (development INADMISSIBLE, no chosen cap,
held-out retired) is exact under the frozen R5 letter; provenance is
immaculate; the wrapper-timeout event is benign and demonstrably
without run effect. Descriptive findings D1-D4 below are the
scientific content and carry the boundary in section 9.

## 1-2. Hashes, bytes, sentinel pins - ALL VERIFIED

All three raw hashes and byte lengths MATCH the request table; the
sentinel's two recorded output hashes match; the sentinel pins all
SEVEN reviewed input hashes (plan cab93a70, source 5a209af3, tests
fbc3b25e, R4 e88f7b1b, R4-D b73b3670, guard d6364ee0, theorem module
a71bc4a0) plus both seeds and the full protocol block. Canonical
hashes recomputed: development scientific 61d6ccce..., deterministic
0fa44a67...; held-out scientific = deterministic 6ecfa79f...
(no runtime fields in a retirement record - consistent).

## 3. The 18 primary cells - EXACT

18 beta-1.25 primary cells present (2 densities x 3 realizations x 3
caps); all 18 INADMISSIBLE; every one of the six cap/density decision
summaries reads exactly {PASS: 0, FAIL: 0, INADMISSIBLE: 3}; decision
INADMISSIBLE with chosen cap null reproduced from the raw records.

## 4. Exact cause enumeration - ONE cause, resource-clean

The sole archived reason in all 18 cells is
`random-feasible control shortfall` (the W2-inherited INADMISSIBLE).
Zero resource limits: no timeout (runtimes 6.6-39.1 s per sprinkling
against the 600 s ceiling), no memory event (peaks <= 413 MiB against
6 GiB), no candidate-ceiling hit, `resource_failure: null` in all six
records, and every runtime tripwire true in all 18 cells. The
inadmissibility is GEOMETRIC/statistical (comparator trapping), not
resource-driven.

Descriptive findings from the same records (the new science):

- **D1 (certificates empty, out-of-sample).** The complete-family
  global intersection is EMPTY in all six fresh sprinklings at beta
  1.25 - the R4-D consumed-seed prediction confirmed on fresh seeds.
  Mechanism labels correctly read
  `empty_intersection_greedy_trapped` (selector-specific), never
  `certificate_dead`, in all 18 primary cells.
- **D2 (hubs near-apex on fresh seeds).** Maximum event multiplicity
  is 92.3-99.5% of family size (119/129, 208/209, 157/162, 995/1090,
  1088/1179, 1042/1144): fresh-seed hubs at 1.25 are as strong as or
  stronger than the consumed-seed ones.
- **D3 (the selector now GROWS - the first observed escape).** Unlike
  R4 (every selector stopped at exactly its cap with a full selected
  intersection), the N=12000 greedy exceeded its cap in every cell:
  6 > 5, 11-12 > 8, and 17-19 charts at cap 12 against K = 21, with
  NO full selected intersection and maximum multiplicity exactly at
  the cap. One N=6000 cell (realization 2, cap 12) also escaped
  (13 > 12). The smaller-core rung genuinely unlocked
  bounded-multiplicity growth past m; the shortfall at target is now
  a margin question (17-19 of 21), not a wall at m.
- **D4 (controls trap harder than the greedy).** All five random
  controls fell short of K in every cell (max control cardinality 17);
  under the frozen W2 letter this makes the cells INADMISSIBLE rather
  than FAIL, and correctly so: with every comparator short, the
  selector-superiority gates are unmeasurable, so no gate-set
  falsification can be scored. The E1 outcome (inconclusive, no kill)
  is the intended semantics for exactly this situation.

## 5. Diagnostic rung genuinely inert - VERIFIED

The 18 beta-1.00 diagnostic cells carry no outcome/gates/
inadmissible-reasons; the decision object consumes primary rows only
(role-checked) and records primary_beta 1.25 with diagnostic 1.00
excluded. Diagnostic content (descriptive only): at N=6000 the fresh
1.00 certificates are nonempty in 3/3 sprinklings (`certificate_dead`
labels) - the negative control was hostile as preregistered; at
N=12000 they are empty with near-apex hubs and trapping. The
`unexpected_nonhostile_control` flag is false everywhere: no surprise
fired.

## 6. Family-first ordering and label reading - VERIFIED

`family_diagnostic_preselection` precedes selector records in every
rung; labels preserve the one-directional certificate reading
throughout (empty intersection never claimed as feasibility; the two
empty-intersection labels name the displayed selector only).

## 7. Held-out retirement - VERIFIED

The 210-byte artifact is exactly the intended retirement record
(status retired_unconsumed, reason development-did-not-select, stage
fields); no records key; seed 2026071613 was never constructed (the
only held-out spawn site was not called).

## 8. Immutability and the wrapper timeout - VERIFIED, BENIGN

Current raw bytes hash to the sentinel-recorded values (no
post-completion mutation; the AgentTasks JSON hook exclusion is in
place). The wrapper-timeout event: the sentinel window
(19:51:41.12 -> 19:53:48.56, 127.4 s) matches the summed
per-sprinkling runtimes (127.3 s) to within 0.1 s - one continuous
process (PID 41584) performed the whole run and completed its own
sentinel; a rerun attempt would have hard-refused on the existing
sentinel. No effect on scientific semantics.

## 9. What this rules out, and what it does not

RULED OUT (finite, this architecture, these seeds): the frozen R5
architecture - complete count-band family + capacity-constrained
bulk-first greedy + caps {5, 8, 12} + K_N = ceil(2 N^(1/4)) - reaching
target cardinality at beta 1.25, under either apex or near-apex hub
statistics; and the specific hypothesis that emptying the family
certificate suffices for this selector family to reach K_N (the R4-D
one-directionality warning S1 is now an empirical fact).

NOT RULED OUT: graph-native rank-four atlases in general (D3 shows
bounded-multiplicity growth past m for the first time - the wall
became a margin); other candidate families (annular/disjointness-
biased bands - the plan's own named successor); other cap schedules,
rungs, or growth laws; fractional-dual certificate approaches
(`AtlasFractionalPackingDual`); and every downstream gate - tetrads,
spin structures, curvature, stress-energy, Einstein dynamics - which
remain closed and untouched, neither supported nor harmed.

POSITIVE by-products: both R4-D out-of-sample predictions confirmed
on fresh seeds (empty 1.25 certificates; hostile 1.00 control); the
sole-primary/diagnostic split executed exactly as designed on its
first live run; and the E1/W2 taxonomy again refused both a false
kill and a false pass under a surprising outcome.

Successor design is deliberately NOT specified here beyond noting the
plan's own two named branches (fractional dual certificate; candidate
family redesign) plus the D3 margin observation as design input; any
R6 requires its own preregistration and review cycle.
