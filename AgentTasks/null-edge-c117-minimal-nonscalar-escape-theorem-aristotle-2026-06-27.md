---
aristotle:
  project_id: e1bdabec-de36-46d5-aeb4-071be475a532
  task_id: 61e78ba2-b5ff-4c3e-b4dc-cf13da2c8973
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-furey-hughes-round-20260627-project
  output_dir: AgentTasks/aristotle-output/e1bdabec-de36-46d5-aeb4-071be475a532
  status: summary_integrated
---

# C117 Aristotle job: minimal non-scalar escape theorem for Gate C1

Date: 2026-06-27

## Prompt

You are helping the PhysicsSM null-edge program. This is a finite-dimensional
theorem-design job, with an eye toward a later Lean proof. Do not build the full
repository.

Read the attached `ROUND_CONTEXT.md`.

Current finite-origin results show:

- If a candidate selector is balance-even, it cannot produce nonzero chiral
  trace.
- Nonzero chiral trace requires a nonzero balance-odd component.
- Chiral trace only sees the balance-odd part.

The project wants to extend this into a minimal-escape classification:

Any C1 release that is analytic/translation-invariant/scalar or balance-even on
the balanced origin kernel and vanishes to higher order cannot polarize
chirality. The release must use a non-scalar spinor-line operator, branch
involution, complex structure, projector, overlap/domain-wall construction, or
controlled nonlocal selector.

Task:

Formulate the cleanest finite-dimensional theorem package capturing this
minimal non-scalar escape hatch.

Please provide:

1. A no-go theorem for scalar or central corrections on a balanced origin
   kernel.
2. A no-go theorem for balance-even polynomial selectors.
3. A positive "minimal escape" theorem saying what extra structure is enough to
   make nonzero chiral trace possible.
4. A concrete toy model, preferably 2 x 2 or 4 x 4, showing the minimal escape.
5. A Lean-friendly API sketch:
   - finite type,
   - matrices over `Complex`,
   - chirality operator `Gamma`,
   - balance symmetry `J`,
   - odd/even decomposition,
   - selector `B`,
   - chiral trace functional.
6. A warning about which positive result is only an origin-polarizer result and
   not a full C1 release.

Requested output:

- Exact theorem statements.
- Proof sketches.
- A suggested file/module name for a standalone Lean job.
- Any likely Mathlib lemmas needed.
- Next Aristotle jobs.

Important constraints:

- Do not weaken the no-go by silently adding assumptions that make it trivial.
- Do not overclaim from the toy model.
- Avoid raw physical claims unless the theorem hypotheses include the necessary
  spectral/gauge/anomaly data.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-furey-hughes-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: e1bdabec-de36-46d5-aeb4-071be475a532

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
61e78ba2-b5ff-4c3e-b4dc-cf13da2c8973 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

System.Collections.Hashtable.Label

Project: $(System.Collections.Hashtable.Id)

Integrated into:

- Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md section 23.
- AgentTasks/null-edge-aristotle-gate-c1-completed-integration-2-2026-06-27.md.

Note: Aristotle reported standalone clean builds where applicable, but this pass did not promote returned Lean files into trusted PhysicsSM modules and did not run local Lean verification.
