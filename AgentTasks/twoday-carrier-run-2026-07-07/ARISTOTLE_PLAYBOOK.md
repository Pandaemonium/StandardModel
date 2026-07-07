# Aristotle playbook (two-day carrier run) - heavy use, three job classes

Aristotle is the run's engine and is to be used VERY heavily - but heavily on the
three axes it is actually good at, not on slot-filling. Full mechanics:
`docs/ARISTOTLE.md`. This playbook is the run-specific doctrine.

## 1. The fleet mix (the standing target)

At any time, aim for:

- **4-7 PROOF/CONSTRUCTION jobs** - isolated, statement-first, non-colliding,
  split across both agents' lanes (Claude: carrier/T/A bricks; Codex: OS1/QC/KP
  bricks).
- **1-2 AUDIT jobs** - adversarial semantic audits of recently landed flagships
  (sec 3). These are the run's independent third reviewer, and last run they
  caught what self-review missed. Keep one in flight almost always.
- **1 STRATEGY job every ~6h** - a written strategic review of the currently
  riskiest thread (sec 4), alternating agents.

If you cannot fill the proof slots with GENUINELY OPEN targets, do not fill them.
An empty slot is signal (saturation -> escalate per `RUN_PLAN.md` sec 5); a slot
burning budget on a re-derivation is a bug. Last run produced byte-identical
re-derivations because prompts outlived their targets - hence the stale-check
rule below is absolute.

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

Rotation: every flagship lands -> enters the audit pool -> gets an Aristotle audit
within ~6h of landing. Prioritize: capstone-adjacent > guard-file changes > new
lane headliners. File findings to the ledger as `[AUDIT-FINDING]`; a confirmed
finding is a WIN (log the catch), and the downgrade commits the same cycle.

## 4. STRATEGY jobs - Aristotle as strategist

Every ~6h, the on-duty agent (alternating: Claude at T+6, T+18, T+30, T+42;
Codex at T+0/T+12/T+24/T+36) submits a strategy job on the riskiest live thread:

> Given [the thread's goal, the exact current statements, what landed, what
> failed and how - all verbatim], produce: (a) an assessment of whether the
> current decomposition can succeed as stated, (b) the sharpest alternative
> decomposition, (c) any counterexample risk to the stated lemmas, (d) the three
> highest-value next lemmas with exact Lean statements. Cite Mathlib API by name
> where relevant.

Strategy outputs feed `THREAD_BOARD.md` route updates and the Fable queue (a
strategy job that says "the statement is probably false" is an immediate
`FABLE_QUEUE.md` item with the evidence attached).

## 5. Budget posture

Heavy means heavy: prefer over-submitting GOOD jobs to idling - the constraint is
job quality (open target + exact statement + minimal package), never slot count.
Cancel decisively (2-hour rule, superseded targets, Fable-redirected routes).
Log every submit/harvest/cancel in the ledger with the project id so the other
agent can pick up your fleet mid-run.

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
