# TWO-DAY CARRIER RUN (2026-07-07 -> 2026-07-09): master plan

Designed by Fable-5. Two co-equal executors - **Claude Opus 4.8** and **Codex 5.5** -
run autonomously for 48 hours, leveraging **Aristotle very heavily** (proof search,
adversarial audits, strategy jobs), doing **frequent literature work** against the
Neo4j graph (read AND write), with Claude placing a **high-value Fable-5 call every
3 hours** (see `FABLE_CALL_PROTOCOL.md`).

This plan is the single source of truth for the run. The agents' standing orders are
`GOAL_PROMPT_CLAUDE.md` and `GOAL_PROMPT_CODEX.md`. The work queue with per-thread
done-conditions is `THREAD_BOARD.md`. Coordination happens ONLY through `LEDGER.md`
(append-only) plus git commits.

## 0. Mission

Execute the Weitzenbock-carrier program (`AgentTasks/overnight-mass-run-2026-07-06/
FABLE_STEER.md`) to kernel-checked, honestly-graded completion of Moves 1-3:

- **Move 1 (Day 1, critical path):** the carrier `D = sum_e c(alpha_e) nabla_e + Phi`
  on a finite 2-complex and the **discrete Weitzenbock decomposition**
  `D^#D = Q_A + Q_C + Q_T + E`, with `E`'s vanishing hypotheses explicit.
- **Move 2 (Day 2, the goal in honest form):** the four **component-identification
  lemmas** (Q_A = aperture, Q_T = turn, Q_C <-> Z2 gap at strong-coupling leading
  order, E <-> the gravity/NSBB slot stated as interface), **graded irreducibility**
  (the upgraded `no_common_carrier`), and **relative exhaustiveness**.
- **Move 3 (both days, Codex lane):** the re-scoped C-gate - **strong-coupling SU(2)
  mass gap with explicit beta_0** (Osterwalder-Seiler 1978 mechanized), with the
  all-beta gap explicitly OPEN.

The prize at T+48h: `GrandMassCapstone`'s conjunction upgraded to an **identity** -
one carrier, four canonically-graded obstruction slots, each tied to its
independently-proved lane functional, all axiom-guarded.

## 1. Roles

- **Claude Opus 4.8** - executor. Lanes: **T (turn) + A (aperture) + the carrier
  algebra** (Clifford/Krein, Move 1, Move 2 identification for Q_A/Q_T, A=T bridge,
  B-lane commutant follow-through). Owns `CarrierAxiomGuard.lean` (new). Places the
  3-hourly Fable calls. Runs the odd-hour lit rounds.
- **Codex 5.5** - executor. Lanes: **C (closure) + gauge/YM + polymer/analysis**
  (Move 3 / Osterwalder-Seiler, Q_C-in-expectation identification, KP/Penrose crux,
  product-haar RP core). Owns `SlabAxiomGuard.lean`. Runs the even-hour lit rounds.
- **Aristotle** - the engine, run HOT. Target mix AT ALL TIMES (see
  `ARISTOTLE_PLAYBOOK.md`): **up to 12 simultaneous jobs** - ~8-10 proof/construction
  + 2-3 adversarial AUDIT jobs (fired after every 2-4 integrated proofs) + 1 STRATEGY
  job refreshed HOURLY. Harvest-first; stale-check before every submit; 2-hour rule.
  12 is a CEILING, not a quota - the saturation discipline (sec 5) still binds.
- **Fable-5** - conceptual driver, called every 3h by Claude with a decision-forcing
  packet (`FABLE_CALL_PROTOCOL.md`); also receives escalations via `FABLE_QUEUE.md`.
- **Shared lanes** B (octonion/spectral-triple) and V (E8): opportunistic, claim first.

## 2. The 48-hour arc

Times are relative to run start (T+0). Checkpoints are hard commitments; everything
else flexes around harvests.

