# NullStrand Aristotle wave 3

Date: 2026-06-25

Purpose: broad, ambitious follow-up wave after the full-tree Aristotle roadmap
hardening review. These jobs intentionally span larger clusters than the prior
standalone proof wave, but each has a clear ownership boundary and should return
patchable Lean, a concrete scaffold, or a precise blocker.

Shared context:

- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `AgentTasks/null-strand-roadmap-hardening-report-aristotle-2026-06-25.md`
- live `PhysicsSM/NullStrand/` tree

Jobs:

1. `nullstrand-g1-iid-master-20260625`
2. `nullstrand-g1-checkerboard-master-20260625`
3. `nullstrand-g0-firewall-dedup-audit-20260625`
4. `nullstrand-fock-bell-equivariance-hardening-20260625`
5. `nullstrand-least-action-ergodic-dynamics-20260625`
6. `nullstrand-sync-holonomy-pathindependence-20260625`
7. `nullstrand-graph-superdirac-spike-20260625`

Submission status: integrated/triaged.

| job | project_id | task_id | status |
| --- | --- | --- | --- |
| `nullstrand-g1-iid-master-20260625` | `7c52ed82-5947-4327-93ae-edb8f1372fc0` | `2754e5a2-ae71-4fc8-b4be-2a1c1c936f85` | integrated |
| `nullstrand-g1-checkerboard-master-20260625` | `5d2f7646-f24b-4646-a375-19644de5aaa2` | `feeb54c5-438d-4a56-9600-0f5fc66e9fbf` | integrated |
| `nullstrand-g0-firewall-dedup-audit-20260625` | `f105c00d-a222-4e7a-ab4e-00f242c4d624` | `067b5d23-5584-433f-abcd-a04bce25ac05` | integrated |
| `nullstrand-fock-bell-equivariance-hardening-20260625` | `f91e1900-6076-4ffb-a44b-74c667db404f` | `cf735321-2d51-4785-8aec-a652194b70c1` | failed after nudge; no live integration |
| `nullstrand-least-action-ergodic-dynamics-20260625` | `c96fdc80-e071-4d59-99d2-b9194699efd5` | `5945de75-f1d1-42d7-b8b3-8af30b7c6554` | failed after nudge; no live integration |
| `nullstrand-sync-holonomy-pathindependence-20260625` | `5df79eef-ec6c-45f3-85d3-2890e2d22d7f` | `e04a751a-33e0-4468-a743-9d7bc447f586` | failed after nudge; no live integration |
| `nullstrand-graph-superdirac-spike-20260625` | `12232975-6826-4bf9-a977-9cd142159034` | `5e133d23-a24a-4ce7-822f-470bbbe5ecf1` | failed after nudge; no live integration |

## 2026-06-25 build-loop nudge

The following still-running projects were nudged with `aristotle continue
--mode instruct` after they appeared to be spending budget on full-project build
or dependency setup:

- `7c52ed82-5947-4327-93ae-edb8f1372fc0`
- `f91e1900-6076-4ffb-a44b-74c667db404f`
- `c96fdc80-e071-4d59-99d2-b9194699efd5`
- `5df79eef-ec6c-45f3-85d3-2890e2d22d7f`
- `12232975-6826-4bf9-a977-9cd142159034`

Instruction sent: skip full `lake build` and dependency rebuilds; use only
cheap targeted checks if useful; return patchable Lean snippets, theorem
statements, helper lemmas, precise blockers, and a concise completion report.

## 2026-06-25 integration result

Integrated:

- `PhysicsSM/NullStrand/Master/FiniteModel.lean` from project
  `7c52ed82-5947-4327-93ae-edb8f1372fc0`, adding
  `FiniteIIDNullStrandModel`, `finiteIIDNullStrand_master`,
  `octaWitnessModel`, and `finiteIIDNullStrandModel_nonempty`.
- `PhysicsSM/NullStrand/Master/Checkerboard.lean` from project
  `5d2f7646-f24b-4646-a375-19644de5aaa2`, adding
  `checkerboardBohmBell_master`.
- `PhysicsSM/NullStrand/Audit.lean`,
  `PhysicsSM/NullStrand/Audit/Inventory.lean`,
  `PhysicsSM/NullStrand/Audit/DraftFirewall.lean`, and the duplicate theorem
  rename in `PhysicsSM/NullStrand/NullFiber/RegulatorNoGo.lean` from project
  `f105c00d-a222-4e7a-ab4e-00f242c4d624`.

The remaining four projects were canceled/replaced by the nudge path and their
replacement tasks failed without patchable Lean output. They are being resubmitted
in the next wave with explicit "do not run full build" instructions.
