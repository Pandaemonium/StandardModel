# Stage A3f-R5 preregistration: smaller-core growing atlas

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Status: `PLAN-CLEARED`; implementation may begin, but do not execute before a
separate source/hash review returns `RUN-CLEARED`

## Question and inherited evidence

Can the unchanged R4 capacity-constrained selector reach the growing target
cardinality when the protected cores are small enough that the complete
candidate family no longer has a common event?

R4 returned `INADMISSIBLE` in all 36 development cells: every constrained
selector stopped exactly at its cap, every selected family had a full common
intersection, and every random-feasible control also shorted. R4-D then
replayed the six consumed development sprinklings without selectors or gates.
It found:

- beta `0.80`: complete-family global intersection in `6/6` sprinklings;
- beta `1.00`: global intersection in `2/6`, with near-universal hubs in the
  other four;
- diagnostic-only beta `1.25`: empty global intersection in `6/6`, nonempty
  cores, and maximum hub fractions from `87.4%` to `97.9%`.

The implication is one-directional. A nonempty complete-family intersection
proves that no capacity-`m` selector can exceed `m` charts. An empty
intersection removes only that theorem-level obstruction; strong hubs may
still trap the selector. R5 is the fresh-seed discriminator.

The earlier R3 provenance incident remains attached to this lane:
`INC-2026-07-16-A3F-R3-DUPLICATE-RUN`, deterministic fingerprint
`2bddbd2e26a24598a04252d68b776bd8685a8cfeaca1303e9eb45f27348b8085`.

## Frozen construction

Inherit the R4 graph, chart, core, bulk, cardinality, selector, controls,
metrics, topology gates, outcome taxonomy, and ceilings verbatim except for the
explicit primary/control rung split below.

For `N` random events plus the standard top endpoint, use

```text
n_R = N^(3/4),  n_S = N^(1/2),  n_L = N^(1/4).
```

Construct every comparable endpoint pair whose stored inclusive interval count
lies in `[0.90,1.10] n_R`. For each beta, use

```text
H_beta = beta^4 n_S,
Core_beta(p,q) = {x in I(p,q) |
                  H_beta <= C(p,x)+1 and H_beta <= C(x,q)+1},
Bulk_beta = {x | indegree(x) >= H_beta and outdegree(x) >= H_beta}.
```

`C(u,v)` is the open interval count. Coordinates generate only the oracle
causal relation and are deleted before candidate, selector, diagnostic, nerve,
or gate logic.

## Primary and diagnostic rungs

Freeze exactly two rungs on every fresh sprinkling:

```text
result-bearing primary: beta = 1.25
diagnostic negative control: beta = 1.00
```

Beta `1.25` is the **only** rung used for cap selection, realization outcomes,
development qualification, held-out confirmation, and cross-density drift.

Beta `1.00` is recomputed on the same fresh sprinklings with the same candidate,
selector, cap, and metric definitions, but it is explicitly excluded from:

- `PASS`, `FAIL`, or `INADMISSIBLE` assignment;
- cap qualification or selection;
- development or held-out aggregation;
- cross-density drift gates; and
- kill or promotion logic.

The diagnostic expectation is renewed apex/near-apex trapping. For each cap,
archive whether the constrained greedy reaches `K_N`, every control cardinality,
and all ordinary R4 metrics. Define `unexpected_nonhostile_control = true`
exactly when the diagnostic constrained greedy reaches `K_N` while respecting
the cap. This flag is descriptive and triggers post-run review; it has no gate
effect in either direction. Making hostile behavior a pass condition is
forbidden because it would make an informative negative-control surprise fail
the primary stage.

## Growing cardinality and capacities

Keep

```text
K_N = ceil(2 N^(1/4)),
m in (5, 8, 12).
```

Thus `K_6000 = 18` and `K_12000 = 21`. A realization is inadmissible if the
complete family has fewer than `K_N` candidates. No cap, threshold, selector,
or target cardinality is tuned from R4-D.

## Selector and controls

Use the R4 capacity-constrained greedy selector exactly:

1. accept only candidates whose addition preserves eventwise multiplicity at
   most `m`;
2. maximize marginal bulk coverage of the rung under evaluation;
3. break remaining ties by marginal all-event coverage;
4. archive the complete exact tie orbit; and
5. sample uniformly from that orbit with the dedicated stream.

Reject empty cores. Select exactly `K_N` distinct candidates or record a
primary gate-2 `FAIL`.

For every cap and rung, run five replayable random-priority feasible controls
as in R4. On the primary rung, every control must reach `K_N`; a shortfall is
`INADMISSIBLE` under the inherited W2 asymmetry. Diagnostic-rung control
shortfalls are archived only and cannot affect the primary outcome.

## Pre-selection family diagnostics

Before any selector or control is called on each realization and rung, archive
the complete-family quantities introduced by R4-D:

- family empty flag;
- global-intersection flag and exact size, using `null` for an empty family;
- maximum event multiplicity over every diamond event, including the top;
- number of events attaining the maximum;
- exact core-size minimum, median, and maximum; and
- the corresponding fractions of `diamond_event_count`.

These fields are descriptive and never replace the frozen primary outcome.
For each primary cap, archive the following descriptive mechanism label:

- `certificate_dead` if the complete-family intersection is nonempty;
- `empty_intersection_greedy_trapped` if it is empty and constrained greedy
  stops before `K_N`; or
- `empty_intersection_greedy_reaches_target` if it is empty and constrained
  greedy reaches `K_N`.

