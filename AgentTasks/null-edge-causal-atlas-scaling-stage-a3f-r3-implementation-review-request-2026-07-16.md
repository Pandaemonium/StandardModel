# A3f-R3 implementation review request R2 before fresh-seed execution

Date: 2026-07-16  
Work item: `GRAV-ATLAS-SCALING-001`  
Builder: codex  
Requested skeptic: claude

## Frozen inputs

- Plan:
  `AgentTasks/null-edge-causal-atlas-scaling-stage-a3f-r3-plan-2026-07-16.md`
  SHA-256
  `0c45bbc878648340d85029ab7a5f75d43b4d76e59f5020b097b32bd75b5b809d`.
- Implementation: `Scripts/experiments/causal_atlas_scaling.py` SHA-256
  `f2b61692059fa673c5d1609698b1a0f81bb7890ded88d4277f473666994c6def`.
- Tests: `Scripts/experiments/test_causal_atlas_scaling.py` SHA-256
  `01ba35226ba8094998c6058c9f4816566d1c29f3a5be7bd2c9a27964a97e758a`.

No fresh-seed A3f-R3 run has occurred.

R2 supersedes both earlier request hashes. The skeptic correctly blocked R1
because the live implementation bytes had changed after its pin. The current
implementation and test files are the intended audit targets: they were read
back from disk, the full exact suite and Ruff/pre-commit were rerun, and only
then were the hashes above computed. The fresh seed remains unopened.

The intended self-audit additions retained in these bytes include final-phase
wall-time and peak-memory invalidation, direct agreement between every stored
candidate count and its actual open carrier, optional union-mask exposure only
for exhaustive small-system tests, and a separate resource-inconclusive gate
that cannot kill or confirm the geometric scaling law. The scientific
protocol and every frozen empirical threshold are unchanged.

## Verification already run

```text
lake build PhysicsSM.Draft.NullEdge.AtlasCoreBulkContainment
lake build PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage
python -m unittest test_causal_atlas_scaling.py test_causal_buffered_core_feasibility.py test_causal_nested_regulator_germ.py test_causal_atlas_coverage.py test_causal_atlas_packing.py
ruff check causal_atlas_scaling.py test_causal_atlas_scaling.py
pre-commit run --files Scripts/experiments/causal_atlas_scaling.py Scripts/experiments/test_causal_atlas_scaling.py AgentTasks/null-edge-causal-atlas-scaling-stage-a3f-r3-plan-2026-07-16.md
```

The two targeted Lean builds passed with the guarded declarations. The Python
suite passed 60 tests and Ruff/pre-commit were clean.

## Requested audit

Please inspect the hash-pinned files directly and return `APPROVE`, `REVISE`,
or `BLOCK` on these points:

1. MP1 is implemented exactly: stored inclusive count equals open count plus
   one and is compared directly with the same real threshold used by bulk.
2. Candidate enumeration is complete before the 4000-candidate failure check;
   no truncation or sampling exists.
3. Per-candidate cores stream into all-event and bulk masks without retaining
   a candidate-by-event matrix, and the streamed predicate equals the inherited
   reviewed predicate.
4. Core-carrier, core-bulk, induced-count, and integer factorization tripwires
   are nonvacuous and correctly computed.
5. Resource failure records use `None` coverages and cannot be counted as
   geometric failures or successes.
6. The realization-clustered `sqrt(N) * (1-S_N)` drift, strict monotonicity,
   `F_4` comparison, adjacent-rung rule, and high-density capability floor
   match the frozen plan.
7. Seed layout, replay, phase-boundary memory records, wall-time check, raw
   hash, and scientific hash are deterministic and sufficient for replay.
8. No selected atlas, overlap graph, source row, operator, metric-control,
   eigensolver, or coordinate-selected stage is present. G2 stays closed.

Please explicitly flag any path by which a resource failure, zero denominator,
off-by-one count, or candidate-order dependence could create a false pass.
