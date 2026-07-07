# Aristotle playbook (two-day carrier run) - heavy use, three job classes

Aristotle is the run's engine and is to be used VERY heavily - but heavily on the
three axes it is actually good at, not on slot-filling. Full mechanics:
`docs/ARISTOTLE.md`. This playbook is the run-specific doctrine.

## 1. The fleet mix (up to 12 concurrent - run HOT)

Run the fleet at **up to 12 simultaneous jobs**. At any time, aim for:

- **8-10 PROOF/CONSTRUCTION jobs** - isolated, statement-first, non-colliding,
  split across both agents' lanes (Claude: carrier/T/A bricks; Codex: OS1/QC/KP
  bricks). Each agent runs up to ~5 of its own.
- **2-3 AUDIT jobs** - adversarial semantic audits, fired EVENT-DRIVEN after every
  2-4 integrated proofs (sec 3). The run's independent third reviewer; last run
  they caught what self-review missed. Keep 2-3 in flight whenever integrations
  are flowing.
- **STRATEGY jobs, two tiers, run OFTEN** (sec 4): FREQUENT focused jobs on
  specific threads (well above hourly, whenever a thread has a live question) PLUS a
  GRAND-STRATEGY whole-project review at least HOURLY (a floor, not a target), agents
  alternating. Strategy jobs never go stale, so they are the first thing spare
  capacity converts to.

**12 is a CEILING, not a quota.** The saturation discipline still binds absolutely:
if you cannot fill the proof slots with GENUINELY OPEN, non-stale targets, do NOT
fill them with re-derivations. An unfilled slot is signal (saturation -> escalate
per `RUN_PLAN.md` sec 5); a slot burning budget on an already-landed target is a
bug. Last run produced byte-identical re-derivations because prompts outlived their
targets - hence the stale-check rule below is absolute. When proof targets run dry,
convert spare capacity to MORE audit + strategy jobs (which never go stale), not to
duplicate proofs.

## 2. PROOF jobs - the discipline

1. **Statement first.** The submitting agent writes the exact Lean statement
   (and, for Move-1/2 flagships, gets it Fable-RATIFIED first). Aristotle proves;
   it does not choose what to prove.
2. **Stale-check (absolute rule).** Before submitting "build/prove X in file F":
   check F in the tree (`ls`, `grep` for the theorem name, count placeholder
   tokens). If the target exists and is placeholder-free, the job is stale - do
   not submit; update `THREAD_BOARD.md` instead.
3. **Package minimal.** Standalone (Mathlib + a few restated defs) whenever the
   target allows - cheaper and faster. Repo snapshot only when the import graph
   is genuinely needed; stage Lean-project-only (sec 6). Generate a context pack
   (`Scripts/aristotle/make_context_pack.py`) for nontrivial full-repo jobs.
4. **One target per job.** A job with three goals returns one goal done and two
   half-done. Split.
5. **Harvest-first.** Every cycle integrates completed jobs BEFORE submitting new
   ones. An unharvested COMPLETE job is inventory rotting.
6. **2-hour rule.** RUNNING > 2h -> cancel, `continue --mode instruct` to
   finalize-without-build if the partial work is worth keeping, else park.
7. **Review on arrival.** Every deliverable gets the four-mode over-claim hunt +
   axiom-footprint check + import-path fix (Aristotle habitually writes short
   imports - fix to full `PhysicsSM.Draft...` paths) before integration, then
   cross-review by the other agent before "landed."

## 3. AUDIT jobs - the independent red team

Submit with a prompt of this shape (see the overnight run's
`prompt_A10a_capstone_audit.md` for a worked example):

> You are an adversarial mathematical auditor. Below is the VERBATIM Lean source
> of N recently-landed theorems plus their docstrings and the intended readings.
> Hunt specifically for: (1) vacuous quantification (a `forall/exists` order that
> asserts nothing; unsatisfiable hypotheses), (2) hollow proofs (a load-bearing
> hypothesis unused - check with `#print axioms` reasoning and by asking what the
> proof would prove with the hypothesis deleted), (3) docstrings claiming more
> than the statement (semantic drift between prose and kernel), (4) statements
> that are secretly a known-false shape. For each finding: severity, the exact
> line, the honest downgrade or fix. Deliver findings as a Markdown report; do
> NOT "fix" the code.

Trigger: **EVENT-DRIVEN - after every 2-4 integrated proofs, fire an audit job** on
the most recent / riskiest landings (keep 2-3 audit jobs in flight while
integrations flow). Prioritize: capstone-adjacent > guard-file changes > new lane
headliners. Maintain an audit counter in the ledger (`[AUDIT-DUE]` when 2-4
integrations have accumulated unaudited). File findings as `[AUDIT-FINDING]`; a
confirmed finding is a WIN (log the catch), and the downgrade commits the same cycle.

## 4. STRATEGY jobs - Aristotle as strategist (two tiers, run OFTEN)

Strategy jobs are cheap insurance and the budget is unconstrained - run them
FREQUENTLY, in two tiers.

