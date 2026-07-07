# Fable-5 call protocol (every 2 hours, placed by Claude)

Fable-5 has superhuman synthesis and problem-solving ability. It is not a checker
you consult to be safe - it is the most capable theorist and strategist on the
program, and the run's single greatest force-multiplier. **Use it to ADVANCE the
program, not merely to validate it.** Its highest-value outputs are: cracking the
hardest open problems, deep cross-lane synthesis and new mathematics, and advanced
strategic direction. Red-teaming is one mode it is also excellent at - use it when
called for - but a run that only asks Fable "is this right?" is wasting the best
instrument it has.

**Be unbelievably ambitious.** Hand Fable the hardest thing on the board - the two
standing cruxes, the full Weitzenbock assembly, the whole unification theorem, a
crux everyone thinks is out of reach - and ask it to actually solve or advance it.
Do not sandbag it with only safe, incremental, already-scoped asks. Optimism is the
policy: assume Fable can crack problems the executors cannot, and give it those
problems. The failure mode to avoid is not "asked too much" - it is "asked too
little."

A 2-hourly call is 24 calls across the run. **The bar: every call either advances
the program (a new decomposition, a proof strategy, a synthesis, a breakthrough) or
forces a decision that changes what we do next.** A call that only reports status,
or only asks for a rubber-stamp, is a wasted call.

## 1. Mechanics

```bash
python Scripts/autonomous_loop/send_claude_review.py \
  --model claude-fable-5 \
  --packet AgentTasks/twoday-carrier-run-2026-07-07/fable-calls/call-NN-packet.md \
  --source-file <verbatim .lean file(s) in play>   # repeatable, use liberally \
  --slug fable-call-NN \
  --max-budget-usd 6.00 \
  --timeout-seconds 1800
```

- Wrapper: `Scripts/autonomous_loop/send_claude_review.py` with
  `--model claude-fable-5` (the flag exists; default is opus - do not forget it).
  The wrapper gives Fable read-only repo + literature + graph + Mathlib/PhysLean
  search; it cannot write. First call of the run: do a `--dry-run` once to confirm
  the `claude-fable-5` model id is accepted before relying on it.
- **Budget is not the constraint (user-set: unconstrained).** Default `6.00`;
  for a deep CRACK or SYNTHESIS call, go higher (`10.00`+) and raise the timeout -
  a single breakthrough is worth more than a day of fleet spend. Never truncate an
  ambitious ask to save budget.
- Every call auto-logs to `AgentTasks/model-calls/claude/`. Also write a short
  digest + the DECISION/ADVANCE TAKEN to `LEDGER.md` (`[FABLE-CALL NN]`) so Codex
  sees the outcome without reading the full log.
- Keep each packet in `fable-calls/` - numbered, committed. STANDALONE: Fable is
  blind to the chat; assume it remembers nothing since `FABLE_HELP.md` /
  `FABLE_STEER.md` (cite by path - it has repo tools - but quote the load-bearing
  parts inline).
- **Verbatim source rule:** whenever Fable is reasoning about a Lean statement
  (to crack it, extend it, ratify it, or diagnose it), the exact source goes in via
  `--source-file` - a paraphrase hides the very structure Fable needs to work with.

## 2. The packet contract (built for ambition)

Every packet has these sections. The contract now leads with the THRUST, not a
narrow question - a CRACK/SYNTHESIS thrust is a full problem to solve, not a
yes/no.

1. **CONTEXT DELTA** (<= 20 lines): what landed (with axiom footprint), what
   failed and the insight from failing, fleet + thread-board state. Only what bears
   on the thrust.
2. **THE PRIMARY THRUST** (exactly one, but it can be huge): the hard problem to
   crack, the synthesis to produce, or the decision to force. Give Fable the FULL
   problem: the goal, every relevant landed result, every prior attempt and why it
   failed, the relevant prior art (cite graph keys), and the exact obstruction.
   Then ask it, ambitiously, to produce the advance - a new decomposition, the key
   lemma, a proof strategy or full sketch, a mechanism, a counterexample, or a
   reframe that dissolves the obstruction. Explicitly INVITE it to introduce new
   definitions, new intermediate theorems, and new connections - it is not confined
   to the statements we already wrote.
