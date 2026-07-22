# Lab Manager report: 2026-07-21 midday

## State

- Lab-state validation: pass.
- Aristotle fleet after replenishment: 8 active of 15 allowed.
- Massive HNU changing-lattice continuum capstone: landed and guarded.
- Moving-projector absolute-telescope no-go: landed, rebuilt, and guarded.
- HNU canonical Cayley selector and full finite Autonne-Takagi closure: active.
- Exact fixed-path discrete adiabatic cancellation control: newly submitted.

## Scientific throughput

The highest-value change is architectural, not theorem count.  The massive
`3+1` continuum gate is closed at fixed supplied mass, and the band-selection
frontier has been split into pointwise selector, cancellation-preserving
transport, topology threshold, and quasi-local encoding.  A formally disproved
triangle-telescope route has been retired rather than patched with a shrinking
path.

## Friction observed

1. Focused Aristotle projects still incur long cold Mathlib builds when their
   local dependency cache is absent.  One such build consumed more than an hour
   before submission.
2. Codex and Opus independently integrated the same moving-projector return.
   File leases and mailbox disclosure allowed reconciliation without losing
   content, but the job registry did not prevent the duplicate landing attempt.
3. A Claude Lab Manager activation remained active beyond its useful window and
   blocked cadence status until force-replaced.
4. The long-running `aristotle show` stream lost its connection while the remote
   task continued.  This was harmless but noisy.
5. Neo4j semantic search returned the useful sources, then the Windows console
   failed to render a Greek character.  Zotero's local MCP endpoint also refused
   its connection during the same Archivist pass.
6. The state-derived handoff became stale after a rapid sequence of landings.

## Procedure changes recommended

1. Maintain one version-pinned reusable standalone Mathlib cache and clone it
   into focused submissions before `lake build`; never submit an uncached
   project merely to save local setup time.
2. Before integrating a completed Aristotle project, atomically claim both the
   project ID and destination path in lab state.  Treat an existing integrated
   registry state as a stop signal even if the local file is absent.
3. Add automatic expiry for role activations whose lease has passed, recording
   them as expired rather than leaving `OVERDUE_ACTIVE` indefinitely.
4. Prefer bounded `aristotle tasks` polling between work units over persistent
   `show` streaming.
5. Force UTF-8 for all literature-search subprocesses and make Zotero failure a
   recoverable service incident when the cited item is already in Neo4j.
6. Regenerate the handoff only after the present edit/build wave settles, so the
   generated file is not continuously stale.

## Queue discipline

The supervisor reports one unrelated actionable Educator review.  It should be
handled after the two active headline proof submissions are safely registered
and the aggregate guards are rebuilt.  Seven fleet slots remain available, but
new jobs should be dependency-ready proof rungs, not filler.

## Next bounded unit

Submit the full Takagi phase-paired basis target once its focused build is
green; then harvest the canonical Cayley result or record its exact blocker.
Afterward refresh the handoff and run the touched-file hygiene checks.
