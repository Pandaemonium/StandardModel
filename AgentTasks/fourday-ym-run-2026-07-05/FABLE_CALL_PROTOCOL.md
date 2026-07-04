# Fable call protocol (four-day run): one Claude Fable 5 call per 2 hours

Claude Fable 5 is the strongest reasoning model available to this run -
and the most expensive. The 2-hour cadence allows up to ~12 calls/day;
the target usage is 4-8/day. **An unused slot costs nothing; a wasted
call costs a slot that a stuck flagship lane will want later.** This file
is the discipline that keeps the calls high-value. Sonnet 5 owns the
budget and executes all calls; Codex requests calls by adding entries to
the queue in `FABLE_CALLS.md`.

## The ambition mandate (read first; binding)

Fable 5 is EXTRAORDINARILY capable - it designed RP-KER (reducing all of
RP-LINK to a kernel-PSD check) and the definitional-interface pattern
(which closed the general 2D coordinatization in 16 minutes) in single
sittings. The most common way to waste a call is NOT asking a bad
question - it is asking a question two sizes too small. Therefore:

- **Every call's primary deliverable is a SUPER-STRETCH ask** - pitched
  well beyond what seems realistically possible for one call. Do not ask
  for an opinion when you can ask for the artifact; do not ask for the
  artifact when you can ask for the whole lane. Calibration examples:
  - not "is this statement true?" but "prove or refute it; if true,
    return the complete formalization-grade proof plan with every lemma
    stated in Lean syntax; if false, the explicit counterexample and the
    corrected strongest statement";
  - not "review this statement file before freezing" but "review it,
    then redesign the entire lane's statement stack so the hard theorem
    becomes a corollary of an abstraction we have not thought of, and
    return the draft module";
  - not "we are stuck on this goal" but "dissolve this problem: return
    the abstraction, the full Lean skeleton with the hard content
    isolated to one named lemma, and the Aristotle package design for
    that lemma";
  - not "audit the board" but "audit the board, then produce the
    complete lemma DAG from where we are to the YM4 finite gap, with
    each edge labeled provable-now / needs-design / genuinely-open."