Only `certificate_dead` is a universal no-selector statement. The two greedy
labels concern the displayed selector, not the global packing optimum.

## Primary per-realization gates

At beta `1.25`, inherit all twelve R4 gates without change. A realization
passes only if:

1. every resource, replay, candidate, carrier, core, bulk, containment,
   induced-count, factorization, relabeling, and pre-selection diagnostic
   tripwire passes;
2. constrained greedy and all five controls select exactly `K_N`;
3. selected maximum multiplicity is at most `m`;
4. the selected overlap graph is connected;
5. the selected cores do not have a full common intersection;
6. overlap edge density is strictly below `0.90`;
7. at least `0.80` of selected charts participate in an occupied triangle;
8. repeated-given-covered-bulk coverage is at least `0.35`;
9. selected bulk coverage is at least `0.70`;
10. all-event and bulk family capture are each at least `0.80`;
11. all-event and bulk headroom capture are each at least `0.50`, with the
    inherited minimum headroom `0.02`; and
12. at least one greedy step after the first has positive all-event marginal.

Gate 5 remains an implementation tripwire because gate 3 plus `K_N > m`
entails it through
`ProtectedCoreAtlasNerve.fullCommonOverlap_card_le_bound`.

## Outcome taxonomy

Use the R4 E1/E2/W2 taxonomy on beta `1.25` only:

- `PASS`: all primary gates and tripwires pass;
- `FAIL`: a scientific primary gate among 2-12 fails with resources and
  tripwires clean; or
- `INADMISSIBLE`: resource failure, too few candidates, random-control
  shortfall, implementation-tripwire halt, or degenerate headroom.

A constrained-greedy primary shortfall is `FAIL`. A primary random-control
shortfall is `INADMISSIBLE`. If no cap qualifies and every decisive
disqualification is `FAIL`-driven, kill only the displayed selector at this
frozen construction. Any decisive `INADMISSIBLE` path is inconclusive. The
diagnostic beta `1.00` cannot decide either classification.

## Fresh development and held-out protocol

Freeze fresh seeds not used elsewhere in the repository:

```text
development seed = 2026071612
held-out seed = 2026071613
```

Development uses `N in (6000,12000)`, three realizations per density, both
rungs, and all three caps. A cap qualifies only if at least two of three
**primary beta `1.25`** realizations pass at each density. Choose the smallest
qualifying cap automatically inside the frozen runner.

If development selects a cap, continue automatically to held-out seed
`2026071613`, five new realizations per density, both rungs, and only the chosen
cap. A held-out density passes when at least four of five primary realizations
pass. Apply the inherited `0.15` maximum cross-density drift to clustered
primary-rung medians of family capture, headroom capture, repeated coverage,
and triangle participation. No diagnostic-rung value enters drift.

If development selects no cap, write a held-out retirement record without
spawning the held-out seed. The held-out seed is then retired-unconsumed and
may not be reused.

## Resource and reservation protocol

Keep the R4 ceilings unchanged:

- complete candidate ceiling: `4000`;
- peak process working set: `6 GiB`;
- wall time: `600 s` per sprinkling, including both rungs;
- dense relation ceiling: `(12001)^2` Booleans; and
- existing NumPy, SciPy, and psutil only.

The set-reservation sentinel must atomically reserve, before seed spawning or
RNG construction:

```text
AgentTasks/causal-growing-atlas-stage-a3f-r5-run-sentinel-2026-07-16.json
AgentTasks/causal-growing-atlas-stage-a3f-r5-development-2026-07-16.json
AgentTasks/causal-growing-atlas-stage-a3f-r5-heldout-2026-07-16.json
```

Any existing path is a hard refusal. A failure retains the sentinel and does
not authorize a second run. Frozen result and sentinel artifacts are excluded
from formatting hooks after creation; their raw bytes are immutable evidence.

## Pre-execution review sequence

1. Independent review approves or revises this plan without implementation or
   output.
2. Freeze the approved plan hash.
3. Implement R5 in new source and test files; do not edit R4 or R4-D artifacts.
4. Test exact R4 parity away from the rung-decision split, the sole-primary
   aggregation rule, diagnostic exclusion, pre-selection family facts, seed
   tree separation, and multi-output reservation.
5. Pin plan, source, tests, imported R4 source, guard, and theorem-module hashes.
6. Independent source/hash review returns `RUN-CLEARED` or `REVISE`.
7. Execute the exact frozen command once only after `RUN-CLEARED` and path
   absence checks.
8. Return raw artifacts and hashes for independent recomputation before any
   scientific interpretation.

## Claim boundary and successor

A held-out R5 pass is finite `M [comp]` evidence that this selected complete
count-band family supports a growing bounded-multiplicity protected-core atlas
on the tested flat manifold-generated controls. It does not establish an
asymptotic atlas, derive rank four, Lorentzian signature, a tetrad, spin lift,
curvature convergence, stress-energy, or Einstein dynamics. G2 remains closed.

If beta `1.25` remains uniformly trapped with empty complete-family
intersections, the next step is not threshold relaxation. A separately
preregistered diagnostic may search for a rational fractional dual certificate
using `AtlasFractionalPackingDual.lean`, or redesign the count-band candidate
family with annular/disjointness bias. Neither option is part of R5.

## Provenance

This repaired design follows
`AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R4D_RESULT_2026-07-16.md` and the
cross-family correction in mailbox messages `msg-20260716-113227-833fc0c2`
and `msg-20260716-113842-aca93013`. The correction prevents the known-hostile
diagnostic rung from making primary qualification impossible by construction.
