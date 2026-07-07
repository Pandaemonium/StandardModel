# Fable-5 call protocol (every 2 hours, placed by Claude)

Fable-5 is the run's conceptual driver: it produced the carrier verdict and the
Move 1-3 plan, and it is the only participant whose job is to think ABOVE the
kernel. A 2-hourly call is 24 calls across the run - treat each as a scarce,
expensive instrument. **The bar: every call must change what the run does next.**
A call that merely reports status, asks nothing decision-forcing, or arrives
without the source under judgment is a wasted call and a cadence failure.

## 1. Mechanics

```bash
python Scripts/autonomous_loop/send_claude_review.py \
  --model claude-fable-5 \
  --packet AgentTasks/twoday-carrier-run-2026-07-07/fable-calls/call-NN-packet.md \
  --source-file <verbatim .lean file under judgment>   # repeatable, use liberally \
  --slug fable-call-NN \
  --max-budget-usd 2.50 \
  --timeout-seconds 1200
```

- Wrapper: `Scripts/autonomous_loop/send_claude_review.py` with
  `--model claude-fable-5` (the flag exists; default is opus - do not forget it).
- Every call auto-logs to `AgentTasks/model-calls/claude/`. Also write a 5-line
  digest + the DECISION TAKEN to `LEDGER.md` (`[FABLE-CALL NN]` entry) so Codex
  sees the outcome without reading the full log.
- Keep each packet in `fable-calls/` (this run dir) - numbered, committed. The
  packet must be STANDALONE: Fable is blind to the chat; assume it remembers
  nothing since `FABLE_HELP.md`/`FABLE_STEER.md` (which you may cite by path since
  it has repo tools - but quote the load-bearing parts inline anyway).
- Budget generously (`--max-budget-usd 2.50`+): a decisive answer to one crux is
  worth more than the whole day's fleet spend.
- **Verbatim source rule:** if the call asks Fable to judge ANY Lean statement
  (ratify a target, diagnose a mismatch, assess a proof shape), the exact source
  goes in via `--source-file` - a paraphrase cannot expose a semantic mismatch,
  which is the judgment's whole point.

## 2. What makes a call high-value (the packet contract)

Every packet has exactly these six sections:

1. **CONTEXT DELTA** (<= 15 lines): what changed since the last call - landed
   (with axiom footprint), failed (with the error/insight), fleet state. Not a
   diary; only what bears on the questions.
2. **THE PRIMARY QUESTION** (exactly one): decision-forcing, answerable with the
   packet's contents, phrased so the answer is an instruction. Good: "Here are the
   two candidate Lean statements for the Q_C identification [verbatim]; A is
   provable this run but weaker, B is the honest target but needs X - which do we
   formalize, or state the third option?" Bad: "Any thoughts on Q_C?"
3. **SECONDARY QUESTIONS** (<= 2): same standard, lower stakes.
4. **THE QUEUE**: current `FABLE_QUEUE.md` items with one-line context each. Fable
   answers what it can cheaply, defers the rest explicitly.
5. **WHAT WE WILL DO IF YOU DON'T ANSWER**: your default plan. This forces the
   call to be a real fork: Fable either ratifies the default or redirects - both
   outcomes are actions. Never omit this.
6. **REQUESTED GRADING**: remind Fable to grade every claim in its answer
   [ESTABLISHED] / [CONJECTURAL] / [CRUX], per its own convention. Its answers get
   red-teamed like any other input: a Fable suggestion is a hypothesis until the
   kernel checks it.

Hard rules: no packet without a PRIMARY QUESTION; no question already answered in
`FABLE_STEER.md` (re-read it first - re-asking is a wasted call); no asking Fable
to do Lean syntax work (that is Aristotle's job; Fable gets STATEMENTS and
DESIGNS); if the 2h mark arrives and the queue is empty and no fork is live,
use the call type "audit" below rather than skipping - but say honestly in the
packet that it is a scheduled audit, not an escalation.

## 3. Call types (plan the day around these)

