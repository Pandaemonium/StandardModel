# Codex request: disposition of the local A3f-R2 Lean gate

## Decision requested

Return one of:

- `RUN-CLEARED`: the local kernel closure discharges exact gate 1 and Aristotle
  project `393284aa-586d-4bcd-ad15-f03d63a1131f` may remain an independent
  replay to harvest after the once-only benchmark;
- `WAIT-ARISTOTLE`: the held-out seed must remain closed until that specific
  external project returns and is audited; or
- `REVISE`: identify exact statement or proof concerns.

Do not execute seed `2026071608` during this review.

## Evidence

- Frozen submitted statements:
  `AgentTasks/aristotle-submit/greedy-coverage-20260716-project/GreedyCoverage/GreedyCoverage.lean`
- Locally closed, statement-identical source:
  `AgentTasks/aristotle-standalone/greedy-coverage-20260716/GreedyCoverage/GreedyCoverage.lean`
- Correct total-residual capstone:
  `AgentTasks/aristotle-standalone/greedy-total-residual-20260716/GreedyTotalResidual/GreedyTotalResidual.lean`
- Task record:
  `AgentTasks/greedy-coverage-aristotle-2026-07-16.md`

## Checks already passed

1. `lake env lean` passes on both standalone modules.
2. The only submitted-to-live changes are the three proof bodies; public
   theorem and definition signatures are unchanged.
3. No placeholder or trust-expanding construct remains in the locally closed
   `GreedyCoverage.lean`.
4. Lean MCP reports `[propext, Classical.choice, Quot.sound]` and no source
   warning for:
   - `exists_marginal_card_mul_ge_uncovered`;
   - `greedy_marginal_card_mul_ge_uncovered`;
   - `residual_contract`;
   - `geometric_residual_bound`; and
   - `marginalGain_map`.
5. The first proof chooses a maximum finite marginal and applies the union-card
   upper bound. The second composes that witness with the stated maximum. The
   third is ordered rational arithmetic. The separate capstone uses total
   covered cardinality and therefore avoids the rejected benchmark-intersection
   deficit.

## Boundary

Even `RUN-CLEARED` opens only the frozen finite A3f-R2 packing benchmark. It
does not open source rows, operators, G2, tetrads, curvature, or dynamics. The
Aristotle project remains mandatory to harvest and audit when it returns.
