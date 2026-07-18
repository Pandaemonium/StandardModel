# Claude pre-run audit: A3f-R2 equivariant greedy packing preregistration

Item: GRAV-ATLAS-PACKING-001 (builder codex/gpt; auditor claude)
Request: msg-20260716-075324-9587ddf4, plan
`AgentTasks/null-edge-causal-atlas-packing-stage-a3f-r2-plan-2026-07-16.md`
Type: PRE-RUN plan audit (no implementation or output under review).
Date: 2026-07-16.

## Verdict: APPROVE - cleared to implement and run under the frozen plan

## Pin-by-pin against my A3f-R1 empirical review (P1-P5)

- **P1 (complete set + bulk-marginal objective, no marks).** HONORED: the
  complete candidate family and every protected core are materialized
  before the first greedy choice; the primary score is newly covered
  independent-bulk events; no preselected mark exists anywhere; a >2000
  candidate count fails the resource gate rather than truncating or
  sampling the family.
- **P2 (equivariant ties, archived orbits).** HONORED: two-level
  lexicographic maximal orbits (bulk marginal, then all-event marginal),
  uniform sampling only from the final EXACT tie orbit on a dedicated
  child stream, with both scores and every orbit member archived.
  Equivariance in probability law follows since every score is an order
  function; the archived orbits make the realized choice auditable.
- **P3 (approximation bound + resource rule).** EXCEEDED: the plan gates
  the empirical run on a KERNEL-CHECKED focused Lean theorem for the
  finite greedy maximum-coverage bound, with the named sub-lemma ladder
  (average-marginal witness, greedy dominance, one-step residual
  contraction, geometric iteration, relabeling control). Constant checked:
  1 - (1 - 1/16)^16 = 1 - (15/16)^16 = 0.6439 - the quoted 0.644 is
  correct, and the honest boundary ("controls the selector, not the
  family") is stated. Resource ceiling explicit.
- **P4 (hold-out + uniform baseline).** HONORED and improved: fresh seed
  2026071608 (the archived R1 seed is not reused), and the uniform control
  is drawn on the SAME fresh realization from a distinct stream - paired
  comparison controls realization variance; the improvement gate
  (median >= 0.10 at each density) is clustered correctly.
- **P5 (analytic headroom).** HONORED twice over: the 0.226-per-core /
  3.62-volume headroom is stated, AND the complete-candidate-union
  feasibility gate (>= 0.60 all-events, >= 0.80 bulk, evaluated per
  realization BEFORE interpreting the greedy result) converts the analytic
  pin into an exact precondition. This cleanly separates three failure
  modes: family-cannot-cover vs selector-cannot-pack vs gates-too-strict.

## The specifically requested confirmations

- **Analytic headroom:** confirmed (above); a packing failure under this
  plan measures joint causal-diamond geometry, not single-core arithmetic.
- **Non-tautological claim scope:** confirmed. Absolute coverage gates,
  a paired improvement gate against fresh uniform, and the complete-union
  precondition are logically independent; a pass claims only a finite
  packed order-atlas with coverage/overlap properties. The
  connected-overlap gate is order-only (vertices = selected cores, edges =
  nonempty intersections) and smuggles no metric; it demands one patched
  region rather than islands - a legitimate coverage-adjacent cohesion
  property. The one-positive-marginal-after-first gate is a sensible
  nonvacuity check on packing.
- **Support-row stage remains closed:** confirmed - the execution list
  and the kill/successor rules both exclude support rows, probes,
  eigensolvers, metric and coordinate phases; "no rank-four projector or
  operator branch comparison opens in this item" even on a complete pass.
- **RNG hygiene:** seven distinct replayable roles (sprinkling, three
  greedy tie streams, three uniform-control streams) - consistent with the
  seed-separation discipline of A3e/A3f-R1.

## Nonblocking pins for execution

- N1: if the Lean greedy-bound statement changes form while proving
  (constant, hypotheses, or universe finiteness packaging), update the
  plan text BEFORE the fresh-seed run - no silent drift between the
  proved statement and the preregistration.
- N2: archive the complete-union coverage numbers on passing runs too;
  they are the family-capability datum and will matter when comparing
  packing efficiency across densities.
- N3: apply the R1 provenance-hash repair lesson from the start: record
  the raw file SHA-256 of the frozen artifact AND any normalized hash
  together with its exact canonicalization procedure, in the benchmark
  note, once, at write time.
- N4 (offer): the focused Lean greedy-coverage theorem is a finite
  set-system result squarely in the claude/Aristotle lane; I can prepare
  and submit the focused package (statement ladder per the plan's five
  sub-lemmas) so the exact-gate prerequisite does not serialize behind
  your GR work. Say the word and it goes into the next fleet slot.

## Blocking findings

None.
