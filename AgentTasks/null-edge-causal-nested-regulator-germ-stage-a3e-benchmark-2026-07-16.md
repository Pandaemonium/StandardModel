# Stage A3e benchmark: buffered outer regulator and inner causal germ

## Verdict

**KILL the frozen `B=24/32` count-balanced nested-regulator mechanism.**

The exact order-side implementation passes, but the preregistered Phase 1
availability gate fails decisively. Across five fixed-density `N=9600`
realizations and 40 independently sampled common-interior marks, only one mark
has any `B=32` outer bracket, no mark has a genuinely nested `B=24` bracket,
and therefore no nested pair exists. Phase 2 was correctly not run.

This is an external finite support-control failure. It is not a no-go theorem
for all local Alexandrov regulators and does not test a tetrad, curvature, or
Einstein dynamics.

## Frozen execution

The run used the unchanged preregistration:

| Quantity | Frozen value |
|---|---:|
| Seed | `2026071606` |
| Realizations | 5 |
| Events per realization | 9600 |
| Marks per realization | 8 |
| Tight buffer ratio | 24 |
| Refinement buffer ratio | 32 |
| Analytic minimum ratio | 20.3537595771 |
| Rapidity-excess cap | 1.5 |
| Maximum tie orbit | 64 |
| Primary inference unit | realization clustered through marks |

The selector receives only the causal relation and inclusive interval counts.
Sprinkling and mark sampling use distinct spawned seed streams. Coordinates
were not used because the Phase 1 support gate failed.

## Exact controls

All 22 focused tests pass. They cover:

- dense/sparse inclusive counts on chain and branching orders;
- convex outer-carrier induced counts;
- full-interval count preservation inside a further inner germ;
- complete minimum-score tie orbits at both rungs;
- exact relabeling of the two-rung selection and nested-pair relation;
- coordinate-free selector signatures; and
- independent sprinkling and mark seed streams.

The first selected carrier also passes the runtime induced-count tripwire.
The four realizations with no selected carrier report no tripwire value rather
than converting absence into an exact pass.

## Frozen result

| Realization | Common marks | Sampled marks | Marks with `B=32` | Marks with nested `B=24` | Nested pairs | Phase 1 |
|---:|---:|---:|---:|---:|---:|---|
| 1 | 5763 | 8 | 1 | 0 | 0 | fail |
| 2 | 5744 | 8 | 0 | 0 | 0 | fail |
| 3 | 5919 | 8 | 0 | 0 | 0 | fail |
| 4 | 5620 | 8 | 0 | 0 | 0 | fail |
| 5 | 5888 | 8 | 0 | 0 | 0 | fail |

The one retained `B=32` bracket is rank-capable, but its three raw-to-retained
source closure rates are approximately `0.931`, `0.723`, and `0.343`. Its
minimum closure rate is therefore also far below the frozen `0.80` gate.

Machine-readable headline:

```text
passes_all_gates = false
phase1.realizations_passing = 0
phase1.minimum_realizations_passing = 4
phase1.passes_phase1 = false
phase2 = null
coordinates_used_for_postselection_control = false
```

## Reproduction

```text
cd Scripts/experiments
python -m unittest test_causal_nested_regulator_germ.py \
  test_causal_compact_bracket_carrier.py \
  test_causal_adjacent_scale_availability.py
# 22 tests: OK

ruff check causal_nested_regulator_germ.py \
  test_causal_nested_regulator_germ.py
# All checks passed

python causal_nested_regulator_germ.py --realizations 5 \
  --output ../../tmp/a3e-frozen-replay.json
# Archived and replayed JSON are identical modulo runtime_seconds.
```

## Scientific split

The analytic clearance bound was a necessary arithmetic condition only. It
correctly prevented a carrier-size impossibility, but it did not make two
fixed-count endpoint bands jointly probable around a random order-selected
mark. The failure occurs before any spectral or coordinate calculation and is
therefore a clean availability result.

Retain:

- the order-only rapidity-excess diagnostic from A3d;
- the mathematical distinction between an outer regulator and inner germ;
- the explicit count-buffer calculus formalized in
  `AlexandrovNestedGerm.lean`; and
- realization-clustered, nonvacuity-preconditioned gates.

Kill:

- fixed `B=24/32` symmetric endpoint bands as the outer-regulator selector;
- exact-minimum nested-orbit selection for this fixed-count mechanism; and
- any rescue by larger global diamonds, capable-mark selection, wider bands,
  altered buffers, or lower gates.

The next admissible numerical architecture must first construct an order-only
outer atlas and then separate three roles inside each carrier: a probe region,
a protected evaluation core, and the retarded source support of each core row.
A source may contribute to a row without itself qualifying as an evaluation
center. The preregistration must analytically predict typical-event protected-
core coverage before choosing the finite diamond and gate; at the A3e scales,
the two-sided outer depth alone restricts eligible marks to roughly `7.7%` of
the volume, already below the old `80%` gate. This architecture is distinct
from demanding two preassigned symmetric endpoint-count bands around every
sampled mark. It requires a new preregistration and independent review before
execution.

## Claim grade

- Exact implementation properties: `M [orig]`.
- Frozen five-realization result: `M [orig]`, external numerical oracle.
- Continuum, tetrad, curvature, stress-energy, and Einstein claims: not
  reached; gates remain closed.
