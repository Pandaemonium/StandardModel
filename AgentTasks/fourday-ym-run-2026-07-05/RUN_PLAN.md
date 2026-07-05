# Four-day YM run 2026-07-05: system of record

Two co-equal autonomous partners - Claude Sonnet 5 (Claude Code) and
Codex 5.5 - work this repo for FOUR DAYS on the Yang-Mills / mass-gap
ladder, with Aristotle as shared proof engine and third partner (strategy,
red-team, triage). This file is the contract; shared state lives in
`LEDGER.md` and `DISCUSSION.md`; per-task technical direction lives in
`TASK_DIRECTIONS.md`; what the planning session already verified lives in
`PREP_NOTES.md`. "Day 1" is the first calendar day the loop starts;
day boundaries are local midnight, checkpointed per the daily-cadence
section.

The canonical work queue is **section 14 of
`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`** (items Q1-Q12, the
attack graph, and the adopted kill conditions). The run's task board maps
onto it; if the two ever disagree, section 14 wins and the board gets
fixed. This plan inherits the 2026-07-03 overnight run's protocol
(`AgentTasks/overnight-ym-run-2026-07-03/RUN_PLAN.md`) with the multi-day
extensions below; where the two differ, THIS file wins for this run.

## Mission (in priority order)

1. **Close RP-LINK** (Q1): instantiate the proved master theorem
   `ReflectionPositivityKernel` for the Wilson weight on a link-reflection
   lattice. First formalized reflection positivity for an interacting
   lattice gauge ensemble anywhere.
2. **Transfer Hilbert space** (Q2) and the **sector-correct D12 transfer
   matrix** (Q3): turn RP into a positive self-adjoint transfer operator
   on a genuine inner-product space, with the flux-vs-glueball sector
   decomposition proved, feeding `TransferGapDefinition.finiteMassGap`.
3. **Unconditional gap-lane spectrum** (Q4+Q5): harvest the running
   unitarizability job `d4a9bd1f`, strip the matrix-model hypothesis from
   `WilsonVacuumDominance`, prove eigenvalue reality/ordering.
4. **KP lane** (Q6-Q8): freeze the finite polymer-conclusion statement,
   push the tree-graph/tail-bound theorem (Aristotle-heavy), map the
   strong-coupling character expansion into it, and go for exponential
   clustering of local loop observables.
5. **Finish YM1 Theorem 2** (Q11): the boundary-circuit lasso
   identification on `RectTreeGauge` (ordering already derived).
6. **YM-LIT + paper units**: source-verify the RP and KP attribution debt
   (Osterwalder-Seiler, Menotti-style RP sources, Kotecky-Preiss);
   maintain novelty checks; outline the two nearest paper units (YM1
   finite-G exact solutions; RP-LINK).
7. **Aristotle-as-partner jobs**: a KP statement-shape strategy job; a
   semantic red-team of the transfer-Hilbert-space layer once built.

Q9 (finite strong-coupling gap assembly) and Q10 (infinite-volume state)
are STRETCH: attempt only after Q1-Q3 and Q6-Q8 have landed; reaching
their named-prerequisite lemmas (the local-algebra cyclicity statement)
already counts as strong progress. Q12 (Peter-Weyl) stays OUT except as
`DISCUSSION.md` notes.

## What a shockingly successful four days looks like

```text
RP-LINK kernel-checked for the Wilson weight on a concrete link-reflection
  lattice (Q1), with the transfer Hilbert space and positive self-adjoint
  transfer operator constructed on top of it (Q2);
the D12 flux-sector decomposition theorem proved: transfer preserves
  sectors, local plaquette algebra preserves the trivial sector (Q3);
vacuum dominance and nonnegative string tension UNCONDITIONAL (Q4), with
  fusion-operator eigenvalues proved real and ordered below the vacuum
  eigenvalue (Q5);
the KP finite polymer conclusion (convergence + cluster tail bound)
  kernel-checked (Q6) and the strong-coupling polymer map verified with
  volume-uniform constants (Q7), giving exponential clustering of local
  loop observables (Q8);
YM1 Theorem 2 closed end-to-end: boundary-circuit Wilson loop on the
  concrete rectangle (Q11);
the YM4 finite-gap statement assembled with every remaining hypothesis a
  NAMED, frozen lemma (Q9 doorstep);
attribution debt for RP/KP source-verified; two paper units outlined.
```

Honest negatives count at full value: a refuted statement, a false-start
sector definition caught by the oracle, a KP constant that is NOT
volume-uniform, or an RP cut kernel that fails PSD would each redirect
weeks and must be recorded as wins.

## Architecture

