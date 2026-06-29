---
aristotle:
  project_id: 15d7ae6c-3c97-4a54-89fd-ea8d6a9e22dc
  task_id: ca34c754-a3c4-4462-a102-295d8af2793b
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-furey-hughes-round-20260627-project
  output_dir: AgentTasks/aristotle-output/15d7ae6c-3c97-4a54-89fd-ea8d6a9e22dc
  status: summary_integrated
---

# C112 Aristotle job: native Gate C1 branch-selector candidates

Date: 2026-06-27

## Prompt

You are helping the PhysicsSM null-edge program. This is a strategy and
formalization-design job, not a full-repo build job.

Read the attached `ROUND_CONTEXT.md`. The current Gate C1 blocker is the missing
null-edge-native branch selector `B(U)`.

Recent finite-origin results show that any successful selector must not be
balance-even on the origin kernel. If `B` commutes with the balance symmetry `J`,
then polynomial selectors `p(B)` have zero chiral trace. Nonzero chiral trace
requires a nonzero `J`-odd component.

The user has asked whether Cohl Furey and Mia Hughes' symmetry-breaking pattern
can guide this search. Their relevant pattern is: choose an internally preferred
complex structure, involution, projector, or action split; then define the
surviving symmetry by the centralizer/invariant structure.

Task:

1. Rank the most promising null-edge-native candidate sources for `B(U)` or
   `T_br`.
2. For each candidate, say whether it plausibly produces a nonzero balance-odd
   origin component.
3. For each candidate, identify the likely gauge-safety risk.
4. For the top two candidates, propose formal definitions and theorem goals.
5. Give at least one candidate no-go: a class of superficially plausible
   selectors that must fail because they are scalar, central, or balance-even on
   the origin kernel.

Candidate families to consider:

- branch involution from branch geometry,
- null-edge complex structure,
- path-orientation parity,
- holonomy-derived branch observable,
- primal/dual soldering involution,
- internal/spacetime left-right action separator,
- overlap or sign-function operator,
- domain-wall or boundary projector,
- Schur-complement projector after integrating out auxiliary degrees of freedom,
- finite-volume combinatorial path-sum selector.

Required output:

- A ranked list.
- A short theorem statement for the highest-ranked route.
- A formalizable API sketch.
- A concrete finite-origin test for each top route.
- Recommended follow-up Aristotle jobs.

Important constraints:

- Do not claim Gate C1 is solved.
- Do not use a propagator zero to hide a gauge-charged mirror branch.
- Do not rely on arbitrary scalar Wilson-like corrections.
- If a route requires non-ultralocality, describe the needed control theorem.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-furey-hughes-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: 15d7ae6c-3c97-4a54-89fd-ea8d6a9e22dc

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
ca34c754-a3c4-4462-a102-295d8af2793b 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

System.Collections.Hashtable.Label

Project: $(System.Collections.Hashtable.Id)

Integrated into:

- Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md section 22.
- AgentTasks/null-edge-aristotle-gate-c1-completed-integration-2026-06-27.md.

Note: Aristotle reported standalone clean builds where applicable, but this pass did not promote returned Lean files into trusted PhysicsSM modules and did not run local Lean verification.
