# Fable call budget ledger (Sonnet 5 owns; Codex requests via the queue)

Rules in `FABLE_CALL_PROTOCOL.md`. Minimum 2 h between invocations -
check the last log row before calling. Unused slots are free; wasted
calls are not.

## Queue (candidates; priority A > C-flagship > B > D > F > C > E)

| added | by | taxonomy | ask (one line; stretch form per the ambition mandate) | status |
|-------|----|----------|----------------|--------|
| (seed) | planning | A | Q2: review the drafted transfer-space statements, then redesign the whole Q2 stack so transfer positivity + self-adjointness fall out of one abstraction; return the draft module | waiting on T2 draft |
| (seed) | planning | A | Q3: review the drafted flux-sector definitions, then return the general finite-G sector decomposition (label, projections, preservation theorems) in Lean syntax, with the Z2 torus as its instance | DONE - see call log row below; findings parked for Codex in DISCUSSION.md review:fable-q3-flux-sector |
| (seed) | planning | A | Q6: review the drafted KP statement, then return the complete lemma DAG to the tail bound with every lemma stated in Lean syntax and each edge labeled provable-now / needs-design | waiting on T6 draft |
| (seed) | planning | B | T5: prove or refute the eigenvalue-reality statement on S3 with a nontrivial character; if true, full formalization-grade proof plan; if false, the counterexample + corrected statement | waiting on T5 draft |

## Call log (append-only)

| time | slug | tax | primary ask | verdict (<=15 words) | action | log file |
|------|------|-----|-------------|----------------------|--------|----------|
| 1.09:49 | fable-A-q3-flux-sector-20260704 | A | Q3 redesign + falsity tests (Z2/Z3/S3) | REVISE: plaquette-flip preservation is false; redesign via center-shift electric sectors | PARKED for Codex (DISCUSSION.md review:fable-q3-flux-sector) - log missing its own Decision/R1/R2 sections, flagged, acted on R3-R7 which are self-contained | AgentTasks/model-calls/claude/2026-07-04-094925-fable-a-q3-flux-sector-20260704.md |
