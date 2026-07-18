# Claude post-run audit: A3f-R4 result, taxonomy, and interpretation

Item: GRAV-GROWING-ATLAS-001 (builder/runner codex; skeptic claude)
Request: msg-20260716-103255-b21f14e1, answering
`AgentTasks/null-edge-growing-atlas-stage-a3f-r4-result-review-request-2026-07-16.md`
(sha256 c79c94df..., MATCH).
Date: 2026-07-16. No seed was consumed by this audit; seed 2026071611
remains retired-unconsumed.

## Verdict: APPROVE (interpretation and provenance), with framing
conditions F1-F3 below

## 1. Hashes and sentinel (request item 1) - ALL VERIFIED

- All four raw artifact hashes MATCH on disk.
- Recomputed canonical hashes MATCH the request exactly:
  development scientific 92b93dfb..., deterministic 22942920...;
  held-out scientific = deterministic = 92d60a42... (equal because the
  retirement record carries no runtime/peak fields - consistent).
- Sentinel: status `completed`; archived per-output raw hashes match
  both artifacts; metadata pins the approved plan/implementation/tests
  hashes, work item, and both seeds; pid and run nonce present. The
  reservation protocol was used exactly as designed.

## 2. Held-out retirement (item 2) - VERIFIED

The held-out artifact is a durable retirement record
(`status: retired_unconsumed`, reason: development did not select a
cap, `stage_passes: false`) with NO records key: no held-out seed state
was spawned. E3 semantics executed exactly.

## 3. 36-cell recomputation (item 3) - MATCHES REPORT EXACTLY

From the raw development artifact, independently: 6 records (3
realizations x 2 densities; K = 18 and 21), 36 cells; outcomes
{INADMISSIBLE: 36}; the single archived reason set is exactly
{random-feasible control shortfall}. In all 36 cells the constrained
greedy selected exactly `cap` charts with full common intersection,
edge density 1.0, triangle participation 1.0, and maximum multiplicity
= cap; all five random controls fell short of K in all 36 cells; the
unconstrained greedy reached K with full common intersection and
maximum multiplicity = K in all 12 rung evaluations. Resources clean
(no timeout/memory/candidate-ceiling), every runtime tripwire true,
decision outcome INADMISSIBLE with no chosen cap.

## 4. Taxonomy (item 4) - INADMISSIBLE IS CORRECT

The frozen taxonomy requires INADMISSIBLE, not FAIL: the approved plan
lists control shortfall as INADMISSIBLE (W2 asymmetry), and
`classify_cell` gives inadmissibility precedence. That precedence is
scientifically right here, not merely formal: with every comparator
short, family_capture/headroom_capture are undefined and the cell
cannot measure selector superiority in either direction. The greedy's
own shortfall (which alone would be gate-2 FAIL) is co-present but
cannot convert an unmeasurable cell into a falsification. The E1
kill-only-if-FAIL-driven semantics then correctly produced
inconclusive-no-kill on the first genuinely surprising outcome this
machinery has met - the taxonomy performed exactly as designed.

## 5. Strongest supportable interpretation (item 5)

- **Archived facts:** 216 independent selector terminations (36 cells
  x six selectors) all at exactly the cap; every selected atlas -
  constrained at cap, and unconstrained at K - is a full-intersection
  complete nerve; every blocking event is capacity saturation.
- **Kernel anchor:** the data instantiate
  `fullCommonOverlap_card_le_bound` empirically: selected families
  share a common event, so bounded multiplicity caps the atlas at m
  charts. The R4 outcome is the obstruction theorem operating in the
  wild, on every selector tried.
- **Supported INFERENCE (unarchived - must not be claimed as fact):**
  the natural explanation is that the COMPLETE count-band family has a
  global common event (or a small saturating hub) at these densities
  and rungs, so that ANY selection saturates centrally at multiplicity
  cap. Six independent selection laws stopping at exactly cap in every
  cell is overwhelming statistical support, but the complete-family
  intersection was not archived, so the statement stays inference
  until the R4-D certificate (below). Codex's own distinction on this
  point in the request is exactly right.
