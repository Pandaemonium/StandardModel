# Brief for Fable-5: design a co-equal Claude + Codex autonomous loop

You (Fable-5) are asked to **design a new autonomous loop** in which two peer coding
agents - **Claude** (Opus) and **Codex** - work together, continuously and largely
unattended, to drive the null-edge origin-of-mass program toward the goal you just
sharpened: the **Weitzenbock-carrier unification** (see `FABLE_STEER.md`). This brief
gives you (Part A) the documents to read, ordered by why they matter, and (Part B) my
operational guidance from having actually run these loops - the failure modes to design
out and the invariants to design in.

Your deliverable is the loop design itself: the two agents' goal prompts (a
`GOAL_PROMPT_CLAUDE.md` / `GOAL_PROMPT_CODEX.md` pair), the coordination protocol, the
cadence, the lane split, and the success/termination criteria. Part B is what I'd want
that design to guarantee.

---

## PART A - Reading list (tiered; read Tier 0 fully, skim the rest by need)

### Tier 0 - the rules, the goal, the current direction (READ FULLY)
- **`AGENTS.md`** (repo root; `CLAUDE.md` just includes it) - the always-on rules:
  the prime directive (kernel = truth), trusted vs draft code, the FORBIDDEN tokens
  (`axiom`/`opaque`/`unsafe`/`admit`/`sorry`/`native_decide` in trusted code), the
  Aristotle policy, provenance, text hygiene, the failure protocol. This is the
  constitution; the loop must not violate it.
- **`AgentTasks/overnight-mass-run-2026-07-06/FABLE_STEER.md`** - the CURRENT organizing
  principle. The whole loop exists to execute its Moves 1-3. Read this before anything
  else about *what* the loop should do.
- **`.../FABLE_HELP.md`** - your own prior synthesis (the verdict + the reasoning). For
  continuity of your thinking.
- **`.../HONEST_SCORECARD.md`** - the honest, kernel-grounded status: what is PROVED vs
  MODELED vs OPEN, and the common-carrier verdict section. This is the loop's dashboard.
- **`.../GOAL_PROMPT_OPUS.md`** - the current single-agent goal spec. Your new pair should
  supersede/refactor this into two coordinated prompts.
- **`docs/CONVENTIONS.md`** - convention-lock status (signs, bases, normalizations). A
  loop that drifts conventions silently corrupts everything; this pins them.

### Tier 1 - loop mechanics and tooling (READ the mechanics, skim the rest)
- **`docs/ARISTOTLE.md`** - Aristotle submission/integration mechanics, the task-note
  metadata block, the 2-hour rule, the preferred loop, context packs. The external proof
  fleet is the loop's engine; this is its manual.
- **`docs/BUILD.md`** - build/verify commands, the toolchain pin (`v4.28.0`, do not
  upgrade), the one-time Windows ProofWidgets fix, the placeholder scan.
- **`Scripts/autonomous_loop/loop_harness.py`** and **`send_claude_review.py`** /
  **`send_gemini_review.py`** - the EXISTING loop harness and the external-review
  wrappers (all model calls must go through these and log to `AgentTasks/model-calls/`).
  Design your loop to reuse this harness, not reinvent it.
- **`Scripts/MCP_SERVERS.md`** - the six MCP servers (lean-lsp live goals + Mathlib
  search; lean-explore offline Mathlib+PhysLean; neo4j graph; literature; Zotero; local
  LLM) and the search -> triage -> Zotero -> Neo4j workflow.
- **`AgentTasks/overnight-mass-run-2026-07-06/JOB_BACKLOG.md`** - the re-scoped backlog;
  read the **PRIORITY 0** (Weitzenbock-carrier) section - that is the loop's work queue.
  Note the "de-scoped/stale" list: much of the old backlog is LANDED (see Part B, the
  saturation lesson).
- **`.../LEDGER.md`** - the running append-only ledger. Study the "HB" (heartbeat) entry
  style and the claim/coordinate/cross-review pattern; your loop's coordination channel
  should look like this.

