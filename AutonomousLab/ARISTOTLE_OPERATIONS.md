# Aristotle in AFPL

Aristotle is the lab's proof specialist, not an oracle of physical meaning.
`docs/ARISTOTLE.md` remains the operational source of truth.

## Role adaptations

- Scientist: solve hard Lean targets and find reusable lemmas.
- Skeptic: search for counterexamples, hidden hypotheses, and false theorem
  shapes.
- Visionary: design theorem ladders and identify decisive formal bottlenecks.
- Superstar: seek stronger general statements and cleaner theorem packaging
  without weakening or inflation.
- Lab Manager: audit the proof queue, stalls, duplication, package size, and
  harvest quality.

## Fleet policy (throughput-first, 2026-07-12 Research Director redirect)

The default is **a full fleet, not a rationed one.** Aristotle is the primary
engine of progress; an idle slot is wasted throughput.

- **Keep the fleet full.** Target `aristotle_projects` (8) *active* whenever
  there are hard open targets -- and there almost always are. Treat 8 as a
  floor-to-fill, not a cap-to-fear. A near-idle fleet is a process failure to be
  fixed the same cycle, not a resting state.
- **No per-work-item Aristotle ration.** There is NO "one package per work item"
  limit and NO capacity-exception gating below the fleet cap. If a slot is open
  and a target is ready, fire it. The old per-item ceiling is withdrawn.
- **Both interactive families submit directly.** Codex and interactive Claude
  each submit Aristotle jobs without routing through the other; the single-writer
  rule governs JSON *state*, never proof-job submission. Record each job in
  `state/ARISTOTLE_JOBS.json` and the ledger immediately (append-only ledger is
  collision-safe; validate after a registry write).
- **Refill on every harvest.** The moment a job returns, submit the next queued
  target so the fleet never drops below capacity. Maintain a standing
  target queue (hard open gaps, successors, frontier lemmas) so there is always
  something to fire.
- **Harvest-claim protocol (both families, accepted 2026-07-12).** Completed/idle
  jobs are visible to both families via `aristotle list`, so before downloading
  or banking any completed/idle job, send a mailbox claim notice naming the job
  id (e.g. "claiming harvest of `<id>`"). An existing open claim reserves that
  harvest; if you see one, skip that job. This costs one message and prevents
  duplicate integration (observed twice on 2026-07-12: DPI and von Neumann were
  each independently banked before the protocol; the `read-first` file guard
  caught the second collision). Submitting new proof jobs still needs no claim —
  only harvesting a *completed* job does.
- **Package discipline unchanged:** focused Mathlib-only packages for isolated
  targets; full-repo packages only for genuine composition targets; context pack
  before nontrivial submission.
- **At least one audit/counterexample job per major positive theorem wave**
  (runs in parallel, never as a substitute for filling the fleet with proofs).
- Two-hour stall review with snapshot preservation before cancellation; every
  project/task ID recorded immediately.

Anti-pattern to avoid (observed 2026-07-12): declaring "genuinely blocked" or
"saturated" while the fleet is idle and hard targets are queued. Blocked means
"no ready target AND every slot full," not "I finished my current lane."

## Submission contract

Every proof job includes:

- exact typechecking statement;
- intended mathematical and physical reading;
- seed imports and convention locks;
- prohibited weakening;
- nonzero witness and negative/boundary control;
- expected axiom footprint;
- manuscript consequence and kill condition;
- narrow verification command.

## Landing contract

Aristotle completion is not landing. The integrating Scientist and Skeptic must
inspect the actual source, verify it locally, scan trust, compare the theorem to
the intended meaning, add guards, and update state/provenance.

## Strategy jobs

At least once per day of active research, submit a whole-portfolio strategy or
audit job containing the five-year goal, current portfolio, recent failures,
and exact question. Focused strategy jobs occur more often. Strategy output is
advice and receives a disposition record.