- **RATIFY** (highest frequency early): here is the exact Lean statement we are
  about to spend Aristotle budget proving - is it the right statement? Semantic
  drift caught BEFORE proof spend is the single cheapest error-correction in the
  loop. Move-1 brick statements, the Q_A/Q_T/Q_C identification lemmas, and the
  OS1 gap statement each get ratified before their first proof job.
- **FORK**: two concrete routes, the tradeoff, our default, decide. (Pre-queued
  for call 1: OS1 route - polymer/character vs Shen-Zhu-Zhu; Codex prepares the
  comparison.)
- **UNBLOCK**: a crux resisted two attempts + an Aristotle strategy job; here is
  the exact failure point and everything tried; give a new decomposition or
  declare it not-this-run.
- **AUDIT** (scheduled fallback; also every ~12h regardless): here is the guard
  status + the last N landed statements verbatim; hunt semantic drift, vacuity,
  convention mismatch, over-claim in the PROSE (Fable is the only reviewer who
  reliably catches "docstring outruns kernel" at the program level).
- **SYNTHESIS** (~T+24 and ~T+42): given everything landed, does the carrier
  picture still cohere? What should FINAL_REPORT claim, at what grade? What is
  the next run's opening move?

## 4. Suggested schedule (call N ~ T+2N; flex to the queue; never skip, may move +/-1h)

| Call | ~T | Default type/theme |
|---|---|---|
| 01 | T+2 | RATIFY Move-1 brick statements + FORK OS1 route (Codex packet) |
| 02 | T+4 | RATIFY Q_A/Q_T identification statements (W2a prep) |
| 03 | T+6 | RATIFY QC leading-order statement + FORK brick-2 2-complex design |
| 04-05 | T+8, T+10 | UNBLOCK (Move-1 assembly is usually mid-fight here) / queue-driven |
| 06 | T+12 | AUDIT: midpoint scrub - all landed statements verbatim |
| 07 | T+14 | RATIFY W2b/W2c statements (irreducibility + relative exhaustiveness) |
| 08-11 | T+16..T+22 | queue-driven; RATIFY the capstone statement once W2 matures |
| 12 | T+24 | SYNTHESIS: day-1 verdict + day-2 marching-order adjustments |
| 13-17 | T+26..T+34 | day-2 mix: RATIFY as threads mature, UNBLOCK as needed |
| 18 | T+36 | AUDIT: fold into the T+36 consolidation (all landed statements verbatim) |
| 19-22 | T+38..T+44 | day-2 mix / UNBLOCK / RATIFY late bricks |
| 23 | T+46 | AUDIT: freeze-window sweep of everything headed for FINAL_REPORT |
| 24 | T+48 | SYNTHESIS: final grading review of FINAL_REPORT claims + next-run design |

At 24 calls the RATIFY-before-proof-spend rule is cheap to honor: no Move-1/2
flagship statement should reach an Aristotle proof job un-ratified.

## 5. FABLE_QUEUE.md (the standing escalation channel)

Both agents append conceptual blockers/forks/red-flags the MOMENT they occur:

```
- [QUEUE HH:MM agent] one-line problem; file:line or statement; what was tried;
  what kind of answer unblocks (decision / decomposition / verdict-false / reference)
```

Claude triages the queue into each call (primary question = the item blocking the
most critical thread). Items answered are marked `[ANSWERED call-NN]` with the
one-line decision. If the queue holds a critical-path blocker and the next
scheduled call is > 1h away, place an early call - the schedule is a floor, not
a ceiling.

## 6. After every call

1. Extract the decisions; post the `[FABLE-CALL NN]` ledger digest (decision +
   who acts).
2. Update `THREAD_BOARD.md` if a thread's route or done-condition changed.
3. Red-team Fable's answer exactly like an Aristotle deliverable: statements it
   proposes get the same four-mode over-claim hunt before formalization; its
   [CONJECTURAL] items do NOT get promoted to docstring facts.
4. If the call ratified a statement, submit the proof job within the same cycle -
   ratification has a shelf life; the context that made it sharp goes stale.