```text
Claude Sonnet 5 (loop)  <-- co-equal partners -->  Codex 5.5 (loop)
        |         \\                        //          |
        |     shared LEDGER.md + DISCUSSION.md          |
        |                    |                          |
        +---------->  Aristotle (proof + strategy/red-team jobs)
```

Both agents run in the same working tree on `main`. Safety comes from
ledger claims (file globs), not isolation. Aristotle is consulted three
ways: focused Mathlib-only proof packages; strategy/audit jobs at branch
points; `aristotle continue --mode ask` triage. External model reviews go
through `Scripts/autonomous_loop/send_claude_review.py` /
`send_gemini_review.py` only (logged under `AgentTasks/model-calls/`).

## Coordination protocol (inherited + multi-day deltas)

**Claims.** Ledger task board is the single source of truth. To work a
task: set its row `claimed-<agent>`, list file globs, post a heartbeat.
One active task per agent (plus passive Aristotle waiting). Never edit
inside the other agent's claimed globs. Multi-day delta: a claim with no
heartbeat for **3 hours** may be taken over after a `DISCUSSION.md` note.

**Heartbeats.** One line per 30-45 min cycle:
`<day>.<HH:MM> <agent> <task> <next-step>`.

**Cycle shape.** (1) Read ledger + discussion deltas since your last
heartbeat. (2) Answer `review:` threads addressed to you - they outrank
new work. (3) Act on your claim. (4) Poll Aristotle if you own
submissions. (5) Heartbeat; board update; substantive discussion posts
only.

**Cross-review.** Required before: submitting a new-statement Aristotle
proof job; integrating any Aristotle result produced DURING the run;
changing claim-language documents; and (multi-day delta) FREEZING any
statement file for Q2, Q3, or Q6 - these three carry the run's semantic
risk. Verdict within one cycle, with the standard three questions.
Harvesting jobs submitted BEFORE the run (`d4a9bd1f`) needs the
integration checklist + post-hoc review note only.

**Disagreement.** Math + repo evidence, two rounds max; then Aristotle
tiebreak or park in `Parked for user`. Never silently proceed.

**Commits.** After each verified batch: `pre-commit run --files <paths>`;
explicit `git add` paths; prefix `fourday-ym-202607: `; no push; no
amend. `.git/index.lock` collision: wait and retry; delete only if the
other agent's heartbeat is >30 min stale.

**Compaction/restart resilience (multi-day, load-bearing).** Assume your
context WILL be compacted or restarted multiple times. On every wake:
re-read the ledger tail (last ~20 heartbeats), your claimed row, and
discussion deltas; trust the board over your memory; never re-derive what
`PREP_NOTES.md` records. Anything you would need after a restart must be
IN THE RUN FILES, not in your head - write down partial proof states as
handoff comments in the draft files themselves.

## Daily cadence (multi-day core)

Each day has three fixed points:

1. **Day-start replan (first cycle of the day).** Re-read section 14 +
   yesterday's `DAY_<n>_REPORT.md` + the board. Reorder task priorities if
   the graph demands it (post `replan:` note in `DISCUSSION.md`).
   Reordering within the mission is free; ADDING a lane requires both
   agents' agreement + a `Parked for user` note if it touches scope.
2. **Midday integration point.** Harvest completed Aristotle jobs before
   submitting new ones (harvest-first is the standing rule).
3. **Day-end checkpoint (last ~90 min of the day).** No new proof
   submissions; integration sweep; targeted builds; full `lake build` if
   the live tree changed that day; ledger reconciliation; write
   `DAY_<n>_REPORT.md` per `DAILY_REPORT_TEMPLATE.md` (one agent drafts,
   the other reviews - alternate days); commit.

Day 4 ends with `FINAL_REPORT.md` instead: same template plus the
promotion-candidate list (what the user should consider moving toward
trusted), the paper-unit assembly state, and the recommended next run.

**Saturation rule (from the 2026-07-03 postmortem, binding).** Never
sleep-poll in a blocking loop. If your lanes are all blocked on external
jobs: do genuine side work (YM-LIT items, oracle fixtures, small freeze
lemmas, doc sync, paper-unit outlines) or END THE CYCLE and let the loop
re-invoke you. Recognize saturation honestly: four consecutive heartbeats
with no verified delta means switch tasks or write the day report early.

## Aristotle protocol (inherited, with run budget)

