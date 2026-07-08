# Aristotle task - P12 Koide / T-solder SUB-NAT gate

## Job

- Requested job name:
  `ne-hard-p12-koide-tsolder-p1-subnat-gate-strategy-20260707`
- Lane: Q07 / Koide / T-solder / kappa gate
- Type: probe/strategy/audit

```yaml
aristotle:
  project_id: 7f7c1ea6-a75d-429c-9ab9-3c447b5250c9
  task_id: 2559bd28-59ba-46b8-9a54-c4f0800c8612
  target_file: AgentTasks/twoday-carrier-run-2026-07-07/TSOLDER_KAPPA_ANALYSIS.md
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/ne-hard-p12-koide-tsolder-p1-subnat-gate-strategy-20260707-project
  output_dir: AgentTasks/aristotle-output/7f7c1ea6-a75d-429c-9ab9-3c447b5250c9
  status: submitted
```

## Context

`TSOLDER_KAPPA_ANALYSIS.md` records the current kappa/tetrahedral analysis.
Fable's handoff says to run probe P1 first, then analyze edge-subdivision
naturality (`SUB-NAT`) as the hypothesis-level explanation.

Pro's correction: define what subdivision invariance means before computing.
Distinguish:

- `SUB-NAT-STRICT`,
- `SUB-NAT-PROJECTIVE`,
- `SUB-NAT-RENORMALIZED`.

## Target

Produce an execution-ready strategy packet, and Lean targets if feasible, for:

1. probe P1 on the Z3 tetrahedral carrier-to-leg reduction,
2. the SUB-NAT comparison of bookkeeping B1 and B2,
3. the outcome table:
   - exactly one bookkeeping is natural,
   - both are natural,
   - neither is natural.

Pre-register the intended equality notion before any computation.  Use the
palindromic-transfer convention theorem for the corner convention; do not
choose a new convention.

## Desired output

- A crisp definition of the subdivision map and induced corner.
- A table of strict/projective/renormalized invariance targets.
- Exact theorem statements or oracle computations for the next Lean package.
- Claim boundary: this is a gate for mass-value hypotheses, not a mass-value
  prediction.

## Required patch layer

Use:

- `AgentTasks/twoday-carrier-run-2026-07-07/FABLE_HANDOFF_HARDEST_PIECES.md`,
- `AgentTasks/twoday-carrier-run-2026-07-07/ARISTOTLE_HARDEST_PIECES_PRO_PATCHES_2026-07-07.md`.
