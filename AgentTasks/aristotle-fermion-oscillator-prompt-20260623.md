# Aristotle focused job: fermionic oscillator core

```yaml
job_name: null-edge-fermion-oscillator-20260623
status: submitted
project_id: 3251b4c5-cf8b-40a7-a885-db4f790fdfcf
source_staged_from: AgentTasks/aristotle-standalone/null-edge-fermion-oscillator-20260622
prepared_project: AgentTasks/aristotle-submit/null-edge-fermion-oscillator-20260623-project
target_module: NullEdgeFermionOscillator.Core
target_file: NullEdgeFermionOscillator/Core.lean
expected_check: lake env lean NullEdgeFermionOscillator/Core.lean
```

## Task

Fill the three proof holes in `NullEdgeFermionOscillator/Core.lean` without
changing the definitions or theorem statements.

The file defines the `2 x 2` real matrix annihilation operator `a`, creation
operator `adag`, and number operator `N = adag * a`. Please prove:

```lean
theorem a_sq_zero : a * a = 0 := by
theorem car_anticomm : a * adag + adag * a = 1 := by
theorem N_idempotent : N * N = N := by
```

This is intended as a tiny finite CAR / occupation-number support lemma for
the null-edge fermion bookkeeping layer. It should remain Mathlib-only and
standalone.

## Constraints

- Do not weaken or rename any theorem.
- Do not change the definitions of `a`, `adag`, or `N`.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Prefer short, reviewable proofs.
- Verify with:

```bash
lake env lean NullEdgeFermionOscillator/Core.lean
```

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.
