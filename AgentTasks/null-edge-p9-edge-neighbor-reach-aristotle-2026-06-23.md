# Aristotle focused job: P9 edge-neighbor reach

```yaml
job_name: null-edge-p9-edge-neighbor-reach-20260623
status: integrated
project_id: af7b61f3-c743-428a-b989-f30239f3fc03
task_id: d88f469d-1a0a-4efb-bed7-b8a5601be0ee
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-edge-neighbor-reach-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-edge-neighbor-reach-20260623-project
output_dir: AgentTasks/aristotle-output/af7b61f3-c743-428a-b989-f30239f3fc03
target_module: PhysicsSM.Draft.NullEdgeP9EdgeNeighborReach
target_file: PhysicsSM/Draft/NullEdgeP9EdgeNeighborReach.lean
expected_check: lake env lean PhysicsSM/Draft/NullEdgeP9EdgeNeighborReach.lean
```

## Task

Fill the five proof holes in `NullEdgeP9EdgeNeighborReach/Core.lean` without
changing definitions or theorem statements.

This is a finite locality scaffold for the P9 source-visibility route. The
program should not assume fundamental bounded point valency. Instead, it needs
an effective link-local relation `edgeNeighborN`: an edge is locally visible
when the endpoint diamond contains at most `N` intermediate events. This file
proves the finite support algebra needed to use that relation in response
kernels.

## Targets

```lean
edgeNeighborN_subrelation
edgeNeighborN_induced_of_original
kernelSupported_edgeNeighborN_to_rel
iterateApply_supported_in_exact_reach
responseAtStep_zero_of_target_outside_exact_reach
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9EdgeNeighborReach/Core.lean
```

## Proof sketch

`edgeNeighborN_subrelation` is projection from the conjunction. The induced
subdiamond theorem should use `Finset.card_le_card` for the inclusion of
induced endpoint-diamond intermediates into original endpoint-diamond
intermediates. `kernelSupported_edgeNeighborN_to_rel` uses the fact that
`edgeNeighborN rel N i j` implies `rel i j`.

The iterated reach theorem is induction on the step count `m`. The successor
case expands `iterateApply` and `applyKernel`; each summand vanishes either
because the previous vector is outside `ReachExactly step source m` or because
the kernel entry is outside `step`. The response theorem then expands
`responseAtStep`/`dot` and uses the support theorem plus the target support
hypothesis.

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission note

Staged on 2026-06-23.

Local preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-edge-neighbor-reach-20260623/NullEdgeP9EdgeNeighborReach/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-edge-neighbor-reach-20260623/NullEdgeP9EdgeNeighborReach/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-edge-neighbor-reach-20260623/NullEdgeP9EdgeNeighborReach/Core.lean
```

The Lean preflight found exactly the five intended proof-hole warnings and no
other errors. Non-ASCII scan was clean.

Submitted on 2026-06-23 as Aristotle project
`af7b61f3-c743-428a-b989-f30239f3fc03`, task
`d88f469d-1a0a-4efb-bed7-b8a5601be0ee`.

## Integration note

Aristotle completed on 2026-06-23 and reported all five targets solved with no
statement or definition changes:

- `edgeNeighborN_subrelation`;
- `edgeNeighborN_induced_of_original`;
- `kernelSupported_edgeNeighborN_to_rel`;
- `iterateApply_supported_in_exact_reach`;
- `responseAtStep_zero_of_target_outside_exact_reach`.

The integrated module `PhysicsSM.Draft.NullEdgeP9EdgeNeighborReach` rewrites
the proof bodies in plain ASCII Lean style while preserving the theorem
statements.

Verification run:

```text
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-p9-edge-neighbor-reach-aristotle-2026-06-23.md af7b61f3-c743-428a-b989-f30239f3fc03
lake env lean PhysicsSM/Draft/NullEdgeP9EdgeNeighborReach.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9EdgeNeighborReach.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9EdgeNeighborReach.lean
lake build PhysicsSM.Draft.NullEdgeP9EdgeNeighborReach
lake env lean PhysicsSMDraft.lean
```

The targeted Lean check, targeted module build, placeholder scan, non-ASCII
scan, and rerun draft-root import check passed. The first draft-root check raced
the targeted build before the `.olean` existed and was rerun successfully.

Scientific role: this proves the finite effective-locality scaffold for
`edgeNeighbor_N`: the relation is a subrelation of the causal relation, is
stable under induced subdiamonds, supports causal-support conversion for
kernels, and bounds iterated response by exact finite step reach.