Budget FOR THIS RUN (user-authorized): up to **8 SIMULTANEOUSLY RUNNING
YM jobs**, proof + audit + strategy combined. There is NO daily
submission cap - submit as many jobs as the work genuinely supports, as
long as no more than 8 are running at once (check `aristotle list`
before submitting; a completed/IDLE job frees its slot on harvest).
Quality control comes from the existing rules, not a quota:
cross-review before new-statement submissions, harvest-first, cancel
jobs you beat locally, registry always current, and the two-failure park
rule. The standing one-job rule resumes when the run ends.

**Use the width for more than proofs - THIS IS UNDERUSED, FIX IT (binding
update, day 1).** An audit at hour ~3 found ZERO Aristotle jobs running
against the 8-slot budget, with only one job (the Q6 KP strategy job)
submitted during the run itself, while multiple `design:`/`review:`
threads sat waiting on slow peer-to-peer cross-review that Aristotle
could resolve in parallel. Aristotle is a partner, not just a prover -
the overnight run's strategy job (`ac230cc8`) and red-team (`cb437537`,
which caught the TransferPositivity over-claim) were among its
highest-value returns, and this run has the same eight-slot budget
sitting idle. The fix is a STANDING RULE, not just aspiration:

- **Whenever a `design:` or `review:` thread has a proposed resolution
  awaiting cross-review, submit an Aristotle audit/strategy job on it
  IN PARALLEL with peer review, not instead of it.** Do not let a
  design proposal sit waiting on a single peer's cross-review cycle when
  a third opinion is one submission away. This applies retroactively:
  any such thread open right now should get a job today.
  Rationale: Aristotle
  cross-review has already SAVED the run real time twice (the Q3
  Fable/Aristotle-style redesign correcting a false plaquette-flip
  claim; the Q6 KP strategy job correctly splitting supportable
  convergence from the unsupportable distance tail) - both of those were
  themselves audit-style calls, not proofs, and both changed the target
  before Lean was written.
- **Grand-strategy reviews** (whole-ladder audits): one on day 1 - THIS
  IS OVERDUE if not yet submitted; treat it as a same-day priority, not
  a someday item - (deliverable: sequencing critique of the Q1-Q12
  board + the lemma DAG to the YM4 gap + what the run is not seeing) and
  one at the day-3 replan (mid-run course correction against actual
  progress). Prompt format per
  `AgentTasks/aristotle-prompts/overnight-ym-ladder-strategy.prompt.md`.
