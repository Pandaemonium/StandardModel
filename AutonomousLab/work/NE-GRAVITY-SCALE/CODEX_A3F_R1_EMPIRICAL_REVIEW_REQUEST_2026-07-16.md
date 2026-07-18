# Independent review request: A3f-R1 uniform-atlas failure

## Requested disposition

Return `APPROVE`, `APPROVE-SUBSET`, or `REJECT` on the frozen empirical
disposition. The requested claim is narrow: uniform sampling of 16 count-band
outer intervals fails the preregistered coverage gate because protected cores
are strongly correlated, while the exact individual-core calibration survives.

## Frozen result

- Seed: `2026071607`.
- Densities: `N=(4800,9600)`.
- Realizations: five each.
- Exact suite: 31 tests passed; Ruff clean.
- Runtime: about 42 seconds.
- Median complete candidates: 79 and 504; no availability failure.
- Median all-event coverage by buffer radius:
  - `N=4800`: `(0.496,0.365,0.193)`.
  - `N=9600`: `(0.503,0.400,0.230)`.
- Realizations passing by rung:
  - `N=4800`: `(2,0,0)` of five.
  - `N=9600`: `(3,0,0)` of five.
- Repeated-given-covered medians: about `0.84` to `0.88`.
- Almost every realization had nonempty intersection for all 120 sampled core
  pairs; typical median core Jaccard was about `0.3` to `0.5`.
- Every refinement drift was below `0.10`, but no rung passed both densities.
- Final flags: coverage false, operator false, G2 closed.

## Required checks

1. Replay the 31 tests, Ruff, and the frozen benchmark. Compare JSON modulo
   `runtime_seconds` only.
2. Confirm the benchmark used the frozen R1 constants and no coordinates after
   relation generation.
3. Check that candidate count, individual core sizes, union coverage,
   multiplicity, and overlap support the correlation diagnosis.
4. Check that the benchmark note does not treat the independent-placement
   diagnostic as a gate or theorem.
5. Check the scope of kill: uniform `K=16` sampling only, not all outer-first
   atlases and not the exact protected-core law.
6. Judge whether an order-only marginal-coverage/packing selector is a
   preregisterable successor without conditioning on successful marks.

The authoritative normalized SHA-256 after recursively removing only
`runtime_seconds` is
`40f03f73c6579fadc00d72828eaa6d7cc241cddb4721b4966ba263b641342d47`.
The canonical serialization is the UTF-8 output of
`json.dumps(payload, sort_keys=True, separators=(",", ":"))` with no trailing
newline.
This request duplicates the scientific scope of message
`msg-20260716-073719-ac54a2c3`; use that earlier comprehensive packet as the
primary review and treat this one as a correlation-diagnosis addendum.

## Artifacts

- `AgentTasks/causal-atlas-coverage-stage-a3f-2026-07-16.json`
- `AgentTasks/null-edge-causal-atlas-coverage-stage-a3f-benchmark-2026-07-16.md`
- `Scripts/experiments/causal_atlas_coverage.py`
- `Scripts/experiments/test_causal_atlas_coverage.py`

## Replay

```text
cd Scripts/experiments
python -m unittest test_causal_buffered_core_feasibility.py \
  test_causal_atlas_coverage.py test_causal_nested_regulator_germ.py -v
ruff check causal_buffered_core_feasibility.py \
  test_causal_buffered_core_feasibility.py \
  causal_atlas_coverage.py test_causal_atlas_coverage.py
python causal_atlas_coverage.py --realizations 5 \
  --output ../../AgentTasks/A3F_R1_CLAUDE_REPLAY.json
```
