# Autonomous loop control directory

This directory stores durable state for long-running autonomous work on the
null-edge / Furey / Standard Model project.

Use it as the first stop for a fresh agent session.

## Start-of-loop checklist

1. Read `state.json`.
2. Read `current-objective.md`.
3. Read the latest entries in `progress.md` and `decision-checkpoints.md`.
4. Check `aristotle-queue.md` for running and returned jobs.
5. Check `questions-for-user.md` for unresolved user decisions.
6. Check `meta-review.md` for the last strategic critique.
7. Run a targeted literature search for the current objective.
8. Pick one bounded next action.

## End-of-loop checklist

1. Append a progress entry.
2. Update `state.json`.
3. Log friction if anything slowed the loop.
4. Record the literature search in `progress.md`, `literature-queue.md`, or a
   dedicated note, including queries/sources and whether anything useful was
   found.
5. Update Aristotle, Claude, Pro, and literature queues.
6. Append a meta-review entry that checks whether the loop made real progress.
7. Record decisions or claim changes in `decision-checkpoints.md`.
8. Leave the next action clear.

## Mandatory cycle invariant

Every autonomous cycle must include every major loop function:

- goal/blocker analysis;
- Aristotle status/integration/submission work when any job is active or ready;
- literature search (unconditional);
- Track A local analysis and Lean/doc work (convergent gates C0/C1/H/F) when a
  real action is available;
- Track B action (qubit/information or generalization), falsifiability-gated, when
  a real action is available;
- meta-analysis of whether the activity is producing real progress on both tracks;
- friction logging and harness/tooling improvement when friction appears;
- Claude review once per Aristotle round, with a self-contained packet.

Hard rule: literature search and meta-review are required every cycle and may
only be shrunk, never skipped (a skip is a process failure recorded in
`meta-review.md`). The Track A/Track B *work* items are real-action-gated: when a
track is blocked on a running job or has nothing decisive to do, record that in
the meta-review and idle it - see the loop `AGENTS.md` section "Honest idle is a
complete cycle." Never pad a cycle with make-work (trivial Lean, near-duplicate
notes, checklist-as-Lean) to satisfy the invariant; an honest idle cycle is
complete, a padded one is not.

## Aristotle concurrency policy

Running Aristotle jobs are not blanket blockers. It is acceptable to have
multiple Aristotle jobs running in parallel when the targets are independent.

Before waiting, ask whether a running job is a hard dependency for the next
submission:

- Does the next target import the running job's expected module?
- Does the next theorem statement require a returned theorem from that job?
- Would submitting now duplicate or conflict with the running proof target?
- Has Aristotle explicitly rejected new work because of project capacity?

If the answer is no, submit the ready job. Record any capacity rejection or
stalled metadata call as friction, but do not turn all running jobs into a
global stop sign.

Do not skip the literature step. At minimum, run one targeted search against the
local literature graph, Zotero, arXiv/web, or another appropriate source for the
current blocker. Record the exact query/source and the result, even if the result
is "no new useful papers found." Memory of prior searches is not a substitute.

Do not skip meta-analysis. A cycle is not complete until `meta-review.md` has a
fresh skeptical entry asking whether the run moved a theorem gate, publication
claim, blocker, or harness capability. If the answer is no, the next cycle must
pivot or repair the process.

## Success standard

Do not measure success by the number of commands, files, papers, or jobs. A loop
is successful only if it moves a gate, narrows a blocker, proves or refutes a
statement, sharpens a publication claim, improves the harness, or packages a
hard question well enough that another model can help.

A loop that omits literature search or meta-review does not meet the success
standard, even if it performed useful local work.

## Helper script

```powershell
python Scripts/autonomous_loop/loop_harness.py status
python Scripts/autonomous_loop/loop_harness.py new-run --objective "..."
python Scripts/autonomous_loop/loop_harness.py record-friction --title "..." --detail "..."
python Scripts/autonomous_loop/loop_harness.py queue-pro --title "..." --question "..."
python Scripts/autonomous_loop/loop_harness.py queue-claude --title "..." --question "..."
python Scripts/autonomous_loop/loop_harness.py queue-aristotle --title "..." --target "..."
```

