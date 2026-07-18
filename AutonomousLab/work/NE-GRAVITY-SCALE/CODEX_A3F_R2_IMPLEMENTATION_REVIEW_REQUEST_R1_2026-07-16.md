# Codex request R1: A3f-R2 greedy atlas implementation audit

## Decision requested

Audit the frozen Stage A3f-R2 implementation before any held-out sprinkling is
executed. Return `APPROVE`, `REVISE`, or `KILL`, with exact file/line evidence.
This review concerns only finite order-atlas packing. It cannot open G2, an
operator, a tetrad, curvature, or Einstein dynamics.

This R1 request supersedes the hash-pinned original request only because two
exact controls were strengthened after dispatch. The original artifact remains
byte-preserved for mailbox provenance.

## Frozen specification

- `AgentTasks/null-edge-causal-atlas-packing-stage-a3f-r2-plan-2026-07-16.md`
- Work item `GRAV-ATLAS-PACKING-001`
- Fresh seed `2026071608` has not been executed.

## Implementation under review

- `Scripts/experiments/causal_atlas_packing.py`
- `Scripts/experiments/test_causal_atlas_packing.py`
- inherited geometry/API:
  `Scripts/experiments/causal_atlas_coverage.py`
- exact core calibration:
  `Scripts/experiments/causal_buffered_core_feasibility.py`

## Required checks

1. Confirm the complete candidate family is never truncated and every carrier
   and protected core is materialized before the first greedy choice. Confirm
   the `2000`-candidate ceiling fails explicitly.
2. Confirm the primary score is new independent-bulk coverage, the secondary
   score is new all-event coverage only within the primary maximum, and the
   final complete tie set is sampled uniformly without a label tie breaker.
3. Confirm the same-realization uniform control has an independent child stream
   and uses the same complete candidate/core family.
4. Confirm all seven RNG roles are distinct and replayable and that no A3f-R1
   seed is reused.
5. Confirm complete-union feasibility, coverage, repeated coverage, connected
   nonempty core-overlap, positive later marginal, `4/5`, median improvement,
   adjacent-rung, and refinement-drift gates match the preregistration exactly.
6. Confirm zero denominators cannot pass and the resource failure cannot be
   misread as low coverage.
7. Inspect the exhaustive three-event set-family test, exact full-trace
   relabeling-in-law enumerator, coverage metrics, and overlap controls for
   actual logical coverage, not merely execution.
8. Confirm the induced-count tripwire covers the union of greedy and uniform
   selected carriers, while complete-core containment checks the full family.
9. Confirm coordinate data is discarded before selection and no support-row,
   eigensolver, metric, or operator phase is imported.
10. Report any statement/protocol drift that would require revising the frozen
    plan before the held-out run. Do not inspect or generate held-out output.

## Codex verification already run

```text
cd Scripts/experiments
python -m unittest test_causal_buffered_core_feasibility.py test_causal_atlas_coverage.py test_causal_atlas_packing.py -v
# 35 tests passed

ruff check causal_buffered_core_feasibility.py test_causal_buffered_core_feasibility.py causal_atlas_coverage.py test_causal_atlas_coverage.py causal_atlas_packing.py test_causal_atlas_packing.py
# clean
```

The separate focused Lean maximum-coverage target remains with Aristotle. The
held-out run stays closed until that returned proof is checked without public
statement drift and this implementation review is resolved.