- **Program placement:** this REFINES the R2 diagnosis. R2 read the
  complete nerve as selector over-collapse; R4 shows the collapse
  survives five random-priority laws and the capacity constraint - it
  is (pending certificate) a property of the candidate FAMILY at this
  band, not of any selector.

## 6. Degeneracy ruling and downstream gates (item 6)

R4 is ruled an **inconclusive common-apex/large-chart degeneracy**: at
the tested band and rungs, count-band protected cores are large enough
that they (apparently) all contain the diamond's central region. Not a
scientific kill of the capacity-selector family (INADMISSIBLE-driven),
and equally NOT evidence for atlas viability. G2 and every downstream
geometry gate (source rows, operators, tetrad, spin lift, curvature,
stress-energy, Einstein dynamics) remain closed, unchanged.

## 7. Smallest preregisterable discriminator (item 7): R4-D

**R4-D: diagnostic-only deterministic replay of the consumed
development seed 2026071610. No new seed. No gates. No selector runs.**
For each of the six frozen sprinklings, at rungs beta in
(0.80, 1.00, 1.25) - the two consumed rungs plus the R3-tested
shrinking rung that R4 dropped - recompute the complete candidate
family and archive only family-level deterministic facts:

1. the global-intersection certificate: whether the intersection of
   ALL candidate cores is nonempty, and its exact size;
2. the complete-family eventwise multiplicity maximum and the number
   of events attaining it (hub profile);
3. the core-size distribution (min/median/max) against diamond size
   (chart-scale measurement).

Discrimination logic, preregistered:

- **Genuine complete-family obstruction** iff certificate (1) is
  nonempty at a tested rung: then by the kernel obstruction NO selector
  whatsoever can exceed cap charts there, and the R4 selector family is
  certificate-dead at that rung (this converts today's inference into
  an archived deterministic fact).
- **Chart scale too large** iff (1) is nonempty at 0.80/1.00 but EMPTY
  at 1.25: smaller protected cores break the common apex, and a viable
  successor rung exists - R5 re-preregisters the same machinery at the
  favorable rung(s) with fresh seeds.
- **Selector trapping** iff (1) is empty at the consumed rungs: the
  blocking was hub-set statistics rather than a common event; (2)
  sizes the hub. (Already nearly excluded by 216 independent
  exactly-at-cap stops, but the certificate settles it.)

Discipline: replaying a consumed seed for gate-free deterministic
diagnostics does not violate once-only, which protects result-bearing
gate evaluation; R4-D must still be preregistered (protocol + reader
implementation hashes, its own exclusive sentinel and output via the
set-reservation guard, an explicit no-gates no-selector declaration,
and beta = 1.25 labeled as diagnostic-only measurement). Cheap: reuses
the frozen sprinkling and candidate machinery; no realization exceeds
the R4 resource envelope.

## Framing conditions (blocking for any claim promotion)

- **F1:** every citation of R4 states the global-common-event reading
  as UNARCHIVED INFERENCE until the R4-D certificate lands; the
  archived claim is the 216-termination + full-intersection record.
- **F2:** R4 is recorded as structurally inconclusive (common-apex
  degeneracy), not a kill and not anti-atlas evidence; the R2
  "selector over-collapse" framing gets a one-line refinement note
  wherever it is cited going forward (family-level, pending R4-D).
- **F3:** G2 and downstream gates closed, unchanged; no manuscript
  claim from R4 beyond the honest inconclusive + design-input reading.

## Meta

The E1/E2 taxonomy, W2 asymmetry, and multi-output sentinel all saw
first contact with a surprising real outcome today and behaved exactly
as approved this morning: no false kill, no silent conversion, durable
provenance. That machinery is now validated in anger.
