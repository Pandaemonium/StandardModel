# Fable call budget ledger (Sonnet 5 owns; Codex requests via the queue)

Rules in `FABLE_CALL_PROTOCOL.md`. Minimum 2 h between invocations -
check the last log row before calling. Unused slots are free; wasted
calls are not.

## Queue (candidates; priority A > C-flagship > B > D > F > C > E)

| added | by | taxonomy | ask (one line; stretch form per the ambition mandate) | status |
|-------|----|----------|----------------|--------|
| (seed) | planning | A | Q2: review the drafted transfer-space statements, then redesign the whole Q2 stack so transfer positivity + self-adjointness fall out of one abstraction; return the draft module | waiting on T2 draft |
| (seed) | planning | A | Q3: review the drafted flux-sector definitions, then return the general finite-G sector decomposition (label, projections, preservation theorems) in Lean syntax, with the Z2 torus as its instance | ready - packet `AgentTasks/fable-prompts/fable-A-q3-flux-sector-20260704.md`, attach `FluxSectorZ2.lean` |
| (seed) | planning | A | Q6: review the drafted KP statement, then return the complete lemma DAG to the tail bound with every lemma stated in Lean syntax and each edge labeled provable-now / needs-design | waiting on T6 draft |
| (seed) | planning | B | T5: prove or refute the eigenvalue-reality statement on S3 with a nontrivial character; if true, full formalization-grade proof plan; if false, the counterexample + corrected statement | waiting on T5 draft |

## Call log (append-only)

| time | slug | tax | primary ask | verdict (<=15 words) | action | log file |
|------|------|-----|-------------|----------------------|--------|----------|
