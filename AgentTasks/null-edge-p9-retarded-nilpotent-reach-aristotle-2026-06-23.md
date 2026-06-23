# Aristotle focused job: P9 retarded nilpotent reach

```yaml
job_name: null-edge-p9-retarded-nilpotent-reach-20260623
status: integrated
project_id: dd4fb31d-a4d4-4d1e-a565-510c57aafe3a
task_id: a24c6395-edc0-44dc-bd1e-71a8a9b95213
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-retarded-nilpotent-reach-20260623-project
output_dir: AgentTasks/aristotle-output/dd4fb31d-a4d4-4d1e-a565-510c57aafe3a
target_module: PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach
target_file: PhysicsSM/Draft/NullEdgeP9RetardedNilpotentReach.lean
expected_check: lake env lean PhysicsSM/Draft/NullEdgeP9RetardedNilpotentReach.lean
```

## Task

Fill the four proof holes in `NullEdgeP9RetardedNilpotentReach/Core.lean`
without changing definitions or theorem statements.

This is a finite retarded-support scaffold for P9. Causal-set response
operators can be retarded and nonlocal; on a finite acyclic diamond, however, a
support relation that strictly decreases a rank should have a finite propagation
horizon. The target is the corresponding finite theorem: beyond the rank
height, exact reach is empty and the iterated response kernel vanishes.

## Targets

```lean
applyKernel_vanishes_off_reach
iterateApply_supported_in_exact_reach
no_reach_beyond_rank
iterateApply_eq_zero_beyond_rank
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9RetardedNilpotentReach/Core.lean
```

## Proof sketch

The one-step support theorem expands `applyKernel` and uses
`Finset.sum_eq_zero`: each summand vanishes either from source support or from
kernel support. The iterated support theorem is induction on `m`.

For `no_reach_beyond_rank`, induct on `m`. In the successor case, any exact
reach path starts with `step i j`; rank decrease gives `rank j < rank i`, while
`rank i < m + 1` gives `rank j < m`, so the induction hypothesis rules out the
tail. `iterateApply_eq_zero_beyond_rank` combines the exact-reach support
theorem with `no_reach_beyond_rank` for every index.

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
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
rg -n "^\s*sorry\b|^\s*admit\b|\baxiom\b|\bopaque\b|\bunsafe\b|\bnative_decide\b" AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-retarded-nilpotent-reach-20260623/NullEdgeP9RetardedNilpotentReach/Core.lean
```

The Lean preflight found exactly the four intended proof-hole warnings and no
other errors. Non-ASCII scan was clean. The focused package helper reported four
proof-hole lines, zero proof-escape tokens, and zero unsafe tokens.

Submitted on 2026-06-23 as Aristotle project
`dd4fb31d-a4d4-4d1e-a565-510c57aafe3a`, task
`a24c6395-edc0-44dc-bd1e-71a8a9b95213`.

## Integration note

Aristotle completed on 2026-06-23 and reported all four targets solved with no
statement or definition changes:

- `applyKernel_vanishes_off_reach`;
- `iterateApply_supported_in_exact_reach`;
- `no_reach_beyond_rank`;
- `iterateApply_eq_zero_beyond_rank`.

The extracted file was clean for proof holes and escape hatches, but used
compact tactic syntax and lacked a final newline. The integrated module
`PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach` rewrites the proof bodies in
plain ASCII Lean style while preserving the theorem statements.

Verification run:

```text
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-p9-retarded-nilpotent-reach-aristotle-2026-06-23.md dd4fb31d-a4d4-4d1e-a565-510c57aafe3a
lake env lean PhysicsSM/Draft/NullEdgeP9RetardedNilpotentReach.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9RetardedNilpotentReach.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9RetardedNilpotentReach.lean
lake build PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach
lake env lean PhysicsSMDraft.lean
```

The targeted Lean check, targeted module build, placeholder scan, non-ASCII
scan, and rerun draft-root import check passed. The first draft-root check raced
the targeted build before the `.olean` existed and was rerun successfully.

Scientific role: this is a finite retarded-horizon theorem. If the response
support relation strictly decreases a rank on a finite diamond, then exact
reach is empty beyond the rank height and the iterated kernel vanishes.
