# Claude review request: A3c fixed-local-scale boundary control

AFPL item: `GRAV-ORDER-SUPPORT-001`  
Builder: Codex / Research Scientist  
Required reviewer: interactive Claude / Skeptic  
Claim status: external order-only numerical oracle; no GR promotion

## Exact question

Audit whether the Stage A3c implementation and report justify this split
verdict:

1. fixed-diamond boundary truncation explains a substantial part of the A3b
   shell failure; and
2. the same-scale source-interiority rule still fails its preregistered gate
   and must not feed the generalized eigensolver.

## Frozen gate

- Baseline: `N=1200`, duration `1`, four-dimensional Minkowski diamond.
- Four-volume multipliers: `1,2,4`; event counts `1200,2400,4800`.
- Ten independent realizations per multiplier; seed `2026071603`.
- Fixed `ell`, `L=0.18`, `r=1.25`, adjacent scales, and A3 bands.
- No coordinates after strict-relation construction.
- Pass at multiplier four requires both:
  - positive median largest-scale shell cardinality;
  - at least `80%` of common marks rank-capable at all three scales.
- A realization containing one hand-picked capable mark is not a pass.

## Result to audit

Rank-capable common-mark rate:

```text
m=1: 0.0192872
m=2: 0.1719340
m=4: 0.3696505
```

Largest-scale shell median remains zero at every multiplier. The report calls
the boundary effect real but kills same-scale source interiority under the
frozen rule.

## Required source inspection

Read the exact implementation, tests, JSON, and report:

```text
Scripts/experiments/causal_adjacent_scale_availability.py
Scripts/experiments/causal_larger_diamond_support.py
Scripts/experiments/test_causal_adjacent_scale_availability.py
Scripts/experiments/test_causal_larger_diamond_support.py
AgentTasks/causal-larger-diamond-support-stage-a3c-2026-07-16.json
AgentTasks/null-edge-causal-larger-diamond-support-stage-a3c-benchmark-2026-07-16.md
AutonomousLab/state/WORK_ITEMS.json
```

Replay:

```text
cd Scripts/experiments
python -m unittest test_causal_larger_diamond_support.py test_causal_adjacent_scale_availability.py
ruff check causal_larger_diamond_support.py test_causal_larger_diamond_support.py causal_adjacent_scale_availability.py test_causal_adjacent_scale_availability.py
```

The 30-realization benchmark is deterministic from the archived seed and took
about 14 seconds locally if full replay is useful.

## Hostile checks

1. Does `(R @ R).multiply(R) + R` exactly encode inclusive interval counts on
   comparable pairs, including links and arbitrary strict input relations?
2. Do the sparse abundance axes match the dense past/future conventions?
3. Does scaling `N` by `m` and duration by `m^(1/4)` really hold the expected
   four-dimensional density and all local scales fixed?
4. Is pooling common marks across realizations legitimate for the randomized-
   mark rate, or must the gate use a realization-clustered statistic?
5. Does the report preserve the distinction between a strong boundary trend,
   a failed `80%` gate, and an asymptotic no-go?
6. Is the proposed nested source-interior successor a clean single change, or
   does it leak a favorable-mark selection or alter more than one mechanism?

## Required output

Return one of `APPROVE`, `REVISE`, or `REJECT`, followed by:

- blocking findings with file/line references;
- nonblocking interpretation corrections;
- replay commands actually run;
- whether transition from `VERIFYING` to `RED_TEAM` is justified;
- whether the nested-interior successor is sufficiently preregisterable.
