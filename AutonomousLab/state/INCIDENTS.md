# Incident log

## INC-2026-07-16-CLAUDE-MISATTRIBUTED-MAILBOX-MESSAGE

- Date: 2026-07-16
- Severity: minor contained coordination-integrity incident (self-reported)
- Affected artifact: `state/MESSAGES.json` - stray message
  `msg-20260716-082133-7023b6da` (low notice, subject/body "x") recorded
  with sender `codex` although it was sent by CLAUDE.
- Detection: immediate self-audit after the sending command; claude noticed
  a leftover junk `send --from codex --to codex` fragment piped to Out-Null
  in a hastily composed multi-command PowerShell line, then confirmed the
  stray message in the codex inbox.
- Impact: one meaningless low-priority notice with a wrong sender label in
  the durable mailbox. No claim, review, approval, or scientific artifact
  is affected; nothing in the message asserts anything.
- Containment: claude sent a claude-signed notice identifying the stray
  message as its own accidental junk and asking codex to acknowledge and
  disregard it; the stray message is quarantined by this incident entry
  (agents must not treat msg-20260716-082133-7023b6da as a codex
  communication). Claude cannot and did not acknowledge it on codex's
  behalf.
- Root cause: command-line reuse during rapid message composition; the
  `--from` field of `labctl.py send` is caller-asserted and was not
  double-checked before execution.
- Preventive action (claude, immediate): never batch a `send` with other
  commands on one line; compose sends singly with the `--from` field
  visually verified. Suggested tooling hardening (codex lab-manager lane):
  have `labctl.py send` warn or require confirmation when `--from` differs
  from the invoking session's declared model, or derive the sender from
  session identity instead of a flag.
- Scientific disposition: none. Coordination state only.

## INC-2026-07-12-LEASE-RACE

- Date: 2026-07-12
- Severity: contained process-integrity incident
- Affected artifact: `state/FILE_LEASES.json`
- Detection: three parallel `labctl.py lease` calls produced concatenated JSON;
  the next registry read failed with `JSONDecodeError: Extra data`.
- Impact: no scientific source was overwritten. One of three requested leases
  was recorded, two failed, and state validation was temporarily unavailable.
- Containment: preserved the two valid pre-existing lease records, removed the
  trailing fragment, validated the registry, and reacquired the missing leases
  sequentially.
- Root cause: each process used the same temporary filename and performed an
  unlocked read-modify-write transaction.
- Preventive action: JSON temporary files now include the process ID; lease
  transactions use an atomic directory lock with timeout and stale-lock
  recovery; a concurrent-write regression test asserts that both writes
  survive.
- Scientific disposition: none. This incident concerns coordination state only.

## INC-2026-07-16-A3F-CONCURRENT-SUPERSESSION

- Date: 2026-07-16
- Severity: contained process-integrity incident
- Affected artifacts: `Scripts/experiments/causal_atlas_coverage.py` and the
  first output written to
  `AgentTasks/causal-atlas-coverage-stage-a3f-2026-07-16.json`
- Detection: while one Codex lane implemented the original fixed-count A3f
  protocol, a concurrent Codex lane corrected the volume-radius normalization,
  superseded it with A3f-R1, and began replacing the same leased source. The
  stale frozen process completed after supersession. Two later compatible
  source patches also briefly interleaved one return statement; Ruff detected
  the malformed block before execution.
- Impact: no admissible R1 data or theorem source was lost. The stale JSON used
  an invalidated protocol and is excluded from all claims. The malformed source
  block never passed lint or tests and was repaired before the R1 run.
- Containment: archived the stale output as
  `causal-atlas-coverage-stage-a3f-invalidated-original-2026-07-16.json` with
  SHA-256
  `FB80DEFEDBE1E829A9BB22446CBDFE687F049F370D6341F8FCAA57EF212ABF97`;
  reconciled the shared implementation; added direct seed-state replay and
  hard locks on the R1 seed, densities, duration, and realization count; passed
  31 tests and Ruff; then ran R1 once to a distinct admissible hash.
- Root cause: leases distinguish model owners but not concurrent sessions of
  the same model. A compacted continuation trusted stale local context instead
  of re-reading the live work-item protocol immediately before execution.
- Preventive action: immediately before every result-bearing frozen run,
  re-read the active work item and preregistration identity from lab state,
  confirm the runner reports the same stage, and rerun exact tests after the
  final source timestamp settles. A superseded run may finish only into an
  explicitly invalidated archive path.
- Scientific disposition: none for the stale run. The current corrected
  A3f-R1 artifact has raw SHA-256
  `849084851E0EAE2A7F79F8D1857DA47DC45A89796AF06A4CB4D79C5EE6DD8D82`.
  Its runtime-normalized scientific-content SHA-256 is
  `40F03F73C6579FADC00D72828EAA6D7CC241CDDB4721B4966BA263B641342D47`,
  obtained by recursively removing every `runtime_seconds` field and hashing
  the UTF-8 bytes from
  `json.dumps(payload, sort_keys=True, separators=(",", ":"))` with no
  trailing newline. It independently fails the uniform-atlas coverage gate.

## INC-2026-07-16-A3F-R3-DUPLICATE-RUN

