# Decision records

## ADR-001: Persistent lab instead of serial autonomous runs

- Date: 2026-07-12
- Status: accepted by Research Director request
- Decision: Maintain AFPL state, portfolio, roles, cadence, and review gates
  under `AutonomousLab/`.
- Rationale: serial runs repeatedly reconstruct context, duplicate work, and
  optimize short horizons. Persistent memory and stage gates enable cumulative
  learning and procedure improvement.
- Consequence: future autonomous goals should enter through AFPL prompts and
  update shared state rather than create a new constitution by default.

## ADR-002: Cross-model independence

- Date: 2026-07-12
- Status: accepted provisionally
- Decision: role copies within one model do not satisfy independent review;
  headline promotion requires a different model or explicit human disposition.
- Rationale: personality prompts change attention but not underlying model
  correlation.
- Review: first monthly metascience review.