The script is intentionally simple and dependency-free. It does not replace
semantic judgment.

## Model-call wrappers

Use these wrappers for adversarial or strategic model calls from the loop:

```powershell
python Scripts/autonomous_loop/send_claude_review.py --packet AgentTasks\packet.md --slug short-name
python Scripts/autonomous_loop/send_gemini_review.py --packet AgentTasks\packet.md --slug short-name
```

Defaults:

- Claude: `opus` through the installed Claude CLI.
- Gemini: `gemini-3.1-pro-preview` through the Gemini REST API.

Dry-run first when changing the packet shape:

```powershell
python Scripts/autonomous_loop/send_claude_review.py --packet AgentTasks\packet.md --slug short-name --dry-run
python Scripts/autonomous_loop/send_gemini_review.py --packet AgentTasks\packet.md --slug short-name --dry-run
```

Logs:

```text
AgentTasks/model-calls/claude/
AgentTasks/model-calls/gemini/
```

Each call must produce one Markdown log file containing both the full prompt and
the full response or error. API keys must never be logged.

## Prompt standard for blind model calls

Claude and Gemini calls should assume the model comes in blind to the project.
Do not send a vague request and expect chat history to fill the gaps.

A useful packet must include:

- project thesis;
- current gate status;
- proved facts and theorem names;
- failed routes and negative results;
- exact assumptions to attack;
- what would count as success;
- what would count as failure;
- requested output format;
- next-action constraints, such as whether the answer should produce Lean jobs,
  literature leads, publication language, or a no-go verdict.

If the packet is not self-contained enough for a fresh model to give useful
one-shot feedback, improve the packet before calling the API.

## Policy update 2026-06-27: Aristotle concurrency and mandatory cycle steps

The autonomous loop should not wait merely because Aristotle jobs are already running. Keep the pipeline warm unless a specific result is a hard dependency for the next action, or the external service is rejecting new work because of capacity.

Default concurrency target:

```text
About 6-8 simultaneously running Aristotle jobs is acceptable.
```

Use dependency-aware scheduling:

```text
Submit ahead when the next job is independent.
Wait only when the next job needs a returned theorem, API shape, counterexample, or convention from a running job.
Prefer local preparation while waiting on hard-gated jobs: write the packet, define acceptance criteria, identify blockers, and prepare integration notes.
```

Every autonomous cycle must still include all core steps:

```text
1. analyze goals and blockers;
2. check and integrate completed Aristotle work;
3. run literature search;
4. do local Lean/docs/analysis work;
5. run meta-review for real progress and strategy correction;
6. call Claude once per Aristotle round or active cycle when adversarial feedback is useful;
7. submit new Aristotle jobs when independent work is ready;
8. log progress, friction, questions, and next actions.
```

Concurrency is not a license to spray vague jobs. Each submitted job should state what it depends on, what it does not depend on, and what result would change the next planning decision.

## Dependency-aware scheduling algorithm

At the start of each cycle, classify every candidate Aristotle job:

- `Independent`: can run now without any active job returning.
- `Soft-dependent`: can run now only if its assumptions are explicit and it makes no release claim.
- `Hard-dependent`: must wait for a specific active theorem, API shape, counterexample, or convention.

Use this scheduler:

- If fewer than about 6 useful jobs are running, prefer launching the best independent or soft-dependent job after integration checks.
- If about 6-8 jobs are running, launch only if the new job is genuinely independent, sharply scoped, and likely to change the next decision.
- If more than about 8 jobs are running, default to integration, local Lean/docs work, literature, meta-review, and packet preparation unless a new job is exceptionally high leverage.
- Never launch a hard-dependent job just to keep the queue busy. Prepare its packet and acceptance criteria locally, then wait for the dependency.
- Never wait merely because unrelated jobs are running.

Each submitted job packet should include a short dependency declaration:

```text
Dependency class: Independent / Soft-dependent / Hard-dependent.
Does not depend on: ...
Hard dependencies, if any: ...
Decision changed if this returns: ...
```

This keeps the loop from both failure modes: starving the proof queue while
jobs run, and spraying low-quality jobs that fork the theorem APIs before the
right dependencies return.
