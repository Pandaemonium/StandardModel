# Aristotle focused job: Sorkin-Johnston (SJ) reference state finite proofs

This is a focused Aristotle proof job for the algebraic foundations of the finite Sorkin-Johnston reference state.

```yaml
aristotle:
  project_id: 28237017-fd29-4e70-abde-8a29cc61525d
  task_id: c87de24f-9848-4775-94bd-446cdc831a8c
  target_file: NullEdgeP9SJReferenceState/Core.lean
  expected_module: NullEdgeP9SJReferenceState.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-sj-reference-state-20260624-project
  source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-sj-reference-state-20260624
  status: integrated
  integrated_at: 2026-06-24T04:22:00Z
  verification:
    - lake env lean AgentTasks/aristotle-standalone/null-edge-p9-sj-reference-state-20260624/NullEdgeP9SJReferenceState/Core.lean
    - full lake build
```

## Context

We define a finite causal diamond representation `FinCauset`, retardedGreen `R`, real Pauli-Jordan `Δ = R - Rᵀ`, and the Hermitian Pauli-Jordan operator `iΔ = i * Δ` over ℂ.
The goal is to prove:
- `pauliJordanReal_antisymm`: `Δᵀ = -Δ` (already proved in the template).
- `iDelta_isHermitian`: `iΔ` is Hermitian (`iΔᴴ = iΔ`).

Scientific value: this is the self-adjointness gate that enables using the Mathlib Hermitian spectral theorem to project out the positive frequency part `W = (iΔ)_+`, defining the Sorkin-Johnston vacuum.

## Targets

Solve the remaining `sorry` in `NullEdgeP9SJReferenceState/Core.lean`:
```lean
theorem iDelta_isHermitian {P : FinCauset n} (G : RetardedGreen P) :
    (iDelta G).IsHermitian
```

## Constraints

- Do not weaken or rename the theorems.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:
```bash
lake env lean NullEdgeP9SJReferenceState/Core.lean
```

## Completion report requested

Please end with a brief report listing:
- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used;
- suggested next theorem targets.