### 4a. FOCUSED strategy jobs (as often as useful - well above hourly)

On a SPECIFIC thread / decomposition / stuck lemma. Whenever a thread has a live
design question, a stalled proof, or a route choice, fire one - do not wait for a
clock. These should be many per hour when work is flowing.

> Given [the thread's goal, the exact current statements, what landed, what failed
> and how - all verbatim], produce: (a) can the current decomposition succeed as
> stated? (b) the sharpest alternative decomposition; (c) any counterexample risk to
> the stated lemmas; (d) the three highest-value next lemmas with exact Lean
> statements. Cite Mathlib API by name where relevant.

### 4b. GRAND STRATEGY jobs (at least once per hour - a FLOOR, not a target)

A HOLISTIC review of the WHOLE project against its goals - never a single thread.
At least hourly, more whenever the picture shifts; agents alternate (Claude odd
hours, Codex even). Give Aristotle the full picture: the goal (the origin-of-mass
thesis + the `FABLE_STEER` carrier program), the current `HONEST_SCORECARD`, the
`THREAD_BOARD` (all threads + status), the axiom-guard state, and the recent
`LEDGER`. Ask it to be a skeptical program director, not a cheerleader:

> Reviewing the ENTIRE project against its stated goal (the full origin of mass from
> null edges, via the Weitzenbock-carrier unification): (a) are we on the right track
> - is the carrier decomposition still the right organizing principle, or is there a
> better one? (b) across ALL lanes/threads, what is the single highest-value next
> move, and what is being over- or under-invested? (c) what are the top risks,
> dead-ends, or statements likely to be false or mis-scoped? (d) what should be
> re-scoped, escalated to Fable, or abandoned? (e) does the scorecard's
> PROVED/MODELED/OPEN grading match the actual kernel state, or is anything
> over-claimed? Give a ranked, decision-forcing set of recommendations.

Grand-strategy outputs are consolidated into the ledger (`[GRAND-STRATEGY]`) and feed
BOTH the thread board (route updates) and the Fable queue - a grand-strategy job that
flags a wrong organizing principle, a likely-false headline, or a scorecard
over-claim is an immediate HIGH-PRIORITY `FABLE_QUEUE.md` item. Where focused and
grand strategy disagree, the disagreement itself goes to Fable.

Any strategy job (either tier) that says "the statement is probably false" is an
immediate `FABLE_QUEUE.md` item with the evidence attached.

## 5. Budget posture - UNCONSTRAINED (user-set)

Budget is **unconstrained**: run the fleet as hot as there is GENUINE OPEN WORK.
The only limit is job quality (open target + exact/ratified statement + minimal
package), never spend and never slot count. Prefer over-submitting GOOD jobs to
idling. But "unconstrained" is not "mindless": the saturation discipline (sec 1,
`RUN_PLAN.md` sec 5) still binds absolutely - when open proof targets run dry, spare
capacity goes to MORE audit + strategy jobs (which never go stale), NEVER to
duplicate or speculative-breadth proofs that will not integrate. Cancel decisively
(2-hour rule, superseded targets, Fable-redirected routes). Log every
submit/harvest/cancel in the ledger with the project id so the other agent can pick
up your fleet mid-run.

## 6. Mechanics crib (Windows; learned the hard way - do not relearn)

- **Stage minimal:** `git archive HEAD -- PhysicsSM lakefile.toml lean-toolchain
  lake-manifest.json PhysicsSM.lean PhysicsSMDraft.lean PhysicsSMSPL.lean
  AGENTS.md | tar -x -C <stage-dir>` - the FULL tree hits Windows MAX_PATH under
  `AgentTasks/aristotle-standalone/` and the submit dies mid-tar.
- **Job name = staging-dir basename** (`--name` does not exist). Name dirs
  `tc-<thread>-<slug>` so `aristotle list` reads as a board.
- **Download to a FILE path:** `aristotle download <id> --destination x.zip`
  (it `write_bytes`, a directory fails with PermissionError). The archive is
  gzip despite `.zip`: `gzip -dc x.zip > x.tar && tar --force-local -xf x.tar`
  (plain `tar -tf C:/...` parses `C:` as a remote host).
- **`aristotle show` on a RUNNING job** streams a progress bar and hangs the
  call - wrap in `timeout`, or `show` only non-RUNNING jobs; `list` is safe.
- **Transient `AristotleAPIError` on submit:** wait ~5s, retry once - it was a
  blip both times observed.
- **Empty-prompt hazard:** `$(cat file)` in a fresh shell where the variable/dir
  changed silently submits an empty prompt. Echo the prompt length before
  submitting; if a job went out empty, rescue with
  `aristotle continue --mode instruct <id> "<prompt>"`.
- **Deliverable import paths:** Aristotle writes `import ChiralMassStructure`
  style short paths; rewrite to full `PhysicsSM.Draft...` before `lake build`.
- **CRLF:** Aristotle files arrive CRLF; the first `git commit` aborts on the
  pre-commit fix - re-`git add` the specific files and re-commit. Never
  `git add -A` blindly.
