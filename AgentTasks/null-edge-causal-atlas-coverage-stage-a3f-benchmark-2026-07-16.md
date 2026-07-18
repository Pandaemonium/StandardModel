# Stage A3f-R1 benchmark: uniform outer-atlas coverage

## Disposition

**Status:** killed under the frozen empirical gate  
**Scope of kill:** the uniformly sampled `K=16` outer-atlas mechanism on the
displayed two-density schedule  
**Retained:** the exact flat 4D protected-core law, volume-radius correction,
balanced shrinking exponents, abundant complete candidate sets, calibrated
individual core sizes, and the observed core-correlation diagnostic  
**Not established:** operator locality, G2, a tetrad, curvature, stress-energy,
or Einstein dynamics

The analytic correction and R1 design received an independent pre-run
`APPROVE` in
`AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R1_NORMALIZATION_2026-07-16.md`.
The benchmark then ran once at the frozen seed `2026071607` without retuning.

### Concurrent stale-output record

A concurrent stale lane completed the superseded fixed-count A3f protocol
after the R1 correction was registered. Its output is preserved only as an
invalidated process artifact at
`AgentTasks/causal-atlas-coverage-stage-a3f-invalidated-original-2026-07-16.json`
(raw SHA-256
`FB80DEFEDBE1E829A9BB22446CBDFE687F049F370D6341F8FCAA57EF212ABF97`).
It is excluded from every R1 table and claim and was not used to alter R1.

The current admissible R1 file has raw SHA-256
`849084851E0EAE2A7F79F8D1857DA47DC45A89796AF06A4CB4D79C5EE6DD8D82`.
For replay comparison, parse the JSON, recursively remove every object field
named `runtime_seconds`, serialize the resulting object as UTF-8 with Python
`json.dumps(payload, sort_keys=True, separators=(",", ":"))` and no trailing
newline, then hash those bytes. This canonical scientific-content SHA-256 is
`40F03F73C6579FADC00D72828EAA6D7CC241CDDB4721B4966BA263B641342D47`.
Claude's replay is dictionary-identical under exactly this runtime removal.

## Verification before execution

```text
python -m unittest test_causal_buffered_core_feasibility.py \
  test_causal_atlas_coverage.py test_causal_nested_regulator_germ.py -v
```

All 31 tests passed. The suite checks direct quadrature, count/proper-time
conversion, exact target inversion, balanced exponents, dense/sparse counts,
candidate/core/bulk relabeling, uniform subset sampling, independent
denominators, seed replay, ambient/induced count tripwires, zero-denominator
nonvacuity, and the coordinate/operator firewall.

```text
ruff check causal_buffered_core_feasibility.py \
  test_causal_buffered_core_feasibility.py \
  causal_atlas_coverage.py test_causal_atlas_coverage.py
```

Ruff passed. AFPL state validation passed.

## Frozen result

The machine-readable artifact is
`AgentTasks/causal-atlas-coverage-stage-a3f-2026-07-16.json`. The ten
realizations completed in about 42 seconds total.

| `N` | buffer radius | median candidates | predicted independent all-event coverage | measured median all-event coverage | median bulk coverage | median repeated coverage | realizations passing |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4800 | 0.80 | 79 | 0.984 | 0.496 | 0.746 | 0.877 | 2/5 |
| 4800 | 1.00 | 79 | 0.926 | 0.365 | 0.679 | 0.879 | 0/5 |
| 4800 | 1.25 | 79 | 0.678 | 0.193 | 0.574 | 0.871 | 0/5 |
| 9600 | 0.80 | 504 | 0.973 | 0.503 | 0.714 | 0.844 | 3/5 |
| 9600 | 1.00 | 504 | 0.909 | 0.400 | 0.660 | 0.845 | 0/5 |
| 9600 | 1.25 | 504 | 0.688 | 0.230 | 0.548 | 0.839 | 0/5 |

The predicted column is diagnostic only and was never a gate. No rung passed
either density's required four of five realizations, so no adjacent rung pair
passed both densities. `stage_passes_coverage_gate=false`,
`operator_gate_open=false`, and `g2_closed=true`.

## Why it failed

Candidate availability was not the problem. Every realization exceeded the
required 16 candidates; the complete candidate count ranged from 56 to 138 at
`N=4800` and from 416 to 872 at `N=9600`.

Individual core sizes also followed the flat calibration closely. For example,
the central rung predicted about 720 and 1338 events at the two densities;
realization-level median sampled-core sizes were of that order.

The failure was correlated placement. In nearly every realization all 120
distinct pairs among the 16 sampled cores had nonempty intersection. Typical
median core Jaccard overlaps were about 0.3 to 0.5. Consequently, adding cores
mostly increased multiplicity inside an already covered central region rather
than expanding the union. This explains the simultaneous combination of:

- all-event coverage far below the independent-placement diagnostic;
- repeated-given-covered rates around 0.84 to 0.88; and
- stable but insufficient union coverage across refinement.

The three median cross-density coverage drifts were all below `0.04`, and every
reported drift was below the frozen `0.10` limit. This is a stable failure of
uniform sampling, not a noisy sign flip between densities. **`M [comp]`**.

## Scientific boundary

This result kills neither compact outer regulators nor outer-first atlases in
general. It kills the hypothesis that uniformly sampling 16 count-band outer
intervals produces approximately independent protected-core placement. The
flat formula correctly calibrates each core's expected size but does not model
the joint distribution of cores conditioned on large interval count inside one
global diamond.

The result does not authorize an operator test. Protected evaluation cores do
not settle row-source boundary dependence, and the fixed timelike shell still
has an unbounded rapidity direction.

## Successor constraint

A successor may test an order-only diversified atlas, but it must be
preregistered separately. The natural candidate is a coverage or packing rule
on the complete equivariant candidate set:

1. build every candidate and protected core before selecting the atlas;
2. optimize marginal coverage of the independent order bulk, not coordinate
   separation and not preselected marks;
3. make tie handling equivariant in probability and archive every tie orbit;
4. compare against the frozen uniform baseline on held-out seeds;
5. keep source-row support, polynomial controls, and metric rank closed until
   the diversified coverage gate passes.

The standard greedy maximum-coverage bound suggests a mathematically
controlled selector, but the approximation theorem and finite resource rule
must be stated before another run.