### Day 1 (T+0 -> T+24): build the carrier, scaffold the gate
- **T+0 first cycle (both):** read your goal prompt + `THREAD_BOARD.md`; post standing
  lane claims to `LEDGER.md`; harvest the in-flight jobs (sm-weitzenbock-brick
  c6af1315, sm-color-commutant 1e9ac867, sm-product-haar ac751ecb); cross-review and
  integrate the sound ones; refill per playbook.
- **Claude day-1 thread order:** W1 (Move-1 Weitzenbock assembly, on the algebra brick)
  -> AT (A=T bridge) -> W2a prep (Q_A/Q_T identification statements) -> CC (commutant).
- **Codex day-1 thread order:** OS1 (Osterwalder-Seiler statement + character/polymer
  scaffold, standing on `CharacterExpansion` + `StrongCouplingAreaLaw`) -> QC
  (Q_C leading-order identification design) -> PH (product-haar harvest + RP-core
  integration) -> KP (Penrose scheme) as the analysis backstop.
- **T+12 MIDPOINT CHECK (both, written to ledger):** thread board scrub - every thread
  gets status PROVED/MODELED/OPEN + on-track/stalled; stalled threads escalate (sec 5).
- **T+24 MORNING_REPORT.md:** honest day-1 report in the run dir (template: the
  overnight run's `MORNING_REPORT.md`), including axiom-guard status and fleet stats.

### Day 2 (T+24 -> T+48): identification, irreducibility, consolidation, freeze
- **Claude:** W2a (Q_A/Q_T identification lemmas kernel-checked) -> W2b (graded
  irreducibility) -> W2c (relative exhaustiveness) -> fold into the carrier capstone
  (`CarrierCapstone.lean`, the AND->+ upgrade), all guarded.
- **Codex:** OS1 completion (explicit beta_0 gap theorem or the honest furthest rung +
  documented handoff) -> QC lemma kernel-checked (leading order only, honest scope) ->
  KP crux best-effort via the Penrose partition scheme.
- **T+36 CONSOLIDATION:** merge both guards' new flagships into the scorecard; run the
  full `lake build`; reconcile any cross-lane statement mismatches NOW, not at T+47.
- **T+45 FREEZE:** no new Aristotle submissions after T+45 (harvest-only window);
  final cross-review sweep; kill or park every RUNNING job by T+47 (2-hour rule).
- **T+48 FINAL_REPORT.md:** the honest final report - what is PROVED (with axiom
  footprints), what stays MODELED and exactly which hypothesis, what is OPEN, the
  Fable-call log summary, the lit-graph delta (papers added, keys), and the
  recommended next run.

## 3. Cadences (genuine, not performative - each changes state or logs "nothing to do")

| Cadence | Period | Owner | Content |
|---|---|---|---|
| Throughput cycle | ~20-30 min | both | harvest -> integrate -> cross-review -> refill -> commit |
| Literature round | **every 30 min** | **both, independently (scoped to own lanes)** | per `LIT_NEO4J_PROTOCOL.md`: chunks-search before formalizing; ingest new papers; cite keys in docstrings |
| Red-team cross-review | per integration (hourly floor) | the OTHER agent | hunt the 4 over-claim modes in each integration (see sec 4) |
| Aristotle AUDIT job | **after every 2-4 integrated proofs** (event-driven) | either | adversarial semantic audit of the most recent/riskiest landings (playbook sec 3) |
| Aristotle STRATEGY job | **hourly** | alternating each hour | strategic review of the stalled/riskiest thread (playbook sec 4) |
| **Fable call** | **every 3h** | **Claude** | per `FABLE_CALL_PROTOCOL.md`; queue-driven, decision-forcing |
| Consolidation | ~2h | either (claim it) | fold landed results into `HONEST_SCORECARD.md` + thread board scrub |
| Ledger heartbeat | every cycle | both | one HB line: what landed, what's in flight, what's next |

Pacing: background timers only (no foreground sleep, no polling loops). If a cycle
finds nothing to do, say so in the ledger and lengthen the timer - idle honesty over
busy-work commits.

## 4. Discipline (the spine - non-negotiable)

1. **Kernel = truth.** Grade every result PROVED / MODELED (explicit hypothesis, not
   derived) / OPEN, in the docstring AND the ledger. No trusted code with the
   forbidden tokens (see `AGENTS.md`); draft code may carry a documented
   `s o r r y` as a handoff, never as a success.
2. **Axiom guards.** Every new flagship gets a `#guard_msgs ... #print axioms` block
   pinned to `[propext, Classical.choice, Quot.sound]` or fewer - Claude's in
   `CarrierAxiomGuard.lean`, Codex's in `SlabAxiomGuard.lean`. Never both editing one
   guard file.
3. **Cross-review before "landed."** Integration by one agent -> `[REVIEW-REQ]` in the
   ledger -> the other agent hunts the four over-claim modes: (i) vacuity (quantifier
   order asserts nothing / unsatisfiable hypothesis), (ii) hollow telescoping (the
   load-bearing hypothesis unused), (iii) docstring outrunning the kernel,
   (iv) false-shape (re-proving a known-false form; check the verified negatives) ->
   `[REVIEW-OK]` or `[REVIEW-FLAG reason]`. A flagged result is downgraded or reverted,
   and the CATCH is logged as a win.
4. **Convention lock.** No silent changes to signs, bases, normalizations,
   parenthesization (octonions are nonassociative - compose linear maps only), or the
   null-edge operator architecture (`docs/NULLSTRAND.md`, `docs/CONVENTIONS.md`).
5. **Provenance.** Every module inspired by a paper cites the Neo4j paper key + the
   convention used, in the docstring.
6. **Commits:** small, frequent, prefix `twoday-carrier-202607:`, each agent commits
   its own lane, own co-author trailer. `pre-commit run` first; expect the CRLF abort
   on Aristotle-authored files (re-add, re-commit). Never `git add -A` blindly.

## 5. Escalation ladder (stalls are routed, never churned)

1. **Two failed attempts** on a lemma -> stop; write the handoff comment; submit an
   Aristotle proof job with the isolated statement.
2. **Aristotle fails it too** (or returns hollow) -> submit an Aristotle STRATEGY job
   (is the statement right? is there a counterexample?) AND add an entry to
   `FABLE_QUEUE.md`.
3. **Conceptual blocker / design fork / suspected-false statement** -> `FABLE_QUEUE.md`
   immediately; Claude folds it into the next 3-hourly call - or places an EARLY call
   if the critical path (Move 1/2) is blocked. Do not wait out a blocked critical path.
4. **Saturation signal** (a submitted job reproduces in-tree work; a lane has no
   genuinely-open finite target) -> STOP widening that lane; log the signal; move to
   the next thread on the board; raise at the next Fable call whether to re-scope.
5. **Red flag per AGENTS.md** (new axiom needed, convention mismatch, statement false)
   -> stop the thread, log `[RED-FLAG]`, queue for Fable, continue elsewhere.

## 6. Success criteria (what "astonishing" means, honestly)

- **Floor (must hit):** Move-1 kernel-checked and guarded; Q_A and Q_T identification
  lemmas landed; OS1 at least through the character-expansion gap statement with the
  honest remaining hypothesis explicit; >= 12 lit-graph additions with keys cited in
  landed modules; >= 12 Fable calls logged, each with a decision acted on; zero
  unreviewed integrations; FINAL_REPORT.md at the honest-scorecard bar.
- **Target:** full Move-2 package (identification + irreducibility + relative
  exhaustiveness) = the unification theorem in honest form; OS1 with explicit beta_0;
  the carrier capstone AND->+ upgrade committed.
- **Stretch:** KP crux via Penrose scheme; higher-d N-N discrete Stokes; the Spin(10)
  flag-stabilizer statement proved at the U(5) rung.
- **Anti-goals:** module count, fleet-slots-filled, re-derivations of landed results,
  any headline whose docstring outruns its kernel content.