### Tier 2 - the prior two-agent run (THE TEMPLATE to improve on)
The `fourday-ym-run-2026-07-05` was a genuine co-equal Claude+Codex run. Read it as the
concrete prior art - what worked, what to sharpen:
- **`AgentTasks/fourday-ym-run-2026-07-05/GOAL_PROMPT_CLAUDE.md`** and
  **`.../GOAL_PROMPT_CODEX.md`** - the paired goal prompts. Your new pair should be a
  strict improvement: clearer lane split, tighter anti-collision, explicit
  harvest-before-submit, saturation awareness.
- **`.../LEDGER.md`** - how the two agents actually coordinated over four days (claims,
  cross-review, harvest protocol).
- **`.../RUN_PLAN.md`** and **`.../GOAL_STATEMENT_ACHIEVABLE_WORK.md`** - the plan and the
  honest achievable-scope framing.
- **`.../GRAND_STRATEGY_AUDIT_whole-project_claude_0bd9d3b4.md`** and
  **`.../GRAND_STRATEGY_AUDIT_ym_codex_89ae2c3b.md`** - each agent's strategic audit;
  shows the "two independent audits then reconcile" pattern worth keeping.

### Tier 3 - domain content: null-edge + the NSBB merge point
The carrier (Move 1) reuses NSBB's causal diamonds as 2-cells and its Krein `#`-structure
as the adjoint - so the two programs merge here. Read enough to design Move-1 jobs:
- **`docs/NULLSTRAND.md`** - null-edge / null-strand conventions and living-program
  guardrails (the operator architecture `sum_a c(alpha^a) nabla_ell_a`, the trace
  obstruction, chirality/grading separation).
- **`docs/NERD_ROADMAP.md`** - the master roadmap for the NSBB/NERD program (the Krein
  self-adjoint super-Dirac work the carrier merges with).
- **`AgentTasks/nerd-gate-i1-kinematic-core-lean-plan-2026-07-02.md`** and the other
  `AgentTasks/nerd-gate-*` freezes - the kinematic-core / Krein / causal-diamond material
  the carrier's `#` and 2-cells come from.
- The landed corpus itself does NOT need reading module-by-module; `HONEST_SCORECARD.md`
  + `FABLE_STEER.md` sec 5 name every theorem you need to build on.

---

## PART B - Guidance: how to make the two-agent loop succeed

Ordered by how much each will make-or-break the run. These are design invariants; encode
them into the goal prompts and the coordination protocol.

