# Review request: A3f-R5 implementation and exact controls

Date: 2026-07-16  
Work item: `GRAV-GROWING-ATLAS-001`  
Required verdict: `RUN-CLEARED` or `REVISE`; execution remains unauthorized

## Frozen review surface

| Artifact | SHA-256 |
|---|---|
| `AgentTasks/null-edge-growing-atlas-stage-a3f-r5-plan-2026-07-16.md` | `cab93a70dda3dd3ac04b715ebf8cddcbe44cc840436b382d3721f06fa69e0eb1` |
| `Scripts/experiments/causal_smaller_core_growing_atlas.py` | `5a209af3938adaf2677e965411aa31e98fb21744ce65b88f0be6d35e692c3aff` |
| `Scripts/experiments/test_causal_smaller_core_growing_atlas.py` | `fbc3b25e748f00ddde0680ecb4f87048f1b0e7bad45d1ab5ba6e60cdf09385d4` |
| Imported R4 source `Scripts/experiments/causal_growing_atlas.py` | `e88f7b1bd946ffd78632283203ce4923245a274da1728bc101b232c77ff7be59` |
| Imported R4-D source `Scripts/experiments/causal_growing_atlas_diagnostic.py` | `b73b367073e4dbf38eac16f216e946fb6d3f67a8c1765760779ba9b2983ef553` |
| `Scripts/experiments/frozen_run_guard.py` | `d6364ee0443513254e16d0d0077f8d8b4bae360e78614049e8fa9aacd8680f16` |
| `PhysicsSM/Draft/NullEdge/ProtectedCoreAtlasNerve.lean` | `a71bc4a0b6810d980c1fea261bfad808c6e3d0a472ae19dc7245b79f69e2466f` |

The frozen seed integers and their child-state separation were exercised only
by unit tests. No sprinkling was generated, `evaluate_realization`,
`run_phase`, and `run_chained_benchmark` were not called, and all three R5
workspace output paths remain absent.

## Verification already run

From `Scripts/experiments`:

```text
ruff check causal_smaller_core_growing_atlas.py test_causal_smaller_core_growing_atlas.py causal_growing_atlas.py test_causal_growing_atlas.py causal_growing_atlas_diagnostic.py test_causal_growing_atlas_diagnostic.py frozen_run_guard.py test_frozen_run_guard.py
python -m unittest test_frozen_run_guard.py test_causal_smaller_core_growing_atlas.py test_causal_growing_atlas.py test_causal_growing_atlas_diagnostic.py test_causal_atlas_scaling.py test_causal_buffered_core_feasibility.py test_causal_nested_regulator_germ.py test_causal_atlas_coverage.py test_causal_atlas_packing.py
```

Ruff is clean and all 129 tests pass. Scoped pre-commit passes. The pinned Lean
module also passes:

```text
lake env lean PhysicsSM/Draft/NullEdge/ProtectedCoreAtlasNerve.lean
```

The 19 R5 tests cover seed-tree replay/disjointness, exact R4 constants,
primary/diagnostic role separation, diagnostic outcome stripping, diagnostic
resource handling, same-rung bulk scoring, preselection ordering, mechanism
labels, primary-only cap qualification and drift, unreviewed-rung rejection,
set reservation before the runner, canonical hashes, and the coordinate
firewall.

## Requested blocking audit

1. Confirm the implementation imports the frozen R4 selector, controls,
   metrics, thresholds, gates, taxonomy, and ceilings without changing them.
2. Confirm beta `1.25` is the only rung visible to `_cell_rows`, development
   cap qualification, held-out four-of-five, drift, and stage outcome logic.
3. Confirm beta `1.00` records contain no `outcome`, `gates`, or
   `inadmissible_reasons` assignment, and neither selector success nor
   shortfall can help or hurt the primary stage.
4. Confirm every selector receives the `bulk` array computed for the rung
   under evaluation; no diagnostic selector can score beta-1.25 bulk.
5. Confirm `summarize_complete_family` executes before unconstrained or
   constrained selectors, and the mechanism labels preserve the
   one-directional certificate reading.
6. Confirm the same fresh sprinkling is shared across both rungs while all
   selector/control streams and development/held-out roots remain disjoint and
   replayable.
7. Confirm primary greedy shortfall, random-control shortfall, tripwire,
   saturation, timeout, memory, cap selection, and held-out semantics remain
   exactly the reviewed R4 rules.
8. Confirm the sentinel and both output paths are acquired exclusively before
   the runner can spawn either seed; failed acquisition cannot leave a partial
   reservation; completed bytes are outside mutating pre-commit hooks.
9. Confirm plan/source/test/R4/R4-D/guard/theorem hashes are all verified before
   reservation and copied into the sentinel metadata.
10. Confirm a pass remains finite atlas/nerve evidence only and cannot open G2,
    a tetrad/spin structure, curvature, stress-energy, or Einstein dynamics.

Please replay the 129-test suite, Ruff, and the pinned Lean check. Return
`RUN-CLEARED` only if every blocking question passes at the displayed hashes.
Do not call `run_phase`, construct a sprinkling, or create any R5 output path
during review.

## Exact frozen command after `RUN-CLEARED`

Run once from `Scripts/experiments` only after confirming all three reserved
paths remain absent:

```text
python causal_smaller_core_growing_atlas.py --development-output ../../AgentTasks/causal-growing-atlas-stage-a3f-r5-development-2026-07-16.json --heldout-output ../../AgentTasks/causal-growing-atlas-stage-a3f-r5-heldout-2026-07-16.json --sentinel ../../AgentTasks/causal-growing-atlas-stage-a3f-r5-run-sentinel-2026-07-16.json --plan ../../AgentTasks/null-edge-growing-atlas-stage-a3f-r5-plan-2026-07-16.md --tests test_causal_smaller_core_growing_atlas.py --r4-source causal_growing_atlas.py --r4d-source causal_growing_atlas_diagnostic.py --guard frozen_run_guard.py --theorem-module ../../PhysicsSM/Draft/NullEdge/ProtectedCoreAtlasNerve.lean --expected-plan-sha256 cab93a70dda3dd3ac04b715ebf8cddcbe44cc840436b382d3721f06fa69e0eb1 --expected-implementation-sha256 5a209af3938adaf2677e965411aa31e98fb21744ce65b88f0be6d35e692c3aff --expected-tests-sha256 fbc3b25e748f00ddde0680ecb4f87048f1b0e7bad45d1ab5ba6e60cdf09385d4 --expected-r4-source-sha256 e88f7b1bd946ffd78632283203ce4923245a274da1728bc101b232c77ff7be59 --expected-r4d-source-sha256 b73b367073e4dbf38eac16f216e946fb6d3f67a8c1765760779ba9b2983ef553 --expected-guard-sha256 d6364ee0443513254e16d0d0077f8d8b4bae360e78614049e8fa9aacd8680f16 --expected-theorem-module-sha256 a71bc4a0b6810d980c1fea261bfad808c6e3d0a472ae19dc7245b79f69e2466f
```

Any source, test, plan, guard, imported source, or theorem-module edit after
review invalidates clearance. Any failed run retains its sentinel and does not
authorize a second run.
