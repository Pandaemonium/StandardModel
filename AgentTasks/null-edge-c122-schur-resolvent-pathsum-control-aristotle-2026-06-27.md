---
aristotle:
  project_id: bb7b761d-cef4-42fc-8cf6-2083223d55bb
  task_id: eabd8970-7b5f-4c47-8661-6502e7f1f948
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-pro-synthesis-round-20260627-project
  output_dir: AgentTasks/aristotle-output/bb7b761d-cef4-42fc-8cf6-2083223d55bb
  status: summary_integrated
---

# C122 Aristotle job: Schur/resolvent path-sum control

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a theorem-design job connecting the Schur-Feshbach route to controlled
non-ultralocal path sums. Do not build the full repo.

Goal:

Design the theorem that turns a Schur complement or resolvent:

```text
M^{-1}, or (M - T)^{-1}
```

into a controlled finite-volume path-sum expansion.

Task:

1. Give a finite-volume Neumann/path expansion:

```text
(M - T)^{-1} = M^{-1} sum_n (T M^{-1})^n
```

or the correct ordered variant.

2. Interpret matrix elements as sums over allowed paths.

3. State shell-count and amplitude-suppression hypotheses:

```text
number_of_paths(n) <= C mu^n;
norm(path_amplitude) <= A alpha^n;
mu alpha < 1.
```

4. Prove or sketch the tail bound and operator-norm convergence.

5. Add the oddness preservation audit:

If the Schur self-energy has a balance-odd finite coefficient and the path-sum
converges in norm, under what conditions is the balance-odd origin component not
lost in the limit?

6. Add the gauge covariance audit:

If each path amplitude transforms by endpoint conjugation, prove the finite sum
and limit transform by conjugation.

7. State what remains outside this theorem:

```text
physical Weyl residue;
bad-sector gap;
anomaly accounting;
Krein positivity.
```

Requested output:

- A clean theorem stack suitable for later Lean formalization.
- Minimal hypotheses.
- Counterexamples or failure modes for conditional/oscillatory convergence.
- Recommended next Aristotle jobs.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-pro-synthesis-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: bb7b761d-cef4-42fc-8cf6-2083223d55bb

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
eabd8970-7b5f-4c47-8661-6502e7f1f948 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-3-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