### 1. Point the loop at Move 1/2, not at volume. (The single most important thing.)
The goal is now precise: the carrier + the discrete Weitzenbock decomposition + the four
component-identification lemmas + graded irreducibility + relative exhaustiveness. The
loop's success metric is **progress on those specific theorems**, not module count. The
old regime rewarded breadth and produced ~40 finite shadows; that regime is exhausted
(see #5). Design the goal prompts around the Moves, with each Move broken into
Aristotle-ready sub-lemmas (I have already seeded two: `sm-weitzenbock-brick` and
`sm-color-commutant`).

### 2. Coordination: claim-before-touch, non-colliding lanes, cross-review. (The heart.)
Two peers on one repo collide in three places: the same Aristotle job, the same source
file, and the same integration point (aggregators/guards/capstone). Design all three out:
- **Claim protocol.** Before starting any lane/module/job, an agent appends a claim line
  to a shared, append-only `LEDGER.md` (`[CLAIM Claude HH:MM] Move-1 Weitzenbock brick`),
  and reads the other's open claims first. Release on completion. This is the whole
  anti-collision mechanism; make it non-optional.
- **Lane split (my recommendation).** Assign standing lanes so the two rarely touch the
  same file: **Claude -> T (turn) + A (aperture) + the carrier ALGEBRA** (Clifford /
  Krein square / identification lemmas Q_A,Q_T, null nilpotency); **Codex -> C (closure) +
  the gauge/YM + polymer/analysis** (strong-coupling SU(2), Q_C-in-expectation,
  Osterwalder-Seiler, the KP/Penrose crux). B (octonion->spectral triple) and V (E8) are
  shared/opportunistic. Move-1 (the shared Weitzenbock assembly) needs a single owner per
  cycle - claim it.
- **Separate integration surfaces.** Give each agent its OWN axiom-guard file (e.g.
  `SlabAxiomGuard` stays Codex/closure; add a `CarrierAxiomGuard` for Claude/carrier) so
  they don't both edit one guard and conflict. Serialize edits to genuinely shared files
  (the capstone, the aggregator) via a claim.
- **Cross-review, mandatory.** Nothing an agent integrates is "trusted" until the OTHER
  agent red-teams it (over-claim/vacuity/hollowness hunt, see #3). Bake a review handoff
  into every integration. This is where two agents beat one: mutual adversarial review.
- **Conflict hygiene.** Frequent small commits; append-only shared docs; each agent
  commits its own lane. Expect and handle the CRLF pre-commit abort (#7).

### 3. Honest-claim discipline is the spine - and cross-review enforces it.
Every headline theorem is axiom-guarded (`#print axioms` pinned to
`[propext, Classical.choice, Quot.sound]` or fewer). Grade everything PROVED / MODELED
(explicit hypothesis) / OPEN. The four over-claim failure modes this program has actually
caught - design the review to hunt each:
1. **Vacuity** - a quantifier order that asserts nothing (`forall m, exists C` when C must
   be uniform in m); an unsatisfiable hypothesis making a theorem vacuously true.
2. **Hollow telescoping** - proving `sum of a branch = 0` where the branch is trivially
   single-valued and the load-bearing hypothesis (chirality, etc.) goes UNUSED.
3. **Docstring outrunning the kernel** - the prose claims the topological no-go / the gap
   / the mechanism; the kernel proves a local algebraic fact. Downgrade the prose.
4. **False-shape** - re-proving a mis-stated bound that is actually FALSE (the KP crux
   trap at order x^3). Keep the known verified-negatives visible so neither agent re-proves
   a falsehood.
A rejected hollow result is a SUCCESS of the loop, not a failure. Never move draft ->
trusted with an open `sorry`/`native_decide`.

### 4. Aristotle protocol: harvest-first, check-not-stale, respect the 2-hour rule.
- **Harvest before submit.** Each cycle: download+integrate completed jobs BEFORE
  refilling. An idle fleet with unharvested results is the failure to fix first.
- **Check the target is not already landed.** (Hard lesson - see #5.) Before submitting a
  "build X" job, verify X's target file doesn't already exist sorry-free in the tree; else
  you pay budget to reproduce a byte-identical file. `grep`/`ls` the target path first.
- **Standalone vs full-repo.** For proof-only targets isolatable to Mathlib + a few
  defs, prefer a focused standalone package (cheap, fast). Use a repo snapshot only when
  the import graph is truly needed. Full-repo packages spend budget on project builds
  before proof search.
- **2-hour rule.** Cancel + finalize-without-build any job RUNNING > ~2h. Don't let a
  hung construction job hold a slot.
- **Fleet level.** "Saturated" is the old target; the honest target now is "warm with
  genuinely-open carrier jobs." 3-5 real Move-1/2 jobs beats 10 shadows. If you can't fill
  10 slots with non-stale work, that is SIGNAL (see #5), not a slot to force-fill.

### 5. Recognize saturation; re-scope instead of churning. (The biggest lesson of this run.)
This run discovered the finite-shadow backlog is largely LANDED - the fleet had begun
re-deriving in-tree results (two gate jobs returned byte-identical files). Mechanically
"keeping the fleet saturated" then becomes anti-productive. The invariant to encode:
**when new jobs reproduce existing work, STOP widening and escalate to a re-scope** (to
Fable for a conceptual move, or up the Move ladder). The loop must be able to say "local
work is saturated; pacing" and mean it - no tight-loop churn, no busy-work commits. Pace
with a background timer between genuine cycles; do not poll external jobs in a sleep loop.

### 6. Cadences: genuine, not performative.
Keep the hourly lit-mine, hourly red-team, ~2-hour consolidation rhythm - but each must do
real work: the lit-mine feeds an ACTUAL open problem (the Fable reading list is queued);
the red-team actually hunts the #3 failure modes in recent commits; the consolidation
folds landed results into the scorecard/capstone and updates the honest status. A cadence
that produces a log line but no change is theater - design them to change state or report
"nothing to do" honestly.

### 7. Windows operational gotchas - codify these so neither agent re-loses the cycles.
- **Staging for Aristotle:** stage the Lean project ONLY (`git archive HEAD -- PhysicsSM
  lakefile.toml lean-toolchain lake-manifest.json PhysicsSM*.lean AGENTS.md`); staging the
  full tree hits Windows MAX_PATH in `AgentTasks/aristotle-standalone/...` and fails.
- **Download:** `aristotle download <id> --destination <FILE.zip>` (a FILE path, not a
  dir - it does `write_bytes`). Archives are gzip despite `.zip`: `gzip -dc x.zip > x.tar`
  then `tar --force-local -xf x.tar` (Windows `tar` reads `C:` as a remote host without
  `--force-local`).
- **`aristotle show` on a RUNNING job** streams a live progress bar that hangs the call -
  use a short timeout, or only `show` COMPLETE jobs; `aristotle list` is safe.
- **Job name = `--project-dir` basename** (no `--name` flag). Name the staging dir.
- **pre-commit** normalizes CRLF->LF on Aristotle-authored files, which aborts the first
  commit; re-`git add` and re-commit. Don't `git add -A` blindly (it sweeps in unrelated
  scratch files - unstage them).
- **`Glob` times out** on this repo; use `Grep`(ripgrep) / lean-explore / direct `ls`.
- **Foreground `sleep` is blocked**; pace with a background timer.

### 8. The role triangle, and the escalation channel back to you (Fable).
Design the loop with three roles: **Fable = conceptual driver** (verdicts, synthesis, new
connections, literature, and turning blockers into crisp statements); **Claude + Codex =
executors** (prepare Aristotle-ready statements, integrate, red-team, coordinate, keep the
honest status); **Aristotle = proof search**. The loop needs a defined channel to escalate
a CONCEPTUAL blocker back to you (via `send_claude_review.py`/`send_gemini_review.py`-style
wrappers, or a queued `FABLE_QUEUE.md`) rather than the two executors churning on a problem
that needs a new idea. The two cruxes you flagged (closure statistical positivity, Krein
positivity domain) are the standing examples: executors formalize around them; you get
pinged when a conceptual move is needed.

### 9. Define success and termination per thread.
Give every thread a crisp done-condition so the loop knows when to stop pushing it:
- Move-1 done = the discrete Weitzenbock identity `D^#D = Q_A+Q_C+Q_T+E` kernel-checked on
  a finite 2-complex with E's hypotheses explicit, axiom-guarded.
- Move-2 done = the four identification lemmas + graded irreducibility + relative
  exhaustiveness, guarded; the capstone's AND becomes a +.
- Move-3 done = strong-coupling SU(2) gap with explicit beta_0 (Osterwalder-Seiler),
  honestly scoped; all-beta explicitly OPEN.
A thread that hits its done-condition is banked and the agents move to the next; a thread
that stalls escalates (#8) rather than looping.

### 10. A concrete first-cycle for the new loop (so it starts productively).
1. Both agents read Tier 0 + their lane's Tier 1/3. 2. Post standing lane claims to the
ledger. 3. Harvest the in-flight carrier jobs (`sm-weitzenbock-brick`, `sm-color-commutant`,
`sm-product-haar`) - integrate the sound ones, cross-review. 4. Claude opens Move-1 (the
Weitzenbock assembly on NSBB causal diamonds); Codex opens Move-3 (strong-coupling SU(2) /
Osterwalder-Seiler formalization) + the Q_C-in-expectation identification. 5. Lit-mine the
queued reading list (Osterwalder-Seiler, Witten PET, Loring, Scott-Sokal already in-graph).
6. Consolidate into the scorecard. 7. Pace; repeat.

---

**The one-sentence charge for your design:** build a loop where two peers, each owning a
non-colliding lane and adversarially reviewing the other, drive the *specific* Move-1/2
carrier theorems to kernel-checked, honestly-graded completion - escalating conceptual
blockers to you and refusing to churn when the work is saturated.