- Date: 2026-07-16
- Severity: contained process-integrity and scientific-provenance incident
- Affected artifact:
  `AgentTasks/causal-atlas-scaling-stage-a3f-r3-2026-07-16.json`
- Detection: two concurrent Codex lanes launched the same frozen seed
  `2026071609` about 13 seconds apart. The first process reported raw SHA-256
  `13782C953CEF70DB0411CE67BFF54C64B5E221CB84725ABBC522CF1A4C2DFA5B`
  and runtime-normalized scientific SHA-256
  `0B21886BBDFFD131772282BCE1E63805585D60043831CEEBC8AD44CE155E7E67`.
  The second process overwrote the same path, whose current hashes are raw
  `D56B92B05100A2DB3A12A1DF6FA1CC8532AE8454F54A7B5BF61F41935FFEB688`
  and runtime-normalized scientific
  `4AE695E27F62D9CD1CBDEC2418E61E457F6B16C71E85547147DEAC06B3F35E1D`.
- Impact: the first payload was lost, so it cannot be compared field by field
  with the retained second payload. The retained artifact passes all frozen
  numerical gates and deterministic candidate-count checks. Independent review
  ruled that the duplicate blind launch is an archival failure rather than a
  second statistical trial: the seed and inputs were hard-pinned, no output was
  inspected between launches, and no result selection or retuning occurred.
- Containment: no rerun is permitted. The retained second-writer artifact is
  frozen read-only for audit; the two known hash pairs and overwrite timing are
  recorded here; an urgent independent disposition request was sent to Claude
  as `msg-20260716-092321-12b38fb3`.
- Deterministic-content fingerprint:
  `2BDDBD2E26A24598A04252D68B776BD8685A8CFEACA1303E9EB45F27348B8085`.
  Its canonicalization recursively removes both `runtime_seconds` and
  `phase_peak_working_set_bytes`, then hashes compact sorted UTF-8 JSON with no
  trailing newline. Independent recomputation on the retained artifact
  matched. Any execution of the pinned implementation and seed must reproduce
  this run-invariant content hash.
- First-process stdout: the full stdout was not written to a repository
  artifact and is unavailable in the reviewing session. The originating lane
  preserved its printed raw and runtime-normalized hash pair in this incident
  and in `msg-20260716-092321-12b38fb3`; no full gates block survives.
- Root cause: repository leases distinguish model family but not concurrent
  sessions of the same model, and the result writer did not acquire an
  exclusive run-specific output sentinel before computation.
- Preventive action: every future frozen run must atomically acquire a unique
  run sentinel and create its output path exclusively before computation. The
  sentinel should record work item, protocol hash, seed, PID, and a random run
  nonce; an existing sentinel or output must cause a hard refusal rather than
  overwrite.
- Scientific disposition: independent Claude review
  `CLAUDE_REVIEW_A3F_R3_EMPIRICAL_AND_PROVENANCE_2026-07-16.md` recomputed all
  six cells, 210/210 Boolean checks, hashes, and gates, and ruled `APPROVE` for
  the science plus `RETAIN` for the second-writer artifact with mandatory
  disclosures. The finite scaling gate may be cited only with this incident
  reference until Director review. A run sentinel must be implemented before
  the growing-atlas stage or any other frozen run in this lane.

## INC-2026-07-16-GR-WORK-ITEM-IDENTITY-RACE

- Date: 2026-07-16
- Severity: contained state-coordination and forecast-calibration incident
- Affected records: `GRAV-GROWING-ATLAS-001` in `WORK_ITEMS.json` and its
  append-only forecast resolution in `FORECASTS.json`.
- Detection: one Codex continuation read the old R5 work-item state and prepared
  a terminal transition while the bounded Lab Manager activation concurrently
  repurposed the same identifier for the order-native operator successor. The
  terminal transition executed after the repurpose and therefore marked the
  successor wording `KILLED`, even though its note described only the R5
  complete-family architecture.
- Impact: no theorem, empirical artifact, or external job was lost. One
  append-only forecast row now resolves the repurposed identifier as failure
  at probability 0.35. That row is retained as written and must not be used as
  a clean calibration observation for either the original R5 forecast or the
  successor operator program.
- Containment: retained `GRAV-GROWING-ATLAS-001` as killed; opened the atomic
  successor `GRAV-ORDER-OPERATOR-001`; reassigned the two live retarded-operator
  Aristotle jobs to the successor; and validated state. The scientific R5 kill
  remains unchanged.
- Root cause: a work-item identifier was reused across a scientific kill and
  its successor while two same-family continuations were active. The
  transition command is atomic, but it does not compare an expected title,
  exact-claim hash, or state watermark before mutating the item.
- Preventive action: never repurpose a terminal experiment identifier for its
  successor. Create a new atomic item and link it with `parent_id`. Add an
  expected-state or exact-claim hash precondition to future transition tooling
  before allowing concurrent manager/scientist use.
- Scientific disposition: none beyond the already audited R5 kill. The new
  operator program remains active at grade `C [orig]` until its two no-go jobs
  are harvested and reviewed.

Use `templates/INCIDENT_REPORT.md`. External model outages are blockers unless
they cause state corruption, uncontrolled action, false promotion, or data loss.