3. **SECONDARY THRUSTS** (<= 2): further hard asks or decisions, lower stakes.
4. **THE QUEUE**: current `FABLE_QUEUE.md` items, one line each - Fable advances
   what it can, defers the rest explicitly.
5. **OUR CURRENT PLAN / DEFAULT**: what we will do absent new guidance - so Fable's
   answer either supercharges it, redirects it, or ratifies it. (For pure-decision
   calls this is the fork's default; for CRACK calls it is "here is our best
   current line of attack - beat it.")
6. **REQUESTED OUTPUT + GRADING**: ask for the advance first, reasoning second;
   grade every claim [ESTABLISHED] / [CONJECTURAL] / [CRUX]; when it proposes a
   proof strategy, ask for the decomposition into named lemmas with the one
   genuinely hard step isolated (so we can hand pieces to Aristotle). Its answers
   are then red-teamed like any other input (sec 6) - a Fable [CONJECTURAL] is a
   hypothesis until the kernel checks it, NOT a docstring fact.

Hard rules: every packet has a THRUST that advances or decides; do not re-ask what
`FABLE_STEER.md` already answers (re-read it first); Fable works at the level of
mathematics, strategy, and proof DESIGN - it hands us statements, decompositions,
strategies, and sketches, and Aristotle/the executors do the Lean syntax and the
kernel check. Never skip a scheduled call for lack of a safe question - there is
ALWAYS a hard problem to throw at it (sec 3, CRACK/SYNTHESIZE/STRATEGIZE).

## 3. Call types - lead with the offensive ones

**Primary (advance the program) - most calls should be one of these:**

- **CRACK** - hand Fable a hard open problem and ask for the breakthrough. The
  standing targets, in rough priority: the **closure statistical-positivity crux**
  (`<Q_C> >= 0` beyond leading order); the **Krein positivity-domain crux** (on
  which physical sector is `D^#D` a genuine nonneg form - the thing that turns the
  decomposition into a mass); the **discrete Weitzenbock assembly** itself (the
  cleanest 2-complex + dressing that makes `D^#D = Q_A+Q_C+Q_T+E` provable); the
  **Q_C identification**; the **KP crux** (`pairSum_le_expBound` via the Penrose
  scheme); **higher-d Nielsen-Ninomiya** (discrete Poincare-Hopf); and, when ripe,
  the **whole unification** (can the four identification lemmas + irreducibility +
  relative exhaustiveness be assembled into one theorem, and what is the sharpest
  statement of it?). Give it everything tried; ask it to solve it or to produce the
  decomposition that makes it solvable.
- **SYNTHESIZE** - deep cross-lane synthesis and new mathematics. What unifies the
  landed corpus at a level we have not seen? What established mathematics (index
  theory, NCG/spectral action, K-theory, twistor/celestial, positive geometry)
  should we be standing on, with the precise bridge? What new theorem does the
  structure predict that we have not thought to state? Ask for connections and
  new results, not summaries.
- **STRATEGIZE** - advanced program strategy. Given the whole board, what is the
  most ambitious achievable target for this run and the shortest honest path to it?
  What are we over/under-investing in? What should we be ATTEMPTING that we are not
  daring to? Pair this with the Aristotle grand-strategy jobs and where they
  disagree, let Fable adjudicate.

**Supporting (use when called for):**

- **RATIFY** - before spending real Aristotle budget on a Move-1/2 flagship, send
  the exact statement and ask: is this the right statement, and is there a stronger
  one we should be proving instead? (Ambition even here: ask Fable to sharpen the
  target upward, not just bless it.) Cheap and high-value, but not the headline.
- **UNBLOCK / RED-TEAM / AUDIT** - a crux that resisted the executors + Aristotle;
  or an adversarial semantic audit of landed flagships (vacuity / hollowness /
  docstring-outruns-kernel / known-false shape). Fable is the best red-teamer on the
  program at the level of "does the prose outrun the kernel" - use it there, and
  fold an audit into the T+12/T+36/T+46 sweeps regardless. But red-team is a MODE,
  not the default framing of a call.

Most calls should COMBINE: e.g. ratify a brick statement (30 seconds of the packet)
AND spend the bulk of the call asking Fable to crack the next crux or extend the
synthesis. Never send a call that is only a rubber-stamp.

## 4. Suggested schedule (call N ~ T+2N; flex to the queue; ambition every time)

Every call carries a CRACK/SYNTHESIZE/STRATEGIZE thrust even when it also ratifies.
RATIFY items ride along; they never consume a whole call.

| Call | ~T | Primary thrust (+ ride-along) |
|---|---|---|
| 01 | T+2 | STRATEGIZE opening: most ambitious achievable target + path (+ RATIFY Move-1 bricks, FORK OS1 route) |
| 02 | T+4 | CRACK: the discrete Weitzenbock assembly - the cleanest provable form (+ RATIFY Q_A/Q_T stmts) |
| 03 | T+6 | CRACK: the Q_C identification + the Krein positivity domain (+ RATIFY QC leading-order stmt) |
| 04 | T+8 | SYNTHESIZE: A=T bridge -> full spinor-helicity/checkerboard structure; new theorems it predicts |
| 05 | T+10 | CRACK: closure statistical-positivity crux (the beyond-leading `<Q_C>`) |
| 06 | T+12 | AUDIT midpoint scrub (all landed stmts verbatim) + STRATEGIZE reallocation |
| 07 | T+14 | CRACK: graded irreducibility + relative exhaustiveness as ONE theorem (+ RATIFY W2b/W2c) |
| 08 | T+16 | CRACK: KP crux via Penrose scheme, or higher-d N-N - whichever is riper |
| 09-11 | T+18..T+22 | queue-driven CRACK/UNBLOCK; RATIFY the capstone statement once W2 matures |
| 12 | T+24 | SYNTHESIZE day-1 verdict: does the carrier picture cohere + the sharpest unification statement |
| 13-17 | T+26..T+34 | day-2 CRACK/SYNTHESIZE mix: the whole unification theorem; the hardest surviving crux; new connections |
| 18 | T+36 | AUDIT consolidation sweep + STRATEGIZE the endgame |
| 19-22 | T+38..T+44 | CRACK the last open cruxes; SYNTHESIZE toward FINAL_REPORT's headline claim |
| 23 | T+46 | AUDIT freeze-window sweep (everything headed for FINAL_REPORT) |
| 24 | T+48 | SYNTHESIZE: final grading review + the most ambitious next-run program |

## 5. FABLE_QUEUE.md (the standing feed)

Both agents append hard problems, forks, suspected-false statements, and red flags
the MOMENT they occur:

```
- [QUEUE HH:MM agent] problem (one line); statement/file:line; tried; what kind of
  answer unblocks (crack / decomposition / decision / verdict-false / reference)
```

Claude triages into each call: the primary thrust = the item that most advances the
critical path (usually a CRACK, not just a blocker). If the queue holds a
critical-path crux and the next call is > 1h away, place an early call - the
schedule is a floor. When the queue is thin, DO NOT downgrade to a rubber-stamp
call: pull the next hardest standing crux from sec 3 and throw it at Fable.

## 6. After every call

1. Extract the advances/decisions; post the `[FABLE-CALL NN]` ledger digest
   (what advanced + who acts on it).
2. Update `THREAD_BOARD.md`: a cracked crux opens new threads; a new decomposition
   rewrites a thread's route; a proposed theorem becomes a new thread with a
   RATIFY-then-prove path.
3. **Red-team Fable's output like any other input.** A proof strategy is a plan,
   not a proof; its [CONJECTURAL] claims are not docstring facts until the kernel
   agrees; run its proposed statements through the four-mode over-claim hunt before
   formalizing. Ambition on the way IN, discipline on the way OUT.
4. Turn the advance into fleet work immediately: a ratified/sharpened statement ->
   Aristotle proof job that same cycle; a decomposition -> one Aristotle job per
   isolated lemma; a synthesis -> new THREAD_BOARD entries + a lit round to ground
   the connections. An advance that does not become a job or a thread within the
   cycle is a dropped ball.
