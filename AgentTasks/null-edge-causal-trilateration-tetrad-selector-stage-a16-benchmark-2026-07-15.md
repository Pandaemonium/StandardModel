# Null-edge causal trilateration tetrad-selector Stage A16 benchmark

Date: 2026-07-15

## Question

Can an intrinsic conditioning objective recover a nondegenerate five-anchor
frame where Stage A15's nearest-ideal-anchor selector failed, and does that
frame supply a locally affine tetrad chart?

## Construction and scope

`Scripts/experiments/causal_trilateration_tetrad_selector.py` uses no known
sprinkling coordinate during construction.

For each realization it:

1. chooses a deep pivot from endpoint interval counts;
2. builds the pivot's Johnston past-by-future lightcone chart;
3. takes the 12 nearest events in that recovered causal cross;
4. uses the center and nearest cross event on each side as three validation
   pivots;
5. restricts lower and upper anchor candidates to events that causally bracket
   every cross event and lie in a supplied intrinsic-time shell;
6. tests every retained lower anchor and every four-element upper-anchor
   combination; and
7. selects the frame with the largest worst-chart normalized minimum singular
   value, then worst-chart volume, condition number, and time-shell mismatch.

The scaffold scale is the Stage A15 value `0.05`, giving target anchor time
`8s = 0.40`. The time shell has relative half-width `0.35`; at most 10 lower
and 18 upper candidates enter the combinatorial search. The intrinsic gate
requires exact causal coverage, normalized worst-chart minimum singular value
at least `0.09`, and maximum chart-frame condition at most `50`.

Known sprinkling coordinates are opened only after anchor selection. The
oracle frame gate requires normalized minimum singular value at least `0.08`
and condition at most `50`. A stronger oracle fits the unique affine map from
each recovered five-anchor frame to its true coordinates, then scores the
remaining nine causal-cross events. Its maximum relative RMS error must not
exceed `0.75`. The same anchor fit between recovered charts gives an entirely
intrinsic transition residual, but does not enter selection.

Dimension, density, global endpoints, anchor scale, cross cardinality, and
thresholds remain supplied. The active cross samples only events causally
related to the pivot, not a full spacetime ball. No metric, connection, or
curvature score is opened.

## Development

Artifact:
`AgentTasks/causal-trilateration-tetrad-selector-stage-a16-development-n2500-2026-07-15.json`

Five `N=2500` realizations use seed `20260820`. Every selected frame brackets
all 12 active events. Aggregated medians are:

- active recovered-chart radius: `0.197`
- common lower and upper candidate counts: `14` and `20`
- retained shell candidate counts: `10` and `18`
- normalized consensus minimum singular value: `0.112`
- consensus maximum condition number: `31.1`
- intrinsic chart-transition residual: `1.335`
- oracle normalized minimum singular value: `0.123`
- oracle frame condition number: `28.0`
- oracle active-event reconstruction error: `1.194`

The intrinsic frame gate and oracle frame gate each pass in four of five
realizations. The same realization fails both, with intrinsic normalized
minimum singular value `0.080` and oracle condition number `152.8`. The
reconstruction and full derived-tetrad gates pass in none of the five.

## Held-out test

Artifact:
`AgentTasks/causal-trilateration-tetrad-selector-stage-a16-heldout-n4000-2026-07-15.json`

Three fresh `N=4000` realizations use seed `20260825` and all settings above
unchanged. Every realization passes both the intrinsic and oracle frame gates:

- exact active causal coverage: `100%`
- median active recovered-chart radius: `0.154`
- median common lower and upper candidate counts: `71` and `23`
- median normalized consensus minimum singular value: `0.163`
- median consensus maximum condition number: `22.9`
- median oracle normalized minimum singular value: `0.167`
- median oracle condition number: `21.9`

This repairs the specific Stage A15 held-out rank/conditioning failure. The
nearest-ideal selector had median condition `182.7` and zero scaffold passes;
the conditioning-first selector has median condition `22.9` intrinsically and
`21.9` in the true coordinates, with 100% frame-gate passes.

The local-chart controls still fail in all three realizations:

- median intrinsic chart-transition residual: `1.131`
- median oracle active-event reconstruction error: `0.910`
- oracle reconstruction gate success rate: `0%`
- full derived-tetrad gate success rate: `0%`

The best reconstruction error is `0.759`, just above the frozen `0.75` gate;
the other two are `0.910` and `1.013`. Higher density stabilizes the selected
anchor frame but does not make the surrounding Johnston coordinates affine.

## Verdict

**Retain chart-consensus max-volume selection as a positive anchor-frame
result.** In the held-out sample it constructs exact common causal brackets,
passes its intrinsic conditioning gate in every realization, and remains
well-conditioned after the known coordinates are opened. This is a material
gain over nearest-ideal-anchor selection.

**Do not call the result a derived tetrad or atlas.** A well-conditioned set of
five anchors does not force nearby event coordinates to agree under the
anchor-induced affine maps. Both the intrinsic transition residual and the
oracle held-out reconstruction control fail. The result derives a stable
frame candidate from supplied dimension, density, endpoints, and scale; it
does not yet derive a local coframe field from a bare graph.

The next reconstruction should retain these selected brackets as hard
conditioning constraints in a joint shared-event coordinate fit. It should
optimize anchor consistency and held-out cross-event geometry together, with
the present selection rule and controls frozen. Connection and curvature
benchmarks remain closed until that atlas gate passes.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_trilateration_tetrad_selector.py`
- `python -m ruff check Scripts/experiments/causal_trilateration_tetrad_selector.py Scripts/experiments/test_causal_trilateration_tetrad_selector.py`
- Development and held-out commands, settings, selected indices, per-sample
  gates, and aggregate statistics are retained in the JSON artifacts.

## Primary source

- Nathan Madsen, "On the Uniqueness of Embeddings of Causal Sets,"
  [arXiv:2607.05840](https://arxiv.org/abs/2607.05840), especially Definition
  2.6, the anchor-scaffold lemma, Lorentzian trilateration identity, and
  approximate-isometry theorem.