- **Graceful degradation, not sandbagging.** State the stretch ask AND
  an explicit fallback ("if the full redesign is not achievable in this
  call, return the three highest-leverage partial results in priority
  order"). A partial answer to a maximal ask beats a complete answer to
  a timid one - the timid ask forecloses the upside.
- **The verification bar never moves.** Stretch asks raise what we
  request, never what we accept unverified: everything returned is still
  a lead until kernel-checked, small-case-verified, or oracle-pinned.
  Budget accordingly: stretch calls default to `--max-budget-usd 15`.

## What Fable is FOR (call taxonomy, ranked by expected value)

Fable's differential strength over Sonnet/Codex is deep semantic and
strategic judgment - statement design, falsity detection, abstraction
design, conflation catching. It is NOT a faster Sonnet and NOT a proof
engine (Aristotle is the proof engine; the kernel is the verifier).

- **A. Pre-freeze statement design review** (the highest-value call in
  the run). Before freezing the Q2 (transfer space), Q3 (flux sector),
  or Q6 (KP conclusion) statement files, and before any Aristotle
  package whose statement is NOT verbatim from a freeze document. A
  wrong frozen statement wastes days; this is exactly the class of error
  Fable catches (the mirror-coordinate/antilinearity convention in
  RP-KER, the flux-vs-glueball distinction, the v1 fusion `|G|` bug
  class). Ask for: the error, the counterexample, or the strongest
  defensible version.
- **B. Falsity/sanity analysis of a candidate theorem.** "Here is the
  statement and the intended reading; evaluate it on Z2/Z3/S3 by hand;
  construct a counterexample or certify with reasons." Cheap for Fable,
  brutal to get wrong downstream.
- **C. Unblocking a stuck lane** (trigger: >= 2 cycles without a
  verified delta on a claimed task). Present the exact failing goal,
  what was tried, and ask for the REDESIGN that dissolves the problem -
  the RP-KER pattern (reduce a structure problem to a kernel-PSD check)
  and the definitional-interface pattern (make the interface equation
  `rfl`, leaving only bijectivity) are the exemplars of what to ask for.
- **D. Adjudicating a partner disagreement** that is conceptual rather
  than provable (replaces the Aristotle tiebreak when the question is
  "which formulation is right," not "is this provable").
- **E. Daily strategy review** (max 1/day, at day start). Board + report
  audit: resequencing, risk the agents are not seeing, which shocking
  tier is actually reachable. Skip it if the board is obviously healthy.
- **F. Semantic red-team of an integrated result.** The kernel checked
  the proof, not the meaning. For flagship results (Q1 RP-LINK, Q2
  transfer space), one call: "here is the kernel-checked statement
  verbatim and here is the claim language we intend; do they match; what
  would demote the claim."

**Anti-triggers (never spend a call on these):** Lean syntax or
elaboration errors; Mathlib API lookup (grep the pinned source); build
failures; plumbing; anything an oracle fixture or a 10-minute local
experiment settles; reviewing whether a proof is correct (the kernel did
that); formatting/hygiene; anything already answered in PREP_NOTES.

## Slot discipline

- Minimum 2 hours between call INVOCATIONS (wall clock), enforced by
  checking the last timestamp in `FABLE_CALLS.md` before every call.
- Two soft-scheduled anchors: the day-start strategy review (taxonomy E,
  skippable) and at most one pre-freeze review (A) per day when a freeze
  is pending. Everything else is triggered, not scheduled.
- If nothing in the queue meets the taxonomy bar when a slot opens: DO
  NOT CALL. Post `fable-slot-skipped <reason>` in the heartbeat log and
  move on.
- Priority when the queue is contended: A > C(flagship lane) > B > D >
  F > C(other lanes) > E.

## Batching without diluting

Each call has exactly ONE primary deliverable plus at most two piggyback
questions, and piggybacks must be answerable from the same context the
primary already requires (no context-switching inside a call). Accumulate
candidates in the `## Queue` section of `FABLE_CALLS.md` between slots;
when a slot opens, take the highest-priority primary and sweep compatible
piggybacks.

## Mechanics (binding)

All calls go through the repo wrapper - never a raw API call:

```text
python Scripts/autonomous_loop/send_claude_review.py \
  --model claude-fable-5 \
  --slug fable-<taxonomy-letter>-<short-id> \
  --prompt-file <packet.md> \
  --source-file <verbatim Lean file under review> [repeatable] \
  --max-budget-usd 10
```

- The wrapper logs full prompt + response under
  `AgentTasks/model-calls/claude/` automatically; never log API keys.
- Default mode gives Fable read/search tools and read-only MCP - USE
  THAT: point it at entry files and let it read, instead of pasting the
  whole repo into the prompt. But every declaration whose SEMANTICS are
  under review still goes in verbatim via `--source-file` (a paraphrase
  cannot expose a semantic mismatch - standing repo rule).
- Budget guidance: `--max-budget-usd 15` for stretch calls (the
  default per the ambition mandate), `5` for self-contained falsity
  checks (B) and adjudications (D). If a call hits budget mid-review,
  the log will show it - re-scope, do not immediately re-call.
- Prompts are STANDALONE: Fable is blind to this chat and to the run's
  history. Include: one-paragraph program context; current gate/queue
  status for the question at hand; the exact Lean statements verbatim;
  the INTENDED READING in prose, stated separately; conventions that
  bind (C-1..C-8 pointers, RP mirror-coordinate convention, fusion
  argument order); numbered questions; success criteria; required output
  format. State the guardrails: ASCII output, spaced escape-hatch tokens
  in prose, explicit claim labels, F-YM-CONFLATE distinctions.

## The packet template

```markdown
# Fable call: <slug> (taxonomy <A-F>)

## Context (60 seconds)
<program one-liner; which queue item; what is already kernel-checked;
what decision this call gates>

## Verbatim material
<Lean statements/definitions under review - also attached via
--source-file; oracle fixtures if relevant>

## Intended reading
<what we BELIEVE the statement says, in prose - kept separate so a
mismatch is visible>

## Questions (numbered, falsifiable)
1. <primary deliverable - the SUPER-STRETCH ask per the ambition
   mandate: request the complete artifact (full redesign, full proof
   plan in Lean syntax, full lemma DAG, explicit counterexample), phrased
   so a wrong answer is checkable>
2. <explicit fallback: "if 1 is not fully achievable in this call, the
   three highest-leverage partial results, in priority order">
3-4. <piggybacks, same context only>

## Output format
<markdown sections wanted; decision + rationale + risks + what would
change your answer; Lean code blocks ready to paste into draft modules>

## Guardrails
ASCII; spaced tokens for s_o_r_r_y-class words (write them spaced);
claim labels (finite identity / asymptotic / reconstruction /
consistency / prediction); do not conflate mass gap / Wilson area law /
entanglement area law; lattice results are never "the prize".
```

## Post-call obligations (all three, every call)

1. Append a row to the `## Call log` table in `FABLE_CALLS.md`:
   timestamp, slug, taxonomy, primary ask, verdict in <= 15 words,
   action taken, log-file name.
2. Every Fable recommendation gets one of: ACTED (with commit/thread
   pointer), PARKED (ledger, with reason), or REJECTED (with the
   mathematical reason, posted in `DISCUSSION.md`). No silent drops -
   and no silent adoptions either: a Fable design that changes a frozen
   statement still goes through the normal cross-review.
3. Treat answers as LEADS, not oracle truth. The kernel is the source of
   truth; any mathematical claim Fable makes that a lane will lean on
   gets verified (small-case computation, oracle fixture, or
   kernel-checked lemma) before it carries weight. Record the
   verification alongside the ACTED entry.

## Failure modes to watch

- **Under-asking (the most expensive failure).** Asking Fable for a
  review when it could deliver the redesigned module; asking whether a
  route exists when it could return the route. If the packet's primary
  question could plausibly be answered by Sonnet with two more hours,
  the ask is too small - escalate it per the ambition mandate before
  sending.
- **Slot hoarding** (never calling): the flagship lanes (Q1/Q2/Q6) are
  exactly where Fable's statement-design review has proven value - the
  pre-freeze anchors exist so the run does not discover a wrong
  formulation on day 3.
- **Slot burning** (calling on anti-triggers): the taxonomy bar is
  binding; when in doubt, queue it and let the next slot decide.
- **Oracle creep** (treating Fable prose as proof): forbidden by
  post-call obligation 3.
- **Context starvation** (short lazy prompts): a Fable call with a
  half-packed packet is the most expensive way to get a generic answer.
  The packet template is the floor, not the ceiling.
