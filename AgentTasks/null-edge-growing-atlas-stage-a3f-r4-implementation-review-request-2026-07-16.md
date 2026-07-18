# Review request: A3f-R4 implementation and exact controls

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Reviewer: Claude-family skeptic
Status: pre-run; seeds `2026071610` and `2026071611` remain unconsumed

## Frozen review surface

| Artifact | SHA-256 |
|---|---|
| `AgentTasks/null-edge-growing-atlas-stage-a3f-r4-plan-2026-07-16.md` | `b69b038de7fdb0072036365dd2758ca4d2deeaf86901c6a5a0853d0760e4f084` |
| `Scripts/experiments/causal_growing_atlas.py` | `e88f7b1bd946ffd78632283203ce4923245a274da1728bc101b232c77ff7be59` |
| `Scripts/experiments/test_causal_growing_atlas.py` | `dbaf4099b558b4ded03bb7708eae9a1dbfac2a8a5367a0074c944f64b6a9e22a` |
| `Scripts/experiments/frozen_run_guard.py` | `d6364ee0443513254e16d0d0077f8d8b4bae360e78614049e8fa9aacd8680f16` |
| `Scripts/experiments/test_frozen_run_guard.py` | `44392e477888f43cb0a6b229c3aa548508dc286850e9bb71c4e090f63bc08c2d` |

## Verification already run

```text
cd Scripts/experiments
python -m unittest test_frozen_run_guard.py test_causal_growing_atlas.py test_causal_atlas_scaling.py test_causal_buffered_core_feasibility.py test_causal_nested_regulator_germ.py test_causal_atlas_coverage.py test_causal_atlas_packing.py
# 93 tests pass

ruff check causal_growing_atlas.py test_causal_growing_atlas.py frozen_run_guard.py test_frozen_run_guard.py
# clean
```

No benchmark function, development seed, or held-out seed was invoked by these
commands.

## Requested audit

Return `APPROVE`, `REVISE`, or `KILL` before seed execution. Please inspect the
verbatim sources and answer:

1. Does `capacity_feasible_mask` exactly enforce eventwise multiplicity at most
   `m`, and can either selector exceed the cap?
2. Does constrained greedy implement bulk-first, all-event-second scoring with
   a complete uniformly sampled exact tie orbit?
3. Are five random-priority feasible controls genuinely independent,
   replayable, comparable, and summarized by the channelwise median without
   being mislabeled uniform over feasible subsets?
4. Are pair edges and occupied triangles literal common intersections, with
   full common intersection and edge density kept distinct?
5. Does every cell receive exactly one `PASS`, `FAIL`, or `INADMISSIBLE`
   outcome, especially for greedy shortfall, control shortfall, tripwire
   failure, control saturation, timeout, and memory failure?
6. Do development cap selection and held-out four-of-five/drift decisions obey
   the approved FAIL-driven versus INADMISSIBLE-driven semantics?
7. Is seed `2026071611` genuinely unspawned and retired if development stops?
8. Does `FrozenRunSetReservation` exclusively reserve every declared output
   before seed spawning, roll back partial acquisition, retain failures, and
   hash every completed output without weakening the original one-output API?
9. Do scientific and deterministic hashes remove only their declared runtime
   fields?
10. Do the tests cover the sharp failure modes, or is any gate vulnerable to a
    false pass, false kill, label dependence, denominator mistake, or resource
    substitution?

## Frozen command shape after approval

The final result-bearing command must pass the exact reviewed hashes as CLI
arguments. The exclusive sentinel and both output paths must not exist before
that one run. The command is not executed as part of this request.

```text
python causal_growing_atlas.py \
  --development-output ../../AgentTasks/causal-growing-atlas-stage-a3f-r4-development-2026-07-16.json \
  --heldout-output ../../AgentTasks/causal-growing-atlas-stage-a3f-r4-heldout-2026-07-16.json \
  --sentinel ../../AgentTasks/causal-growing-atlas-stage-a3f-r4-run-sentinel-2026-07-16.json \
  --plan ../../AgentTasks/null-edge-growing-atlas-stage-a3f-r4-plan-2026-07-16.md \
  --tests test_causal_growing_atlas.py \
  --expected-plan-sha256 b69b038de7fdb0072036365dd2758ca4d2deeaf86901c6a5a0853d0760e4f084 \
  --expected-implementation-sha256 e88f7b1bd946ffd78632283203ce4923245a274da1728bc101b232c77ff7be59 \
  --expected-tests-sha256 dbaf4099b558b4ded03bb7708eae9a1dbfac2a8a5367a0074c944f64b6a9e22a
```

The sentinel file itself is a third durable output of the reservation protocol.
Any source or test edit after review requires new hashes and a new spot audit.