- **Semantic red-team audits** of every flagship integration (Q1
  RP-LINK, Q2 transfer space, Q3 sector decomposition): the kernel
  checked the proof, the red-team checks the MEANING - over-claim
  scoping, inert hypotheses, convention drift, statement-vs-claim
  mismatch. One audit job per flagship within a day of its integration.
  This includes DRAFT modules that only reached a baseline tier (e.g.
  Q1's `doubled_wilson_reflectionForm_nonneg`) - a red-team on a
  self-scoped-honest baseline can still find something the author missed.
- **Statement-design jobs** at branch points (Q6 KP shape is the seeded
  example in TASK_DIRECTIONS T6): cheaper than burning proof attempts on
  a wrongly-shaped statement. Use this proactively for EVERY new design
  thread, not only ones that stall.
- **Midday integration-point check (new, binding):** at every midday
  integration point, before doing anything else, run `aristotle list`
  and count RUNNING jobs. If fewer than ~4 of 8 slots are in use, that is
  itself a signal to look across the open `design:`/`review:` threads
  and the task board for the next audit/strategy/proof submission -
  treat an empty queue as a finding, not a quiet moment.
- **Triage** via `aristotle continue --mode ask` on running jobs does
  not consume a slot.
- Aristotle-for-proofs remains encouraged wherever a proof step is
  well-specified and Aristotle-sized (per the existing focused-package
  discipline); the point of this update is ADDING the strategy/audit
  usage on top, not substituting for proof jobs.

Everything else carries over: focused standalone Mathlib-only packages
(`Scripts/prepare_aristotle_focused_submission.ps1`, invoked with
`pwsh`); skeleton must typecheck with exactly the documented handoff
`s o r r y`; convention-pin `rfl` lemmas in every geometric package (the
pattern that produced the 16-minute `1d9b5b19` success - make the
interface equation DEFINITIONAL so only the hard content remains);
narrow `lake env lean <file>` instruction; the "no .lake folder" warning
at submit is expected; `aristotle download --destination <file>`
produces a GZIP TAR despite any `.zip` name - extract with `tar -xzf`;
two failed attempts on the same statement = park with a failure note, do
not grind.

## Fable escalation resource (new for this run)

Claude Fable 5 may be called via the repo wrapper
(`send_claude_review.py --model claude-fable-5`) at most once per 2
hours, per `FABLE_CALL_PROTOCOL.md` in this directory (binding). Sonnet 5
owns the budget and executes calls; Codex requests via the queue in
`FABLE_CALLS.md`. Use it for what it is differentially good at -
pre-freeze statement design review (Q2/Q3/Q6 and any non-verbatim
Aristotle statement), falsity/sanity analysis, stuck-lane redesign,
conceptual adjudication, daily strategy audit, semantic red-team of
flagship results - and never for anything on the protocol's anti-trigger
list. One primary deliverable per call, packet template mandatory, every
answer ACTED/PARKED/REJECTED in writing, and Fable prose is a LEAD, not
proof: the kernel remains the source of truth. The protocol's AMBITION
MANDATE is binding: Fable is extraordinarily capable, so every call's
primary ask is a super-stretch deliverable pitched well beyond what
seems realistically possible (the complete redesign, the full
formalization-grade proof plan, the whole lemma DAG - never a mere
opinion), with an explicit fallback for graceful degradation.
Under-asking is the protocol's named most-expensive failure mode.

## Convention and oracle discipline (normative)

Everything from the overnight plan remains binding: freeze conventions
C-1..C-8; oracle-first for new convention-sensitive statements
(`Scripts/oracle/validate_lgt_core.py` stays green); the fusion
convolution argument order `sum_h w(h) chi(h^{-1} A)` is oracle-pinned;
LINK vs SITE reflection stay distinct; the D12 flux-sector qualifier is
load-bearing (flux gap vs glueball gap are DIFFERENT named quantities -
Q3's whole point). New for this run: the RP mirror-coordinate convention
of `ReflectionPositivityKernel` (third coordinate = negative side BY
MIRROR IMAGE; antilinearity lives in the form) is normative for all Q1/Q2
work - do not re-derive a variant.

## Guardrails (non-negotiable, whole run)

- **No trusted promotion for the entire run.** Draft modules under
  `PhysicsSM/Draft/NullEdge/GateYM/` wired into the aggregator + task
  notes. Promotion happens at the user's post-run review, guided by
  `FINAL_REPORT.md`'s candidate list.
- No `a x i o m` / `o p a q u e` / statement weakening; documented
  handoff `s o r r y` in draft context or hand to Aristotle.
- F-YM-CONFLATE at constitution grade, including the section 13.2 mass
  taxonomy (fermion / Wilson-regulator / YM-gap / gravitational mass do
  not borrow language from each other).
- Attribution debt: person-names out of claim language until YM-LIT
  verifies sources (file-comment use with "attribution pending" tag OK).
- Hygiene: ASCII, LF, final newline, spaced escape-hatch tokens in prose;
  `pre-commit run --files` per commit; never reformat untouched files;
  write files with UTF-8 no BOM (PowerShell: `Set-Content -Encoding
  utf8NoBOM`; never PS5 redirection).
- Build safety: broken live tree outranks everything; unfixable in ~45
  min -> `git revert` your commits and record why.
- Scope: the mission list is closed. Track B, Balaban, and any new
  physics lane are OUT - notes in `DISCUSSION.md` only. QCD1 spectral
  work is allowed ONLY as a saturation-time side lane and only its
  statement layer. **USER-DIRECTED AMENDMENT (end of day 1):** the user
  has directed an aggressive extension of the roadmap toward FULL QCD
  MASS FORMALISM (see "The road to full QCD mass formalism" below).
  Under that amendment: Peter-Weyl / compact-group representation
  theory enters as the QMF1 substrate survey lane; Grassmann/Wilson-
  fermion STATEMENT-LAYER work (QMF3/QMF4/QMF7 statement files) enters
  as the sanctioned stretch lane replacing the old QCD1-only carve-out.
  The three mountains M1-M3 REMAIN the critical path for days 2-4 -
  the QMF lanes are saturation-time and statement-layer work this run,
  full execution next run. Balaban/continuum-limit claims remain OUT
  at all times (QMF8 records why).
- Kill conditions from section 14 are live: RP blockage (Q1 kernel fails
  PSD) renames the route rather than fudging it; a flux-line lowest
  excitation renames the gap target; non-volume-uniform KP constants get
  reported, not weakened.

## Suggested initial lane split (not binding; the board rules)

- **Claude Sonnet 5:** T0 preflight, then T1 (Q1 RP-LINK closure,
  flagship), then T4/T5 (gap lane: unitarizability harvest + eigenvalue
  ordering), then T2 (Q2 transfer space) with Codex reviewing its design.
- **Codex 5.5:** T3 (Q3 D12 sector design theorem - resolve
  `design:q3-flux-sector` first), then T6 (Q6 KP statement freeze +
  strategy job), then T11 (Q11 lasso statement freeze + package), then T7
  (Q7 polymer map statement).
- Both: T12 (YM-LIT) and T14 (oracle fixtures) woven through; T13 (paper
  units) at day-end checkpoints or saturation time.

## Report specs

`DAILY_REPORT_TEMPLATE.md` defines the day-end checkpoint (short - 40
lines max). `FINAL_REPORT.md` (day 4) follows the overnight
`MORNING_REPORT.md` section list PLUS: promotion candidates with axiom
footprints; paper-unit assembly state; queue-item status sync back into
program-doc section 14 (edit the section's status notes as part of the
report commit); recommended next run shape. Report faithfully: failures,
refutations, and reverts are results.

## Day-2+ roadmap (user-requested update, end of day 1)

Day 1 outperformed the original sequencing: Q4/Q5 closed, Q1's zero-cut
tier closed INCLUDING ensemble identification (after the N3
refutation/Route-B redesign), the Q2 finite OS/GNS stack built four
layers deep (`TransferHilbert` -> `Block` -> `BlockShift` ->
`Z2Electric`), Q6 statement-frozen with a kernel-checked correction
(bare C2 refuted; self-incompatibility load-bearing), Q7's carrier
redesigned and adapter landed, Q8's conditional bridges landed, and
Q11's lasso identity proved. The mission list is unchanged, but the
CRITICAL PATH has narrowed to three named mountains. Everything else is
assembly.

### The three mountains

- **M1 - cut-plaquette RP (Q1 shocking tier).** The one remaining gap
  between the current stack and genuine Osterwalder-Seiler RP-LINK: a
  concrete lattice where the reflection plane CUTS links, the Wilson
  slab weight written in RP-KER mirror coordinates `W a c b`, and a
  spectral/mixture decomposition of the cross-cut coupling feeding
  `cutKernel_posSemidef_of_mixture` plus the day-1 product/finite-product
  closure lemmas. Strategy job `8271a64b` is running on exactly this
  statement shape - its harvest gates the day-2 build.
- **M2 - the KP combinatorial core (Q6).** Two independent hard
  theorems: (a) the Penrose tree-graph inequality (abstract `SimpleGraph`
  form, flagship job `e4458430` running; discharges Codex's parked
  `treeGraphBound_ursell` by specialization), and (b)
  `kp_partial_sum_bound` - the rooted KP tree-sum recursion that
  `071d1370` identified as the true analytic crux of C1. Both are needed
  before `ClusterCoeffData` has a genuine nonzero instance AND the
  corrected C2 becomes usable. These are the two hardest single theorems
  on the whole ladder; treat each as its own focused package, two-failure
  park rule applies.
- **M3 - the physical Wilson transfer instance (Q2/Q3).** The OS/GNS
  stack is complete but every theorem is abstract-kernel-level. Needed: an
  actual Wilson slab transfer kernel from a concrete lattice fed into
  `rpBlockMatrix`, yielding the first PHYSICAL positive transfer operator
  and unlocking `TransferGapDefinition.finiteMassGap` instantiation.

**Key synergy (do not miss this):** M1 and M3 share their missing
object - the concrete cut-bearing reflection lattice with the Wilson
slab weight in mirror coordinates. Build that ONE construction once,
serve both mountains. It is the single highest-leverage artifact left in
the run and should be the day-2 build target as soon as `8271a64b`
returns.

### Revised day milestones

- **Day 2:** (i) harvest `8271a64b` and build the cut-bearing lattice +
  slab-weight construction (M1/M3 shared object); (ii) harvest
  `e4458430` (Penrose) and drive `kp_partial_sum_bound` as a focused
  package with `ClusterCoeffData` as interface (M2); (iii) Q7 concrete
  connected-support/label API so the explicit `PlaquetteKPBound` can be
  STATED for a real geometry; (iv) harvest `acedaea2` and close the YM1
  Theorem 2 ensemble bridge (Q11) - nearest finished-theorem win.
- **Day 3:** mandated mid-run grand-strategy audit (already in this
  plan) recalibrated against M1-M3 progress; M3 physical transfer
  instance on the M1 geometry; Q8 conditional-discharge as Q6/Q7 pieces
  land; begin Q9 doorstep assembly (named-lemma gap statement) if two of
  three mountains have moved.
- **Day 4:** Q9 doorstep assembly with every remaining hypothesis a
  named frozen lemma; Q10 statement file (stretch, unchanged);
  `FINAL_REPORT.md` with promotion candidates and the section-14 status
  sync (unchanged from Report specs).

### Post-run trajectory (roadmap extension beyond day 4)

Recorded now so the final report can grade against it:

1. **Promotion review:** cleanest candidates so far are Q4/Q5
   (unconditional, standard axioms), the zero-cut RP stack
   (`ReflectionCore` -> `WilsonReflectionPositivity` chain incl. the N3
   counterexample + resolution pair), `HermitianFromRealQuadraticForm`
   (Mathlib-gap lemma, PR-to-Mathlib candidate), and the T11 lasso
   identity (`[propext, Quot.sound]`).
2. **Paper unit 1 (YM1 finite-G exact area law):** end-to-end once the
   Q11 ensemble bridge lands; outline already maintained under
   `AgentTasks/paper-units/`.
3. **Paper unit 2 (finite RP stack):** publishable once M1 closes; the
   zero-cut + counterexample + redesign story is already a coherent
   honest-methods narrative even if M1 stays open.
4. **Next run (if mountains remain):** mission = M1 -> M3 -> KP-driven
   clustering, in that order, single-flagship-per-agent shape; the
   Penrose/partial-sum pair as standing Aristotle packages if unclosed.

### Operational notes (day-2+)

- The loop model for the "claude" agent may change between cycles (it
  has run as Sonnet 5, Opus 4.8, and Fable 5); the agent IDENTITY in the
  ledger stays `claude`, and the `FABLE_CALL_PROTOCOL.md` budget governs
  WRAPPER calls only - the loop model itself consuming a Fable-class
  brain does not spend that budget.
- Harvest-first remains binding; five jobs were running at this update
  (`e4458430`, `8271a64b`, `3e483972`, `ba26fe81`, `acedaea2`) - all five
  harvests are day-2 work before new submissions in their lanes.
- The saturation rule and >=4/8 slot check remain binding as written.

## The road to full QCD mass formalism (user-directed aggressive extension)

**Authority and honesty header.** The user directed (end of day 1):
"Be extremely aggressive, including aiming to get to full QCD mass
formalism." This section is the staged ladder from the current
finite-group Yang-Mills stack to a kernel-checked LATTICE QCD mass
formalism - SU(3) gauge fields, Wilson quarks, and hadron masses as
spectral data of a positive transfer operator in quantum-number
sectors. Aggression lives in the REACH and the schedule; honesty lives
in the CLAIMS: every rung is a finite-lattice, fixed-coupling,
fixed-volume statement. The continuum limit is NOT on this ladder
(QMF8 records it as the named open frontier - that is the Clay-level
mathematics this program does not pretend to solve). "QCD mass" on
this ladder ALWAYS means: spectral gap / spectral data of the lattice
transfer operator in a named sector, per the section 13.2 mass
taxonomy, elevated from prose discipline to theorem-level named
definitions. F-YM-CONFLATE remains constitution-grade.

**Why this is reachable from here (the compounding asset).** Nearly
everything built in this run is deliberately group-generic
(`[Group G]`, mirror coordinates, RP-KER, block OS/GNS, sector
projectors) or gauge-content-free (KP machinery, clustering bridges).
The three mountains M1-M3 are not a detour from QCD - they ARE the
pure-gauge half of QCD. What QCD adds is exactly four ingredients:
compact groups (Haar in place of Fintype sums), Grassmann variables
(Berezin integration = finite exterior-algebra identity), the Wilson
fermion action (with its doubling/regulator discipline - which this
repo's NullEdge program has ALREADY built native expertise in), and
quantum-number sectors rich enough to name hadrons (generalizing Q3's
FluxSector machinery, also already built). Existing repo seeds:
`BanksCasherShadow.lean` (chiral/spectral bridge), the Clifford/Spinor
trees under `PhysicsSM/`, the doubler-determinant discipline in
`docs/NULLSTRAND.md`, and T12's already-source-checked
Menotti-Pelissetto 1987 (Wilson-FERMION reflection positivity - the
exact paper QMF5 formalizes against).

### The QMF ladder (QCD Mass Formalism, rungs QMF1-QMF8)

- **QMF1 - compact-group substrate.** Generalize the ensemble layer
  (`LatticeEnsemble`/`PlaquetteEnsemble` and the RP mirror stack's
  Fintype-bound parts) from finite sums to compact-group Haar
  integrals. Deliverables: (a) a Mathlib/PhysLean capability survey
  (DONE early, day 1 end - see `qmf1a:capability-survey` in
  DISCUSSION: Haar PRESENT, `Matrix.specialUnitaryGroup` PRESENT,
  ExteriorAlgebra PRESENT, Peter-Weyl ABSENT, PhysLean not a
  dependency); (b) a `CompactEnsemble` statement layer whose
  finite-group specialization DEFINITIONALLY recovers the current
  stack (the convention-pin `rfl` pattern); (c) SU(2) as first
  target, SU(3) as the named goal. **Survey consequence - QMF1
  SPLITS:** QMF1-RP (Haar-only compact ensemble for RP/transfer;
  cheap; the critical path) vs QMF1-PW (Peter-Weyl / compact
  character orthogonality; expensive; gates ONLY the SU(N)
  character-expansion/KP port; deferred, candidate for a dedicated
  mega-package or Mathlib upstream contribution). The critical QCD
  path RP -> transfer -> fermions -> QMF7 does NOT block on
  Peter-Weyl at any rung.
- **QMF2 - compact-group RP + transfer.** Port RP-KER, the mirror
  convention, cut kernels, and the block OS/GNS stack to the Haar
  substrate. The M1 cut-bearing lattice construction ports unchanged
  (it is geometry, not group theory). Exit criterion: `reflectionForm
  _nonneg`-class theorems for SU(2) Wilson weight on the cut-bearing
  lattice.
- **QMF3 - Grassmann/Berezin finite formalism.** Finite-dimensional
  exterior-algebra integration (Berezin), the Matthews-Salam identity
  (fermionic Gaussian integral = determinant) as a FINITE IDENTITY over
  a finite lattice - fully kernel-checkable, no analysis. Mathlib's
  `ExteriorAlgebra` is the substrate candidate; falsity-test against
  tiny explicit cases (1-2 modes) in the oracle first. This rung is
  INDEPENDENT of QMF1/QMF2 and can start any time as a statement
  freeze + Aristotle package.
- **QMF4 - Wilson fermion action + doubling audit.** The Wilson-Dirac
  operator on the finite lattice (repo Clifford/Spinor conventions,
  gamma-matrix signature documented per AGENTS physics-conventions
  rules), gamma5-hermiticity, and det-positivity for paired flavors at
  zero chemical potential. The doubling story is formalized at
  DETERMINANT level per the standing NullEdge discipline
  (retardedness alone is not a no-doubling proof). Stretch: a finite
  Nielsen-Ninomiya shadow. Honest negative pre-registered: the
  one-flavor sign problem is RECORDED, not worked around.
- **QMF5 - fermionic reflection positivity.** Extend the RP stack to
  Grassmann-valued positive-side algebras: Osterwalder-Seiler 1978
  Sec. 4-5 and Menotti-Pelissetto 1987 (already bibliographically
  verified by T12) are the formalization targets. This is the genuine
  QCD analogue of M1 and reuses its cut geometry.
- **QMF6 - QCD transfer + quantum-number sectors.** The fermionic
  transfer operator on the QMF5 OS/GNS space; sector projectors for
  flavor, parity, charge conjugation, and (for pure-gauge content)
  center flux - the direct generalization of Q3's
  `FluxSector`/`CenterFluxSector` machinery, which was built
  abstractly enough to receive this.
- **QMF7 - hadron mass formalism (the endpoint statement).** A
  `QCDMassFormalism` module proving, at fixed coupling and volume:
  hadron masses EXIST as sector-restricted spectral gaps of the
  positive self-adjoint transfer operator; meson/baryon interpolating
  operators live in the positive-side algebra; the mass taxonomy is
  theorem-level (named defs: `quarkMassParameter` vs
  `hadronSpectralMass` vs `regulatorMass` - provably distinct
  quantities, F-YM-CONFLATE as mathematics instead of prose); finite
  Ward identities; the Banks-Casher finite form grown out of
  `BanksCasherShadow.lean`. THIS is "full QCD mass formalism" in the
  only sense a kernel can check today.
- **QMF8 - the named frontier (recorded, not promised).** Continuum
  limit, renormalization, Balaban-style multiscale: OUT of
  formalization scope, permanently on this ladder's kill list. Any
  drift of QMF7 claim language toward continuum masses is a
  constitution-grade violation. The final report grades the ladder
  against lattice statements only.

### Aggressive schedule overlay (current run, days 2-4)

The mountains keep priority; QMF work rides saturation time and the
statement-layer lanes:

- **Day 2:** M1-M3 as scheduled. Saturation lane: QMF1(a) capability
  survey (lean-explore over Mathlib+PhysLean: Haar, Peter-Weyl,
  SpecialUnitaryGroup, ExteriorAlgebra inventory - one DISCUSSION post)
  and QMF3 statement freeze submitted to Aristotle as a
  statement-design job (Berezin/Matthews-Salam on 1-4 modes, oracle
  fixture first).
- **Day 3:** mandated grand-strategy audit NOW ALSO adjudicates QMF
  sequencing (explicit prompt question: what is the cheapest sound
  path from the M1 cut geometry to QMF5 fermionic RP?). QMF1(b)
  `CompactEnsemble` statement layer if the survey supports it; QMF4
  Wilson-Dirac statement file (definitions + gamma5-hermiticity
  statement, no proofs required yet).
- **Day 4:** QMF7 STATEMENT file - the crown deliverable of the
  aggressive extension this run: the sector-spectral hadron-mass
  definitions with the taxonomy as named defs, every hypothesis a
  frozen named lemma (Q9-doorstep style). `FINAL_REPORT.md` grades
  M1-M3 AND the QMF statement layer, and hands the next run its
  mission.
- **Program-doc sync:** the QMF ladder gets written into
  `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` as a new section
  (15), BUT only after Codex cross-review of this plan section (it is
  a claim-language document; protocol applies). Target: day 2.

### Next-run mission (superseding the earlier post-run sketch)

Whatever M-mountains remain + QMF1-QMF5 execution as the spine, QMF6/7
proofs as the flagship, with the same two-agent + Aristotle
architecture. The promotion review and paper units from the earlier
post-run sketch stand unchanged; paper unit 3 (Berezin/Matthews-Salam
finite formalism, standalone Mathlib-facing) joins the list once QMF3
closes - it is publishable independent of all gauge content.

## The null-edge mass unification overlay (T-NE, user-directed)

**Authority.** The user directed (day 3): find out whether a CONSISTENT
story describes ALL mass in terms of null edges - including QCD
confinement mass - and outline what is achievable. The full outline,
thesis, pillars table, and kill list live in
`NULL_EDGE_MASS_UNIFICATION.md` (this directory); this section is the
scheduling overlay only.

**Thesis (mechanism grade, one line).** "No primitive mass": every
taxonomy-row mass is a relational obstruction to primitively-null
transport - turn (T: fermion/Higgs), closure (C: gauge/Elitzur/gap), or
aperture (A: composite/hadron), with the keystone kinematic identity
`M^2 = sum of pairwise null angles` unifying them and Gate I1's
`det P = m^2` as its two-body germ. F-YM-CONFLATE unaffected: shared
mechanism SHAPE, separate theorems per row.

**The NE-U ladder** (details + kill conditions in the outline doc):

- **NE-U1 - aperture keystone** (`compositeMassSq_eq_zero_iff_
  collinear` + Plucker bridge): Mathlib-only, IMMEDIATE, the spine.
- **NE-U2 - mass = chirality-mixing at Wilson-Dirac grade**
  (`chiral_iff_massless_naive`; physical-vs-regulator mass as
  mathematics): rides the completed QMF4 stack, IMMEDIATE.
- **NE-U3 - closure pillar consolidation** (Elitzur landed by codex;
  named corollary + mechanism docstrings): CHEAP.
- **NE-U4 - gap as closure cost** (sector-restricted statement shape
  for the M3 transfer gap): rides M1-M3, statement discipline only.
- **NE-U5 - "mass without mass" toy** (zero quark mass parameter,
  positive sector gap, one small explicit model): THE CROWN of the
  unification; Aristotle design job first; needs QMF5/QMF6 statement
  shapes, not the mountains.
- **NE-U6 - electroweak/gauge-Higgs rung** (Fradkin-Shenker anchor,
  gauge-invariant composite W): NEXT-RUN; bibliographic verification
  required first.

**Overnight/day-3+ schedule adjustment (mountains keep priority;
NE-U rides the claude lane and saturation time):**

- **Tonight (day 3 night):** (i) NE-U1 statement freeze + oracle pin +
  focused Aristotle package (Mathlib-only; the reverse-Cauchy-Schwarz
  null lemma is the one hard step); (ii) NE-U2 statement freeze on the
  QMF4 stack - attempt direct proof first (the gamma5-parity split is
  near the already-proved gamma5-hermiticity), Aristotle on stall;
  (iii) the pending QMF5 fermionic-RP strategy job gains one explicit
  question: what sector definitions does NE-U5's toy need from
  QMF5/QMF6, and what is the smallest kernel-tractable
  "mass without mass" model?
- **Day 3 audit:** the mandated grand-strategy audit now adjudicates
  THREE threads (M-mountains, QMF, NE-U) and must rank NE-U5 model
  candidates.
- **Day 4:** NE-U1/U2 harvests integrated + independently verified;
  NE-U5 design harvested into a statement file if returned;
  `FINAL_REPORT.md` gains a null-edge-unification section grading
  against the outline doc's CAN/CANNOT lists.
