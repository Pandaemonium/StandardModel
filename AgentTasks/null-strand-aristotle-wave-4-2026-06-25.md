# NullStrand Aristotle wave 4

Date: 2026-06-25

Purpose: broad, ambitious follow-up wave after integrating the useful wave-3
results. The package copies omit `.lake`, so every job explicitly tells
Aristotle not to run full `lake build`. If targeted `lake env lean <file>` works,
use it; otherwise return patchable Lean snippets, proof plans, and exact
blockers.

Shared context:

- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `AgentTasks/null-strand-aristotle-wave-3-2026-06-25.md`
- live `PhysicsSM/NullStrand/` tree

Jobs:

1. `nullstrand-wave4-fock-bell-equivariance-20260625`
2. `nullstrand-wave4-least-action-ergodic-20260625`
3. `nullstrand-wave4-sync-holonomy-20260625`
4. `nullstrand-wave4-graph-superdirac-20260625`
5. `nullstrand-wave4-g1-semantic-audit-20260625`
6. `nullstrand-wave4-audit-automation-20260625`

Submission status: integrated.

| job | project_id | task_id | status |
| --- | --- | --- | --- |
| `nullstrand-wave4-fock-bell-equivariance-20260625` | `35d0411c-524b-4ccb-89e6-ee16233f24f2` | `2bcf3082-b08e-4bec-a289-3e28cfb2979c` | integrated |
| `nullstrand-wave4-least-action-ergodic-20260625` | `b02280e4-ec8c-48e8-ab29-4513e3490c22` | `b3190408-07b7-4796-b7b5-5c710c072097` | integrated |
| `nullstrand-wave4-sync-holonomy-20260625` | `c7746d3c-5f9d-4cc8-8d4f-4dff88f4cb3a` | `409e1c31-d96c-42b7-8dc3-02607225d3ec` | integrated |
| `nullstrand-wave4-graph-superdirac-20260625` | `07fef5d8-a77b-4934-b8a6-e1091278a764` | `85a7618f-2a9c-44c5-8857-5f7c3594a6ea` | integrated |
| `nullstrand-wave4-g1-semantic-audit-20260625` | `300e86eb-533e-4406-99be-c01c1864fe8c` | `f1592029-e3f6-4592-a20a-b1e68f504b1a` | integrated |
| `nullstrand-wave4-audit-automation-20260625` | `e676e62f-ab89-466d-9bf4-b693c39ed34a` | `e58437c4-82df-4d15-bbc4-f0571b7c4423` | partially integrated |

Integration note: the first five jobs returned patchable Lean that was copied
into the live tree and target-checked. The audit-automation archive returned the
Lean audit modules, but not the script/doc artifacts named in its completion
summary; those missing artifacts are being resent as a wave-5 recovery target.
