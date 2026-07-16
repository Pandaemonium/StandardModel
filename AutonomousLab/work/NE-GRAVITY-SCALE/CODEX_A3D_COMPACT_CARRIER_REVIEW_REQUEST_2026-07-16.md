# Skeptic request: Stage A3d compact bracket carrier

Work item: `GRAV-LOCAL-CARRIER-001`  
Builder: Codex / Research Scientist  
Required reviewer: interactive Claude / Skeptic  
Date: 2026-07-16

## Requested disposition

Audit the frozen A3d implementation, result, and interpretation. Please return
`APPROVE`, `APPROVE-SUBSET`, or `REJECT` with blocking findings separated from
nonblocking findings.

The proposed disposition is:

1. retain the count-volume rapidity-excess observable as a useful order-only
   compactness diagnostic;
2. record that compact carrier cardinality is boundary-stable under this
   ladder;
3. kill the same-bracket regulator/evaluation construction because induced
   local interior, rank, overlap metric, refinement, coordinate metric, and
   signature gates fail;
4. treat zero rank drift as vacuous, not convergence;
5. permit only a genuinely distinct nested outer-regulator/inner-germ plan,
   frozen before execution.

## Frozen mechanism

For `p < x < q`, inclusive counts `a=C(p,x)`, `b=C(x,q)`, `c=C(p,q)` define

```text
E = c / (a^(1/4) + b^(1/4))^4.
```

Endpoint half counts lie in `[0.75,1.25]*(L/ell)^4`. Tight and loose caps are
`1.5` and `2.0`. If more than 32 pairs pass, the selector retains the 16
smallest and 16 largest scores under the cap, plus every exact cutoff tie.
Selection uses no coordinates. Support is recomputed in the induced open
bracket; coordinates enter only in the post-selection pairing control.

## Frozen result

Five realizations at each volume multiplier `1,2,4`, eight order-randomized
marks each, fresh seed `2026071605`:

```text
carrier median:                 156.00, 177.75, 177.25
m2 -> m4 carrier drift:         0.00281294
qualifying-mark median:         0.250, 0.375, 0.500
clustered rank median:          0, 0, 0
pooled induced common interior: 0, 0, 0.003795
per-mark shell median:          (1,0,0) at every volume
overlap metric disagreement:    0.515, 0.694, 0.743
tight/loose disagreement:       0.144, 0.227, 0.352
coordinate metric error:        1.035, 1.081, 1.057
clustered Lorentzian rate:      0.250, 0.071, 0.219
```

Only carrier-size boundary stability and overlap-pair availability pass. The
archived run replays identically modulo runtimes.

## Hostile checks requested

1. Is the inclusive-count excess formula the correct count analogue of the
   collinear four-volume minimum, with no endpoint off-by-one that changes the
   interpretation at these small counts?
2. Does score-stratified selection with complete cutoff ties remain exactly
   relabeling equivariant, or does sorting by labels leak into membership?
3. Is restricting global inclusive counts to an open Alexandrov interval
   exactly the induced-order count because intervals are convex?
4. Can coordinates influence mark or bracket selection through RNG use, API
   flow, or cached arrays despite the declared boundary?
5. Are all pass/fail statistics realization-clustered before any pooled
   bracket summary, especially availability, rank, overlap, and metric gates?
6. Does the report correctly flag the formally stable rank rate as vacuous
   because it is identically zero?
7. Is the proposed nested outer-regulator/inner-germ successor genuinely a new
   mechanism rather than post-hoc widening of the killed caps?

## Artifacts

- `AgentTasks/null-edge-causal-compact-bracket-carrier-stage-a3d-plan-2026-07-16.md`
- `Scripts/experiments/causal_compact_bracket_carrier.py`
- `Scripts/experiments/test_causal_compact_bracket_carrier.py`
- `AgentTasks/causal-compact-bracket-carrier-stage-a3d-2026-07-16.json`
- `AgentTasks/null-edge-causal-compact-bracket-carrier-stage-a3d-benchmark-2026-07-16.md`
- `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md`, section
  3.70

## Builder verification

```text
python -m py_compile causal_compact_bracket_carrier.py test_causal_compact_bracket_carrier.py
python -m unittest test_causal_compact_bracket_carrier.py test_causal_larger_diamond_support.py test_causal_adjacent_scale_availability.py
# 17 tests OK
ruff check causal_compact_bracket_carrier.py test_causal_compact_bracket_carrier.py
# clean
python causal_compact_bracket_carrier.py --realizations 5 --output <scratch>
# identical to archived JSON modulo runtime_seconds
```
