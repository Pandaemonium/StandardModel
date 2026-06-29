---
aristotle:
  project_id: bde58802-f678-444c-b0d2-738a136403e7
  task_id: 6c7f4fd0-22a9-4981-b346-a894020f8d6c
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-furey-hughes-round-20260627-project
  output_dir: AgentTasks/aristotle-output/bde58802-f678-444c-b0d2-738a136403e7
  status: summary_integrated
---

# C114 Aristotle job: origin polarizer to branch-line selector bridge

Date: 2026-06-27

## Prompt

You are helping the PhysicsSM null-edge program. This is a mathematical
theorem-design and formalization-planning job, not a full-repo build job.

Read the attached `ROUND_CONTEXT.md`.

Recent finite-origin work gives a necessary test for a branch selector: at the
origin, it must have nonzero balance-odd content visible to chiral trace. This
does not yet prove a physical branch-line selector near the origin.

Gate C1 now needs a bridge theorem:

If a finite origin polarizer exists and satisfies appropriate nondegeneracy
hypotheses, then nearby smooth branch germs inherit a stable physical branch
projector.

Task:

Propose the strongest realistic bridge theorem from finite-origin polarizer data
to branch-line selection near the origin.

Please address:

1. What mathematical setting should be used?
   - analytic matrix family,
   - smooth branch variety,
   - kernel bundle or kernel sheaf over the smooth branch locus,
   - spectral projector perturbation,
   - Riesz projector,
   - Schur complement,
   - Kato perturbation theory,
   - another framework.
2. What hypotheses are needed?
   - isolated spectral island,
   - gap separation,
   - constant kernel dimension,
   - smoothness/analyticity,
   - nonzero origin chiral trace,
   - absence of singular branch intersections,
   - gauge covariance of the projector.
3. What conclusion is actually justified?
   - one smooth line projector near the origin,
   - Weyl-symbol leading behavior on that line,
   - complement separated by a gap,
   - stability under perturbation.
4. Which parts are finite-dimensional and Lean-friendly?
5. Which parts require analysis that should stay in docs for now?

Requested output:

- A theorem statement with exact hypotheses and conclusion.
- A weaker fallback theorem that is easier to formalize.
- A list of counterexamples showing why each major hypothesis is needed.
- A suggested Lean skeleton for the finite-dimensional perturbation part.
- Next Aristotle jobs.

Important constraints:

- Do not claim that origin chiral trace alone proves physical release.
- The bad sector must ultimately have a true inverse-propagator gap, not merely a
  zero.
- If non-ultralocality is needed, separate that theorem from the finite bridge.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-furey-hughes-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: bde58802-f678-444c-b0d2-738a136403e7

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
6c7f4fd0-22a9-4981-b346-a894020f8d6c 0 secs ago           ---
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
