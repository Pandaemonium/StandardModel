# Codex request: A3f-R2 held-out empirical red-team

## Decision requested

Independently inspect the existing held-out artifact and return `APPROVE`,
`REVISE`, or `KILL-INTERPRETATION`, with exact evidence. Do **not** rerun
`causal_atlas_packing.py`: seed `2026071608` has been spent exactly once.

## Frozen evidence

- Plan:
  `AgentTasks/null-edge-causal-atlas-packing-stage-a3f-r2-plan-2026-07-16.md`
- Machine artifact:
  `AgentTasks/causal-atlas-packing-stage-a3f-r2-2026-07-16.json`
- Proposed benchmark disposition:
  `AgentTasks/null-edge-causal-atlas-packing-stage-a3f-r2-benchmark-2026-07-16.md`
- Implementation:
  `Scripts/experiments/causal_atlas_packing.py`
- Guarded theorem:
  `PhysicsSM/Draft/NullEdge/GreedyAtlasCoverage.lean`

Pinned artifact facts:

```text
size = 911017 bytes
raw SHA-256 = 221ea58dedcc964cbbe0275bc8a082c03e653f0140a80367354727167ac5a4a7
scientific-content SHA-256 = c8476e3e99b3b48cbce6f135d5289f27e6f7085e6a7670d54671f86c2190612b
```

Scientific canonicalization recursively removes object fields named
`runtime_seconds`, then uses compact sorted JSON, UTF-8, and no trailing
newline.

## Required audit

1. Recompute both hashes and every density/rung median from the existing JSON.
2. Confirm there are ten realizations and thirty rung records using the frozen
   seed, schedule, candidate band, rungs, `K=16`, and distinct archived streams.
3. Confirm all resource, containment, induced-count, greedy replay, and uniform
   replay tripwires pass; confirm every greedy overlap graph is connected and
   every greedy atlas has a positive post-first marginal.
4. Confirm the complete-family feasibility result: no `N=4800` rung passes;
   at `N=9600`, only `beta=0.8` passes the per-realization absolute gate in all
   five realizations.
5. Confirm that `N=9600,beta=0.8` still fails its density gate because median
   paired all-event improvement is about `0.0777 < 0.10`.
6. Confirm no rung passes both densities, no adjacent pair passes, the final
   packing gate is false, and operator/G2 gates remain hard-closed.
7. Audit the statement that greedy coverage is about `95.6%-99.7%` of the
   complete-family union across the six median cells. Distinguish ratio of
   medians from median of realization-level ratios if that distinction matters.
8. Check the scoped kill language: the frozen two-density `K=16` mechanism is
   killed, while the finite theorem, selector, and candidate-family convergence
   question are retained. Reject any claim of asymptotic failure or G2 progress.
9. Review the proposed successor. It must address complete-family finite-size
   scaling before source rows or operators and may not lower gates, reuse this
   seed as held-out evidence, or add coordinate separation post hoc.
10. Replay the 45 exact tests and Ruff if useful, but do not execute the frozen
    benchmark function.

## Codex independent checks

- Raw and scientific hashes recomputed exactly.
- `10` realizations and `30` rungs found.
- All five runtime/replay tripwire classes: `30/30`.
- Connected overlap, positive later marginal, positive paired improvement:
  each `30/30`.
- Complete candidate range: `46..811`; resource ceiling never approached.
- Current four-file Python suite: `45` tests passed; Ruff clean.

## Claim boundary

This review may validate only a finite packed-atlas disposition. It cannot open
the source-row, operator-locality, metric, G2, tetrad, curvature, stress-energy,
or Einstein-dynamics gates.
