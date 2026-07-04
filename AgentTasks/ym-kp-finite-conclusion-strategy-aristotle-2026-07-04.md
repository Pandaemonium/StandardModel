# Aristotle job: finite KP polymer conclusion strategy (Q6, 2026-07-04)

```yaml
aristotle:
  project_id: 2427a253-ccb7-42d4-bd61-754da4ea5b93
  task_id: 08da7500-9a84-42e0-af32-8f11898547c1
  target_file: KP_Finite_Conclusion_Strategy.md
  expected_module: none; strategy/report job
  submission_project: AgentTasks/aristotle-submit/ym-kp-finite-conclusion-strategy-20260704-project
  source_root: none
  prompt: AgentTasks/aristotle-prompts/ym-kp-finite-conclusion-strategy-20260704.prompt.md
  context_pack: AgentTasks/context-packs/ym-kp-finite-conclusion-strategy-20260704-110414.md
  status: running
```

## Target

Q6 of `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`: freeze the minimal
finite Kotecky-Preiss polymer-conclusion statement on top of
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean`.

This is a strategy and statement-shape job, not a proof job. The requested
output is a report with Lean-syntax definitions/theorem signatures and a lemma
DAG for:

- absolute convergence of the finite abstract polymer cluster expansion;
- a tree-graph-bound route;
- an exponential tail estimate for clusters touching a set and lying at
  distance at least `R`.

## Critical audit question

The current Lean file freezes only `PolymerSystem` and `KPCondition`. The job is
asked to decide whether the exponential tail can follow from this bare condition
or whether Q6 needs an additional distance/energy hypothesis. A precise
"additional hypothesis required" verdict is acceptable and expected if true.

## Local preflight evidence

- `aristotle list --limit 20` on 2026-07-04 11:03 local showed no running YM
  jobs; recent jobs were `IDLE`.
- Context pack generated:
  `AgentTasks/context-packs/ym-kp-finite-conclusion-strategy-20260704-110414.md`.
- Exact grep over pinned Mathlib confirmed:
  `SimpleGraph.Reachable`, `SimpleGraph.Preconnected`,
  `SimpleGraph.Connected`, `SimpleGraph.ConnectedComponent`,
  `SimpleGraph.IsAcyclic`, `SimpleGraph.IsTree`, spanning-tree facts, and
  geometric-series/`Summable` infrastructure exist.
- Exact grep did not reveal any prebuilt polymer/cluster-expansion
  infrastructure; this matches `PolymerKPCriterion.lean`'s handoff note.

## Submission command

Run from `C:\Projects\StandardModel`:

```powershell
$prompt = Get-Content -Raw AgentTasks/aristotle-prompts/ym-kp-finite-conclusion-strategy-20260704.prompt.md
aristotle submit --project-dir AgentTasks/aristotle-submit/ym-kp-finite-conclusion-strategy-20260704-project $prompt
```

Submitted 2026-07-04 11:08 local as project
`2427a253-ccb7-42d4-bd61-754da4ea5b93`, task
`08da7500-9a84-42e0-af32-8f11898547c1`. `aristotle tasks` showed the task
`QUEUED`; a first `aristotle show` call timed out before returning events.
The no-`.lake` warning is expected for this report-only package.

Poll 2026-07-04 11:09 local:

- `aristotle list --limit 10`: project `2427a253...` is `RUNNING`.
- `aristotle tasks 2427a253... --limit 10`: task `08da7500...` is
  `IN_PROGRESS`.

## Harvest checklist

1. Record project id and task id in this note and in
   `AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md`.
2. When complete, download/extract under
   `AgentTasks/aristotle-output/<project-id>/`.
3. Read `KP_Finite_Conclusion_Strategy.md`; do not treat it as proof.
4. Post the statement-shape verdict in `DISCUSSION.md` under
   `idea:q6-kp-statement-shape`.
5. Only then freeze or edit `PolymerKPConclusion.lean` /
   `PolymerKPCriterion.lean`, with cross-review before claiming Q6 statement
   freeze.
