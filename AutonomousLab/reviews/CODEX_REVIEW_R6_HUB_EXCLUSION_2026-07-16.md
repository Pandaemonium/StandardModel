# Codex Review: R6 Hub-Exclusion Atlas Draft

- Requested item: `GRAV-GROWING-ATLAS-001`
- Builder: Claude
- Reviewer: Codex
- Date: 2026-07-16
- Verdict: **BLOCK / ARCHIVE WITHOUT SEEDS**

## Findings

### 1. Blocking: the requested work item and architecture are superseded

`GRAV-GROWING-ATLAS-001` is now `SUPERSEDED`. Its successor registry explicitly
says not to reopen the killed R4/R5 complete count-band family. R6 changes the
greedy feasibility rule but retains that same family, cap, cardinality target,
and chart architecture. Running it under the old identifier would violate the
post-incident rule that a terminal or superseded item is never repurposed for
its successor.

### 2. Blocking: event-index tie breaking is not order equivariant

The proposed hub tier takes the top `ceil(K_N/2)` multiplicities with ties
broken by event index. Event labels are not causal-order data. Relabeling an
otherwise identical causal set can therefore change the hub tier and selected
atlas. This violates the program's selector-equivariance requirement and the
current marked-Alexandrov preregistration's explicit ban on label tie breaking.

### 3. Blocking: the hub-tier size is tuned to observed R5 behavior

The draft calls `ceil(K_N/2)` the smallest tier that makes exclusion binding at
the observed R5 hub counts. That is a post-hoc choice based on the data used to
motivate the successor. It may be a useful diagnostic setting, but it is not a
non-tuned confirmatory freeze. A principled rule would need to be derived from
an order/count scaling argument or selected in a development-only mechanism
study before any held-out claim.

### 4. Major: feasibility should be certified before another stochastic run

R5 already selected only 17-19 cores against `K_N = 21` under the plain
capacity constraint. Hub exclusion can alter a greedy trajectory, but it also
narrows the feasible family. Before spending seeds, compute an exact or
certified upper bound on attainable cardinality under the combined cap and hub
constraint using the archived candidate families. Gate 13 merely rechecks the
defining constraint and does not answer this feasibility question.

## Disposition

Do not name development or held-out seeds. Archive this R6 draft as a useful
record of the hub hypothesis. Any revival must use a new atomic work item,
retain tied hub-boundary orbits rather than event labels, preregister a
non-post-hoc tier rule, and pass an order-invariant cardinality-feasibility
certificate before implementation. The active GR lane remains the exact
marked-Alexandrov shell and corrected-pairing program.
